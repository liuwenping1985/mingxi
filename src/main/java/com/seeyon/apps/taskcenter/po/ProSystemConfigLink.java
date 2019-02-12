package com.seeyon.apps.taskcenter.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;

/**
 * ProSystemConfigLink entity. @author MyEclipse Persistence Tools
 */

public class ProSystemConfigLink extends BasePO {

	// Fields

	private String code;
	private Integer level;
	private String name;
	private String link;
	private Date createTime;
	private String remark;

	// Constructors

	/** default constructor */
	public ProSystemConfigLink() {
	}

	/** minimal constructor */
	public ProSystemConfigLink(Long id, String code, Integer level) {
		this.id = id;
		this.code = code;
		this.level = level;
	}

	/** full constructor */
	public ProSystemConfigLink(Long id, String code, Integer level,
			String name, String link, Date createTime, String remark) {
		this.id = id;
		this.code = code;
		this.level = level;
		this.name = name;
		this.link = link;
		this.createTime = createTime;
		this.remark = remark;
	}

	// Property accessors


	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Integer getLevel() {
		return this.level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLink() {
		return this.link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}