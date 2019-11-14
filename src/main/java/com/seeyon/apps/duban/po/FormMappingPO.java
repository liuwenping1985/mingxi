package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * Created by liuwenping on 2019/11/5.
 */
public class FormMappingPO extends BasePO {

    private Long formRecordId;

    private String tableName;

    private String mapping;


    public Long getFormRecordId() {
        return formRecordId;
    }

    public void setFormRecordId(Long formRecordId) {
        this.formRecordId = formRecordId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getMapping() {
        return mapping;
    }

    public void setMapping(String mapping) {
        this.mapping = mapping;
    }
}
