package com.seeyon.apps.kdXdtzXc.base.model;

import java.io.Serializable;

/**
 * Created by taoanping on 15/1/30.
 * //    <Field id="0000" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>
 */
public class Field implements Serializable {
    private String id;
    private String name;
    private String display;
    private String fieldtype;
    private String fieldlength;
    private String is_null;
    private String is_primary;
    private String classname;

    public Field(String id, String name, String display, String fieldtype, String fieldlength, String is_null, String is_primary, String classname) {
        this.id = id;
        this.name = name;
        this.display = display;
        this.fieldtype = fieldtype;
        this.fieldlength = fieldlength;
        this.is_null = is_null;
        this.is_primary = is_primary;
        this.classname = classname;
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

    public String getIs_null() {
        return is_null;
    }

    public void setIs_null(String is_null) {
        this.is_null = is_null;
    }

    public String getIs_primary() {
        return is_primary;
    }

    public void setIs_primary(String is_primary) {
        this.is_primary = is_primary;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }
}
