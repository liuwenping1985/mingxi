package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.entity.ServiceAffairs;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/8/21.
 */
public final class ServiceHolder {



    public static ServicePlugin getService(String affairType){

        for(ServicePlugin sp:pluginList){

            if(sp.containAffairType(affairType)){
                return sp;
            }
        }


        return null;

    }

    public static ServiceAffairs getServiceAffairs(String affairType){

        ServicePlugin sp = getService(affairType);
        return sp.getServiceAffairs(affairType);
    }



    private static List<ServicePlugin> pluginList = new ArrayList<ServicePlugin>();

    public static void addServicePlugin(ServicePlugin servicePlugin){
        pluginList.add(servicePlugin);
    }
}
