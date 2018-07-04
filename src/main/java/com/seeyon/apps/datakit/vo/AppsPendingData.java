package com.seeyon.apps.datakit.vo;

import java.util.HashMap;

public class AppsPendingData {

    //标题
    private String subject;
    //1、到期清除 2 点击后清除
    private int showMode;
    private String orgName;
    private String receiverName;
    private String senderName;
    private String linkAddress;
    private HashMap extParam;

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

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getLinkAddress() {
        return linkAddress;
    }

    public HashMap getExtParam() {
        return extParam;
    }

    public void setExtParam(HashMap extParam) {
        this.extParam = extParam;
    }

    public void setLinkAddress(String linkAddress) {
        this.linkAddress = linkAddress;
    }
}
