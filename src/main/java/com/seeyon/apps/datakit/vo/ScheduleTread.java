package com.seeyon.apps.datakit.vo;

import com.seeyon.apps.datakit.dao.DataKitDao;
import com.seeyon.apps.datakit.service.DataKitService;

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
