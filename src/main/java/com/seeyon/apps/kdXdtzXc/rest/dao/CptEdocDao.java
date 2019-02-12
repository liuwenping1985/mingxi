package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;

/**
 * 公文
 */
public class CptEdocDao implements RestDao {


    /**
     * 待办发文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getPendingReceiptEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/receipt/pending?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 已办发文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDoneReceiptEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/receipt/done?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 在办发文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getRunningReceiptEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/receipt/running?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 已发发文     *
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getSentReceiptEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/receipt/sent?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }

    /**
     * 待发发文     *
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDraftReceiptEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/receipt/draft?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 待办收文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getPendingDispatchEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/dispatch/pending?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

    }

    /**
     * 待办收文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDongDispatchEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/dispatch/dong?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

    }

    /**
     * 已发收文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getSentDispatchEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/dispatch/sent?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

    }

    /**
     * 在办收文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getRunningDispatchEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/dispatch/running?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

    }

    /**
     * 待发收文
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDraftDispatchEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/dispatch/draft?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);

    }


    /**
     * 待办签报
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getPendingSignEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/sign/pending?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }

    /**
     * 已办签报
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDoneSignEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/sign/done?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }

    /**
     * 在办签报
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getRunningSignEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/sign/running?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 已发签报
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getSentSignEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/sign/sent?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


    /**
     * 待发签报
     *
     * @param ticket
     * @param pageNo
     * @param pageSize
     * @return
     */
    public String getDraftSignEdoc(String ticket, int pageNo, int pageSize) throws Exception {
        return CTPRestClientUtil.getCTPRestClient().get("/edoc/sign/draft?ticket=" + ticket + "&pageNo=" + pageNo + "&pageSize=" + pageSize, String.class);
    }


}