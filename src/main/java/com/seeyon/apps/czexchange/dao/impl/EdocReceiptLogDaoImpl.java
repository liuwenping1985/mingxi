package com.seeyon.apps.czexchange.dao.impl;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.czexchange.dao.EdocReceiptLogDao;
import com.seeyon.apps.czexchange.po.EdocReceiptLog;
import com.seeyon.ctp.util.DBAgent;

public class EdocReceiptLogDaoImpl implements EdocReceiptLogDao {

	@Override
	public EdocReceiptLog getById(Long id) {
		return DBAgent.get(EdocReceiptLog.class, id);
	}

	@Override
	public void insert(EdocReceiptLog edocReceiptLog) {
		edocReceiptLog.setIdIfNew();
		DBAgent.save(edocReceiptLog);
		
	}

	@Override
	public List<EdocReceiptLog> getUnSuccessRecord(Date createDate) {
		if(createDate==null){
			String hql = " from " + EdocReceiptLog.class.getSimpleName() + " where success =:success ";
			Map params = new HashMap();
			params.put("success", false);
			return DBAgent.find(hql, params);
		}else{
			String hql = " from " + EdocReceiptLog.class.getSimpleName() + " where success =:success and createDate >:createDate";
			Map<String, Object> params = new HashMap();
			params.put("success", false);
			params.put("createDate", createDate);
			return DBAgent.find(hql, params);
		}
	}

	@Override
	public void update(EdocReceiptLog edocReceiptLog) {
		DBAgent.update(edocReceiptLog);
		
	}

	@Override
	public void saveOrUpdate(EdocReceiptLog edocReceiptLog) {
		DBAgent.saveOrUpdate(edocReceiptLog);
		
	}

	
}
