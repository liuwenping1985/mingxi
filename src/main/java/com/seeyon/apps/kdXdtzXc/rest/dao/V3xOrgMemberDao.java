package com.seeyon.apps.kdXdtzXc.rest.dao;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;

/**
 */
public class V3xOrgMemberDao implements RestDao {
	private static final Log LOGGER = LogFactory.getLog(V3xOrgMemberDao.class);
	/**
	 * 根据登录名，得到用户信息
	 */
	public JSONObject getOrgMember(String loginName) {
		try {
			loginName = URLEncoder.encode(loginName, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String orgMemberStr = CTPRestClientUtil.getCTPRestClient().get("orgMember/?loginName=" + loginName, String.class);
		try {
			return new JSONObject(orgMemberStr);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 根据用户id得到用户信息
	 * 
	 * @param id
	 * @return
	 */
	public JSONObject getOrgMemberById(String id) {

		String orgMemberStr = CTPRestClientUtil.getCTPRestClient().get("orgMember/" + id, String.class);
		try {
			return new JSONObject(orgMemberStr);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 获取所有的人员信息
	 */
	public JSONArray getAllOrgMembersByAccountId(String accountId) {
		// 由于OA内部接口rest调取的all是不包含已经停用的账户,所以需要自己去查询
		/*
		 * String orgMemberStr =
		 * CTPRestClientUtil.getCTPRestClient().get("orgMembers/all/" +
		 * accountId, String.class); try { return new JSONArray(orgMemberStr); }
		 * catch (JSONException e) { e.printStackTrace(); }
		 */

		// 包含所有已经停用的用户
		try {
			OrgManagerDirect orgManagerDirect = (OrgManagerDirect) AppContext.getBean("orgManagerDirect");
			List<V3xOrgMember> members = orgManagerDirect.getAllMembers(Long.valueOf(accountId), true);
			String jsonString = JSONUtilsExt.toJson(members);
			return new JSONArray(jsonString);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void main(String[] args) {
		V3xOrgMemberDao v = new V3xOrgMemberDao();
		JSONObject orgstr = v.getOrgMemberById("-6313089488641242724");
		try {
			long userid = orgstr.getLong("id");
			System.out.println(userid);

		} catch (JSONException e) {
			e.printStackTrace();
		}
		System.out.println(orgstr);
	}
}