package com.seeyon.apps.duban.service;

import java.io.IOException;
import java.io.InputStream;
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


    }

}
