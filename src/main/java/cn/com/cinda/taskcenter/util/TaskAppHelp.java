package cn.com.cinda.taskcenter.util;

import java.util.Map;

import cn.com.cinda.taskcenter.dao.QueryTaskDetail;

/**
 * 根据应用CODE得到应用NAME
 * 
 * @author tcy
 * 
 */
public class TaskAppHelp {

	private static Map appNameMap = null;

	private static void init() {
		QueryTaskDetail qt = new QueryTaskDetail();
		appNameMap = qt.getAppNameMap();
	}

	public static Map getAppNameMap() {
		if (appNameMap == null) {
			init();
		}
		return appNameMap;
	}

	public static String getAppNameByCode(String appCode) {
		if (appNameMap == null) {
			init();
		}

		return (String) appNameMap.get(appCode);
	}

}
