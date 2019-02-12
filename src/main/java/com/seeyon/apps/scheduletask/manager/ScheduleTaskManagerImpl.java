package com.seeyon.apps.scheduletask.manager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.scheduletask.ScheduleTaskJob;
import com.seeyon.apps.scheduletask.TaskConfig;
import com.seeyon.apps.scheduletask.constant.STConstants;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public class ScheduleTaskManagerImpl implements ScheduleTaskManager{
	private static final Log log = LogFactory.getLog(ScheduleTaskManagerImpl.class);
	private int enabled = SystemProperties.getInstance().getIntegerProperty("", 0);
	private static final String ScheduleTask_KEY = "DEV_AO_SCHEDULE_TASK_KEY";
	private ConfigManager configManager;
	private List<String> beanNames;
	public void setBeanNames(List<String> beanNames) {
		this.beanNames = beanNames;
	}
	public int getEnabled() {
		return enabled;
	}

	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	public void setConfigManager(ConfigManager configManager) {
	    this.configManager = configManager;
	}
	public void init()
	{
		if(enabled != 0)
			return;
		
		try {
			this.listScheduleTask();
			log.info("定时任务加载完成！");
		} catch (Exception e) {
			log.error("加载自定义定时任务出错！\n",e);
		}
	}

	@Override
	public ScheduleTaskJob getScheduleTask(String beanName){
		Map<String,ScheduleTaskJob> cache = this.getCache();
		if(cache.size()==0){
			this.listScheduleTask();
		}else if(cache.get(beanName)==null){
			TaskConfig config = new TaskConfig(beanName);
			cache.put(beanName, config.toScheduleTaskJob());
		}
		return cache.get(beanName);
	}
	@Override
	public boolean isCanExcute(String beanName) {
		return this.getScheduleTask(beanName).getConfig().isCanExcute();
	}
	@Override
	public void saveOrUpdataConfig(ScheduleTaskJob task) {
		//更新配置
		ConfigItem item = configManager.getConfigItem(STConstants.Configuration, task.getConfig().getBeanId());
		if(item==null){
			
			item =  configManager.addConfigItem(STConstants.Configuration, task.getConfig().getBeanId(), task.getConfig().getBeanId());
			
		}
		item.setExtConfigValue(task.getConfig().toxml());
		configManager.updateConfigItem(item);
		task.registerTask();
		
	}
	private Map<String,ScheduleTaskJob> getCache(){
		Map<String,ScheduleTaskJob> cache = (Map<String, ScheduleTaskJob>) AppContext.getCache(ScheduleTask_KEY);
		if(cache==null){
			cache = new ConcurrentHashMap<String, ScheduleTaskJob>();
			AppContext.putCache(ScheduleTask_KEY, cache);
		}
		return cache;
	}
	@Override
	public List<ScheduleTaskJob> listScheduleTask() {
		List<ScheduleTaskJob> listTask= new ArrayList<ScheduleTaskJob>();
		Map<String,ScheduleTaskJob> cache = this.getCache();
		if(cache.size()!=0){
			listTask.addAll(cache.values());
		}else{
			if(beanNames !=null && beanNames.size()>0){
				List<ConfigItem> listItem = configManager.listAllConfigByCategory(STConstants.Configuration);
				if(listItem!=null && listItem.size() >0){
					for (ConfigItem configItem : listItem) {
						String beanName = configItem.getConfigItem();
						String configXml = configItem.getExtConfigValue();
						TaskConfig config = TaskConfig.toTaskConfig(configXml);
						ScheduleTaskJob task = config.toScheduleTaskJob();
						if(task==null){
							this.deleteScheduleTask(beanName);
						}
						if(task!=null){
							listTask.add(task);
							cache.put(beanName, task);
						}
					}
				}
				//处理新增
				if(beanNames.size()>0){
					for (String beanName : beanNames) {
						TaskConfig config = new TaskConfig(beanName);
						ScheduleTaskJob taskJob =config.toScheduleTaskJob();
						if(taskJob!=null&&!cache.keySet().contains(taskJob.getConfig().getBeanId())){
							log.info("加载新定时任务"+taskJob.getConfig().getBeanId()+"到系统");
							this.saveOrUpdataConfig(taskJob);
							listTask.add(taskJob);
							cache.put(beanName, taskJob);
						}
					}
				}
			}
		}
		return listTask;
	}
	@Override
	public  void deleteScheduleTask(String beanName) {
		ScheduleTaskJob task = this.getScheduleTask(beanName);
		task.getConfig().setCanExcute(false);
		task.registerTask();
		ConfigItem item = configManager.getConfigItem(STConstants.Configuration, beanName);
		if(item!=null){
			configManager.deleteConfigItem(STConstants.Configuration, beanName);
		}
	}
	@AjaxAccess
	@Override
	public boolean isRuning(String beanName) {
		return this.getScheduleTask(beanName).isRuning();
	}
}
