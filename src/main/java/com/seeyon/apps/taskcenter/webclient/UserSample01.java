package com.seeyon.apps.taskcenter.webclient;


import java.io.InputStream;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

import cn.com.hkgt.webservice.axis.handler.InitSign;

public class UserSample01 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			String wsdlUrl = "http://80.46.8.73:8071/gumWeb/axis/services/userPubService?wsdl";
			String nameSpaceUri = "http://80.46.8.73:8071/gumWeb/axis/services/userPubService";

			// 调用接口时，授权的用户
			String userName = "hkuser01";
			// 证书存放路径
			String certPath = "/config/keys/hkuser01.p12";

			// 创建调用对象
			Service service = new Service();
			Call call;

			call = (Call) service.createCall();

			// 设置service所在URL
			call.setTargetEndpointAddress(new java.net.URL(wsdlUrl));

			// 设置访问时使用的用户名
			// call.getMessageContext().setUsername(userName);

			InputStream is = UserSample01.class.getResourceAsStream(certPath);
			String signedText = InitSign.initHkSign(is, userName);
			is.close();

			// 设置访问时使用的密码
			// call.getMessageContext().setPassword(signedText);

			// 初始化签名后的用户信息
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "username", userName));
			call.addHeader(new org.apache.axis.message.SOAPHeaderElement(
					"Authorization", "password", signedText));

			// 3.3.1 获得指定用户信息
			call.setOperationName(new QName(nameSpaceUri, "getUserInfo"));
			// 初始化参数，并调用接口
			String[] ret1 = (String[]) call.invoke(new Object[] { "11922457" });

			if (ret1 != null) {
				System.out.println();
				System.out.println("3.3.1  用户基本信息：");
				for (int i = 0; i < ret1.length; i++) {
					System.out.print(ret1[i]);
					System.out.print(",");
				}

				System.out.println();
			}

			// 3.3.2 获得指定用户所在的本级机构
			call.setOperationName(new QName(nameSpaceUri, "getUserCurrentOrg"));
			// 初始化参数，并调用接口
			String[] ret3 = (String[]) call.invoke(new Object[] { "11922457" });

			if (ret3 != null) {
				System.out.println();
				System.out.println("3.3.2 获得指定用户所在的本级机构：");
				for (int i = 0; i < ret3.length; i++) {
					String tmp = ret3[i];
					System.out.print(tmp);
					System.out.println();

				}
			}

			// 3.3.3 获得指定用户所在的一级机构
			call.setOperationName(new QName(nameSpaceUri, "getUserTopOrg"));
			// 初始化参数，并调用接口
			ret3 = (String[]) call.invoke(new Object[] { "11922457" });

			if (ret3 != null) {
				System.out.println();
				System.out.println("3.3.3 获得指定用户所在的一级机构：");
				for (int i = 0; i < ret3.length; i++) {
					String tmp = ret3[i];
					System.out.print(tmp);
					System.out.println();
				}
			}

			// 3.3.4 获得用户ID数组对应的用户名称(输入数组最大长度为50)
			call.setOperationName(new QName(nameSpaceUri, "getUserNames"));
			// 初始化参数，并调用接口
			String[][] ret2 = (String[][]) call
					.invoke(new Object[] { new String[] { "11922457" } });

			if (ret2 != null) {
				System.out.println();
				System.out.println("3.3.4 用户ID数组对应的用户名称列表：");
				for (int i = 0; i < ret2.length; i++) {
					String[] tmp = ret2[i];
					for (int j = 0; j < tmp.length; j++) {
						System.out.print(tmp[j]);
						System.out.print(",");
					}
					System.out.println();

				}
			}

			// 3.3.7 获得指定机构角色的用户列表
			call.setOperationName(new QName(nameSpaceUri, "getRoleUsers"));
			// 初始化参数，并调用接口
			ret2 = (String[][]) call
					.invoke(new Object[] { "0", "1177814004984" });

			if (ret2 != null) {
				System.out.println();
				System.out.println("3.3.7获得指定机构角色的用户列表：");
				for (int i = 0; i < ret2.length; i++) {
					String[] tmp = ret2[i];
					for (int j = 0; j < tmp.length; j++) {
						System.out.print(tmp[j]);
						System.out.print(",");
					}
					System.out.println();

				}
			}

			// 3.3.8 获得多个机构角色的用户列表
			call.setOperationName(new QName(nameSpaceUri, "getRoleUsers"));
			// 初始化参数，并调用接口
			ret2 = (String[][]) call.invoke(new Object[] { "0",
					new String[] { "1177814004984" } });

			if (ret2 != null) {
				System.out.println();
				System.out.println("3.3.8 获得多个机构角色的用户列表：");
				for (int i = 0; i < ret2.length; i++) {
					String[] tmp = ret2[i];
					for (int j = 0; j < tmp.length; j++) {
						System.out.print(tmp[j]);
						System.out.print(",");
					}
					System.out.println();

				}
			}

			// 3.3.9 获得指定角色id下的用户列表
			call.setOperationName(new QName(nameSpaceUri, "getRoleUsersById"));
			// 初始化参数，并调用接口
			ret2 = (String[][]) call.invoke(new Object[] { "0" });

			if (ret2 != null) {
				System.out.println();
				System.out.println("3.3.9 获得指定角色id下的用户列表：");
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
