package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.plugin.PluginDefinition;

import java.util.List;

/**
 * Created by liuwenping on 2018/8/21.
 */
public interface PluginServiceManager {

   ServicePlugin getServicePluginsByAffairType(String affairType);
   List<ServicePlugin> getServicePlugins();
   List<PluginDefinition> getPluginDefinitions();
   List<FormTableDefinition> getFormTableDefinitions();



}
