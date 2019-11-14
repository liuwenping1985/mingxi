package com.seeyon.apps.duban.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * Created by liuwenping on 2019/11/5.
 */
public class FormFieldMapping extends BasePO {

    private String uuid;

    private String fieldInfo;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getFieldInfo() {
        return fieldInfo;
    }

    public void setFieldInfo(String fieldInfo) {
        this.fieldInfo = fieldInfo;
    }
}
