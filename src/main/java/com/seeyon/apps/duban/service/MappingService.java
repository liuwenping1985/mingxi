package com.seeyon.apps.duban.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.mapping.MappingHook;
import com.seeyon.apps.duban.util.FileContentUtil;
import com.seeyon.apps.duban.util.XmlUtils;
import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTable;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.util.CommonUtils;
import org.apache.commons.lang.StringUtils;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.*;

/**
 * 表单和任务的映射
 * Created by liuwenping on 2019/11/7.
 */
public class MappingService {

    public void readMapping(){


    }


    private List<File> getMappingFiles(){

       String path =  MappingHook.class.getResource("").getPath();

       File f  = new File(path);

       return Arrays.asList(f.listFiles(new FilenameFilter(){

           public boolean accept(File dir, String name) {

               if(name.toLowerCase().indexOf("xml")>0){
                   return true;
               }
               return false;
           }
       }));

    }


    public List<String> getMappingContents(){

        List<File> files = getMappingFiles();
        List<String> contentCodes = new ArrayList<String>();
        for(File file:files){
            try {
                String fileContent =  FileContentUtil.readFileContent(file);
                if(StringUtils.isEmpty(fileContent)){
                    continue;
                }
                contentCodes.add(fileContent);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        return contentCodes;
    }
    private  FormTableDefinition parseFormTableMapping(Map data) {

        Object object = data.get("TableList");
        Map tableList = null;
        if(object instanceof List){
            if (CommonUtils.isEmpty((List)object)) {
                return null;
            }
            tableList = (Map)((List) object).get(0);
        }else{
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
            if(fObject instanceof List){
                List dataFieldList = (List)fObject;
                if(CommonUtils.isNotEmpty(dataFieldList)){
                    fieldList = (Map)dataFieldList.get(0);
                }
            }else{
                fieldList = (Map)fObject;
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
    public static void main(String[] args){
        MappingService service = new MappingService();

        List<String> list = service.getMappingContents();
        for(String c:list){
            try {
                String jsonString = XmlUtils.xmlString2jsonString(c);
                Map dataMap = JSON.parseObject(jsonString,HashMap.class);
                FormTableDefinition ftd = service.parseFormTableMapping(dataMap);
                System.out.println(ftd.getName());
                System.out.println(ftd.getCode());
                System.out.println(ftd.getFormTable().getName());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }





}
