package com.seeyon.apps.duban.util;



import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {

    public static void main(String[] arg) {
        Calendar calendar = Calendar.getInstance();
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1;//星期几
        int numWeekOfMonth = calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH);//第几周
       // int day = calendar.get(Calendar.DAY_OF_MONTH);//一个月第几天
        int day = calendar.get(Calendar.DATE);//一个月第几天
        int month = calendar.get(Calendar.MONTH)+1;//第几月
        System.out.println(dayOfWeek);
        System.out.println(numWeekOfMonth);
        System.out.println(day);
        System.out.println(month);
    }
}
