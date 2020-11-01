package com.seeyon.apps.duban.controller;

import com.alibaba.fastjson.JSON;
import org.apache.http.HttpRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DubanCallCenter {


    public static void main(String[] args) {
//        String str = "Mon Dec 30 09:00:00 CST 2019";
//        Date date = parse(str, "EEE MMM dd HH:mm:ss zzz yyyy", Locale.US);
////        String str2=format(now, "EEE MMM dd HH:mm:ss zzz yyyy", Locale.CHINA);
//        System.out.printf("%tF %<tT%n", date);
////        System.out.println(str2);

        String jsonRet = "{\n" +
                "    \"success\": true,\n" +
                "    \"data\": {\n" +
                "        \"total\": 1,\n" +
                "        \"data\": [\n" +
                "            {\n" +
                "                \"createtime\": \"2020-09-25 09:51:57\",\n" +
                "                \"comments\": \"3\",\n" +
                "                \"qcusername\": \"余小玉\",\n" +
                "                \"ifatt\": \"\",\n" +
                "                \"actionurl\": \"http://ierptest.spic.com.cn:8000/ierp/integration/yzjShareOpen.do?formId=wf_approvalpage_bac&mb_formId=wf_approvalpagemobile_bac&pkId=988167228098624512&src=wf&accountId=872529855609044992&taskId=988167260310863872&type=toHandle&tId=988167260310863872\",\n" +
                "                \"todoid\": 988167260310863872,\n" +
                "                \"title\": \"单据编号：PV-202009-000758\",\n" +
                "                \"userid\": 965231324006722560\n" +
                "            }\n" +
                "        ]\n" +
                "    }\n" +
                "}";

        Map jsonData = JSON.parseObject(jsonRet,HashMap.class);

        Map subData  = (Map)jsonData.get("data");

        List<Map> dataList = (List<Map>)subData.get("data");

        String actionUrl = (String)dataList.get(0).get("actionurl");
        System.out.println(actionUrl);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        System.out.println(calendar.get(Calendar.DAY_OF_WEEK));
        System.out.println(calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH));
        HttpServletResponse response=null;
        response.setHeader("token","ytettetsttestetstets");




    }

    public static Date parse(String str, String pattern, Locale locale) {
        if (str == null || pattern == null) {
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
        if (date == null || pattern == null) {
            return null;
        }
        return new SimpleDateFormat(pattern, locale).format(date);
    }

//    public static void main(String[] args){
//
//        String jsonRet = "{\n" +
//                "    \"success\": true,\n" +
//                "    \"data\": {\n" +
//                "        \"total\": 1,\n" +
//                "        \"data\": [\n" +
//                "            {\n" +
//                "                \"createtime\": \"2020-09-25 09:51:57\",\n" +
//                "                \"comments\": \"3\",\n" +
//                "                \"qcusername\": \"余小玉\",\n" +
//                "                \"ifatt\": \"\",\n" +
//                "                \"actionurl\": \"http://ierptest.spic.com.cn:8000/ierp/integration/yzjShareOpen.do?formId=wf_approvalpage_bac&mb_formId=wf_approvalpagemobile_bac&pkId=988167228098624512&src=wf&accountId=872529855609044992&taskId=988167260310863872&type=toHandle&tId=988167260310863872\",\n" +
//                "                \"todoid\": 988167260310863872,\n" +
//                "                \"title\": \"单据编号：PV-202009-000758\",\n" +
//                "                \"userid\": 965231324006722560\n" +
//                "            }\n" +
//                "        ]\n" +
//                "    }\n" +
//                "}";
//
//        Map jsonData = JSON.parseObject(jsonRet,HashMap.class);
//
//        Map subData  = (Map)jsonData.get("data");
//
//        Map data = (Map)subData.get("data");
//
//        String actionUrl = (String)data.get("actionurl");
//
//    }
    //
    //FormTriggerBean
    //FormDataManagerImpl
    //FormTriggerUtil
    //FormTriggerManagerImpl
    //FormTriggerFlowDesign
    //FormTriggerFlowDesign
    //FormTriggerEventListener
    //MessageManagerImpl
}
