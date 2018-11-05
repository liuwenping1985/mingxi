package com.seeyon.apps.nbd.core.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.vo.DataLink;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class MappingServiceManagerImpl implements MappingServiceManager {

    private DataBaseHandler handler = DataBaseHandler.getInstance();

    public FormTableDefinition parseFormTableMapping(Map data) {

        Map tableList = (Map) data.get("TableList");
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
            // System.out.println(table);
            FormTable ft = JSON.parseObject(jString, FormTable.class);
            Map fieldList = (Map) table.get("FieldList");
            if (!CommonUtils.isEmpty(fieldList)) {
                List<Map> fields = new ArrayList<Map>();
                //List<Map> fields = (List<Map>) fieldList.get("Field");
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

    public FormTableDefinition saveFormTableDefinition(CommonParameter p) {
        String affairType = p.$("affairType");
        String linkId = p.$("id");
        String sql = " select * from form_definition where id in (select  CONTENT_TEMPLATE_ID from ctp_content_all where id IN(select BODY from ctp_template where TEMPLETE_NUMBER='" + affairType + "'))";
        DataLink dl = ConfigService.getA8DefaultDataLink();
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
        if (!CommonUtils.isEmpty(items)) {
            String xml = String.valueOf(items.get(0).get("field_info"));
            String jsonString = null;
            try {
                jsonString = XmlUtils.xmlString2jsonString(xml);
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
            Map data = JSON.parseObject(jsonString, HashMap.class);
            FormTableDefinition ftd = parseFormTableMapping(data);
            if (ftd != null) {
                ftd.setAffairType(affairType);
                ftd.setModes(linkId);
                FormTable ft = ftd.getFormTable();
                if (ft != null) {
                    filledTable(ft, p);
                    String ddbKey = affairType + "_" + linkId;
                    handler.createNewDataBaseByNameIfNotExist(ddbKey);
                    handler.putData(ddbKey, affairType, ftd);

                }
                return ftd;
            }

        }

        return null;

    }

    private void filledTable(FormTable ft, CommonParameter p) {
        List<FormField> ffList = ft.getFormFieldList();
        if (!CommonUtils.isEmpty(ffList)) {
            for (FormField ff : ffList) {
                filledFormField(ff, p);
            }
            List<FormTable> slaveTables = ft.getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables)) {
                for (FormTable sft : slaveTables) {
                    List<FormField> sffList = sft.getFormFieldList();
                    if (!CommonUtils.isEmpty(sffList)) {
                        for (FormField ff : sffList) {
                            filledFormField(ff, p);
                        }
                    }
                }
            }
        }
    }

    private void filledFormField(FormField ff, CommonParameter cpa) {
        String key = ff.getName();
        String clsName = cpa.$(key + "_classname");
        String barCode = cpa.$(key + "_ws");
        String export = cpa.$(key + "_export");
        if (!CommonUtils.isEmpty(clsName)) {
            ff.setClassname(clsName);
        }
        if (!CommonUtils.isEmpty(barCode)) {
            ff.setBarcode(barCode);
        }
        if (!CommonUtils.isEmpty(export)) {
            ff.setExport(export);
        }


    }


    public FormTableDefinition deleteFormTableDefinition(CommonParameter p) {
        String affairType = p.$("affairType");
        String linkId = p.$("id");
        String dbKey = affairType+"_"+linkId;
        FormTableDefinition ftd = getFormTableDefinition(p);
        if(ftd!=null){
            handler.removeDataByKey(dbKey,affairType);
        }
        return ftd;
    }

    public FormTableDefinition getFormTableDefinition(CommonParameter p) {
        String affairType = p.$("affairType");
        String linkId = p.$("id");
        String dbKey = affairType+"_"+linkId;
        System.out.println("------------");
        System.out.println(dbKey);
        FormTableDefinition ftd = handler.getDataByKeyAndClassType(dbKey,affairType,FormTableDefinition.class);
        return ftd;
    }


    public FormTableDefinition updateFormTableDefinition(CommonParameter p) {
        String affairType = p.$("affairType");
        String linkId = p.$("id");
        String dbKey = affairType+"_"+linkId;
        FormTableDefinition ftd = handler.getDataByKeyAndClassType(dbKey,affairType,FormTableDefinition.class);
        if(ftd!=null){
            FormTable ft = ftd.getFormTable();
            if(ft!=null){
                filledTable(ft,p);
            }
            handler.putData(dbKey, affairType, ftd);
            return ftd;
        }
        return null;
    }
}
