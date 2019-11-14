package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.po.A8OutputVo;


import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/20.
 */
public interface ServicePlugin {

    public PluginDefinition getPluginDefinition();
    public FormTableDefinition getFormTableDefinition(String affairType);
    void addFormTableDefinition(FormTableDefinition definition);
    void addPluginDefinition(PluginDefinition definition);
    public CommonDataVo receiveAffair(CommonParameter parameter);
    public CommonDataVo getAffair(CommonParameter parameter);
    public CommonDataVo deleteAffair(CommonParameter parameter);
    public CommonDataVo processAffair(CommonParameter parameter);
    public List<String> getSupportAffairTypes();
    public boolean containAffairType(String affairType);
    public Map<String,List<A8OutputVo>> exportAllData();
    public List<A8OutputVo> exportData(String affairType);
    public List<A8OutputVo> exportData(String affairType, CommonParameter parameter);




}
