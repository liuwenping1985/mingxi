package com.seeyon.apps.nbd.vo;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;

/**
 * Created by liuwenping on 2018/11/4.
 */
public class A82Other extends CommonVo{

    private String id;

    private String name;

    private String data;
    //模板编号
    private String affairType;
    //process_start,process_end
    private String triggerType;
    //mid_table
    private String exportType;

    private String linkId;

    private FormTableDefinition ftd;

    public String getLinkId() {
        return linkId;
    }

    public void setLinkId(String linkId) {
        this.linkId = linkId;
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

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getAffairType() {
        return affairType;
    }

    public void setAffairType(String affairType) {
        this.affairType = affairType;
    }

    public String getTriggerType() {
        return triggerType;
    }

    public void setTriggerType(String triggerType) {
        this.triggerType = triggerType;
    }

    public String getExportType() {
        return exportType;
    }

    public void setExportType(String exportType) {
        this.exportType = exportType;
    }

    public FormTableDefinition getFtd() {
        return ftd;
    }

    public void setFtd(FormTableDefinition ftd) {
        this.ftd = ftd;
    }


}
