package com.seeyon.apps.nbd.po;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.ctp.common.po.BasePO;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/19.
 */
public abstract class BasePoEntity extends BasePO {

    private String extra="";


    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    public void putExtraValue(String key,Object value){

    }
    public void putExtraValues(Map data){

    }
    public String getExtraValue(String key){

        return null;
    }

    public Map getReadOnlyExtraMap(){
        if(CommonUtils.isEmpty(this.extra)){
            return new HashMap();
        }
        return JSON.parseObject(this.extra,HashMap.class);
    }
}
