package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.DataValidator;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.vo.DataLink;

import java.util.*;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class TransferService {

    private Map<String,Class> clsHolder = new HashMap<String,Class>();
    private TransferService(){
        clsHolder.put("data_link",DataLink.class);

    }
    private TransferService ins = null;
    public static TransferService getInstance(){

        return Holder.ins;
    }

    public Class getTransferClass(String dataType){
        if(CommonUtils.isEmpty(dataType)){
            return null;
        }
        return clsHolder.get(dataType);
    }

    public <T> T transData(String dataType, CommonParameter p){

        if(p == null){
            return null;
        }
        Class s = getTransferClass(dataType);
        if(s == null){
            return null;
        }

        String jsonString = JSON.toJSONString(p);
        return (T)JSON.parseObject(jsonString,s);

    }

    static class Holder{
        private static TransferService ins = new TransferService();

    }
}
