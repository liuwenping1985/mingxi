package com.xad.bullfly.core.common.service;

import com.xad.bullfly.core.common.AppContextUtil;
import com.xad.bullfly.core.manager.ServiceProviderManager;

/**
 * Created by liuwenping on 2019/9/2.
 */
public abstract class AbstractMicroService implements MicroService {




    public ServiceProviderManager getServiceProviderManager(){
        ServiceProviderManager svc = (ServiceProviderManager) AppContextUtil.getApplicationContext().getBean("serviceProviderManager");
        return svc;
    }

    @Override
    public abstract String getServiceName();

    public AbstractMicroService() {
        ServiceRegister.addMicroService(this);
    }


}
