//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.v3x.bulletin.domain;

import com.seeyon.ctp.common.po.BasePO;

public class BulPublishScope extends BasePO {
    private static final long serialVersionUID = 504265606117033427L;
    private long bulDataId;
    private long userId;
    private String userType;

    public BulPublishScope(long bulDataId, long userId, String userType) {
        this.setIdIfNew();
        this.bulDataId = bulDataId;
        this.userId = userId;
        this.userType = userType;
    }
    public BulPublishScope() {
    }
    public long getBulDataId() {
        return this.bulDataId;
    }

    public void setBulDataId(long bulDataId) {
        this.bulDataId = bulDataId;
    }

    public long getUserId() {
        return this.userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getUserType() {
        return this.userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }
}
