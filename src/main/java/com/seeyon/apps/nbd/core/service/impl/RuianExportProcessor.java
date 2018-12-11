package com.seeyon.apps.nbd.core.service.impl;

import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.CustomExportProcess;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.A8ToOtherConfigEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.JDBCAgent;

import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/12/10.
 */
public class RuianExportProcessor implements CustomExportProcess {

    private NbdService nbdService = new NbdService();

    public void process(A8ToOtherConfigEntity entity, Map data) {

        System.out.println("hahahahahahhahahaha");
        /**
         {formson_0192=[{field0053=null, field0010=222, field0054=null, field0033=www, field0034=wwww, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=12, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www, field0004=12, field0048=22, field0027=222, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}, {field0053=null, field0010=222, field0054=null, field0033=www2, field0034=wwww2, field0012=台, field0078=null, field0058=null, field0037=null, field0059=null, field0015=7381342570116367323, field0016=111, field0038=null, field0073=null, field0052=5337726562289205631, field0074=null, field0028=5851978446896057667, count_field0013=10, field0007=2018-12-11 00:00:00.0, field0008=2018-12-11 00:00:00.0, field0020=2403214902934651590, field0065=null, field0021=6149007273124318565, field0022=6420576744594883243, field0044=-4377052000397996273, field0066=null, field0143=-8377145192776315705, field0045=3441550207905320327, field0067=null, field0046=222, field0003=www2, field0004=12, field0048=22, field0027=222单点, field0049=-4377052000397996273, field0060=null, field0061=null, field0062=null, field0017=1222794058783999117, field0018=2222, field0019=-5220475304581052791}], ratifyflag=0, field0001=2403214902934651590, field0023=DJ20181211005, ratify_member_id=0, start_member_id=7239435747909386284, approve_member_id=7239435747909386284, finishedflag=1, field0029=7239435747909386284, state=1, approve_date=2018-12-11 18:48:34.734, ratify_date=null, start_date=2018-12-11 18:48:18.0}



         * */
        String tb = ConfigService.getPropertyByName("affair_type_export_table","");
        if(CommonUtils.isEmpty(tb)){
            return;
        }
        System.out.println(data);

        FormTableDefinition ftd = entity.getFtd();
        FormTable ft = ftd.getFormTable();
        List<FormTable> slaveTable = ft.getSlaveTableList();
        //DataBaseHelper.e
        JDBCAgent agent = new JDBCAgent();





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
