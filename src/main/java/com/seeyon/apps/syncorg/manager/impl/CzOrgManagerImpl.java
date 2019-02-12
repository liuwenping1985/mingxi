package com.seeyon.apps.syncorg.manager.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.constants.ADConstants;
import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.czdomain.CzMember;
import com.seeyon.apps.syncorg.czdomain.CzPost;
import com.seeyon.apps.syncorg.czdomain.CzReturn;
import com.seeyon.apps.syncorg.enums.ActionTypeEnum;
import com.seeyon.apps.syncorg.enums.ObjectTypeEnum;
import com.seeyon.apps.syncorg.enums.SyncStatusEnum;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.apps.syncorg.log.manager.SyncLogManager;
import com.seeyon.apps.syncorg.manager.CzOrgManager;
import com.seeyon.apps.syncorg.manager.CzOrgOperator;
import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.apps.syncorg.util.CzOrgCheckUtil;
import com.seeyon.apps.syncorg.util.CzVisualUser;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.apps.syncorg.util.MapperUtil;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgPrincipal;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.workflow.engine.enums.ProcessStateEnum.processState;
import com.sun.mail.handlers.message_rfc822;

public class CzOrgManagerImpl implements CzOrgManager {

	private static final Log log = LogFactory.getLog(CzOrgManagerImpl.class);
	
	private CzOrgOperator czOrgOperator;
	public CzOrgOperator getCzOrgOperator() {
		return czOrgOperator;
	}

	public void setCzOrgOperator(CzOrgOperator czOrgOperator) {
		this.czOrgOperator = czOrgOperator;
	}

	private OrgManager orgManager;
	
