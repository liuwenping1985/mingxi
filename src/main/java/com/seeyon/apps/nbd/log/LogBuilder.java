package com.seeyon.apps.nbd.log;

import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.po.LogEntry;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by liuwenping on 2018/10/26.
 */
public class LogBuilder {
    private final Logger logger = Logger.getLogger("A8-DATA-TRANSFER");
    private String module;
    private boolean isPrint = true;

    private LogThread thread = new LogThread();
    public  LogBuilder(String module){

        this.module = module;
        thread = new LogThread();
        thread.start();

    }

    public LogBuilder log(String msg){
        return log(msg,"",true,"DEBUG");
    }
    public LogBuilder error(String msg,String data,boolean isSuccess){
        return log(msg,data,isSuccess,"ERROR");
    }
    public LogBuilder log(String msg,String data,boolean success,String level){
        LogEntry entity = new LogEntry();
        entity.setDefaultValueIfNull();
        entity.setLevel(level);
        entity.setMsg(msg);
        entity.setData(data);
        entity.setSuccess(success);
        thread.add(entity);
        return this;
    }

    public void close(){

        if(!CommonUtils.isEmpty(thread.logList)){
            List<LogEntry> entityList = new ArrayList<LogEntry>();

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
        private List<LogEntry> logList = new ArrayList<LogEntry>();

        private void add(LogEntry entity){
            logList.add(entity);
        }

        public void run(){

            while(isRunning){
                List<LogEntry> entityList = new ArrayList<LogEntry>();

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

        private void processLog(List<LogEntry> logList){
           // DataBaseHandler handler = DataBaseHandler.getInstance();
            if(CommonUtils.isEmpty(logList)){
                return;
            }
            for(LogEntry entity:logList){

               // entity.saveOrUpdate();
              //  logger.l
            }

        }

    }


}
