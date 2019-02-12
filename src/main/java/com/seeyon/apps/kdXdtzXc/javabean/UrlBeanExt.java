package com.seeyon.apps.kdXdtzXc.javabean;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/4/13.
 */
public class UrlBeanExt implements UrlBean {
    private Map<String,String> urlMap=new HashMap<String, String>();

    public Map<String, String> getUrlMap() {
        return urlMap;
    }

    public void setUrlMap(Map<String, String> urlMap) {
        this.urlMap = urlMap;
    }
}
