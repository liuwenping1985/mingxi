package com.seeyon.apps.kdXdtzXc.rest.dao;

import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;
import org.json.JSONException;
import org.json.JSONObject;

public class V3xOrgDepartmentDao implements RestDao {
    //private SdgwUserManageManager sameUserManagementManager =(SdgwUserManageManager) AppContext.getBean("sameUserManagementManager");

    /**
     * rest客户端根据单位id获取部门信息
     *
     * @author Administrator
     */
    public JSONObject getOrgDepartment(String orgId) {
        String json = CTPRestClientUtil.getCTPRestClient().get("orgDepartment/" + orgId, String.class);
        try {
            return new JSONObject(json);
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

}
