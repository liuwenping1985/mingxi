package com.seeyon.apps.doc.manager;

import com.seeyon.ctp.common.exceptions.BusinessException;

public interface DocResourceNewManager {
	
	public void updateDocResource(Long sourceId);
	// �Ϳ� gyz 2018-07-04 start
	public void updateReportResource(Long sourceId,	Long senderId) throws BusinessException;
	// �Ϳ� gyz 2018-07-04 end
}
