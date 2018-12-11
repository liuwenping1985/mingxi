package com.seeyon.apps.nbd.po;

import com.seeyon.apps.nbd.annotation.ClobText;

/**
 * Created by liuwenping on 2018/12/3.
 */
public class A8ToOther extends CommonPo {

    @ClobText
    private String data;
    private Long sourceId;

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Long getSourceId() {
        return sourceId;
    }

    public void setSourceId(Long sourceId) {
        this.sourceId = sourceId;
    }
}
