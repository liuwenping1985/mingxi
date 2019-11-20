package com.seeyon.apps.duban.mapping;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/7.
 */
public class MappingCodeConstant {
    public static String DUBAN_TASK="DB_TASK";
    public static String DUBAN_TASK_FEEDBACK="DB_FEEDBACK";
    public static String DUBAN_TASK_AFFIRM="DB_AFFIRM";
    public static String DUBAN_TASK_DELAY_APPLY="DB_DELAY_APPLY";
    public static String DUBAN_DONE_APPLY="DB_DONE_APPLY";

    public static Map<String,String> FILE_MAPPING = new HashMap<String,String>();
    static{

        FILE_MAPPING.put(DUBAN_TASK,"DubanTASK.xml");
        FILE_MAPPING.put(DUBAN_TASK_FEEDBACK,"DubanFeedback.xml");
        FILE_MAPPING.put(DUBAN_TASK_AFFIRM,"DubanAffirm.xml");
        FILE_MAPPING.put(DUBAN_TASK_DELAY_APPLY,"DubanDelayApply.xml");
        FILE_MAPPING.put(DUBAN_DONE_APPLY,"DubanDoneApply.xml");


    }

}
