package com.seeyon.apps.taskcenter.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.po.ProRoleResource;
import com.seeyon.apps.taskcenter.po.ProSystemConfigLink;
import com.seeyon.ctp.common.dao.BaseDao;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;

public class TaskCenterOADaoImpl extends BaseDao<BasePO> implements TaskCenterOADao {
	@Override
	public <T> T find(Class<T> cls ,Long id){
		return this.getHibernateTemplate().load(cls,id);
	}
	@Override
	public <T> List<T> findAll(Class<T> cls){
		return this.getHibernateTemplate().loadAll(cls);
	}
	@Override
	public List  find( String hql , Map<String,Object> param){
		return DBAgent.find(hql, param);
	}
	@Override
	public void saveOrUpdate(BasePO po){
		this.getHibernateTemplate().saveOrUpdate(po);
	}
	@Override
	public void saveOrUpdateAll(List list){
		this.getHibernateTemplate().saveOrUpdateAll(list);
	}
	@Override
	public List<TaskCenterResource> listTaskCenterResource() {
		String hql = "select new "+TaskCenterResource.class.getName()+"(u.id, u.code, u.name, u.link, u.createTime, u.remark, u.level) from "+ProSystemConfigLink.class.getName() +" u where 1=1 order by u.code";
		Map<String ,Object> params = new HashMap<String, Object>();
		List list = DBAgent.find(hql, params);
		if(list!=null){
			return list;
		}
		return new ArrayList<TaskCenterResource>();
	}
	@Override
	public List<Long> listResourceIdsByroleId(Long roleId, String roleType) {
		StringBuffer hql = new StringBuffer();
		hql.append("select u.resourceId from "+ProRoleResource.class.getName() +" u where u.roleid =:roleId");
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("roleId", roleId);
		
		if(Strings.isNotBlank(roleType)){
			hql.append(" and u.roleType =:roleType ");
			params.put("roleType", roleType);
		}
		List<Long> list = DBAgent.find(hql.toString(), params);
		if(list!=null){
			return list;
		}
		return new ArrayList<Long>();
	}
	@Override
	public void deleteResourceRoleByRoleId(Long roleId, String roleType) {
		StringBuffer hql = new StringBuffer();
		hql.append("DELETE FROM " + ProRoleResource.class.getName() + " u where u.roleid =:roleId");
		Map<String ,Object> params = new HashMap<String, Object>();
		params.put("roleId", roleId);
		
		if(Strings.isNotBlank(roleType)){
			hql.append(" and u.roleType =:roleType ");
			params.put("roleType", roleType);
		}
		this.bulkUpdate(hql.toString(), params, new Object[]{});
	}
	


	
}
