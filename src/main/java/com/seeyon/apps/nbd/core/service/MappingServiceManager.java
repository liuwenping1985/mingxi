package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;

import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public interface MappingServiceManager {

    FormTableDefinition parseFormTableMapping(Map data);
}
