package com.seeyon.apps.u8login.po;

import java.util.Map;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class U8CtpAffair {
    /**
     * id-唯一标识
     */
    private String id;

    private String subject;
    /**
     * 发送人用户编码（必填）
     */
    private String senderUserId;
    /**
     * 接收人用户编码（必填）
     */
    private String receiverUserId;
    /**
     * 组织名称（必填）
     */
    private String orgName;
    /**
     * 创建时间（时间戳）
     */
    private Long createDate;
    /**
     * 跳转地址
     */
    private String link;
    /**
     * 状态
     */
    private Integer status;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
