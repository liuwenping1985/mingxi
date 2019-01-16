package com.seeyon.apps.nbd.service;

import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.Ftd;
import com.seeyon.apps.nbd.po.OtherToA8ConfigEntity;

import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by liuwenping on 2019/1/16.
 */
public class TimerTaskService {

    private TimerTaskService() {

    }

    public static TimerTaskService getInstance() {

        return Holder.ins;

    }

    public void schedule(OtherToA8ConfigEntity entity) {
        String period = entity.getPeriod();
        Long p = CommonUtils.getLong(period);
        if (p == null) {
            return;
        }
        Timer timer = new Timer();
        timer.schedule(new GoodTimerTask(entity), 2000, p * 1000L);

        timerMap.put(entity.getId(), timer);

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
