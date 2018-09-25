//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.u8login.po;

import java.util.Map;

public class U8CtpAffair {
    private String id;
    private String subject;
    private String senderUserId;
    private String receiverUserId;
    private String orgName;
    private Long createDate;
    private String link;
    private Integer status;
    private Map extParam;

    public U8CtpAffair() {
    }

    public Integer getStatus() {
        return this.status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getSubject() {
        return this.subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getSenderUserId() {
        return this.senderUserId;
    }

    public void setSenderUserId(String senderUserId) {
        this.senderUserId = senderUserId;
    }

    public String getReceiverUserId() {
        return this.receiverUserId;
    }

    public void setReceiverUserId(String receiverUserId) {
        this.receiverUserId = receiverUserId;
    }

    public String getOrgName() {
        return this.orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public Long getCreateDate() {
        return this.createDate;
    }

    public String getLink() {
        return this.link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public Map getExtParam() {
        return this.extParam;
    }

    public void setExtParam(Map extParam) {
        this.extParam = extParam;
    }

    public void setCreateDate(Long createDate) {
        this.createDate = createDate;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
