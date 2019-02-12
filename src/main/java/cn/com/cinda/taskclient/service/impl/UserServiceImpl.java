package cn.com.cinda.taskclient.service.impl;

import java.io.FileInputStream;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.taskcenter.webclient.HKServiceClient;
import com.seeyon.ctp.util.Strings;

import cn.com.cinda.taskcenter.common.TaskInfor;

public class UserServiceImpl {

	public static Logger log = Logger.getLogger(UserServiceImpl.class);

	/**
	 * 新版用户管理的服务接口地址
	 */
	public static String userPubServiceUrl = "http://c1-osmapp.cinda.ccb:8071/gempMgrWeb/axis/services/userPubService";

	public UserServiceImpl() {
		init();
	}

	/**
	 * 初始化配置文件
	 */
	public void init() {

		FileInputStream is = null;
		String webServiceUrl = "";
		try {
			Properties initVars = new Properties();
			is = new FileInputStream(TaskInfor.CONFIG_FILE_PATH);
			initVars.load(is);
			webServiceUrl = initVars.getProperty("taskCenter.userPubServiceUrl");

		} catch (Exception e) {
			log.error("读取配置文件[" + TaskInfor.CONFIG_FILE_PATH +"]错误：", e);
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (Exception e) {
					log.error("关闭文件流错误：", e);
				}
			}
		}
		if(!Strings.isBlank(webServiceUrl)){
			userPubServiceUrl = webServiceUrl;
		}
	}
	
	public String getUserDeptIdByjtuserId(String jtuserId){
		try {
			if (!connect(userPubServiceUrl)) {
				return "";
			}

			//自己的实现方式
			String[] ret = null;
			HKServiceClient client = new HKServiceClient(userPubServiceUrl);
			Object result = client.invokeMethod("getUserCurrentOrg", new Object[]{jtuserId});
			if(result!=null && result.getClass().isArray()){
				ret = (String[]) result;
			}

			if (ret != null && ret.length > 0) {
				return ret[0]; // 部门id
			} else {
				return "";
			}
		} catch (Exception ex) {
			log.error("getUserDeptIdByjtuserId: ",ex);
		}
		return "";
	}
	/**
	 * 根据帐号获得用户的userId
	 * 
	 * @param account
	 * @return
	 */
	public String getUserIdByAccount(String account) {
		try {
			if (!connect(userPubServiceUrl)) {
				return "";
			}

			//自己的实现方式
			String[][] ret = null;
			HKServiceClient client = new HKServiceClient(userPubServiceUrl);
			Object result = client.invokeMethod("getLoginOrgs", new Object[]{account});
			if(result!=null && result.getClass().isArray()){
				ret = (String[][]) result;
			}

			if (ret != null && ret.length > 0) {
				return ret[0][0]; // userId
			} else {
				return "";
			}
		} catch (Exception ex) {
			log.error("getUserIdByAccount: ",ex);
		}

		return "";
	}

	/**
	 * 测试服务地址
	 * 
	 * @param url
	 * @return
	 */
	public static boolean connect(String url) {
		try {
			URL res = new URL(url);
			String hostName = res.getHost();
			int port = (res.getPort() == -1) ? 80 : res.getPort();

			// 初步端口测试
			Socket server = new Socket();
			InetSocketAddress address = new InetSocketAddress(hostName, port);
			server.connect(address, 1000);
			server.close();

			// 服务地址测试
			HttpURLConnection conn = (HttpURLConnection) res.openConnection();
			int state = conn.getResponseCode();

			if (state == 200 || state == 500 || state == 405) {// 服务有效
				return true;
			} else {
				log.debug("探测服务连接失败！服务地址:" + url);
				return false;
			}
		} catch (Exception e) {
			log.debug("探测服务连接异常！服务地址:" + url);
		}

		return false;
	}


public static void main(String[] args) {
	UserServiceImpl client = new UserServiceImpl();
	Object result = client.getUserIdByAccount("jsbfkq");
	Object res1 = client.getUserDeptIdByjtuserId(String.valueOf(result));
	System.out.println(JSONObject.toJSONString(res1));
	
}
}
