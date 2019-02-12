package com.seeyon.apps.cinda.sso;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import www.seeyon.com.utils.MD5Util;


import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.portal.sso.SSOLoginHandshakeAbstract;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;

public class SSOLoginHandShakeCinda extends SSOLoginHandshakeAbstract{
	private static final Log log = LogFactory.getLog(SSOLoginHandShakeCinda.class);
	public static final String priavteKey = "prk"+UUIDLong.longUUID();
	@Override
	public String handshake(String ticket) {
		try {
			String loginName = getLoginName(ticket);
			if(Strings.isBlank(loginName)){
				return null;
			}
			V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(loginName);
			if(member!=null && member.getEnabled()){
				return loginName;
			}
		} catch (BusinessException e) {
			log.error("",e);
		}
		return null;
	}
	public static String makeTicket(String userName){
		return userName +"@"+ MD5Util.MD5(userName+priavteKey);

	}
	public static String getLoginName(String ticket){
		try {
			String[] keys = ticket.split("\\@");
			String loginName = keys[0];
			String publickey = keys[1];
			String mykey = MD5Util.MD5(loginName+priavteKey);
			if(mykey.equalsIgnoreCase(publickey)){
				return loginName;
			}
		} catch (Exception e) {
			log.error("检查登录信息出错",e);
		}
		return null;
	}
	@Override
	public void logoutNotify(String paramString) {
		// TODO Auto-generated method stub
		
	}

}
