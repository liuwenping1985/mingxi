package com.seeyon.apps.datakit.po;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.seeyon.ctp.common.po.BasePO;

import java.io.Serializable;
import java.util.Date;

public class NewsDataItem  extends BasePO implements Serializable {

    private String title;
    private Long typeId;
    private String typeName;
    private String publishScope;
    private String publishScopeNames;
    private Long publishDepartmentId;
    private String brief;
    private String keywords;
    private String dataFormat;
    private Date createDate;
    private Long createUser;
    private String createUserName;
    private Date auditDate;
    private Long auditUserId;
    private String auditAdvice;
    private Date publishDate;
    private Long publishUserId;
    private String publishDepartmentName;
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
    @JsonIgnore
    private String ext1;
    @JsonIgnore
    private String ext2;
    @JsonIgnore
    private String ext3;
    @JsonIgnore
    private String ext4;
    @JsonIgnore
    private String ext5;
    private Boolean attachmentsFlag = false;
    private boolean imageNews;
    private boolean focusNews;
    private Long imageId;
    private boolean showPublishUserFlag;
    private String showPublishName;
    private Boolean shareDajia = false;
    private Boolean shareWeixin = false;
    private String imgUrl;
    private String praise = "";
    private Integer praiseSum = 0;
    private Integer replyNumber = 0;
    private Date replyTime;
    private Integer spaceType;

    private String content;
    private Boolean readFlag;
    private boolean noEdit;
    private boolean noDelete;
    private boolean showBriefArea = false;
    private boolean showKeywordsArea = false;

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

    public String getPublishScopeNames() {
        return publishScopeNames;
    }

    public void setPublishScopeNames(String publishScopeNames) {
        this.publishScopeNames = publishScopeNames;
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

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Long getCreateUser() {
        return createUser;
    }

    public void setCreateUser(Long createUser) {
        this.createUser = createUser;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
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

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    public Long getPublishUserId() {
        return publishUserId;
    }

    public void setPublishUserId(Long publishUserId) {
        this.publishUserId = publishUserId;
    }

    public String getPublishDepartmentName() {
        return publishDepartmentName;
    }

    public void setPublishDepartmentName(String publishDepartmentName) {
        this.publishDepartmentName = publishDepartmentName;
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

    public boolean isImageNews() {
        return imageNews;
    }

    public void setImageNews(boolean imageNews) {
        this.imageNews = imageNews;
    }

    public boolean isFocusNews() {
        return focusNews;
    }

    public void setFocusNews(boolean focusNews) {
        this.focusNews = focusNews;
    }

    public Long getImageId() {
        return imageId;
    }

    public void setImageId(Long imageId) {
        this.imageId = imageId;
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

    public Boolean getShareDajia() {
        return shareDajia;
    }

    public void setShareDajia(Boolean shareDajia) {
        this.shareDajia = shareDajia;
    }

    public Boolean getShareWeixin() {
        return shareWeixin;
    }

    public void setShareWeixin(Boolean shareWeixin) {
        this.shareWeixin = shareWeixin;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getPraise() {
        return praise;
    }

    public void setPraise(String praise) {
        this.praise = praise;
    }

    public Integer getPraiseSum() {
        return praiseSum;
    }

    public void setPraiseSum(Integer praiseSum) {
        this.praiseSum = praiseSum;
    }

    public Integer getReplyNumber() {
        return replyNumber;
    }

    public void setReplyNumber(Integer replyNumber) {
        this.replyNumber = replyNumber;
    }

    public Date getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(Date replyTime) {
        this.replyTime = replyTime;
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

    public Boolean getReadFlag() {
        return readFlag;
    }

    public void setReadFlag(Boolean readFlag) {
        this.readFlag = readFlag;
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

    public boolean isShowBriefArea() {
        return showBriefArea;
    }

    public void setShowBriefArea(boolean showBriefArea) {
        this.showBriefArea = showBriefArea;
    }

    public boolean isShowKeywordsArea() {
        return showKeywordsArea;
    }

    public void setShowKeywordsArea(boolean showKeywordsArea) {
        this.showKeywordsArea = showKeywordsArea;
    }
}
