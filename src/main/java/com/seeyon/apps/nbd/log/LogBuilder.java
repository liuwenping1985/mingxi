package com.seeyon.apps.nbd.log;

import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.util.CommonUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by liuwenping on 2018/10/26.
 */
public class LogBuilder {

    private String module;
    private boolean isPrint = true;

    private LogThread thread = new LogThread();
    public  LogBuilder(String module){

        this.module = module;
        thread = new LogThread();
        thread.start();

    }

    public LogBuilder log(String msg){
        LogEntity entity = new LogEntity();
        entity.setTime(new Date());
        entity.setMsg(msg);
        entity.setType(this.module);
        thread.add(entity);
        System.out.println(entity.toString());
        return this;
    }

    public void close(){

        if(!CommonUtils.isEmpty(thread.logList)){
            List<LogEntity> entityList = new ArrayList<LogEntity>();

            synchronized (thread.logList){
                entityList.addAll(thread.logList);
                thread.logList.clear();
            }
            thread.processLog(entityList);
            thread.isRunning = false;
        }
    }



    static class LogThread extends Thread{
        private boolean isRunning = true;
        private List<LogEntity> logList = new ArrayList<LogEntity>();

        private void add(LogEntity entity){
            logList.add(entity);
        }

        public void run(){

            while(isRunning){
                List<LogEntity> entityList = new ArrayList<LogEntity>();

                synchronized (logList){

                    entityList.addAll(logList);
                    logList.clear();
                }
                processLog(entityList);
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        private void processLog(List<LogEntity> logList){
            DataBaseHandler handler = DataBaseHandler.getInstance();
            if(CommonUtils.isEmpty(logList)){
                return;
            }
            for(LogEntity entity:logList){
                String key = CommonUtils.parseDate(entity.getTime());
                handler.createNewDataBaseByNameIfNotExist(entity.getType());
                handler.putData(entity.getType(),key,entity.toString());
            }

        }

    }


}
