package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.entity.FormTableDefinition;
import com.seeyon.apps.datakit.po.Ftd;
import com.seeyon.apps.datakit.vo.CommonParameter;

import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public interface MappingServiceManager {

    FormTableDefinition parseFormTableMapping(Map data);
    public Ftd saveFormTableDefinition(CommonParameter p);
    public Ftd deleteFormTableDefinition(CommonParameter p);
    public Ftd getFormTableDefinition(CommonParameter p);
    public Ftd updateFormTableDefinition(CommonParameter p);
}
