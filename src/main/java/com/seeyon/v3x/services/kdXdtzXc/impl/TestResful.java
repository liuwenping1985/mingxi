package com.seeyon.v3x.services.kdXdtzXc.impl;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMNamespace;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.message.SOAPHeaderElement;
import org.apache.axis2.AxisFault;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.InputStreamRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.commons.httpclient.util.HttpURLConnection;
import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Response;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.junit.Test;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import com.seeyon.apps.kdXdtzXc.manager.GeRenZhiFuXinXi;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class TestResful {
	@Test
	public void Testq1(){
		try {
			String xml4="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
	                "\t\t\t\t<ROOT>\n" +
	                "\t\t\t\t<ITEMS>\n" +
	                "\t\t\t\t\t<ITEM>\n" +
	                "\t\t\t\t\t<COM_CODE>123456</COM_CODE>\n" +
	                "\t\t\t\t\t<COM_DESC>机构/</COM_DESC>\n" +
	                "\t\t\t\t\t<COM_CODE_OA>654321</COM_CODE_OA>\n" +
	                "\t\t\t\t\t<COM_DESC_OA>OA机构</COM_DESC_OA>\n" +
	                "\t\t\t\t\t</ITEM>\n" +	
	                "\t\t\t\t\t<ITEM>\n" +
	                "\t\t\t\t\t<COM_CODE>123459</COM_CODE>\n" +
	                "\t\t\t\t\t<COM_DESC>机构/</COM_DESC>\n" +
	                "\t\t\t\t\t<COM_CODE_OA>654321</COM_CODE_OA>\n" +
	                "\t\t\t\t\t<COM_DESC_OA>OA机构</COM_DESC_OA>\n" +
	                "\t\t\t\t\t</ITEM>\n" +	
	                "\t\t\t\t</ITEMS>\n" +
	                "\t\t\t\t</ROOT>";
			
			String xml3="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                    "\t                <ROOT>\n" +
                    "\t                <ITEMS>\n" +
                    "\t                <ITEM>\n" +
                    "\t                <DEP_CODE>1111</DEP_CODE>\n" +
                    "\t                <DEP_DESC>部门</DEP_DESC>\n" +
                    "\t                <DEP_CODE_OA>33333</DEP_CODE_OA>\n" +
                    "\t                <DEP_DESC_OA>部门1</DEP_DESC_OA>\n" +
                    "\t                </ITEM>\t         \n" +
                    "\t                <ITEM>\n" +
                    "\t                <DEP_CODE>1111</DEP_CODE>\n" +
                    "\t                <DEP_DESC>部门</DEP_DESC>\n" +
                    "\t                <DEP_CODE_OA>33333</DEP_CODE_OA>\n" +
                    "\t                <DEP_DESC_OA>部门1</DEP_DESC_OA>\n" +
                    "\t                </ITEM>\t         \n" +
                    "\t                </ITEMS>\n" +
                    "\t                </ROOT>";
			
			
			
			/*String xml2="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
	                "\t\t\t\t<ROOT>\n" +
	                "\t\t\t\t<ITEMS>\n" +
	                "\t\t\t\t\t<ITEM>\n" +
	                "\t\t\t\t\t<PROJECT_NAME>昆明市城建投资项目</PROJECT_NAME>\n" +
	                "\t\t\t\t\t<PROJECT_CODE>00123434/</PROJECT_CODE>\n" +
	                "\t\t\t\t\t<COM_CODE>45454</COM_CODE>\n" +
	                "\t\t\t\t\t<COM_DESC>云南项目</COM_DESC>\n" +
	                "\t\t\t\t\t</ITEM>\n" +	         
	                "\t\t\t\t</ITEMS>\n" +
	                "\t\t\t\t</ROOT>";*/
			 RPCServiceClient ser = new RPCServiceClient ();  
			Options options1 = ser.getOptions();  
			  
			// 指定调用WebService的URL  
			EndpointReference targetEPR1 = new EndpointReference("http://100.16.16.40/seeyon/services/caiWuSysDataService?wsdl");  
			options1.setTo(targetEPR1);  
			//options.setAction("命名空间/WS 方法名");   
			options1.setAction("http://impl.kdXdtzXc.services.v3x.seeyon.com/sysDepartments"); //方法名 
			  
			// 指定sfexpressService方法的参数值  
			Object[] opAddEntryArgs1 = new Object[] { xml3.toString()};  
			// 指定sfexpressService方法返回值的数据类型的Class对象  
			Class[] classes1 = new Class[] { String.class };  
			// 指定要调用的sfexpressService方法及WSDL文件的命名空间  com.seeyon.apps.kdXdtzXc.manager
			QName opAddEntry1 = new QName("http://impl.kdXdtzXc.services.v3x.seeyon.com","sysDepartments");  
			// 调用sfexpressService方法并输出该方法的返回值  
			String str = ser.invokeBlocking(opAddEntry1, opAddEntryArgs1, classes1)[0].toString(); 
			System.out.println(str);
		} catch (AxisFault e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	public void test3() throws HttpException, IOException{
		String url = "http://localhost:8080/WebServiceTest2/services/Add";  
		  
		byte[] requestBytes;  
		String soapRequestInfo = null;//addClient.getSoapRequestInfo();  
		requestBytes = soapRequestInfo.getBytes("utf-8");  
		  
		HttpClient httpClient = new HttpClient();  
		PostMethod postMethod = new PostMethod(url);  
		postMethod.setRequestHeader("SOAPAction", "http://tempuri.org/GetMiscInfo");//Soap Action Header!  
		  
		InputStream inputStream = new ByteArrayInputStream(requestBytes, 0, requestBytes.length);  
		RequestEntity requestEntity = new InputStreamRequestEntity(inputStream, requestBytes.length, "application/soap+xml; charset=utf-8");  
		postMethod.setRequestEntity(requestEntity);  
		  
		int state = httpClient.executeMethod(postMethod);  
		  
		InputStream soapResponseStream = postMethod.getResponseBodyAsStream();  
		InputStreamReader inputStreamReader = new InputStreamReader(soapResponseStream);  
		BufferedReader bufferedReader = new BufferedReader(inputStreamReader);  
		  
		String responseLine = "";  
		String soapResponseInfo = "";  
		while((responseLine = bufferedReader.readLine()) != null) {  
		    soapResponseInfo = soapResponseInfo + responseLine;  
		}  
	}
	
	
	
	@Test
	public void test2(){
		try {
			System.out.println("进入 getCaiWu 数据接口");
			String jiPiao=HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
			JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
			String xiechengXML  = jsonObject2.optString("xml");
			System.out.println("得到的xml"+xiechengXML);	
			RPCServiceClient ser = new RPCServiceClient ();  
			Options options1 = ser.getOptions();  
			  
			// 指定调用WebService的URL  
			EndpointReference targetEPR1 = new EndpointReference("http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl");  
			options1.setTo(targetEPR1);  
			//options.setAction("命名空间/WS 方法名");   
			options1.setAction("http://xmlns.oracle.com/apps/xxt/soaprovider/plsql/xxt_soa_capital_travel_pkg/process_travel_api"); //方法名 
			  
			// 指定sfexpressService方法的参数值  
			Object[] opAddEntryArgs1 = new Object[] { xiechengXML.toString()};  
			// 指定sfexpressService方法返回值的数据类型的Class对象  
			Class[] classes1 = new Class[] { String.class };  
			// 指定要调用的sfexpressService方法及WSDL文件的命名空间  com.seeyon.apps.kdXdtzXc.manager
			QName opAddEntry1 = new QName("http://xmlns.oracle.com/apps/xxt/soaprovider/plsql/xxt_soa_capital_travel_pkg/","process_travel_api");  
			// 调用sfexpressService方法并输出该方法的返回值  
			String str = ser.invokeBlocking(opAddEntry1, opAddEntryArgs1, classes1)[0].toString(); 
			System.out.println(str);
		} catch (AxisFault e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	  @Test
	    public void cwPost() throws ClientProtocolException, UnsupportedEncodingException, IOException {
	        //为了防止中文参数乱码，则可以用URLEncoder编码，再传递即可
		  String jiPiao=HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
			JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
			String xiechengXML  = jsonObject2.optString("xml");
	        Response execute = Request.Post("http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/")//初始化
	                //.body(new StringEntity("{\"user82\":{\"id\":99,\"name\":\"zhj9\"}}"))//在请求体中设置请求参数
	                .body(new StringEntity(xiechengXML))//在请求体中设置请求参数
	                .setHeader("content-type", "application/xml")//设置请求头,告知服务端，请求参数格式，以使得服务端可以正常接收解析参数
	                .execute();//发送
	        System.out.println("execute"+execute);
	    }
	
	
	/*public static void main(String[] args){

		try {
			String jiPiao=HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
			JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
			String xiechengXML  = jsonObject2.optString("xml");
			System.out.println("得到的xml"+xiechengXML);	
			int i = 0;
			URL url = new URL(
					"http://80.32.9.177:8000/webservices/SOAProvider/plsql/xxt_test_ws_pkg2/?wsdl");
			
			while (i < 1) {
				URLConnection uc = url.openConnection();
				uc.setDoOutput(true);
				uc.setRequestProperty("Content-Type", "text/xml;charset=utf-8");
				PrintWriter pw = new PrintWriter(uc.getOutputStream());
				pw.println(xiechengXML);
				pw.close();

				DocumentBuilderFactory bf = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = bf.newDocumentBuilder();
				InputStream inputStream = uc.getInputStream();
				System.out.println("****"+inputStream);
				Document document = db.parse(inputStream);

				 //System.out.println(document);
				System.out.println("X_RETURN_STATUS:"
						+ document.getElementsByTagName("X_RETURN_STATUS").item(0)
								.getTextContent());
				System.out.println("i:" + i+document);
				i = i + 1;
			}
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	*/

	  
	  @Test
		public void testPost() throws ClientProtocolException, UnsupportedEncodingException, IOException{
			String jiPiao=HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
			JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
			String xiechengXML  = jsonObject2.optString("xml");
			Request.Post("http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/PROCESS_TRAVEL_API")
		           //.body(new StringEntity("{\"user82\":{\"id\":99,\"name\":\"zhj9\"}}"))
			       .body(new StringEntity(xiechengXML))
		           .setHeader("content-type", "application/xml")
		           .execute();
		}
	  
	  public static String doPostSoap1_1(String postUrl, String soapXml,  
	            String soapAction) {  
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
	
 public static void main(String[] args)throws Exception{
		String jiPiao=HttpClientUtil.post("http://localhost:8080/teaglepf/xiecheng/jpjs/flightOrderSettlementInfo/getAll.do","");
		JSONObject jsonObject2 = (JSONObject) JSONSerializer.toJSON(jiPiao);
		String xiechengXML  = jsonObject2.optString("xml");
		System.out.println(xiechengXML);
        String url="http://c1-zjckweb1.zc.cinda.ccb:8000/webservices/SOAProvider/plsql/xxt_soa_capital_travel_pkg/?wsdl";  

		//doPostSoap1_1(url,xiechengXML,"");
	}
	  
}
