package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.dao.KDMeetingTypeDao;

public class KDMeetingTypeManageImpl implements KDMeetingTypeManage {
		private KDMeetingTypeDao kdmeetingTypeDao;
		
		
	
	public KDMeetingTypeDao getKdmeetingTypeDao() {
			return kdmeetingTypeDao;
		}



		public void setKdmeetingTypeDao(KDMeetingTypeDao kdmeetingTypeDao) {
			this.kdmeetingTypeDao = kdmeetingTypeDao;
		}



	@Override
	public List<Map<String, Object>> getAllMeetingType() {
		List<Map<String, Object>> allMeetingType = kdmeetingTypeDao.getAllMeetingType();
		return allMeetingType;
	}

}
