package com.seeyon.apps.syncorg.czdomain;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.apps.syncorg.util.MapperUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.annotations.XStreamAlias;
@XStreamAlias("Department")
public class CzDepartment {
	

	
	public V3xOrgDepartment toV3xOrgDepartment(boolean isNew) throws CzOrgException{

		V3xOrgDepartment department = null;
		if(isNew){
			department = new V3xOrgDepartment();
			department.setCode(this.departmentCode);
			department.setIdIfNew();
			department.setOrgAccountId(MapperUtil.getAccountByDepartmentEnerty(this).getId());
			department.setName(departmentName);
			department.setDescription(discription);
			department.setShortName(departmentName);
			department.setSecondName(departmentName);
			if(CzOrgCheckUtil.needCheckCode){
				if(parentDepartmentCode.equals(accountCode)||Strings.isBlank(parentDepartmentCode)){
				// 处理根部门的情况
				V3xOrgAccount account = CzOrgCheckUtil.getAccountByCode(accountCode);
				department.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, account.getId()));
			}else{
				// 处理非根部门的情况
				V3xOrgDepartment parentDepartment = CzOrgCheckUtil.getDepartmentByCode(accountCode, parentDepartmentCode);
				// 设置新建部门的部门级别
				department.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, parentDepartment.getId()));
			}

			}else{
				if(MapperUtil.getAccountByMapperBingId(parentId)!=null){
					// 上级部门是一个单位
					V3xOrgAccount account = MapperUtil.getAccountByMapperBingId(parentId);
					department.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, account.getId()));
				}else{
					// 上级部门是部门
					V3xOrgDepartment parentDepartment = MapperUtil.getDepartmentByMapperBingId(parentId);
					// 设置新建部门的部门级别
					department.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, parentDepartment.getId()));
				}
			}

		}else{
			// 部门在 OA 中已经存在了
			department = MapperUtil.getDepartmentByMapperBingId(departmentId);
			// department = CzOrgCheckUtil.getDepartmentByCode(accountCode, departmentCode);
		}
		
		return department;
		
	}
	public String getAccountCode() {
		return accountCode;
	}
	public void setAccountCode(String accountCode) {
		this.accountCode = accountCode;
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	public String getDepartmentCode() {
		return departmentCode;
	}
	public void setDepartmentCode(String departmentCode) {
		this.departmentCode = departmentCode;
	}

	public String getDiscription() {
		return discription;
	}
	public void setDiscription(String discription) {
		this.discription = discription;
	}
	public String getDep_sort() {
		return dep_sort;
	}
	public void setDep_sort(String dep_sort) {
		this.dep_sort = dep_sort;
	}
	public String getParentDepartmentCode() {
		return parentDepartmentCode;
	}
	public void setParentDepartmentCode(String parentDepartmentCode) {
		this.parentDepartmentCode = parentDepartmentCode;
	}
	
	
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getDepartmentId() {
		return departmentId;
	}
	public void setDepartmentId(String departmentId) {
		this.departmentId = departmentId;
	}


	public boolean isParentUnitIsAccount() {
		return parentUnitIsAccount;
	}
	public void setParentUnitIsAccount(boolean parentUnitIsAccount) {
		this.parentUnitIsAccount = parentUnitIsAccount;
	}


	private String accountCode;
	private String departmentId;  // 第三方系统中的 ID
	private String departmentName;
	private String departmentCode;
	private String discription;
	private String dep_sort;
	
	// 程序内部使用的属性， 用来记录第三方给的父部门Id 在  OA 中是一个单位还是一个部门
	private boolean parentUnitIsAccount = false;
	
	// 2016-11-05 客户要求去掉原来的按照部门名字的全路径给出相关的部门级别， 改用父部们的部门编码	确定部分的位置
	private String parentDepartmentCode;
	
	// 第三方系统推送过来的付部门的 ID, 这个推送过来的部门， 对方系统一定能够保证是部门， 但是， 部门的父部门ID， 有两种可能性， 一种是付部门的ID， 另一种是单位的ID
	private String parentId;
	
	
	
	// 客户需求， 在修改岗位的时候， 要判断出修改了部门的那些属性
	// 下面这个属性用来定义， 哪些属性从 HR 系统中进行同步
	private static String syncFileds = "accountCode,departmentName,discription,dep_sort"; 
	
	public static void main(String [] args){
		CzDepartment department = new CzDepartment();
		department.setAccountCode("001");
		department.setDep_sort("2");
		department.setDepartmentCode("001002");
		department.setDepartmentName("测试部门");  // 这个是一个全路径， 每级部门的名称用 / 分开
		department.setDiscription("用来测试的第一部门");
		
		System.out.println(CzXmlUtil.toXml(department));
		
	}
	
}
