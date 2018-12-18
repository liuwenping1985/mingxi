package com.seeyon.apps.zqmenhu.po;

import com.seeyon.ctp.common.po.BasePO;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class BulDataItem extends BasePO implements Serializable {

    private String title;
    private Long typeId;
    private String typeName;
    private String publishScope;
    private Long publishDepartmentId;
    private String brief;
    private String keywords;
    private String dataFormat;
    private Timestamp createDate;
    private Long createUser;
    private Date auditDate;
    private Long auditUserId;
    private String auditAdvice;
    private Timestamp publishDate;
    private String publishDateFormat;
    private Long publishUserId;
    private String publishMemberName;
    private String publishDeptName;
    private Date pigeonholeDate;
    private Long pigeonholeUserId;
    private String pigeonholePath;
    private Date updateDate;
    private Long updateUser;
    private Integer readCount;
    private Byte topOrder;
    private Integer state;
    private boolean deletedFlag;
    private Long accountId;
    private String ext1 = "1";
    private String ext2;
    private String ext3;
    private String ext4;
    private String ext5;
    private Boolean attachmentsFlag = false;
    private boolean showPublishUserFlag;
    private String showPublishName;
    private Integer spaceType;
    private String content;
    private String contentName;
    private Boolean readFlag;
    private boolean noEdit;
    private boolean noDelete;
    private String stringId;
     private List<String> mimeTypes;
    public boolean isReadFlag() {
        return readFlag;
    }

    public void setReadFlag(boolean readFlag) {
        this.readFlag = readFlag;
    }

    public List<String> getMimeTypes() {
        return mimeTypes;
    }

    public void setMimeTypes(List<String> mimeTypes) {
        this.mimeTypes = mimeTypes;
    }

    private String choosePublshId;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getPublishScope() {
        return publishScope;
    }

    public void setPublishScope(String publishScope) {
        this.publishScope = publishScope;
    }

    public Long getPublishDepartmentId() {
        return publishDepartmentId;
    }

    public void setPublishDepartmentId(Long publishDepartmentId) {
        this.publishDepartmentId = publishDepartmentId;
    }

    public String getBrief() {
        return brief;
    }

    public void setBrief(String brief) {
        this.brief = brief;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getDataFormat() {
        return dataFormat;
    }

    public void setDataFormat(String dataFormat) {
        this.dataFormat = dataFormat;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public Long getCreateUser() {
        return createUser;
    }

    public void setCreateUser(Long createUser) {
        this.createUser = createUser;
    }

    public Date getAuditDate() {
        return auditDate;
    }

    public void setAuditDate(Date auditDate) {
        this.auditDate = auditDate;
    }

    public Long getAuditUserId() {
        return auditUserId;
    }

    public void setAuditUserId(Long auditUserId) {
        this.auditUserId = auditUserId;
    }

    public String getAuditAdvice() {
        return auditAdvice;
    }

    public void setAuditAdvice(String auditAdvice) {
        this.auditAdvice = auditAdvice;
    }

    public Timestamp getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Timestamp publishDate) {
        this.publishDate = publishDate;
    }

    public String getPublishDateFormat() {
        return publishDateFormat;
    }

    public void setPublishDateFormat(String publishDateFormat) {
        this.publishDateFormat = publishDateFormat;
    }

    public Long getPublishUserId() {
        return publishUserId;
    }

    public void setPublishUserId(Long publishUserId) {
        this.publishUserId = publishUserId;
    }

    public String getPublishMemberName() {
        return publishMemberName;
    }

    public void setPublishMemberName(String publishMemberName) {
        this.publishMemberName = publishMemberName;
    }

    public String getPublishDeptName() {
        return publishDeptName;
    }

    public void setPublishDeptName(String publishDeptName) {
        this.publishDeptName = publishDeptName;
    }

    public Date getPigeonholeDate() {
        return pigeonholeDate;
    }

    public void setPigeonholeDate(Date pigeonholeDate) {
        this.pigeonholeDate = pigeonholeDate;
    }

    public Long getPigeonholeUserId() {
        return pigeonholeUserId;
    }

    public void setPigeonholeUserId(Long pigeonholeUserId) {
        this.pigeonholeUserId = pigeonholeUserId;
    }

    public String getPigeonholePath() {
        return pigeonholePath;
    }

    public void setPigeonholePath(String pigeonholePath) {
        this.pigeonholePath = pigeonholePath;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Long getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(Long updateUser) {
        this.updateUser = updateUser;
    }

    public Integer getReadCount() {
        return readCount;
    }

    public void setReadCount(Integer readCount) {
        this.readCount = readCount;
    }

    public Byte getTopOrder() {
        return topOrder;
    }

    public void setTopOrder(Byte topOrder) {
        this.topOrder = topOrder;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public boolean isDeletedFlag() {
        return deletedFlag;
    }

    public void setDeletedFlag(boolean deletedFlag) {
        this.deletedFlag = deletedFlag;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public String getExt1() {
        return ext1;
    }

    public void setExt1(String ext1) {
        this.ext1 = ext1;
    }

    public String getExt2() {
        return ext2;
    }

    public void setExt2(String ext2) {
        this.ext2 = ext2;
    }

    public String getExt3() {
        return ext3;
    }

    public void setExt3(String ext3) {
        this.ext3 = ext3;
    }

    public String getExt4() {
        return ext4;
    }

    public void setExt4(String ext4) {
        this.ext4 = ext4;
    }

    public String getExt5() {
        return ext5;
    }

    public void setExt5(String ext5) {
        this.ext5 = ext5;
    }

    public Boolean getAttachmentsFlag() {
        return attachmentsFlag;
    }

    public void setAttachmentsFlag(Boolean attachmentsFlag) {
        this.attachmentsFlag = attachmentsFlag;
    }

    public boolean isShowPublishUserFlag() {
        return showPublishUserFlag;
    }

    public void setShowPublishUserFlag(boolean showPublishUserFlag) {
        this.showPublishUserFlag = showPublishUserFlag;
    }

    public String getShowPublishName() {
        return showPublishName;
    }

    public void setShowPublishName(String showPublishName) {
        this.showPublishName = showPublishName;
    }

    public Integer getSpaceType() {
        return spaceType;
    }

    public void setSpaceType(Integer spaceType) {
        this.spaceType = spaceType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContentName() {
        return contentName;
    }

    public void setContentName(String contentName) {
        this.contentName = contentName;
    }



    public boolean isNoEdit() {
        return noEdit;
    }

    public void setNoEdit(boolean noEdit) {
        this.noEdit = noEdit;
    }

    public boolean isNoDelete() {
        return noDelete;
    }

    public void setNoDelete(boolean noDelete) {
        this.noDelete = noDelete;
    }

    public String getStringId() {
        return stringId;
    }

    public void setStringId(String stringId) {
        this.stringId = stringId;
    }





    public String getChoosePublshId() {
        return choosePublshId;
    }

    public void setChoosePublshId(String choosePublshId) {
        this.choosePublshId = choosePublshId;
    }
}
