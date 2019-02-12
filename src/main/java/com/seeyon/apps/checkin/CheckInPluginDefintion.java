package com.seeyon.apps.checkin;

import com.seeyon.ctp.common.AbstractSystemInitializer;

public class CheckInPluginDefintion extends AbstractSystemInitializer {
	public void destroy() 
    {
        System.out.println("销毁checkIn模块");
    }

    public void initialize() 
    {
        System.out.println("初始化checkIn模块");
    }
//	public boolean isAllowStartup(ServletContext servletContext){
//		return true;
//	}
}
