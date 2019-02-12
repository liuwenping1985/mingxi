package com.seeyon.apps.kdXdtzXc.rest.dao;

import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * Created by taoan on 2017-1-15.
 */
public class V3xOrgAccountDao implements RestDao {
    /**
     * 根据公司名称得到单位信息
     *
     * @param name 单位名称，汉字
     */
    public JSONObject getOrgAccount(String name) {
        String orgAccountStr = null;
        try {
            name = URLEncoder.encode(name, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        orgAccountStr = CTPRestClientUtil.getCTPRestClient().get("orgAccount/name/" + name, String.class);
        try {
            return new JSONObject(orgAccountStr);
        } catch (JSONException e) {
            System.out.println(orgAccountStr);
            e.printStackTrace();
        }
        return null;
    }


    public String getOrgAccountId(String name) {
        JSONObject jsonObject = getOrgAccount(name);
        if (jsonObject != null) {
            try {
                return jsonObject.getString("orgAccountId");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return null;
    }



    public static void main(String[] args) {

        V3xOrgAccountDao a = new V3xOrgAccountDao();
        System.out.println(a.getOrgAccount("单位"));
    }
}
