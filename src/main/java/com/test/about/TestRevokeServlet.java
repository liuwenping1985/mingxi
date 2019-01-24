package com.test.about;
import java.io.BufferedInputStream; 
import java.io.ByteArrayOutputStream; 
import net.sf.json.JSONObject;

import org.apache.commons.httpclient.HttpClient; 
import org.apache.commons.httpclient.HttpStatus; 
import org.apache.commons.httpclient.methods.PostMethod; 
import org.apache.commons.httpclient.methods.StringRequestEntity; 
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

/**
 * 吊销
 * @author fengxiangzi
 *
 */
public class TestRevokeServlet {


	public static void main(String[] args) {
		String 	url = "http://192.168.1.222:8082/APWebPF/CertRevokeOrServlert";
		/**
		 * XML请求
		 */
		httpostXml(url);
		
		/**
		 * JSON请求
		 */
		//httpostJson(url);
	}
	
	
	/**
	 * XMLPOST请求
	 */
	public static void httpostXml(String url){
        String xmlString = getXmlString();
        HttpClient client = new HttpClient();  
        PostMethod myPost = new PostMethod(url);  
        client.getParams().setSoTimeout(300*1000);  
         	
        String responseString = null;  
        try{  
            myPost.setRequestEntity(new StringRequestEntity(xmlString,"text/xml","utf-8"));  
            int statusCode = client.executeMethod(myPost);  
            if(statusCode == HttpStatus.SC_OK){  
                BufferedInputStream bis = new BufferedInputStream(myPost.getResponseBodyAsStream());  
                byte[] bytes = new byte[1024];  
                ByteArrayOutputStream bos = new ByteArrayOutputStream();  
                int count = 0;  
                while((count = bis.read(bytes))!= -1){  
                    bos.write(bytes, 0, count);  
                }  
                byte[] strByte = bos.toByteArray();  
                responseString = new String(strByte,0,strByte.length,"utf-8");  
                bos.close();  
                bis.close();  
            }  
        }catch (Exception e) {  
        	e.printStackTrace();
        }  
        myPost.releaseConnection();  
        client.getHttpConnectionManager().closeIdleConnections(0); 
        System.out.println("responseString:"+responseString); 
	}
	

	/**
	 * XML数据源
	 * @return
	 */
	private static String getXmlString(){
		Document document = DocumentHelper.createDocument();
		Element request = document.addElement("Request");
		Element required = request.addElement("Required");
		Element certId = required.addElement("certId");
		certId.setText("4028815e5822ac29015822aef2e90008");
		return document.asXML();
	} 
	
	
	/**
	 * JSON 数据请求
	 */
	public static void httpostJson(String url){
		   String json=showReqJson();
		  JSONObject obj = JSONObject.fromObject(json);  
		  doPost(url, obj);
	  
	}
	
	/**
	 * JSON 数据源
	 * @return
	 */
	public static String showReqJson(){
		String certId="402881b657278a1a0157278b79eb0006";
		String str=getJsonData(certId);
		return str;
		
	}
	
	
	/**
	 * 拼接JSON数据
	 * @param certId 证书ID
	 * @return
	 */
	public static String getJsonData(String certId){
		String query = 
		"{\"required\": "
		    + " [{\"certId\": \""+certId+"\"}]}";
	return query;
	}

	  /**
     * JSON post请求
     * @param url
     * @param json
     * @return
     */
    public static void doPost(String url,JSONObject json){
      DefaultHttpClient client = new DefaultHttpClient();
      HttpPost post = new HttpPost(url);
      String result="";
      try {
        StringEntity s = new StringEntity(json.toString(),"UTF-8");// 中文乱码在此解决
        s.setContentEncoding("UTF-8");
        s.setContentType("application/json");//发送json数据需要设置contentType
        post.setEntity(s);
        HttpResponse res = client.execute(post);
        if(res.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
          result = EntityUtils.toString(res.getEntity());// 返回json格式：
        }
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
      System.out.println("responseString:"+result); 
    }
	

}
