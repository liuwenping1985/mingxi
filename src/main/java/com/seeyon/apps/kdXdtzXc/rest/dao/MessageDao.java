package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by taoan on 2017-4-5.
 */
public class MessageDao implements RestDao {

    /**
     * 协同中个人的全部未读系统消息
     *
     * @param userId 人员ID
     * @param ispage 默认true返回20条，false返回所有
     * @return
     * @throws Exception
     */
    public String getUnreadMessage(String userId, boolean ispage) throws Exception {
        String url = "/message/unread/" + userId + "?ispage=" + ispage;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

    /**
     * 通过获取的消息对象中的linkType 和ReferenceId 来获取消息URL连接
     *
     * @param linkType    消息对象中的linkType属性
     * @param referenceId 消息对象中的ReferenceId属性
     * @return
     * @throws Exception
     */
    public String getMessageLinkurl(String linkType, String referenceId) throws Exception {
        String url = "/message/linkurl/" + linkType + "?ReferenceId=" + referenceId;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

    /**
     * @param userid    人员ID
     * @param messageid 未读消息ID
     * @return
     * @throws Exception
     */
    public String updateStates(String userid, String[] messageid) throws Exception {
        Map res = new HashMap();
        res.put("userid", userid);
        res.put("messageid", messageid);
        String result = CTPRestClientUtil.getCTPRestClient().post("message/isread", res, String.class);
        return result;
    }


}