	public OrgManager getOrgManager() {
		return orgManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	private OrgManagerDirect orgManagerDirect;

	public OrgManagerDirect getOrgManagerDirect() {
		return orgManagerDirect;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}
	
	private SyncLogManager syncLogManager;
	
	public SyncLogManager getSyncLogManager() {
		return syncLogManager;
	}

	public void setSyncLogManager(SyncLogManager syncLogManager) {
		this.syncLogManager = syncLogManager;
	}
	
	private GuidMapper guidMapper;
	
	
	// 下面的程序针对人员的相关方法

	public GuidMapper getGuidMapper() {
		return guidMapper;
	}

	public void setGuidMapper(GuidMapper guidMapper) {
		this.guidMapper = guidMapper;
	}

	@Override
	public CzReturn SyncMember(ActionTypeEnum actionTypeEnum, CzMember czMember,  SyncLog syncLog) throws CzOrgException {
		switch(actionTypeEnum){
		case Add:
			return AddMember(czMember, syncLog);
		case Update:
			return UpdateMember(czMember, syncLog);
		case AddOrUpdate:
			return AddOrUpdateMember(czMember, syncLog);
		case Delete:
			return DeleteMember(czMember, syncLog);
		case Disable:
			return DisableMember(czMember, syncLog);
		case Enable:
			return EnableMember(czMember, syncLog);
		}
		return null;
	}
	
	private CzReturn AddMember(CzMember czMember, SyncLog syncLog) throws CzOrgException {
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
//		boolean codeExist = CzOrgCheckUtil.checkMemberExist(czMember.getAccountCode(), czMember.getCode());
//		if(codeExist){
//			throw new CzOrgException("700008", czMember.getCode());
//		}
		boolean nameExist = CzOrgCheckUtil.checkMemberLoginNameExist(czMember.getLoginName());
		if(nameExist){
			throw new CzOrgException("700006", czMember.getLoginName());
		}
		V3xOrgMember member = czMember.toV3xOrgMember(true);
		if(member == null){
			throw new CzOrgException("同步失败。");
		}
		syncLog.setModifyProperty("全部");
		try {
			OrganizationMessage message = orgManagerDirect.addMember(member);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, member));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("700002", e.getMessage());
		}
	}
	
	private CzReturn UpdateMember(CzMember czMember, SyncLog syncLog) throws CzOrgException{
		V3xOrgMember member = czMember.toV3xOrgMember(false);
		String propertyChangedDesc = CzOrgCheckUtil.updateMemberProperty(member, czMember);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.updateMember(member);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, member));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("700002", e.getMessage());
		}
	}
	
	private CzReturn AddOrUpdateMember(CzMember czMember, SyncLog syncLog) throws CzOrgException{
		//if(CzOrgCheckUtil.checkMemberExist(czMember.getAccountCode(), czMember.getCode())){
		if(CzOrgCheckUtil.checkMemberLoginNameExist(czMember.getLoginName())){
			return UpdateMember(czMember, syncLog);
		}else{
			return AddMember(czMember, syncLog);
		}
	}
	
	private CzReturn DeleteMember(CzMember czMember, SyncLog syncLog) throws CzOrgException{
		// V3xOrgMember member = CzOrgCheckUtil.getMemberByCode(czMember.getAccountCode(), czMember.getCode());
		V3xOrgMember member;
		try {
			member = orgManager.getMemberByLoginName(czMember.getLoginName());
			if(member==null){
				member = MapperUtil.getMemberByMapperBingId(czMember.getUserId());
			}
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("700002", e1.getMessage());
		}
		if(member==null){
			throw new CzOrgException("700002", "没有找到用户UserId="+czMember.getUserId());
		}
		member.setIsDeleted(true);
		try {
			OrganizationMessage message = orgManagerDirect.updateMember(member);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, member));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("700002", e.getMessage());
		}
	}
	
	private CzReturn EnableOrDisableMember(CzMember czMember, SyncLog syncLog, boolean enable) throws CzOrgException{
//		V3xOrgMember member = CzOrgCheckUtil.getMemberByCode(czMember.getAccountCode(), czMember.getCode());
		V3xOrgMember member;
		try {
			member = orgManager.getMemberByLoginName(czMember.getLoginName());
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("700002", e1.getMessage());
		}
		member.setEnabled(enable);
		try {
			OrganizationMessage message = orgManagerDirect.updateMember(member);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, member));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("700002", e.getMessage());
		}
	}
	
	private CzReturn DisableMember(CzMember czMember, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableMember(czMember, syncLog, false);
	}
	
	private CzReturn EnableMember(CzMember czMember, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableMember(czMember, syncLog, true);
	}
	
	// 针对人员的处理程序结束
	
	// 下面的处理程序针对单位

	@Override
	public CzReturn SyncAccount(ActionTypeEnum actionTypeEnum,
			CzAccount czAccount, SyncLog syncLog) throws CzOrgException {
		//add by wfj 20181016  修正数据逻辑  去掉前后空格 _placeholder_phr代表空  start
		
				if(Strings.isNotBlank(czAccount.getParentId())) {
					if("_placeholder_phr".equals(czAccount.getParentId().trim())) {
						czAccount.setParentId(null);
					}else {
						czAccount.setParentId(czAccount.getParentId().trim());
					}
				}
				
				if(Strings.isNotBlank(czAccount.getName())) {
					if("_placeholder_phr".equals(czAccount.getName().trim())) {
						czAccount.setName(null);
					}else {
						czAccount.setName(czAccount.getName().trim());
					}
				}
				
				if(Strings.isNotBlank(czAccount.getThirdAccountId())) {
					if("_placeholder_phr".equals(czAccount.getThirdAccountId().trim())) {
						czAccount.setThirdAccountId(null);
					}else {
						czAccount.setThirdAccountId(czAccount.getThirdAccountId().trim());
					}
				}
				
				
				if(Strings.isNotBlank(czAccount.getSortId())) {
					if("_placeholder_phr".equals(czAccount.getSortId().trim())) {
						czAccount.setSortId("999");
					}else {
						czAccount.setSortId(czAccount.getSortId().trim());
					}
				}
				
				//add by wfj 20181016   end
		// 客户的版本是 A8 企业版， 不存在新建单位的情况
		switch(actionTypeEnum){
		case Add:
			return AddAccount(czAccount, syncLog);
		case Update:
			return UpdateAccount(czAccount, syncLog);
		case AddOrUpdate:
			return AddOrUpdateAccount(czAccount, syncLog);
		case Delete:
			return DeleteAccount(czAccount, syncLog);
		case Disable:
			return DisableAccount(czAccount, syncLog);
		case Enable:
			return EnableAccount(czAccount, syncLog);
		}
		return null;
	}
	
	private CzReturn AddAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
		
