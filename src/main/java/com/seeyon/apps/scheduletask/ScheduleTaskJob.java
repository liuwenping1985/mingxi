package com.seeyon.apps.scheduletask;


import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerUtils;

import com.seeyon.apps.scheduletask.constant.STConstants.OrgTriggerDate;
import com.seeyon.apps.scheduletask.constant.STConstants.Timer_Type;
import com.seeyon.apps.scheduletask.util.SDTaskUtil;
import com.seeyon.ctp.common.quartz.QuartzHolder;
import com.seeyon.ctp.common.quartz.QuartzListener;

public abstract class ScheduleTaskJob implements Job,Serializable {

	private static final long serialVersionUID = 2345678907654L;
	private final static Log logger = LogFactory.getLog(ScheduleTaskJob.class);

	private  boolean runing  = false;
	private TaskConfig config;
	public TaskConfig getConfig() {
		return config;
	}
	public void setConfig(TaskConfig config) {
		this.config = config;
	}

	public void setTaskTimestamp(String taskTimestamp) {
		if(this.config!=null){
			this.config.setTaskTimestamp(taskTimestamp);
		}
	}

	public boolean isRuning() {
		return runing;
	}
	public void setRuning(boolean runing) {
		this.runing = runing;
	}

	public  boolean setTriggerDate(OrgTriggerDate date) {
		if(this.config!=null){
			
			this.config.setTriggerDate(date);
		}
		return true;
	}
    public  boolean setIntervalTime(int intervalHour, int intervalMin) {
        if(intervalHour == 0 && intervalMin == 0){
            return false;
        }
        if(this.config!=null){
        	config.setIntervalHour(intervalHour);
        	config.setIntervalMin(intervalMin);
        }
        return true;
    }

	public  boolean setTriggerTime(int hour, int minute) {
		if( hour < 0 || hour > 23)
		{
			logger.warn("传入的日期参数不正确:" + hour + "，日期使用默认值"+config.getTriggerHour());
			
			return false;
		}
		if( minute < 0 || minute > 59)
		{
			logger.warn("传入的时间参数不正确:" + minute + "，日期使用默认值"+ config.getIntervalMin());	
			
			return false;
		}
		if(this.config!=null){
			config.setTriggerHour(hour);
			config.setTriggerMinute(minute);
		}
		return true;
	}
	  private boolean deleteScheduler()
	  {
	    boolean isDelete = false;
	    try
	    {
	    	if(QuartzHolder.hasQuartzJob(config.getBeanId())){
	    		QuartzHolder.deleteQuartzJob(config.getBeanId());
	    	}
	    	isDelete =  true;

	    }
	    catch (Exception e) {
	    	logger.error("删除任务" +config.getBeanId() + "失败");
	    }
		return isDelete;
	  }
	  
	  public void registerTask()
	  {
	    logger.info("注册调度任务" +config.getBeanId());
	    try
	    {		      
	    	if(!deleteScheduler()){
	    		logger.info("清除任务"+config.getBeanId()+"失败！");
	    		return;
	    	}
	    	if(!config.isCanExcute()){
	    		logger.info("定时任务"+config.getBeanId()+"已注消");
	    		return;
	    	}
	      Scheduler sched = QuartzListener.getScheduler();
	      if (sched == null) {
	        return;
	      }
	      Trigger trigger = null;
	      if (config.getTimerType() == Timer_Type.setTime.ordinal())
	      {
	        if (OrgTriggerDate.everyday.equals(config.getTriggerDate())) {
	          trigger = TriggerUtils.makeDailyTrigger(config.getTriggerHour(), config.getTriggerMinute());
	        } else {
	          trigger = TriggerUtils.makeWeeklyTrigger(config.getTriggerDate().key(), 
	            config.getTriggerHour(), config.getTriggerMinute());
	        }
	        Calendar calendar = Calendar.getInstance();
	        calendar.setTime(new Date());
	        calendar.set(13, calendar.get(13) + 5);
	        

	        trigger.setStartTime(
	          calendar.getTime());
	      }
	      else
	      {
	        int delta = (config.getIntervalHour() * 60 + config.getIntervalMin()) * 60;
	        trigger = TriggerUtils.makeSecondlyTrigger(delta);
	        




	        Calendar calendar = Calendar.getInstance();
	        calendar.setTime(new Date());
	        calendar.set(13, calendar.get(13) + delta);
	        

	        trigger.setStartTime(
	          calendar.getTime());
	      }
	      trigger.setName(config.getBeanId());
	      trigger.setJobName(config.getBeanId());
	      
	      JobDetail job = new JobDetail(config.getBeanId(), 
	        null, SDTaskUtil.getScheduleTask(config.getBeanId()).getClass());
	      
	      sched.scheduleJob(job, trigger);
	      logger.info("注册调度任务" + config.getBeanId() + ",成功");
	      return;
	    }
	    catch (SchedulerException e)
	    {
	      logger.error("注册调度任务" + config.getBeanId() + "失败", e);
	    }
	  }

}
