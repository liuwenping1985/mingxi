package com.seeyon.apps.nbd.core.service.impl;

import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.CustomExportProcess;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.A8ToOtherConfigEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.ctp.common.po.affair.CtpAffair;

import java.util.Map;

/**
 * Created by liuwenping on 2018/12/10.
 */
public class RuianExportProcessor implements CustomExportProcess {

    private NbdService nbdService = new NbdService();

    public void process(A8ToOtherConfigEntity entity, Map data) {

        System.out.println("hahahahahahhahahaha");

        System.out.println(data);
        System.out.println("hahahahahahhahahaha");
    }

    public void process(String code,CtpAffair affair) {
        Long formRecordId = affair.getFormRecordid();
        CommonParameter cp = new CommonParameter();
        cp.$("affairType",code);
        NbdResponseEntity<FormTableDefinition> entity = nbdService.getFormByTemplateNumber(cp);
        FormTableDefinition ftd = entity.getData();
        try {
            Map data = nbdService.exportMasterData(formRecordId,ftd,false);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
