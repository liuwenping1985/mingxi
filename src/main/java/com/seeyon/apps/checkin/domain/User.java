package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 用户
 * @author yangli
 *
 */
public class User  extends BaseModel implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2555329287967352315L;
	private String userId;
	private String code ;
	private String loginName;
	private String userName;
	private String fullPath;
	private String accountId;//单位ID
	private String orgId; //部门ID
	private String orgName;
	private String path;//部门表中的字段
	
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getFullPath() {
		return fullPath;
	}
	public void setFullPath(String fullPath) {
		this.fullPath = fullPath;
	}
	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	
}
