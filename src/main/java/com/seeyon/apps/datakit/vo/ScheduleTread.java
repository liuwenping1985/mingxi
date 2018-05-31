package com.seeyon.apps.datakit.vo;

public class ScheduleTread extends Thread {
    private DataKitService dataKitService;
    public void run(){

        System.out.println("show me the money!");

    }

    public DataKitService getDataKitService() {
        return dataKitService;
    }

    public void setDataKitService(DataKitService dataKitService) {
        this.dataKitService = dataKitService;
    }
}
