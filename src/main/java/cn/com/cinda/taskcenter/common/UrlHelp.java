
package cn.com.cinda.taskcenter.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.po.TaskGroups;
import com.seeyon.ctp.common.AppContext;

public class UrlHelp
{
	private static final Log log = LogFactory.getLog(UrlHelp.class);
	private static TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
	private static String TaskGroupCacheKey = "TASK_CENTER_GROUP_KEY";
	public static List<String> getOutSysGroupApp(){
		List<String> results = new ArrayList<String>();
    	List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
    	if(list!=null && list.size()>0){
    		for (TaskGroups taskGroups : list) {
				if(taskGroups.isOutSys()){
					results.add(taskGroups.getApp());
				}
			}
    	}
		return results;
	}	
	public static List<String> getGroupApps(String groupCode){
		List<String> results = new ArrayList<String>();
    	List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
    	if(list!=null && list.size()>0){
    		for (TaskGroups taskGroups : list) {
				if(taskGroups.getGroupCode().equals(groupCode)){
					results.add(taskGroups.getApp());
				}
			}
    	}
		return results;
	}
	public static List<String> getAllGroupApps(){
		List<String> results = new ArrayList<String>();
    	List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
    	if(list!=null && list.size()>0){
    		for (TaskGroups taskGroups : list) {
					results.add(taskGroups.getApp());
			}
    	}
		return results;
	}
	public static List<String> getGroups(){
		List<String> results = new ArrayList<String>();
		Map<String,TaskGroups> tmpmap = new HashMap<String, TaskGroups>();
    	List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
    	if(list!=null && list.size()>0){
    		for (TaskGroups taskGroup : list) {
				tmpmap.put(taskGroup.getGroupCode(), taskGroup);
			}
    	}
    	results.addAll(tmpmap.keySet());
		return results;
	}
	public static Map<String,String> getGroupNamekeyMap(){
		Map<String,String> tmpmap = (Map<String, String>) AppContext.getCache("CINDA_GroupNamekeyMap");
		if(tmpmap==null || tmpmap.size()==0){
			tmpmap = new HashMap<String, String>();
			AppContext.putCache("CINDA_GroupNamekeyMap", tmpmap);
			synchronized (tmpmap) {
				if(tmpmap.size()==0){
					List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
					if(list!=null && list.size()>0){
						for (TaskGroups taskGroup : list) {
							tmpmap.put(taskGroup.getName(), taskGroup.getGroupCode());
						}
					}
				}
			}
		}
		return tmpmap;
	}
//    public static String getVal(String area, String key)
//    {
//		
////    	List<TaskGroups> list = (List<TaskGroups>) AppContext.getCache(TaskGroupCacheKey);
////    	if(list==null){
////    		
////    	}
//    	List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
//    	if(list!=null && list.size()>0){
//    		for (TaskGroups taskGroups : list) {
//			}
//    	}
//    	
//    	
//    	return key;
//
//    	
//    }
}