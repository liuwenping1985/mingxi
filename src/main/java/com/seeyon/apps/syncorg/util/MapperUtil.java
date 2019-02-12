package com.seeyon.apps.syncorg.util;

import static com.seeyon.apps.syncorg.constants.ADConstants.SYN_LEVEL;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.exception.CzOrgException;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.common.idmapper.MapperException;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;


public class MapperUtil {
	
	
	private static final Log log = LogFactory.getLog(MapperUtil.class);
	private static GuidMapper guidMapper;
	public static GuidMapper getGuidMapper() {
		if(guidMapper==null){
			guidMapper = (GuidMapper) AppContext.getBean("guidMapper");
		}
		return guidMapper;
	}
	
	private static OrgManager orgManager;
	public static OrgManager getOrgManager() {
		if(orgManager==null){
			orgManager = (OrgManager) AppContext.getBean("orgManager");
		}
		return orgManager;
	}

	/*
	 * 根据第三方系统的 ID 获得 OA 中的部门， 返回 null 表示这个部门目前没有建立对应关系
	 */
	public static V3xOrgDepartment getDepartmentByMapperBingId(String bingId ) throws CzOrgException {

		V3xOrgDepartment depart = null;

		try {
			depart = getOrgManager().getDepartmentByCode(bingId);

		} catch (BusinessException e) {
			log.error("getDepartmentByMapperBingId ", e);
			throw new CzOrgException("600002", e.getMessage());
		}
		if(depart !=null && !depart.getIsDeleted() && Strings.isNotBlank(depart.getName())){
			return depart;
		}

		return depart;
	}
	
	
	/*
	 * 根据第三方系统的 ID 获得 OA 中的人员， 返回 null 表示这个人员目前没有建立对应关系
	 */
	public static V3xOrgMember getMemberByMapperBingId(String bingId ) throws CzOrgException {

		V3xOrgMember member = null;

		try {
			member = getOrgManager().getMemberByCode(bingId);
			
		} catch (BusinessException e) {
			log.error("getMemberByMapperBingId ", e);
			throw new CzOrgException("600003", e.getMessage());
		}
		if(member !=null && !member.getIsDeleted() && Strings.isNotBlank(member.getName())){
			return member;
		}
		
		return member;
	}
	
	/*
	 * 根据第三方系统的 ID 获得 OA 中的单位， 返回 null 表示这个单位目前没有建立对应关系
	 */
	public static V3xOrgAccount getAccountByMapperBingId(String bingId) throws CzOrgException{

		V3xOrgAccount account = null;

		try {
			account = getOrgManager().getAccountByCode(bingId);
			
		} catch (BusinessException e) {
			log.error("getAccountByMapperBingId ", e);
			throw new CzOrgException("500009");
		}
		if(account != null && !account.getIsDeleted() && Strings.isNotBlank(account.getName())){
			return account;
		}

		return account;
	}
	
	public static V3xOrgAccount getAccountByEntry(CzAccount czAccount) throws CzOrgException {
		V3xOrgAccount account;
		try {
			account = getOrgManager().getAccountByCode(czAccount.getThirdAccountId());
			
		} catch ( BusinessException e1) {
			throw new CzOrgException("500008");
		}
		if(account==null){
			// 在对应表中， 没有找到这个单位， 按照名称在所有单位中进行查找
			List<V3xOrgAccount> list;
			try {
				list = getOrgManager().getAllAccounts();
				
			} catch (BusinessException e) {
				log.error("", e);
				throw new CzOrgException("500009");
			}
			if(list!=null && list.size()>0){
				for(V3xOrgAccount acc : list){
					if(czAccount.getName().equals(acc.getName())){
						// 增加到 mapper 表中
						acc.setCode(czAccount.getThirdAccountId());
						return acc;
					}
				}
			}
			// OA 中没有找到这个单位， 返回  null 给主程序
			return null;
		}
		// 在对应表中, 找到了这个单位， 直接返回
		return account;
	}

	/*
	 * 根据第三方系统的 ID 获得 OA 中的职务级别， 返回 null 表示这个职务级别目前没有建立对应关系
	 * 由于第三方系统中， 职务级别是不区分单位的， 但是 OA 中的职务级别是区分单位的， 所以， 对方推送过来的每一个职务级别， OA 中都需要在每个单位中增加一个
	 * 第三方系统推送过来的 thirdId, 在做 mapper 对应关系的时候， bingId = thirdId + "_" + oaAccountId
	 * 这样才能保证是一对一的对应关系
	 */
	public static V3xOrgLevel getLevelByMapperBingId(String bingId) throws CzOrgException {
		List<Long> levelIds = getGuidMapper().getLocalIds(bingId,SYN_LEVEL);
		V3xOrgLevel level = null;
		if(levelIds!=null){
			for (Long id : levelIds) {
				V3xOrgLevel lvl;
				try {
					lvl = getOrgManager().getLevelById(id);
				} catch (BusinessException e) {
					log.error("", e);
					throw new CzOrgException("900002");
				}
				if(lvl !=null && !lvl.getIsDeleted() && Strings.isNotBlank(lvl.getName())){
					level =  lvl;
				}else{
					try {
						getGuidMapper().removeByLocalIdAndGuid(id, bingId);
					} catch (MapperException e) {
						log.error("", e);
						throw new CzOrgException("900002");
					}
				}
			}
		}
		return level;
	}
	
