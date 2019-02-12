package com.seeyon.apps.taskcenter.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * ProRoleResource entity. @author MyEclipse Persistence Tools
 */

public class ProRoleResource extends BasePO {

	// Fields


	private Long roleid;
	private String roleType;
	private Long resourceId;
	private String remark;

	// Constructors

	/** default constructor */
	public ProRoleResource() {
	}

	/** minimal constructor */
	public ProRoleResource(Long roleid, String roleType,
			Long resourceId) {
		this.setIdIfNew();
		this.roleid = roleid;
		this.roleType = roleType;
		this.resourceId = resourceId;
	}

	/** full constructor */
	public ProRoleResource(Long id, Long roleid, String roleType,
			Long resourceId, String remark) {
		this.id = id;
		this.roleid = roleid;
		this.roleType = roleType;
		this.resourceId = resourceId;
		this.remark = remark;
	}

	// Property accessors



	public Long getRoleid() {
		return this.roleid;
	}

	public void setRoleid(Long roleid) {
		this.roleid = roleid;
	}

	public String getRoleType() {
		return this.roleType;
	}

	public void setRoleType(String roleType) {
		this.roleType = roleType;
	}

	public Long getResourceId() {
		return this.resourceId;
	}

	public void setResourceId(Long resourceId) {
		this.resourceId = resourceId;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}