package com.seeyon.apps.cinda.authority.menucheck;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.menu.check.MenuCheck;
import com.seeyon.ctp.organization.dao.OrgHelper;
//import com.seeyon.v3x.meetingroom.manager.MeetingRoomAdminManager;

public class CindaAuthorityMenuCheck implements MenuCheck{


	private static final Log log = LogFactory .getLog(CindaAuthorityMenuCheck.class);
	//private static MeetingRoomAdminManager meetingRoomAdminManager = AppContext.getBeansOfType(MeetingRoomAdminManager.class).get(MeetingRoomAdminManager.class);
	private String menuId;
	
	public String getMenuId() {
		return menuId;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public boolean check(long memberId, long accountId) {
		 boolean isAdmin = false;
	        //User user = CurrentUser.get();

	        try
	        {	
	        	//判断是否会议室管理员
//	        	isAdmin = meetingRoomAdminManager.checkAdmin(memberId);
	        	if(!isAdmin){
	        		isAdmin = OrgHelper.getOrgManager().isAdministrator();
	        	}
//	        	//判断是否为 HR管理员   
//	        	V3xOrgMember member = orgManager.getMemberById(memberId);
//	        	//可以改下参数 换成其他管理员
//	            List<V3xOrgRole> hrRoles = orgManager.getRoleByCode("HrAdmin", member.getOrgAccountId());
//	            if(hrRoles !=null && hrRoles.size()>0){
//	            	for (V3xOrgRole hrRole : hrRoles) {
//	            		roleId = hrRole.getId();
//	            		isHRAdmin = orgManager.isRole(paramLong1, paramLong2, paramString, paramVarArgs)
//					}
//	            }
	        }
	        catch (Exception e)
	        {
	            log.error("", e);
	        }
	       return isAdmin;
	}

}