//		boolean codeExist = CzOrgCheckUtil.checkAccountExist(czAccount.getCode());
//		if(codeExist){
//			throw new CzOrgException("500007", czAccount.getCode());
//		}
		V3xOrgMember groupAdmin = orgManager.getGroupAdmin();
		CzVisualUser.visualUser(groupAdmin);
		boolean codeExist = CzOrgCheckUtil.checkAccountExistByThirdEnerty(czAccount);
		if(codeExist){
			throw new CzOrgException("500017", "第三方系统的ID 是： " + czAccount.getThirdAccountId());
		}
		
		boolean nameExist = CzOrgCheckUtil.checkAccountNameExist(czAccount.getName());
		if(nameExist){
			throw new CzOrgException("500006", czAccount.getName());
		}
		V3xOrgAccount account = czAccount.toV3xOrgAccount(true);
		
		syncLog.setModifyProperty("全部");
		try {
			// 需要创建一个人员， 这个人员作为单位的管理员
			V3xOrgMember admin = new V3xOrgMember();
			int pos = orgManager.getAllAccounts().size(); 
			String loginName = "admin"+pos;
			while(true){
				try{
					V3xOrgMember tempMember = orgManager.getMemberByLoginName(loginName);
					if(tempMember == null) break;
					pos++;
					loginName = "admin"+pos;
				}catch(Exception e){
					break;
				}
			}
			admin.setIdIfNew();
			admin.setOrgAccountId(account.getId());
			admin.setName(loginName);
			admin.setCode(loginName);
			admin.setV3xOrgPrincipal(new V3xOrgPrincipal(admin.getId(), loginName, "123456"));
			admin.setOrgDepartmentId(-1L);
			admin.setOrgLevelId(-1L);
			admin.setOrgPostId(-1L);
			admin.setIsAdmin(Boolean.valueOf(true));
			admin.setType(Integer.valueOf(OrgConstants.MEMBER_TYPE.FORMAL.ordinal()));
			
			OrganizationMessage message = czOrgOperator.addAccount(account, admin);
			
			if(message.isSuccess()){
				// 增加到 mapper 中
				guidMapper.map(account.getId(), czAccount.getThirdAccountId(), ADConstants.SYN_ACCOUNT);
			}
			DBAgent.commit();
			// 默认新增一个人员待分配部门
			V3xOrgDepartment dept = new V3xOrgDepartment();
			dept.setIdIfNew();
			dept.setOrgAccountId(account.getId());
			dept.setCode("99");
			dept.setName("人员待分配部门");
			dept.setSuperior(account.getId());
			dept.setGroup(false);
			dept.setEnabled(true);
			dept.setSuperiorName("");
			int defaultSortId = orgManagerDirect.getMaxSortNum(V3xOrgDepartment.class.getSimpleName(), account.getId())+1;

			dept.setSortId(Long.valueOf(defaultSortId));
			dept.setIsInternal(true);
			dept.setStatus(1);
			dept.setLevelScope(-1);
			dept.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, account.getId()));
			message = czOrgOperator.addDepartment(dept);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, account));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009", e.getMessage());
		}
	}
	
	private CzReturn UpdateAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
		V3xOrgAccount account = czAccount.toV3xOrgAccount(false);
		String propertyChangedDesc = CzOrgCheckUtil.updateAccountProperty(account, czAccount);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.updateAccount(account);
			
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, account));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009", e.getMessage());
		}
	}
	
	private CzReturn AddOrUpdateAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
