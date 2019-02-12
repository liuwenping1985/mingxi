package com.seeyon.apps.dev.doc.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmUser;
import com.seeyon.apps.cinda.authority.util.CZDBAgent;

public class CindaUserDaoImpl implements CindaUserDao {

	@Override
	public UmOrganization getOrgByName(String name) {
		String hql = " from cinda_user."+UmOrganization.class.getName() +" o where o.organizationname=:name";
		Map<String , Object> param = new HashMap<String ,Object>();
		param.put("name", name);
		List list = CZDBAgent.find(hql, param);
		if(list!=null && list.size()>0){
			return (UmOrganization) list.get(0);
		}
		return new UmOrganization();
	}

	@Override
	public UmUser getbyLoginNane(String loginName) {
		// loginname
		String hql = " from "+UmUser.class.getName() +" o where o.loginname=:loginName";
		Map<String , Object> param = new HashMap<String ,Object>();
		param.put("loginName", loginName);
		List list = CZDBAgent.find(hql, param);
		if(list!=null && list.size()>0){
			return (UmUser) list.get(0);
		}
		return new UmUser();
	}

	@Override
	public UmOrganization getOrgById(String Id) {
		String hql = " from cinda_user."+UmOrganization.class.getName() +" o where o.id=:Id";
		Map<String , Object> param = new HashMap<String ,Object>();
		param.put("Id", Id);
		List list = CZDBAgent.find(hql, param);
		if(list!=null && list.size()>0){
			return (UmOrganization) list.get(0);
		}
		return new UmOrganization();
	}
	
}
