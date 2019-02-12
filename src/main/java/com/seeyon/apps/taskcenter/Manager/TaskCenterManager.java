package com.seeyon.apps.taskcenter.Manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.apps.taskcenter.po.TaskGroups;
import com.seeyon.ctp.util.FlipInfo;

public interface TaskCenterManager {
	public void init();
	public List count(String loginName);
	public List<TaskGroups> getAllTaskGroups();
	public FlipInfo todoList(FlipInfo flipInfo, Map<String, String> param);
	public String taskCheak(String taskId);
	public FlipInfo listmydoneTask(FlipInfo flipInfo, Map<String, String> param);
	
	// 客开 GXY start
	public List<CenterTaskBO> newjasonTodolist(String userId,String group);
	// 客开  GXY end
}
