package com.seeyon.apps.czexchange.util;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmUser;
import com.seeyon.apps.cinda.authority.util.CZDBAgent;
import com.seeyon.apps.czexchange.dao.CzThirdPartOrgDao;
import com.seeyon.apps.dev.doc.dao.CindaUserDao;
import com.seeyon.apps.syncorg.constants.ADConstants;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.exchange.manager.ExchangeAccountManager;

public class CzOrgUtil {

	private static final Log log = LogFactory.getLog(CzOrgUtil.class);
	
	
	private static CzThirdPartOrgDao czThirdPartOrgDao;
	
	
	public static CzThirdPartOrgDao getCzThirdPartOrgDao() {
		if(czThirdPartOrgDao==null){
			czThirdPartOrgDao = (CzThirdPartOrgDao) AppContext.getBean("czThirdPartOrgDao");
		}
		return czThirdPartOrgDao;
	}

	private static ExchangeAccountManager exchangeAccountManager;
	private static CindaUserDao cindaUserDao = getCindaUserDao();
	private static CindaUserDao getCindaUserDao(){
		if(cindaUserDao==null){
			cindaUserDao = (CindaUserDao) AppContext.getBean("cindaUserDao");
		}
		return cindaUserDao;
	}
	public static ExchangeAccountManager getExchangeAccountManager() {
		if(exchangeAccountManager==null){
			exchangeAccountManager = (ExchangeAccountManager) AppContext.getBean("exchangeAccountManager");
		}
		return exchangeAccountManager;
	}

	private static OrgManager orgManager;
	
	public static OrgManager getOrgManager() {
		if(orgManager==null){
			orgManager = (OrgManager) AppContext.getBean("orgManager");
		}
		return orgManager;
	}

	private static GuidMapper guidMapper;
	
	
	public static GuidMapper getGuidMapper() {
		if(guidMapper==null){
			guidMapper = (GuidMapper) AppContext.getBean("guidMapper");
		}
		return guidMapper;
	}
	public static UmUser getUmUserByMemberId(Long memberId){
		UmUser umuser = null;
		try {
			V3xOrgMember member = orgManager.getMemberById(memberId);
			if(member!=null){
				
				umuser = cindaUserDao.getbyLoginNane(member.getLoginName());
			}else{
				umuser = new UmUser();
			}
		} catch (BusinessException e) {
			log.error("",e);
			umuser = new UmUser();
		}
		return umuser;
	}
	public static V3xOrgMember getV3xOrgMemberByumuserId(String umuserId){
		
		V3xOrgMember member = null;
		try {
			UmUser umuser = CZDBAgent.get(UmUser.class, umuserId);
			if(umuser!=null){
				
				member = orgManager.getMemberByLoginName(umuser.getLoginname());
			}else{
				member = new V3xOrgMember();
			}
		} catch (BusinessException e) {
			log.error("",e);
			member = new V3xOrgMember();
		}
		return member;
	}
	public static UmOrganization getUmOrganizationByV3xOrgId(Long v3xEntryId){

			V3xOrgEntity en = null;
			try {
				en = getOrgManager().getEntityAnyType(v3xEntryId);
			} catch (BusinessException e) {
				log.error("",e);
			}
			if(en!=null){
				return cindaUserDao.getOrgByName(en.getName());
			}
			return null;

	}
	public static UmOrganization getUmOrganizationByV3xOrgIdold(Long v3xEntryId){
		String umId = getGuidMapper().getGuid(v3xEntryId, ADConstants.SYN_ACCOUNT);
		if(Strings.isBlank(umId)){
			umId = getGuidMapper().getGuid(v3xEntryId, ADConstants.SYN_DEPARTMENT);
		}
		if(Strings.isBlank(umId)){
			V3xOrgEntity en = null;
			try {
				en = getOrgManager().getEntityAnyType(v3xEntryId);
			} catch (BusinessException e) {
				log.error("",e);
			}
			if(en!=null){
				return cindaUserDao.getOrgByName(en.getName());
			}
		}
		return cindaUserDao.getOrgById(umId);
	}
	public static V3xOrgEntity getV3xOrgEntityByUmOrgId(String umOrgid){
//		Long v3xorgId = null;
//		try {
//			v3xorgId = getGuidMapper().getLocalId(umOrgid, ADConstants.SYN_ACCOUNT);
//			if(v3xorgId==null||v3xorgId==-1L){
//				v3xorgId = getGuidMapper().getLocalId(umOrgid, ADConstants.SYN_DEPARTMENT);
//			}
//			if(v3xorgId!=null && v3xorgId !=-1L){
//				return getOrgManager().getEntityAnyType(v3xorgId);
//			}
//		} catch (BusinessException e1) {
//			log.error("",e1);
//		}
		try {
			UmOrganization um = cindaUserDao.getOrgById(umOrgid);
			V3xOrgEntity en = getOrgManager().getAccountByName(um.getOrganizationname());
			if(en==null) {
				List<V3xOrgDepartment> list = getOrgManager().getDepartmentsByName(um.getOrganizationname(), CurrentUser.get().getAccountId());
				if(list!=null && list.size()>0){
					en = list.get(0);
				}
			}
			if(en!=null){
				return en;
			}
		} catch (BusinessException e) {
			log.error("",e);
		}
		return new V3xOrgAccount();
	}
}
