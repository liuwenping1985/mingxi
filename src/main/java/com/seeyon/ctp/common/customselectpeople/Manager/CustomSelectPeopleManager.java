package com.seeyon.ctp.common.customselectpeople.Manager;

import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.customselectpeople.po.CustomSelectPeoplePO;
import com.seeyon.ctp.util.FlipInfo;

public interface CustomSelectPeopleManager {

	
	public FlipInfo getLeaderNames(FlipInfo flipInfo, Map<String, String> condition) throws Exception;
	public List<CustomSelectPeoplePO> getEnumItemByEnumId();
}
