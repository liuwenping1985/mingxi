package com.seeyon.apps.duban.util;

import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/19.
 */
public class DataBaseUtils {



    public static void executeUpdate(String sql){
        JDBCAgent agent = new JDBCAgent(true);
        try{

            System.out.println(sql);

            agent.execute(sql);
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            agent.close();
        }

    }

    public static Map querySingleDataBySQL(String sql){

        List<Map> retList = queryDataListBySQL(sql);
        if(CommonUtils.isEmpty(retList)){
            return null;
        }
        return retList.get(0);


    }


    public static List<Map> queryDataListBySQL(String sql){
        JDBCAgent agent = new JDBCAgent(true);

        List<Map> dataList = new ArrayList<Map>();
        try{
            System.out.println(sql);
            agent.execute(sql);
            return agent.resultSetToList();

        }catch(Exception e){
            e.printStackTrace();
        }finally {
            agent.close();
        }
        return dataList;
    }

    public static void main(String[] args){
        System.out.println("err");
    }
}
