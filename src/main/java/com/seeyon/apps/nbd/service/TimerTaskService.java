package com.seeyon.apps.nbd.service;

import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.Ftd;
import com.seeyon.apps.nbd.po.OtherToA8ConfigEntity;

import java.util.*;

/**
 * Created by liuwenping on 2019/1/16.
 */
public class TimerTaskService {

    private TimerTaskService() {

        DataLink link = ConfigService.getA8DefaultDataLink();
      //  DataBaseHelper.getDataByTypeAndId(link,OtherToA8ConfigEntity.class);
        String sql ="select * from other_to_a8_config_entity";
        List<OtherToA8ConfigEntity> otaList = DataBaseHelper.executeObjectQueryBySQLAndLink(link,OtherToA8ConfigEntity.class,sql);
        if(CommonUtils.isEmpty(otaList)){
            return;
        }
        for(OtherToA8ConfigEntity ota:otaList){
            this.schedule(ota);
        }
    }

    public static TimerTaskService getInstance() {

        return Holder.ins;

    }

    public void schedule(OtherToA8ConfigEntity entity) {

        if("api_receive".equals(entity.getExportType())){
            return ;
        }
        if("OVER".equals(entity.getExtString8())){
            return;
        }
        String period = entity.getPeriod();
        if(CommonUtils.isEmpty(period)){
            entity.setExtString8("OVER");
            entity.saveOrUpdate();
            Timer timer = new Timer();
            timer.schedule(new GoodTimerTask(entity), 2000);
            //只会执行一次
        }else{

            Long p = CommonUtils.getLong(period);
            if (p == null) {
                //非法的timer
                return;
            }
            Timer timer = new Timer();
            timer.schedule(new GoodTimerTask(entity), 2000, p * 1000L);

            timerMap.put(entity.getId(), timer);
        }



    }

    public void remove(OtherToA8ConfigEntity entity) {

        Timer timer = timerMap.remove(entity.getId());
        if (timer != null) {
            try {
                timer.cancel();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static Map<Long, Timer> timerMap = new HashMap<Long, Timer>();

    private static class GoodTimerTask extends TimerTask {
        private OtherToA8ConfigEntity entity;

        public GoodTimerTask(OtherToA8ConfigEntity e) {
            entity = e;
        }

        public void run() {
            if (entity == null) {
                return;
            }
            String exportType = entity.getExportType();
            if("schedule".equals(exportType)){





            }else{
                //API获取

            }
            Long linkId = entity.getLinkId();
            DataLink a8Link = ConfigService.getA8DefaultDataLink();
            DataLink otherLink = DataBaseHelper.getDataByTypeAndId(a8Link, DataLink.class, linkId);
            //extString1,4
            String a8Table = entity.getExtString1();
            String otherTable = entity.getExtString4();
            String uniqueKey = entity.getExtString3();
            Long ftdId = entity.getFtdId();
            if (ftdId == null) {
                //全匹配
            } else {
               // Ftd f;
            }


        }
    }

    private static class Holder {

        public static TimerTaskService ins = new TimerTaskService();
    }
}
