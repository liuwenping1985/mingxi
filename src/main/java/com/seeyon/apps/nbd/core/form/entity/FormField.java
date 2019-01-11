package com.seeyon.apps.nbd.core.form.entity;

/**
 * 简化form的那一坨大便一样的逻辑
 * Created by liuwenping on 2018/9/7.
 */
public class FormField {

    private Long id;
    private String name;
    private String display;
    private String fieldtype;
    private String fieldlength;
    private String barcode;
    private boolean is_null;
    private boolean is_primary;
    private String classname;
    private String export;
    private Object value;

    public String getExport() {
        return export;
    }

    public void setExport(String export) {
        this.export = export;
    }

    private String jsonname;

    private String parser;

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getJsonname() {
        return jsonname;
    }

    public void setJsonname(String jsonname) {
        this.jsonname = jsonname;
    }

    public String getParser() {
        return parser;
    }

    public void setParser(String parser) {
        this.parser = parser;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDisplay() {
        return display;
    }

    public void setDisplay(String display) {
        this.display = display;
    }

    public String getFieldtype() {
        return fieldtype;
    }

    public void setFieldtype(String fieldtype) {
        this.fieldtype = fieldtype;
    }

    public String getFieldlength() {
        return fieldlength;
    }

    public void setFieldlength(String fieldlength) {
        this.fieldlength = fieldlength;
    }

    public boolean isIs_null() {
        return is_null;
    }

    public void setIs_null(boolean is_null) {
        this.is_null = is_null;
    }

    public boolean isIs_primary() {
        return is_primary;
    }

    public void setIs_primary(boolean is_primary) {
        this.is_primary = is_primary;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }
}
