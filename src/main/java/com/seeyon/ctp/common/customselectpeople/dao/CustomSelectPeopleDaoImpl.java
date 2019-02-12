package com.seeyon.ctp.common.customselectpeople.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;

public class CustomSelectPeopleDaoImpl extends BaseHibernateDao<OrgUnit> implements CustomSelectPeopleDao{
	
	@SuppressWarnings("unchecked")
	@Override
	public List<CtpEnumItem> getEnumItemByEnumId(Long enumId,String showValue){
		
		User user  = AppContext.getCurrentUser();
		Long accountId = user.getAccountId();
		Map<String, Long> map = new HashMap<String, Long>();
		String hql = "from CtpEnumItem f where f.state = 1 and f.refEnumid=:enumId and f.orgAccountId=:orgAccountId  order by f.sortnumber asc";
		if (Strings.isNotEmpty(showValue)){
			hql = "from CtpEnumItem f where f.showvalue='" + showValue + "' and f.state = 1 and f.refEnumid=:enumId and f.orgAccountId=:orgAccountId  order by f.sortnumber asc";
		}
		
		map.put("enumId", enumId);
		map.put("orgAccountId", accountId);
		return DBAgent.find(hql,map);

	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<CtpEnumItem> getEnumItemByEnumId(Long enumId){
		
		User user  = AppContext.getCurrentUser();
		Long accountId = user.getAccountId();
		Map<String, Long> map = new HashMap<String, Long>();
		String hql = "from CtpEnumItem f where f.state = 1 and f.refEnumid=:enumId and f.orgAccountId=:orgAccountId  order by f.sortnumber asc";
		
		map.put("enumId", enumId);
		map.put("orgAccountId", accountId);
		return DBAgent.find(hql,map);
	}

}
