package com.seeyon.apps.taskcenter.bo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cn.com.hkgt.um.vo.AuthorityVO;

import com.seeyon.apps.cinda.authority.domain.UmAuthority;
import com.seeyon.apps.taskcenter.po.ProSenderUrl;
import com.seeyon.ctp.util.Strings;

public class TaskCenterResource implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5449163551597205232L;
	private List<TaskCenterResource> childs = new ArrayList<TaskCenterResource>();
	private Boolean virtualItem = true;
	private Long Id;
	private String code;
	private String name;
	private String url;
	private Date createTime;
	private Date updateTime;
	private Long createUser;
	private Long accountId;
	private Long roleId;
	private String remark;
	private boolean checked =false;
	private int level;  // 第几级
	private int sortId;  // 排序号
	private boolean open = false;
	private String parentcode;

	public String getParentCode(){
		String parentCode= this.code.substring(0, this.code.length()-2);
		return Strings.isBlank(parentCode)?"0":parentCode;
	}
	public void setParentcode(String parentcode) {
		this.parentcode = parentcode;
	}
	public TaskCenterResource(Long id, String code, String name, String url,
			Date createTime, String remark, Integer level) {
		super();
		Id = id;
		this.code = code;
		this.name = name;
		this.url = url;
		this.createTime = createTime;
		this.remark = remark;
		this.level = level==null?code.length():level;
		this.virtualItem = Strings.isBlank(url);
		this.sortId = Integer.parseInt(code);
		this.open = "0".equals(this.getParentCode());
	}
	public TaskCenterResource(UmAuthority po){
		this.Id = Long.parseLong(po.getAuthoritycode());
		this.code = po.getAuthoritycode();
		this.parentcode = po.getParentcode();
		this.name = po.getAuthorityname();
		this.createTime = po.getCreatedate();
		this.url = po.getUrl()==null? "":po.getUrl();
		this.level = po.getLevel();
		this.sortId = Integer.valueOf( po.getAuthoritycode());
		this.virtualItem = Strings.isBlank(url.trim());
	}
	public TaskCenterResource(ProSenderUrl po){
		this.Id = po.getId();
		this.code = po.getCode();
		this.name = po.getName();
		this.createTime = po.getCreateTime();
		this.url = po.getUrl()==null? "":po.getUrl();
		this.createUser = po.getCreateUser();
		this.name = po.getName();
		this.roleId = po.getRoleId();
		this.remark = po.getRemark();
		this.level = Strings.isBlank(po.getCode()) ? 100 : Integer.valueOf(po.getCode().length() / 2);
		this.sortId = Integer.valueOf(po.getCode().substring(0, 2));
		this.virtualItem = Strings.isBlank(url.trim());
	}

	
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public int getSortId() {
		return sortId;
	}
	public void setSortId(int sortId) {
		this.sortId = sortId;
	}
	public Long getId() {
		return Id;
	}
	public void setId(Long id) {
		Id = id;
	}
	public List<TaskCenterResource> getChilds() {
		return childs;
	}
	public void setChilds(List<TaskCenterResource> childs) {
		this.childs = childs;
	}
	public Boolean getVirtualItem() {
		return virtualItem;
	}
	public void setVirtualItem(Boolean virtualItem) {
		this.virtualItem = virtualItem;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
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
	public Long getRoleId() {
		return roleId;
	}
	public void setRoleId(Long roleId) {
		this.roleId = roleId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}

	public boolean isChecked() {
		return checked;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
	public boolean isOpen() {
		return open;
	}
	public void setOpen(boolean open) {
		this.open = open;
	}
	public TaskCenterResource(AuthorityVO vo) {
		super();
		this.virtualItem = Strings.isBlank(vo.getUrl())?true:false;
		Id = Long.parseLong(vo.getAuthorityCode());
		this.code = vo.getAuthorityCode();
		this.name = vo.getAuthorityName();
		this.url = vo.getUrl();
		this.createTime = new Date();
		this.updateTime = new Date();
		this.level = Strings.isBlank(vo.getAuthorityCode()) ? 2 : Integer.valueOf(vo.getAuthorityCode().length() / 2);
		this.sortId = Integer.valueOf(vo.getAuthorityCode().substring(0, 2));
		this.open = "0".equals(this.getParentCode());
		this.parentcode = this.getParentCode();
	}

}
