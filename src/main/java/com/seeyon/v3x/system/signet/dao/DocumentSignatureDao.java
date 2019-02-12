package com.seeyon.v3x.system.signet.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.v3x.system.signet.domain.V3xDocumentSignature;

public class DocumentSignatureDao  extends BaseHibernateDao<V3xDocumentSignature>{
	
	public List<V3xDocumentSignature> findByRecordId(String recordId) throws Exception {
		String hql = "from V3xDocumentSignature where recordId=:recordId order by signDate";
		Map pmap = new HashMap();
		pmap.put("recordId", recordId);
		List<V3xDocumentSignature> querylist = DBAgent.find(hql, pmap);
		return querylist;
	}

	public void deleteByRecordId(String recordId) {
		String hql = "delete from V3xDocumentSignature as ds where ds.recordId=?";
		super.bulkUpdate(hql, null, new Object[] { recordId });
	}

}
