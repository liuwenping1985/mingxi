package com.seeyon.apps.checkin.aberrant;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import com.seeyon.apps.checkin.domain.CheckInInstall;
import com.seeyon.apps.checkin.manager.CheckInInstallManager;
import com.seeyon.ctp.common.AppContext;

/**
 * 异常处理类
 * 
 * @author administrator
 * @since 2013-06-12
 */
public class CheckTask implements Runnable  {
	
	private CheckInInstallManager checkininstallmanager;

	public CheckInInstallManager getCheckininstallmanager() {
		return checkininstallmanager;
	}

	public void setCheckininstallmanager(CheckInInstallManager checkininstallmanager) {
		this.checkininstallmanager = checkininstallmanager;
	}

	public void run() 
	{
		System.out.println("CheckTask run()...........");
		try 
		{
			while (true) 
			{
				long startSyncTime =getSleepTime(); 
				if (startSyncTime > 0) 
				{
					TimeUnit.MILLISECONDS.sleep(startSyncTime);
					checkininstallmanager = (CheckInInstallManager) AppContext.getBean("checkininstallmanager");
					// 检查前一天的考勤信息
					checkininstallmanager.checkYesterdayCheckin();
					// 发起表单
					checkininstallmanager.startUpForm();
				}
				else
				{
					break;
				}
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * 获取休眠时间
	 * 
	 * @param currentTimeMillis
	 * @return
	 */
	private long getSleepTime() {
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date todayDate = new Date();//今天日期
		Calendar now = Calendar.getInstance();
		now.setTime(todayDate);
		now.set(Calendar.DATE, now.get(Calendar.DATE) + 1);
		Date tomorrowDate = now.getTime();
		Date startTimeD=null;//启动时间
		
		//取得服务器当前时间
		long nowtime = System.currentTimeMillis();
		
		checkininstallmanager = (CheckInInstallManager) AppContext.getBean("checkininstallmanager");
		//查询考勤设置表
		List<CheckInInstall> rsinitns = checkininstallmanager.selectffectivect();
		//异常判定时间点(0:30)
		String errorTime = "";
		try {
			if(null != rsinitns && rsinitns.size() > 0){
				for(CheckInInstall inin : rsinitns){
					errorTime = inin.getErrorTime();//0:30
				}
			}else{
				return 0;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		String startTimeStr = "";
		
		try {
			String todayd = sdfDate.format(todayDate);
			String todaystime = todayd + " " + errorTime;
			Date todaystartt = sdfDateTime.parse(todaystime); 
			if(todaystartt.compareTo(todayDate)>0){
				startTimeStr= todayd + " " + errorTime;//启动时间为当天2013-07-05 + 异常判定时间1:30:00 = 2013-07-05 1:30:00
			}else{				
				startTimeStr= sdfDate.format(tomorrowDate) + " " + errorTime;//启动时间为明天2013-07-06 + 异常判定时间1:30:00 = 2013-07-05 1:30:00
			}
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		
		//获取启动的时间
		try {
			startTimeD = sdfDateTime.parse(startTimeStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		long startL = startTimeD.getTime();
		
		long startSyncTime = startL - nowtime;
		return startSyncTime;
	}
}
