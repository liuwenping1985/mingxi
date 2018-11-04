package com.seeyon.apps.nbd.core.form.entity;

import com.seeyon.apps.nbd.core.util.CommonUtils;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class FormTable {

    private Long id;
    private String name;
    private String display;
    private String tabletype;
    private String needquery;
    private String onwertable;
    private String onwerfield;
    private List<FormTable> slaveTableList = new ArrayList<FormTable>();
    private List<FormField> formFieldList = new ArrayList<FormField>();


    public String getNeedquery() {
        return needquery;
    }

    public void setNeedquery(String needquery) {
        this.needquery = needquery;
    }

    public Long getId() {
        return id;
    }

    public List<FormField> getFormFieldList() {
        return formFieldList;
    }

    public void setFormFieldList(List<FormField> formFieldList) {
        this.formFieldList = formFieldList;
    }

    public void addFieldList(FormField field) {
        if(CommonUtils.isEmpty(this.formFieldList)){
            this.formFieldList = new ArrayList<FormField>();
        }
        this.formFieldList.add(field);
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

    public String getTabletype() {
        return tabletype;
    }

    public void setTabletype(String tabletype) {
        this.tabletype = tabletype;
    }

    public String getOnwertable() {
        return onwertable;
    }

    public List<FormTable> getSlaveTableList() {
        return slaveTableList;
    }

    public void setSlaveTableList(List<FormTable> slaveTableList) {
        this.slaveTableList = slaveTableList;
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
}
