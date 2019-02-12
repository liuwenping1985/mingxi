package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.base.util.StringUtils;
import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * 得到协同
 */
public class CtpAffairDao implements RestDao {




    /**
     * 得到待办协同
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getPendingAffairs(String ticket, int pageNo, int pageSize) throws Exception {
        String s = CTPRestClientUtil.getCTPRestClient().get("/affairs/pending?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

        return s;
    }

    /**
     * 得到已办协同
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDoneAffairs(String ticket, int pageNo, int pageSize) throws Exception {
        String s = CTPRestClientUtil.getCTPRestClient().get("affairs/done?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
//        if (!StringUtils.emprtArray(s)) {
//            return new JSONObject(s);
//        }
        return s;
    }

    /**
     * 得到待发协同
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public JSONObject getDraftAffairs(String ticket, int pageNo, int pageSize) throws Exception {
        String s = CTPRestClientUtil.getCTPRestClient().get("/affairs/draft?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
        if (!StringUtils.emprtArray(s)) {
            return new JSONObject(s);
        }
        return null;
    }


    /**
     * 得到已发协同
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public JSONObject getSentAffairs(String ticket, int pageNo, int pageSize) throws Exception {
        String s = CTPRestClientUtil.getCTPRestClient().get("/affairs/sent?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
        if (!StringUtils.emprtArray(s)) {
            return new JSONObject(s);
        }
        return null;
    }




}
