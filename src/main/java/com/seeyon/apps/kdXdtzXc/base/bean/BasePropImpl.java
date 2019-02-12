package com.seeyon.apps.kdXdtzXc.base.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by tap-pcng43 on 2017/5/22.
 */
public class BasePropImpl implements BaseProp {
    private Map<String,String> propMap=new HashMap<String, String>();

    public Map<String, String> getPropMap() {
        return propMap;
    }

    public void setPropMap(Map<String, String> propMap) {
        this.propMap = propMap;
    }
}
