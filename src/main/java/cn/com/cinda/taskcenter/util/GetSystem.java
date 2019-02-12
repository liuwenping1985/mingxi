package cn.com.cinda.taskcenter.util;

import java.util.Enumeration;
import java.util.Properties;

public class GetSystem {
	public String getProperty(String key)
	{
		String result=null;
		Properties prpt = System.getProperties();
	    Enumeration enm = prpt.propertyNames();  //返回系统属性列表中所有键的枚举
	    String key1 = "";
	    while(enm.hasMoreElements())
	    {
	     key1 = (String) enm.nextElement();
	     System.out.println(key1+":"+System.getProperty(key1,"undefined"));
	    }
	    result=System.getProperty(key,"undefined");
	    System.out.println("******************"+result);
		return result;
	}

}
