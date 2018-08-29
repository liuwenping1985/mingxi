package com.seeyon.apps.nbd.platform.oa;

import com.seeyon.apps.nbd.core.entity.Entity;

import java.util.Map;

/**
 * Created by liuwenping on 2018/8/23.
 */
public interface SubEntityFieldParser {


    public void parse(Map dataMap,Map inputDataMap, Entity entity);
}
