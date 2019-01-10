package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.service.impl.ZrzxLeaderOutExportProcessor;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.ZrzxUserSchedule;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by liuwenping on 2018/12/18.
 */
public class CommonDataController extends BaseController {

    private NbdService nbdService;

    public NbdService getNbdService() {
        return nbdService;
    }

    public void setNbdService(NbdService nbdService) {
        this.nbdService = nbdService;
    }

    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
        CommonUtils.processCrossOriginResponse(response);

        CommonParameter parameter = CommonParameter.parseParameter(request);
        String startDate = parameter.$("day");


        NbdResponseEntity entity = getNbdService().lanch(parameter);
        UIUtils.responseJSON(entity, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getDepartmentLeaderCalendar(HttpServletRequest request, HttpServletResponse response) {
        CommonUtils.processCrossOriginResponse(response);

        CommonParameter parameter = CommonParameter.parseParameter(request);
        String day = parameter.$("day");
        String startDay = day+" 23:59:59";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date endDayDate = null;
        try {
            endDayDate = new Date(sdf.parse(startDay).getTime()-24*3600*1000);
        } catch (ParseException e) {
            e.printStackTrace();
            endDayDate = new Date();
        }
        String endDay = CommonUtils.formatDate(endDayDate);
        String sql = "select * from zrzx_user_schedule where name='S_LEADER' and start_date <='" + startDay + "' and end_date>= '" + endDay + "'";
        Collection<String> sLeaderName = ZrzxLeaderOutExportProcessor.S_LEADER.keySet();
        NbdResponseEntity entity = new NbdResponseEntity();
        try {
            Map<String,ZrzxUserSchedule> retMap = new HashMap<String, ZrzxUserSchedule>();
            for(String sName:sLeaderName){
                ZrzxUserSchedule srzx = new ZrzxUserSchedule();
                srzx.setUserName(sName);
                srzx.setLocation("");
                srzx.setReason("");
                retMap.put(sName,srzx);
            }
            DataLink dl = ConfigService.getA8DefaultDataLink();
            List<ZrzxUserSchedule> dataList = DataBaseHelper.executeObjectQueryBySQLAndLink(dl, ZrzxUserSchedule.class, sql);


            if (!CommonUtils.isEmpty(dataList)) {
                for (ZrzxUserSchedule schedule : dataList) {
                    retMap.put(schedule.getUserName(),schedule);
                }
            }
            List<ZrzxUserSchedule> vals = new ArrayList<ZrzxUserSchedule>();

            vals.addAll(retMap.values());
            Collections.sort(vals, new Comparator<ZrzxUserSchedule>() {
                public int compare(ZrzxUserSchedule o1, ZrzxUserSchedule o2) {
                    Integer ret1 = ZrzxLeaderOutExportProcessor.S_LEADER.get(o1.getUserName());
                    if(ret1==null){
                        ret1 = 0;
                    }
                    Integer ret2 = ZrzxLeaderOutExportProcessor.S_LEADER.get(o2.getUserName());
                    if(ret2==null){
                        ret2 = 0;
                    }
                    return ret1-ret2;
                }
            });
            List<Map> dt=new ArrayList<Map>();
            for(ZrzxUserSchedule userSchedule : vals){

                String jsonString= JSON.toJSONString(userSchedule);
                Map map = JSON.parseObject(jsonString,HashMap.class);
                map.put("id",String.valueOf(map.get("id")));
                map.put("userId",String.valueOf(map.get("userId")));
                dt.add(map);
            }
            entity.setItems(dt);
        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg("[ERROR]" + e.getMessage());
        }
        UIUtils.responseJSON(entity, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getAccountLeaderCalendar(HttpServletRequest request, HttpServletResponse response) {
        CommonUtils.processCrossOriginResponse(response);
        try {
            CommonParameter parameter = CommonParameter.parseParameter(request);
            String day = parameter.$("day");
            //day = day+" 23:59:59";
            String startDay = day + " 23:59:59";
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date endDayDate = null;
            try {
                endDayDate = new Date(sdf.parse(startDay).getTime()-24*3600*1000);
            } catch (ParseException e) {
                e.printStackTrace();
                endDayDate = new Date();
            }
            String endDay = CommonUtils.formatDate(endDayDate);
            String sql = "select * from zrzx_user_schedule where name='M_LEADER' and start_date <='" + startDay + "' and end_date>= '" + endDay + "'";
            Set<String> mLeaderName = ZrzxLeaderOutExportProcessor.M_LEADER.keySet();
            NbdResponseEntity entity = new NbdResponseEntity();
            try {
                Map<String, ZrzxUserSchedule> retMap = new HashMap<String, ZrzxUserSchedule>();
                for (String sName : mLeaderName) {
                    ZrzxUserSchedule srzx = new ZrzxUserSchedule();
                    srzx.setLocation("");
                    srzx.setReason("");
                    srzx.setUserName(sName);
                    retMap.put(sName, srzx);
                }
                DataLink dl = ConfigService.getA8DefaultDataLink();
                List<ZrzxUserSchedule> mDataList = DataBaseHelper.executeObjectQueryBySQLAndLink(dl, ZrzxUserSchedule.class, sql);
                if (!CommonUtils.isEmpty(mDataList)) {
                    for (ZrzxUserSchedule schedule : mDataList) {
                        retMap.put(schedule.getUserName(), schedule);
                    }
                }
                List<ZrzxUserSchedule> vals = new ArrayList<ZrzxUserSchedule>();
                vals.addAll(retMap.values());
                Collections.sort(vals, new Comparator<ZrzxUserSchedule>() {
                    public int compare(ZrzxUserSchedule o1, ZrzxUserSchedule o2) {
                        Integer ret1 = ZrzxLeaderOutExportProcessor.M_LEADER.get(o1.getUserName());
                        if (ret1 == null) {
                            ret1 = 0;
                        }
                        Integer ret2 = ZrzxLeaderOutExportProcessor.M_LEADER.get(o2.getUserName());
                        if (ret2 == null) {
                            ret2 = 0;
                        }
                        return ret1 - ret2;
                    }
                });
                List<Map> dt = new ArrayList<Map>();
                for (ZrzxUserSchedule userSchedule : vals) {

                    String jsonString = JSON.toJSONString(userSchedule);
                    Map map = JSON.parseObject(jsonString, HashMap.class);
                    map.put("id", String.valueOf(map.get("id")));
                    map.put("userId", String.valueOf(map.get("userId")));
                    dt.add(map);
                }
                entity.setItems(dt);
            } catch (Exception e) {
                e.printStackTrace();
                entity.setResult(false);
                entity.setMsg("[ERROR]" + e.getMessage());
            }
            UIUtils.responseJSON(entity, response);
        }catch(Exception e){
            e.printStackTrace();;
        }
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getMyCalendar(HttpServletRequest request, HttpServletResponse response) {
        CommonUtils.processCrossOriginResponse(response);
        User user = AppContext.getCurrentUser();
        NbdResponseEntity entity = new NbdResponseEntity();
        if(user==null){
            entity.setResult(false);
            entity.setMsg("not log in");
            UIUtils.responseJSON(entity,response);
            return null;

        }
        CommonParameter parameter = CommonParameter.parseParameter(request);
        String day = parameter.$("day");
        String startDay = day+" 23:59:59";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date endDayDate = null;
        try {
            endDayDate = new Date(sdf.parse(startDay).getTime()-24*3600*1000);
        } catch (ParseException e) {
            e.printStackTrace();
            endDayDate = new Date();
        }
       // Date endDayDate = new Date(CommonUtils.parseDate(startDay).getTime()-24*3600*1000);
        String endDay = CommonUtils.formatDate(endDayDate);
        //day = day+" 23:59:59";
        String sql = "select * from zrzx_user_schedule where user_id="+user.getId()+" and start_date <='" + startDay + "' and end_date>= '" + endDay + "'";
        DataLink dl = ConfigService.getA8DefaultDataLink();
        List<ZrzxUserSchedule> mDataList = DataBaseHelper.executeObjectQueryBySQLAndLink(dl, ZrzxUserSchedule.class, sql);
        if(!CommonUtils.isEmpty(mDataList)){
            List<Map> dt=new ArrayList<Map>();
            for(ZrzxUserSchedule userSchedule : mDataList){

                String jsonString= JSON.toJSONString(userSchedule);
                Map map = JSON.parseObject(jsonString,HashMap.class);
                map.put("id",String.valueOf(map.get("id")));
                map.put("userId",String.valueOf(map.get("userId")));
                dt.add(map);
            }
            entity.setItems(dt);
            entity.setResult(true);
        }else{
            entity.setData(null);
            entity.setResult(false);
        }
        UIUtils.responseJSON(entity,response);
        return null;
    }

    private static TreeMap<Integer,String> S_LEADER_SORTED = new TreeMap<Integer,String>();

    private static TreeMap<Integer,String> getSLeaderSortedMap(){
        if(S_LEADER_SORTED.isEmpty()){
            for(Map.Entry<String,Integer> entry:ZrzxLeaderOutExportProcessor.S_LEADER.entrySet()){

                S_LEADER_SORTED.put(entry.getValue(),entry.getKey());
            }
        }
        return S_LEADER_SORTED;

    }
    private static TreeMap<Integer,String> M_LEADER_SORTED = new TreeMap<Integer,String>();

    private static TreeMap<Integer,String> getMLeaderSortedMap(){
        if(M_LEADER_SORTED.isEmpty()){
            for(Map.Entry<String,Integer> entry:ZrzxLeaderOutExportProcessor.M_LEADER.entrySet()){

                M_LEADER_SORTED.put(entry.getValue(),entry.getKey());
            }
        }
        return M_LEADER_SORTED;

    }

    public static void main(String[] args){
        System.out.println("ERROR");
    }



}
