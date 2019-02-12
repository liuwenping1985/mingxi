package com.seeyon.apps.kdXdtzXc.util;

import java.nio.charset.Charset;

import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

public class SoapRequest {

	
	//携程接口定时器方法
	public static String sendSoapRequest(String postUrl, String soapXml, String soapAction) {    
        String retStr = "";  
        // 创建HttpClientBuilder  
        HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();  
        // HttpClient  
        CloseableHttpClient closeableHttpClient = httpClientBuilder.build();  
        HttpPost httpPost = new HttpPost(postUrl);  
                //  设置请求和传输超时时间  
        RequestConfig requestConfig = RequestConfig.custom()  
                .setSocketTimeout(30000)  
                .setConnectTimeout(30000).build();  
        httpPost.setConfig(requestConfig);  
        try {  
            httpPost.setHeader("Content-Type", "text/xml;charset=UTF-8");  
            httpPost.setHeader("SOAPAction", soapAction);  
            StringEntity data = new StringEntity(soapXml,  
                    Charset.forName("UTF-8"));  
            httpPost.setEntity(data);  
            CloseableHttpResponse response = closeableHttpClient  
                    .execute(httpPost);  
            HttpEntity httpEntity = response.getEntity();  
            if (httpEntity != null) {  
                // 打印响应内容  
                retStr = EntityUtils.toString(httpEntity, "UTF-8");  
               System.out.println("response:" + retStr);  
            }  
            // 释放资源  
            closeableHttpClient.close();  
        } catch (Exception e) {  
           e.printStackTrace();
        }  
        return retStr;  
    }
}
