package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.Ftd;

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
