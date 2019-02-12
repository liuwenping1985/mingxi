package com.seeyon.apps.czexchange.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
public class CzVisualUser {

	
	private static final Log log = LogFactory.getLog(CzVisualUser.class);
	public static boolean visualUser(V3xOrgMember member){
		User user = new User();
		user.setId(member.getId());
		user.setName(member.getName());
		user.setLoginAccount(member.getOrgAccountId());
		user.setAccountId(member.getOrgAccountId());
		AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
		return true;
	}
	
	
	
	public static boolean restoreCurrentUser(User user){
		AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
		return true;
	}
}
