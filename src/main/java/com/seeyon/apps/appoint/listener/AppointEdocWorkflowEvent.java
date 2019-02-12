package com.seeyon.apps.appoint.listener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.appoint.manager.AppointEdocManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.workflow.event.AbstractWorkflowEvent;
import com.seeyon.ctp.workflow.event.WorkflowEventData;
import com.seeyon.ctp.workflow.event.WorkflowEventResult;
import com.seeyon.v3x.edoc.domain.EdocSummary;

public class AppointEdocWorkflowEvent extends AbstractWorkflowEvent {
	private static final Log log = LogFactory.getLog(AppointEdocWorkflowEvent.class);
	private AppointEdocManager appointEdocManager;
	

    public void setAppointEdocManager(AppointEdocManager appointEdocManager) {
		this.appointEdocManager = appointEdocManager;
	}

	/**
     * 唯一标示，一旦生成，不可变更
     * @return
     */
    public String getId() {
		return this.getClass().getSimpleName();
	}
    
    /**
     * 事件显示名称
     * @return
     */
    public String getLabel() {
		return "任免公文监听";
	}
    
    /**
     * 返回指定的模版编号
     * @return
     */
    public String getTemplateCode(){return "";};
    
    //发起前事件
    public WorkflowEventResult onBeforeStart(WorkflowEventData data){return null;}
    //发起事件
    public void onStart(WorkflowEventData data){
    	log.info("发起事件=="+JSONObject.toJSONString(data));
    }
    
    //处理前事件
    public WorkflowEventResult onBeforeFinishWorkitem(WorkflowEventData data){return null;}
    //处理事件
    public void onFinishWorkitem(WorkflowEventData data){
    	log.info("处理事件=="+JSONObject.toJSONString(data));
    	final EdocSummary summary = (EdocSummary) data.getSummaryObj();
    	try {
			Thread th = new Thread(new Runnable() {
				@Override
				public void run() {
					AppointEdocManager appointEdocManager  = (AppointEdocManager) AppContext.getBean("appointEdocManager");
					appointEdocManager.push(summary);
					log.info("==推送完成==");
				}
			});
			th.start();
		} catch (Exception e) {
			log.error("",e);
		}
    }
    
    //终止前事件
    public WorkflowEventResult onBeforeStop(WorkflowEventData data){return null;}
    //终止事件
    public void onStop(WorkflowEventData data){
    	log.info("终止事件=="+JSONObject.toJSONString(data));
    }
    
    //回退前事件
    public WorkflowEventResult onBeforeStepBack(WorkflowEventData data){return null;}
    //回退事件
    public void onStepBack(WorkflowEventData data){
    	log.info("回退事件=="+JSONObject.toJSONString(data));
    }
    
    //撤销前事件
    public WorkflowEventResult onBeforeCancel(WorkflowEventData data){return null;}
    //撤销事件
    public void onCancel(WorkflowEventData data){
    	log.info("撤销事件=="+JSONObject.toJSONString(data));
    }
    
    //取回前事件
    public WorkflowEventResult onBeforeTakeBack(WorkflowEventData data){return null;}
    //取回事件
    public void onTakeBack(WorkflowEventData data){
    	log.info("取回事件=="+JSONObject.toJSONString(data));
    }
    
    //结束事件
    public void onProcessFinished(WorkflowEventData data){
    	log.info("结束事件=="+JSONObject.toJSONString(data));
    	final EdocSummary summary = (EdocSummary) data.getSummaryObj();
    	try {
			Thread th = new Thread(new Runnable() {
				@Override
				public void run() {
					AppointEdocManager appointEdocManager  = (AppointEdocManager) AppContext.getBean("appointEdocManager");
					appointEdocManager.push(summary);
					log.info("==推送完成==");
				}
			});
			th.start();
		} catch (Exception e) {
			log.error("",e);
		}
    	
    }

}
