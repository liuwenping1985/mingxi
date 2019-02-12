package com.seeyon.apps.taskcenter.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.task.domain.TaskApp;
import com.seeyon.apps.taskcenter.task.domain.TaskLinkType;

public interface TaskCenterDao {
	public List findBysql(String sql, Map<String, Object> params);
	public <T> List<T> getAll(Class<T> cls);
	public <T> T getById(Class<T> clazz,String Id);
	public List<TaskApp> getAllTaskApp();
	public List find(String hql ,Object[] params);
	public List<TaskLinkType> getAllTAskLinkType();
	List<?> findListByHQL(String hql, Map<String, Object> agrs);
	List<?> findListByHQL(String hql, Map<String, Object> agrs, int start,
			int size);
}
