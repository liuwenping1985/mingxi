package com.seeyon.apps.duban.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.util.FileContentUtil;
import com.seeyon.apps.duban.util.XmlUtils;
import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTable;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.util.CommonUtils;
import org.apache.commons.lang.StringUtils;

import java.io.File;
import java.io.FilenameFilter;
import java.util.*;

/**
 * 表单和任务的映射
 * Created by liuwenping on 2019/11/7.
 */
public class MappingService {


    private static MappingService mappingService = new MappingService();
    private static FormTableDefinition MAIN_FTD = null;

    public static MappingService getInstance() {
        return mappingService;

    }

    private Map<String, FormTableDefinition> ftdMap = new HashMap<String, FormTableDefinition>();

    public void reloadMapping() {
        ftdMap.clear();

    }


    public FormTableDefinition getCachedMainFtd() {
        if (MAIN_FTD == null) {
            MAIN_FTD = getFormTableDefinitionDByCode("DB_TASK_MAIN");
        }
        return MAIN_FTD;


    }


    public FormTableDefinition getFormTableDefinitionDByCode(String code) {
        return getFormTableDefinitionDByCode(code, true);
    }

    public FormTableDefinition getFormTableDefinitionDByCode(String code, boolean fromCache) {
        FormTableDefinition ftd = null;
        if (fromCache) {
            ftd = ftdMap.get(code);
        }
        if (ftd == null) {
            String fileName = MappingCodeConstant.FILE_MAPPING.get(code);
            if (!StringUtils.isEmpty(fileName)) {

                File file = getMappingFile(fileName);
                try {
                    String fileContent = FileContentUtil.readFileContent(file);
                    if (StringUtils.isEmpty(fileContent)) {
                        throw new Exception("读取文件内容为空");
                    }
                    Map dataMap = JSON.parseObject(fileContent, HashMap.class);
                    ftd = parseFormTableMapping(dataMap);
                    if (ftd != null) {
                        ftdMap.put(code, ftd);
                        return ftd;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new RuntimeException("读取文件错误:" + code, e);
                }
            }
        } else {
            return ftd;
        }
        throw new RuntimeException("不支持的编码code:" + code);

    }

    private File getMappingFile(String fileName) {

        String path = MappingCodeConstant.class.getResource("").getPath();
        System.out.println(path + fileName);
        File f = new File(path + fileName);

        return f;
    }

    private List<File> getMappingFiles() {

        String path = MappingCodeConstant.class.getResource("").getPath();

        File f = new File(path);

        return Arrays.asList(f.listFiles(new FilenameFilter() {

            public boolean accept(File dir, String name) {

                if (name.toLowerCase().indexOf("json") > 0) {
                    return true;
                }
                return false;
            }
        }));

    }

    //以下均为测试是否好使

    public List<String> getMappingContents() {

        List<File> files = getMappingFiles();
        List<String> contentCodes = new ArrayList<String>();
        for (File file : files) {
            try {
                String fileContent = FileContentUtil.readFileContent(file);
                if (StringUtils.isEmpty(fileContent)) {
                    continue;
                }
                contentCodes.add(fileContent);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        return contentCodes;
    }

    public FormTableDefinition parseFormTableMapping(Map data) {

        Object object = data.get("TableList");
        if (object == null) {
            Object child = data.get("NODE");
            if (child != null && child instanceof Map) {
                object = ((Map) child).get("TableList");
            }
        }
        Map tableList = null;
        if (object instanceof List) {
            if (CommonUtils.isEmpty((List) object)) {
                return null;
            }
            tableList = (Map) ((List) object).get(0);
        } else {
            tableList = (Map) object;
        }


        if (CommonUtils.isEmpty(tableList)) {
            return null;
        }

        FormTableDefinition definition = JSON.parseObject(JSON.toJSONString(tableList), FormTableDefinition.class);
        List<Map> tables = new ArrayList<Map>();

        Object obj = tableList.get("Table");
        if (obj instanceof List) {
            tables = (List<Map>) obj;
        } else {
            if (obj instanceof Map) {
                tables.add((Map) obj);
            }
        }

        if (CommonUtils.isEmpty(tables)) {
            return null;
        }

        //Map<String,>
        //分别解析各个table，然后组装关联关系
        List<FormTable> slaveTableList = new ArrayList<FormTable>();
        for (Map table : tables) {
            String jString = JSON.toJSONString(table);

            FormTable ft = JSON.parseObject(jString, FormTable.class);
            Object fObject = table.get("FieldList");
            Map fieldList = null;
            if (fObject instanceof List) {
                List dataFieldList = (List) fObject;
                if (CommonUtils.isNotEmpty(dataFieldList)) {
                    fieldList = (Map) dataFieldList.get(0);
                }
            } else {
                fieldList = (Map) fObject;
            }
            // Map fieldList = (Map) table.get("FieldList");
            if (!CommonUtils.isEmpty(fieldList)) {
                List<Map> fields = new ArrayList<Map>();

                Object oj = fieldList.get("Field");
                if (oj instanceof List) {
                    fields.addAll((List) oj);
                } else {
                    if (oj instanceof Map) {
                        fields.add((Map) oj);
                    }
                }

                if (!CommonUtils.isEmpty(fields)) {
                    for (Map field : fields) {
                        String fdJson = JSON.toJSONString(field);
                        FormField ff = JSON.parseObject(fdJson, FormField.class);
                        ft.addFieldList(ff);
                    }
                }
            }
            if ("slave".equals(ft.getTabletype())) {
                slaveTableList.add(ft);
            } else {
                ft.setSlaveTableList(slaveTableList);
                definition.setFormTable(ft);
            }
        }
        return definition;
    }

    public static void main(String[] args) {
        MappingService service = new MappingService();

        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK_FEEDBACK_AUTO);

        System.out.println(ftd.getFormTable().getSlaveTableList().get(0).getName());

    }


}
