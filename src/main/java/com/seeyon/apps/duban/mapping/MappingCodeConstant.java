package com.seeyon.apps.duban.mapping;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/7.
 */
public class MappingCodeConstant {

    public static String DUBAN_TASK = "DB_TASK";
    public static String DUBAN_TASK_FEEDBACK = "DB_FEEDBACK";
    public static String DUBAN_TASK_DELAY_APPLY = "DB_DELAY_APPLY";
    public static String DUBAN_DONE_APPLY = "DB_DONE_APPLY";


    public static String FIELD_DUBAN_RENYUAN = "field0012";
    public static String FIELD_DUBAN_WANCHENGLV = "field0021";
    public static String FIELD_DUBAN_WANCHENGLV_SUPERVISOR = "field0013";


    public static Map<String,String> FILE_MAPPING = new HashMap<String,String>();


    static{


        FILE_MAPPING.put(DUBAN_TASK,"DB_TASK.json");
        FILE_MAPPING.put(DUBAN_TASK_FEEDBACK,"DB_FEEDBACK.json");
        FILE_MAPPING.put(DUBAN_TASK_DELAY_APPLY,"DB_DELAY_APPLY.json");
        FILE_MAPPING.put(DUBAN_DONE_APPLY,"DB_DONE_APPLY.json");


    }
    public static void main(String[] rga){

        System.out.println("=== ~<'---<>---'>~ ===");

    }

}
