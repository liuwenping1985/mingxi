package com.seeyon.apps.nbd.core.config;

import com.seeyon.apps.nbd.po.DataLink;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Created by liuwenping on 2018/8/17.
 */
public class ConfigService {

    public static final String APP_KEY="UFgGlyPTiFytLhUVCbb6vAiGp4MDNU8I6e8uSxoGP+Y=";

    private static  Properties p = new Properties();

    private static DataLink DEFAULT_DATA_LINK = null;

    public static String getPropertyByName(String key,String defaultValue){

        return p.getProperty(key,defaultValue);

    }
    public static DataLink getA8DefaultDataLink(){
        if(DEFAULT_DATA_LINK == null){
            String url = getPropertyByName("local_db_url","192.168.1.98");
            String port = getPropertyByName("local_db_port","3306");
            String user = getPropertyByName("local_db_user","root");
            String password = getPropertyByName("local_db_password","admin123!");
            String type = getPropertyByName("local_db_type","0");
            String name = getPropertyByName("local_db_name","v61sp22");

            DEFAULT_DATA_LINK = new DataLink();
            DEFAULT_DATA_LINK.setDataBaseName(name);
            DEFAULT_DATA_LINK.setDbType(type);
            DEFAULT_DATA_LINK.setUserName(user);
            DEFAULT_DATA_LINK.setPassword(password);
            DEFAULT_DATA_LINK.setPort(port);
            DEFAULT_DATA_LINK.setHost(url);
        }

       return DEFAULT_DATA_LINK;
    }
//    public static File getA82OtherCreateTable(){
//        String path = A8OutputVo.class.getResource("a8_to_other_config_entity.sql").getPath();
//        return new File(path);
//    }
    public static String A8_TO_OTHER="";
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
       String key =  ConfigService.getPropertyByName("affair_type_template_code","");
       System.out.println(key);
    }



}
