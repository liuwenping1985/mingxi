package com.seeyon.apps.syncorg.czdomain;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.Strings;
import com.thoughtworks.xstream.annotations.XStreamAlias;
@XStreamAlias("Post")
public class CzPost {
	
	private static Log log = LogFactory.getLog(CzPost.class);
	public V3xOrgPost toV3xOrgPost(boolean isNew) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect) AppContext.getBean("orgManagerDirect");
		
		V3xOrgPost post = null;
		Long accountId = CzOrgCheckUtil.getAccountByCode(this.accountCode).getId();
		if(isNew){
			post = new V3xOrgPost();
			post.setCode(this.code);
			post.setTypeId(Long.valueOf(V3xOrgPost.ROLETYPE_FIXROLE));
			try {
				post.setSortId(Strings.isBlank(this.sortId)? orgManagerDirect.getMaxSortNum(V3xOrgPost.class.getSimpleName(), accountId)+1: Long.valueOf(sortId));
			} catch (NumberFormatException e) {
				log.error("", e);
			} catch (BusinessException e) {
				log.error("", e);
			}
			post.setIdIfNew();
		}else{
			post = CzOrgCheckUtil.getPostByCode(accountCode, code);
		}

		// private String departmentCodes;  // 关联的部门编码， 用 “,” 分开
		return post;
	}

	public String getAccountCode() {
		return accountCode;
	}
	public void setAccountCode(String accountCode) {
		this.accountCode = accountCode;
	}
	public String getOcupationName() {
		return ocupationName;
	}
	public void setOcupationName(String ocupationName) {
		this.ocupationName = ocupationName;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getSortId() {
		return sortId;
	}
	public void setSortId(String sortId) {
		this.sortId = sortId;
	}
	public String getDepartmentCodes() {
		return departmentCodes;
	}
	public void setDepartmentCodes(String departmentCodes) {
		this.departmentCodes = departmentCodes;
	}

	public String getDiscription() {
		return discription;
	}
	public void setDiscription(String discription) {
		this.discription = discription;
	}

	private String accountCode;
	private String ocupationName;
	private String code;
	private String sortId;           // 整数
	private String departmentCodes;  // 关联的部门编码， 用 “,” 分开
	private String discription;
	
	
	// 客户需求， 在修改岗位的时候， 要判断出修改了岗位的那些属性
	// 下面这个属性用来定义， 哪些属性从 HR 系统中进行同步
	private static String syncFileds = "accountCode,ocupationName,sortId,departmentCodes,discription"; 

	
	public static void main(String [] args){
		CzPost post = new CzPost();
		post.setAccountCode("001");
		post.setCode("post001");
		post.setDiscription("第一岗位描述");
		post.setOcupationName("第一岗位");
		post.setSortId("1");
		
		System.out.println(CzXmlUtil.toXml(post));
		
		
	}
}
