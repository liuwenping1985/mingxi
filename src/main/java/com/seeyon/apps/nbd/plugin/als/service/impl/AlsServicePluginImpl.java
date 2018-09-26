package com.seeyon.apps.nbd.plugin.als.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.als.service.AbstractAlsServicePlugin;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;

import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class AlsServicePluginImpl extends AbstractAlsServicePlugin {
    private EnumManager enumManager;
    public EnumManager getEnumManager() {
        // Enumcon
        if(enumManager==null){
            enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
        }
        return enumManager;
    }

    public CtpEnumItem getCtpEnumItemById(Long enumId){

        CtpEnumItem item = null;
        try {
            item = getEnumManager().getCacheEnumItem(enumId);
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        if(item == null){


        }

        return null;

    }

    public String getFieldDisplayName(Object val){

        return null;
    }

    public List<String> getSupportAffairTypes() {
        return this.getPluginDefinition().getSupportAffairTypes();
    }

    public Map<String, List<A8OutputVo>> exportAllData() {
        throw new UnsupportedOperationException();
    }

    public List<A8OutputVo> exportData(String affairType) {
        List<A8OutputVo> dataList = new ArrayList<A8OutputVo>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        System.out.println("----starting export data----");
        System.out.println("----export master table---");
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            System.out.println("master table data size:" + list.size());
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables) && !CommonUtils.isEmpty(list)) {
                //create temp master table container

                Map<Long, Map> masterTempMap = new HashMap<Long, Map>();
                for (Map masterMap : list) {
                    Object id = masterMap.get("id");
                    if (id != null) {
                        masterTempMap.put((Long) id, masterMap);
                    }
                }

                for (FormTable ft : slaveTables) {
                    System.out.println("[<---->]export slave table:" + ft.getName());
                    String slaveTableSql = FormTableDefinition.genAllQuery(ft);
                    List<Map> slaveDataList = DataBaseHelper.executeQueryByNativeSQL(slaveTableSql);
                    //onwerfield
                    if (!CommonUtils.isEmpty(slaveDataList)) {
                        for (Map slaveTableMap : slaveDataList) {
                            Object fmId = slaveTableMap.get("formmain_id");
                            if (fmId != null) {
                                Map masterMap = masterTempMap.get((Long) fmId);
                                if (!CommonUtils.isEmpty(masterMap)) {
                                    masterMap.putAll(slaveTableMap);
                                }
                            }
                        }
                    }
                }
            }
            List<List<SimpleFormField>> simpleList = ftd.filledValue(list);
            for (List<SimpleFormField> sffList : simpleList) {
                A8OutputVo a8OutputVo = exportA8OutputVo(affairType, sffList);
                if (a8OutputVo != null) {
                    dataList.add(a8OutputVo);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(" end of export master table");
        return dataList;

    }

    private A8OutputVo exportA8OutputVo(String affairType, List<SimpleFormField> sffList) {

        if (CommonUtils.isEmpty(sffList)) {
            return null;
        }
        A8OutputVo vo = new A8OutputVo();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        vo.setStatus(0);
        vo.setCreateDate(new Date());
        vo.setUpdateDate(vo.getCreateDate());
        vo.setType(affairType);
        //处理子表

        //end of 处理
        for (SimpleFormField sff : sffList) {
            if (sff.getName().toLowerCase().equals("id")) {
                vo.setSourceId(CommonUtils.paserLong(sff.getValue()));
            }
            if (sff.getName().toLowerCase().equals("start_date")) {
                Object obj = sff.getValue();
                vo.setYear(String.valueOf(CommonUtils.getYear(String.valueOf(obj))));
                vo.setCreateDate(CommonUtils.parseDate(String.valueOf(obj)));
                vo.setUpdateDate(vo.getCreateDate());
            }
            /**
             * 翻译
             */


            dataMap.put(sff.getDisplay(), sff.getValue());
        }
        vo.setData(JSON.toJSONString(dataMap));
        vo.setIdIfNew();
        return vo;
    }

    public List<A8OutputVo> exportData(String affairType, CommonParameter parameter) {
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        return null;
    }
}
