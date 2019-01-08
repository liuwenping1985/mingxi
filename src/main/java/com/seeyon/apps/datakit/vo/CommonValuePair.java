package com.seeyon.apps.datakit.vo;

import org.apache.http.NameValuePair;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 *
 * Created by liuwenping on 2018/8/24.
 */


public class CommonValuePair implements NameValuePair {
    private String key;
    private String value;

    public CommonValuePair() {
    }

    public CommonValuePair(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getName() {
        return key;
    }

    public String getValue() {
        return value;
    }

    public static List<? extends NameValuePair> toNameValuePairList(Map param) {
        List<CommonValuePair> list = new ArrayList<CommonValuePair>();
        if (CollectionUtils.isEmpty(param)) {
            return list;
        }
        for (Object key : param.keySet()) {
            String keyStr = String.valueOf(key);
            Object val = param.get(key);
            String valueStr = String.valueOf(val);
            if (val == null) {
                valueStr = null;
            }
            CommonValuePair p = new CommonValuePair(keyStr, valueStr);
            list.add(p);
        }
        return list;
    }
}