package com.seeyon.apps.kdXdtzXc.rest.dao;


import com.seeyon.apps.kdXdtzXc.rest.util.CTPRestClientUtil;
import com.seeyon.apps.kdXdtzXc.rest.util.RestDao;

/**
 * Created by taoan on 2017-3-22.
 */
public class NewsDao implements RestDao {

    /**
     * 获取某个版块下的所有新闻
     *
     * @param typeId 新闻版块ID
     * @param ticket SSO成功后获取的身份令牌,由外部系统产生。
     * @return
     * @throws Exception
     */
    public String getNewsTypeNews(String typeId, String ticket) throws Exception {
        String url = "/news/newsType/" + typeId + "?ticket=" + ticket;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

    /**
     * 获取某个单位下的所有新闻
     *
     * @param unitId       单位ID
     * @param ticket       SSO成功后获取的身份令牌,由外部系统产生。
     * @param imageOrFocus 新闻类型，0：图片新闻；1：焦点新闻；2：所有新闻。默认为2
     * @return
     * @throws Exception
     */
    public String getUnitNews(String unitId, String ticket, String imageOrFocus) throws Exception {
        String url = "/news/unit/" + unitId + "?ticket=" + ticket + "&imageOrFocus=" + imageOrFocus;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }


    /**
     * 单位新闻版块列表
     *
     * @param unitId 单位id
     * @return
     */
    public String getUnitNewsType(String unitId) throws Exception {
        String url = "/news/newsType/unit/" + unitId;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }

    /**
     * 集团新闻板块
     *
     * @return
     */
    public String getGroupNewsType() throws Exception {
        String url = "/news/newsType/group/" ;
        String s = CTPRestClientUtil.getCTPRestClient().get(url, String.class);
        return s;
    }





}
