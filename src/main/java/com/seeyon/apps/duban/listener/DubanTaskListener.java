package com.seeyon.apps.duban.listener;

import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.mapping.MappingService;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.CommonServiceTrigger;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.apache.log4j.Logger;

import java.util.List;
import java.util.Map;

/**
 * 主要的流转逻辑
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskListener {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskListener.class);

    private ColManager colManager;

    public ColManager getColManager() {
        if (colManager == null) {
            colManager = (ColManager) AppContext.getBean("colManager");
        }
        return colManager;
    }

    /**
     * 结束
     *
     * @param event
     */
    @ListenEvent(event = CollaborationFinishEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event) {
        Long summaryId = event.getSummaryId();
        System.out.println();
        if (CommonServiceTrigger.needProcess(summaryId)) {
            //往台账表插入数据
            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK_AFFIRM);
            try {
                ColSummary colSummary = this.getColManager().getSummaryById(summaryId);
                if (colSummary == null) {
                    Long id = colSummary.getFormRecordid();
                    String sql = ftd.genQueryById(id);
                    Map data = DataBaseUtils.querySingleDataBySQL(sql);
                    DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class,data,ftd);
                    task.setNewId();
                    DBAgent.save(task);
                    //查出了表单的数据
                }

            } catch (BusinessException e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * 开始
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStartEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStart(CollaborationStartEvent event) {
//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStart");
//
//        }


    }

    /**
     * 取消
     *
     * @param event
     */
    @ListenEvent(event = CollaborationCancelEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onCancel(CollaborationCancelEvent event) {
//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onCancel");
//
//        }


    }

    /**
     * 取回
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStepBackEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStepBack(CollaborationStepBackEvent event) {

//        Long summaryId = event.getSummaryId();
//        Long affairId = (Long)event.getSource();
//        try {
//            CtpAffair affair = colManager.getAffairById(affairId);
//
//           String sql="insert into ctp_hd(id,affairId) values(\'"+ UUIDLong.longUUID()+"\',"+affair.getId()+")";
//        } catch (BusinessException e) {
//            e.printStackTrace();
//        }
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStepBack");
//
//        }
    }

    /**
     * 终止
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStopEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStop(CollaborationStopEvent event) {


//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStop");
//
//        }
    }

    /**
     * 处理
     *
     * @param event
     */
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {
//        Long summaryId = event.getSummaryId();
//
//
//        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where state=3 and objectId="+summaryId);
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onProcess");
//
//        }

    }

}
