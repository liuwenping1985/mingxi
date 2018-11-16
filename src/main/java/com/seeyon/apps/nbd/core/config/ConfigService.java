package com.seeyon.apps.nbd.core.config;

import com.seeyon.apps.nbd.config.Hook;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Created by liuwenping on 2018/8/17.
 */
public class ConfigService {

    public static final String APP_KEY="UFgGlyPTiFytLhUVCbb6vAiGp4MDNU8I6e8uSxoGP+Y=";

    private static  Properties p = new Properties();


    public static String getPropertyByName(String key,String defaultValue){

        return p.getProperty(key,defaultValue);

    }
    private static void init(){
        p = new Properties();
        InputStream ins = Hook.class.getResourceAsStream("config.properties");
        try {
            p.load(ins);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    static{
        init();
    }

    public static void main(String[] args){
       String key =  ConfigService.getPropertyByName("eas_user_name","");
       System.out.println(key);
    }



}
