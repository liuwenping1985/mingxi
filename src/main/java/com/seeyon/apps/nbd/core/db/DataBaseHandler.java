package com.seeyon.apps.nbd.core.db;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import org.springframework.util.StringUtils;

import java.io.*;
import java.util.*;

/**
 * Created by liuwenping on 2018/8/24.
 */
public class DataBaseHandler {

    private static  DataBaseHandler dataBaseHandler;

    private static Map dbMap = new HashMap();

    private static String DEFAULT_DB = "DataBase";

    private static String EXT_DB = "ExtDataBase";

    private static Map<String,String> extDbMap = new HashMap<String,String>();

    private static Map<String,Map> dbContainerMap = new HashMap<String,Map>();

    private  DataBaseHandler(){
        StringBuilder stb = initDataBase(DEFAULT_DB);
        if(!CommonUtils.isEmpty(stb.toString())){
            dbMap = JSON.parseObject(stb.toString(),HashMap.class);
        }
        stb =initDataBase(EXT_DB);
        if(!CommonUtils.isEmpty(stb.toString())){
            extDbMap = JSON.parseObject(stb.toString(),HashMap.class);
        }
        if(!extDbMap.isEmpty()){
            Set<String> keySet = extDbMap.keySet();
            for(String key:keySet){
                stb = initDataBase(key);
                if(stb.length()==0){
                    stb.append("{}");
                }
                Map db = JSON.parseObject(stb.toString(),HashMap.class);
                dbContainerMap.put(key,db);
            }


        }
        initCsvDataFile();

    }
    private static Map<Long,String> csvDataMap = new HashMap<Long,String>();

    private void initCsvDataFile(){

        File f =  this.getCommonCsvFile();

        StringBuilder stb = this.readFileContent(f,true);


        String[] lines = stb.toString().split("\n");
        for(String line:lines){
            String[] data = line.split(",");
            csvDataMap.put(Long.parseLong(data[0]),data[1]);
        }
        System.out.println(csvDataMap);

    }
    public boolean isEnumExist(Long eid){
        return csvDataMap.containsKey(eid);
    }
    private StringBuilder readFileContent(File file,boolean isMultiLine){
        StringBuilder stb = new StringBuilder();
        FileReader fr = null;
        BufferedReader reader = null;
        try {
            fr = new FileReader(file);
            reader = new BufferedReader(fr);
            String line = null;

            while((line=reader.readLine()) !=null){
                if(isMultiLine){
                    stb.append(line).append("\n");
                }else{
                    stb.append(line);
                }

            }
            reader.close();
            fr.close();

        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            if(fr!=null){
                try {
                    fr.close();
                } catch (IOException e) {

                }
            }
            if(reader!=null){
                try {
                    reader.close();
                } catch (IOException e) {

                }
            }
        }
        return stb;



    }
    private StringBuilder initDataBase(String dataBaseName){
        File file = this.getFile(dataBaseName);
        return this.readFileContent(file,false);
    }



    private void store(){
        String dbMapString = JSON.toJSONString(dbMap);
        File f = this.getFile();
        doStore(f,dbMapString);

    }
    private void store(String dataBaseName){
        Map map =null;
        if(EXT_DB.equals(dataBaseName)){
            map = extDbMap;
        }else{
            map = dbContainerMap.get(dataBaseName);
        }

        String dbMapString = JSON.toJSONString(map);
        File f = this.getFile(dataBaseName);
        doStore(f,dbMapString);

    }
    private void doStore(File f,String content){
        if(f.exists()){
            f.delete();
        }
        try {
            f.createNewFile();
            FileWriter fw = new FileWriter(f);
            fw.write(content);
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
    private File getFile(String dbName){
        String path = this.getClass().getResource("").getPath();
        path=path+dbName+".json";
        File f = new File(path);
        return f;

    }
    private File getCommonCsvFile(){
        String path = this.getClass().getResource("").getPath();
        path=path+"data.csv";
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
    public Object getDataByKey(String dbName,String key){
        Map db= dbContainerMap.get(dbName);
        if(db==null){
            return null;
        }
        return db.get(key);
    }

    public void putData(String key,Object obj){

        dbMap.put(key,obj);
        store();
    }
    public void putAllData(Map obj){

        dbMap.putAll(obj);
        store();
    }
    public void putData(String dbName,String key,Object obj){
        Map db= dbContainerMap.get(dbName);
        db.put(key,obj);
        store(dbName);
    }
    public void putAllData(String dbName,Map data){
        Map db= dbContainerMap.get(dbName);
        db.putAll(data);
        store(dbName);
    }
    public Map getDataAll(String dbName){
        Map db= dbContainerMap.get(dbName);
        if(db == null){
            return null;
        }
        Map neew =new HashMap();
        neew.putAll(db);
        return neew;
    }
    public boolean isDBExist(String dbName){
        String db= extDbMap.get(dbName);
        if(db!=null){
            return true;
        }
        return false;
    }
    public boolean createNewDataBaseByNameIfNotExist(String dataBaseName){
        if(isDBExist(dataBaseName)){
            return false;
        }
        dbContainerMap.put(dataBaseName,new HashMap());
        extDbMap.put(dataBaseName,"1");
        this.store(dataBaseName);
        this.store(EXT_DB);
        return true;
    }


    public static void main(String[] args){
        DataBaseHandler handler =  DataBaseHandler.getInstance();
//       Map data = handler.getDataAll("HT0007");
//       for(Object key:data.keySet()){
//
//           String val = JSON.toJSONString(data.get(key));
//           A8OutputVo vo = JSON.parseObject(val,A8OutputVo.class);
//           System.out.println(JSON.toJSONString(vo));
//       }
        String dbName = "company";
//        if(!handler.isDBExit(dbName)){
//            boolean isOk = handler.createNewDataBaseByName(dbName);
//            if(!isOk){
//                System.out.println("");
//                return;
//            }
//        }
 //       System.out.println(handler.getDataByKey(dbName,"北京华恒业房地产开发有限公司"));

//
//        // System.out.println(handler.getDataByKey("123"));
//        handler.putData(dbName,"test1234",1L);
//        System.out.println(handler.getDataByKey(dbName,"test123"));
//

    }


}
