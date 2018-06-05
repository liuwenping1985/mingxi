package com.seeyon.apps.bulext.po;

import com.seeyon.ctp.common.po.BasePO;

import java.io.Serializable;
import java.util.Date;

public class BulReaderRecord extends BasePO implements Serializable {

    private Long bulId;

    private Long memberId;

    private Date readDate;

    public Long getBulId() {
        return bulId;
    }

    public void setBulId(Long bulId) {
        this.bulId = bulId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Date getReadDate() {
        return readDate;
    }

    public void setReadDate(Date readDate) {
        this.readDate = readDate;
    }
}
