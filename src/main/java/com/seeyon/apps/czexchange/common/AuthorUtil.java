 package com.seeyon.apps.czexchange.common;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.services.AuthorityService;
import com.seeyon.ctp.services.UserToken;
import com.seeyon.ctp.util.TextEncoder;




public class AuthorUtil {
	public static String url = AppContext.getSystemProperty("internet.site.url");
	
	// 在做客户端测试的时候， 获得 token 的方法
	
	public static String getToken() throws Exception{
		
	
		AuthorityService service = (AuthorityService) AppContext.getBean("authorityService");
		String pwd = AppContext.getSystemProperty("webservice.password");	
		UserToken token = service.authenticate("service-admin", TextEncoder.decode(pwd));
		return token.getId();
	}

}
