package com.seeyon.apps.scheduletask;

import java.io.Serializable;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.scheduletask.constant.STConstants;
import com.seeyon.apps.scheduletask.constant.STConstants.OrgTriggerDate;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.XMLCoder;

public class TaskConfig implements Serializable, Cloneable{
	private static final long serialVersionUID = -987647643563L;
	private static final Log log = LogFactory.getLog(TaskConfig.class);
	private String beanId;
	private String clazzName;
	private  int triggerHour = 23;
	private  int triggerMinute = 30;
    private  int intervalHour = 0;
	private  int intervalMin = 10;
	private  int timerType = STConstants.Timer_Type.intervalTime.ordinal();    
	private  OrgTriggerDate triggerDate = OrgTriggerDate.everyday;
	private String startTime;
	private Long accountId;
	private String taskTimestamp;			//任务同步时间戳
	private boolean canExcute = false;

	
    public TaskConfig() {
		super();
	}
	public TaskConfig(String clazzName) {
		super();
		this.clazzName = clazzName;
	}
	public String getClazzName() {
		return clazzName;
	}
	public void setClazzName(String clazzName) {
		this.clazzName = clazzName;
	}
	public String getBeanId() {
		return beanId;
	}
	public void setBeanId(String beanId) {
		this.beanId = beanId;
	}
	public int getTriggerHour() {
		return triggerHour;
	}
	public void setTriggerHour(int triggerHour) {
		this.triggerHour = triggerHour;
	}
	public int getTriggerMinute() {
		return triggerMinute;
	}
	public void setTriggerMinute(int triggerMinute) {
		this.triggerMinute = triggerMinute;
	}
	public int getIntervalHour() {
		return intervalHour;
	}
	public void setIntervalHour(int intervalHour) {
		this.intervalHour = intervalHour;
	}
	public int getIntervalMin() {
		return intervalMin;
	}
	public void setIntervalMin(int intervalMin) {
		this.intervalMin = intervalMin;
	}
	public int getTimerType() {
		return timerType;
	}
	public void setTimerType(int timerType) {
		this.timerType = timerType;
	}
	public OrgTriggerDate getTriggerDate() {
		return triggerDate;
	}
	public void setTriggerDate(OrgTriggerDate triggerDate) {
		this.triggerDate = triggerDate;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public Long getAccountId() {
		return accountId;
	}
	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}
	public String getTaskTimestamp() {
		return taskTimestamp;
	}
	public void setTaskTimestamp(String taskTimestamp) {
		this.taskTimestamp = taskTimestamp;
	}
	public boolean isCanExcute() {
		return canExcute;
	}
	public void setCanExcute(boolean canExcute) {
		this.canExcute = canExcute;
	}
	public static TaskConfig toTaskConfig(String xml){
		return (TaskConfig) XMLCoder.decoder(xml);
	}
	public ScheduleTaskJob toScheduleTaskJob(){
		ScheduleTaskJob taskJob =null;
		try {
			if(this.clazzName.indexOf(".")!=-1){
				Class clazz = Class.forName(this.clazzName);
				if(Strings.isBlank(beanId)){
					this.beanId = StringUtil.firstCharLower(clazz.getSimpleName());
				}
				taskJob = (ScheduleTaskJob) clazz.newInstance();
				taskJob.setConfig(this);
			}
			
		} catch (Exception e) {
			log.error("创建实例出错beanName="+clazzName,e);
		}
		return taskJob;
    }
    public String toxml(){
    	return XMLCoder.encoder(this);
    }	  
}
