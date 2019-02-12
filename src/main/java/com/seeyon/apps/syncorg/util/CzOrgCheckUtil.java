package com.seeyon.apps.syncorg.util;

import static com.seeyon.apps.syncorg.constants.ADConstants.SYN_DEPARTMENT;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.czdomain.CzMember;
import com.seeyon.apps.syncorg.czdomain.CzPost;
import com.seeyon.apps.syncorg.enums.MemberPropertiesKey;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.idmapper.MapperException;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.OrganizationMessage.OrgMessage;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgPrincipal;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;


public class CzOrgCheckUtil {
	
	private static final Log log = LogFactory.getLog(CzOrgCheckUtil.class);
	public static final boolean needCheckCode = false;
	public static void checkCode(String code) throws CzOrgException{
		// 用户新修改的需求， 单位编码不作为唯一区分的字段了，  去掉了检验
		if(needCheckCode&&Strings.isBlank(code)){
			throw new CzOrgException("300001");
		}
	}
	
	public static void checkAccountCode(String code) throws CzOrgException{
		// 用户新修改的需求， 单位编码不作为唯一区分的字段了，  去掉了检验
		if(needCheckCode&&Strings.isBlank(code)){
			throw new CzOrgException("500001");
		}
	}
	
	public static V3xOrgAccount getAccountByCode(String accountCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgAccount> listAccounts = null;
		try {
			listAccounts = orgManager.getAllAccounts();
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500004", e.getMessage());
		}
		if(listAccounts!=null&&listAccounts.size()>0){
			for(V3xOrgAccount account : listAccounts){
				if(accountCode.equals(account.getCode())){
					return account;
				}
			}
			throw new CzOrgException("500002", accountCode);
		}
		throw new CzOrgException("500003");
	}
	
	public static V3xOrgAccount getAccountByEnerty(CzAccount czAccount) throws CzOrgException{
		V3xOrgAccount account = MapperUtil.getAccountByEntry(czAccount);
		if(account==null){
			throw new CzOrgException("500012", "单位的第三方ID 是 ： " + czAccount.getThirdAccountId());
		}
		return account;
	}
	
	
	
	public static V3xOrgPost getPostByCode(String accountCode, String postCode) throws CzOrgException{
		List<V3xOrgPost> listPosts = null;
		listPosts = getAllPostsByAccount(accountCode, true);
		if(listPosts!=null&&listPosts.size()>0){
			for(V3xOrgPost post : listPosts){
				if(postCode.equals(post.getCode())){
					return post;
				}
			}
			throw new CzOrgException("800003", postCode);
		}
		throw new CzOrgException("800004");
	}
	
	public static V3xOrgLevel getLevelByjtId(String jtaccountId, String levelId) throws CzOrgException{
		List<V3xOrgLevel> listLevels = null;
		listLevels = getAllLevelsByAccount(jtaccountId, true);
		if(listLevels!=null&&listLevels.size()>0){
			for(V3xOrgLevel level : listLevels){
				if(levelId.equals(level.getCode())){
					return level;
				}
			}
			throw new CzOrgException("900003", levelId);
		}
		throw new CzOrgException("900004");
	}
	
	public static V3xOrgMember getMemberByCode(String accountCode, String memberCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");

		List<V3xOrgMember> listMembers = null;
		listMembers = getAllMembersByAccount(accountCode, true);
		if(listMembers!=null&&listMembers.size()>0){
			for(V3xOrgMember member : listMembers){
				if(memberCode.equals(member.getCode())){
					return member;
				}
			}
			throw new CzOrgException("700003", memberCode);
		}
		throw new CzOrgException("700004");
	}
	
	public static V3xOrgLevel getDefaultLevel(String accountCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		
	    String defaultLeveltName = AppContext.getSystemProperty("syncorg.oaparameters.default_level_name");
	    if(Strings.isBlank(defaultLeveltName)){
	    	defaultLeveltName = "员工";
	    }
		V3xOrgLevel memberLevel =  null;
		if(accountCode!=null &&Strings.isNotBlank(defaultLeveltName)){
			List<V3xOrgLevel> list = null;
			list = getAllLevelsByAccount(accountCode, true);
			if(list!=null && list.size() >0 ){
				for (V3xOrgLevel tmpLevel : list) {
					if(tmpLevel.getName().equals(defaultLeveltName)){
						memberLevel = tmpLevel;
						break;
					}
				}
			}
			if(memberLevel==null){
				// 新建一个缺省的职务级别
				memberLevel = new V3xOrgLevel();
				memberLevel.setIdIfNew();
				memberLevel.setCode("");
				memberLevel.setName(defaultLeveltName);
				memberLevel.setOrgAccountId(getAccountByCode(accountCode).getId());
				memberLevel.setEnabled(true);
				memberLevel.setSortId(100L);
				memberLevel.setLevelId(100);
				memberLevel.setIsDeleted(false);
				try {
					orgManagerDirect.addLevel(memberLevel);
				} catch (BusinessException e) {
					log.error("", e);
				}
			}
		
		}
		return memberLevel;
}

	
	public static V3xOrgPost getDefaultPost(String accountCode) throws CzOrgException{
			OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
			OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
			
		    String defaultPostName = AppContext.getSystemProperty("syncorg.oaparameters.default_post_name");
		    if(Strings.isBlank(defaultPostName)){
		    	defaultPostName = "员工";
		    }
			V3xOrgPost memberPost =  null;
			if(accountCode!=null &&Strings.isNotBlank(defaultPostName)){
				List<V3xOrgPost> list = null;
				list = getAllPostsByAccount(accountCode, true);
				if(list!=null && list.size() >0 ){
					for (V3xOrgPost tmpPost : list) {
						if(tmpPost.getName().equals(defaultPostName)){
							memberPost = tmpPost;
							break;
						}
					}
				}
				if(memberPost==null){
					// 新建一个缺省的岗位
					memberPost = new V3xOrgPost();
					memberPost.setIdIfNew();
					memberPost.setCode("");
					memberPost.setName(defaultPostName);
					memberPost.setOrgAccountId(getAccountByCode(accountCode).getId());
					memberPost.setEnabled(true);
					memberPost.setSortId(100L);
					memberPost.setTypeId(5L);
					memberPost.setIsDeleted(false);
					try {
						orgManagerDirect.addPost(memberPost);
					} catch (BusinessException e) {
						log.error("", e);
					}
				}
			
			}
			return memberPost;
	}
	
