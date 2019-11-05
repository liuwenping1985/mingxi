package com.seeyon.apps.ztask.po;

import com.seeyon.apps.platform.po.CommonPo;

/**
 * 任务的附属物
 * Created by liuwenping on 2019/1/18.
 */
public class TaskReference extends CommonPo {

    private String referenceId;

    private String typeName;


    private String referenceValue;


    private Long referenceObject;

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getReferenceValue() {
        return referenceValue;
    }

    public void setReferenceValue(String referenceValue) {
        this.referenceValue = referenceValue;
    }

    public Long getReferenceObject() {
        return referenceObject;
    }

    public void setReferenceObject(Long referenceObject) {
        this.referenceObject = referenceObject;
    }
}
