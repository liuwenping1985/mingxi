package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.duban.vo.form.FormField;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.NormalTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.TableField;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.nbd.log.LogBuilder;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.apps.nbd.po.OtherToA8ConfigEntity;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.ctp.util.UUIDLong;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 往里边扔数据
 * Created by liuwenping on 2019/1/17.
 */
public class DataImportService {
    private static final LogBuilder lb = new LogBuilder("Other-to-a8");
   // private final Log logger = Logger//getLogger(DataImportService.class);
    private DataImportService() {

    }

    public static final DataImportService getInstance() {

        return Holder.ins;
    }


    public void importFromOtherToA8(OtherToA8ConfigEntity otherToA8ConfigEntity) {
        //把对象拉直
        TransferService.getInstance().filledOtherToA8(otherToA8ConfigEntity);
        //获取数据
        List<Map> dataList = fetchData(otherToA8ConfigEntity);
        //导入数据
        importData(otherToA8ConfigEntity, dataList);
    }


    private List<Map> fetchData(OtherToA8ConfigEntity entity) {

        String exportType = entity.getExportType();
        String storeType = entity.getExtString2();
        String otherTable = entity.getExtString1();
        String a8Table = entity.getExtString4();
        String mappingUniqueKey = getUniqueKeyMapping(entity);
        System.out.println("mappingUniqueKey:"+mappingUniqueKey);
        Long linkId = entity.getLinkId();
        DataLink a8Link = ConfigService.getA8DefaultDataLink();
        List<Map> retList = new ArrayList<Map>();
        if ("schedule".equals(exportType)) {
            String sql = "select * from " + otherTable + " where 1=1";
            if (!CommonUtils.isEmpty(mappingUniqueKey)) {
                if ("form".equals(storeType)) {
                    //处理表单的逻辑
                    //todo 这个逻辑没有写
                    return retList;
                } else {
                    String sql2 = "select " + mappingUniqueKey + " from " + a8Table;
                    try {
                        List<Map> uniquekeyList = DataBaseHelper.executeQueryByNativeSQL(sql2);
                        if (CommonUtils.isNotEmpty(uniquekeyList)) {
                            List<String> keys = new ArrayList<String>();
                            for (Map data : uniquekeyList) {
                                Object key = data.get(mappingUniqueKey.toLowerCase());
                                if (key != null) {
                                    Long val = CommonUtils.getLong(key);
                                    if (val != null) {
                                        keys.add(val.toString());
                                    } else {
                                        keys.add("'" + key.toString() + "'");
                                    }
                                }
                            }
                            if (CommonUtils.isNotEmpty(keys)) {
                                String uniqueKey = entity.getExtString3();
                                if(keys.size()>1000){
                                    int size = 0;

                                    List<String> subSql = new ArrayList<String>();
                                    while(size<keys.size()){
                                        List<String> subList;
                                        if(size+999<keys.size()){
                                           subList = keys.subList(size,size+999);
                                           size = size+999;
                                        }else{
                                            subList = keys.subList(size,keys.size());
                                            size=keys.size()+99;
                                            //break out
                                        }

                                        subSql.add(" "+uniqueKey+" not in ("+DataBaseHelper.join(subList,",")+") ");
                                    }
                                    StringBuilder stb = new StringBuilder();
                                    stb.append("(");
                                    stb.append(DataBaseHelper.join(subSql,"and"));
                                    stb.append(")");
                                    sql += " and "+stb.toString();
                                }else{
                                    sql += " and " + uniqueKey + " not in(" + DataBaseHelper.join(keys, ",") + ")";
                                }

                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }


            }
            if ("form".equals(storeType)) {
                //TODO 这个逻辑没有写 处理表单的逻辑

            } else {
                if (linkId != null && !linkId.equals(-1)) {

                    DataLink oLink = DataBaseHelper.getDataByTypeAndId(a8Link, DataLink.class, linkId);
                    if (oLink != null) {
                        System.out.println(sql);
                        return DataBaseHelper.executeQueryBySQLAndLink(oLink, sql);
                    }
                }


            }


        } else {
            //API获取有点麻烦免了吧api_get
            String invokeUrl = entity.getExportUrl();
            if (!CommonUtils.isEmpty(invokeUrl)) {
                try {
                    Map ret = UIUtils.httpGetInvoke(invokeUrl);
                    retList.add(ret);
                } catch (Exception e) {
                    lb.error("[OTHER_TO_A8]" + e.getMessage(), "" + entity.getId(), false);
                    lb.log(e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        //把数据整回来了
        System.out.println("data---size:"+retList);
        return retList;
    }

    private String getUniqueKeyMapping(OtherToA8ConfigEntity entity) {
        String storeType = entity.getExtString2();
        String uniqueKey = entity.getExtString3();
        if (CommonUtils.isEmpty(uniqueKey)) {
            return null;
        }
        if ("form".equals(storeType)) {
            FormTableDefinition ftd = entity.getFtd();
            if (ftd != null) {
                List<FormField> ffList = ftd.getFormTable().getFormFieldList();
                for (FormField ff : ffList) {
                    String barCode = ff.getBarcode();
                    if(barCode==null){
                       continue;
                    }
                    if (uniqueKey.toLowerCase().equals(barCode.toLowerCase())) {
                        return ff.getName();
                    }
                }
            }
        } else {
            NormalTableDefinition ntd = entity.getTableFtd();
            if (ntd != null) {

                List<TableField> tfList = ntd.getFieldList();
                for (TableField tf : tfList) {
                    String mapping = tf.getMapping().toLowerCase();
                    if (uniqueKey.toLowerCase().equals(mapping)) {
                        return tf.getName();
                    }

                }
            }

        }
        //没找到映射
        return null;

    }

    private void importData(OtherToA8ConfigEntity entity, List<Map> dataList) {

        if (!CommonUtils.isEmpty(dataList)) {
            for (Map data : dataList) {
                importData(entity, data);
            }

        }


    }

    private void importData(OtherToA8ConfigEntity entity, Map insertData) {
        if (CommonUtils.isEmpty(insertData)) {
            return;
        }
        String storeType = entity.getExtString2();
        String a8Table = entity.getExtString4();
        if ("form".equals(storeType)) {


        } else {
            List<String> keyList = new ArrayList<String>();
            List<Object> valueList = new ArrayList<Object>();
            List<String> wenhao = new ArrayList<String>();
            NormalTableDefinition ntd = entity.getTableFtd();
            List<TableField> tfList = ntd.getFieldList();
            for (TableField tf : tfList) {
                String name = tf.getName();
                if(!"1".equals(tf.getExport())){
                    continue;
                }
                if (name == null) {
                    continue;
                }
                name = name.toLowerCase();
                if ("id".equals(name)) {
                    keyList.add(tf.getName());
                    valueList.add(UUIDLong.longUUID());
                    wenhao.add("?");
                    continue;
                }
                String mapping = tf.getMapping();
                if (CommonUtils.isNotEmpty(mapping)) {
                    mapping = mapping.toLowerCase();
                    Object val = insertData.get(mapping);
                    // TransferService.getInstance().t
                    if (val != null) {
                        val = TransferService.getInstance().transFormCommon(tf.getClassname(), val);
                        keyList.add(tf.getName());
                        valueList.add(val);
                        wenhao.add("?");
                    }

                }

            }
            String sql = "INSERT INTO " + a8Table + " (" + DataBaseHelper.join(keyList, ",") + ") VALUES(" + DataBaseHelper.join(wenhao, ",") + ")";
            try {
                Integer count = DataBaseHelper.executeUpdateByNativeSQLAndLink(ConfigService.getA8DefaultDataLink(), sql, valueList);
                lb.log(count+":saved:"+sql);
                System.out.println(sql);
            } catch (Exception e) {
                lb.error("ERROR:"+e.getMessage(), JSON.toJSONString(insertData),false);
                e.printStackTrace();
            }






        }




    }


    private static class Holder {

        private static DataImportService ins = new DataImportService();

    }

    public static void main(String[] args){

        System.out.println("1");
    }
}