	public static V3xOrgLevel getLevelByEnerty(CzLevel czLevel, Long accountId) throws CzOrgException {
		V3xOrgLevel level = getLevelByMapperBingId(czLevel.getThirdId() + "_" + String.valueOf(accountId));
		if(level==null){
			// 该单位中没有这个职务级别
			return null;
		}
		return level;  // 找到了这个朱武级别， 给予返回
	}
	// 由于一个部门的父部门不清楚是单位还是部门， 所以需要进行判断
	public static V3xOrgAccount getAccountByDepartmentEnerty(CzDepartment enerty) throws CzOrgException{
		V3xOrgAccount account = getAccountByMapperBingId(enerty.getParentId());
		if(account!=null){
			return account;
		}
		V3xOrgDepartment department = getDepartmentByMapperBingId(enerty.getParentId());
		if(department==null){
			throw new CzOrgException("500009");
		}
		try {
			account = getOrgManager().getAccountById(department.getOrgAccountId());
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("500009");
		}
		return account;
	}
	
	/*
	 * 根据第三方系统传递的对象， 在 OA 中获得部门， 获得的步骤是：  先在 mapper 中查找， 然后再从 OA 中按照名称， 名称的匹配是按照父部门下的所有一级部门进行匹配的
	 */
	public static V3xOrgDepartment getDepartmentByEntry(CzDepartment entry) throws CzOrgException  {
		String thirdDeptId = entry.getDepartmentId();
		String thirdParentDept_AccountId = entry.getParentId();
		String deptName = entry.getDepartmentName();
		V3xOrgDepartment department;
		try {
			department = getOrgManager().getDepartmentByCode(thirdDeptId);

			if(department==null && Strings.isNotBlank(deptName)){
				// 下面的程序是在处理：  目前没有建立这个部门的对应关系的前题小的
				// 首先要判断一下， 这个部门的父部门是单位还是部门
				// 判断的前题条件是：  第三方系统在推送的时候， 一定是先推送所有的单位， 然后再推送部门， 这样， 如果在单位的对应关系中没有找到这个单位， 就一定是部门了
				V3xOrgAccount virsualAccount = getOrgManager().getAccountByCode(thirdParentDept_AccountId);
				if(virsualAccount != null){
					// 父部门是一个单位
					List<V3xOrgDepartment> list = getOrgManager().getChildDeptsByAccountId(virsualAccount.getId(), true);
						
					// 第二个参数表示是否只获得第一层
					if(list!=null&&list.size()>0){
						for(V3xOrgDepartment dept : list){
							if(deptName.equals(dept.getName())){
								// 找到了对应的部门， 增加到 mapper 中
								dept.setCode(entry.getDepartmentId());
								return dept;  // 返回了找到的部门
							}
						}
					}
					return null;  // 单位的根部门中， 根据名称， 没有找到这个部门， 需要新建

				}else{
					// 父部门是一个部门
					// 强制要求第三方， 一定是从父部门开始推送， 只有父部门推送完了以后， 才能够推送子部门
					// 这样就可以保证， 父部门的对应关系一定是存在的
					V3xOrgDepartment parentDepartment = getOrgManager().getDepartmentByCode(thirdParentDept_AccountId);
					if(parentDepartment==null){
						// 如果对方推送的顺序对的话， 这种情况是不应该发生的， 直接抛出异常
						throw new CzOrgException("600013", "父部门的ID = " + thirdParentDept_AccountId);
					}else{
						List<V3xOrgDepartment> list = getOrgManager().getChildDepartments(parentDepartment.getId(), true);
						// 第二个参数表示只获得第一层的部门
						if(list!=null && list.size()>0){
							for(V3xOrgDepartment dept : list){
								if(deptName.equals(dept.getName())){
									// 找到了对应的部门， 增加到 mapper 中
									dept.setCode(entry.getDepartmentId());
									return dept;  // 返回了找到的部门
								}
							}
						}
						// 在父部门的下面， 没有找到具有相同名称的部门， 返回null， 让调用的地方新建部门
						return null;

					}
				}
			}
		} catch (BusinessException e) {
			log.error("", e);
			throw new CzOrgException("600002", e.getMessage());
		}
		
		// 在  mapper 中已经直接找到了对应的部门
		return department;

	}
}
