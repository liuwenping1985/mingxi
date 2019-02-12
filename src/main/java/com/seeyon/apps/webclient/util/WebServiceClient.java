package com.seeyon.apps.webclient.util;

import java.net.URL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.xfire.client.Client;

import com.seeyon.ctp.common.constants.SystemProperties;

public class WebServiceClient {
	private static Log log = LogFactory.getLog(WebServiceClient.class);
	private String url = SystemProperties.getInstance().getProperty("syncorg.webservices.address");
	
	public WebServiceClient(String url){
		this.url = url;
	}
	/**
	 * 执行webservice方法
	 * @param methodName
	 * @param params
	 * @return
	 */
	public Object [] invokeMethod(String methodName , Object[] params){
		  Object[] results = null;
		  log.info("请求的webservice地址为："+url);
		  try {
		   Client client = new Client(new URL(url));
		   results = client.invoke(methodName, params);
		  } catch (Exception e) {
		   log.error("",e);
		  }
		return results;
	}
}
