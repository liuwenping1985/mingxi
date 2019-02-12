package com.seeyon.apps.kdXdtzXc.util;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;

public class GetUrl {

	public static String getTaskOpenUrl(Integer app, String affairId, String object_id) {
		String url = "";
		if (StringUtilsExt.isEqual(app, ApplicationCategoryEnum.collaboration.key())) {
			url = "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId=" + affairId + "&contentAnchor={1}";
		} else if (StringUtilsExt.isEqual(app, ApplicationCategoryEnum.edocSend.key()) || StringUtilsExt.isEqual(app, ApplicationCategoryEnum.edocRec.key()) || StringUtilsExt.isEqual(app, ApplicationCategoryEnum.edocSign.key())) {
			url = "/edocController.do?method=detailIFrame&from=listDone&affairId=" + affairId;
		} else if (StringUtilsExt.isEqual(app, ApplicationCategoryEnum.meeting.key())) {
			url = "/mtMeeting.do?method=mydetail&id=" + object_id + "&affairId=" + affairId + "state=10";
		} else if (StringUtilsExt.isEqual(app, ApplicationCategoryEnum.meetingroom.key())) {
			url = "/meetingroom.do?method=createPerm&openWin=1&id=" + object_id;
		}
		return url;
	}

}
