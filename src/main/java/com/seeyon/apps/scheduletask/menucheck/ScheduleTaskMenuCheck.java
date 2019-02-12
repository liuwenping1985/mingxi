package com.seeyon.apps.scheduletask.menucheck;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.menu.check.AbstractMenuCheck;

public class ScheduleTaskMenuCheck extends AbstractMenuCheck {
	
	private static final Log log = LogFactory.getLog(ScheduleTaskMenuCheck.class);
	
	public boolean check(long memberId, long loginAccountId) {
			try {
				User user = AppContext.getCurrentUser();
					if (user!=null &&  user.isAdministrator()) {
						return true;
					}
			} catch (Exception e) {
				log.error("", e);
				return false;
			}
		return false;
	}

}
