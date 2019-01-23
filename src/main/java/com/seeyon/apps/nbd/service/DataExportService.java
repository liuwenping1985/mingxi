package com.seeyon.apps.nbd.service;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 往外边输出数据（单例）
 * Created by liuwenping on 2018/11/28.
 */
public class DataExportService {

    private DataExportService(){
        schedule(new CustomRuianTask(),100000,10*24*3600*1000);
    }

    public static final DataExportService getInstance(){

        return DataExportServiceHolder.ins;
    }

    public Timer schedule(TimerTask task, long delay, long period){

        Timer timer  = new Timer();
        timer.schedule(task,delay,period);
        return timer;
    }
    public Timer schedule(TimerTask task){

        Timer timer  = new Timer();
        timer.schedule(task,1000);
        return timer;
    }




    private static class DataExportServiceHolder{

        private static DataExportService ins = new DataExportService();

    }

}
