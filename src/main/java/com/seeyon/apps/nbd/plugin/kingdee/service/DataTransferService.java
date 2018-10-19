package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.plugin.kingdee.vo.CommonKingDeeVo;
import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;
import com.seeyon.apps.nbd.plugin.kingdee.vo.KingdeeEntry;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by liuwenping on 2018/10/17.
 */
public final class DataTransferService {
    private static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    private static Map<String,DataParser> dataParaserMap = new HashMap<String, DataParser>();
    static class DefaultDataParser implements DataParser {

        public KingDeeBill parse(Map data, FormTableDefinition ftd) {
            KingDeeBill bill = new KingDeeBill();
            return parse(bill,data,ftd);
        }

        public KingDeeBill parse(KingDeeBill bill, Map data, FormTableDefinition ftd) {
            System.out.println("data:"+JSON.toJSONString(data));
            List<FormField> ffList = ftd.getFormTable().getFormFieldList();
            String billString = JSON.toJSONString(bill);
            Map retData = JSON.parseObject(billString,HashMap.class);
            for(FormField ff:ffList){
                String ffName = ff.getClassname();
                if(CommonUtils.isEmpty(ffName)){
                    continue;
                }
                if(ffName.contains("ws")){
                    String barCode = ff.getBarcode();
                    Object obj = data.get(ff.getName());
                    Object dt =transData(ff.getClassname(),obj);
                    retData.put(barCode,dt);
                }
            }
           // System.out.println("jsonmap"+retData);
            bill = JSON.parseObject(JSON.toJSONString(retData),KingDeeBill.class);
            bill.setLocalAmt(bill.getAmount());
            bill.setNumber(String.valueOf(data.get("id")));
            List<KingdeeEntry> entryList = new ArrayList<KingdeeEntry>();
            KingdeeEntry entry = new KingdeeEntry();
            entry.setAmount(bill.getAmount());
            entry.setLocalAmt(bill.getAmount());
            entryList.add(entry);
            bill.setEntries(entryList);
            bill.setBizDate(format.format(new Date()));
            return bill;
        }
    }
    private static DataParser defaultDataParser = new DefaultDataParser();

    static{
        dataParaserMap.put("HTFKSQD1",defaultDataParser);
        dataParaserMap.put("HTFKSQD2",defaultDataParser);
        dataParaserMap.put("HTFKSQD_GLFY",defaultDataParser);
    }

    public DataParser getDataParaserByAffairType(String affairType){
        return dataParaserMap.get(affairType);
    }

    private static Object transData(String clsName,Object obj){
        if(CommonUtils.isEmpty(clsName)||"ws".equals(clsName)){
            return obj;
        }
        if("ws_enum".equals(clsName)){
            return CommonUtils.getEnumShowValue(obj);
        }
        if("ws_wrapper".equals(clsName)){
           return new CommonKingDeeVo(String.valueOf(obj));
        }
        if("ws_wrapper_account".equals(clsName)){

            String val = String.valueOf(CommonUtils.getOrgValueByDeptIdAndType(obj,1));
            return new CommonKingDeeVo(val);
        }
        if(clsName.contains("ws_wrapper_local")){
            Object val =  getFromLocal(clsName,obj);
            return new CommonKingDeeVo(String.valueOf(val));
        }
        if(clsName.contains("ws_local")){
            return getFromLocal(clsName,obj);


        }


        return obj;
    }

    private static Object getFromLocal(String clsName,Object key){
        System.out.println("local:"+key);
        String[] splitClsName = clsName.split("_");
        String dbName = splitClsName[splitClsName.length-1];
        Object val = DataBaseHandler.getInstance().getDataByKey(dbName,String.valueOf(key));
        if(val == null){
            if("北京华恒业房地产开发有限公司".equals(key)){
                return "01010102";
            }
            if("北京华富新业房地产开发有限公司".equals(key)){
                return "01010103";
            }
            if("北京华恒兴业房地产开发有限公司".equals(key)){
                return "01010101";
            }
            return key;
        }

        return val;
    }

    public static void main(String[] args){
        String clsName="ws_wrapper_local_company";
        Object val= "北京华恒业房地产开发有限公司";
        System.out.println(""+clsName.contains("ws")+getFromLocal(clsName,val));
    }


}