//		if(CzOrgCheckUtil.checkAccountExist(czAccount.getCode())){
		if(CzOrgCheckUtil.checkAccountExistByThirdEnerty(czAccount)){
			return UpdateAccount(czAccount, syncLog);
		}else{
			return AddAccount(czAccount, syncLog);
		}
	}
	
	private CzReturn DeleteAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
		// 在调用删除单位ID 的接口的时候, 对方只传递一个 第三方系统的ID, 这个 ID 可能是单位的ID, 也可能是部门的 ID
		// 如果这个 ID 在OA 中从来没有新建或者修改过， 则无法删除这个ID
		// 也就是说， OA 自己新建的单位或者部门， 从来没有同步过， 是不可能通过第三方的接口删除的
		
		// 下面是通过 Code 值获取单位的方法
		// V3xOrgAccount account = CzOrgCheckUtil.getAccountByCode(czAccount.getCode());
		V3xOrgAccount account = MapperUtil.getAccountByMapperBingId(czAccount.getThirdAccountId());
		if(account!=null){
			// 要删除的是一个单文
			account.setIsDeleted(true);
			syncLog.setModifyProperty("删除");
			try {
				OrganizationMessage message = orgManagerDirect.updateAccount(account);
				if(message.isSuccess()){
					return new CzReturn(true, "");
				}else{
					return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, account));
				}
			} catch (BusinessException e) {
				log.error("", e);
				throw new CzOrgException("500009", e.getMessage());
			}
		}else{
			// 要删除的是一个部门
			// 为了避免死循环调用, 在不知道是单位ID 还是部门ID 的情况下, 只能通过调用删除部门的接口来实现
//			CzDepartment czDepartment = new CzDepartment();
//			czDepartment.setDepartmentId(czAccount.getThirdAccountId());
//			syncLog.setObjectTypeEnum(ObjectTypeEnum.Department);
//			return DeleteDepartment(czDepartment, syncLog);
			throw new CzOrgException("500012", "如果不知道是单位还是部门， 请调用删除部门的接口！");
		}

	}
	
	private CzReturn EnableOrDisableAccount(CzAccount czAccount, SyncLog syncLog, boolean enable) throws CzOrgException{
	//	V3xOrgAccount account = CzOrgCheckUtil.getAccountByCode(czAccount.getCode());
		V3xOrgAccount account = CzOrgCheckUtil.getAccountByEnerty(czAccount);
		account.setEnabled(enable);
		syncLog.setModifyProperty(enable?"启用":"停用");
		try {
			OrganizationMessage message = orgManagerDirect.updateAccount(account);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, account));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009", e.getMessage());
		}
	}
	
	private CzReturn DisableAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableAccount(czAccount, syncLog, false);
	}
	
	private CzReturn EnableAccount(CzAccount czAccount, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableAccount(czAccount, syncLog, true);
	}
	
	// 针对单位的处理程序结束
	
	
	// 下面的处理程序针对岗位
	// 客户在改用第三方的 ID 进行唯一区分的时候， 没有提出岗位同步的要求

	@Override
	public CzReturn SyncPost(ActionTypeEnum actionTypeEnum, CzPost czPost, SyncLog syncLog) throws CzOrgException {
		switch(actionTypeEnum){
		case Add:
			return AddPost(czPost, syncLog);
		case Update:
			return UpdatePost(czPost, syncLog);
		case AddOrUpdate:
			return AddOrUpdatePost(czPost, syncLog);
		case Delete:
			return DeletePost(czPost, syncLog);
		case Disable:
			return DisablePost(czPost, syncLog);
		case Enable:
			return EnablePost(czPost, syncLog);
		}
		return null;
	}
	
	private CzReturn AddPost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
		boolean codeExist = CzOrgCheckUtil.checkPostExist(czPost.getAccountCode(), czPost.getCode());
		if(codeExist){
			throw new CzOrgException("800007", czPost.getCode());
		}
		boolean nameExist = CzOrgCheckUtil.checkPostNameExist(czPost.getAccountCode(), czPost.getOcupationName());
		if(nameExist){
			throw new CzOrgException("800006", czPost.getOcupationName());
		}
		V3xOrgPost post = czPost.toV3xOrgPost(true);
		String propertyChangedDesc = CzOrgCheckUtil.updatePostProperty(post, czPost);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.addPost(post);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, post));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("800002", e.getMessage());
		}
	}
	
	private CzReturn UpdatePost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		V3xOrgPost post = czPost.toV3xOrgPost(false);
		String propertyChangedDesc = CzOrgCheckUtil.updatePostProperty(post, czPost);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.updatePost(post);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, post));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("800002", e.getMessage());
		}
	}
	
	private CzReturn AddOrUpdatePost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		if(CzOrgCheckUtil.checkPostExist(czPost.getAccountCode(), czPost.getCode())){
			return UpdatePost(czPost, syncLog);
		}else{
			return AddPost(czPost, syncLog);
		}
	}
	
	private CzReturn DeletePost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		V3xOrgPost post = CzOrgCheckUtil.getPostByCode(czPost.getAccountCode(), czPost.getCode());
		post.setIsDeleted(true);
		syncLog.setModifyProperty("删除");
		try {
			OrganizationMessage message = orgManagerDirect.updatePost(post);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, post));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("800002", e.getMessage());
		}
	}
	
	private CzReturn EnableOrDisablePost(CzPost czPost, SyncLog syncLog, boolean enable) throws CzOrgException{
		V3xOrgPost post = CzOrgCheckUtil.getPostByCode(czPost.getAccountCode(), czPost.getCode());
		post.setEnabled(enable);
		syncLog.setModifyProperty(enable?"启用":"停用");
		try {
			OrganizationMessage message = orgManagerDirect.updatePost(post);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, post));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("800002", e.getMessage());
		}
	}
	
	private CzReturn DisablePost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisablePost(czPost, syncLog, false);
	}
	
	private CzReturn EnablePost(CzPost czPost, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisablePost(czPost, syncLog, true);
	}
	
	// 针对岗位的处理程序结束

	// 下面的处理程序针对部门

	@Override
	public CzReturn SyncDepartment(ActionTypeEnum actionTypeEnum,
			CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException {
		//add by wfj 20181016  修正数据逻辑  去掉前后空格 _placeholder_phr代表空  start
		if(Strings.isNotBlank(czDepartment.getAccountCode())) {
			if("_placeholder_phr".equals(czDepartment.getAccountCode().trim())) {
				czDepartment.setAccountCode(null);
			}else {
			czDepartment.setAccountCode(czDepartment.getAccountCode().trim());
			}
		}
		
		if(Strings.isNotBlank(czDepartment.getDepartmentCode())) {
			if("_placeholder_phr".equals(czDepartment.getDepartmentCode().trim())) {
				czDepartment.setDepartmentCode(null);
			}else {
			czDepartment.setDepartmentCode(czDepartment.getDepartmentCode().trim());
			}
		}
		
		if(Strings.isNotBlank(czDepartment.getDepartmentId())) {
			if("_placeholder_phr".equals(czDepartment.getDepartmentId().trim())) {
				czDepartment.setDepartmentId(null);
			}else {
			czDepartment.setDepartmentId(czDepartment.getDepartmentId().trim());
			}
		}
		
		
		if(Strings.isNotBlank(czDepartment.getDepartmentName())) {
			if("_placeholder_phr".equals(czDepartment.getDepartmentName().trim())) {
				czDepartment.setDepartmentName(null);
			}else {
			czDepartment.setDepartmentName(czDepartment.getDepartmentName().trim());
			}
		}
		
		
		if(Strings.isNotBlank(czDepartment.getDep_sort())) {
			if("_placeholder_phr".equals(czDepartment.getDep_sort().trim())) {
				czDepartment.setDep_sort("999");
			}else {
			czDepartment.setDep_sort(czDepartment.getDep_sort().trim());
			}
		}
		
		
		if(Strings.isNotBlank(czDepartment.getDiscription())) {
			if("_placeholder_phr".equals(czDepartment.getDiscription().trim())) {
				czDepartment.setDiscription(null);
			}else {
			czDepartment.setDiscription(czDepartment.getDiscription().trim());
			}
		}
		
		
		if(Strings.isNotBlank(czDepartment.getParentDepartmentCode())) {
			if("_placeholder_phr".equals(czDepartment.getParentDepartmentCode().trim())) {
				czDepartment.setParentDepartmentCode(null);
			}else {
			czDepartment.setParentDepartmentCode(czDepartment.getParentDepartmentCode().trim());
			}
		}
		if(Strings.isNotBlank(czDepartment.getParentId())) {
			if("_placeholder_phr".equals(czDepartment.getParentId().trim())) {
				czDepartment.setParentId(null);
			}else {
			czDepartment.setParentId(czDepartment.getParentId().trim());
			}
		}
		//add by wfj 20181016   end
		// 确定父部门是单位还是部门
		if(!actionTypeEnum.equals(ActionTypeEnum.Delete)){
			if(Strings.isNotBlank(czDepartment.getParentId())){
				
				V3xOrgAccount account = MapperUtil.getAccountByMapperBingId(czDepartment.getParentId());
				if(account!=null){
					czDepartment.setParentUnitIsAccount(true);
				}else{
					czDepartment.setParentUnitIsAccount(false);
				}
			}else{
				throw new CzOrgException("600014");
			}
		}

		switch(actionTypeEnum){
		case Add:
			return AddDepartment(czDepartment, syncLog);
		case Update:
			return UpdateDepartment(czDepartment, syncLog);
		case AddOrUpdate:
			return AddOrUpdateDepartment(czDepartment, syncLog);
		case Delete:
			return DeleteDepartment(czDepartment, syncLog);
		case Disable:
			return DisableDepartment(czDepartment, syncLog);
		case Enable:
			return EnableDepartment(czDepartment, syncLog);
		}
		return null;
	}
	
	private CzReturn AddDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
//		boolean codeExist = CzOrgCheckUtil.checkDepartmentExist(czDepartment.getAccountCode(), czDepartment.getDepartmentCode());
//		if(codeExist){
//			throw new CzOrgException("600007", czDepartment.getDepartmentCode());
//		}
		boolean codeExist = CzOrgCheckUtil.checkDepartmentExistByEnerty(czDepartment);
		if(codeExist){
			throw new CzOrgException("600003", "第三方系统的部门ID是：" + czDepartment.getDepartmentId());
		}
		boolean nameExist = CzOrgCheckUtil.checkDepartmentNameExistByEnerty(czDepartment);
		if(nameExist){
			throw new CzOrgException("600006", czDepartment.getDepartmentName());
		}
		V3xOrgDepartment department = czDepartment.toV3xOrgDepartment(true);
		syncLog.setModifyProperty("全部");
		try {
			OrganizationMessage message = orgManagerDirect.addDepartment(department);
			if(message.isSuccess()){
				// 增加 mapper 对应表
				guidMapper.map(department.getId(), czDepartment.getDepartmentId(), ADConstants.SYN_DEPARTMENT);
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, department));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600002", e.getMessage());
		}
	}
	
	private CzReturn UpdateDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
		V3xOrgDepartment department = czDepartment.toV3xOrgDepartment(false);
		String propertyChangedDesc = CzOrgCheckUtil.updateDepartmentProperty(department, czDepartment);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.updateDepartment(department);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, department));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600002", e.getMessage());
		}
	}
	
	private CzReturn AddOrUpdateDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
	//	if(CzOrgCheckUtil.checkDepartmentExist(czDepartment.getAccountCode(), czDepartment.getDepartmentCode())){
		if(CzOrgCheckUtil.checkDepartmentExistByEnerty(czDepartment)){
			return UpdateDepartment(czDepartment, syncLog);
		}else{
			return AddDepartment(czDepartment, syncLog);
		}
	}
	
	private CzReturn DeleteDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
		// 在调用删除部门ID 的接口的时候, 对方只传递一个 第三方系统的ID, 这个 ID 可能是单位的ID, 也可能是部门的 ID
		// 如果这个 ID 在OA 中从来没有新建或者修改过， 则无法删除这个ID
		// 也就是说， OA 自己新建的单位或者部门， 从来没有同步过， 是不可能通过第三方的接口删除的
		
		// 下面是通过 Code 值获取单位的方法
		// V3xOrgDepartment department = CzOrgCheckUtil.getDepartmentByCode(czDepartment.getAccountCode(), czDepartment.getDepartmentCode());

		V3xOrgDepartment department = MapperUtil.getDepartmentByMapperBingId(czDepartment.getDepartmentId());
		if(department!=null){
			department.setIsDeleted(true);
			syncLog.setModifyProperty("删除");
			try {
				OrganizationMessage message = orgManagerDirect.updateDepartment(department);
				if(message.isSuccess()){
					return new CzReturn(true, "");
				}else{
					return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, department));
				}
			} catch (BusinessException e) {
				log.error("", e);
				throw new CzOrgException("600002", e.getMessage());
			}
		}else{
			CzAccount czAccount = new CzAccount();
			czAccount.setThirdAccountId(czDepartment.getDepartmentId());
			syncLog.setObjectTypeEnum(ObjectTypeEnum.Account);
			return DeleteAccount(czAccount, syncLog);
		}

	}
	
	private CzReturn EnableOrDisableDepartment(CzDepartment czDepartment, SyncLog syncLog, boolean enable) throws CzOrgException{
		// V3xOrgDepartment department = CzOrgCheckUtil.getDepartmentByCode(czDepartment.getAccountCode(), czDepartment.getDepartmentCode());
		V3xOrgDepartment department = MapperUtil.getDepartmentByEntry(czDepartment);
		department.setEnabled(enable);
		syncLog.setModifyProperty(enable?"启用":"停用");
		try {
			OrganizationMessage message = orgManagerDirect.updateDepartment(department);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, department));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600002", e.getMessage());
		}
	}
	
	private CzReturn DisableDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableDepartment(czDepartment, syncLog, false);
	}
	
	private CzReturn EnableDepartment(CzDepartment czDepartment, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableDepartment(czDepartment, syncLog, true);
	}

	// 针对部门的处理程序结束

	@Override
	public String SyncOne(SyncLog syncLog) {
		CzReturn czReturn = processData(syncLog.getObjectTypeEnum(), syncLog.getActionTypeEnum(), syncLog.getXmlString(), syncLog);
		return czReturn.getSuccess();
	}
	
	
	public CzReturn processData(ObjectTypeEnum objectTypeEnum, ActionTypeEnum actionTypeEnum,  String xmlString, SyncLog syncLog) {
		// 程序执行到这里的时候, 应该是已经通过了数据格式有效性的检查， 可以记录数据库了
		CzReturn czReturn = null;
		
		try{
			switch(objectTypeEnum){
			case Account:
				czReturn = SyncAccount(actionTypeEnum, CzXmlUtil.toBean(xmlString, CzAccount.class), syncLog);
				break;
			case Department:
				czReturn =  SyncDepartment(actionTypeEnum, CzXmlUtil.toBean(xmlString, CzDepartment.class), syncLog);
				break;
			case Member:
				czReturn =  SyncMember(actionTypeEnum, CzXmlUtil.toBean(xmlString, CzMember.class), syncLog);
				break;
			case Post:
				czReturn =  SyncPost(actionTypeEnum, CzXmlUtil.toBean(xmlString, CzPost.class), syncLog);
				break;
			case Level:
				czReturn =  SyncLevel(actionTypeEnum, CzXmlUtil.toBean(xmlString, CzLevel.class), syncLog);
				break;
			default:
				new CzReturn(false, "200001", objectTypeEnum.getText());
			}
			if("true".equals(czReturn.getSuccess().toLowerCase())){
				syncLog.setRetryTimes(syncLog.getRetryTimes()+1);
				syncLog.setErrorMessage(czReturn.getErrorMessage());
				syncLog.setSyncStatusEnum(SyncStatusEnum.Success);
			}else{
				syncLog.setRetryTimes(syncLog.getRetryTimes()+1);
				syncLog.setErrorMessage(czReturn.getErrorMessage());
				syncLog.setSyncStatusEnum(SyncStatusEnum.Failed);
			}
			syncLogManager.update(syncLog);
		}catch(CzOrgException e){
			czReturn = new CzReturn(false, e.getErrorCode(), e.getExtMessage());
			syncLog.setRetryTimes(syncLog.getRetryTimes()+1);
			syncLog.setErrorMessage(czReturn.getErrorMessage());
			syncLog.setSyncStatusEnum(SyncStatusEnum.Failed);
			syncLogManager.update(syncLog);
		}

		
		return czReturn;
	}

	

	// 下面的程序都是对职务级别的处理
	
	@Override
	public CzReturn SyncLevel(ActionTypeEnum actionTypeEnum, CzLevel czLevel, SyncLog syncLog) throws CzOrgException {
		switch(actionTypeEnum){
		case Add:
			return AddLevel(czLevel, syncLog);
		case Update:
			return UpdateLevel(czLevel, syncLog);
		case AddOrUpdate:
			return AddOrUpdateLevel(czLevel, syncLog);
		case Delete:
			return DeleteLevel(czLevel, syncLog);
		case Disable:
			return DisableLevel(czLevel, syncLog);
		case Enable:
			return EnableLevel(czLevel, syncLog);
		}
		return null;
	}
	private CzReturn AddLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
