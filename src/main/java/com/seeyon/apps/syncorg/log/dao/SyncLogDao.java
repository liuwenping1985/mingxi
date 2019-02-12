package com.seeyon.apps.syncorg.log.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.syncorg.enums.SyncStatusEnum;
import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.ctp.util.FlipInfo;

public interface SyncLogDao {

	public List<SyncLog> queryByCondition(FlipInfo flipInfo, Map<String, String> query);
	
	public void insert(SyncLog syncLog);
	
	public void update(SyncLog syncLog);
	
	public SyncLog getById(Long id);
	
	public void saveOrUpdate(SyncLog syncLog);
	
	public List<SyncLog> getListByStatus(SyncStatusEnum [] statuss);
	
	public List<SyncLog> getAll();
	
	public boolean deleteRecord(String ids);


}
