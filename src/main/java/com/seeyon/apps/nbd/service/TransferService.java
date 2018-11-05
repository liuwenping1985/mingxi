package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.vo.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class TransferService {

    private Map<String,Class> clsHolder = new HashMap<String,Class>();
    private TransferService(){
        clsHolder.put(NbdConstant.DATA_LINK,DataLink.class);
        clsHolder.put(NbdConstant.A8_TO_OTHER,A82Other.class);
        clsHolder.put(NbdConstant.OTHER_TO_A8,Other2A8.class);
        clsHolder.put("log",LogEntry.class);

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
        T t =  (T) JSON.parseObject(jsonString,s);

        if(s == A82Other.class){



        }
        if(s == Other2A8.class){


        }

        return t;


    }


    static class Holder{
        private static TransferService ins = new TransferService();

    }

    public static void main(String[] args){
        CommonParameter p = new CommonParameter();
        p.$("user","1234");
        p.$("password","12345");
        p.$("host","12345");
        CommonVo vo = getInstance().transData("data_link",p);
        System.out.println(JSON.toJSONString(vo));
    }
}