//		boolean codeExist = CzOrgCheckUtil.checkLevelExist(czLevel.getAccountCode(), czLevel.getCode());
//		if(codeExist){
//			throw new CzOrgException("900007", czLevel.getCode());
//		}
		// 第三方系统中, 职务级别是不区分单位的， 所以在处理职务级别的时候, 要对所有的单位进行循环
		CzReturn czReturn = null;
		List<V3xOrgAccount> listAllAccount = null;
		try {
			listAllAccount = orgManager.getAllAccounts();
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("900002");
		}
		if(listAllAccount!=null&&listAllAccount.size()>0){
			for(V3xOrgAccount account : listAllAccount){
				czLevel.setAccountId(String.valueOf(account.getId()));
				czReturn = AddLevel4OneAccount(czLevel, account.getId(), syncLog);
			}
		}else{
			throw new CzOrgException("500003");
		}
		return czReturn;
	}
	
	private CzReturn AddLevel4OneAccount(CzLevel czLevel, Long accountId, SyncLog syncLog) throws CzOrgException{
		boolean nameExist = CzOrgCheckUtil.checkLevelExistByEnertyAndAccountId(czLevel, accountId);
		if(nameExist){
			throw new CzOrgException("900006", czLevel.getName());
		}
		czLevel.setAccountId(String.valueOf(accountId));
		V3xOrgLevel level = czLevel.toV3xOrgLevel(true);
//		String propertyChangedDesc = CzOrgCheckUtil.updateLevelProperty(level, czLevel);
		syncLog.setModifyProperty("全部");
		try {
			OrganizationMessage message = orgManagerDirect.addLevel(level);
			if(message.isSuccess()){
				// 增加到 mapper
				guidMapper.map(level.getId(), czLevel.getThirdId()+"_"+accountId, ADConstants.SYN_LEVEL);
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, level));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("900002", e.getMessage());
		}


	}
	
	private CzReturn UpdateLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
		CzReturn czReturn = null;
		List<V3xOrgAccount> listAllAccount = null;
		try {
			listAllAccount = orgManager.getAllAccounts();
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("900002");
		}
		if(listAllAccount!=null&&listAllAccount.size()>0){
			for(V3xOrgAccount account : listAllAccount){
				czLevel.setAccountId(String.valueOf(account.getId()));
				czReturn =UpdateLevel4OneAccount(czLevel, account.getId(), syncLog);
			}
		}
		return czReturn;
	}
	private CzReturn UpdateLevel4OneAccount(CzLevel czLevel, Long accountId, SyncLog syncLog) throws CzOrgException{
		czLevel.setAccountId(String.valueOf(accountId));
		V3xOrgLevel level = czLevel.toV3xOrgLevel(false);
		//未知原因造成的找不到，更新失败问题
		if(czLevel.isIsnew()){
			return this.AddLevel4OneAccount(czLevel, accountId, syncLog);
		}
		String propertyChangedDesc = CzOrgCheckUtil.updateLevelProperty(level, czLevel);
		syncLog.setModifyProperty(propertyChangedDesc);
		try {
			OrganizationMessage message = orgManagerDirect.updateLevel(level);
			if(message.isSuccess()){
				return new CzReturn(true, "");
			}else{
				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, level));
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("900002", e.getMessage());
		}


	}
	
	private CzReturn AddOrUpdateLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		// 如果根据 code 值查找， 没有找到的话， 程序就判断成了新增的状态了， 下面主要是对于职务级别的名称进行检查
		CzReturn czReturn = null;
		List<V3xOrgAccount> listAllAccount = null;
		try {
			listAllAccount = orgManager.getAllAccounts();
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("900002");
		}
		if(listAllAccount!=null&&listAllAccount.size()>0){
			for(V3xOrgAccount account : listAllAccount){
				czLevel.setAccountId(String.valueOf(account.getId()));
				if(CzOrgCheckUtil.checkLevelExistByEnertyAndAccountId(czLevel, account.getId())){
					czReturn = UpdateLevel4OneAccount(czLevel, account.getId(), syncLog);
				}else{
					czReturn = AddLevel4OneAccount(czLevel, account.getId(), syncLog);
				}
			}
		}
		return czReturn;

	}
	
	private CzReturn DeleteLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		//V3xOrgLevel level = CzOrgCheckUtil.getLevelByCode(czLevel.getAccountCode(), czLevel.getCode());
		CzReturn czReturn = null;
		List<V3xOrgAccount> listAllAccount = null;
		try {
			listAllAccount = orgManager.getAllAccounts();
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("900002");
		}
		if(listAllAccount!=null&&listAllAccount.size()>0){
			for(V3xOrgAccount account : listAllAccount){
				czLevel.setAccountId(String.valueOf(account.getId()));
				V3xOrgLevel level = MapperUtil.getLevelByEnerty(czLevel, account.getId());
				level.setIsDeleted(true);
				try {
					OrganizationMessage message = orgManagerDirect.updateLevel(level);
					if(message.isSuccess()){
						czReturn = new CzReturn(true, "");
					}else{
						czReturn = new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, level));
					}
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("900002", e.getMessage());
				}
			}
		}
		return czReturn;
	}
	
	private CzReturn EnableOrDisableLevel(CzLevel czLevel, SyncLog syncLog, boolean enable) throws CzOrgException{
//		V3xOrgLevel level = CzOrgCheckUtil.getLevelByCode(czLevel.getAccountCode(), czLevel.getCode());
//		level.setEnabled(enable);
//		try {
//			OrganizationMessage message = orgManagerDirect.updateLevel(level);
//			if(message.isSuccess()){
//				return new CzReturn(true, "");
//			}else{
//				return new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, level));
//			}
//		} catch (BusinessException e) {
//			log.error("", e);
//			throw new CzOrgException("900002", e.getMessage());
//		}
		
		CzReturn czReturn = null;
		List<V3xOrgAccount> listAllAccount = null;
		try {
			listAllAccount = orgManager.getAllAccounts();
		} catch (BusinessException e1) {
			log.error("", e1);
			throw new CzOrgException("900002");
		}
		if(listAllAccount!=null&&listAllAccount.size()>0){
			for(V3xOrgAccount account : listAllAccount){
				czLevel.setAccountId(String.valueOf(account.getId()));
				V3xOrgLevel level = MapperUtil.getLevelByEnerty(czLevel, account.getId());
				level.setEnabled(enable);
				try {
					OrganizationMessage message = orgManagerDirect.updateLevel(level);
					if(message.isSuccess()){
						czReturn = new CzReturn(true, "");
					}else{
						czReturn = new CzReturn(false, CzOrgCheckUtil.getErrorMessage(message, level));
					}
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("900002", e.getMessage());
				}
			}
		}
		return czReturn;
	}
	
	private CzReturn DisableLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableLevel(czLevel, syncLog, false);
	}
	
	private CzReturn EnableLevel(CzLevel czLevel, SyncLog syncLog) throws CzOrgException{
		return EnableOrDisableLevel(czLevel, syncLog, true);
	}



}
