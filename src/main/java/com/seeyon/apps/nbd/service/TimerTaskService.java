package com.seeyon.apps.nbd.service;

import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.nbd.log.LogBuilder;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.OtherToA8ConfigEntity;

import java.util.*;

/**
 * 按理说该用ScheduledExecutorService,这里用timer简化点吧
 * Created by liuwenping on 2019/1/16.
 */
public class TimerTaskService {
    private static final LogBuilder lb = new LogBuilder("Other-to-a8");
    private TimerTaskService() {

        DataLink link = ConfigService.getA8DefaultDataLink();
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
            //只会执行一次
            Timer timer = new Timer();
            timer.schedule(new GoodTimerTask(entity), 2000);

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
            try {
                System.out.println("-------schedule------");
                DataImportService.getInstance().importFromOtherToA8(entity);
            }catch(Exception e){
                e.printStackTrace();
            }

        }
    }

    private static class Holder {

        public static TimerTaskService ins = new TimerTaskService();
    }
}
