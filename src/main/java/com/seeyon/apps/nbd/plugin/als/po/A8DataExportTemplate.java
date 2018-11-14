package com.seeyon.apps.nbd.plugin.als.po;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/13.
 */
public class A8DataExportTemplate {

    public static Map<String,String> dataMap = new HashMap<String,String>();
    static{

        dataMap.put("formmain_2571","FK0002");
        dataMap.put("formmain_1841","FK0003");
        dataMap.put("formmain_1415","FK0004");
        dataMap.put("formmain_0111","FK0005");
        dataMap.put("formmain_0998","FK0001");
        dataMap.put("formmain_0025","HT0005");
        dataMap.put("formmain_1455","HT0006");
        dataMap.put("formmain_1626","HT0007");
        dataMap.put("formmain_2434","HT0002");
        dataMap.put("formmain_0845","HT0004");
        dataMap.put("formmain_2660","HT0001");






    }
    public static String getAffairTypeByName(String name){


        return dataMap.get(name);

    }

}
