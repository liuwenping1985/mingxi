package com.seeyon.apps.kdXdtzXc.util;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class RequestUtil {
	public static Map<String, Object> getParameterValueMap(HttpServletRequest request, boolean remainArray) {
		Map<String, Object> map = new HashMap<String, Object>();
		Enumeration<?> params = request.getParameterNames();
		while (params.hasMoreElements()) {
			String key = params.nextElement().toString();
			String[] values = request.getParameterValues(key);
			if (remainArray){
				map.put(key, values);
			}else{
				if (values.length == 1) {
					map.put(key, values[0]);
				} else {
					map.put(key, getByAry(values));
				}

			}
		}
		return map;
	}
	
	private static String getByAry(String[] aryTmp) {
		String rtn = "";
		for (int i = 0; i < aryTmp.length; i++) {
			String str = aryTmp[i].trim();
			if (!str.equals("")) {
					rtn = rtn + str + ",";
			}
		}
		if (rtn.length() > 0)
			rtn = rtn.substring(0, rtn.length() - 1);
		return rtn;
	}
}
