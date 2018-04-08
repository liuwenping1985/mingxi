package com.seeyon.apps.datakit.vo;

public class AppsPendingData {

    //标题
    private String subject;
    //1、到期清除 2 点击后清除
    private int showMode;
    private String orgName;
    private String userLoginName;
    private String linkAddress;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public int getShowMode() {
        return showMode;
    }

    public void setShowMode(int showMode) {
        this.showMode = showMode;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public String getUserLoginName() {
        return userLoginName;
    }

    public void setUserLoginName(String userLoginName) {
        this.userLoginName = userLoginName;
    }

    public String getLinkAddress() {
        return linkAddress;
    }

    public void setLinkAddress(String linkAddress) {
        this.linkAddress = linkAddress;
    }
}
