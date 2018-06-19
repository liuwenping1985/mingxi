package com.seeyon.apps.u8login.po;

import java.util.Map;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class U8CtpAffair {

    private String subject;

    private String senderUserId;

    private String receiverUserId;

    private String orgName;

    private Long createDate;

    private String link;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(String senderUserId) {
        this.senderUserId = senderUserId;
    }

    public String getReceiverUserId() {
        return receiverUserId;
    }

    public void setReceiverUserId(String receiverUserId) {
        this.receiverUserId = receiverUserId;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public Long getCreateDate() {
        return createDate;
    }
    private Map extParam;
    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public Map getExtParam() {
        return extParam;
    }

    public void setExtParam(Map extParam) {
        this.extParam = extParam;
    }

    public void setCreateDate(Long createDate) {
        this.createDate = createDate;
    }
}
