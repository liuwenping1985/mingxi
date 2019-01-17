package com.seeyon.apps.nbd.service;

/**
 * 往外边输出数据（单例）
 * Created by liuwenping on 2018/11/28.
 */
public class DataExportService {

    private DataExportService(){

    }

    public static final DataExportService getInstance(){

        return DataExportServiceHolder.ins;
    }





    private static class DataExportServiceHolder{

        private static DataExportService ins = new DataExportService();

    }

}
