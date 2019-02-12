package com.seeyon.apps.taskcenter.webclient;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.rmi.RemoteException;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.description.OperationDesc;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.ctp.common.SystemEnvironment;

import cn.com.cinda.taskcenter.model.Task;
import cn.com.hkgt.webservice.axis.handler.InitSign;

public class HKServiceClient {
	private static final Log log = LogFactory.getLog(HKServiceClient.class);
	
//	public static String wsdlUrl = "http://80.46.8.73:8071/gtaskctr/axis/services/taskPubService?wsdl";
//	public static String nameSpaceUri = "http://80.46.8.73:8071/gtaskctr/axis/services/taskPubService";
	private String nameSpaceUri = null;
	private String wsdlUrl = null;
	private Call call = null;
	private boolean ismainMethod = false;
	
	/**
	 * 7.3.1 创建任务
	 * @param String[][]
	 * @return String
	 */
	public boolean createTask(Task task){
		boolean soucess = false;

		
		String[][] data = new String[1][20];
		data[0][0] = "OALC-106710-115401";
		data[0][1] = "APP_SYS_OA";
		data[0][2] = "APP_SYS_OA_FW";
		data[0][3] = "待办列表测试";
		data[0][4] = "OALC-89927";
		data[0][5] = "1";
		data[0][6] = "费克勤 拟稿";
		data[0][7] = "11922457";
		data[0][8] = "费克勤";
		data[0][9] = "111585";
		data[0][10] = "信息技术部";
		data[0][11] = "11922457";
		data[0][12] = "费克勤";
		data[0][13] = "1177813996062";
		data[0][14] = "信息技术部";
		data[0][15] = "";
		data[0][16] = "urlpath=../gongwen/gwFrame.jsp?Method=Deal||RECORD_ID=50197||ENTITY_ID=3||TASK_ID=106701||SELECT_MODEL=1||FLOW_ID=89927";
		data[0][17] = null;
		data[0][18] = null;
		data[0][19] = null;
		
		call.setOperationName(new QName(nameSpaceUri, "createTask"));
		// 初始化参数，并调用接口
		String ret10 = null;
		try {
			ret10 = (String) call
					.invoke(new Object[] { data });
		} catch (Exception e) {
			log.error("",e);
		}

		if (ret10 != null) {
			System.out.println();
			System.out.println("7.3.1 创建任务：");
			System.out.print(ret10);
			soucess = true;
		}
		return soucess;
		
	}
	
