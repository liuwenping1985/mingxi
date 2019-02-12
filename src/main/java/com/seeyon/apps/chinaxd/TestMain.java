package com.seeyon.apps.chinaxd;

import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.xerces.dom.CoreDocumentImpl;
import org.apache.xerces.dom.DocumentImpl;
import org.codehaus.xfire.client.Client;
import org.codehaus.xfire.service.OperationInfo;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.ctp.util.Datetimes;




public class TestMain {
	public static void main(String[] args) throws Exception {
		String url = "http://192.168.18.132";
		String authurl = url+"/seeyon/services/authorityService?wsdl";
		String token = getToken(authurl);
		String data = "{\"bill\":{\"position\":\"/OKR/4WYTCmm1XH8NtcPa3SuYS4=\",\"empNumber\":\"test-1\",\"empName\":\"测试-1\",\"enrollDate\":\"2016-09-07\",\"adminOrgUnit\":\"8r0AAAAA2sDM567U\",\"bizDate\":\"2016-09-07\"},\"status\":\"1\",\"billEntrys\":[{\"index\":\"学习能力\",\"weight\":0.10,\"describe\":\"学习能力评价标准\",\"type\":\"1\"},{\"index\":\"工作目标及完成情况\",\"weight\":0.05,\"describe\":\"工作目标及完成情况评价标准....\",\"type\":\"2\"}]}";
		
		String uri = url+"/seeyon/services/devFormFlowServices?wsdl";
		String result = sendFormNoclient(url,token , data);
		System.out.println(result);
	}
	public static String getToken(String wsdlUrl) throws Exception{

		DocumentImpl result = null;
		Client client = new Client(new URL(wsdlUrl));
		Object[] resp = client.invoke("authenticate", new Object[]{"service-admin","123456"});
		result = (DocumentImpl) resp[0];
		return ((CoreDocumentImpl) result.getFirstChild()).getTextContent();
	
	}
	public static String sendFormNoclient(String wsdlUrl ,String token , String fromdata) throws  Exception{
		String result = "";
		Client client = new Client(new URL(wsdlUrl));
		Object[] resp = client.invoke("launchFormCollaboration", new Object[]{token, "ljx", "empToformal", "", fromdata});
		if(resp!=null && resp.length>0){
			result = (String) resp[0];
		}
		 return result;
	}
	public static String getServicesToken(String address,String userName,String password) throws Exception{

		DocumentImpl result = null;
		Client client = new Client(new URL(address+"/seeyon/services/authorityService?wsdl"));
		Collection<OperationInfo> list = client.getService().getServiceInfo().getOperations();
		for (OperationInfo info : list) {
			System.out.println(info.getName());
			Object[] resp = client.invoke(info, new Object[]{"service-admin","123456"});
			result = (DocumentImpl) resp[0];
			System.out.println(((CoreDocumentImpl) result.getFirstChild()).getTextContent());
		}
		return ((CoreDocumentImpl) result.getFirstChild()).getTextContent();
	
	}

	public static String sendForm(String token , String fromdata){
/*		 DevFormFlowServices service = new DevFormFlowServices();
		 DevFormFlowServicesPortType portType = service.getDevFormFlowServicesHttpSoap11Endpoint();
		 String result = portType.launchFormCollaboration(token, "ljx", "asdf", "sadf", fromdata);*/
		String result = null;
		 return result;
	}

	public static String makeFormData(){
		String dataString = "";
		Map<String,Object> map = new HashMap<String,Object>();
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		map.put("subdata", list);
		Map<String,String> submap = new HashMap<String,String>();
		submap.put("姓名", "刘建新");
		submap.put("性别", "男");
		list.add(submap);
		Map<String,String> submap2 = new HashMap<String,String>();
		submap2.put("姓名", "张三");
		submap2.put("性别", "男");
		list.add(submap2);

		Map<String,String> submap3 = new HashMap<String,String>();
		submap3.put("姓名", "李四:ssas");
		submap3.put("性别", "男");
		list.add(submap3);
		map.put("申请日期", Datetimes.format(new Date(), "yyyy-MM-dd"));
		map.put("申请部门", "开发部");
		map.put("填单人", "刘建新");
		dataString = JSONObject.toJSONString(map);
		
		return dataString;
		
		
	}

}
