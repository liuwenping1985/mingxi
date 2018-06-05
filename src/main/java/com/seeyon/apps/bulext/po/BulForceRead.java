package com.seeyon.apps.bulext.po;

import com.seeyon.ctp.common.po.BasePO;

import java.io.Serializable;

public class BulForceRead extends BasePO implements Serializable {


    private Long bulId;


    public Long getBulId() {
        return bulId;
    }

    public void setBulId(Long bulId) {
        this.bulId = bulId;
    }
}
