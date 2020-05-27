package com.seeyon.apps.duban.controller;

import com.seeyon.ctp.form.bean.FormTriggerBean;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManagerImpl;
import com.seeyon.ctp.form.modules.trigger.FormTriggerEventListener;
import com.seeyon.ctp.form.modules.trigger.FormTriggerManagerImpl;
import com.seeyon.ctp.form.modules.trigger.action.FormTriggerFlowDesign;
import com.seeyon.ctp.form.util.FormTriggerUtil;
import com.seeyon.v3x.online.controller.MessageController;
import com.seeyon.v3x.online.manager.MessageManagerImpl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DubanCallCenter {


    public static void main(String[] args)
    {
//        String str = "Mon Dec 30 09:00:00 CST 2019";
//        Date date = parse(str, "EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);
////        String str2=format(now, "EEE MMM dd HH:mm:ss zzz yyyy", Locale.CHINA);
//        System.out.printf("%tF %<tT%n", date);
////        System.out.println(str2);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        System.out.println(calendar.get(Calendar.DAY_OF_WEEK));
        System.out.println(calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH));

    }

    public static Date parse(String str, String pattern, Locale locale) {
    if(str == null || pattern == null) {
     return null;
     }
    try {
     return new SimpleDateFormat(pattern, locale).parse(str);
    } catch (ParseException e) {
    e.printStackTrace();
    }
     return null;
    }
//
     public static String format(Date date, String pattern, Locale locale) {
    if(date == null || pattern == null) {
     return null;
    }
     return new SimpleDateFormat(pattern, locale).format(date);
     }

    //FormTriggerBean
    //FormDataManagerImpl
    //FormTriggerUtil
  //FormTriggerManagerImpl
    //FormTriggerFlowDesign
   // FormTriggerFlowDesign
   // FormTriggerEventListener
   // MessageManagerImpl
}
