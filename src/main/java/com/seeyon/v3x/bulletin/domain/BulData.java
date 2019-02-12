package com.seeyon.v3x.bulletin.domain;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.seeyon.ctp.common.po.BasePO;

public class BulData extends BasePO implements Serializable {

    private static final long serialVersionUID = -6006398162421738965L;
    private String            title;
    private Long              typeId;
    private String            typeName;
    @JsonIgnore
    private BulType           type;
    private String            publishScope;
    private Long              publishDepartmentId;
    private String            brief;
    private String            keywords;
    private String            dataFormat;
    private Timestamp         createDate;
    private Long              createUser;
    private Date              auditDate;
    private Long              auditUserId;
    private String            auditAdvice;
    private Timestamp         publishDate;
    private String            publishDateFormat;
    private Long              publishUserId;
    private String            publishMemberName;
    private String            publishDeptName;
    private Date              pigeonholeDate;
    private Long              pigeonholeUserId;
    private String            pigeonholePath;
    private Date              updateDate;
    private Long              updateUser;
    private Integer           readCount;
    private Byte              topOrder;
    private Integer           state;
    private boolean           deletedFlag;
    private Long              accountId;
    private String            ext1 = "1";                                    //记录阅读信息
    private String            ext2;                                    //允许打印
    private String            ext3;                                    //审核：直接发布/通过/不通过
    private String            ext4;                                    //应用标识
    private String            ext5;                                    //WORD转PDF，设置PDF文件的ID
    private Boolean           attachmentsFlag  = false;
    private boolean           showPublishUserFlag;
    private String            showPublishName;
    private Integer           spaceType;

    private String            content;
    private String            contentName;
    private Boolean           readFlag;
    private boolean           noEdit;                                  // 是否不能修改
    private boolean           noDelete;                                // 是否不能删除
    private String            stringId;
    //客开 start
    private Date              auditDate1;                               //排版日期
    private Long              auditUserId1;                             //排版人
    private String            auditAdvice1;                             //排版意见
    private Long              oldId;                                    //旧公告ID
    // 项目  信达资产   公司  kimde  修改人  msg  修改时间  2017-11-13  修改功能  公告添加副标题  start
    private String            futitle;//公告副标题
    //项目  信达资产   公司  kimde  修改人  msg  修改时间  2017-11-13  修改功能  公告添加副标题  end
    
    public Date getAuditDate1() {
      return auditDate1;
    }

    public String getFutitle() {
		return futitle;
	}

	public void setFutitle(String futitle) {
		this.futitle = futitle;
	}

	public void setAuditDate1(Date auditDate1) {
      this.auditDate1 = auditDate1;
    }

    public Long getAuditUserId1() {
      return auditUserId1;
    }

    public void setAuditUserId1(Long auditUserId1) {
      this.auditUserId1 = auditUserId1;
    }

    public String getAuditAdvice1() {
      return auditAdvice1;
    }

    public void setAuditAdvice1(String auditAdvice1) {
      this.auditAdvice1 = auditAdvice1;
    }
    
    public Long getOldId() {
      return oldId;
    }
    
    public void setOldId(Long oldId) {
      this.oldId = oldId;
    }
    //客开 end
    
	private Integer 		  publishChoose = 0;					   // 发布人类型选择 0 实际发布人 1 选择人员 2 手动输入人员
    private String 			  writePublish;							   // 手动输入发布人名
    private String 			  choosePublshId;							   // 选择发布人员


	public String getChoosePublshId() {
		return choosePublshId;
	}

	public void setChoosePublshId(String choosePublshId) {
		this.choosePublshId = choosePublshId;
	}

	public Integer getPublishChoose() {
		return publishChoose;
	}

	public void setPublishChoose(Integer publishChoose) {
		this.publishChoose = publishChoose;
	}

	public String getWritePublish() {
		return writePublish;
	}

	public void setWritePublish(String writePublish) {
		this.writePublish = writePublish;
	}

	
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

    public BulType getType() {
        return type;
    }

    public void setType(BulType type) {
        this.type = type;
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

    public String getStringId() {
        return stringId;
    }

    public void setStringId(String stringId) {
        this.stringId = stringId;
    }

}