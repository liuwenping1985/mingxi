package com.seeyon.apps.czexchange.common;

import java.math.BigDecimal;

public class CommonUtil {

	public static Long getLong(Object obj) {
		if(obj == null) {
			return null;
		}
		String typeName = obj.getClass().getSimpleName().toLowerCase();
		if (Integer.class.getSimpleName().toLowerCase().equals(
				typeName)) {
			return ((Integer) obj).longValue();
		} else if (Long.class.getSimpleName().toLowerCase()
				.equals(typeName)) {
			return (Long) obj;
		} else if (BigDecimal.class.getSimpleName().toLowerCase().equals(
				typeName)) {
			return ((BigDecimal) obj).longValue();
		}
		return new Long(obj.toString());
	}
	
	/**  
	 * 字符串日期转换成中文格式日期  
	 * @param date  字符串日期 yyyy-MM-dd  
	 * @return  yyyy年MM月dd日  
	 * @throws Exception  
	 */  
	public static String dateToCnDate(String date) {   
	    String result = "";   
	    String[]  cnDate = new String[]{"○","一","二","三","四","五","六","七","八","九"};   
	    String ten = "十";   
	    String[] dateStr = date.split("-");   
	    for (int i=0; i<dateStr.length; i++) {   
	        for (int j=0; j<dateStr[i].length(); j++) {   
	            String charStr = dateStr[i];   
	            String str = String.valueOf(charStr.charAt(j));   
	            if (charStr.length() == 2) {   
	                if (charStr.equals("10")) {   
	                    result += ten;   
	                    break;   
	                } else {   
	                    if (j == 0) {   
	                        if (charStr.charAt(j) == '1')    
	                            result += ten;   
	                        else if (charStr.charAt(j) == '0')   
	                            result += "";   
	                        else  
	                            result += cnDate[Integer.parseInt(str)] + ten;   
	                    }   
	                    if (j == 1) {   
	                        if (charStr.charAt(j) == '0')   
	                            result += "";   
	                         else  
	                            result += cnDate[Integer.parseInt(str)];   
	                    }   
	                }   
	            } else {   
	                result += cnDate[Integer.parseInt(str)];   
	            }   
	        }   
	        if (i == 0) {   
	            result += "年";   
	            continue;   
	        }   
	        if (i == 1) {   
	            result += "月";   
	            continue;   
	        }   
	        if (i == 2) {   
	            result += "日";   
	            continue;   
	        }   
	    }   
	    return result;   
	}  

}
