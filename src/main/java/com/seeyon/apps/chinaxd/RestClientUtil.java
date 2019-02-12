package com.seeyon.apps.chinaxd;

import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;

public class RestClientUtil {
    public static CTPRestClient resouresClient(String oaUrl,String userName , String passWord) {
//    	
        CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance(oaUrl);
        // REST 动态客户机
        CTPRestClient client = clientManager.getRestClient();
        client.authenticate(userName, passWord);
        return client;
    }
    public static void main(String[] args) {
    	String url = "http://192.168.18.135";
    	String userName = "test";
    	String passWord = "123456";
    	CTPRestClient client = resouresClient(url, userName, passWord);
	}
}
