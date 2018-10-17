package com.seeyon.apps.nbd.core.form.entity;

import com.seeyon.apps.nbd.core.util.CommonUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
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

    public List<List<SimpleFormField>> filledValue(List<Map> values) {
        List<FormField> formFields = this.getFormTable().getFormFieldList();
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
                sff.setValue(objs.get(ff.getName()));
                sffList.add(sff);
            }

            dataList.add(sffList);
        }
        return dataList;

    }

    public String genInsertSQL() {


        return null;

    }
}
