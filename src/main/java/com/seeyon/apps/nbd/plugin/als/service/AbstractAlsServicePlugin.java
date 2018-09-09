package com.seeyon.apps.nbd.plugin.als.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public abstract class AbstractAlsServicePlugin implements ServicePlugin {
    private PluginDefinition pd;
    private Map<String,FormTableDefinition> fdMap = new HashMap<String,FormTableDefinition>();


    public PluginDefinition getPluginDefinition() {
        return this.pd;
    }

    public FormTableDefinition getFormTableDefinition(String affairType) {
        return fdMap.get(affairType);
    }

    public void addFormTableDefinition(FormTableDefinition definition) {
        if(definition == null){
            return;
        }
        String affType = definition.getAffairType();
        fdMap.put(affType,definition);
    }

    public void addPluginDefinition(PluginDefinition definition) {
        this.pd = definition;
    }

    public CommonDataVo receiveAffair(CommonParameter parameter) {
        throw new UnsupportedOperationException();
    }

    public CommonDataVo getAffair(CommonParameter parameter) {
        throw new UnsupportedOperationException();
    }

    public CommonDataVo deleteAffair(CommonParameter parameter) {
        throw new UnsupportedOperationException();
    }

    public CommonDataVo processAffair(CommonParameter parameter) {
        throw new UnsupportedOperationException();
    }

    public  abstract List<String> getSupportAffairTypes();


    public boolean containAffairType(String affairType) {
        if (pd == null) {
            return false;
        }
        return pd.containAffairType(affairType);

    }

    public Map<String,List<A8OutputVo>> exportAllData() {
        throw new UnsupportedOperationException();
    }

    public List<A8OutputVo> exportData(String affairType) {
        throw new UnsupportedOperationException();
    }

    public List<A8OutputVo> exportData(String affairType, CommonParameter parameter) {
        throw new UnsupportedOperationException();
    }
}
