package com.seeyon.v3x.bulletin.vo;

import java.util.List;

import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;
import com.seeyon.v3x.bulletin.util.Constants;

/**
 * 用户在查看单位公告或集团公告首页时，每个公告板块除了显示最新6条公告之外，还需显示其管理员、审核员（如果该公告板块设定了审核员的话）
 * 同时也需要针对当前用户的权限显示"发布公告"或"板块管理"功能按钮
 * 为此设定一个仅用于前端展现的类，包含公告板块、当前用户是否具备发起权限和管理权限
 */
public class BulTypeModel{
	private boolean canNewOfCurrent;     // 当前用户是否有新建权限
	private boolean canAdminOfCurrent;   // 当前用户是否可以管理
	private boolean canAuditOfCurrent;   // 当前用户是否可以
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
	private BulType bulType;
	private String  bulName;
	private Long id;
    private String   adminsName;
    private String   auditName;
    private boolean flag; //判断部门或自定义空间版块
    private String topNumber;//置顶个数
    private Integer  spaceType;
    private Long     spaceId;
	
	public String getTopNumber() {
		return topNumber;
	}
	public void setTopNumber(String topNumber) {
		this.topNumber = topNumber;
	}
	public boolean getFlag() {
		return flag;
	}
	public void setFlag(boolean flag) {
		this.flag = flag;
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
	public String getBulName() {
		return bulName;
	}
	public void setBulName(String bulName) {
		this.bulName = bulName;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @param bulType 公告板块
	 * @param domainIds 当前登录用户的各种组织模型，比如部门ID、所属组的ID、岗位ID等，以便匹配发起权限
	 */
	public BulTypeModel(BulType bulType,long userId, List<Long> domainIds){
		this.bulType = bulType;
		this.spaceId = bulType.getAccountId();
		this.spaceType = bulType.getSpaceType();
		if (bulType.isAuditFlag()) {
		    if (bulType.getAuditUser().longValue() == userId) {
		        setCanAuditOfCurrent(true);
		    }
		}
		//客开 start
        if (bulType.isTypesettingFlag()) {
          if (bulType.getTypesettingStaff().longValue() == userId) {
            setCanTypesettingOfCurrent(true);
          }
        }
        //客开 end
		this.setProps(domainIds);
	}
	public BulTypeModel(){
	}
	private void setProps(List<Long> domainIds){
		//公告板块的发起权限授权对象可以是单位、部门、岗位、职务级别、组等情况，依次进行匹配
		for(BulTypeManagers tm : bulType.getBulTypeManagers()){
			if(domainIds.contains(tm.getManagerId())){
				if(Constants.MANAGER_FALG.equals(tm.getExt1())){
					setCanAdminOfCurrent(true);
					setCanNewOfCurrent(true);
					break;
				} else if(Constants.WRITE_FALG.equals(tm.getExt1()))
					setCanNewOfCurrent(true);
			}
		}
	}

	public BulType getBulType() {
		return bulType;
	}

	public void setBulType(BulType bulType) {
		this.bulType = bulType;
	}

	public boolean getCanAdminOfCurrent() {
		return canAdminOfCurrent;
	}

	public void setCanAdminOfCurrent(boolean canAdminOfCurrent) {
		this.canAdminOfCurrent = canAdminOfCurrent;
	}

	public boolean getCanNewOfCurrent() {
		return canNewOfCurrent;
	}

	public void setCanNewOfCurrent(boolean canNewOfCurrent) {
		this.canNewOfCurrent = canNewOfCurrent;
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
    public boolean isCanAuditOfCurrent() {
        return canAuditOfCurrent;
    }
    public void setCanAuditOfCurrent(boolean canAuditOfCurrent) {
        this.canAuditOfCurrent = canAuditOfCurrent;
    }
	
}
