package com.seeyon.apps.ztask.po;

import com.seeyon.apps.platform.po.CommonPo;

/**
 * 任务的附属物
 * Created by liuwenping on 2019/1/18.
 */
public class TaskReference extends CommonPo {

    private String referenceId;

    private String typeName;
    /**
     * 有督办的类型和附件
     */
    private String type;

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

    @Override
    public String getType() {
        return type;
    }

    @Override
    public void setType(String type) {
        this.type = type;
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
