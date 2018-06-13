package com.seeyon.apps.datakit.vo;

import com.seeyon.apps.datakit.service.DataKitNanJingService;

import java.util.Timer;
import java.util.TimerTask;

public class ScheduleTread{
    private DataKitNanJingService dataKitNanJingService;
    public static boolean RUN = true;
    private static boolean isStart = false;
    public void schedule(){
        if(isStart){
            return;
        }
        isStart = true;
        Timer timer = new Timer();
       // Date dt = new Date();
        //dataKitNanJingService
        timer.schedule(new TimerTask(){

            public void run() {
                try {
                    if(!RUN){
                        return;
                    }
                    System.out.println("----schedule syncJQJX----");
                    dataKitNanJingService.syncJQJX(false);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },30*60*1000L,1*3600*1000L);
        timer.schedule(new TimerTask(){

            public void run() {
                try {
                    if(!RUN){
                        return;
                    }
                    System.out.println("----schedule syncPPB----");
                    dataKitNanJingService.syncPPB(false);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },10*60*1000L,5*60*1000L);
        timer.schedule(new TimerTask(){

            public void run() {
                try {
                    if(!RUN){
                        return;
                    }
                    System.out.println("----schedule syncSPFL----");
                    dataKitNanJingService.syncSPFL(false);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },5*60*1000L,5*60*1000L);
        timer.schedule(new TimerTask(){

            public void run() {
                try {
                    if(!RUN){
                        return;
                    }
                    System.out.println("----schedule syncDQXX----");
                    dataKitNanJingService.syncDQXX(false);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        },8*60*1000L,5*60*1000L);
    }

    public DataKitNanJingService getDataKitNanJingService() {
        return dataKitNanJingService;
    }

    public void setDataKitNanJingService(DataKitNanJingService dataKitNanJingService) {
        this.dataKitNanJingService = dataKitNanJingService;
    }
}
