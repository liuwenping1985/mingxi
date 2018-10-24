package com.seeyon.apps.menhu.vo;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Created by liuwenping on 2018/10/24.
 */
public class BulsVo {

    private String title;
    private Timestamp createDate;
    private Long accountId;
    private String accountName;
    private Long createUserId;
    private String createUserName;
    private Integer readCount;
    private Long publishDepartmentId;
    private String publishDepartmentName;
    private Long typeId;
    private Date publishDate;
    private Date updateDate;
    private Long publishUserId;
    private String publishUserName;
    private String link;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }



    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public Long getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(Long createUserId) {
        this.createUserId = createUserId;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
    }

    public Integer getReadCount() {
        return readCount;
    }

    public void setReadCount(Integer readCount) {
        this.readCount = readCount;
    }

    public Long getPublishDepartmentId() {
        return publishDepartmentId;
    }

    public void setPublishDepartmentId(Long publishDepartmentId) {
        this.publishDepartmentId = publishDepartmentId;
    }

    public String getPublishDepartmentName() {
        return publishDepartmentName;
    }

    public void setPublishDepartmentName(String publishDepartmentName) {
        this.publishDepartmentName = publishDepartmentName;
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Long getPublishUserId() {
        return publishUserId;
    }

    public void setPublishUserId(Long publishUserId) {
        this.publishUserId = publishUserId;
    }

    public String getPublishUserName() {
        return publishUserName;
    }

    public void setPublishUserName(String publishUserName) {
        this.publishUserName = publishUserName;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }
}
