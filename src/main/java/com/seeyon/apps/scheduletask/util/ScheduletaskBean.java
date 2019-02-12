package com.seeyon.apps.scheduletask.util;

import java.lang.reflect.Method;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.Strings;

@SuppressWarnings("serial")
public class ScheduletaskBean extends ScheduleTaskJob{
	public static final Log log= LogFactory.getLog(ScheduletaskBean.class) ;
	private String jobBeanName;
	private String methodName;
	private Object[] jobParams;

	public String getJobBeanName() {
		return jobBeanName;
	}
	public void setJobBeanName(String jobBeanName) {
		this.jobBeanName = jobBeanName;
	}
	public String getMethodName() {
		return methodName;
	}
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	public Object[] getJobParams() {
		return jobParams;
	}
	public void setJobParams(Object[] jobParams) {
		this.jobParams = jobParams;
	}
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		if(!this.isRuning()){
			this.setRuning(true);
			log.info("开始执行定时任务"+this.getConfig().getBeanId());
			if(Strings.isNotBlank(getJobBeanName()) && Strings.isNotBlank(getMethodName())){
				Object bean = AppContext.getBean(this.getConfig().getBeanId());
				if(bean!=null){
					Class clazz = bean.getClass();
					Method[] methods = clazz.getDeclaredMethods();
					for (Method method : methods) {
						String methodName = method.getName();
						Class[] paramTypes = method.getParameterTypes();
						if(methodName.equals(this.getMethodName()) &&
								(paramTypes==null 
								|| (paramTypes.length==1 && paramTypes[0].isArray())
								|| paramTypes.length==this.getJobParams().length)){
							try {
								method.setAccessible(true);
								method.invoke(bean, getJobParams());
							} catch (Exception e) {
								log.error("定时任务"+this.getConfig().getBeanId()+"调用失败",e);
							}
						}
					}
				}
				log.info("没有找到"+getJobBeanName()+"对象！");
				
			}
			log.info("定时任务"+this.getConfig().getBeanId()+"完成！");
		}
		this.setRuning(false);
	}

}
