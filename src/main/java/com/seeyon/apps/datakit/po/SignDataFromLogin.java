package com.seeyon.apps.datakit.po;

import com.seeyon.ctp.common.po.BasePO;

import java.io.Serializable;
import java.util.Date;

public class SignDataFromLogin extends BasePO  implements Serializable {
    private Long userId;

    private String name;

    private String content;

    private String dateToken;

    private Date loginDate;

    private Date lastLoginDate;

    private int dataType;

    private int dataState;

    public String getDateToken() {
        return dateToken;
    }

    public void setDateToken(String dateToken) {
        this.dateToken = dateToken;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getLoginDate() {
        return loginDate;
    }

    public void setLoginDate(Date loginDate) {
        this.loginDate = loginDate;
    }

    public int getDataType() {
        return dataType;
    }

    public void setDataType(int dataType) {
        this.dataType = dataType;
    }

    public int getDataState() {
        return dataState;
    }

    public void setDataState(int dataState) {
        this.dataState = dataState;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }
}
