package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.vo.CommonParameter;

import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public interface MappingServiceManager {

    FormTableDefinition parseFormTableMapping(Map data);
    public FormTableDefinition saveFormTableDefinition(CommonParameter p);
    public FormTableDefinition deleteFormTableDefinition(CommonParameter p);
    public FormTableDefinition getFormTableDefinition(CommonParameter p);
    public FormTableDefinition updateFormTableDefinition(CommonParameter p);
}
