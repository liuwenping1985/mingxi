package com.seeyon.apps.nbd.plugin.bairong.config;

import com.seeyon.apps.nbd.core.service.ServiceHolder;
import com.seeyon.apps.nbd.platform.oa.OaServiceRegister;
import com.seeyon.apps.nbd.plugin.bairong.service.BairongService;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class ServiceApplicationConfig {

    public ServiceApplicationConfig(){

        this.init();

    }

    private void init(){
        BairongService bs = new BairongService();
        OaServiceRegister register = new OaServiceRegister();
        register.addServicePlugin(bs);
        ServiceHolder.addServiceRegister(register);
    }
}
