package com.seeyon.apps.nbd.core.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.table.entity.NormalTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.TableField;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.Ftd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 字段
 * Created by liuwenping on 2018/9/7.
 *
 * @author liuwenping
 */
public class MappingServiceManagerImpl implements MappingServiceManager {

    //private DataBaseHandler handler = DataBaseHandler.getInstance();

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

            FormTable ft = JSON.parseObject(jString, FormTable.class);
            Map fieldList = (Map) table.get("FieldList");
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

    private String getTableName(String tableName) {
        return tableName.toUpperCase();

    }
    private Ftd mergeFormTableDefinition(Ftd ftdHandler,CommonParameter p){
        String affairType = p.$("affairType");
        if (CommonUtils.isEmpty(affairType)) {
            // System.out.println("saveFormTableDefinition: affairType NOT PRESENTED");
            return null;
        }
        // String sql = " select * from form_definition where id = (select  CONTENT_TEMPLATE_ID from ctp_content_all where id =(select BODY from ctp_template where TEMPLETE_NUMBER='"+affairType+"'))";
        String sql = " select * from " + getTableName("FORM_DEFINITION") + " where ID = (select  CONTENT_TEMPLATE_ID from " + getTableName("CTP_CONTENT_ALL") + " where ID =(select BODY from " + getTableName("CTP_TEMPLATE") + " where TEMPLETE_NUMBER='" + affairType + "'))";
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
                FormTable ft = ftd.getFormTable();
                if (ft != null) {
                    filledTable(ft, p);
                    if(ftdHandler==null){
                         ftdHandler = new Ftd();
                        ftdHandler.setDefaultValueIfNull();
                    }
                    ftdHandler.setName(affairType);
                    ftdHandler.setData(JSON.toJSONString(ftd));
                    ftdHandler.saveOrUpdate(dl);
                    //DataBaseHelper.persistCommonVo(dl,ftdHandler);
                    return ftdHandler;
                }
                return null;
            }

        }

        return null;

    }
    public Ftd saveFormTableDefinition(CommonParameter p) {

        return mergeFormTableDefinition(null,p);
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
        } else {
            ff.setClassname("");
        }
        if (!CommonUtils.isEmpty(barCode)) {
            ff.setBarcode(barCode);
        } else {
            ff.setBarcode("");
        }
        if (!CommonUtils.isEmpty(export)) {
            ff.setExport(export);
        } else {
            ff.setExport("");
        }


    }
    private void filledTableField(TableField ff, CommonParameter cpa) {
        String key = ff.getName();
        String clsName = cpa.$(key + "_classname");


        if (!CommonUtils.isEmpty(clsName)) {
            ff.setClassname(clsName);
        } else {
            ff.setClassname("");
        }
        String mapping = cpa.$(key + "_mapping");
        if (!CommonUtils.isEmpty(mapping)&&!"NONE_NONE".equals(mapping)) {
            ff.setMapping(mapping);
        } else {
            ff.setMapping("");
        }
        String export = cpa.$(key + "_export");
        if (!CommonUtils.isEmpty(export)) {
            ff.setExport(export);
        } else {
            ff.setExport("0");
        }


    }


    public Ftd deleteFormTableDefinition(CommonParameter p) {

        Object ftdId = p.$("id");
        if (ftdId==null||CommonUtils.isEmpty(""+ftdId)) {
            System.out.println("deleteFormTableDefinition: ID NOT PRESENTED");
            return null;
        }

        Long fid = Long.parseLong(""+ftdId);
        if(fid.equals(-1)){
            return null;
        }
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, fid);
        if(ftd==null){
            return null;
        }
        ftd.delete(dl);
        return ftd;

    }

    public Ftd getFormTableDefinition(CommonParameter p) {
        String ftdId = p.$("id");
        if (CommonUtils.isEmpty(ftdId)) {
            System.out.println("updateFormTableDefinition: ID NOT PRESENTED");
            return null;
        }
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, Long.parseLong(ftdId));
        return ftd;
    }


    public Ftd updateFormTableDefinition(CommonParameter p) {
        //String affairType = p.$("affairType");
        String id = String.valueOf(p.$("id"));
        if (CommonUtils.isEmpty(id)) {
            System.out.println("updateFormTableDefinition: ID NOT PRESENTED");
            return null;
        }
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Ftd ftdHolder = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, Long.parseLong(id));
        if(ftdHolder==null){
            return null;
        }
        return mergeFormTableDefinition(ftdHolder,p);
    }

    public Ftd saveNormalTableDefinition(CommonParameter p) {
        String table = p.$("extString4");
        if(CommonUtils.isEmpty(table)){
            return null;
        }
        DataLink dl = ConfigService.getA8DefaultDataLink();
        //List<Map> dataMapList = DataBaseHelper.queryColumnsByTableAndLink(dl,table);
        NormalTableDefinition ntd = genNormalTableDefinition(p,table);
        Ftd ftdHandler = new Ftd();
        ftdHandler.setDefaultValueIfNull();
        ftdHandler.setName(table);
        ftdHandler.setData(JSON.toJSONString(ntd));
        ftdHandler.saveOrUpdate(dl);
        return ftdHandler;
    }

    private NormalTableDefinition genNormalTableDefinition(CommonParameter p,String tableName){
        DataLink dl = ConfigService.getA8DefaultDataLink();
        List<Map> dataMapList = DataBaseHelper.queryColumnsByTableAndLink(dl,tableName);
        NormalTableDefinition ntd = new NormalTableDefinition();
        ntd.setTableName(tableName);
        List<TableField> tfList = new ArrayList<TableField>();
        for(Map map:dataMapList){
            TableField tf = new TableField();
            tf.setName(map.get("column_name")+"");
            tf.setType(map.get("type_name")+"");
            filledTableField(tf,p);
            tfList.add(tf);
        }
        ntd.setFieldList(tfList);
        return ntd;
    }

    public Ftd deleteNormalTableDefinition(CommonParameter p) {
        return deleteFormTableDefinition(p);
    }

    public Ftd getNormalTableDefinition(CommonParameter p) {
        return getFormTableDefinition(p);
    }

    public Ftd updateNormalTableDefinition(CommonParameter p) {
        String id = String.valueOf(p.$("id"));
        if (CommonUtils.isEmpty(id)) {
            System.out.println("updateNormalTableDefinition: ID NOT PRESENTED");
            return null;
        }
        String table = p.$("extString4");
        if(CommonUtils.isEmpty(table)){
            return null;
        }
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Ftd ftdHolder = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, Long.parseLong(id));
        NormalTableDefinition ntd = genNormalTableDefinition(p,table);
        ftdHolder.setData(JSON.toJSONString(ntd));
        ftdHolder.saveOrUpdate();
        return ftdHolder;
    }

    public static void main(String[] args) {
        System.out.println(11);
    }
}
