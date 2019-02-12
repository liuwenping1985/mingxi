package com.seeyon.apps.taskcenter.po;

import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;

/**
 * ProSenderUrl entity. @author MyEclipse Persistence Tools
 */

public class ProSenderUrl extends BasePO implements Comparable<ProSenderUrl>{


	private String code;
	private String name;
	private String url;
	private Date createTime;
	private Date updateTime;
	private Long createUser;
	private Long accountId;
	private Long roleId;
	private String remark;
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
	@Override
	public int compareTo(ProSenderUrl o) {
		int oSort = Integer.valueOf((o.getCode()));
		int thisSort = Integer.valueOf((this.getCode()));
		if(oSort<thisSort) return 1;
		return -1;
		/*
		int level = Integer.valueOf((o.getCode().substring(0, 2)));
		int thisLevel = Integer.valueOf((this.getCode().substring(0, 2)));
		if(level!=thisLevel){
			return level>thisLevel?1:-1;
		}else{
			// 比较二级编码
			if(o.getCode().length()==2){
				
			}
			int secondLevel = Integer.valueOf((o.getCode().substring(2, 4)));
			int thissecondLevel = Integer.valueOf((this.getCode().substring(2, 4)));
			if(secondLevel!=thissecondLevel){
				return secondLevel>thissecondLevel?1:-1;
			}else{
				// 比较三级
				int thirdLevel = Integer.valueOf((o.getCode().substring(4, 6)));
				int thisthirdLevel = Integer.valueOf((this.getCode().substring(4, 6)));
				return thirdLevel > thisthirdLevel ? 1:-1;
			}
		}
		*/
	}

	
	public static void main(String [] args){
		String s = "010203";
		String s1 = s.substring(0, 2);
		String s2 = s.substring(2,4);
		String s3 = s.substring(4,6);
		System.out.println(s1);
		System.out.println(s2);
		System.out.println(s3);
		System.out.println(Integer.valueOf(s3));
	}


}