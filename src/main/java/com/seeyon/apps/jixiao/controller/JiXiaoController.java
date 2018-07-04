package com.seeyon.apps.jixiao.controller;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.springframework.util.CollectionUtils;

import java.util.List;

public class JiXiaoController extends BaseController {


    @ListenEvent(event= CollaborationFinishEvent.class,mode=EventTriggerMode.immediately,async = true)
    public void syncJiXiao(CollaborationFinishEvent event){
        System.out.println("----------SYNC JIXIAO-------------");
       /* field0022 */
        Long affairId = event.getAffairId();
        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where id = "+affairId);
        if(!CollectionUtils.isEmpty(affairList)){
            CtpAffair affair = affairList.get(0);
        }

    }
}
