package com.seeyon.apps.nbd.core.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.service.CustomExportProcess;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.nbd.po.A8ToOtherConfigEntity;
import com.seeyon.apps.nbd.po.LogEntry;
import com.seeyon.apps.nbd.po.ZrzxUserSchedule;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;

import java.util.Date;
import java.util.Map;
import java.util.TreeMap;

/**
 * Created by liuwenping on 2018/12/18.
 */
public class ZrzxLeaderOutExportProcessor implements CustomExportProcess {
    /**
     * String sLeader = "张耀东
     王圣殿
     陈勤
     王琪
     陈刚
     闫世东
     黄业茹
     刘尊文
     田洪海
     王亚男
     张小丹
     洪少贤
     陈向东";
     * {"personName":"张耀东","reason":"开会","组2":[{}],"tbsj":10,"endDate":1545926400000,"填报时间":1545062400000,"location":"北京","id":6607379359658714246,"startDate":1545062400000}
     * @param form
     * @param data
     */
    public static TreeMap<String,Integer> S_LEADER = new TreeMap<String, Integer>();
    static{
        S_LEADER.put("张耀东",1);
        S_LEADER.put("王圣殿",2);
        S_LEADER.put("陈勤",3);
        S_LEADER.put("王琪",4);
        S_LEADER.put("陈刚",5);
        S_LEADER.put("闫世东",6);
        S_LEADER.put("黄业茹",7);
        S_LEADER.put("刘尊文",8);
        S_LEADER.put("田洪海",9);
        S_LEADER.put("王亚男",10);
        S_LEADER.put("张小丹",11);
        S_LEADER.put("洪少贤",12);
        S_LEADER.put("陈向东",13);

    }
    public static TreeMap<String,Integer> M_LEADER = new TreeMap<String, Integer>();
    static{

        M_LEADER.put("任勇",1);
        M_LEADER.put("程春明",2);
        M_LEADER.put("贾峰",3);
        M_LEADER.put("辛志伟",4);
        M_LEADER.put("李国刚",5);
        M_LEADER.put("董旭辉",6);
        M_LEADER.put("金冬霞",7);
    }

    public void process(A8ToOtherConfigEntity entity, Map data) {

        //String tableName ="zrzx_user_schedule";
        System.out.println("zrzx_user_schedule:"+data);
        ZrzxUserSchedule schedule = new ZrzxUserSchedule();
        schedule.setDefaultValueIfNull();
        Object userId = data.get("user_id");
        String userName = "";
        if(userId != null){
            Object ext2 = data.get("extString2");
            Object ext3 = data.get("extString3");
            schedule.setExtString1(entity.getAffairType());
            if(ext2!=null){
                schedule.setExtString2(String.valueOf(ext2));
            }else{
                schedule.setExtString2(entity.getName());
            }
            if(ext3!=null){
                schedule.setExtString3(String.valueOf(ext3));
            }

           Long uid = CommonUtils.getLong(userId);
           if(uid == null){
               userName = ""+userId;
               schedule.setUserName(userName);
           }else{
               OrgManager manager =  CommonUtils.getOrgManager();
               try {
                   schedule.setUserId(uid);
                   schedule.setUserName(String.valueOf(uid));
                   String user_name;
                   V3xOrgMember member = manager.getMemberById(uid);
                    user_name = member.getName();
                   if(S_LEADER.get(user_name)!=null){
                       schedule.setName("S_LEADER");
                   }else if(M_LEADER.get(user_name)!=null){
                       schedule.setName("M_LEADER");
                   }else{
                       schedule.setName("NORMAL");
                   }
                   schedule.setUserName(member.getName());

               } catch (Exception e) {
                   e.printStackTrace();
               }
           }

        }else{
            LogEntry log = new LogEntry();
            log.setDefaultValueIfNull();
            log.setData(JSON.toJSONString(data));
            log.setSuccess(false);
            log.setLevel("ERROR");
            log.setMsg("LEADER_OUT_ERROR_USER_ID_EMPTY");
            try{
                log.saveOrUpdate();
                return ;
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        Object reason = data.get("reason");
        if(reason!=null){
            schedule.setReason(String.valueOf(reason));
        }
        Object endDate = data.get("end");
        if(endDate!=null){
            if(endDate instanceof Date){
                schedule.setEndDate((Date)endDate);
            }else if(endDate instanceof Long){
                schedule.setEndDate(new Date((Long)endDate));
            }else{
                try{
                    Date dt = CommonUtils.parseDate(""+endDate);
                    if(dt == null){
                        schedule.setEndDate(new Date(String.valueOf(endDate)));
                    }else{
                        schedule.setEndDate(dt);
                    }

                }catch (Exception r){

                }
            }
        }
        Object startDate = data.get("start");
        if(startDate!=null){
            if(startDate instanceof Date){
                schedule.setStartDate((Date)startDate);
            }else if(startDate instanceof Long){
                schedule.setStartDate(new Date((Long)startDate));
            }else{
                try{
                    Date dt = CommonUtils.parseDate(""+startDate);
                    if(dt == null){
                        schedule.setStartDate(new Date(String.valueOf(startDate)));
                    }else{
                        schedule.setStartDate(dt);
                    }

                }catch (Exception r){

                }
            }
        }
        Object location = data.get("location");
        if(location!=null){
            schedule.setLocation(String.valueOf(location));
        }
        schedule.saveOrUpdate();

    }

    public void process(String code, CtpAffair affair) {

    }
}
