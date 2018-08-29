package com.seeyon.apps.nbd.core.entity;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class FieldMeta {


    private boolean isId;

    private String name;

    private String type;

    private String desc;

    private String source;


    public boolean isId() {
        return isId;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public void setId(boolean id) {
        isId = id;
    }

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

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
