package com.seeyon.apps.nbd.core.service.impl;

import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.CustomExportProcess;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.A8ToOtherConfigEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.UUIDLong;

import java.sql.Timestamp;
import java.util.*;

/**
 * Created by liuwenping on 2018/12/10.
 */
public class RuianExportProcessor implements CustomExportProcess {

    private NbdService nbdService = new NbdService();

    public void process(A8ToOtherConfigEntity entity, Map data) {

        System.out.println("hahahahahahhahahaha");
        Integer indexCount =1;

        /**
         {formson_0192=[{field0053=null, field0010=222, field0054=null, field0033=www, field0034=wwww, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=12, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www, field0004=12, field0048=22, field0027=222, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}, {field0053=null, field0010=222, field0054=null, field0033=www2, field0034=wwww2, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=10, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www2, field0004=12, field0048=22, field0027=222单点, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}], ratifyflag=0, field0001=2403214902934651590, field0023=DJ20181211005, ratify_member_id=0, start_member_id=7239435747909386284, approve_member_id=7239435747909386284, finishedflag=1, field0029=7239435747909386284, state=1, approve_date=2018-12-11 18:48:34.734, ratify_date=null, start_date=2018-12-11 18:48:18.0}

         [{type_name=NUMBER, column_size=19, column_name=ID, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=10, column_name=STATE, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=25, column_name=START_MEMBER_ID, table_name=FORMMAIN_0155}, {type_name=TIMESTAMP(6), column_size=11, column_name=START_DATE, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=25, column_name=APPROVE_MEMBER_ID, table_name=FORMMAIN_0155}, {type_name=TIMESTAMP(6), column_size=11, column_name=APPROVE_DATE, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=10, column_name=FINISHEDFLAG, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=10, column_name=RATIFYFLAG, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=25, column_name=RATIFY_MEMBER_ID, table_name=FORMMAIN_0155}, {type_name=TIMESTAMP(6), column_size=11, column_name=RATIFY_DATE, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=10, column_name=SORT, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=25, column_name=MODIFY_MEMBER_ID, table_name=FORMMAIN_0155}, {type_name=TIMESTAMP(6), column_size=11, column_name=MODIFY_DATE, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0001, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0002, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0003, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0004, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0005, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0006, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0007, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0008, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0009, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0010, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0011, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0012, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0013, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0014, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0016, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0018, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0020, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0022, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0024, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0025, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0026, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0027, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0028, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0029, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0030, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0031, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0032, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0033, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0034, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0035, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0036, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0037, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0038, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0039, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0040, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0041, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0042, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0043, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0044, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0045, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0046, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0047, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0048, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0049, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0050, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0051, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0052, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0054, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0055, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0056, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0057, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0058, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0059, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0060, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0061, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0062, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0063, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0069, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0071, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0073, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0074, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0078, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0090, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0142, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0143, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0064, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0053, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0065, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0066, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0067, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0068, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0070, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0072, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0075, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0076, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0077, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0079, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0080, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0081, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0082, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0083, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0084, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0085, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0086, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0087, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0088, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0089, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0015, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0017, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0019, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0021, table_name=FORMMAIN_0155}, {type_name=DATE, column_size=7, column_name=FIELD0091, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0147, table_name=FORMMAIN_0155}, {type_name=NUMBER, column_size=20, column_name=FIELD0146, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0023, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0148, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0145, table_name=FORMMAIN_0155}, {type_name=VARCHAR2, column_size=255, column_name=FIELD0144, table_name=FORMMAIN_0155}]
         * */

        //String json = "{formson_0192=[{field0053=null, field0010=222, field0054=null, field0033=www, field0034=wwww, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=12, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www, field0004=12, field0048=22, field0027=222, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}, {field0053=null, field0010=222, field0054=null, field0033=www2, field0034=wwww2, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=10, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www2, field0004=12, field0048=22, field0027=222单点, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}], ratifyflag=0, field0001=2403214902934651590, field0023=DJ20181211005, ratify_member_id=0, start_member_id=7239435747909386284, approve_member_id=7239435747909386284, finishedflag=1, field0029=7239435747909386284, state=1, approve_date=2018-12-11 18:48:34.734, ratify_date=null, start_date=2018-12-11 18:48:18.0}\n";
        String tb = ConfigService.getPropertyByName("affair_type_export_table", "");
        if (CommonUtils.isEmpty(tb)) {
            return;
        }
        String ct = ConfigService.getPropertyByName("affair_type_count_key", "count");
        String index = ConfigService.getPropertyByName("affair_type_index_key", "index");
        List<Map> columnDataList = DataBaseHelper.queryColumnsByTableAndLink(ConfigService.getA8DefaultDataLink(), tb);
        System.out.println(data);
        FormTableDefinition ftd = entity.getFtd();
        FormTable ft = ftd.getFormTable();
        List<FormTable> slaveTable = ft.getSlaveTableList();
        //执行sql的
        List<String> executeSQL = new ArrayList<String>();
        //执行insert的数据
        List<Map> insertDatas = new ArrayList<Map>();
        //子表+主表的平铺数据
        Map<String, Map> dataSlaveMap = new HashMap<String, Map>();
        for (FormTable sFt : slaveTable) {
            //从data中取出子表数据,然后删除掉
            Object obj = data.get(sFt.getName());
            data.remove(sFt.getName());
            List<Map> retList = new ArrayList<Map>();
            if (obj instanceof List) {
                retList.addAll((List) obj);
            } else {
                retList.add((Map) obj);
            }
            //处理子表数据
            int tag=1;
            for (Map sData : retList) {
                Object objMap = dataSlaveMap.get(tag+"-"+String.valueOf(data.get("id")));
                Map childMap = null;
                if(objMap==null){
                     childMap = new HashMap();
                    dataSlaveMap.put(tag+"-"+String.valueOf(data.get("id")),childMap);
                }else{
                    childMap=(Map)objMap;
                }

                //先复制一份主表数据
                childMap.putAll(data);
                //填入子表数据
                childMap.putAll(sData);
                tag++;

            }
        }

        for (Map sData : dataSlaveMap.values()) {
            //取列名
            //从map中取数据
            String indexOtherFieldName = "";
            String indexField = "";
            Integer count = 0;
            String countFieldName="";
            for (Object key : sData.keySet()) {
                if (String.valueOf(key).contains(ct)) {
                    try {
                        //System.out.println("key:+)
                        count = Integer.parseInt("" + sData.get(key));
                        countFieldName = ("" + key).split("_")[1];
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (String.valueOf(key).contains(index)) {
                    try {
                        indexField = "" + key;
                        indexOtherFieldName = ("" + key).split("_")[1];
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

            }

            Map<String, String> columnsData = genDataMap(columnDataList);

            for (int i = 0; i < count; i++) {
                Map insertMap = new HashMap();
                Object fVal = sData.get(indexField);
                if(fVal!=null){
                    insertMap.put(indexOtherFieldName.toUpperCase(),fVal+"-"+indexCount++);
                    insertMap.put(countFieldName.toUpperCase(),1);
                }
                for (String colName : columnsData.keySet()) {
                    String lowerCaseCol = colName.toLowerCase();
                    String type = columnsData.get(colName);
                    Object obj = sData.get(lowerCaseCol);
                    if (obj != null) {
                        if(type.toLowerCase().contains("timestamp")){
                            try{
                                if(obj instanceof Date){
                                    insertMap.put(colName,new Timestamp(((Date)obj).getTime()));
                                }else if(obj instanceof String){
                                    Date dt = new Date((String)obj);
                                    insertMap.put(colName,new Timestamp(dt.getTime()));
                                }else{
                                    insertMap.put(colName,new Timestamp(new Date().getTime()));
                                }

                            }catch(Exception e){

                            }
                        }else{
                            insertMap.put(colName,obj);
                        }

                    }
                }

                insertDatas.add(insertMap);

            }


        }

        //System.out.println(insertDatas);

        for(Map insertData:insertDatas){
            List<String> keyList = new ArrayList<String>();
            List<Object> valueList = new ArrayList<Object>();
            List<String> wenhao = new ArrayList<String>();
            for(Object key:insertData.keySet()){
                keyList.add(String.valueOf(key));
                if("id".equals(key.toString().toLowerCase())){
                    valueList.add(UUIDLong.longUUID());
                }else{
                    valueList.add(insertData.get(key));
                }

                wenhao.add("?");
            }
            String sql = "INSERT INTO " + tb+" (" +DataBaseHelper.join(keyList,",")+") VALUES("+DataBaseHelper.join(wenhao,",")+")";
            try {
               Integer count =  DataBaseHelper.executeUpdateByNativeSQLAndLink(ConfigService.getA8DefaultDataLink(),sql,valueList);
              //  System.out.println(count);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }


        System.out.println("hahahahahahhahahaha");
    }

    private Map<String, String> genDataMap(List<Map> columnDataList) {
        Map<String, String> dataMap = new HashMap<String, String>();
        for (Map col : columnDataList) {
            dataMap.put("" + col.get("column_name"), "" + col.get("type_name"));
        }
        return dataMap;
    }

    public void process(String code, CtpAffair affair) {
        Long formRecordId = affair.getFormRecordid();
        CommonParameter cp = new CommonParameter();
        cp.$("affairType", code);
        NbdResponseEntity<FormTableDefinition> entity = nbdService.getFormByTemplateNumber(cp);
        FormTableDefinition ftd = entity.getData();
        try {
            Map data = nbdService.exportMasterData(formRecordId, ftd, false);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
