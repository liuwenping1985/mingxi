package com.seeyon.apps.taskcenter.webclient;

import java.io.InputStream;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

import cn.com.hkgt.webservice.axis.handler.InitSign;

public class TaskSample {

	public static void main(String[] args) {
		try {

			String wsdlUrl = "http://80.46.8.73:8071/gtaskctr/axis/services/taskPubService?wsdl";
			String nameSpaceUri = "http://80.46.8.73:8071/gtaskctr/axis/services/taskPubService";

			// 调用接口时，授权的用户
			String userName = "hkuser01";
			// 证书存放路径
			String certPath = "/config/keys/hkuser01.p12";

			// 创建调用对象
			Service service = new Service();
			Call call = (Call) service.createCall();

			// 设置service所在URL
			call.setTargetEndpointAddress(new java.net.URL(wsdlUrl));

			// 设置访问时使用的用户名
			// call.getMessageContext().setUsername(userName);

			InputStream is = TaskSample.class.getResourceAsStream(certPath);
			String signedText = InitSign.initHkSign(is, userName);
			is.close();

			// 设置访问时使用的密码
			// call.getMessageContext().setPassword(signedText);

			// 初始化签名后的用户信息
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "username", userName));
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "password", signedText));

			/**
			 * 7.3.1 创建任务
			 * @param String[][]
			 * @return String
			 */
			
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
			String ret10 = (String) call
					.invoke(new Object[] { data });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.1 创建任务：");
				System.out.print(ret10);
			}
			
			/**
			 * 7.3.2 执行任务
			 * @param String 任务id
			 * @param String 任务状态
			 * @param String 任务意见
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "executeTask"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","1","任务意见" });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.2 执行任务：");
				System.out.print(ret10);
			}
					
			/**
			 * 7.3.3 查询任务信息
			 * @param String 任务id
			 * @return String[]
			 */
			call.setOperationName(new QName(nameSpaceUri, "queryTask"));
			// 初始化参数，并调用接口
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

			/**
			 * 7.3.4 删除任务
			 * @param String[] 任务id
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "deleteTask"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-10671100-115401"} });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.4 删除任务：");
				System.out.print(ret10);
			}
			
			/**
			 * 7.3.5更新任务数据
			 * @param String 任务id
			 * @param String 任务附加数据
			 * @param String 任务其他链接编码
			 * @param String 任务其他链接名称
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "updateTaskData"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","urlpath=../gongwen/gwFrame.jsp?Method=Deal||RECORD_ID=50197||ENTITY_ID=3||TASK_ID=106701||SELECT_MODEL=1||FLOW_ID=89927","任务其他链接编码","任务其他链接名称" });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.5更新任务数据：");
				System.out.print(ret10);
			}
			
			/**
			 * 7.3.6 更新任务状态
			 * @param String[] 任务id
			 * @param String[] 任务状态
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "updateTaskStatus"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-106710-115401"},new String[]{"1"}  });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.6 更新任务状态：");
				System.out.print(ret10);
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
			call.setOperationName(new QName(nameSpaceUri, "updateTaskCreateor"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","11922457","费克勤","111585","信息技术部" });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.7更新任务创建人：");
				System.out.print(ret10);
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
			call.setOperationName(new QName(nameSpaceUri, "updateTaskExecutor"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401","11922457","费克勤","111585","信息技术部" });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.8更新任务执行人：");
				System.out.print(ret10);
				System.out.print(",");
			}
			
			/**
			 * 7.3.9 更新任务主题
			 * @param String[] 任务id
			 * @param String[] 任务主题
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "updateTaskSubject"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { new String[]{"OALC-106710-115401"},new String[]{"任务主题"}  });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.9 更新任务主题：");
				System.out.print(ret10);
				System.out.print(",");
			}
			
			/**
			 * 7.3.10 任务转交
			 * @param String 原任务id
			 * @param String[][] {{新任务Id，转交人Id，转交人姓名，转交人机构Id， 转交人机构名称}}
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "transferTask"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-106710-115401" ,new String[][]{{"OALC-106711-115401","11922457","费克勤","111585","信息技术部"}}  });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.10 任务转交：");
				System.out.print(ret10);
				System.out.print(",");
			}
			
			/**
			 * 7.3.11 流程结束
			 * @param String 流程id
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri, "completeFlow"));
			// 初始化参数，并调用接口
			ret10 = (String) call
					.invoke(new Object[] { "OALC-899100"  });

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.11 流程结束：");
				System.out.print(ret10);
				System.out.print(",");
			}
			
			/**
			 * 7.3.12 查询用户待办数量
			 * @param String 用户id
			 * @param String 应用编码
			 * @return String
			 */
			call
					.setOperationName(new QName(nameSpaceUri,
							"queryTaskCount"));
			// 初始化参数，并调用接口
			ret10 = (String) call.invoke(new Object[] {
					"11922457", "APP_SYS_OA" });

			System.out.println();
			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.12 查询用户待办数量：");
				System.out.print(ret10);
				System.out.println();

				}

			
			/**
			 * 7.3.13 查询用户待办
			 * @param String 用户id
			 * @param String 应用编码
			 * @param int 当前页数
			 * @param int 每页显示记录数
			 * @return String[][] 
			 */
			call
					.setOperationName(new QName(nameSpaceUri,
							"queryTaskList"));
			// 初始化参数，并调用接口
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
			
			
			/**
			 * 7.3.14 查询指定状态任务数量
			 * @param String 用户id
			 * @param String 应用编码
			 * @param String 任务状态
			 * @return String
			 */
			call.setOperationName(new QName(nameSpaceUri,
					"queryTaskCountByStatus"));
			// 初始化参数，并调用接口
			ret10 = (String) call.invoke(new Object[] { "11922457","APP_SYS_OA","1" });

			System.out.println();

			if (ret10 != null) {
				System.out.println();
				System.out.println("7.3.14 查询指定状态任务数量：");
				System.out.print(ret10);
				System.out.println();
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
			call.setOperationName(new QName(nameSpaceUri,
					"queryTaskListByStatus"));
			// 初始化参数，并调用接口
			ret2 = (String[][]) call.invoke(new Object[] { "11922457","APP_SYS_OA","1",1,15 });

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


		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