	public static boolean checkPostExist(String accountCode, String postCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgPost> listPosts = null;
		listPosts = getAllPostsByAccount(accountCode, true);
		if(listPosts!=null&&listPosts.size()>0){
			for(V3xOrgPost post : listPosts){
				if(postCode.equals(post.getCode())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	public static boolean checkLevelExist(String accountCode, String levelCode) throws CzOrgException{

		List<V3xOrgLevel> listLevels = null;
		listLevels = getAllLevelsByAccount(accountCode, true);
		if(listLevels!=null&&listLevels.size()>0){
			for(V3xOrgLevel level : listLevels){
				if(levelCode.equals(level.getCode())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	
	
	public static List<V3xOrgPost> getAllPostsByAccount(String accountCode, boolean includeDisable) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		V3xOrgAccount account = getAccountByCode(accountCode);
		List<V3xOrgPost> listPosts = null;
		try {
			listPosts = orgManagerDirect.getAllPosts(account.getId(), true);
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("800005", e.getMessage());
		}
		
		return listPosts;
	}
	
	public static List<V3xOrgLevel> getAllLevelsByAccount(String maperedId, boolean includeDisable) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		V3xOrgAccount account = MapperUtil.getAccountByMapperBingId(maperedId);
		if(account==null){
			
			V3xOrgDepartment dept = MapperUtil.getDepartmentByMapperBingId(maperedId);
			if(dept!=null){
				try {
					account = OrgHelper.getOrgManager().getAccountById(dept.getOrgAccountId());
				} catch (BusinessException e) {
					log.error("",e);
				}
			}
		}
		List<V3xOrgLevel> listLevels = null;
		if(account!=null){
			try {
				listLevels = orgManagerDirect.getAllLevels(account.getId(), true);
			} catch (BusinessException e) {
				log.error("", e);
				throw new CzOrgException("900005", e.getMessage());
			}
		}else{
			throw new CzOrgException("900005","没有找到ID="+maperedId+"的部门！");
		}
		return listLevels;
	}
	
	public static List<V3xOrgDepartment> getAllDepartmentsByThirdAccountId(String thirdAccountId, boolean includeDisable) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		V3xOrgAccount account = MapperUtil.getAccountByMapperBingId(thirdAccountId);
		List<V3xOrgDepartment> listDepartments = new ArrayList();
		try {
			FlipInfo flipInfo = new FlipInfo();
			flipInfo.setNeedTotal(false);
			flipInfo.setPage(1);
			flipInfo.setSize(Integer.MAX_VALUE);
			// 查询出所有启用的， 内部部门
			List<V3xOrgDepartment> listDepartments_enable = orgManagerDirect.getAllDepartments(account.getId(), true, true, null, null, flipInfo);
			if(listDepartments_enable!=null&&listDepartments_enable.size()>0){
				listDepartments.addAll(listDepartments_enable);
			}
			// 查询出所有停用的部门
			List<V3xOrgDepartment> listDepartments_disable = orgManagerDirect.getAllDepartments(account.getId(), false, true, null, null, flipInfo);
			if(listDepartments_disable!=null&&listDepartments_disable.size()>0){
				listDepartments.addAll(listDepartments_disable);
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600005", e.getMessage());
		}
		
		return listDepartments;
	}

	
	public static List<V3xOrgDepartment> getAllDepartmentsByAccount(String accountCode, boolean includeDisable) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		V3xOrgAccount account = getAccountByCode(accountCode);
		List<V3xOrgDepartment> listDepartments = new ArrayList();
		try {
			FlipInfo flipInfo = new FlipInfo();
			flipInfo.setNeedTotal(false);
			flipInfo.setPage(1);
			flipInfo.setSize(Integer.MAX_VALUE);
			// 查询出所有启用的， 内部部门
			List<V3xOrgDepartment> listDepartments_enable = orgManagerDirect.getAllDepartments(account.getId(), true, true, null, null, flipInfo);
			if(listDepartments_enable!=null&&listDepartments_enable.size()>0){
				listDepartments.addAll(listDepartments_enable);
			}
			// 查询出所有停用的部门
			List<V3xOrgDepartment> listDepartments_disable = orgManagerDirect.getAllDepartments(account.getId(), false, true, null, null, flipInfo);
			if(listDepartments_disable!=null&&listDepartments_disable.size()>0){
				listDepartments.addAll(listDepartments_disable);
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600005", e.getMessage());
		}
		
		return listDepartments;
	}
	
	
	
	public static List<V3xOrgMember> getAllMembersByAccount(String accountCode, boolean includeDisable) throws CzOrgException{
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		V3xOrgAccount account = getAccountByCode(accountCode);
		List<V3xOrgMember> listMembers = null;
		try {
			listMembers = orgManagerDirect.getAllMembers(account.getId(), true);
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("900005", e.getMessage());
		}
		
		return listMembers;
	}
	
	
	/*
	 * 根据单位的编码判断单位是否存在
	 */
	public static boolean checkAccountExist(String accountCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		List<V3xOrgAccount> listAccounts = null;
		try {
			listAccounts = orgManager.getAllAccounts();
		} catch (BusinessException e) {
			throw new CzOrgException("500004", e.getMessage());
		}
		if(listAccounts!=null&&listAccounts.size()>0){
			for(V3xOrgAccount account : listAccounts){
				if(accountCode.equals(account.getCode())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	/*
	 * 根据第三方系统的ID， 判断一个单位是否存在
	 */
	public static boolean checkAccountExistByThirdEnerty(CzAccount czAccount) throws CzOrgException {
		// 首先判断对应表中是否存在
		if(MapperUtil.getAccountByEntry(czAccount)==null){
			return false;
		}else{
			return true;
		}
	}
	
	public static boolean checkAccountNameExist(String accountName) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		OrgManagerDirect orgManagerDirect = (OrgManagerDirect)AppContext.getBean("orgManagerDirect");
		List<V3xOrgAccount> listAccounts = null;
		try {
			listAccounts = orgManager.getAllAccounts();
		} catch (BusinessException e) {
			throw new CzOrgException("500004", e.getMessage());
		}
		if(listAccounts!=null&&listAccounts.size()>0){
			for(V3xOrgAccount account : listAccounts){
				if(accountName.equals(account.getName())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	private static String getFullDepartmentName(V3xOrgDepartment department) throws CzOrgException{
		StringBuilder SB = new StringBuilder();
		V3xOrgDepartment parentDept = null;
		parentDept = getNameByPath(department, SB);
		while(parentDept!=null){
			parentDept = getNameByPath(parentDept, SB);
		}
		return SB.toString();
	}
	
	public static V3xOrgDepartment getParentDepartmentThirdAccountIdAndName(String thirdAccountId, String departmentFullname) throws CzOrgException{
		List<V3xOrgDepartment> listDepartments = null;
		listDepartments = getAllDepartmentsByThirdAccountId(thirdAccountId, true);
		if(listDepartments!=null&&listDepartments.size()>0){
			for(V3xOrgDepartment department : listDepartments){
				// 首先要判断一下， 这两个部门是不是同级部门
				String fullDeptName = getFullDepartmentName(department);
				if(departmentFullname.equals(fullDeptName)){
					return department;
				}
			}
			throw new CzOrgException("600003", departmentFullname);
		}
		throw new CzOrgException("600003", departmentFullname);
}
	
	public static V3xOrgDepartment getParentDepartmentByName(String accountCode, String departmentFullname) throws CzOrgException{
			List<V3xOrgDepartment> listDepartments = null;
			listDepartments = getAllDepartmentsByAccount(accountCode, true);
			if(listDepartments!=null&&listDepartments.size()>0){
				for(V3xOrgDepartment department : listDepartments){
					// 首先要判断一下， 这两个部门是不是同级部门
					String fullDeptName = getFullDepartmentName(department);
					if(departmentFullname.equals(fullDeptName)){
						return department;
					}
				}
				throw new CzOrgException("600003", departmentFullname);
			}
			throw new CzOrgException("600003", departmentFullname);
	}
	
	private static V3xOrgDepartment getNameByPath(V3xOrgDepartment department, StringBuilder sb) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		try {
			String parh = department.getPath();
			String name = department.getName();
			if(!Strings.isBlank(sb.toString())){
				sb.insert(0, name  + "/");
			}else{
				sb.insert(0, name);
			}
			if(Strings.isBlank(department.getParentPath())){
				return null;
			}else{
				return orgManager.getDepartmentByPath(department.getParentPath());
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600002", e.getMessage());
		}
	}
	
	
	public static V3xOrgDepartment getDepartmentByCode(String accountCode, String departmentCode) throws CzOrgException{
		List<V3xOrgDepartment> listDepartments = null;
		listDepartments = getAllDepartmentsByAccount(accountCode, true);
		if(listDepartments!=null&&listDepartments.size()>0){
			for(V3xOrgDepartment department : listDepartments){
				if(departmentCode.equals(department.getCode())){
					return department;
				}
			}
			throw new CzOrgException("600003", departmentCode);
		}
		throw new CzOrgException("600003", departmentCode);
	}
	
	public static boolean checkDepartmentExist(String accountCode, String departmentCode) throws CzOrgException{
		List<V3xOrgDepartment> listDepartments = null;
		listDepartments = getAllDepartmentsByAccount(accountCode, true);
		if(listDepartments!=null&&listDepartments.size()>0){
			for(V3xOrgDepartment department : listDepartments){
				if(departmentCode.equals(department.getCode())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	// 首先用第三方系统的ID 判断是否存在， 如果不存在的话， 用名字来判断是否存在
	public static boolean checkDepartmentExistByEnerty(CzDepartment czDepartment) throws CzOrgException{
		V3xOrgDepartment department = MapperUtil.getDepartmentByEntry(czDepartment);
		return department!=null;
	}
	

//  20161105 下面这部分代码是按照部门名称作为识别部门位置的方法所编写的
//	public static boolean checkDepartmentNameExist(String accountCode, String departmentName) throws CzOrgException{
//		List<V3xOrgDepartment> listDepartments = null;
//		listDepartments = getAllDepartmentsByAccount(accountCode, true);
//		if(listDepartments!=null&&listDepartments.size()>0){
//			for(V3xOrgDepartment department : listDepartments){
//				// 首先要判断一下， 这两个部门是不是同级部门
//				String fullDeptName = getFullDepartmentName(department);
//				if(departmentName.equals(fullDeptName)){
//					return true;
//				}
//			}
//			return false;
//		}
//		return false;
//	}
	// 下面的代码按照父部门的编码来识别部门的位置
	// 如果是根部门， 则父部门的编码要输入所在单位的编码
	public static boolean checkDepartmentNameExist(String accountCode, String parentDepartmentCode, String departmentName) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgDepartment> listDepartments = null;
		listDepartments = getAllDepartmentsByAccount(accountCode, true);
		if(listDepartments!=null&&listDepartments.size()>0){
			for(V3xOrgDepartment department : listDepartments){
				V3xOrgDepartment parentDepartment;
				try {
					parentDepartment = orgManager.getDepartmentByPath(department.getParentPath());
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("600008", e.getMessage());
				}
				if(parentDepartment==null||parentDepartmentCode.equals(parentDepartment.getCode())){
					if(departmentName.equals(department.getName())){
						return true;
					}
				}
			}
			return false;
		}
		return false;
	}
	
	public static boolean checkDepartmentNameExistByEnerty(CzDepartment czDepartment) throws CzOrgException{
		String thirdDeptId = czDepartment.getDepartmentId();
		String thirdParentDept_AccountId = czDepartment.getParentId();
		String deptName = czDepartment.getDepartmentName();
		V3xOrgDepartment department;
		try {
			department = MapperUtil.getDepartmentByMapperBingId(thirdDeptId);
		} catch (CzOrgException e) {
			throw e;
		}
		if(department==null){
			// 下面的程序是在处理：  目前没有建立这个部门的对应关系的前题小的
			// 首先要判断一下， 这个部门的父部门是单位还是部门
			// 判断的前题条件是：  第三方系统在推送的时候， 一定是先推送所有的单位， 然后再推送部门， 这样， 如果在单位的对应关系中没有找到这个单位， 就一定是部门了
			V3xOrgAccount virsualAccount = MapperUtil.getAccountByMapperBingId(thirdParentDept_AccountId);
			if(virsualAccount!=null){
				// 父部门是一个单位
				List<V3xOrgDepartment> list;
				try {
					list = MapperUtil.getOrgManager().getChildDeptsByAccountId(virsualAccount.getId(), true);
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("600002", e.getMessage());
				}  // 第二个参数表示是否只获得第一层
				if(list!=null&&list.size()>0){
					for(V3xOrgDepartment dept : list){
						if(deptName.equals(dept.getName())){
							return true;  // 返回了找到的部门
						}
					}
				}else{
					return false;  // 单位的根部门中， 根据名称， 没有找到这个部门， 需要新建
				}
			}else{
				// 父部门是一个部门
				// 强制要求第三方， 一定是从父部门开始推送， 只有父部门推送完了以后， 才能够推送子部门
				// 这样就可以保证， 父部门的对应关系一定是存在的
				V3xOrgDepartment parentDepartment = MapperUtil.getDepartmentByMapperBingId(thirdParentDept_AccountId);
				if(parentDepartment==null){
					// 如果对方推送的顺序对的话， 这种情况是不应该发生的， 直接抛出异常
					throw new CzOrgException("600013", "父部门的ID = " + thirdParentDept_AccountId);
				}else{
					List<V3xOrgDepartment> list;
					try {
						list = MapperUtil.getOrgManager().getChildDepartments(parentDepartment.getId(), true);
					} catch (BusinessException e) {
						log.error("", e);
						throw new CzOrgException("600002", e.getMessage());
					}  // 第二个参数表示只获得第一层的部门
					if(list!=null&&list.size()>0){
						for(V3xOrgDepartment dept : list){
							if(deptName.equals(dept.getName())){

								return true;  // 返回了找到的部门
							}
						}
					}else{
						// 在父部门的下面， 没有找到具有相同名称的部门， 返回null， 让调用的地方新建部门
						return false;
					}
				}
			}
				return false;  // 程序应该是执行不到这里的
		}else{
			// 在  mapper 中已经直接找到了对应的部门
			return true;
		}	
	}
	
	
	
	public static Long getParentDepartmentId(String accountCode, V3xOrgDepartment v3xOrgDepartment, String fullDepartmentName) throws CzOrgException{
		
		String [] arrays = fullDepartmentName.split("\\/");
		long parentDeptId = v3xOrgDepartment.getOrgAccountId();
		if(arrays.length>1){
			String parentDepartmentFullname = "";
			for(int i = 0; i < arrays.length -1; i++){
				String s = arrays[i];
				if(Strings.isBlank(parentDepartmentFullname)){
					parentDepartmentFullname = parentDepartmentFullname + s;
				}else{
					parentDepartmentFullname = parentDepartmentFullname + "/" + s;
				}
			}
			parentDeptId = CzOrgCheckUtil.getParentDepartmentByName(accountCode, parentDepartmentFullname).getId();
		}
		return parentDeptId;
	}
	

	public static boolean checkLevelNameExist(String accountCode, String levelName) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgLevel> listLevels = null;
		listLevels = getAllLevelsByAccount(accountCode, true);
		if(listLevels!=null&&listLevels.size()>0){
			for(V3xOrgLevel level : listLevels){
				if(levelName.equals(level.getName())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	public static boolean checkLevelExistByEnertyAndAccountId(CzLevel czLevel, Long accountId) throws CzOrgException{
		V3xOrgLevel level = MapperUtil.getLevelByEnerty(czLevel, accountId);
		if(level==null) {
			return false;
		}else{
			return true;
		}
	}
	
	public static boolean checkPostNameExist(String accountCode, String postName) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgPost> listPosts = null;
		listPosts = getAllPostsByAccount(accountCode, true);
		if(listPosts!=null&&listPosts.size()>0){
			for(V3xOrgPost post : listPosts){
				if(postName.equals(post.getName())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	
	
	public static boolean checkMemberExist(String accountCode, String memberCode) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		List<V3xOrgMember> listMembers = getAllMembersByAccount(accountCode, true);
		if(listMembers!=null&&listMembers.size()>0){
			for(V3xOrgMember member : listMembers){
				if(memberCode.equals(member.getCode())){
					return true;
				}
			}
			return false;
		}
		return false;
	}
	
	
	
	public static boolean checkMemberLoginNameExist(String loginName) throws CzOrgException{
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		V3xOrgMember member = null;
		try {
			member = orgManager.getMemberByLoginName(loginName);
		} catch (BusinessException e) {
			return false;
		}
		if(member==null){
			return false;
		}
		return true;
	}
	
	private static boolean checkEqual(Object oaObject, Object czObject, boolean nullIsTrue){
		if(czObject==null) return nullIsTrue;  // true, 表示如果第三方产品中这个属性是 "空", 则不进行更新
		if(oaObject==null) return false;  // 如果第三方系统给的值不是空， OA系统的值是空， 一定要更新的
		if(czObject instanceof String){
			if(Strings.isBlank(String.valueOf(czObject))) return nullIsTrue;
		}
		return oaObject.equals(czObject);
	}
	
	private static String addToString(String retval, String addString){
		if(Strings.isBlank(retval)){
			retval = addString;
		}else{
			retval = retval + "," + addString;
		}
		
		return retval;
	}
	
	
	public static String updateAccountProperty(V3xOrgAccount v3xOrgAccount, CzAccount czAccount){
		String retval = "";
		if(!checkEqual(v3xOrgAccount.getDescription(), czAccount.getDiscription(), true)){
			v3xOrgAccount.setDescription(czAccount.getDiscription());
			retval = addToString(retval, "描述");
		}
		if(!checkEqual(v3xOrgAccount.getName(), czAccount.getName(), true)){
			v3xOrgAccount.setName(czAccount.getName());
			retval = addToString(retval, "名称");
		}

		if(!checkEqual(v3xOrgAccount.getSortId(), Strings.isBlank(czAccount.getSortId())?null:Long.valueOf(czAccount.getSortId()), true)){
			v3xOrgAccount.setSortId(Long.valueOf(czAccount.getSortId()));
			retval = addToString(retval, "排序号");
		}
		
		if(!checkEqual(v3xOrgAccount.getSecondName(), czAccount.getSecondName(), true)){
			v3xOrgAccount.setSecondName(czAccount.getSecondName());
			retval = addToString(retval, "第二名称");
		}

		if(!checkEqual(v3xOrgAccount.getShortName(), czAccount.getShortName(), true)){
			v3xOrgAccount.setShortName(czAccount.getShortName());
			retval = addToString(retval, "简称");
		}
//      第三方数据中， 没有这个相关的标志		
//		if(!checkEqual(v3xOrgAccount.getEnabled(), Boolean.valueOf(czAccount.getIsEnabled())||"1".equals(czAccount.getIsEnabled()), true)){
//			v3xOrgAccount.setEnabled(Boolean.valueOf(czAccount.getIsEnabled())||"1".equals(czAccount.getIsEnabled()));
//			retval = addToString(retval, v3xOrgAccount.getEnabled()?"启用":"停用");
//		}
		
		// TODO:
//		private String person;
//		private String zip;
//		private String address;
//		private String ctrPhone;
//		account.setProperty(key, value);  fax
//		private String url;
//		private String uType;  // 单位类型
//		private String parentUnitCode;
//		private String adminLoginName;
//		private String adminPassword;
//		private String isCopy;  // 是否复制职务级别
		

		return retval;
	}
	
	
	
	public static String updatePostProperty(V3xOrgPost v3xOrgPost, CzPost czPost) throws CzOrgException{
		String retval = "";
		if(!checkEqual(v3xOrgPost.getDescription(), czPost.getDiscription(), true)){
			v3xOrgPost.setDescription(czPost.getDiscription());
			retval = addToString(retval, "描述");
		}
		
		if(!checkEqual(v3xOrgPost.getSortId(), Strings.isBlank(czPost.getSortId())? null : Long.valueOf(czPost.getSortId()), true)){
			v3xOrgPost.setSortId(Long.valueOf(czPost.getSortId()));
			retval = addToString(retval, "排序号");
		}
		
		if(!checkEqual(v3xOrgPost.getName(), czPost.getOcupationName(), true)){
			v3xOrgPost.setName(czPost.getOcupationName());
			retval = addToString(retval, "名称");
		}

/*		if(!Strings.isBlank(czPost.getAccountCode())){
			Long accountId = CzOrgCheckUtil.getAccountByCode(czPost.getAccountCode()).getId();
			if(!checkEqual(v3xOrgPost.getOrgAccountId(), accountId, true)){
				v3xOrgPost.setOrgAccountId(accountId);
				retval = addToString(retval, "所属单位");
			}
		}*/
         // TODO:
		// private String departmentCodes;  // 关联的部门编码， 用 “,” 分开
		
		
		return retval;
	}
	
	public static String updateLevelProperty(V3xOrgLevel v3xOrgLevel, CzLevel czLevel) throws CzOrgException{
		String retval = "";
		
/*		if(!checkEqual(v3xOrgLevel.getDescription(), czLevel.getDiscription(), true)){
			v3xOrgLevel.setDescription(czLevel.getDiscription());
			retval = addToString(retval, "描述");
		}*/
/*		if(!Strings.isBlank(czLevel.getLevelId())){
			if(!checkEqual(v3xOrgLevel.getLevelId(), Integer.valueOf(czLevel.getLevelId()), true)){
				v3xOrgLevel.setLevelId(Integer.valueOf(czLevel.getLevelId()));
				retval = addToString(retval, "等级");
			}
		}*/


		if(!checkEqual(v3xOrgLevel.getName(), czLevel.getName(), true)){
			v3xOrgLevel.setName(czLevel.getName());
			retval = addToString(retval, "名称");
		}
		
/*		if(!Strings.isBlank(czLevel.getAccountCode())){
			Long accountId = CzOrgCheckUtil.getAccountByCode(czLevel.getAccountCode()).getId();
			if(!checkEqual(v3xOrgLevel.getOrgAccountId(), accountId, true)){
				v3xOrgLevel.setOrgAccountId(accountId);
				retval = addToString(retval, "所属单位");
			}
		}*/
		//TODO:
		// private String parentLevelCode;
		
		return retval;
	}
	
	public static String updateDepartmentProperty(V3xOrgDepartment v3xOrgDepartment, CzDepartment czDepartment) throws CzOrgException{
		String retval = "";
//		if(!checkEqual(v3xOrgDepartment.getDescription(), czDepartment.getDiscription(), true)){
//			v3xOrgDepartment.setDescription(czDepartment.getDiscription());
//			retval = addToString(retval, "描述");
//		}
		
		Long accountId =-1L;
		if(needCheckCode){
			accountId = CzOrgCheckUtil.getAccountByCode(czDepartment.getAccountCode()).getId();
		}else{
			accountId = MapperUtil.getAccountByDepartmentEnerty(czDepartment).getOrgAccountId();
		}
		if(!checkEqual(v3xOrgDepartment.getOrgAccountId(), accountId, true)){
			v3xOrgDepartment.setOrgAccountId(accountId);
			retval = addToString(retval, "所属单位");
		}

		// 20161105 下面的代码是根据全路径来判断层级关系的代码
//		String fullDepartmentName = czDepartment.getDepartmentName();
//		String [] arrays = fullDepartmentName.split("\\/");
//		
//		if(!checkEqual(v3xOrgDepartment.getName(), arrays[arrays.length-1], true)){
//			v3xOrgDepartment.setName(arrays[arrays.length-1]);
//			retval = addToString(retval, "名称");
//		}
//		
//		
//		Long parentDeptId = getParentDepartmentId(czDepartment.getAccountCode(), v3xOrgDepartment, fullDepartmentName);
//		String path = OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, parentDeptId);
//		
//		if(!checkEqual(v3xOrgDepartment.getPath(), path, true)){
//			v3xOrgDepartment.setPath(path);
//			retval = addToString(retval, "层级关系");
//		}
//		
//      20161105 下面的代码是根据父部门 的编码值来判断层级关系的代码
		
		String departmentName = czDepartment.getDepartmentName();
		
		if(!checkEqual(v3xOrgDepartment.getName(), departmentName, true)){
			v3xOrgDepartment.setName(departmentName);
			retval = addToString(retval, "名称");
		}
		if(needCheckCode){
			if((czDepartment.getAccountCode().equals(czDepartment.getParentDepartmentCode())||Strings.isBlank(czDepartment.getParentDepartmentCode()))){
				// 处理根部门的情况
				V3xOrgAccount account = getAccountByCode(czDepartment.getAccountCode());
				if(!checkEqual(v3xOrgDepartment.getParentPath(), account.getPath(), true)){
					// 父部门发生了变化， 把部门的路径修改到新的部门下面
					v3xOrgDepartment.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, account.getId()));
					retval = addToString(retval, "层级关系");
				}
			}else{
				// 处理非跟部门的情况
				V3xOrgDepartment czParentDept = getDepartmentByCode(czDepartment.getAccountCode(), czDepartment.getParentDepartmentCode());
				
				if(!checkEqual(v3xOrgDepartment.getParentPath(), czParentDept.getPath(), true)){
					// 父部门发生了变化， 把部门的路径修改到新的部门下面
					v3xOrgDepartment.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, czParentDept.getId()));
					retval = addToString(retval, "层级关系");
				}
			}
		}else{

			// 部门所属单位
			if(czDepartment.isParentUnitIsAccount()){
				// 当前要同步的部门的所属单位是一个单位
				V3xOrgAccount newAccount = MapperUtil.getAccountByMapperBingId(czDepartment.getParentId());
				V3xOrgDepartment oldDept = MapperUtil.getDepartmentByMapperBingId(czDepartment.getDepartmentId());
				
				if(!oldDept.getParentPath().equals(newAccount.getPath())){
					// 原来的父单位的路径 和现在的父单位的路径不一致
					v3xOrgDepartment.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, newAccount.getId()));
					retval = addToString(retval, "层级关系");
				}
			}else{
				// 当前要同步的部门的父部门是一个部门
				V3xOrgDepartment oldDept = MapperUtil.getDepartmentByMapperBingId(czDepartment.getDepartmentId());
				V3xOrgDepartment newParentDept = MapperUtil.getDepartmentByMapperBingId(czDepartment.getParentId());
				if(!oldDept.getParentPath().equals(newParentDept.getPath())){
					v3xOrgDepartment.setPath(OrgHelper.getPathByPid4Add(V3xOrgDepartment.class, newParentDept.getId()));
					retval = addToString(retval, "层级关系");
				}
			}

		}

		// 层级关系的修改完毕
		
		if(!checkEqual(v3xOrgDepartment.getSortId(), Long.valueOf(czDepartment.getDep_sort()), true)){
			v3xOrgDepartment.setSortId(Long.valueOf(czDepartment.getDep_sort()));
			retval = addToString(retval, "排序号");
		}

		return retval;
	}
	
	
	
	public static String updateMemberProperty(V3xOrgMember v3xOrgMember, CzMember czMember) throws CzOrgException{
		String retval = "";
		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
		if(!checkEqual(v3xOrgMember.getDescription(), czMember.getDiscription(), true)){
			v3xOrgMember.setDescription(czMember.getDiscription());
			retval = addToString(retval, "描述");
		}
		

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			if(!checkEqual(v3xOrgMember.getBirthday()==null? null : sdf.format(v3xOrgMember.getBirthday()), czMember.getBirthday(), true)){
				v3xOrgMember.setProperty(MemberPropertiesKey.birthday.name(), sdf.parse(czMember.getBirthday()));
				retval = addToString(retval, "生日");
			}
		} catch (ParseException e) {
				log.error("", e);
				throw new CzOrgException("700007", czMember.getBirthday());
		}

		if(!checkEqual(v3xOrgMember.getProperty(MemberPropertiesKey.emailaddress.name()), czMember.getEmail(), true)){
			v3xOrgMember.setProperty(MemberPropertiesKey.emailaddress.name(), czMember.getEmail());
			retval = addToString(retval, "电子邮件");
		}
		if(!Strings.isBlank(czMember.getEnabled())){
			if(!checkEqual(v3xOrgMember.getEnabled(), Boolean.valueOf(czMember.getEnabled())||"1".equals(czMember.getEnabled()), true)){
				v3xOrgMember.setEnabled(Boolean.valueOf(czMember.getEnabled())||"1".equals(czMember.getEnabled()));
				retval = addToString(retval, v3xOrgMember.getEnabled() ? "启用":"停用");
			}
		}

		
		if(!checkEqual(v3xOrgMember.getLoginName(), czMember.getLoginName(), true)){
			if(v3xOrgMember.getLoginName()==null){
				v3xOrgMember.setV3xOrgPrincipal(new V3xOrgPrincipal(v3xOrgMember.getId(), czMember.getLoginName(), Strings.isBlank(czMember.getPassWord())?"123456":czMember.getPassWord()));
				v3xOrgMember.setLoginName(v3xOrgMember, czMember.getLoginName());

			}else{
				v3xOrgMember.setLoginName(v3xOrgMember, czMember.getLoginName());
			}
			retval = addToString(retval, "登录名");
		}
		
		if(!checkEqual(v3xOrgMember.getProperty(MemberPropertiesKey.telnumber.name()), czMember.getMobilePhone(), true)){
			v3xOrgMember.setProperty(MemberPropertiesKey.telnumber.name(), czMember.getMobilePhone());
			retval = addToString(retval, "电话");
		}
		

		
		if(!checkEqual(v3xOrgMember.getProperty(MemberPropertiesKey.officenumber.name()), czMember.getOfficePhone(), true)){
			v3xOrgMember.setProperty(MemberPropertiesKey.officenumber.name(), czMember.getOfficePhone());
			retval = addToString(retval, "办公电话");
		}
		
		if(!checkEqual(String.valueOf(v3xOrgMember.getProperty(MemberPropertiesKey.gender.name())), czMember.getSex(), true)){
			v3xOrgMember.setProperty(MemberPropertiesKey.gender.name(), czMember.getSex());
			retval = addToString(retval, "性别");
		}
		
		try{
			if(!Strings.isBlank(czMember.getAccountCode())){
				// 建新
				Long accountId = orgManager.getAccountByCode(czMember.getAccountCode()).getId();//CzOrgCheckUtil.getAccountByCode(czMember.getAccountCode()).getId();
				if(!checkEqual(v3xOrgMember.getOrgAccountId(), accountId, true)){
					v3xOrgMember.setOrgAccountId(accountId);
					retval = addToString(retval, "所属单位");
				}
			}
		}catch(BusinessException e){
			log.error("所属单位错误 ",e);
		}
		
		if(v3xOrgMember.getSortId()!=null){
			if(!checkEqual(v3xOrgMember.getSortId(), Long.valueOf(czMember.getPer_sort()), true)){
				v3xOrgMember.setSortId(Long.valueOf(czMember.getPer_sort()));
				retval = addToString(retval, "排序号");
			}
		}

		if(!checkEqual(v3xOrgMember.getName(), czMember.getTrueName(), true)){
			v3xOrgMember.setName(czMember.getTrueName());
			retval = addToString(retval, "姓名");
		}
		
		if(!Strings.isBlank(czMember.getOcupationCode())){
			Long postId = CzOrgCheckUtil.getPostByCode(czMember.getAccountCode(), czMember.getOcupationCode()).getId();
			if(!checkEqual(v3xOrgMember.getOrgPostId(), postId, true)){
				v3xOrgMember.setOrgPostId(postId);
				retval = addToString(retval, "岗位");
			}
		}
		
		try{
			if(!Strings.isBlank(czMember.getOtypeCode())){
				List<V3xOrgLevel> lstLevel = orgManager.getAllLevels(v3xOrgMember.getOrgAccountId());
				for(V3xOrgLevel level : lstLevel){
					if(level.getName().equalsIgnoreCase(czMember.getOtypeCode())){
						v3xOrgMember.setOrgLevelId(level.getId());
						retval = addToString(retval, "职务级别");
						break;
					}
				}
			}
		}catch(BusinessException e){
			log.error("职务级别错误 ",e);
		}

		try{
			if(!Strings.isBlank(czMember.getDeptartmentCode())){
				Long departmentId = orgManager.getDepartmentByCode(czMember.getDepartmentId()).getId();
				if(!checkEqual(v3xOrgMember.getOrgDepartmentId(), departmentId, true)){
					v3xOrgMember.setOrgDepartmentId(departmentId);
					retval = addToString(retval, "所属部门");
				}
			}
		}catch(BusinessException e){
			log.error("所属部门错误 ",e);
		}
	
		
	//  TODO:	
	//	czMember.getSecondOcupationCodes());
	//  czMember.getPassWord();	
	//  下面的属性需要修改 staff
	//	czMember.getStaffNumber());
	//	czMember.getIdentity();
	//	czMember.getFamilyPhone());
		

		return retval;
	}

	
	public static String getErrorMessage(OrganizationMessage message, V3xOrgEntity entity){
		if (!message.isSuccess()) {
			String msg = "";
			List<OrgMessage> listMsg = message.getErrorMsgs();
			if(listMsg!=null&&listMsg.size()>0){
				for(OrgMessage m: listMsg){
					String key = m.getCode().name();
//				String key = MessageStatus.ACCOUNT_EXIST_CHILDACCOUNT_ENABLE.name();
			msg = msg + " " + ResourceUtil.getString("MessageStatus."+key, entity);
				}
			}
			return msg;
		}else{
			return "";  // successMsg + "成功";
		}
	}
}
