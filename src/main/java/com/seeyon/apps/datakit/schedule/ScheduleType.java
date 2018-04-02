package com.seeyon.apps.datakit.schedule;

/**
 * Created by liuwenping on 2018/4/2.
 */
public class ScheduleType {


    public static int PERIOD_DAY = 1;

    public static int PERIOD_HOUR = 2;

    public static int PERIOD_MINUTE = 3;

    //FROM 1-7
    public static int PERIOD_WEEK = 4;

    public static int PERIOD_MONTH = 5;

    public static int PERIOD_YEAR = 6;

    public static final ScheduleType EVERY_DAY = new ScheduleType(1);

    public ScheduleType(int type) {

    }
}
