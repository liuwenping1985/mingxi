package com.seeyon.apps.docexport.util;

import java.util.HashMap;
import java.util.Map;

import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;

public class RestIntfaceUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// 指定协议、IP和端口，获取ClientManager
		CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://192.168.0.42:80");
//		EdocSummaryResource
		// 取得REST动态客户机实例
		CTPRestClient client = clientManager.getRestClient();
		client.authenticate("test", "test123");
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("summaryid", new String[]{"-6258934827272091849","6192188217816403786"});
		param.put("folder", "/Users/mac/Downloads/公文importEdoc导入XMLDEMO/");
		client.post("edoc/export", param, String.class);
	}

}
