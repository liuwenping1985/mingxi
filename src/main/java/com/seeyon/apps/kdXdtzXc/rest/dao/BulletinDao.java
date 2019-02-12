package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;

/**
 * Created by taoan on 2017-4-5.
 */
public class BulletinDao implements RestDao {


    /**
     * 获取某一单位下的所有公告数据
     * @param unitId 单位ID
     * @param ticket SSO成功后获取的身份令牌,由外部系统产生。
     * @return
     * @throws Exception
     */
    public String getUnitIdBulletin(String unitId, String ticket) throws Exception {
        String url = "/bulletin/unit/"+unitId+"?ticket=" + ticket;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }




    /**
     * 获取某一公告版块下的所有公告数据
     *
     * @param typeId 新闻版块ID
     * @param ticket SSO成功后获取的身份令牌,由外部系统产生。
     * @return
     * @throws Exception
     */
    public String getBulTypeBulletin(String typeId, String ticket) throws Exception {
        String url = "/bulletin/bulType/" + typeId + "?ticket=" + ticket;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }


    /**
     * 获取某一单位下的公告版块列表。
     *
     * @param unitId 单位id
     * @return
     * @throws Exception
     */
    public String getUnitBulType(String unitId) throws Exception {
        String url = "/bulletin/bulType/unit/"+unitId ;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

    /**
     * 获取集团下的公告版块列表。
     *
     * @return
     */
    public String getGroupBulType() throws Exception {
        String url = "/bulletin/bulType/group" ;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

}
