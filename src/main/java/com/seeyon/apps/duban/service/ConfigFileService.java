package com.seeyon.apps.duban.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

/**
 * Created by liuwenping on 2019/11/7.
 */
public class ConfigFileService {

    private static Properties properties = new Properties();
    public static String getPropertyByName(String key,String defaultValue){

        return properties.getProperty(key,defaultValue);

    }
    public static String getPropertyByName(String key){

        return properties.getProperty(key,"");

    }
    public static Map getTemplateProperties(){
/**
 * ctp.template.-7849725267052772823=DB_DONE_APPLY

 ctp.template.5568002767950727683=DB_DELAY_APPLY

 ctp.template.7672869598940252106=DB_FEEDBACK
 */
        Map data = new HashMap();
        for(Map.Entry entry : properties.entrySet()){
            String key = String.valueOf(entry.getKey());
            String value = String.valueOf(entry.getValue());
            if(key.startsWith("ctp.template")){
                if(value.equals("DB_DONE_APPLY")||value.equals("DB_DELAY_APPLY")||value.equals("DB_FEEDBACK")){
                    data.put(value,key.split("\\.")[2]);
                }
            }

        }
        return data;

    }
    private static void init(){
        properties = new Properties();
        InputStream ins = ConfigFileService.class.getResourceAsStream("config.properties");
        try {
            properties.load(ins);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    static{
        init();
    }

    public static Object reload(){

        init();
        try {
            Set set = properties.entrySet();
            return set;
        }catch(Exception e){
            e.printStackTrace();
        }
        return "reload error";
    }


    public static void main(String[] args){
        String ids = ConfigFileService.getPropertyByName("ctp.template.ids");
        String[] idArray = ids.split(",");
        for(String arg:idArray){
            System.out.println(ConfigFileService.getPropertyByName("ctp.template."+arg));
        }
        Map data = ConfigFileService.getTemplateProperties();
        System.out.println(data);

    }

}
