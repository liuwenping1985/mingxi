package com.seeyon.apps.datakit.schedule;

import java.util.concurrent.ThreadPoolExecutor;

/**
 * Created by liuwenping on 2018/4/2.
 */
public  class ScheduleManager {

    private static int MAX_THREAD = 5;

    private ThreadPoolExecutor threadPoolExecutor;

    public  ScheduleManager() {
       // ThreadPoolExecutor
        threadPoolExecutor = null;//Executor.newScheduleThreadExecutor();
    }


    public  void schedule(ScheduleType type, Runnable job) {


    }
}
