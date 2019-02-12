package com.seeyon.apps.taskcenter.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;

public class TaskGroups extends BasePO {
	private String groupCode;
	private String name;
	private String app;
	private boolean outSys = false;
	private GroupType groupType;
	private Date createTime;
	private Date updateTime;
	private Long createUser;
	private Long accountId;
	private String remark;
	
	
	public TaskGroups() {
		super();
		this.setIdIfNew();
	}
	
	public TaskGroups(String groupCode, String name, String app, boolean outSys) {
		super();
		this.setIdIfNew();
		this.groupCode = groupCode;
		this.name = name;
		this.app = app;
		this.outSys = outSys;
		this.setCreateTime(new Date());
	
	}

	public GroupType getGroupType() {
		return groupType;
	}
	public void setGroupType(GroupType groupType) {
		this.groupType = groupType;
	}
	public String getGroupCode() {
		return groupCode;
	}
	public void setGroupCode(String groupCode) {
		this.groupCode = groupCode;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getApp() {
		return app;
	}
	public void setApp(String app) {
		this.app = app;
	}
	public boolean isOutSys() {
		return outSys;
	}
	public void setOutSys(boolean outSys) {
		this.outSys = outSys;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public Long getCreateUser() {
		return createUser;
	}
	public void setCreateUser(Long createUser) {
		this.createUser = createUser;
	}
	public Long getAccountId() {
		return accountId;
	}
	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public static enum GroupType{
		Group,GroupAPP;
	}
}
