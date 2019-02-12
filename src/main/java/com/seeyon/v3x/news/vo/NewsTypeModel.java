package com.seeyon.v3x.news.vo;

import java.util.List;

import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.domain.NewsTypeManagers;
import com.seeyon.v3x.news.util.Constants;

public class NewsTypeModel {
    private Long     id;
    private String   typeName;
    private Integer  spaceType;
    private Long     spaceId;
    private boolean  canNewOfCurrent;   // 当前用户是否有新建权限
    private boolean  canAdminOfCurrent; // 当前用户是否可以管理
    private boolean  canAuditOfCurrent; // 当前用户是否审核员
    //客开 start
    private boolean canTypesettingOfCurrent; //当前用户是否排版员
    private String typesettingStaff;
    
    public boolean isCanTypesettingOfCurrent() {
      return canTypesettingOfCurrent;
    }

    public void setCanTypesettingOfCurrent(boolean canTypesettingOfCurrent) {
      this.canTypesettingOfCurrent = canTypesettingOfCurrent;
    }
    
    public String getTypesettingStaff() {
      return typesettingStaff;
    }

    public void setTypesettingStaff(String typesettingStaff) {
      this.typesettingStaff = typesettingStaff;
    }
    //客开 end
    private NewsType newsType;
    private long     userId;
    private String   adminsName;
    private String   auditName;
    private String 	 topNumber;//置顶个数

    public NewsTypeModel(NewsType newsType, long userId, List<Long> domainIds) {
        this.newsType = newsType;
        this.spaceType = newsType.getSpaceType();
        this.spaceId = newsType.getAccountId();
        this.userId = userId;
        this.setProps(domainIds);
    }

    private void setProps(List<Long> domainIds) {
        this.setId(newsType.getId());
        this.setTypeName(newsType.getTypeName());

        for (NewsTypeManagers tm : newsType.getNewsTypeManagers()) {
            if (domainIds.contains(tm.getManagerId())) {
                if (Constants.MANAGER_FALG.equals(tm.getExt1())) {
                    setCanAdminOfCurrent(true);
                    setCanNewOfCurrent(true);
                    break;
                } else if (Constants.WRITE_FALG.equals(tm.getExt1())) {
                    setCanNewOfCurrent(true);
                }
            }
        }

        if (newsType.isAuditFlag()) {
            if (newsType.getAuditUser().longValue() == userId) {
                setCanAuditOfCurrent(true);
            }
        }
        //客开 start
        if (newsType.isTypesettingFlag()) {
          if (newsType.getTypesettingStaff().longValue() == userId) {
            setCanTypesettingOfCurrent(true);
          }
        }
        //客开 end
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public Integer getSpaceType() {
        return spaceType;
    }

    public void setSpaceType(Integer spaceType) {
        this.spaceType = spaceType;
    }

    public Long getSpaceId() {
        return spaceId;
    }

    public void setSpaceId(Long spaceId) {
        this.spaceId = spaceId;
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

    public NewsType getNewsType() {
        return newsType;
    }

    public void setNewsType(NewsType newsType) {
        this.newsType = newsType;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getAdminsName() {
        return adminsName;
    }

    public void setAdminsName(String adminsName) {
        this.adminsName = adminsName;
    }

    public String getAuditName() {
        return auditName;
    }

    public void setAuditName(String auditName) {
        this.auditName = auditName;
    }

    public String getTopNumber() {
    	return topNumber;
    }
    
    public void setTopNumber(String topNumber) {
    	this.topNumber = topNumber;
    }
}
