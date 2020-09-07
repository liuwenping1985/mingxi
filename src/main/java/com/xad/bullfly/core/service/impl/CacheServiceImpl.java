package com.xad.bullfly.core.service.impl;

import com.xad.bullfly.core.common.service.AbstractMicroService;
import com.xad.bullfly.core.service.CacheService;

/**
 * Created by liuwenping on 2020/1/2.
 */
public class CacheServiceImpl extends AbstractMicroService implements CacheService {

    @Override
    public String getServiceName() {
        return "cacheService";
    }


}
