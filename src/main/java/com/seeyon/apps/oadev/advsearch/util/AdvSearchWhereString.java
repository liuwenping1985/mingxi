package com.seeyon.apps.oadev.advsearch.util;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.mozilla.universalchardet.prober.SBCSGroupProber;

import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;


public class AdvSearchWhereString {

	public static Map<String, Object> getWhereString(String tableName,
			Map<String, String> params) {
		Map<String, Object> retval = new HashMap();
		StringBuffer conditionSb = new StringBuffer("");
		Map<String, Object> retParams = new HashMap();

		Iterator<String> ite = params.keySet().iterator();
		while (ite.hasNext()) {
			String key = (String) ite.next();
		//	if("".equals(anObject))
			if ((params.get(key) != null)
					&& (!Strings.isBlank(String.valueOf(params.get(key))))) {
				if ("highquery".equals(key)) {
					// 处理高级查询

					List<Map<String, Object>> tempList = new ArrayList();
					Object temO = params.get(key);
					if ((temO instanceof Map)) {
						tempList.add((Map) temO);
					} else {
						tempList.addAll((List) temO);
					}

					Object[] o = SearchUtil.getHqlString(tableName, tempList);
					retParams = (Map<String, Object>) o[1];
					conditionSb.append(o[0]);
				} else {
					if(!"statusStr".equals(key)&&!key.startsWith("cz_")){
						List<Map<String, Object>> tempList = new ArrayList();

						Object temO = params.get(key);
						if ((temO instanceof Map)) {
							tempList.add((Map) temO);
						} else {
							tempList.addAll((List) temO);
						}
						
						//[(me.type = :Type0  ) , {Type0=1}]
						Object[] o=null;
						try{
							o = SearchUtil.getHqlString(tableName, tempList);
						}catch (Exception e) {
							if(key.equals("enable")){
								o=new Object[2];
								o[0]="(me.enable = :Enable0)";
								Map a=new HashMap<String, Object>();
								a.put("Enable0", tempList.get(0).get(SearchUtil.FIELDVALUE));
								o[1]=a;
							}
						}
						System.out.println(o.toString());
						retParams = (Map<String, Object>) o[1];
						conditionSb.append(o[0]);
						}
					}
			}
		}
		retval.put("whereString", conditionSb.toString());
		retval.put("params", retParams);
		return retval;
	}
}

