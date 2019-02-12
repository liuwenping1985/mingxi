package com.seeyon.apps.kdXdtzXc.menu;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.menu.check.AbstractMenuCheck;

public class NotMenuCheck extends AbstractMenuCheck  {

	private static final Log LOGGER = LogFactory.getLog(NotMenuCheck.class);
 
	@Override
	public boolean check(long memberId, long loginAccountId) {
		return true;
	}
}
