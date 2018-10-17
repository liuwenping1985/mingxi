package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class DataTransferService {
    private static Map<String,DataParaser> dataParaserMap = new HashMap<String, DataParaser>();
    static{
        dataParaserMap.put("HTFKSQD1", new DataParaser() {


            public KingDeeBill parse(Map data) {
                KingDeeBill bill = new KingDeeBill();
                return parse(bill,data);
            }

            public KingDeeBill parse(KingDeeBill bill, Map data) {
                return null;
            }
        });

    }
    public DataParaser getDataParaserByAffairType(String affairType){

        return dataParaserMap.get(affairType);
    }
}
