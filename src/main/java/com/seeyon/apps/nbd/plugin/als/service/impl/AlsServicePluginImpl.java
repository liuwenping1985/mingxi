package com.seeyon.apps.nbd.plugin.als.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.als.service.AbstractAlsServicePlugin;
import com.seeyon.ctp.common.ctpenum.manager.EnumManagerImpl;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;

import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class AlsServicePluginImpl extends AbstractAlsServicePlugin {

    public EnumManager getEnumManager(Long id){
       // Enumcon

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
        System.out.println(" i am ok");
        System.out.println(" export master table");
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            List<List<SimpleFormField>> simpleList = ftd.filledValue(list);
            for(List<SimpleFormField> sffList:simpleList){
                A8OutputVo  a8OutputVo = exportA8OutputVo(affairType,sffList);
                if(a8OutputVo!=null){
                    dataList.add(a8OutputVo);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(" end of export master table");
        return dataList;

    }

    private A8OutputVo exportA8OutputVo(String affairType,List<SimpleFormField> sffList){

        if(CommonUtils.isEmpty(sffList)){
            return  null;
        }
        A8OutputVo vo = new A8OutputVo();
        Map<String,Object> dataMap = new HashMap<String, Object>();
        vo.setStatus(0);
        vo.setCreateDate(new Date());
        vo.setUpdateDate(vo.getCreateDate());
        vo.setType(affairType);
        for(SimpleFormField sff :sffList){
            if(sff.getName().toLowerCase().equals("id")){
                vo.setSourceId(CommonUtils.paserLong(sff.getValue()));
            }
            if(sff.getName().toLowerCase().equals("start_date")){
               Object obj =  sff.getValue();
               vo.setYear(String.valueOf(CommonUtils.getYear(String.valueOf(obj))));
               vo.setCreateDate(CommonUtils.parseDate(String.valueOf(obj)));
               vo.setUpdateDate(vo.getCreateDate());
            }


            dataMap.put(sff.getDisplay(),sff.getValue());
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
