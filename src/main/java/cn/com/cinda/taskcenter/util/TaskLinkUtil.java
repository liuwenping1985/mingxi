package cn.com.cinda.taskcenter.util;

import java.util.HashMap;

import cn.com.cinda.taskcenter.model.Task;

/**
 * 任务链接处理
 * 
 * @author hkgt
 * 
 */
public class TaskLinkUtil {

	/**
	 * 根据任务对象、链接类型获得任务链接
	 * 
	 * @param linkTypeCode
	 *            链接类型
	 * @param links
	 *            所有链接map
	 * @param task
	 *            任务对象
	 * @return 任务链接
	 */
	public static String getTaskLink(String linkTypeCode, HashMap links,
			Task task) {
		String tmp = "#";
		try {
			String linkTypeCode2 = linkTypeCode + "," + task.getTask_status();

			// 获得链接
			tmp = (String) links.get(linkTypeCode2);
			if (tmp == null) {
				return "#";
			}

			tmp = tmp.replaceAll("app_var_1", task.getApp_var_1());
			if(task.getApp_var_2()!=null)
			{
			tmp = tmp.replaceAll("app_var_2", task.getApp_var_2());
			}else
			{
				tmp = tmp.replaceAll("app_var_2", "");
				
			}
			tmp = tmp.replaceAll("app_var_3", task.getApp_var_3());
			tmp = tmp.replaceAll("app_var_4", task.getApp_var_4());
			tmp = tmp.replaceAll("app_var_5", task.getApp_var_5());
			tmp = tmp.replaceAll("app_var_6", task.getApp_var_6());
			tmp = tmp.replaceAll("app_var_7", task.getApp_var_7());
			tmp = tmp.replaceAll("app_var_8", task.getApp_var_8());
			tmp = tmp.replaceAll("app_var_9", task.getApp_var_9());

			tmp = tmp.replaceAll("task_app_state", task.getTask_app_state());

			return tmp;
		} catch (Exception ex) {
			 ex.printStackTrace();
		}

		return tmp;
	}
}
