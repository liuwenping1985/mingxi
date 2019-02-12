package com.seeyon.apps.syncorg.czdomain;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.apps.syncorg.util.MapperUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPrincipal;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.annotations.XStreamAlias;
@XStreamAlias("Member")
public class CzMember {
	
	
	private static final Log log = LogFactory.getLog(CzMember.class);
	
	public V3xOrgMember toV3xOrgMember(boolean isNew) throws CzOrgException {
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		RoleManager roleManager = (RoleManager)AppContext.getBean("roleManager");	
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");			
		V3xOrgMember member = null;
		Long accountId;
		Long oaDepartmentId;
		
		try{
			V3xOrgDepartment v3xDeptObj = orgManager.getDepartmentByCode(departmentId);
			accountId = v3xDeptObj.getOrgAccountId();
			oaDepartmentId = v3xDeptObj.getId();
			
			if(isNew){
				member = new V3xOrgMember();
				member.setCode(userId);
				member.setIdIfNew();
				member.setName(trueName);
				member.setEnabled(true);
				member.setV3xOrgPrincipal(new V3xOrgPrincipal(member.getId(), loginName, "123456"));
				member.setOrgAccountId(accountId);
				member.setOrgDepartmentId(oaDepartmentId);
				if(!Strings.isBlank(otypeCode)){
					List<V3xOrgLevel> lstLevel = orgManager.getAllLevels(accountId);
					for(V3xOrgLevel level : lstLevel){
						if(level.getName().equalsIgnoreCase(otypeCode)){
							member.setOrgLevelId(level.getId());
							break;
						}
					}
				}
				int defaultSortId = 1;
				try {
					defaultSortId = orgManagerDirect.getMaxSortNum(V3xOrgMember.class.getSimpleName(), accountId)+1;
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("700002", e.getMessage());
				}
				member.setSortId(Strings.isBlank(per_sort)? defaultSortId:Long.valueOf(per_sort));
	
				//设置人员默认角色
				log.info("设置人员默认角色开始");
				try {
					V3xOrgRole defultRole = roleManager.getDefultRoleByAccount(accountId);
					if (OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == defultRole.getBond()) {
						orgManagerDirect.addRole2Entity(defultRole.getId(), accountId, member, orgManager.getDepartmentById(oaDepartmentId));
					}else{
						orgManagerDirect.addRole2Entity(defultRole.getId(), accountId, member);
					}
	
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("700002", e.getMessage());
				}
				log.info("设置人员默认角色结束");
			}else{
				member = orgManager.getMemberByCode(userId);
			}
		}catch(Exception e){
			log.error("人员同步错误：", e);
		}

		return member;
		
	}
	public String getAccountCode() {
		return accountCode;
	}
	public void setAccountCode(String accountCode) {
		this.accountCode = accountCode;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getPassWord() {
		return passWord;
	}
	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	public String getStaffNumber() {
		return staffNumber;
	}
	public void setStaffNumber(String staffNumber) {
		this.staffNumber = staffNumber;
	}
	public String getTrueName() {
		return trueName;
	}
	public void setTrueName(String trueName) {
		this.trueName = trueName;
	}
	public String getDeptartmentCode() {
		return departmentCode;
	}
	public void setDeptartmentCode(String deptartmentCode) {
		this.departmentCode = deptartmentCode;
	}
	public String getOcupationCode() {
		return ocupationCode;
	}
	public void setOcupationCode(String ocupationCode) {
		this.ocupationCode = ocupationCode;
	}
	public String getSecondOcupationCodes() {
		return secondOcupationCodes;
	}
	public void setSecondOcupationCodes(String secondOcupationCodes) {
		this.secondOcupationCodes = secondOcupationCodes;
	}
	public String getOtypeCode() {
		return otypeCode;
	}
	public void setOtypeCode(String otypeCode) {
		this.otypeCode = otypeCode;
	}
	public String getFamilyPhone() {
		return familyPhone;
	}
	public void setFamilyPhone(String familyPhone) {
		this.familyPhone = familyPhone;
	}
	public String getOfficePhone() {
		return officePhone;
	}
	public void setOfficePhone(String officePhone) {
		this.officePhone = officePhone;
	}
	public String getMobilePhone() {
		return mobilePhone;
	}
	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

	public String getDiscription() {
		return discription;
	}
	public void setDiscription(String discription) {
		this.discription = discription;
	}
	public String getIdentity() {
		return identity;
	}
	public void setIdentity(String identity) {
		this.identity = identity;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getBirthday() {
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	public String getPer_sort() {
		return per_sort;
	}
	public void setPer_sort(String per_sort) {
		this.per_sort = per_sort;
	}
	
	
	public String getEnabled() {
		return enabled;
	}
	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}


	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}


	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getDepartmentId() {
		return departmentId;
	}
	public void setDepartmentId(String departmentId) {
		this.departmentId = departmentId;
	}


	private String accountCode;
	private String loginName;
	private String code;
	private String userId;  // 第三方系统的用户 ID
	private String passWord;
	private String staffNumber;
	private String trueName;
	private String departmentCode;
	private String departmentId;  // 第三方系统的部门 ID
	private String ocupationCode;
	private String secondOcupationCodes;  // 多个副刚采用 "," 分开的方式
	private String otypeCode;  // 职务级别的编码值
	private String familyPhone;
	private String officePhone;
	private String mobilePhone;
	private String email;
	private String discription;
	private String identity;
	private String sex;  // -1 无性别， 1 男， 2 女
	private String birthday;  // yyyy-mm-dd
	private String per_sort;
	private String enabled;  // 0 停用， 1 启用
	
	// 客户需求， 在修改人员的时候， 要判断出修改了人员的那些属性
	// 下面这个属性用来定义， 哪些属性从 HR 系统中进行同步
	private static String syncFileds = "accountCode,loginName,passWord,staffNumber,trueName,deptartmentCode,ocupationCode,discription";
	
	public static void main(String [] args){
		CzMember member = new CzMember();
		member.setUserId("zjyh001");
		member.setLoginName("登录名");
		member.setTrueName("ZJ子公司用户名添加");
		member.setEmail("abc@abc.abc");
		member.setDepartmentId("12345");
		member.setOtypeCode("zjzw001");
		member.setSex("2");
		member.setPer_sort("01");
		String xml = CzXmlUtil.toXml(member);
		System.out.println(xml);
		System.out.println(JSONObject.toJSONString(CzXmlUtil.toBean(xml, CzMember.class)));
		
	}
}
