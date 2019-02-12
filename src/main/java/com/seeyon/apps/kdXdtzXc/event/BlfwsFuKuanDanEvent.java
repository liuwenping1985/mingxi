package com.seeyon.apps.kdXdtzXc.event;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
//import com.seeyon.apps.kdXdtzXc.manager.BlfFuKuanDanManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.workflow.event.AbstractWorkflowEvent;
import com.seeyon.ctp.workflow.event.WorkflowEventData;
import com.seeyon.ctp.workflow.event.WorkflowEventResult;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class BlfwsFuKuanDanEvent extends AbstractWorkflowEvent {


    private static final Log log = LogFactory.getLog(BlfwsFuKuanDanEvent.class);

    @Override
    public String getId() {
        // TODO Auto-generated method stub
        return "blf_fkd_ws_event";
    }

    @Override
    public String getLabel() {
        // TODO Auto-generated method stub
        return "付款单NC接口发送";
    }

    @Override
    public WorkflowEventResult onBeforeCancel(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeCancel");
        return super.onBeforeCancel(data);
    }

    @Override
    public WorkflowEventResult onBeforeFinishWorkitem(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeFinishWorkitem");
        return super.onBeforeFinishWorkitem(data);
    }

    @Override
    public WorkflowEventResult onBeforeStart(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeStart");
        return super.onBeforeStart(data);
    }

    @Override
    public WorkflowEventResult onBeforeStepBack(WorkflowEventData event) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeStepBack");

        return super.onBeforeStepBack(event);
    }

    @Override
    public WorkflowEventResult onBeforeStop(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeStop");
        return super.onBeforeStop(data);
    }

    @Override
    public WorkflowEventResult onBeforeTakeBack(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onBeforeTakeBack");
        return super.onBeforeTakeBack(data);
    }

    @Override
    public void onCancel(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onCancel");
        super.onCancel(data);
    }

    @Override
    public void onFinishWorkitem(WorkflowEventData event) {
//        super.onFinishWorkitem(event);
//        ColSummary colSummary = (ColSummary) event.getSummaryObj();
//        Long formrecid = colSummary.getFormRecordid();
//        BlfFuKuanDanManager blfFuKuanDanManager = (BlfFuKuanDanManager) AppContext.getBean("blfFuKuanDanManager");
//        if (StringUtilsExt.isNullOrNone(formrecid)) {
//            throw new RuntimeException("无法获取付款单表单ID！");
//        }
//        try {
//            blfFuKuanDanManager.updateBlfFuKuanDanDetail(null, formrecid);
//        } catch (Exception e) {
//            e.printStackTrace();
//            throw new RuntimeException("发送付款单数据到NC出错！", e);
//        }


    }

    @Override
    public void onProcessFinished(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onProcessFinished");
        super.onProcessFinished(data);
    }

    @Override
    public void onStart(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onStart");
        super.onStart(data);
    }

    @Override
    public void onStepBack(WorkflowEventData event) {
        // TODO Auto-generated method stub

        System.out.println("onStart");
        super.onStepBack(event);


    }

    @Override
    public void onStop(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onStop");
        super.onStop(data);
    }

    @Override
    public void onTakeBack(WorkflowEventData data) {
        // TODO Auto-generated method stub
        System.out.println("onTakeBack");
        super.onTakeBack(data);
    }


}
