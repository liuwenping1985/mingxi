package com.seeyon.apps.taskcenter.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.ctp.common.po.BasePO;

public interface TaskCenterOADao {

	public void saveOrUpdate(BasePO po);

	public void saveOrUpdateAll(List list);

	public <T> T find(Class<T> cls , Long id);

	public <T> List<T> findAll(Class<T> cls);

	public List find(String hql, Map<String, Object> param);
	
	public List<TaskCenterResource> listTaskCenterResource();
	
	public void deleteResourceRoleByRoleId(Long roleId ,String roleType);

	public List<Long> listResourceIdsByroleId(Long roleId, String roleType);


}
