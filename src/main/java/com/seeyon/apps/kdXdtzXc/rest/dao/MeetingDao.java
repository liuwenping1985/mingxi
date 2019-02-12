package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by taoan on 2017-4-5.
 */
public class MeetingDao implements RestDao {

	/**
	 * 通过【会议ID】来获取会议信息
	 * 
	 * @param id
	 *            会议ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingDetail(String id) throws Exception {
		String url = "/meeting/" + id;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 通过【人员ID】来获取会议已办列表信息。
	 * 
	 * @param personId
	 *            人员ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingDones(String personId) throws Exception {
		String url = "meeting/dones/" + personId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 通过【人员ID】来获取会议待办列表信息。
	 * 
	 * @param personId
	 *            人员ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingPendings(String personId) throws Exception {
		String url = "meeting/pendings/" + personId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 通过【人员ID】来获取会议待发列表信息。
	 * 
	 * @param personId
	 *            人员ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingWaitsends(String personId) throws Exception {
		String url = "meeting/waitsends/" + personId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 通过【人员ID】来获取会议已发列表信息。
	 * 
	 * @param personId
	 *            人员ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingSends(String personId) throws Exception {
		String url = "meeting/sends/" + personId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 通过【会议纪要ID】来获取会议信息。
	 * 
	 * @param recordId
	 *            会议纪要ID【meeting_summary表ID】
	 * @return
	 * @throws Exception
	 */
	public String getMeetingSummary(String recordId) throws Exception {
		String url = "meeting/summary/" + recordId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * 获取所有参会人员
	 * 
	 * @param meetingId
	 *            会议ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingPersons(String meetingId) throws Exception {
		System.out.println("进入方法");
		String url = "meeting/persons/" + meetingId;
		String s = CTPRestClientUtil.getCTPRestClient().post(url, meetingId, String.class);
		System.out.println("505225225252525252");
		return s;
	}

	/**
	 * 获取会议的震荡回复意见
	 * 
	 * @param meetingId
	 *            会议ID
	 * @return
	 * @throws Exception
	 */
	public String getMeetingComments(String meetingId) throws Exception {
		String url = "meeting/comments/" + meetingId;
		String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
		return s;
	}

	/**
	 * @param meetingId
	 *            会议ID
	 * @param messageid
	 *            未读消息ID
	 * @return
	 * @throws Exception
	 */
	public String updateMeetingStates(String meetingId, String[] messageid) throws Exception {
		Map res = new HashMap();
		// res.put("userid", userid);
		// res.put("messageid", messageid);
		String result = CTPRestClientUtil.getCTPRestClient().post("meeting/reply", res, String.class);
		return result;
	}

}
