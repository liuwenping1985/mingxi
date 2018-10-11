package com.seeyon.apps.nbd.platform.oa;

import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.v3x.services.flow.FlowUtil;
import org.apache.commons.lang.StringUtils;


import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class ProcessEventHandler {


    private ColManager colManager;

    private AffairManager affairManager;

    private OrgManager orgManager;

    public ColManager getColManager() {
        if(this.colManager == null) {
            this.colManager = (ColManager) AppContext.getBean("colManager");
        }

        return this.colManager;
    }
    public AffairManager getAffairManager() {
        if(this.affairManager == null) {
            this.affairManager = (AffairManager)AppContext.getBean("affairManager");
        }

        return this.affairManager;
    }
    public OrgManager getOrgManager() {
        if(this.orgManager == null) {
            this.orgManager = (OrgManager)AppContext.getBean("orgManager");
        }

        return this.orgManager;
    }
  //  private ServiceForwardHandler handler = new ServiceForwardHandler();

    @ListenEvent(event = CollaborationFinishEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event) {
        Long affairId = event.getAffairId();
        try {
            CtpAffair ctpAffair = this.getAffairManager().get(affairId);
        } catch (BusinessException e) {
            e.printStackTrace();
        }

    }
    @ListenEvent(event = CollaborationStepBackEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onStepBack(CollaborationStepBackEvent event) {
         Long summaryId = event.getSummaryId();

//        Long affairId = event.is
//        CtpAffair ctpAffair = this.getAffairManager().get(affairId);
//
//        processEvent(summaryId,ctpAffair);
//
      System.out.println("-----onStepBack----");

       // processDoneEvent(summaryId,"回退",FlowUtil.FlowState.back.getKey());

    }
    @ListenEvent(event = CollaborationCancelEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onCancel(CollaborationCancelEvent event) {
        Long summaryId = event.getSummaryId();

//        Long affairId = event.is
//        CtpAffair ctpAffair = this.getAffairManager().get(affairId);
//
//        processEvent(summaryId,ctpAffair);
//
        System.out.println("-----onCancel----");

      //  processDoneEvent(summaryId,"取消",FlowUtil.FlowState.cancle.getKey());

    }
//    @ListenEvent(event = CollaborationTakeBackEvent.class,async = true,mode = EventTriggerMode.afterCommit)
//    public void onTakeBack(CollaborationTakeBackEvent event) {
//        Long summaryId = event.getSummaryId();
//
//        System.out.println("-----onTakeBack----");
//        processDoneEvent(summaryId,"取回",FlowUtil.FlowState.tackBack.getKey());
////        Long affairId = event
////        CtpAffair ctpAffair = this.getAffairManager().get(affairId);
////
////        processNormalEvent(summaryId,ctpAffair);
////
////        System.out.println("-----TEST2----");
//
//
//
//    }
    @ListenEvent(event = CollaborationStopEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onStop(CollaborationStopEvent event) {
        Long summaryId = event.getSummaryId();
        System.out.println("-----onStop----");
       // processDoneEvent(summaryId,"停止",FlowUtil.FlowState.teminal.getKey());

    }

    private void processDoneEvent(Long summaryId,String msg,int state){
        if(!needProcess(summaryId)){
            return;
        }
        ColSummary summary;
        try {
            summary = this.getColManager().getColSummaryById(summaryId);
            //int state = FlowUtil.getFlowState(this.getAffairManager(), summary);
            String operator="";
            String forwardMember = summary.getForwardMember();
            if(!StringUtils.isEmpty(forwardMember)){
                operator=this.getOrgManager().getMemberById(Long.valueOf(forwardMember)).getLoginName();
            }

            //summary.setState(state);
            //getColManager().updateColSummary(summary);
               // String operator =  this.getOrgManager().getMemberById(ctpAffair.getMemberId()).getLoginName();
            postData(summaryId,state, operator,msg);

        } catch (Exception e) {
            e.printStackTrace();
        }

        //int state = FlowUtil.getFlowState(this.getAffairManager(), summary);
    }

    private void processNormalEvent(Long summaryId,CtpAffair ctpAffair){
        if(!needProcess(summaryId)){
            return;
        }
        ColSummary summary;
        try {
            // String key = affairType+"$"+parameter.get("affair_id");

            summary = this.getColManager().getColSummaryById(summaryId);
            int state = FlowUtil.getFlowState(this.getAffairManager(), summary);
            if(state ==  FlowUtil.FlowState.cancle.getKey()){
                //回调
                String operator =  this.getOrgManager().getMemberById(ctpAffair.getMemberId()).getLoginName();
                postData(summaryId,state, operator,"取消");
            }
            if(state == FlowUtil.FlowState.back.getKey()){
                //回退
                String operator =  this.getOrgManager().getMemberById(ctpAffair.getMemberId()).getLoginName();
                postData(summaryId,state, operator,"回退");
            }
            if(state == FlowUtil.FlowState.tackBack.getKey()){
                //回退
                String operator =  this.getOrgManager().getMemberById(ctpAffair.getMemberId()).getLoginName();
                postData(summaryId,state, operator,"取回");
            }
            if(state == FlowUtil.FlowState.teminal.getKey()){
                //终止
                String operator =  this.getOrgManager().getMemberById(ctpAffair.getMemberId()).getLoginName();
                postData(summaryId,state, operator,"终止");
            }

        } catch (BusinessException var6) {
            var6.printStackTrace();
        }
    }

    @ListenEvent(event = CollaborationProcessEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {
        Long summaryId = event.getSummaryId();
       // CtpAffair ctpAffair =  event.getAffair();
       // processNormalEvent(summaryId,ctpAffair);
        System.out.println("-----TEST3----");



    }

    private boolean needProcess(Long summaryId){

        Object obj =  DataBaseHandler.getInstance().getDataByKey("flow"+summaryId);
        System.out.println("Object--->"+obj);
        if(obj!=null){
            return true;
        }
        return false;

    }

    private void postData(Long summaryId,int state,String operator,String currentState){
        String key_affairType =  (String)DataBaseHandler.getInstance().getDataByKey("flow"+summaryId);
        String[] keys = key_affairType.split("_");
        String affairType = keys[0];
        String affair_id = keys[1];
        Map dataParam = new HashMap();
        dataParam.put("affair_id",affair_id);
        dataParam.put("id",summaryId);
        dataParam.put("affairType",affairType);
        dataParam.put("state",state);
        dataParam.put("currentState",currentState);
        dataParam.put("operator",operator);
        dataParam.put("note","");
        dataParam.put("data","{}");

//        affair_id：外部数据id
//        id：OA数据id
//        affairType：事务类型
//        state：审核状态
//        currentState：退回时状态
//        operator：操作人（用户名）
//        note：审核说明
//        data：其他补充数据

        String url = ConfigService.getPropertyByName("callback.uri","");
        try {
            System.out.println(url);
            System.out.println(dataParam);
            Map res = UIUtils.post(url,dataParam);
            System.out.println(res);
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}
