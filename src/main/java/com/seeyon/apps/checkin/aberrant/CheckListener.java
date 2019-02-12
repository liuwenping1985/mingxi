package com.seeyon.apps.checkin.aberrant;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.seeyon.apps.checkin.manager.CheckInInstallManager;

/**
 * 异常处理监听类
 * @author administrator
 * @since 2013-06-12
 */
@WebListener
public class CheckListener implements ServletContextListener{
	
	private CheckInInstallManager checkininstallmanager;

	public CheckInInstallManager getCheckininstallmanager() {
		return checkininstallmanager;
	}

	public void setCheckininstallmanager(CheckInInstallManager checkininstallmanager) {
		this.checkininstallmanager = checkininstallmanager;
	}
	@Override
	public void contextInitialized(ServletContextEvent event) {
//		System.out.println("======================CheckListener contextInitialized==========================");
//		//定义任务类
//		Runnable work = new CheckTask();
//		Thread thread = new Thread(work);
//		thread.start();
	}

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		
	}
}

	