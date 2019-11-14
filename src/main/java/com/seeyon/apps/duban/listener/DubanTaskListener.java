package com.seeyon.apps.duban.listener;

import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.duban.service.CommonServiceTrigger;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.apache.log4j.Logger;

/**
 * 主要的流转逻辑
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskListener {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskListener.class);
    /**
     * 结束
     * @param event
     */
    @ListenEvent(event = CollaborationFinishEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event){
        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onFinish");

        }

    }

    /**
     * 开始
     * @param event
     */
    @ListenEvent(event = CollaborationStartEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onStart(CollaborationStartEvent event){
        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onStart");

        }


    }

    /**
     * 取消
     * @param event
     */
    @ListenEvent(event = CollaborationCancelEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onCancel(CollaborationCancelEvent event){
        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onCancel");

        }


    }

    /**
     * 取回
     * @param event
     */
    @ListenEvent(event = CollaborationStepBackEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onStepBack(CollaborationStepBackEvent event){

        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onStepBack");

        }
    }

    /**
     * 终止
     * @param event
     */
    @ListenEvent(event = CollaborationStopEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onStop(CollaborationStopEvent event){


        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onStop");

        }
    }

    /**
     * 处理
     * @param event
     */
    @ListenEvent(event = CollaborationProcessEvent.class,async = true,mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event){
        Long summaryId = event.getSummaryId();

        if(CommonServiceTrigger.needProcess(summaryId)){
            LOGGER.info("need process onProcess");

        }

    }

}
