package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.po.A8ToOtherConfigEntity;
import com.seeyon.ctp.common.po.affair.CtpAffair;

import java.util.Map;

/**
 * Created by liuwenping on 2018/12/10.
 */
public interface CustomExportProcess {

    void process(A8ToOtherConfigEntity entity, Map data);
    void process(String code, CtpAffair affair);
}
