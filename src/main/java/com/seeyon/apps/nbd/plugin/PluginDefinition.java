package com.seeyon.apps.nbd.plugin;

import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.platform.plugin.constant.EnumPluginType;

import java.util.List;

/**
 * Created by liuwenping on 2018/9/7.
 */
public interface PluginDefinition {

    public String getPluginName();
    public String getPluginId();
    /**
     * 获取插件支持的事务类型
     */
     List<String> getSupportAffairTypes();
    /**
     * 获取是否支持该事务
     * @return
     */
    boolean containAffairType(String affairType);

    /**
     * 获取服务
     * @return
     */
     ServicePlugin getServicePlugin();

     public List<EnumPluginType> getPluginType();







}
