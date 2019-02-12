package com.seeyon.ctp.common.checkflowopen.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.customselectpeople.po.CustomSelectPeoplePO;
import com.seeyon.ctp.util.FlipInfo;

public interface CheckFlowOpenManager {

	
	public String getCurrentOpenFlowUser(Long affairId, String currentUserName);
	
	public void removeFlowOpenUser(Long affairId, String currentUserName);
}
