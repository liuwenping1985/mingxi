package com.seeyon.apps.nbd.core.config;

import com.seeyon.apps.nbd.po.A8OutputVo;
import com.seeyon.apps.nbd.vo.DataLink;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedList;
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
    public static DataLink getA8DefaultDataLink(){
        String url = getPropertyByName("local_db_url","192.168.1.98");
        String port = getPropertyByName("local_db_port","3306");
        String user = getPropertyByName("local_db_user","root");
        String password = getPropertyByName("local_db_password","admin123!");
        String type = getPropertyByName("local_db_type","0");
        String name = getPropertyByName("local_db_name","v61sp22");

       DataLink dl = new DataLink();
       dl.setDataBaseName(name);
       dl.setDbType(type);
       dl.setUser(user);
       dl.setPassword(password);
       dl.setExtString2(port);
       dl.setHost(url);
       return dl;
    }
    public static File getA82OtherCreateTable(){
        String path = A8OutputVo.class.getResource("cr.sql").getPath();
        return new File(path);
    }
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
       String key =  ConfigService.getPropertyByName("callback.uri","");
       System.out.println(key);
    }



}
