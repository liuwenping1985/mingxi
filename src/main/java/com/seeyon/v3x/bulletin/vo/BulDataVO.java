package com.seeyon.v3x.bulletin.vo;

import java.util.Date;

public class BulDataVO {
	private Long    id;
    private String  title;
    private String  fuTitle;  // 副标题
    private String  dataFormat; //正文类型
    private Date    publishDate;
    private String  publishDate1;
    private Long    publishUserId;
    private String  publishUserName;
    private String  showPublishName;
    private Boolean showPublishUserFlag; //是否显示发布人
    private Long    typeId;
    private String  typeName;
    private String  readCount     = "0"; //阅读数
    private String  topOrder	 = "0";
    private Boolean attachmentFlag; //附件
    private String  spaceType;
    private String createDate;
    private String state;
    private boolean readFlag;         //阅读记录
    private String publishScope;	//发布范围
    private String createUser;
    private Boolean auditFlag;
    private String Ext5;	//word转PDF
    //客开 start
    private Boolean typesettingFlag;
    
    public Boolean getTypesettingFlag() {
      return typesettingFlag;
    }
    public void setTypesettingFlag(Boolean typesettingFlag) {
      this.typesettingFlag = typesettingFlag;
    }
    //客开 end
	public String getExt5() {
		return Ext5;
	}
	public void setExt5(String ext5) {
		Ext5 = ext5;
	}
	public Boolean getAuditFlag() {
		return auditFlag;
	}
	public void setAuditFlag(Boolean auditFlag) {
		this.auditFlag = auditFlag;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public String getPublishScope() {
		return publishScope;
	}
	public void setPublishScope(String publishScope) {
		this.publishScope = publishScope;
	}
	public boolean isReadFlag() {
		return readFlag;
	}
	public void setReadFlag(boolean readFlag) {
		this.readFlag = readFlag;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getSpaceType() {
		return spaceType;
	}
	public void setSpaceType(String spaceType) {
		this.spaceType = spaceType;
	}
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
	public String getDataFormat() {
		return dataFormat;
	}
	public void setDataFormat(String dataFormat) {
		this.dataFormat = dataFormat;
	}
	public Date getPublishDate() {
		return publishDate;
	}
	public void setPublishDate(Date publishDate) {
		this.publishDate = publishDate;
	}
	public String getPublishDate1() {
		return publishDate1;
	}
	public void setPublishDate1(String publishDate1) {
		this.publishDate1 = publishDate1;
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
	public String getShowPublishName() {
		return showPublishName;
	}
	public void setShowPublishName(String showPublishName) {
		this.showPublishName = showPublishName;
	}
	public Boolean getShowPublishUserFlag() {
		return showPublishUserFlag;
	}
	public void setShowPublishUserFlag(Boolean showPublishUserFlag) {
		this.showPublishUserFlag = showPublishUserFlag;
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
	public String getReadCount() {
		return readCount;
	}
	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}
	public String getTopOrder() {
		return topOrder;
	}
	public void setTopOrder(String topOrder) {
		this.topOrder = topOrder;
	}
	public Boolean getAttachmentFlag() {
		return attachmentFlag;
	}
	public void setAttachmentFlag(Boolean attachmentFlag) {
		this.attachmentFlag = attachmentFlag;
	}


}
