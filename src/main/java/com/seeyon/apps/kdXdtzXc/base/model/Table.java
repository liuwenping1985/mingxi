package com.seeyon.apps.kdXdtzXc.base.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by taoanping on 15/1/30.
 * //    <Table id="1" name="formmain_1264" display="" tabletype="" onwertable="" onwerfield="">
 */
public class Table {
    private String tableId;

    private String className;
    private String formName;
    private String id;
    private String name;
    private String display;
    private String tabletype;
    private String onwertable;
    private String onwerfield;
    private List<Field> fieldList = new ArrayList<Field>();

    public Table(String id, String name, String display, String tabletype, String onwertable, String onwerfield) {
        this.id = id;
        this.name = name;
        this.display = display;
        this.tabletype = tabletype;
        this.onwertable = onwertable;
        this.onwerfield = onwerfield;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public void add(Field field) {
        if (fieldList == null) fieldList = new ArrayList<Field>();
        this.fieldList.add(field);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public String getTabletype() {
        return tabletype;
    }

    public void setTabletype(String tabletype) {
        this.tabletype = tabletype;
    }

    public String getOnwertable() {
        return onwertable;
    }

    public void setOnwertable(String onwertable) {
        this.onwertable = onwertable;
    }

    public String getOnwerfield() {
        return onwerfield;
    }

    public void setOnwerfield(String onwerfield) {
        this.onwerfield = onwerfield;
    }

    public List<Field> getFieldList() {
        return fieldList;
    }

    public void setFieldList(List<Field> fieldList) {
        this.fieldList = fieldList;
    }

    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }

    @Override
    public String toString() {
        return "Table{" +
                "className='" + className + '\'' +
                ", formName='" + formName + '\'' +
                ", id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", display='" + display + '\'' +
                ", tabletype='" + tabletype + '\'' +
                ", onwertable='" + onwertable + '\'' +
                ", onwerfield='" + onwerfield + '\'' +
                ", fieldList=" + fieldList +
                '}';
    }
}
