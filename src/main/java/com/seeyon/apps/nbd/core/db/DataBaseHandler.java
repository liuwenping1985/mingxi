package com.seeyon.apps.nbd.core.db;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.login.auth.DefaultLoginAuthentication;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.organization.principal.PrincipalManagerImpl;
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
        if(!StringUtils.isEmpty(stb.toString())){
            dbMap = JSON.parseObject(stb.toString(),HashMap.class);
        }
        stb = initDataBase(EXT_DB);
        if(!StringUtils.isEmpty(stb.toString())){
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

    }
    private StringBuilder initDataBase(String dataBaseName){
        StringBuilder stb = new StringBuilder();
        try {
            FileReader fr = new FileReader(this.getFile(dataBaseName));
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
        return stb;

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
        FileWriter fw = null;
        try {
            f.createNewFile();
            fw = new FileWriter(f);
            fw.write(content);
            fw.flush();
        } catch (Exception e) {
            e.printStackTrace();

        }finally {
            if(fw!=null){
                try {
                    fw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

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
    public <T> T getDataByKeyAndClassType(String dbName,String key,Class<T> cls){
        Map db= dbContainerMap.get(dbName);
        if(db==null){
            return null;
        }
        Object obj =  db.get(key);
        String jstring = JSON.toJSONString(obj);
        T t = JSON.parseObject(jstring,cls);
        return t;
    }

    public void putData(String key,Object obj){

        dbMap.put(key,obj);
        store();
    }

    public Object removeDataByKey(String dbName,String key){
        Map db= dbContainerMap.get(dbName);
        Object obj = null;
        if(db!=null){
           obj=  db.remove(key);
           if(obj!=null){
               store(dbName);
           }
        }
        return obj;
    }
    public void putAllData(Map obj){

        dbMap.putAll(obj);
        store();
    }
    public void putData(String dbName,String key,Object obj){
        Map db= dbContainerMap.get(dbName);
        if(db == null){
            return;
        }
        db.put(key,obj);
        store(dbName);
    }
    public void putAllData(String dbName,Map data){
        Map db= dbContainerMap.get(dbName);
        if(db == null||data == null){
            return ;
        }
        db.putAll(data);
        store(dbName);
    }
    public Map getDataAll(String dbName){
        Map db= dbContainerMap.get(dbName);
        Map neew =new HashMap();
        if(db == null){
            return null;
        }
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
        String dbName = "company";
//        if(!handler.isDBExit(dbName)){
//            boolean isOk = handler.createNewDataBaseByName(dbName);
//            if(!isOk){
//                System.out.println("");
//                return;
//            }
//        }
        System.out.println(handler.getDataByKey(dbName,"北京华恒业房地产开发有限公司"));

//
//        // System.out.println(handler.getDataByKey("123"));
//        handler.putData(dbName,"test1234",1L);
//        System.out.println(handler.getDataByKey(dbName,"test123"));
//

    }


}
