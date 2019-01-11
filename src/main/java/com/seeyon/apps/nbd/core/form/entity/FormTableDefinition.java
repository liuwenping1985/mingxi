package com.seeyon.apps.nbd.core.form.entity;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.service.TransferService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 简化form的那一坨大便一样的逻辑
 * Created by liuwenping on 2018/9/7.
 */
public class FormTableDefinition {
    private String affairType;
    private boolean is_push;
    private String modes;
    private FormTable formTable;


    public String getAffairType() {
        return affairType;
    }

    public void setAffairType(String affairType) {
        this.affairType = affairType;
    }

    public String getModes() {
        return modes;
    }

    public void setModes(String modes) {
        this.modes = modes;
    }

    public boolean isIs_push() {
        return is_push;
    }

    public void setIs_push(boolean is_push) {
        this.is_push = is_push;
    }

    public FormTable getFormTable() {
        return formTable;
    }

    public void setFormTable(FormTable formTable) {
        this.formTable = formTable;
    }

    public String genAllQuery() {

        // String table
        String tableName = this.getFormTable().getName();
        StringBuilder stb = new StringBuilder();
        stb.append("select * from ");
        stb.append(tableName);
        return stb.toString();
    }
    public String genQueryById(Object id) {

        // String table
        String tableName = this.getFormTable().getName();
        StringBuilder stb = new StringBuilder();
        stb.append("select * from ");
        stb.append(tableName);
        stb.append(" where id=");

        if(id instanceof Long||id instanceof Integer){
            stb.append(id);
        }else {
            stb.append("'").append(id).append("'");
        }
        return stb.toString();
    }
    public List<List<SimpleFormField>> filledValue(FormTable ft,List<Map> values) {
        TransferService tfs = TransferService.getInstance();
        List<FormField> formFields = ft.getFormFieldList();
        List<List<SimpleFormField>> dataList = new ArrayList<List<SimpleFormField>>();
        if (CommonUtils.isEmpty(formFields)) {
            return dataList;
        }
        if (CommonUtils.isEmpty(values)) {
            return dataList;
        }
        for (Map objs : values) {
            if (CommonUtils.isEmpty(objs)) {
                continue;
            }
            List<SimpleFormField> sffList = new ArrayList<SimpleFormField>();
            for(FormField ff:formFields){
                SimpleFormField sff= new SimpleFormField();
                sff.setDisplay(ff.getDisplay());
                sff.setName(ff.getName());
                sff.setValue(tfs.transForm2Other(ff,objs.get(ff.getName())));
                sffList.add(sff);
            }

            dataList.add(sffList);
        }
        return dataList;

    }
    public List<Map> filled2ValueMap(FormTable ft,List<Map> values,boolean usingDisplay) {
        TransferService tfs = TransferService.getInstance();
        List<FormField> formFields = ft.getFormFieldList();
        System.out.println("formFields:"+ JSON.toJSONString(formFields));
        System.out.println("values:"+ JSON.toJSONString(values));

        List<Map> dataList = new ArrayList<Map>();
        if (CommonUtils.isEmpty(formFields)) {
            return dataList;
        }
        if (CommonUtils.isEmpty(values)) {
            return dataList;
        }
        for (Map objs : values) {
            if (CommonUtils.isEmpty(objs)) {
                continue;
            }
            Map data = new HashMap();
            for(FormField ff:formFields){
                if(!"1".equals(ff.getExport())){
                    continue;
                }
                String fExportName = ff.getBarcode();
                if(CommonUtils.isEmpty(fExportName)){
                    if(!usingDisplay){
                        fExportName = ff.getName();
                    }else{
                        fExportName = ff.getDisplay();
                    }

                }
                data.put(fExportName,tfs.transForm2Other(ff,objs.get(ff.getName())));
            }

            dataList.add(data);
        }
        return dataList;

    }
    public List<List<SimpleFormField>> filledValue(List<Map> values) {

        return filledValue(this.getFormTable(),values);
    }


    public String genSelectSQLById(FormTable ft,Object recordId) {
        String tableName = ft.getName();
        StringBuilder stb = new StringBuilder();
        stb.append("select * from ");
        stb.append(tableName);
        stb.append(" where id=");

        if(recordId instanceof Long){
            stb.append(recordId);
        }else {
            stb.append("'").append(recordId).append("'");
        }
        return stb.toString();

    }
    public String genSelectSQLByProp(FormTable ft,String prop,Object recordId) {
        String tableName = ft.getName();
        StringBuilder stb = new StringBuilder();
        stb.append("select * from ");
        stb.append(tableName);
        stb.append(" where "+prop+"=");

        if(recordId instanceof Long){
            stb.append(recordId);
        }else {
            stb.append("'").append(recordId).append("'");
        }
        return stb.toString();

    }
}
