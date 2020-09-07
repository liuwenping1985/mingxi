package com.xad.bullfly.core.manager.impl;

import com.xad.bullfly.core.common.annotation.MicroServiceProvider;
import com.xad.bullfly.core.common.service.MicroService;
import com.xad.bullfly.core.manager.ServiceProviderManager;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2019/8/21.
 *
 * @Author liuwenping
 */
@Component("serviceProviderManager")
@Order(2)
public class ServiceProviderManagerImpl implements ServiceProviderManager {

    private Map<String, MicroService> serviceHolder = new HashMap<>();

    @Override
    public <T extends MicroService> T getServiceByName(String serviceName) {
        if (serviceName == null) {
            return null;
        }

        return (T) serviceHolder.get(serviceName);
    }

    @Override
    public <T extends MicroService> T getServiceByType(Class<T> serviceType) {
        if (serviceType == null) {
            return null;
        }
        MicroServiceProvider provider = serviceType.getAnnotation(MicroServiceProvider.class);
        if (provider != null) {
            String svcName = provider.name();
            if (!StringUtils.isEmpty(svcName)) {
                T t = getServiceByName(svcName);
                if (t != null) {
                    return t;
                }
            }
        }
        Collection<MicroService> services = serviceHolder.values();
        for (MicroService microService : services) {
            if (microService.getClass() == serviceType) {
                return (T) microService;
            }
        }

        return null;
    }

    @Override
    public <T extends MicroService> void registerService(T t) {
        if (t == null) {
            throw new RuntimeException("can not register a null service!");
        }
        MicroServiceProvider provider = t.getClass().getAnnotation(MicroServiceProvider.class);
        if (provider != null) {
            String svcName = provider.name();
            serviceHolder.put(svcName, t);
        } else {
            serviceHolder.put(t.getClass().getSimpleName(), t);
        }

    }

    @Override
    public <T extends MicroService> void registerService(String svcName, T t) {
        if (svcName == null || t == null) {
            throw new RuntimeException("can not register a null service name!");
        }
        serviceHolder.put(svcName, t);

    }

    @Override
    public <T extends MicroService> T removeService(T t) {

        MicroServiceProvider provider = t.getClass().getAnnotation(MicroServiceProvider.class);
        if (provider != null) {
            String svcName = provider.name();
            return (T)serviceHolder.remove(svcName);
        }
           return (T)serviceHolder.remove(t.getClass().getSimpleName());


    }

    @Override
    public <T extends MicroService> T removeService(String svcName) {

        return (T)serviceHolder.remove(svcName);
    }
}
