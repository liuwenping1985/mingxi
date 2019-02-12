package com.seeyon.apps.czexchange.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.util.CZDBAgent;
import com.seeyon.apps.czexchange.dao.CzThirdPartOrgDao;

public class CzThirdPartOrgDaoImpl implements CzThirdPartOrgDao {

	private static final Log log = LogFactory.getLog(CzThirdPartOrgDaoImpl.class);
	@Override
	public String getThridAccountIdByName(String thirdAccountName) {
		String hql = " from cinda_user." + UmOrganization.class.getSimpleName() + " where organizationname =:organizationname";
		Map<String, Object> params = new HashMap();
		params.put("organizationname", thirdAccountName);
		List<UmOrganization> list = CZDBAgent.find(hql, params);
		if(list!=null&&list.size()>0){
			return list.get(0).getId();
		}
 		return null;
	}
	@Override
	public String getThirdAccountCodeByThirdId(String thirdId) {
		String hql = " from cinda_user." + UmOrganization.class.getSimpleName() + " where id =:id";
		Map<String, Object> params = new HashMap();
		params.put("id", thirdId);
		List<UmOrganization> list = CZDBAgent.find(hql, params);
		if(list!=null&&list.size()>0){
			return list.get(0).getCode();
		}
 		return null;
	}
	@Override
	public String getThridAccountIdByCode(String thirdAccountCode) {
		String hql = " from cinda_user." + UmOrganization.class.getSimpleName() + " where code =:code";
		Map<String, Object> params = new HashMap();
		params.put("code", thirdAccountCode);
		List<UmOrganization> list = CZDBAgent.find(hql, params);
		if(list!=null&&list.size()>0){
			return list.get(0).getId();
		}
 		return null;
	}

}
