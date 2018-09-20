package com.seeyon.apps.nbd.core.db;

import com.seeyon.ctp.util.JDBCAgent;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * Created by liuwenping on 2018/9/9.
 */
public final class DataBaseHelper {

    public static List<Map> executeQueryByNativeSQL(String sql) throws Exception {
        JDBCAgent jdbc = new JDBCAgent();
        try {
            jdbc.execute(sql.toString());
             List<Map> list =  jdbc.resultSetToList();
            return list;
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            jdbc.close();
        }
       return new ArrayList<Map>();

    }



}
