package com.seeyon.apps.nbd.core.entity;

import java.util.List;

/**
 * Created by liuwenping on 2018/8/22.
 */
public class Entity {


    private String table;

    private List<OriginalField> originalFields;

    private List<FieldMeta> fields;

    private String refParentField;

    private String parse;

    public String getRefParentField() {
        return refParentField;
    }

    public void setRefParentField(String refParentField) {
        this.refParentField = refParentField;
    }

    public String getTable() {
        return table;
    }

    public void setTable(String table) {
        this.table = table;
    }

    public List<OriginalField> getOriginalFields() {
        return originalFields;
    }

    public void setOriginalFields(List<OriginalField> originalFields) {
        this.originalFields = originalFields;
    }

    public List<FieldMeta> getFields() {
        return fields;
    }

    public String getParse() {
        return parse;
    }

    public void setParse(String parse) {
        this.parse = parse;
    }

    public void setFields(List<FieldMeta> fields) {
        this.fields = fields;
    }
}
