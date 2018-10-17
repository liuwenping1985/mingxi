package com.seeyon.apps.nbd.plugin.als;

import com.seeyon.apps.nbd.core.service.ServicePlugin;
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
        AFFAIR_TYPE_LIST.add("HT0001");
        AFFAIR_TYPE_LIST.add("HT0002");
        AFFAIR_TYPE_LIST.add("HT0003");
        AFFAIR_TYPE_LIST.add("HT0004");
        AFFAIR_TYPE_LIST.add("HT0005");
        AFFAIR_TYPE_LIST.add("HT0006");
        AFFAIR_TYPE_LIST.add("HT0007");
        AFFAIR_TYPE_LIST.add("FK0001");
        AFFAIR_TYPE_LIST.add("FK0002");
        AFFAIR_TYPE_LIST.add("FK0003");
        AFFAIR_TYPE_LIST.add("FK0004");
        AFFAIR_TYPE_LIST.add("FK0005");
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
}
