package com.seeyon.apps.nbd.po;

import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.NormalTableDefinition;

/**
 * Created by liuwenping on 2018/11/4.
 */

public class A8ToOtherConfigEntity extends CommonPo {
    //模板编号
    private String affairType;

    //process_start,process_end
    private String triggerType;
    //mid_table,http
    private String exportType;

    private String exportUrl;

    private Long linkId;

    private Long ftdId;

    private FormTableDefinition formTableDefinition;

    private NormalTableDefinition normalTableDefinition;

    public Long getFtdId() {
        return ftdId;
    }

    public void setFtdId(Long ftdId) {
        this.ftdId = ftdId;
    }

    public Long getLinkId() {
        return linkId;
    }

    public void setLinkId(Long linkId) {
        this.linkId = linkId;
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

    public String getExportUrl() {
        return exportUrl;
    }

    public void setExportUrl(String exportUrl) {
        this.exportUrl = exportUrl;
    }

    public FormTableDefinition getFtd() {
        return formTableDefinition;
    }
    public NormalTableDefinition getTableFtd() {
        return normalTableDefinition;
    }
    public void setFormTableDefinition(FormTableDefinition formTableDefinition) {
        this.formTableDefinition = formTableDefinition;
    }
    public void setNormalTableDefinition(NormalTableDefinition normalTableDefinition) {
        this.normalTableDefinition = normalTableDefinition;
    }

}
