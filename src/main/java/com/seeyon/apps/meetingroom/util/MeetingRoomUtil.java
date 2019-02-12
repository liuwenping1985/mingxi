package com.seeyon.apps.meetingroom.util;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;

public class MeetingRoomUtil {
	
	private static OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");

	public static String getMeetingRoomMngdepNames(String mngdepIds) throws BusinessException {
		String mngdepNames = "";
		if(Strings.isNotEmpty(mngdepIds)) {
			for(String mngdepId : mngdepIds.split(",")) {
				String addName = "";
				V3xOrgUnit unit = orgManager.getUnitById(Long.parseLong(mngdepId.split("[|]")[1]));
				if (unit != null) {
					addName = unit.getName();
				} else {
					V3xOrgPost post = orgManager.getPostById(Long.parseLong(mngdepId.split("[|]")[1]));
					addName = post.getName();
				}
				if (Strings.isNotBlank(mngdepNames)) {
					mngdepNames += ",";
				}
				mngdepNames += addName;
			}
		}
		return mngdepNames;
	}
	
}
