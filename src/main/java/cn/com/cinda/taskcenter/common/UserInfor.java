package cn.com.cinda.taskcenter.common;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;

/*import com.cinda.eoffice.ccds.ccbl.security.SecuritySegment;
import com.cinda.eoffice.ccds.ccbl.security.SecurityService;
import com.cinda.eoffice.ccds.ccbl.security.SecurityServiceFactory;*/

/**
 * 用户相关信息
 * 
 * @author hkgt
 * 
 */
public class UserInfor {
	private static final Log log = LogFactory.getLog(UserInfor.class);
	/**
	 * 根据用户id获得用户名称 性能和缓存问题由接口SecurityService负责处理
	 * 
	 * @param userId
	 * @return
	 */
	public static String getUserNameById(String userId) {
		if (userId == null || "".equals(userId)) {
			return "";
		} else if ("taskcenter".equalsIgnoreCase(userId)) {
			return "任务中心";
		} else if ("weblogic".equalsIgnoreCase(userId)) {
			return "任务中心";
		} else {
			try {
				V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(userId);
				if(member!=null){
					return member.getName();
				}
			} catch (Exception e) {
				log.error("",e);
			}
		}

		return "";
	}

	/**
	 * 根据用户id获得用户部门编码 性能和缓存问题由接口SecurityService负责处理
	 * 
	 * @param userId
	 * @return
	 */
	public static String getDeptCodeByUserId(String userId) {
		if (userId == null || "".equals(userId)) {
			return null;
		} else {
			try {
				V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(userId);
				if(member!=null){
					V3xOrgDepartment dept = OrgHelper.getDepartment(member.getOrgDepartmentId());
					if(dept!=null){
						return dept.getCode();
					}
				}
			} catch (Exception e) {
				log.error("",e);
			}
		}

		return "";
	}

	/**
	 * 根据用户id获得用户部门名称 性能和缓存问题由接口SecurityService负责处理
	 * 
	 * @param userId
	 * @return
	 */
	public static String getDeptNameByUserId(String userId) {
		if (userId == null || "".equals(userId)) {
			return null;
		} else {
			try {
				V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(userId);
				if(member!=null){
					V3xOrgDepartment dept = OrgHelper.getDepartment(member.getOrgDepartmentId());
					if(dept!=null){
						return dept.getName();
					}
				}
			} catch (Exception e) {
				log.error("",e);
			}
		}

		return "";
	}

	/**
	 * 根据部门编码获得用户部门名称 性能和缓存问题由接口SecurityService负责处理
	 * 
	 * @param deptCode
	 * @return
	 */
	public static String getDeptNameByDeptCode(String deptCode) {
		if (deptCode == null || "".equals(deptCode)) {
			return null;
		} else {
			try {
				List<V3xOrgEntity> list = OrgHelper.getOrgManager().getEntityList(V3xOrgDepartment.class.getSimpleName(), "code", deptCode, AppContext.getCurrentUser().getAccountId());
				if(list!=null&& list.size()>0){
					for (V3xOrgEntity en : list) {
						if(en.getCode().equals(deptCode)&& en.getEnabled()){
							return en.getName();
						}
					}
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}

		return "";
	}

}
