package com.seeyon.apps.duban.vo.form;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.util.CommonUtils;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 简化form的映射和取数逻辑
 * Created by liuwenping on 2018/9/7.
 */
public class FormTableDefinition {
    private String name;
    private boolean is_push;
    private String code;
    private FormTable formTable;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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
