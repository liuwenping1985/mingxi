package com.seeyon.apps.nbd.core.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class CommonUtils {
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public static boolean isEmpty(Collection collection){
        if(collection == null||collection.isEmpty()){
            return true;
        }
        return false;
    }
    public static boolean isEmpty(Map map){
        if(map == null||map.isEmpty()){
            return true;
        }
        return false;
    }
    public static boolean isEmpty(String str){
        if(str == null||str.length()==0){
            return true;
        }
        return false;
    }
    public static boolean isEmpty(Object[] objs){
        if(objs == null||objs.length==0){
            return true;
        }
        return false;
    }
    public static Long paserLong(Object obj){
        if(obj == null){
            return null;
        }
        Long val = null;
        try {
           val =  Long.parseLong(String.valueOf(obj));
        }finally {
            return val;
        }

    }
    public static Date parseDate(String dateStr){
        try {
            Date dt = sdf.parse(dateStr);
            return dt;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }
    public static int getYear(String dtStr){

        return getYear(parseDate(dtStr));
    }
    public static int getYear(Date dt){
        Calendar calendar = Calendar.getInstance();
        if(dt!=null){
            calendar.setTime(dt);
        }
        return calendar.get(Calendar.YEAR);
    }
    public static int getYear(){

        return getYear(new Date());
    }
}
