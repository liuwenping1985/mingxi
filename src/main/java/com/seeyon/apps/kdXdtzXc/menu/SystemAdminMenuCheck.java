package com.seeyon.apps.kdXdtzXc.menu;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.menu.check.AbstractMenuCheck;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class SystemAdminMenuCheck extends AbstractMenuCheck  {

	private static final Log LOGGER = LogFactory.getLog(SystemAdminMenuCheck.class);
 
	@Override
	public boolean check(long memberId, long loginAccountId) {
		boolean isAllow = false;
		if (isAdmin()) {
			isAllow = false;
		}else{
			isAllow = true;
		} 
		
		return isAllow;
	}

	public boolean isAdmin() {
		User user = CurrentUser.get();
		return user.isGroupAdmin() || user.isAdmin() || user.isAdministrator() || user.isSuperAdmin();
	}
    
}
