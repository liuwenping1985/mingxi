package com.seeyon.apps.nbd.core.db;

import com.alibaba.fastjson.JSON;
import org.springframework.util.StringUtils;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/24.
 */
public class DataBaseHandler {

    private static  DataBaseHandler dataBaseHandler;

    private static Map dbMap = new HashMap();

    private  DataBaseHandler(){
        StringBuilder stb = new StringBuilder();
        try {
            FileReader fr = new FileReader(this.getFile());
            BufferedReader reader = new BufferedReader(fr);
            String line = null;

            while((line=reader.readLine()) !=null){
                stb.append(line);
            }
            reader.close();
            fr.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        if(!StringUtils.isEmpty(stb.toString())){
            dbMap = JSON.parseObject(stb.toString(),HashMap.class);
        }


    }

    private void store(){

        String dbMapString = JSON.toJSONString(dbMap);
        File f = this.getFile();
        if(f.exists()){
            f.delete();
        }
        try {
            f.createNewFile();
            FileWriter fw = new FileWriter(f);
            fw.write(dbMapString);
            fw.flush();
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();

        }

    }

    private File getFile(){
        String path = this.getClass().getResource("DataBase.json").getPath();

        File f = new File(path);
        return f;

    }

    public static DataBaseHandler getInstance(){
        if(dataBaseHandler == null){
            dataBaseHandler = new DataBaseHandler();
        }

        return dataBaseHandler;
    }

    public Object getDataByKey(String key){

        return dbMap.get(key);
    }

    public void putData(String key,Object obj){

         dbMap.put(key,obj);
         store();
    }


    public static void main(String[] args){
        DataBaseHandler handler =  DataBaseHandler.getInstance();
        handler.putData("123","456");
        handler.putData("1234","4567");
        handler.putData("12345","45678");
       // System.out.println(handler.getDataByKey("123"));
    }


}
