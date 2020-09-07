package com.xad.bullfly.core.service.impl;

import com.xad.bullfly.core.common.service.AbstractMicroService;
import com.xad.bullfly.core.service.DataAdapterService;

/**
 * Created by liuwenping on 2020/1/2.
 */
public class DataFlowServiceImpl extends AbstractMicroService implements DataAdapterService {

    @Override
    public String getServiceName() {
        return "dataFlowService";
    }

}
