package com.seeyon.apps.chinaxd;
import java.net.URL;

import org.apache.xerces.dom.CoreDocumentImpl;
import org.apache.xerces.dom.DocumentImpl;
import org.codehaus.xfire.client.Client;




public class MyTestMain {
	private static String url = "http://192.168.18.132";
	private static String authurl = url+"/seeyon/services/authorityService?wsdl";
	private static String uri = url+"/seeyon/services/devFormFlowServices?wsdl";
	public static void main(String[] args) throws Exception {
		String token = getToken(authurl);
/*		String data = "{\"bill\":{\"position\":\"/OKR/4WYTCmm1XH8NtcPa3SuYS4=\",\"empNumber\":\"test-1\",\"empName\":\"测试-1\",\"enrollDate\":\"2016-09-07\",\"adminOrgUnit\":\"8r0AAAAA2sDM567U\",\"bizDate\":\"2016-09-07\"},\"status\":\"1\",\"billEntrys\":[{\"index\":\"学习能力\",\"weight\":0.10,\"describe\":\"学习能力评价标准\",\"type\":\"1\"},{\"index\":\"工作目标及完成情况\",\"weight\":0.05,\"describe\":\"工作目标及完成情况评价标准....\",\"type\":\"2\"}]}";
		String result = sendFormNoclient(uri,token ,"gd","empToformal" ,data);
		System.out.println(result);*/
	}
	/**
	 * 获取token
	 * @param wsdlUrl
	 * @return
	 * @throws Exception
	 */
	public static String getToken(String wsdlUrl) throws Exception{

		DocumentImpl result = null;
		Client client = new Client(new URL(wsdlUrl));
		Object[] resp = client.invoke("authenticate", new Object[]{"service-admin","mustchange"});
		result = (DocumentImpl) resp[0];
		String token = ((CoreDocumentImpl) result.getFirstChild()).getTextContent();
		System.out.println("token==="+token);
		return token;
	
	}
	/**
	 * 发起OA流程
	 * @param wsdlUrl
	 * @param token
	 * @param senderLoginName
	 * @param formCode
	 * @param fromdata
	 * @return
	 * @throws Exception
	 */
	public static String sendFormNoclient(String wsdlUrl ,String token ,String senderLoginName,String formCode , String fromdata) throws  Exception{
		String result = "";
		Client client = new Client(new URL(wsdlUrl));
		Object[] resp = client.invoke("launchFormCollaboration", new Object[]{token, senderLoginName, formCode, "", fromdata});
		if(resp!=null && resp.length>0){
			result = (String) resp[0];
		}
		 return result;
	}


}
