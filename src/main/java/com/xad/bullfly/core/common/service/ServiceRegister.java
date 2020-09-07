package com.xad.bullfly.core.common.service;

import com.alibaba.druid.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/1/2.
 */
public final class ServiceRegister {

    private static Map<String, MicroService> microServiceContainer = new HashMap<String, MicroService>();

    public static List<MicroService> getMicroServices() {
        List<MicroService> mLists = new ArrayList<>();
        mLists.addAll(microServiceContainer.values());
        return mLists;
    }

    public static void addMicroService(MicroService svc) {
        if (svc != null) {
            //serviceProviderManager
            if (StringUtils.isEmpty(svc.getServiceName())) {
                microServiceContainer.put(svc.getClass().getSimpleName(), svc);
            }else{
                microServiceContainer.put(svc.getServiceName(), svc);
            }

        }

    }
}
