package com.seeyon.apps.syncorg.czdomain;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.MapperUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.annotations.XStreamAlias;
@XStreamAlias("Account")
public class CzAccount {
	
	private static final Log log = LogFactory.getLog(CzAccount.class); 

	private static Long groupId = -1730833917365171641l;
	public V3xOrgAccount toV3xOrgAccount(boolean isNew) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		V3xOrgAccount account = null;
		if(isNew){
			// 首先获得上级单位
			V3xOrgAccount parentAccount;
			// 从对照表中查看 parentId 是否存在
			parentAccount = MapperUtil.getAccountByMapperBingId(parentId);
			if(parentAccount == null){
				// 如果不存在, 则直接建到集团下面
				try {
					parentAccount = orgManager.getRootAccount();
				} catch (BusinessException e1) {
					log.error("", e1);
					throw new CzOrgException("500009", e1.getMessage());
				}
			}

			Long superior = parentAccount.getId();
			
			account = new V3xOrgAccount();
			account.setIdIfNew();
			account.setName(name);
			account.setCode(Strings.isBlank(code)? name:code);
			

			account.setOrgAccountId(account.getId());
			account.setSuperiorName(parentAccount.getName());
			account.setSuperior(superior);
			account.setShortName(name);
			
			int defaultSortId = 1;
			try {
				defaultSortId = orgManagerDirect.getMaxSortNum(V3xOrgAccount.class.getSimpleName(), account.getId())+1;
			} catch (BusinessException e) {
				log.error("", e);
				throw new CzOrgException("500009", e.getMessage());
			}
			account.setSortId(Strings.isBlank(sortId)? defaultSortId:Long.valueOf(sortId));

			account.setDescription(discription);
			account.setGroup(false);
			account.setPath(OrgHelper.getPathByPid4Add(V3xOrgAccount.class, superior));	
			
			
		}else{
			
			// account = CzOrgCheckUtil.getAccountByCode(code);
			// 如果不是新的单位, 则根据第三方的Id 获得单位
			account = MapperUtil.getAccountByMapperBingId(thirdAccountId);
			if(account==null){
				throw  new CzOrgException("500012", "第三方的单位ID 是 ： " + thirdAccountId);
			}
			return account;
		}
		

		return account;
	}
	
	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getSortId() {
		return sortId;
	}
	public void setSortId(String sortId) {
		this.sortId = sortId;
	}

	public String getDiscription() {
		return discription;
	}
	public void setDiscription(String discription) {
		this.discription = discription;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSecondName() {
		return secondName;
	}
	public void setSecondName(String secondName) {
		this.secondName = secondName;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getShortName() {
		return shortName;
	}
	public void setShortName(String shortName) {
		this.shortName = shortName;
	}
	public String getIsEnabled() {
		return isEnabled;
	}
	public void setIsEnabled(String isEnabled) {
		this.isEnabled = isEnabled;
	}
	public String getPerson() {
		return person;
	}
	public void setPerson(String person) {
		this.person = person;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCtrPhone() {
		return ctrPhone;
	}
	public void setCtrPhone(String ctrPhone) {
		this.ctrPhone = ctrPhone;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getuType() {
		return uType;
	}
	public void setuType(String uType) {
		this.uType = uType;
	}
	public String getParentUnitCode() {
		return parentUnitCode;
	}
	public void setParentUnitCode(String parentUnitCode) {
		this.parentUnitCode = parentUnitCode;
	}
	public String getAdminLoginName() {
		return adminLoginName;
	}
	public void setAdminLoginName(String adminLoginName) {
		this.adminLoginName = adminLoginName;
	}
	public String getAdminPassword() {
		return adminPassword;
	}
	public void setAdminPassword(String adminPassword) {
		this.adminPassword = adminPassword;
	}
	public String getIsCopy() {
		return isCopy;
	}
	public void setIsCopy(String isCopy) {
		this.isCopy = isCopy;
	}
	
	
	public String getThirdAccountId() {
		return thirdAccountId;
	}

	public void setThirdAccountId(String thirdAccountId) {
		this.thirdAccountId = thirdAccountId;
	}


	private String sortId;
	private String discription;
	private String name;
	private String secondName;
	private String code;
	private String thirdAccountId;
	private String shortName;
	private String isEnabled;
	private String person;
	private String zip;
	private String address;
	private String ctrPhone;
	private String fax;
	private String url;
	private String uType;  // 单位类型
	private String parentUnitCode;
	private String adminLoginName;
	private String adminPassword;
	private String isCopy;  // 是否复制职务级别
	private String parentId;
	
	// 客户需求， 在修改岗位的时候， 要判断出修改了单位的那些属性
	// 下面这个属性用来定义， 哪些属性从 HR 系统中进行同步
	private static String syncFileds = "discription,name,secondName,shortName,isEnabled"; 
	
	
	
	
}
