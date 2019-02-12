package com.seeyon.v3x.services.plugin.synchorg;

import java.rmi.RemoteException;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.syncorg.czdomain.CzAccount;
import com.seeyon.apps.syncorg.czdomain.CzDepartment;
import com.seeyon.apps.syncorg.czdomain.CzLevel;
import com.seeyon.apps.syncorg.czdomain.CzMember;
import com.seeyon.apps.syncorg.czdomain.CzPost;
import com.seeyon.apps.syncorg.czdomain.CzReturn;
import com.seeyon.apps.syncorg.enums.ActionTypeEnum;
import com.seeyon.apps.syncorg.enums.ObjectTypeEnum;
import com.seeyon.apps.syncorg.util.CzXmlUtil;
import com.seeyon.apps.webclient.util.WebServiceClient;

public class TestSyncOrgServices {

//	public static String url  = "http://80.32.9.246";
	public static String url  = "http://192.168.0.42";
	public static String xml  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

	
	public static void main(String [] args) throws RemoteException{
		boolean ok = synchDept();
		while(ok){ 
			try {
				syncAccount();
				ok = synchDept();
				synchMember();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			}
		
	}
	
	public static String testGetToken(){
		String [] params = new String [] {"service-admin", "123456"};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/authorityService?wsdl");
		Object [] result = webClient.invokeMethod("authenticate", params);
		org.apache.xerces.dom.DocumentImpl doc = (org.apache.xerces.dom.DocumentImpl) result[0];
		//System.out.println(doc.getFirstChild().getTextContent());
		return null;
		//return doc.getFirstChild().getTextContent();
	}
	
	public static void checkToken(String token){
		// 单位的测试
		// 新增加一个 OA 中没有的单位
		
		String xml = CzXmlUtil.toXml(createData_Level());
		String [] params = new String [] {testGetToken(), ObjectTypeEnum.Level.name(), ActionTypeEnum.AddOrUpdate.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String returnXml = result[0].toString();
		CzReturn czReturn = CzXmlUtil.toBean(returnXml, CzReturn.class);
		System.out.println(czReturn.getSuccess() + czReturn.getErrorMessage());

		// 测试新增人员 (通过)
		// 测试修改人员 (真实姓名)
		// 启用人员
		// 停用人员
		// 删除人员
		
		// 岗位的测试
		// 测试新增岗位, 岗位编码检查, 岗位名称检查, 排序好测试
		// 修改岗位
		// 停用岗位
		// 启用岗位
		// 删除岗位
		
		// 职务级别的测试
		// 新增职务级别
		// 修改
		// 停用
		// 启用
		// 删除
		
		
		// 部门的测试
		// 新增部门, 部门编码检查， 部门名称检查
		// 修改
		// 停用
		// 启用
		// 删除
		

	}
	public static boolean syncAccount(){
		String token =  testGetToken();
		
//		testSyncOrg();
		String xml = CzXmlUtil.toXml(createData_Account());
		System.out.println(xml);
		String [] params = new String [] {token, ObjectTypeEnum.Account.name(), ActionTypeEnum.Update.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String msg = (String) result[0];
		System.out.println(JSONObject.toJSONString(result));
		if(msg.contains("true")){
			return true;
		}
		return false;
	}
	public static boolean addAccount(){
		String token =  testGetToken();
		
//		testSyncOrg();
		String xml = CzXmlUtil.toXml(createData_Account());
		System.out.println(xml);
		String [] params = new String [] {token, ObjectTypeEnum.Account.name(), ActionTypeEnum.Add.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String msg = (String) result[0];
		System.out.println(JSONObject.toJSONString(result));
		if(msg.contains("true")){
			return true;
		}
		return false;
	}
	public static CzAccount createData_Account(){
		CzAccount account = new CzAccount();

		account.setName("OA中没有的单位22");
		account.setDiscription("从第三方系统新增加的单位22");
		account.setThirdAccountId("third022");
		account.setSortId("4"); 
		return account;
	}
	public static boolean addDept(){
		String token =  testGetToken();
		String xml = CzXmlUtil.toXml(createData_Department());
		System.out.println(xml);
		String [] params = new String [] {token, ObjectTypeEnum.Department.name(), ActionTypeEnum.Add.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String msg = (String) result[0];
		System.out.println(JSONObject.toJSONString(result));
		if(msg.contains("true")){
			return true;
		}
		return false;
	}
	public static boolean synchDept(){
		String token =  testGetToken();
		String xml = CzXmlUtil.toXml(createData_Department());
		System.out.println(xml);
		String [] params = new String [] {token, ObjectTypeEnum.Department.name(), ActionTypeEnum.Update.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String msg = (String) result[0];
		System.out.println(JSONObject.toJSONString(result));
		if(msg.contains("true")){
			return true;
		}
		return false;
	}
	public static boolean synchMember(){
		String token =  testGetToken();
		String xml = CzXmlUtil.toXml(createData_Member());
		System.out.println(xml);
		String [] params = new String [] {token, ObjectTypeEnum.Member.name(), ActionTypeEnum.Update.name(), xml};
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg", params);
		String msg = (String) result[0];
		System.out.println(JSONObject.toJSONString(result));
		if(msg.contains("true")){
			return true;
		}
		return false;
	}
	public static CzDepartment createData_Department(){
		CzDepartment department = new CzDepartment();
		department.setDep_sort("22");
		department.setDepartmentId("thirdDept22");
		department.setDepartmentName("第third2下的部门222"); 
		department.setParentId("third022");
		department.setDiscription("第二部门下子部门描述1111");
		
		return department;
	}
	
	
	
	public static CzLevel createData_Level(){
		CzLevel level = new CzLevel();

		level.setName("第一职务级别22-22");
		level.setCode("level001");
		
		return level;
	}
	
	public static CzPost createData_Post(){
		CzPost post = new CzPost();
		post.setAccountCode("code001");
		post.setCode("/OKR/4WYTCmm1XH8NtcPa3SuYS4=3");
		post.setDiscription("第一岗位描述");
		post.setOcupationName("第一岗位88");
		post.setSortId("");
		return post;
	}	
	
	public static CzMember createData_Member(){
		CzMember member = new CzMember();

		member.setUserId("memberId008");
		member.setEmail("a@a.com");
		member.setLoginName("test008");
		member.setPer_sort("1");
		member.setSex("1");
		member.setTrueName("测试人员一888-888");
		member.setAccountCode("third022");
		member.setDepartmentId("thirdDept22");
		
		return member;
	}
	
	private static void testSyncOrg(){
		CzMember czMember = new CzMember();
		czMember.setAccountCode("code001");
		czMember.setDeptartmentCode("001");
		czMember.setLoginName("test001");
		czMember.setPassWord("654321");
		czMember.setSex("1");
		czMember.setCode("1234");
		czMember.setTrueName("测试001");
		Object [] params = new Object [4];
		params[0] = testGetToken();
		params[1] = "Member";
		params[2] = "Add";
		params[3] = CzXmlUtil.toXml(czMember);
		WebServiceClient webClient = new WebServiceClient(url+"/seeyon/services/syncOrgServices?wsdl");
		Object [] result = webClient.invokeMethod("syncOrg",  params);
		System.out.println(result[0].toString());
	}
}
