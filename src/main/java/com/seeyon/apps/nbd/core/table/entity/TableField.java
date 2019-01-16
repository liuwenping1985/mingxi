package com.seeyon.apps.nbd.core.table.entity;

/**
 * Created by liuwenping on 2019/1/16.
 */
public class TableField {
    private String name;
    private String type;
    private String length;
    private String classname;
    private String export;
    private Object value;
    private String mapping;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }

    public String getExport() {
        return export;
    }

    public void setExport(String export) {
        this.export = export;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public String getMapping() {
        return mapping;
    }

    public void setMapping(String mapping) {
        this.mapping = mapping;
    }
}
