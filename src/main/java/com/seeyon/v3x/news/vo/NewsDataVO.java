package com.seeyon.v3x.news.vo;

import java.util.Date;

import com.seeyon.ctp.util.Datetimes;

public class NewsDataVO {

    private Long    id;
    private String  title;
    private String  fuTitle;
    private String  content;
    private String  contentType;
    private boolean imageNews;        //图片新闻
    private boolean focusNews;        //焦点新闻
    private Long    imageId;          //图片id
    private String  imageUrl;         //图片url
    private String  createUserName;
    private Long    publishUserId;
    private String  publishUserName;
    private String  publishUserDepart;
    private String  createDate;
    private Date    publishDate;
    private String  publishDate1;
    private Long    typeId;
    private String  typeName;
    private Integer readCount    = 0; //阅读数
    private Integer praiseSum    = 0; //点赞数
    private Integer replyNumber  = 0; //回复数
    private String  praise       = ""; //已点赞人员id
    private String  praiseMember = ""; //已点赞人员名称
    private boolean praiseFlag;       //是否点过赞
    private boolean attachmentsFlag;
    private Integer  state;
    private boolean readFlag;         //阅读标志
    private boolean auditFlag;        //审核标记
    private boolean commentPermit;    //允许评论
    private boolean messagePermit;    //允许接收消息
    private String  topNumberOrder	 = "0";
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getFuTitle() {
        return fuTitle;
    }

    public void setFuTitle(String fuTitle) {
        this.fuTitle = fuTitle;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    
    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
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

    public String getPublishUserDepart() {
        return publishUserDepart;
    }

    public void setPublishUserDepart(String publishUserDepart) {
        this.publishUserDepart = publishUserDepart;
    }
    
    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(Date publishDate) {
        this.publishDate = publishDate;
    }

    public String getPublishDate1() {
        return Datetimes.formatDatetime(this.getPublishDate());
    }

    public void setPublishDate1(String publishDate1) {
        this.publishDate1 = publishDate1;
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

    public Integer getReadCount() {
        return readCount;
    }

    public void setReadCount(Integer readCount) {
        this.readCount = readCount;
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

    public String getPraise() {
        return praise;
    }

    public void setPraise(String praise) {
        this.praise = praise;
    }

    public String getPraiseMember() {
        return praiseMember;
    }

    public void setPraiseMember(String praiseMember) {
        this.praiseMember = praiseMember;
    }

    public boolean isPraiseFlag() {
        return praiseFlag;
    }

    public void setPraiseFlag(boolean praiseFlag) {
        this.praiseFlag = praiseFlag;
    }

    public boolean isAttachmentsFlag() {
        return attachmentsFlag;
    }

    public void setAttachmentsFlag(boolean attachmentsFlag) {
        this.attachmentsFlag = attachmentsFlag;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public boolean isReadFlag() {
        return readFlag;
    }

    public void setReadFlag(boolean readFlag) {
        this.readFlag = readFlag;
    }

    public boolean isAuditFlag() {
        return auditFlag;
    }

    public void setAuditFlag(boolean auditFlag) {
        this.auditFlag = auditFlag;
    }

    public boolean isCommentPermit() {
        return commentPermit;
    }

    public void setCommentPermit(boolean commentPermit) {
        this.commentPermit = commentPermit;
    }

    public boolean isMessagePermit() {
        return messagePermit;
    }

    public void setMessagePermit(boolean messagePermit) {
        this.messagePermit = messagePermit;
    }

	public String getTopNumberOrder() {
		return topNumberOrder;
	}

	public void setTopNumberOrder(String topNumberOrder) {
		this.topNumberOrder = topNumberOrder;
	}

}
