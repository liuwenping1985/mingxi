package com.seeyon.v3x.news.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import org.apache.commons.lang.math.NumberUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.Strings;

public class NewsType extends BasePO implements Serializable, Comparable<NewsType> {

    private static final long     serialVersionUID = -7243536984288931405L;
    private String                typeName;
    private boolean               usedFlag;
    private String                description;
    @JsonIgnore
    private Byte                  topCount;
    private boolean               auditFlag;
    private Long                  auditUser;
    @JsonIgnore
    private Long                  defaultTemplateId;
    private Date                  createDate;
    private Long                  createUser;
    private String                createUserName;
    private Date                  updateDate;
    private Long                  updateUser;
    private Long                  accountId;
    private Integer               spaceType;
    @JsonIgnore
    private String                ext1;
    @JsonIgnore
    private String                ext2;
    @JsonIgnore
    private Integer               sortNum          = 999;
    private Boolean               outterPermit;
    private Boolean               isAuditorModify;                         //是否允许审核员修改
    private Boolean               commentPermit    = true;
    private Byte				  topNumber;//置顶个数

    @JsonIgnore
    private Set<NewsTypeManagers> newsTypeManagers;
    private String                managerUserIds;
    private String                writeUserIds;
    private String                writeUserNames;
    private boolean               canNewOfCurrent;                         // 当前用户是否有新建权限
    private boolean               canAdminOfCurrent;                       // 当前用户是否可以管理
    private boolean               canAuditOfCurrent;                       // 当前用户是否审核员
    @JsonIgnore
    private int                   totalItems;
    @JsonIgnore
    private boolean               isShowManageButton;
    private int                   auditPending;                            // 如果是审核员 待办条数
    //客开 start
    private Long                  typesettingStaff;                         // 排版员
    private boolean                  typesettingFlag;                         // 是否排版
    
    public Long getTypesettingStaff() {
      return typesettingStaff;
    }

    public void setTypesettingStaff(Long typesettingStaff) {
      this.typesettingStaff = typesettingStaff;
    }
    
    public boolean isTypesettingFlag() {
      return typesettingFlag;
    }
    
    public void setTypesettingFlag(boolean typesettingFlag) {
      this.typesettingFlag = typesettingFlag;
    }
    //客开 end
    


    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public boolean isUsedFlag() {
        return usedFlag;
    }

    public void setUsedFlag(boolean usedFlag) {
        this.usedFlag = usedFlag;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Byte getTopCount() {
        return topCount;
    }

    public void setTopCount(Byte topCount) {
        this.topCount = topCount;
    }

    public boolean isAuditFlag() {
        return auditFlag;
    }

    public void setAuditFlag(boolean auditFlag) {
        this.auditFlag = auditFlag;
    }

    public Long getAuditUser() {
        return auditUser;
    }

    public void setAuditUser(Long auditUser) {
        this.auditUser = auditUser;
    }

    public Long getDefaultTemplateId() {
        return defaultTemplateId;
    }

    public void setDefaultTemplateId(Long defaultTemplateId) {
        this.defaultTemplateId = defaultTemplateId;
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

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public Integer getSpaceType() {
        return spaceType;
    }

    public void setSpaceType(Integer spaceType) {
        this.spaceType = spaceType;
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

    public Integer getSortNum() {
        return sortNum;
    }

    public void setSortNum(Integer sortNum) {
        this.sortNum = sortNum;
    }

    public Boolean getOutterPermit() {
        return outterPermit;
    }

    public void setOutterPermit(Boolean outterPermit) {
        this.outterPermit = outterPermit;
    }

    public Boolean getIsAuditorModify() {
        if (isAuditorModify == null) {
            return false;
        }
        return isAuditorModify;
    }

    public void setIsAuditorModify(Boolean isAuditorModify) {
        this.isAuditorModify = isAuditorModify;
    }

    public Boolean getCommentPermit() {
        return commentPermit;
    }

    public void setCommentPermit(Boolean commentPermit) {
        this.commentPermit = commentPermit;
    }

    public Set<NewsTypeManagers> getNewsTypeManagers() {
        return newsTypeManagers;
    }

    public void setNewsTypeManagers(Set<NewsTypeManagers> newsTypeManagers) {
        this.newsTypeManagers = newsTypeManagers;
    }

    public String getManagerUserIds() {
        return managerUserIds;
    }

    public void setManagerUserIds(String managerUserIds) {
        this.managerUserIds = managerUserIds;
    }

    public String getManagerUserNames() {
        String names = "";
        if (Strings.isNotBlank(this.getManagerUserIds())) {
            String[] strs = this.getManagerUserIds().split(",");
            if (strs != null && strs.length > 0) {
                for (String id : strs) {
                    if (Strings.isNotBlank(id)) {
                        names = names + "," + Functions.showMemberNameOnly(NumberUtils.toLong(id));
                    }
                }
            }
        }
        return names;
    }

    public String getWriteUserIds() {
        return writeUserIds;
    }

    public void setWriteUserIds(String writeUserIds) {
        this.writeUserIds = writeUserIds;
    }

    public String getWriteUserNames() {
        return writeUserNames;
    }

    public void setWriteUserNames(String writeUserNames) {
        this.writeUserNames = writeUserNames;
    }

    public String getAuditUserName() {
        String auditUserName = "";
        if (this.isAuditFlag()) {
            auditUserName = Functions.showMemberNameOnly(this.getAuditUser());
            if (auditUserName == null) {
                auditUserName = "";
            }
        }
        return auditUserName;
    }

    public boolean isCanNewOfCurrent() {
        return canNewOfCurrent;
    }

    public void setCanNewOfCurrent(boolean canNewOfCurrent) {
        this.canNewOfCurrent = canNewOfCurrent;
    }

    public boolean isCanAdminOfCurrent() {
        return canAdminOfCurrent;
    }

    public void setCanAdminOfCurrent(boolean canAdminOfCurrent) {
        this.canAdminOfCurrent = canAdminOfCurrent;
    }

    public boolean isCanAuditOfCurrent() {
        return canAuditOfCurrent;
    }

    public void setCanAuditOfCurrent(boolean canAuditOfCurrent) {
        this.canAuditOfCurrent = canAuditOfCurrent;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public boolean isShowManageButton() {
        return isShowManageButton;
    }

    public void setShowManageButton(boolean isShowManageButton) {
        this.isShowManageButton = isShowManageButton;
    }

    public int getAuditPending() {
        return auditPending;
    }

    public void setAuditPending(int auditPending) {
        this.auditPending = auditPending;
    }

    public int compareTo(NewsType o) {
        if (this.getSortNum().intValue() < o.getSortNum().intValue()) {
            return -1;
        } else if (this.getSortNum().intValue() > o.getSortNum().intValue()) {
            return 1;
        } else {
            return (this.getCreateDate().compareTo(o.getCreateDate()));
        }
    }

	public Byte getTopNumber() {
		return topNumber;
	}

	public void setTopNumber(Byte topNumber) {
		this.topNumber = topNumber;
	}

}