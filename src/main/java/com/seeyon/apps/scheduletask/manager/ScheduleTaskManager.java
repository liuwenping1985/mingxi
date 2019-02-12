package com.seeyon.apps.scheduletask.manager;

import java.util.List;

import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.apps.scheduletask.constant.STConstants.OrgTriggerDate;



public interface ScheduleTaskManager {
	/**
	 * 初始化环境
	 * 这里会读取配置,并自动启动定时器
	 *
	 */
	public void init();
	public ScheduleTaskJob getScheduleTask(String beanName);
	public void saveOrUpdataConfig(ScheduleTaskJob task);
	public List<ScheduleTaskJob> listScheduleTask();
	public  void deleteScheduleTask(String beanName);
	public boolean isCanExcute(String beanName) ;
	public boolean isRuning(String beanName);
	

}
