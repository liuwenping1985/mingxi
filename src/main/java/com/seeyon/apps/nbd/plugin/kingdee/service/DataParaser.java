package com.seeyon.apps.nbd.plugin.kingdee.service;

import com.seeyon.apps.nbd.plugin.kingdee.vo.KingDeeBill;

import java.util.Map;

/**
 * Created by liuwenping on 2018/10/17.
 */
public interface DataParaser {

    public KingDeeBill parse(Map data);
    public KingDeeBill parse(KingDeeBill bill,Map data);
}
