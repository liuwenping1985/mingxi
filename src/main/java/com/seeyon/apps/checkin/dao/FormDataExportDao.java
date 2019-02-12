package com.seeyon.apps.checkin.dao;

public interface FormDataExportDao {
	public boolean isSyncFormData(Long summary_id, String templateCode);
	public String getUserCode(Long summary_id);
}
