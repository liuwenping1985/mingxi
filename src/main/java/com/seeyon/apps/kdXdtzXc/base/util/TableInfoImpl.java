package com.seeyon.apps.kdXdtzXc.base.util;

/**
 * Created by taoan on 2016-7-27.
 */
public class TableInfoImpl implements TableInfo {
    private int index;
    private String name;
    private String desc;
    private String classname;
    private Boolean breakCheck = false;

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public Boolean getBreakCheck() {
        return breakCheck;
    }

    public void setBreakCheck(Boolean breakCheck) {
        this.breakCheck = breakCheck;
    }
}
