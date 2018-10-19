package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;

import java.util.Map;

/**
 * Created by liuwenping on 2018/10/17.
 */
public interface DataParser {

    public KingDeeBill parse(Map data, FormTableDefinition ftd);
    public KingDeeBill parse(KingDeeBill bill,Map data,FormTableDefinition ftd);
}
