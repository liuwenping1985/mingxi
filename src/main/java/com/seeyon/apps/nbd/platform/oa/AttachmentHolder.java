package com.seeyon.apps.nbd.platform.oa;

import com.seeyon.apps.nbd.core.db.DataBaseHelper;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/16.
 */
public class AttachmentHolder {




    public static List<Map> getDataById(Object id){
        isInit();

        return null;

    }
    public static List<Map> getDataByReferenceId(Object id){
        isInit();

        return null;

    }
    public static List<Map> getDataBySubReferenceId(Object id){
        isInit();

        return null;

    }

    public static List<Map> getByRawId(Long sid){

        return null;
    }
    private static boolean is_ok = false;

    private static Map<Long,Map> dataMap = new HashMap<Long, Map>();

    private synchronized static void isInit(){

        if(is_ok){
            return;
        }

        String sql = "select * from ctp_attachment";
        try {
            List<Map> sqlDataList = DataBaseHelper.executeQueryByNativeSQL(sql);
            for(Map data:sqlDataList){
                dataMap.put(getLong(data.get("id")),data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
    private  static Long getLong(Object obj){
        if(obj instanceof Long){
            return (Long)obj;
        }
        if(obj instanceof BigDecimal){
            return ((BigDecimal)obj).longValue();
        }
        try{

            return Long.parseLong(String.valueOf(obj));
        }catch (Exception e){
            return null;
        }
    }


}
