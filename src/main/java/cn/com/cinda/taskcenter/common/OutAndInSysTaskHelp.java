package cn.com.cinda.taskcenter.common;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.po.TaskGroups;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.util.DBAgent;

public class OutAndInSysTaskHelp {
	private static TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
	// 获得应用对应的分类 {TZD=业务类, GJSJ=业务类, OALC=行政事务, MEETING=行政事务}
	public static Map<String,String>  getTaskGroupMap() {
		// 获取分类
		List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
		Map<String,String> appSrcMap = new LinkedHashMap<String,String> ();
		if(list!=null && list.size()>0){
			for (TaskGroups taskGroups : list) {
				appSrcMap.put(taskGroups.getApp(), taskGroups.getName());
			}
		}
		return appSrcMap;
	}

	// 获得分类名称
	public static Map<String,String>  getGroupTypeName() {
		// 获取分类
		Map<String,String> appSrcMap = new LinkedHashMap<String,String> ();
		List<TaskGroups> list = taskCenterManager.getAllTaskGroups();
		if(list!=null && list.size()>0){
			
			for (TaskGroups taskGroups : list) {
				if(appSrcMap.get(taskGroups.getName())==null){
					appSrcMap.put(taskGroups.getName(), taskGroups.getApp());
				}else{
					String val = appSrcMap.get(taskGroups.getName())+","+taskGroups.getApp();
					appSrcMap.put(taskGroups.getName(), val);
				}
			}
		}
//		String groups = UrlHelp.getVal("GROUP", "groups");
//		// System.out.println(groups);
//
//		Map appSrcMap = new LinkedHashMap();
//		String[] arr = groups.split(",");
//		for (int i = 0; i < arr.length; i++) {
//			String tmp2 = UrlHelp.getVal("GROUP_NAME", arr[i]);
//			// System.out.println(tmp2);
//
//			String tmp = UrlHelp.getVal("GROUP_APP", arr[i]);
//
//			appSrcMap.put(tmp2, tmp);
//		}
//
//		// System.out.println("===============" + appSrcMap);

		return appSrcMap;
	}

	public static void main(String[] args) {
		Map map = getTaskGroupMap();
		System.out.println(map);

		map = getGroupTypeName();
		System.out.println(map);
	}
}
