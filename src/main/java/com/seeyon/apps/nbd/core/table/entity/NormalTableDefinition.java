package com.seeyon.apps.nbd.core.table.entity;

import java.util.List;

/**
 * Created by liuwenping on 2019/1/16.
 */
public class NormalTableDefinition {

    private String tableName;

    private List<TableField> fieldList;

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public List<TableField> getFieldList() {
        return fieldList;
    }

    public void setFieldList(List<TableField> fieldList) {
        this.fieldList = fieldList;
    }
}
