package com.seeyon.apps.syncorg.log.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.oadev.advsearch.TableNameEnum;
import com.seeyon.apps.syncorg.enums.SyncStatusEnum;
import com.seeyon.apps.syncorg.log.dao.SyncLogDao;
import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.apps.oadev.advsearch.*;
import com.seeyon.apps.oadev.advsearch.util.AdvSearchWhereString;

public class SyncLogDaoImpl extends BaseHibernateDao<SyncLog> implements SyncLogDao {

	
	private static final Log log = LogFactory.getLog(SyncLogDaoImpl.class);
	@Override
	public List<SyncLog> queryByCondition(FlipInfo flipInfo,
			Map<String, String> query) {
		
		Map<String, Object> map = AdvSearchWhereString.getWhereString(
				TableNameEnum.SyncLog.getKey(), query);
		
		String hql = " from " + SyncLog.class.getSimpleName() + " m where 1=1 ";
		Map<String, Object> namedParameterMap = (Map<String, Object>) map.get("params");
		if (!Strings.isBlank(String.valueOf(map.get("whereString")))) {
			hql = hql + " and " +  map.get("whereString");
		}	
		Map<String, Object> params = new HashMap();

		
		
		hql = hql + " order by createTime desc";
		
		
		return DBAgent.find(hql, namedParameterMap, flipInfo);
	}
	@Override
	public void insert(SyncLog moveLog) {
		moveLog.setIdIfNew();
		DBAgent.saveOrUpdate(moveLog);
		
	}
	@Override
	public SyncLog getById(Long id) {
		return DBAgent.get(SyncLog.class, id);
	}

	@Override
	public void saveOrUpdate(SyncLog syncLog) {
		DBAgent.saveOrUpdate(syncLog);
		
	}
	@Override
	public List<SyncLog> getListByStatus(SyncStatusEnum [] statuss) {
		String hql = " from " + SyncLog.class.getSimpleName() + " where 1 = 1";
		Map<String, Object> params = new HashMap();
		if(statuss!=null){
			hql = hql + " and syncStatusEnum in(:status)";
			params.put("status", statuss);
		}
		return DBAgent.find(hql, params);
	}
	@Override
	public void update(SyncLog syncLog) {
		DBAgent.saveOrUpdate(syncLog);
		
	}
	@Override
	public boolean deleteRecord(String ids) {
		if(Strings.isBlank(ids)) return true;
		try{
			String [] arrays = ids.split(",");
			List<SyncLog> listAll = new ArrayList();
			if(arrays!=null&&arrays.length>0){
				for(String s : arrays){
					SyncLog syncLog = DBAgent.get(SyncLog.class, Long.valueOf(s));
					listAll.add(syncLog);
				}
				DBAgent.deleteAll(listAll);
			}
			return true;
		}catch(Exception e){
			log.error("", e);
		}
		return false;

	}

}
