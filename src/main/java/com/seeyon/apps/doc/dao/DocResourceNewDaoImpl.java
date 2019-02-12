package com.seeyon.apps.doc.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.apps.doc.manager.DocAclManager;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Strings;

public class DocResourceNewDaoImpl extends BaseHibernateDao<DocResourcePO> implements DocResourceNewDao{
	
	private DocAclDao        				docAclDao;
	private DocResourceDao   				docResourceDao;
	private DocAclManager 					docAclManager;
	private DocDao           				docDao;
	

	//根据文档名称 和 父节点文档匹配
	public String getdocIdsByFrName(final DocResourcePO doc){
		String ids = "";
		String[] split = doc.getLogicalPath().split("\\.");
		String hql = "from DocResourcePO where frName = :frName and logicalPath like '%"+split[0]+"%'";
		 List<DocResourcePO> find = this.find(hql, -1, -1, CommonTools.newHashMap("frName", doc.getFrName()));
		 for (DocResourcePO docResourcePO : find) {
			 ids += docResourcePO.getId()+",";
		}
		 return ids.substring(0, ids.length()-1);
	}
	
	

}
