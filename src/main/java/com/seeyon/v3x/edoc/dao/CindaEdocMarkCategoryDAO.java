package com.seeyon.v3x.edoc.dao;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.doc.dao.DocResourceNewDao;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.v3x.edoc.domain.EdocMarkCategory;
import com.seeyon.v3x.edoc.domain.EdocMarkDefinition;
import com.seeyon.v3x.edoc.util.Constants;

public class CindaEdocMarkCategoryDAO extends BaseHibernateDao<EdocMarkCategory>{
	
	private static final Log log = LogFactory.getLog(CindaEdocMarkCategoryDAO.class);
	
	
	public EdocMarkCategory containEdocMarkCategory(String name, long domainId) {
		EdocMarkDefinition edocMarkDefinition = null;
		String hql = "from EdocMarkDefinition as definition where definition.wordNo=? and definition.domainId=? and definition.status in(0,1) order by definition.status desc";
		Object[] values1 = {name, domainId};
    	List<EdocMarkDefinition> definition = super.findVarargs(hql, values1);
    	edocMarkDefinition = definition.get(0);

    	return edocMarkDefinition.getEdocMarkCategory();
    }
	
	

}
