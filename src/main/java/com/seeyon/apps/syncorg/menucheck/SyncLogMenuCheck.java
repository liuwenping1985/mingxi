package com.seeyon.apps.syncorg.menucheck;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.menu.check.AbstractMenuCheck;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;



/*
 * 菜单权限验证类
 * menuId  格式：  ##-%%-&&， ## 表示一级菜单编号  %% 表示二级菜单编号 && 表示三级菜单编号， 如果没有这一级用 00 表示 
 */
public class SyncLogMenuCheck extends AbstractMenuCheck {

	private static final Log log = LogFactory.getLog(SyncLogMenuCheck.class);
	
	public boolean check(long memberId, long loginAccountId) {
		return isAccountAdmin(memberId);
		
	}
	
	public static boolean isAccountAdmin(Long memberId){
		
		// 当前用户如果是管理员，则具有察看同步日志的菜单
		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
		if(memberId!=null) {
			V3xOrgMember member = null;
			try {
				member = orgManager.getMemberById(memberId);
			} catch (BusinessException e) {
				log.error("", e);
			}
			if(member==null) return false;		
			if(member.getIsAdmin()){
				return true;
			}
			return false;
		}
		return false;
	}
	
		
	
}