	/**
	 * 7.3.2 执行任务
	 * @param String 任务id
	 * @param String 任务状态
	 * @param String 任务意见
	 * @return String
	 */
	public boolean  executeTask(String taskId , String taskState , String taskComment){
		boolean soucess = false;
		call.setOperationName(new QName(nameSpaceUri, "executeTask"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
//					.invoke(new Object[] { "OALC-106710-115401","1","任务意见" });
					.invoke(new Object[] { taskId,taskState,taskComment });
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.2 执行任务：");
				System.out.print(ret10);
				soucess = true;
			}
		} catch (Exception e) {
			log.error("",e);
		}
		return soucess;


	}
	/**
	 * 7.3.3 查询任务信息
	 * @param String 任务id
	 * @return String[]
	 */
	public boolean queryTask (){
		call.setOperationName(new QName(nameSpaceUri, "queryTask"));
		// 初始化参数，并调用接口
		try {
			String[] ret = (String[]) call
					.invoke(new Object[] { "OALC-106710-115401" });

			if (ret != null) {
				System.out.println();
				System.out.println("7.3.3 查询任务信息：");
				for (int i = 0; i < ret.length; i++) {
					System.out.print(ret[i]);
					System.out.print(",");
				}
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 7.3.4 删除任务
	 * @param String[] 任务id
	 * @return String
	 */
	public void deleteTask(){
		call.setOperationName(new QName(nameSpaceUri, "deleteTask"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-10671100-115401"} });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.4 删除任务：");
				System.out.print(ret10);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.5更新任务数据
	 * @param String 任务id
	 * @param String 任务附加数据
	 * @param String 任务其他链接编码
	 * @param String 任务其他链接名称
	 * @return String
	 */
	public void updateTaskData(){
		
		call.setOperationName(new QName(nameSpaceUri, "updateTaskData"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","urlpath=../gongwen/gwFrame.jsp?Method=Deal||RECORD_ID=50197||ENTITY_ID=3||TASK_ID=106701||SELECT_MODEL=1||FLOW_ID=89927","任务其他链接编码","任务其他链接名称" });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.5更新任务数据：");
				System.out.print(ret10);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.6 更新任务状态
	 * @param String[] 任务id
	 * @param String[] 任务状态
	 * @return String
	 */
	public void updateTaskStatus(){
		
		call.setOperationName(new QName(nameSpaceUri, "updateTaskStatus"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-106710-115401"},new String[]{"1"}  });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.6 更新任务状态：");
				System.out.print(ret10);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.7更新任务创建人
	 * @param String 任务id
	 * @param String 创建人id
	 * @param String 创建人姓名
	 * @param String 创建人机构id
	 * @param String 创建人机构名称
	 * @return String
	 */
	public void updateTaskCreateor(){
		
		call.setOperationName(new QName(nameSpaceUri, "updateTaskCreateor"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","11922457","费克勤","111585","信息技术部" });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.7更新任务创建人：");
				System.out.print(ret10);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.8更新任务执行人
	 * @param String 任务id
	 * @param String 执行人id
	 * @param String 执行人姓名
	 * @param String 执行人机构id
	 * @param String 执行人机构名称
	 * @return String
	 */
	public void updateTaskExecutor(){
		
		call.setOperationName(new QName(nameSpaceUri, "updateTaskExecutor"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","11922457","费克勤","111585","信息技术部" });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.8更新任务执行人：");
				System.out.print(ret10);
				System.out.print(",");
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.9 更新任务主题
	 * @param String[] 任务id
	 * @param String[] 任务主题
	 * @return String
	 */
	public void updateTaskSubject(){
		
		call.setOperationName(new QName(nameSpaceUri, "updateTaskSubject"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-106710-115401"},new String[]{"任务主题"}  });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.9 更新任务主题：");
				System.out.print(ret10);
				System.out.print(",");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.10 任务转交
	 * @param String 原任务id
	 * @param String[][] {{新任务Id，转交人Id，转交人姓名，转交人机构Id， 转交人机构名称}}
	 * @return String
	 */
	public void transferTask(){
		
		call.setOperationName(new QName(nameSpaceUri, "transferTask"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401" ,new String[][]{{"OALC-106711-115401","11922457","费克勤","111585","信息技术部"}}  });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.10 任务转交：");
				System.out.print(ret10);
				System.out.print(",");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 7.3.11 流程结束
	 * @param String 流程id
	 * @return String
	 */
	public boolean completeFlow(){
		
		call.setOperationName(new QName(nameSpaceUri, "completeFlow"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call
					.invoke(new Object[] { "OALC-899100"  });
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.11 流程结束：");
				System.out.print(ret10);
				System.out.print(",");
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 7.3.12 查询用户待办数量
	 * @param String 用户id
	 * @param String 应用编码
	 * @return String
	 */
	public void queryTaskCount(){
		
		call
		.setOperationName(new QName(nameSpaceUri,
				"queryTaskCount"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call.invoke(new Object[] {
					"11922457", "APP_SYS_OA" });
			
			System.out.println();
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.12 查询用户待办数量：");
				System.out.print(ret10);
				System.out.println();
				
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	/**
	 * 7.3.13 查询用户待办
	 * @param String 用户id
	 * @param String 应用编码
	 * @param int 当前页数
	 * @param int 每页显示记录数
	 * @return String[][] 
	 */
	public void queryTaskList(){
		
		call
		.setOperationName(new QName(nameSpaceUri,
				"queryTaskList"));
		// 初始化参数，并调用接口
		try {
			String[][] ret2 = (String[][]) call
					.invoke(new Object[] { "11922457", "APP_SYS_OA",1,15 });
			
			if (ret2 != null) {
				System.out.println();
				System.out.println("7.3.13 查询用户待办：");
				for (int i = 0; i < ret2.length; i++) {
					String[] tmp = ret2[i];
					for (int j = 0; j < tmp.length; j++) {
						System.out.print(tmp[j]);
						System.out.print(",");
					}
					System.out.println();
					
				}
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 7.3.14 查询指定状态任务数量
	 * @param String 用户id
	 * @param String 应用编码
	 * @param String 任务状态
	 * @return String
	 */
	public void queryTaskCountByStatus(){
		
		call.setOperationName(new QName(nameSpaceUri,
				"queryTaskCountByStatus"));
		// 初始化参数，并调用接口
		try {
			String ret10 = (String) call.invoke(new Object[] { "11922457","APP_SYS_OA","1" });
			
			System.out.println();
			
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.14 查询指定状态任务数量：");
				System.out.print(ret10);
				System.out.println();
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 7.3.15 查询指定状态任务
	 * @param String 用户id
	 * @param String 应用编码
	 * @param String 任务状态
	 * @param int 当前页数
	 * @param int 每页显示记录数
	 * @return String[][] 
	 */
	public void queryTaskListByStatus(){
		
		call.setOperationName(new QName(nameSpaceUri,
				"queryTaskListByStatus"));
		// 初始化参数，并调用接口
		try {
			String[][] ret2 = (String[][]) call.invoke(new Object[] { "11922457","APP_SYS_OA","1",1,15 });
			
			System.out.println();
			
			if (ret2 != null) {
				System.out.println();
				System.out.println("7.3.15 查询指定状态任务：");
				for (int i = 0; i < ret2.length; i++) {
					String[] tmp = ret2[i];
					for (int j = 0; j < tmp.length; j++) {
						System.out.print(tmp[j]);
						System.out.print(",");
					}
					System.out.println();
					
				}
			}
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public Object invokeMethod(String methodName,Object[] params){
		log.info("调用华科接口nameSpaceUri="+nameSpaceUri+" ，methodName="+methodName+" ,params="+JSONObject.toJSONString(params));
		if(call!=null){
			call.setOperationName(new QName(nameSpaceUri, methodName ));
			try {
				return call.invoke(params);
			} catch (Exception e) {
				log.error("调用华科接口是出现错误",e);
			}
		}else{
			log.info("调用华科接口nameSpaceUri="+nameSpaceUri+" ，初始化未成功");
		}
		return null;
		
	}
	public Object invokeUserService(HKUserMethodEnum method ,Object[] params){
		return this.invokeMethod(method.name(), params);
	}
	public Object invokeTaskService(HKTaskMethodEnum method ,Object[] params){
		return this.invokeMethod(method.name(), params);
	}
	/**
	 * 初始化客户端
	 * @param nameSpaceUri
	 */
	public HKServiceClient(String nameSpaceUri){
		this.nameSpaceUri = nameSpaceUri;
		this.wsdlUrl = nameSpaceUri+"?wsdl";
		log.info("初始化客户端HKServiceClient链接，nameSpaceUri="+nameSpaceUri);
//		log.info("wsdlUrl"+wsdlUrl);
		try {
			// 调用接口时，授权的用户
			String userName = "hkuser01";
			// 证书存放路径
			String certPath = SystemEnvironment.getApplicationFolder()+"/WEB-INF/cfgHome/plugin/taskcenter/cinda/keys/hkuser01.p12";
			log.info("userName="+userName+"   证书存放路径为："+certPath);
			// 创建调用对象
			Service service = new Service();
			this.call = (Call) service.createCall();

			// 设置service所在URL
			call.setTargetEndpointAddress(new java.net.URL(wsdlUrl));

			// 设置访问时使用的用户名
			// call.getMessageContext().setUsername(userName);

//			InputStream is = HKServiceClient.class.getResourceAsStream(certPath);
			File crt = new File(certPath);
			InputStream is = new FileInputStream(crt);
			String signedText = InitSign.initHkSign(is, userName);
			is.close();

			// 设置访问时使用的密码
			// call.getMessageContext().setPassword(signedText);

			// 初始化签名后的用户信息
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "username", userName));
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "password", signedText));
			
		} catch (Exception e) {
			log.error("初始化客户端异常",e);
		}

	}
	public static enum HKUserMethodEnum{
		getUserInfo("3.3.1 获得指定用户信息"),
		getUserCurrentOrg("3.3.2 获得指定用户所在的本级机构"),
		getUserTopOrg("3.3.3 获得指定用户所在的一级机构"),
		getUserNames("3.3.4 获得用户ID数组对应的用户名称(输入数组最大长度为50)"),
		getRoleUsers("3.3.7 获得指定机构角色的用户列表");
		private String description;
		
		private HKUserMethodEnum(String description) {
			this.description = description;
		}
		public String getDescription() {
			return description;
		}

	}
	public static enum HKTaskMethodEnum{
		createTask,
		executeTask,
		queryTask,
		deleteTask,
		updateTaskData,
		updateTaskStatus,
		updateTaskCreateor,
		updateTaskExecutor,
		updateTaskSubject,
		transferTask,
		completeFlow,
		queryTaskCount,
		queryTaskList,
		queryTaskCountByStatus,
		queryTaskListByStatus,
	}
	
	
	public static enum HKOrgMethodEnum{
		getDepartmentInfo("2.3.1 获得指定机构信息"),
		getChildDepartments("2.3.2 获得指定机构的下级机构列表"),
		getParentDepartment("2.3.3  获得指定机构的上级机构"),
		getDepartmentTreeById("2.3.4 获得指定机构的下级机构树"),
		getAllParentDepartments("2.3.5 获得指定机构的所有上级机构"),
		getOrgPaths("2.3.6 获得机构ID数组对应的机构全路径"),
		getCorporations("2.3.7 获得集团和一级子机构列表");
		
		private String description;
		
		private HKOrgMethodEnum(String description) {
			this.description = description;
		}
		public String getDescription() {
			return description;
		}
	}

	public static void main(String[] args) {
		 String taskUri = "http://80.46.8.73:8071/gtaskctr/axis/services/taskPubService";
		 String userUri = "http://80.46.8.73:8071/gumWeb/axis/services/userPubService";
		 String url = "http://192.168.18.129/seeyon/services/authorityService";
		HKServiceClient client = new HKServiceClient(userUri);
		Object result = client.invokeMethod("getLoginOrgs", new Object[]{"jsbfkq"});
		System.out.println(JSONObject.toJSONString(result));

	}
}
