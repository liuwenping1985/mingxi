package com.seeyon.apps.nbd.core.form.entity;

/**
 * Created by liuwenping on 2018/9/9.
 */
public class SimpleFormField {
    private String name;
    private String display;
    private Object value;
    private String className;

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

    public Object getValue() {
        return value;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public void setValue(Object value) {
        this.value = value;
    }
}
