package com.seeyon.apps.nbd.core.service;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/8/21.
 */
public final class ServiceHolder {



    public static ServicePlugin getService(String affairType){

        //手工加的
        for(ServicePlugin sp:pluginList){

            if(sp.containAffairType(affairType)){
                return sp;
            }
        }
        //系统自带的标准service



        return null;

    }



    private static List<ServicePlugin> pluginList = new ArrayList<ServicePlugin>();

    public static void addServicePlugin(ServicePlugin servicePlugin){
        pluginList.add(servicePlugin);
    }
}
