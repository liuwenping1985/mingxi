package com.seeyon.apps.nbd.plugin.als;

import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.platform.plugin.constant.EnumPluginType;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.service.impl.AlsServicePluginImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 另外一个幸运的service
 * just a joke
 * Another lucky Service
 * Created by liuwenping on 2018/9/7.
 */
public class AlsPluginDefinition implements PluginDefinition{

    private static List<String> AFFAIR_TYPE_LIST = new ArrayList<String>();

    private AlsServicePluginImpl service = new AlsServicePluginImpl();

    static{
        AFFAIR_TYPE_LIST.add("FK0001");
    }

    public AlsPluginDefinition (){
        service.addPluginDefinition(this);
    }

    public String getPluginName() {
        return "als";
    }

    public String getPluginId() {
        return UUID.randomUUID().toString();
    }


    public List<String> getSupportAffairTypes(){
        return AFFAIR_TYPE_LIST;

    }

    public boolean containAffairType(String affairType) {

        for(String af:AFFAIR_TYPE_LIST){
            if(af.equals(affairType)){
                return true;
            }
        }
        return false;
    }

    public ServicePlugin getServicePlugin() {
        return service;
    }
    private static List<EnumPluginType> list = new ArrayList<EnumPluginType>();
    static{

        list.add(EnumPluginType.EXPORT_DB);
    }
    public List<EnumPluginType> getPluginType() {

        return list;
    }
}
