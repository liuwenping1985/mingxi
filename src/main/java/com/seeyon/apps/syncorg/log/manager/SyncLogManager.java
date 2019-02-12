package com.seeyon.apps.syncorg.log.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.syncorg.po.log.SyncLog;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.util.FlipInfo;

public interface SyncLogManager {

	
	public FlipInfo queryByCondition(FlipInfo flipInfo,
			Map<String, String> query);
	
	public void insert(SyncLog moveLog);
	
	public String syncOne(String id) throws Exception;
	
	public String SyncAll();
	
	public String syncFailed();
	
	public List<SyncLog> getAll();
	
	public void update(SyncLog syncLog);
	
	public String deleteRecord(String ids);


}
