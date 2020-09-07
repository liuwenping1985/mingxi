package com.xad.bullfly.core.service.impl;

import com.xad.bullfly.core.common.service.AbstractMicroService;
import com.xad.bullfly.core.service.BPELService;

/**
 * Created by liuwenping on 2020/1/2.
 */
public class BPELServiceImpl extends AbstractMicroService implements BPELService {

    @Override
    public String getServiceName() {
        return "BPELService";
    }


}
