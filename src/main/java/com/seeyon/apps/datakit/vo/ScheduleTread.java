package com.seeyon.apps.datakit.vo;

import com.seeyon.apps.datakit.dao.DataKitDao;
import com.seeyon.apps.datakit.service.DataKitService;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class ScheduleTread{
    private DataKitService dataKitService;
    private int startAt=3;
    public void schedule(){
        Timer timer = new Timer();
        Date dt = new Date();
        Calendar cal = Calendar.getInstance();
        int now = cal.get(Calendar.HOUR_OF_DAY);
        if(now<startAt){
            now = 24-startAt + now;
        }else{
            now = now-startAt;
        }
        timer.schedule(new TimerTask(){

            public void run() {
                try {
                    dataKitService.autoSync();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },now*3600*1000L,24*3600*1000L);
    }

    public DataKitService getDataKitService() {
        return dataKitService;
    }

    public void setDataKitService(DataKitService dataKitService) {
        this.dataKitService = dataKitService;
    }
}
