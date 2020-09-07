package com.xad.bullfly.core.manager;

import com.xad.bullfly.core.common.service.MicroService;

/**
 * Created by liuwenping on 2019/8/21.
 */

public interface ServiceProviderManager {

     <T extends MicroService> T getServiceByName(String serviceName);

     <T extends MicroService> T getServiceByType(Class<T> serviceType);

     <T extends MicroService> void registerService(T t);
     <T extends MicroService> void registerService(String svcName, T t);

     <T extends MicroService> T removeService(T t);

     <T extends MicroService> T removeService(String svcName);
}
