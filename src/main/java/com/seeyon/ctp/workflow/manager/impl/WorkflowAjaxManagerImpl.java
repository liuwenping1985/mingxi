/**
 * Author: wangchw
 * Rev:WorkflowAjaxManagerImpl.java
 * Date: 20122012-9-18上午09:57:39
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
*/
package com.seeyon.ctp.workflow.manager.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMActor;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.definition.BPMSeeyonPolicy;
import net.joinwork.bpm.definition.BPMTransition;
import net.joinwork.bpm.definition.ObjectName;
import net.joinwork.bpm.engine.execute.BPMCase;
import net.joinwork.bpm.engine.wapi.CaseDetailLog;
import net.joinwork.bpm.engine.wapi.CaseInfo;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;
import net.joinwork.bpm.engine.wapi.WorkItem;
import net.joinwork.bpm.engine.wapi.WorkItemManager;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import net.joinwork.bpm.task.BPMWorkItemList;
import net.joinwork.bpm.task.WorkitemInfo;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairData;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.formula.manager.FormulaManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.formula.Formula;
import com.seeyon.ctp.common.po.processlog.ProcessLog;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.template.vo.CtpTemplateVO;
import com.seeyon.ctp.organization.OrgConstants.ORGENT_TYPE;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowDesignerManager;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowHastenManager;
import com.seeyon.ctp.workflow.engine.enums.ProcessStateEnum;
import com.seeyon.ctp.workflow.engine.listener.ActionRunner;
import com.seeyon.ctp.workflow.event.BPMEvent;
import com.seeyon.ctp.workflow.event.EventDataContext;
import com.seeyon.ctp.workflow.event.WorkflowEventExecute;
import com.seeyon.ctp.workflow.event.WorkflowEventManager;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.exception.NoSuchWorkitemException;
import com.seeyon.ctp.workflow.manager.CaseManager;
import com.seeyon.ctp.workflow.manager.ProcessManager;
import com.seeyon.ctp.workflow.manager.ProcessOrgManager;
import com.seeyon.ctp.workflow.manager.ProcessTemplateManager;
import com.seeyon.ctp.workflow.manager.SubProcessManager;
import com.seeyon.ctp.workflow.manager.WorkFlowAppExtendInvokeManager;
import com.seeyon.ctp.workflow.manager.WorkFlowMatchUserManager;
import com.seeyon.ctp.workflow.manager.WorkFlowReplaceNodeManager;
import com.seeyon.ctp.workflow.manager.WorkflowAjaxManager;
import com.seeyon.ctp.workflow.manager.WorkflowFormDataMapInvokeManager;
import com.seeyon.ctp.workflow.po.HistoryCaseRunDAO;
import com.seeyon.ctp.workflow.po.ProcessTemplete;
import com.seeyon.ctp.workflow.po.SubProcessRunning;
import com.seeyon.ctp.workflow.po.SubProcessSetting;
import com.seeyon.ctp.workflow.po.WorkitemDAO;
import com.seeyon.ctp.workflow.util.BranchArgs;
import com.seeyon.ctp.workflow.util.CalculateProcessNodePosition;
import com.seeyon.ctp.workflow.util.WorkFlowFinal;
import com.seeyon.ctp.workflow.util.WorkFlowNodeReplaceUtil;
import com.seeyon.ctp.workflow.util.WorkflowUtil;
import com.seeyon.ctp.workflow.util.condition.Expression;
import com.seeyon.ctp.workflow.util.condition.ExpressionFactory;
import com.seeyon.ctp.workflow.vo.CPMatchResultVO;
import com.seeyon.ctp.workflow.vo.FlashProcessNodePositionVO;
import com.seeyon.ctp.workflow.vo.WorkflowFormFieldVO;
import com.seeyon.ctp.workflow.vo.WorkflowReplaceVO;
import com.seeyon.ctp.workflow.wapi.WorkFlowAppExtendManager;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import com.seeyon.v3x.common.web.login.CurrentUser;

import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMActor;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.definition.BPMSeeyonPolicy;
import net.joinwork.bpm.definition.BPMTransition;
import net.joinwork.bpm.definition.ObjectName;
import net.joinwork.bpm.engine.execute.BPMCase;
import net.joinwork.bpm.engine.wapi.CaseDetailLog;
import net.joinwork.bpm.engine.wapi.CaseInfo;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;
import net.joinwork.bpm.engine.wapi.WorkItem;
import net.joinwork.bpm.engine.wapi.WorkItemManager;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import net.joinwork.bpm.task.BPMWorkItemList;
import net.joinwork.bpm.task.WorkitemInfo;

/**
 * <p>Title: T4工作流</p>
 * <p>Description: 工作流ajax实现类</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * <p>Author: wangchw</p>
 * @since CTP2.0
*/
public class WorkflowAjaxManagerImpl implements WorkflowAjaxManager {

    /**
     * 日志记录
     */
    private final static Log       logger = LogFactory.getLog(WorkflowAjaxManagerImpl.class);

    private SubProcessManager     subProcessManager;

    private WorkFlowHastenManager workFlowHastenManager;

    private ProcessManager        processManager;

    private CaseManager           caseManager;

    private WorkflowApiManager    workflowApiManager;

    private ProcessOrgManager     processOrgManager;

    private ProcessLogManager     processLogManager;

    private BPMWorkItemList       itemlist;

    private WorkItemManager       workItemManager;
    
    private EnumManager           enumManagerNew;
    
    private AppLogManager appLogManager;
    
    private PermissionManager      permissionManager      = null;
    
    private WorkFlowMatchUserManager workFlowMatchUserManager;
    
    public PermissionManager getPermissionManager() {
        return permissionManager;
    }

    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }
    
    public AppLogManager getAppLogManager() {
        return appLogManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    private WorkFlowDesignerManager workFlowDesignerManager;
        
    private WorkFlowReplaceNodeManager workFlowReplaceNodeManager;
    
    private OrgManagerDirect orgManagerDirect;
    
    private TemplateManager templateManager;
    
    public TemplateManager getTemplateManager() {
        return templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public OrgManagerDirect getOrgManagerDirect() {
		return orgManagerDirect;
	}

	public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
		this.orgManagerDirect = orgManagerDirect;
	}

	public WorkFlowReplaceNodeManager getWorkFlowReplaceNodeManager() {
		return workFlowReplaceNodeManager;
	}

	public void setWorkFlowReplaceNodeManager(
			WorkFlowReplaceNodeManager workFlowReplaceNodeManager) {
		this.workFlowReplaceNodeManager = workFlowReplaceNodeManager;
	}

    public WorkFlowDesignerManager getWorkFlowDesignerManager() {
        return workFlowDesignerManager;
    }

    public void setWorkFlowDesignerManager(WorkFlowDesignerManager workFlowDesignerManager) {
        this.workFlowDesignerManager = workFlowDesignerManager;
    }

    public EnumManager getEnumManagerNew() {
        return enumManagerNew;
    }

    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

    /**
     * @param workItemManager the workItemManager to set
     */
    public void setWorkItemManager(WorkItemManager workItemManager) {
        this.workItemManager = workItemManager;
    }

    /**
     * @param itemlist the itemlist to set
     */
    public void setItemlist(BPMWorkItemList itemlist) {
        this.itemlist = itemlist;
    }

    /**
     * @return the processLogManager
     */
    public ProcessLogManager getProcessLogManager() {
        return processLogManager;
    }

    /**
     * @param processLogManager the processLogManager to set
     */
    public void setProcessLogManager(ProcessLogManager processLogManager) {
        this.processLogManager = processLogManager;
    }

    /**
     * @return the processOrgManager
     */
    public ProcessOrgManager getProcessOrgManager() {
        return processOrgManager;
    }

    /**
     * @param processOrgManager the processOrgManager to set
     */
    public void setProcessOrgManager(ProcessOrgManager processOrgManager) {
        this.processOrgManager = processOrgManager;
    }

    private ProcessTemplateManager processTemplateManager;
    
    @Override
    public boolean hasMainProcess(String templateId) throws BPMException {
        boolean hassMainProcess = false;
        if (templateId != null && !"".equals(templateId.trim())) {
            List<SubProcessSetting> subProcessList = subProcessManager
                    .getAllSubProcessSettingByNewflowTempleteId(templateId);
            if (subProcessList != null && subProcessList.size() > 0) {
                List<Long> mainTemplateIdList = new ArrayList<Long>(subProcessList.size());
                for(SubProcessSetting sub:subProcessList){
                    mainTemplateIdList.add(sub.getTempleteId());
                }
                //找到所有的主流程
                List<ProcessTemplete> mainTempleteList = processTemplateManager.selectProcessTemplateByIdList(mainTemplateIdList);
                //如果主流程是已发布然后被修改状态，找到对应的新流程
                List<ProcessTemplete> newTemplateList = processTemplateManager.selectProcessTemplateByOldIdList(mainTemplateIdList);
                if(mainTempleteList!=null && mainTempleteList.size()>0){
                    Map<Long, ProcessTemplete> mainMap = new HashMap<Long, ProcessTemplete>(mainTempleteList.size());
                    Map<Long, ProcessTemplete> newMap = new HashMap<Long, ProcessTemplete>();
                    //如果主流程是已发布然后被修改状态，找到对应的新流程，然后用散列表格式缓存
                    if(newTemplateList!=null && newTemplateList.size()>0){
                    	for(ProcessTemplete templete : newTemplateList){
                    		newMap.put(templete.getOldTemplateId(), templete);
                    	}
                    }
                    for(ProcessTemplete templete : mainTempleteList){
                    	//状态2表示待删除
                    	if(2==templete.getState()){
                    		continue;
                    	}
                    	//如果不存在对应的修改状态的流程，那么放入其中；如果存在，那么不放入
                    	if(newMap.get(templete.getId())==null){
                    		mainMap.put(templete.getId(), templete);
                    	}
                    }
                    //因为查出来的
                    if(mainMap.size()>0){
                    	hassMainProcess = true;
                    }
                }
            }
        }
        return hassMainProcess;
    }

    @Override
    public String[][] getMainProcessTitleList(List<String> templateIdList) throws BPMException {
        String[][] mainProcessTitle = new String[0][0];
        if(templateIdList!=null && templateIdList.size()>0){
            List<SubProcessSetting> subProcessList = subProcessManager
                    .getAllSubProcessSettingByNewflowTempleteIdList(templateIdList);
            //如果没有找到子流程绑定数据，那么这个传过来的id可能是个已发布然后又被修改的模板id，需要找到他的原模板Id。
            if (subProcessList == null || subProcessList.size() <= 0) {
            	List<Long> newIdList = new ArrayList<Long>();
            	for(String isString : templateIdList){
            		try{
            			newIdList.add(Long.parseLong(isString));
            		}catch(NumberFormatException e){}
            	}
            	List<ProcessTemplete> oldTemplateList = processTemplateManager.selectProcessTemplateByIdList(newIdList);
            	if(oldTemplateList!=null && oldTemplateList.size()>0){
            		List<String> oldIdStringList = new ArrayList<String>();
            		for(ProcessTemplete t : oldTemplateList){
            			if(t.getOldTemplateId()!=null){
            				oldIdStringList.add(t.getOldTemplateId().toString());
            			}
            		}
            		subProcessList = subProcessManager.getAllSubProcessSettingByNewflowTempleteIdList(oldIdStringList);
            	}
            }
            if (subProcessList != null && subProcessList.size() > 0) {
                List<Long> mainTemplateIdList = new ArrayList<Long>(subProcessList.size());
                for(SubProcessSetting sub:subProcessList){
                    mainTemplateIdList.add(sub.getTempleteId());
                }
                //找到所有的主流程
                List<ProcessTemplete> mainTempleteList = processTemplateManager.selectProcessTemplateByIdList(mainTemplateIdList);
                //如果主流程是已发布然后被修改状态，找到对应的新流程
                List<ProcessTemplete> newTemplateList = processTemplateManager.selectProcessTemplateByOldIdList(mainTemplateIdList);
                if(mainTempleteList!=null && mainTempleteList.size()>0){
                    Map<Long, ProcessTemplete> mainMap = new HashMap<Long, ProcessTemplete>(mainTempleteList.size());
                    Map<Long, ProcessTemplete> newMap = new HashMap<Long, ProcessTemplete>();
                    //如果主流程是已发布然后被修改状态，找到对应的新流程，然后用散列表格式缓存
                    if(newTemplateList!=null && newTemplateList.size()>0){
                    	for(ProcessTemplete templete : newTemplateList){
                    		newMap.put(templete.getOldTemplateId(), templete);
                    	}
                    }
                    for(ProcessTemplete templete : mainTempleteList){
                    	//状态2表示待删除
                    	if(2==templete.getState()){
                    		continue;
                    	}
                    	//如果不存在对应的修改状态的流程，那么放入其中；如果存在，那么不放入
                    	if(newMap.get(templete.getId())==null){
                    		mainMap.put(templete.getId(), templete);
                    	}
                    }
                    //因为查出来的
                    if(mainMap.size()>0){
	                    mainProcessTitle = new String[subProcessList.size()][2];
	                    int index = 0;
	                    //将主流程子流程和子流程的数据一一对应，构成一个二维数组，其中的一维数组第一个元素是子流程标题，第二个元素是主流程标题
	                    for(SubProcessSetting sub:subProcessList){
	                        ProcessTemplete templete = mainMap.get(sub.getTempleteId());
	                        if(templete!=null){
	                            mainProcessTitle[index][0] = sub.getSubject();
	                            mainProcessTitle[index][1] = templete.getProcessName();
	                            index++;
	                        }
	                    }
                    }
                }
            }
        }
        return mainProcessTitle;
    }

    @Override
    public boolean hasSubProcess(String templateId) throws BPMException {
        boolean hassSubProcess = false;
        if (templateId != null && !"".equals(templateId.trim())) {
            String ttId = templateId;
            try{
                List<Long> idList = new ArrayList<Long>(1);
                idList.add(Long.parseLong(ttId));
                List<ProcessTemplete> oldList = processTemplateManager.selectProcessTemplateByOldIdList(idList);
                if(oldList!=null && !oldList.isEmpty()){
                    ttId = oldList.get(0).getId().toString();
                }
            }catch(NumberFormatException e){
                logger.error(e);
            }
            List<SubProcessSetting> subProcessList = subProcessManager.getAllSubProcessSettingByTemplateId(ttId,
                    null);
            if (subProcessList != null && subProcessList.size() > 0) {
                hassSubProcess = true;
            }
        }
        return hassSubProcess;
    }

    @Override
    public boolean addMemberIdToCache(String activityId, String memberIds) {
        return workFlowHastenManager.addMemberIdToCache(activityId, memberIds);
    }

    @Override
    public String hasten(String processId, String activityId, String appName, List<String> personIds,
            String superviseId, String content, boolean sendPhoneMessage) {
        List<Long> personIdLong = new ArrayList<Long>();
        if (personIds != null) {
            for (String id : personIds) {
                try {
                    personIdLong.add(Long.parseLong(id));
                } catch (Exception e) {
                    logger.info("催办时，人员Id强制类型转换错误，将要被转换的id是：" + id);
                    logger.error(e);
                }
            }
        }
        DataContainer container = workFlowHastenManager.hasten(processId, activityId, appName, personIdLong,
                superviseId, content, sendPhoneMessage);
        return container.getJson();
    }

    public SubProcessManager getSubProcessManager() {
        return subProcessManager;
    }

    public void setSubProcessManager(SubProcessManager subProcessManager) {
        this.subProcessManager = subProcessManager;
    }

    public WorkFlowHastenManager getWorkFlowHastenManager() {
        return workFlowHastenManager;
    }

    public void setWorkFlowHastenManager(WorkFlowHastenManager workFlowHastenManager) {
        this.workFlowHastenManager = workFlowHastenManager;
    }

    @Override
    public boolean editWFCDiagram(String processId, String processXml) throws BPMException {
        if (processId != null && !processId.trim().equals("") && !processId.trim().equals("-1") && null != processXml
                && !"".equals(processXml.trim())) {//更新
            try {
                processManager.updateRunningProcessXml(processId, processXml);
            } catch (Throwable e) {
                throw new BPMException(e);
            }
        }
        return true;
    }

    @Override
    public String canTakeBack(String appName, String processId, String activityId, String workitemId)
            throws BPMException {
        DataContainer container = new DataContainer();
        //是否允许取回
        boolean canTakeBack = true;
        int state = 0;
        if (processId != null && workitemId != null && appName != null && !"".equals(processId.trim())
                && !"".equals(workitemId.trim()) && !"".equals(appName.trim())) {
            BPMProcess process = processManager.getRunningProcess(processId);
            WorkitemInfo workitem = itemlist.getWorkItemOrHistory(Long.parseLong(workitemId));
            if (process != null && workitem != null) {
                long caseId = workitem.getCaseId();
                activityId = workitem.getActivityId();
                //当前节点是否为知会节点
                BPMHumenActivity activity = (BPMHumenActivity) process.getActivityById(activityId);
                if (ObjectName.isInformObject(activity)) {
                    canTakeBack = false;
                    state = 5;//当前节点是知会节点
                }
                if(null==activity){
                	container.add("canTakeBack", false);
                	state= 5;
                    container.add("state", String.valueOf(state));
                    return container.getJson();
                }
                BPMSeeyonPolicy policy = activity.getSeeyonPolicy();
                String policyId = policy.getId();
                if (canTakeBack) {
                    if ("vouch".equals(policyId)) {
                        canTakeBack = false;
                        state = 6;//当前节点为核定节点
                    }
                }
//                if (canTakeBack) {
//                    if ("fengfa".equals(policyId)) {
//                        canTakeBack = false;
//                        state = 7;//当前节点为封发节点
//                    }
//                }
                if (canTakeBack) {
                    BPMCase theCase = caseManager.getCase(caseId);
                    if (theCase == null) {
                        canTakeBack = false;
                        state = 1;//流程已经结束
                    } else {
                        if (theCase instanceof HistoryCaseRunDAO) {
                            canTakeBack = false;
                            state = 1;//流程已经结束
                        }
                    }
                }
                List<BPMHumenActivity> childs = WorkflowUtil.getAllChildHumens(activity);
                List<WorkItem> childItems = null;
                if (canTakeBack) {
                    if (childs.size() != 0) {
                    	childItems = workItemManager.getWorItemListByStates(workitem.getCaseId(), childs,
                    			new Integer[]{WorkItem.STATE_FINISHED,WorkItem.STATE_SUSPENDED,WorkItem.STATE_NEEDREDO_TOME});
                    	if(null!=childItems && !childItems.isEmpty()){
                    		for (WorkItem workItem2 : childItems) {
								if(workItem2.getState()==WorkItem.STATE_FINISHED){
									canTakeBack = false;
		                            state = 2;//表示后面节点任务事项已处理完成
		                            break;
								}else{
									canTakeBack = false;
		                            state = 8;//表示后面节点任务事项已处理完成
		                            break;
								}
							}
                    	}
                    }
                }
                List<SubProcessRunning> subList = null;
                if (canTakeBack) {
                    if ("1".equals(policy.getNF())) {
                    	List<String> nodeIds = null;
                        subList= subProcessManager.getSubProcessRunningListByMainProcessId(processId, nodeIds);
                        if(null!=subList && !subList.isEmpty() ){
                        	for (SubProcessRunning subProcessRunning : subList) {
								if(subProcessRunning.getMainNodeId().equals(activityId) && subProcessRunning.getIsFinished()==1){
									canTakeBack = false;
		                            state = 3;//当前节点触发的子流程已经结束
		                            break;
								}
							}
                        }
                    }
                }
                if (canTakeBack) {//主流程中没有核定通过节点，还要判断当前节点的子流程中是否已核定通过
                    if ("1".equals(policy.getNF())) {
                        List<String> nodeIds = null;
                        if(null==subList){
                        	subList = subProcessManager.getSubProcessRunningListByMainProcessId(processId, nodeIds);
                        }
                        if (subList != null && subList.size() > 0) {
                            for (SubProcessRunning sub : subList) {
                            	if(sub.getMainNodeId().equals(activityId)){
	                                int vouch = workFlowHastenManager.getSummaryVouch(appName, sub.getSubProcessProcessId());
	                                if (vouch == 1) {
	                                    canTakeBack = false;
	                                    state = 4;//当前节点触发的子流程中已核定通过
	                                    break;
	                                } 
                            	}
                            }
                        }
                    }
                }
            } else {
                state = -1;
                logger.info("WorkFlow异常：判断是否允许取回时，根据指定的processId找不到指定BPMProcess，processId=" + processId);
            }
        } else {
            state = -1;
            logger.info("WorkFlow异常：判断是否允许取回时，指定的processId为null！");
        }
        container.add("canTakeBack", canTakeBack);
        container.add("state", String.valueOf(state));
        return container.getJson();
    }

    @Override
    public String[] canRepeal(String appName, String processId, String activityId) throws BPMException {
        //是否允许撤销
        boolean canRepeal = true;
        String msg= "";
        if (processId != null) {
            BPMProcess process = processManager.getRunningProcess(processId);
            if (process != null) {
                if (canRepeal) {//流程是否已经结束
                    List<? extends BPMCase> caseList = caseManager.getCaseByProcessId(processId);
                    if (caseList != null && caseList.size() > 0) {
                        BPMCase theCase = caseList.get(0);
                        if (theCase != null && theCase.isFinished()) {
                            canRepeal = false;
                            msg= ResourceUtil.getString("workflow.validate.repeal.msg0");//"该流程已结束，不能撤销！";
                        }
//                        int stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
//                        if(stepCount>0){//流程处于指定回退状态了，但当前任务事项不是被指定回退状态，不可继续指定回退
//                            canRepeal = false;
//                            msg= "当前流程处于指定回退状态,你不能进行此操作!";
//                        }
                    } else {
                    	canRepeal = false;
//                    	msg = "流程已经被删除或者撤销！";
                    	msg= ResourceUtil.getString("workflow.validate.repeal.msg5");
                    }
                }
                if (canRepeal) {//判断是否是核定节点
                    boolean isAdmin= CurrentUser.get().isGroupAdmin() || CurrentUser.get().isAdministrator();
                    if(!isAdmin){
                        int vouch = workFlowHastenManager.getSummaryVouch(appName, processId);
                        if (vouch == 1) {
                            msg= ResourceUtil.getString("workflow.validate.repeal.msg1");//"该流程已被核定，不能撤销！";
                            canRepeal = false;
                        }
                    }
                }
                if(canRepeal){
                    List<SubProcessRunning> allSubList= subProcessManager.getSubProcessRunningListByMainOrSubProcessId(processId, true, false);
                    if(null!=allSubList && !allSubList.isEmpty()){
                    	for (SubProcessRunning subProcessRunning : allSubList) {
							if(subProcessRunning.getSubProcessProcessId().equals(processId)){//当前流程为子流程
								msg= ResourceUtil.getString("workflow.validate.repeal.msg2");//"当前流程为新流程，不能撤销！";
		                        canRepeal = false;
		                        break;
							}
						}
                    	if(canRepeal){
                    		for (SubProcessRunning subProcessRunning : allSubList) {
                        		String aSubProcessId= subProcessRunning.getSubProcessProcessId();
								if(subProcessRunning.getIsFinished()==1){
	                                String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummarySubject(aSubProcessId);
	                                canRepeal= false;
	                                msg= ResourceUtil.getString("workflow.validate.repeal.msg3",subProcessSubject);//"该流程触发的新流程《"+subProcessSubject+"》已结束，不能回退！";
	                                break;
								}else{
									int vouch= WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummaryVouch(aSubProcessId);
                                    if(vouch==1){//核定通过了
                                        canRepeal= false;
                                        msg= ResourceUtil.getString("workflow.validate.repeal.msg4");//"该流程的子流程已核定通过，不能撤销！";
                                        break;
                                    }
								}
							}
                    	}
                    }
                }
            }else{
                logger.warn("查不到流程对象,processId:="+processId+";process为空！");
                throw new BPMException("cant`t find process ,processId:="+processId+";process is null!");
            }
        }
        String[] result= new String[2];
        result[0]= String.valueOf(canRepeal);
        result[1]= msg;
        return result;
    }

    @Override
    public long cloneWorkflowTemplateById(Long templateId, int state) throws BPMException {
        return workflowApiManager.cloneWorkflowTemplateById(templateId, state);
    }

    @Override
    public String validateFailReSelectPeople(String xml, List<Map<String, String>> importVOList) throws BPMException {
        //        return workflowApiManager.validateFailReSelectPeople(xml, importVOList);
        return "{}";
    }

    @Override
    public String templateExist(Long templateId) throws BPMException {
        boolean exist = false, templateIdIsNull = false;
        if (templateId != null) {
            ProcessTemplete templete = processTemplateManager.selectProcessTemplateById(templateId);
            if (templete != null && templete.getId().equals(templateId)) {
                exist = true;
            }
        } else {
            templateIdIsNull = true;
        }
        DataContainer container = new DataContainer();
        container.add("exist", exist);
        container.add("templateIdIsNull", templateIdIsNull);
        return container.getJson();
    }

    /**
     * @return the processManager
     */
    public ProcessManager getProcessManager() {
        return processManager;
    }

    /**
     * @param processManager the processManager to set
     */
    public void setProcessManager(ProcessManager processManager) {
        this.processManager = processManager;
    }

    public CaseManager getCaseManager() {
        return caseManager;
    }

    public void setCaseManager(CaseManager caseManager) {
        this.caseManager = caseManager;
    }

    public WorkflowApiManager getWorkflowApiManager() {
        return workflowApiManager;
    }

    public void setWorkflowApiManager(WorkflowApiManager workflowApiManager) {
        this.workflowApiManager = workflowApiManager;
    }

    @Override
    public String[] changeCaseProcess(String str, String[] idArr, String[] typeArr, String[] nameArr,
            String[] accountIdArr, String[] accountShortNameArr, String[] selecteNodeIdArr, String[] _peopleArr,
            String[] condition, String[] nodes, boolean iscol, String[] userExcludeChildDepartmentArr,
            String processXml, String orginalReadyObjectJson, String oldProcessLogJson,
            String defaultPolicyId,String defaultPolicyName) throws BPMException {
        User user = AppContext.getCurrentUser();
        if (user == null) {
            throw new BPMException("please login first!");//请先登录系统
        }
        String[] strArr = str.split(",");
        String processId = strArr[0];
        String activityId = strArr[1];
        String operationType = strArr[2];
        String flowType = strArr[3];
        String isShowShortName = strArr[4];
        String desc_by = strArr[5];
        String caseId = strArr[6];
        Map<String, Object> flowData = new HashMap<String, Object>();
        if (!"null".equals(desc_by) && !"null".equals(flowType)) {
            String _desc_by = "xml".equals(desc_by) ? "xml" : "people";
            flowData.put("desc_by", _desc_by);
            String[] types = typeArr;
            String[] ids = idArr;
            String[] names = nameArr;
            String[] accountIds = accountIdArr;
            String[] userExcludeChildDepartments = userExcludeChildDepartmentArr;
            String[] accountShortNames = accountShortNameArr;
            if (names == null && ids != null && types != null) {
                names = processOrgManager.getElementNames(ids, types);
            }
            List<Map<String, Object>> people = new ArrayList<Map<String, Object>>();
            if (ids != null) {
                for (int i = 0; i < ids.length; i++) {
                    String id = ids[i];
                    String type = processOrgManager.getUserTypeByField(types[i] + "");
                    String name = names[i];
                    String accountId = accountIds[i];
                    String accountShortName = accountShortNames[i];
                    boolean includeChild = true;
                    BPMSeeyonPolicy bpmSeeyonPolicy = null;
                    if (userExcludeChildDepartments != null && userExcludeChildDepartments.length > i
                            && userExcludeChildDepartments[i] != null && "true".equals(userExcludeChildDepartments[i])) {
                        includeChild = false;
                    }
                    if(Strings.isBlank(defaultPolicyId) || Strings.isBlank(defaultPolicyName)){
                        if (iscol) {
                            bpmSeeyonPolicy = new BPMSeeyonPolicy(BPMSeeyonPolicy.SEEYON_POLICY_COLLABORATE);
                        } else {
                            switch (Integer.parseInt(flowType)) {
                                case 0:
                                case 1:
                                case 2:
                                    bpmSeeyonPolicy = new BPMSeeyonPolicy(BPMSeeyonPolicy.EDOC_POLICY_SHENPI);
                                    break;
                                case 3:
                                    bpmSeeyonPolicy = new BPMSeeyonPolicy("huiqian", "会签");
                            }
                        }
                    }else{
                        bpmSeeyonPolicy = new BPMSeeyonPolicy(defaultPolicyId, defaultPolicyName);
                    }
                    Map<String, Object> party = new HashMap<String, Object>();
                    party.put("type", type);
                    party.put("id", id);
                    party.put("name", name);
                    party.put("accountId", accountId);
                    party.put("accountShortName", accountShortName);
                    party.put("includeChild", includeChild);
                    party.put("bpmSeeyonPolicy", bpmSeeyonPolicy);
                    people.add(party);
                }
            }
            flowData.put("people", people);
            flowData.put("type", Integer.parseInt(flowType) + 1);
            flowData.put("isShowShortName", isShowShortName);
        }
        if (nodes != null) {
            Map<String, String> map = new HashMap<String, String>();
            for (int i = 0; i < nodes.length; i++) {
                if (!"".equals(nodes[i]) && !"".equals(condition[i]))
                    map.put(nodes[i], condition[i]);
            }
            if (map.size() > 0) {
                flowData.put("condition", map);
            }
        }
        String[] xmlStr = new String[] {};
        boolean isForm = false;
        String userName= Functions.showMemberName(user.getId());
        xmlStr = processManager.superviseUpdateProcess(processId, activityId, Integer.parseInt(operationType),
                flowData, null, selecteNodeIdArr, _peopleArr, caseId, processXml, orginalReadyObjectJson, user.getId()
                        .toString(), userName, isForm, oldProcessLogJson, "",null);
        return xmlStr;
    }

    @Override
    public String[] saveModifyWorkflowData(String processId, String caseId, String appName, String processXml,
            String readyObjectJson, String processLogJson) throws BPMException {
        String[] result= new String[]{"true",""};
        String realAppName= appName;
        if(ApplicationCategoryEnum.edocRec.name().equals(appName)
                || ApplicationCategoryEnum.edocSend.name().equals(appName)
                || ApplicationCategoryEnum.edocSign.name().equals(appName)
                || "sendEdoc".equals(appName) 
                || "recEdoc".equals(appName)
                || "signReport".equals(appName)){//公文种类较多，兼容处理下
            appName= "edoc";
        }else if("form".equals(appName)){
            appName= "collaboration";
        }else if("sendInfo".equals(appName)){
            appName= "info";
        }
        //前端用户校验督办权限,判断是否有督办权限
        User user = AppContext.getCurrentUser();
        boolean hasSupervisorRight = true;
        WorkFlowAppExtendManager workFlowAppExtendManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
        try {
            hasSupervisorRight = workFlowAppExtendManager.checkUserSupervisorRight(caseId,
                    user.getId());
        } catch (Throwable e) {
            hasSupervisorRight= false;
            logger.error(e.getMessage(), e);
        }
        if (!hasSupervisorRight) {
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.supervisor.nothasright");
            return result;
        }
        //持久化修改后的流程
        if (processId != null && !"".equals(processId)) {
            BPMProcess process = null;
            if (null != processXml && !"".equals(processXml.trim()) && !"null".equals(processXml.trim())
                    && !"undefined".equals(processXml.trim())) {
                try {
                    process = BPMProcess.fromXML(processXml);
                } catch (Throwable e) {
                    logger.error(e.getMessage(), e);
                }
            }
            if (process != null) {
                BPMCase theCase = caseManager.getCase(Long.parseLong(caseId));
                //如果该流程实例存在待添加或待删除的节点，将其激活或撤销
                ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
                WorkflowBpmContext context = new WorkflowBpmContext();
                context.setReadyObjectJson(readyObjectJson);
                context.setProcessId(processId);
                context.setCaseId(Long.parseLong(caseId));
                context.setAppName(appName);
                context.setTheCase(theCase);
                context.setProcess(process);
                BPMActor startActor = (BPMActor) process.getStart().getActorList().get(0);
                context.setStartAccountId(startActor.getParty().getAccountId());
                context.setStartUserId(theCase.getStartUser());
                context.setCurrentUserId(user.getId()==null?"-1":String.valueOf(user.getId()));
                context.setCurrentAccountId(user.getLoginAccount()==null?"-1":String.valueOf(user.getLoginAccount()));
                AffairData affairData = null;
                try {
                    affairData = WorkFlowAppExtendInvokeManager.getAppManager(appName).getAffairData(processId);
                } catch (Throwable e) {
                    logger.error(e.getMessage(), e);
                }
                context.setBusinessData(EventDataContext.CTP_AFFAIR_DATA, affairData);
                context.setVersion("2.0");
                WorkflowUtil.putCaseToWorkflowBPMContext(theCase, context);
                context.setProcessChanged(true);
                engine.saveAcitivityModify(process, user.getId().toString(), context, theCase,true);
                WorkflowUtil.putWorkflowBPMContextToCase(context, theCase);
                caseManager.updateCase(theCase);
                if (theCase.isFinished()) {
                	processManager.updateRunningProcess(context.getProcess(), ProcessStateEnum.processState.finished.ordinal(),context.getTheCase());
                }else{
                	processManager.updateRunningProcess(process,theCase);
                }
                if(!context.getWillDeleteWorkItems().isEmpty()){//要删除的节点集合和要删除的事项集合
                    itemlist.cancelItems("", context);
                    ActionRunner.RunItemEvent(BPMEvent.WORKITEM_CANCELED, context,context.getWillDeleteWorkItems().get(0),context.getWillDeleteWorkItems());
                }
                if(!context.getEventDataContextList().isEmpty()){
                	if(Strings.isNotEmpty(context.getEventDataContextList())){
                		for(EventDataContext data :context.getEventDataContextList()){
                			data.setModifyWorkflowModel(true);
                		}
                	}
                	
                    ActionRunner.RunItemEvent(BPMEvent.WORKFLOW_WORKITEM_ASSIGNED,context.getEventDataContextList());
                }
                //更新节点权限引用
                try {
                    updatePermissinRef(realAppName, processXml,affairData.getPerssionAccountId() );
                } catch (BusinessException e) {
                    logger.warn("更新节点权限引用异常!",e);
                }
                if(workFlowAppExtendManager != null &&  "collaboration".equals(appName) ){
                	List<Map<String,String>> list = WorkflowUtil.getNodeMemberInfos(process);
                	workFlowAppExtendManager.processNodesChanged(processId,null, list);
                }
                
            }
        }

        //记录流程更改日志
        List<Map<String, Object>> list = null;
        try {
            if (Strings.isNotBlank(processLogJson)) {
                list = (List<Map<String, Object>>) JSONUtil.parseJSONString(processLogJson);
                if (list != null) {
                    for (Map<String, Object> data : list) {
                        String processId1 = (String) data.get("processId");
                        String activityId1 = (String) data.get("activityId");
                        String actionId1 = (String) data.get("actionId");
                        String actionUserId1 = (String) data.get("actionUserId");
                        String param0 = data.get("param0") == null ? "" : data.get("param0").toString();
                        String param1 = data.get("param1") == null ? "" : data.get("param1").toString();
                        String param2 = data.get("param2") == null ? "" : data.get("param2").toString();
                        String param3 = data.get("param3") == null ? "" : data.get("param3").toString();
                        String param4 = data.get("param4") == null ? "" : data.get("param4").toString();
                        String param5 = data.get("param5") == null ? "" : data.get("param5").toString();
                        String actionDesc = data.get("actionDesc") == null ? null : data.get("actionDesc").toString();
                        ProcessLog pLog = new ProcessLog();
                        pLog.setProcessId(Long.parseLong(processId1));
                        pLog.setActivityId(Long.parseLong(activityId1));
                        pLog.setActionId(Integer.parseInt(actionId1));
                        pLog.setActionUserId(Long.parseLong(actionUserId1));
                        pLog.setParam0(param0);
                        pLog.setParam1(param1);
                        pLog.setParam2(param2);
                        pLog.setParam3(param3);
                        pLog.setParam4(param4);
                        pLog.setParam5(param5);
                        pLog.setDesc(actionDesc);
                        processLogManager.insertLog(pLog);
                    }
                }
            }
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
        }

        //调用应用给相关人员发送消息,记录应用日志
        try {
            WorkFlowAppExtendInvokeManager.getAppManager(appName).sendSupervisorMsgAndRecordAppLog(caseId);
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
        }
        return result;
    }
    
    
    private void updatePermissinRef(String appName, String processXml, Long accountId) throws BusinessException {
        //更新节点权限引用状态
        String configCategory = "";
        if ("collaboration".equals(appName) || "form".equals(appName)) {
            configCategory = EnumNameEnum.col_flow_perm_policy.name();
        } else if ( "sendEdoc".equals(appName) || "edocSend".equals(appName) ) {
            configCategory = EnumNameEnum.edoc_send_permission_policy.name();
        } else if ( "edocRec".equals(appName) || "recEdoc".equals(appName) ) {
            configCategory = EnumNameEnum.edoc_rec_permission_policy.name();
        } else if ("signReport".equals(appName) || "edocSign".equals(appName)) {
            configCategory = EnumNameEnum.edoc_qianbao_permission_policy.name();
        } else if ("sendInfo".equals(appName) || "info".equals(appName)) {
            configCategory = EnumNameEnum.info_send_permission_policy.name();
        }
        List<String> list = workflowApiManager.getWorkflowUsedPolicyIds(appName, processXml, "", "");
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                permissionManager.updatePermissionRef(configCategory, list.get(i), accountId);
            }
        }
    }

    @Override
    public String[] changeCaseProcessNodeProperty(String[] flowProp, String[] policyStr, String caseId, boolean iscol,
            String processXml, String orginalReadyObjectJson, String oldProcessLogJson) throws BPMException {
        User user = AppContext.getCurrentUser();
        if (user == null) {
            throw new BPMException("Please log in to the system first!");//请先登录系统
        }
        String[] strArr = flowProp;
        String processId = strArr[0];
        String activityId = strArr[1];
        String operationType = strArr[2];
        BPMSeeyonPolicy policy = new BPMSeeyonPolicy();
        String[] policyArr = policyStr;
        policy.setId(policyArr[0]);
        policy.setName(policyArr[1]);
        policy.setdealTerm(policyArr[2]);
        policy.setRemindTime(policyArr[3]);
        
        if(policyArr.length > 26){
            policy.setCycleRemindTime(policyArr[26]);
        }
        policy.setProcessMode(policyArr[4]);
        policy.setMatchScope(policyArr[5]);
        
        String hasDesc= policyArr[12];
        if(Strings.isNotBlank(hasDesc) && "1".equals(hasDesc.trim())){
            policy.setDesc(policyArr[8]);
        }
        
        policy.setDealTermType(policyArr[9]);
        policy.setDealTermUserId(policyArr[10]);
        policy.setDealTermUserName(policyArr[11]);
        String isProIncludeChild = policyArr[13];
        String formField= policyArr[14];
        String rup= policyArr[15];
        String pup= policyArr[16];
        String na= policyArr[17];
        String operationm= policyArr[18];
        
        if(policyArr.length > 25){
            String na_i = policyArr[24];
            String na_b = policyArr[25];
            policy.setIgnoreBlank(na_i);
            policy.setAsBlankNode(na_b);
        }
        
        policy.setRup(rup);
        policy.setPup(pup);
        policy.setNa(na);
        boolean isForm = false;
        String formName = "";
        String operationName = "";
        if (null != policyArr[6] && !"null".equals(policyArr[6].trim()) && !"".equals(policyArr[6].trim())
                && !"undefined".equals(policyArr[6].trim())) {
            formName = policyArr[6].trim();
            isForm = true;
        }
        if (null != policyArr[7] && !"null".equals(policyArr[7].trim()) && !"".equals(policyArr[7].trim())
                && !"undefined".equals(policyArr[7].trim())) {
            operationName = policyArr[7].trim();
            isForm = true;
        }
        policy.setForm(formName);
        policy.setOperationName(operationName);
        policy.setOperationm(operationm);
        policy.setFormField(formField);
        policy.setTolerantModel(policyArr[19]);
        if(policyArr.length > 22){
	        policy.setQueryIds(policyArr[21]);
	        policy.setStatisticsIds(policyArr[22]);
        }
        if(policyArr.length > 23){
            policy.setRscope(policyArr[23]);
        }
        String nodeName= policyArr[20];
        String[] xmlStr = new String[] {};
        Map<String, Object> flowData = new HashMap<String, Object>();
        String userName= Functions.showMemberName(user.getId());
        xmlStr = processManager.superviseUpdateProcess(processId, activityId, Integer.parseInt(operationType),
                flowData, policy, null, null, caseId, processXml, orginalReadyObjectJson, user.getId().toString(),
                userName, isForm, oldProcessLogJson, isProIncludeChild,nodeName);
        return xmlStr;
    }

    public ProcessTemplateManager getProcessTemplateManager() {
        return processTemplateManager;
    }

    public void setProcessTemplateManager(ProcessTemplateManager processTemplateManager) {
        this.processTemplateManager = processTemplateManager;
    }

    @Override
    public String[] validateCurrentSelectedNode(String caseId, String currentSelectedNodeId,
            String currentSelectedNodeName, String currentStepbackNodeId, String initialize_processXml,
            String permissionAccountId, String configCategory,String processId) throws BPMException {
        String[] result = new String[14];
        result[0] = "true";
        result[1] = "";
        result[2] = "false";
        result[3] = "false";
        result[4] = "false";
        result[5] = "false";
        result[6] = "false";
        result[7] = "false";//当前流程是否为子流程，不允许选择开始节点。
        result[8] = "false";
        result[9] = "false";
        result[10] = "false";//是否为孩子节点
        result[11] = "false";//是否为孩子节点
        if (null == currentSelectedNodeId || "".equals(currentSelectedNodeId.trim())
                || "-1".equals(currentSelectedNodeId.trim())) {
            result[0] = "false";
            result[1] = "The param error:currentSelectedNodeId";
            return result;
        }
        if (null == currentStepbackNodeId || "".equals(currentStepbackNodeId.trim())
                || "-1".equals(currentStepbackNodeId.trim())) {
            result[0] = "false";
            result[1] = "The param error:currentStepbackNodeId";
            return result;
        }
        if ((null == initialize_processXml || "".equals(initialize_processXml.trim())
                || "-1".equals(initialize_processXml.trim()))&& Strings.isBlank(processId) ) {
            result[0] = "false";
            result[1] = "The param error:initialize_processXml";
            return result;
        }
        BPMProcess process = null;
        if(Strings.isNotBlank(initialize_processXml)){
        	process = BPMProcess.fromXML(initialize_processXml);
        }else if(Strings.isNotBlank(processId)){
        	process = workflowApiManager .getBPMProcessForM1(processId);
        }
        BPMProcess.fromXML(initialize_processXml);
        BPMAbstractNode currentSelectedNode = null;
        BPMCase theCase = caseManager.getCase(Long.parseLong(caseId));
        if ("start".equals(currentSelectedNodeId.trim())) {
            currentSelectedNode = process.getStart();
            //如果是开始节点，则应该要判断下当前流程是否为子流程，如果是子流程，则不允许选择开始节点。
            String _processId= theCase.getProcessId();
            List<SubProcessRunning> subList= subProcessManager.getSubProcessRunningListBySubProcessId(_processId, true, false);
            if(null!=subList && subList.size()>0){//当前流程为子流程
                result[0] = "false";
                result[7] = "true";
                return result;
            }
        } else if ("end".equals(currentSelectedNodeId.trim())) {
            result[0] = "false";
            result[1] = "currentSelectedNodeId is end";
            return result;
        } else {
            currentSelectedNode = process.getActivityById(currentSelectedNodeId.trim());
            if(!currentSelectedNodeId.equals(currentStepbackNodeId)){//是已办节点
                boolean isDone = WorkflowUtil.isThisState(theCase, currentSelectedNodeId, CaseDetailLog.STATE_FINISHED);
                if(isDone){
                    List<BPMHumenActivity> childs= new ArrayList<BPMHumenActivity>();
                    childs.add((BPMHumenActivity)currentSelectedNode);
                    List<WorkItem> workitems= workItemManager.getWorItemList(Long.parseLong(caseId), childs);
                    if(null==workitems || workitems.isEmpty()){//节点匹配不到人，不能回退
                        result[0] = "false";
                        result[11] = "true";
                        return result;
                    }else{
                    	boolean isValid= WorkflowUtil.isNodeValid(theCase, currentSelectedNode);
                    	if(!isValid){
                    		result[0] = "false";
                            result[13] = "true";
                            return result;
                    	}
                    }
                }
            }
        }
        Map<String, String> passNodes= new HashMap<String, String>();
        boolean[] isMyChildNode = isMyChildNode(theCase, process, currentSelectedNodeId.trim(), currentSelectedNode,
                currentStepbackNodeId,permissionAccountId, configCategory,passNodes);
        result[0] = String.valueOf(isMyChildNode[0]);
        if (isMyChildNode[0]) {
            result[1] = "success";
        }
        result[10] = String.valueOf(isMyChildNode[0]);
        if ( isMyChildNode[2] || isMyChildNode[3] || isMyChildNode[4] || isMyChildNode[5] || isMyChildNode[8]) {
            result[0] = "false";
            result[1] = "fail";
        }
        result[2] = String.valueOf(isMyChildNode[1]);
        result[3] = String.valueOf(isMyChildNode[2]);
        result[4] = String.valueOf(isMyChildNode[3]);
        result[5] = String.valueOf(isMyChildNode[4]);
        result[6] = String.valueOf(isMyChildNode[5]);
        result[8] = String.valueOf(isMyChildNode[6]);
        result[9] = String.valueOf(isMyChildNode[7]);
        result[12] = String.valueOf(isMyChildNode[8]);
        return result;
    }

    @Override
    public String[] validateWorkflowAutoCondition(String appName, String appId, String expression,
            boolean validateRelation) throws BPMException {
        //如果表单Id不存在，那么也就不必校验表单单元格了。
        //如果分支条件表达式校验不通过，那么也没有必要校验表单单元格
        //判断表达式中的表达是否都在指定的表单中
        Map<String, WorkflowFormFieldVO> fieldMap = new HashMap<String, WorkflowFormFieldVO>();
        Long formAppId= null;
        if ("form".equals(appName)) {//表单模板
            formAppId= Long.parseLong(appId);
            fieldMap= WorkflowFormDataMapInvokeManager.getAppManager("form").getFormFieldMap(appId);
            WorkflowFormFieldVO temp = new WorkflowFormFieldVO();
            temp.setName(WorkFlowFinal.Validate_FormFieldType_Number);
            fieldMap.put(WorkFlowFinal.Validate_FormFieldType, temp);
        } else if ("edoc".equals(appName) || "edocSend".equals(appName) || "sendEdoc".equals(appName) || "recEdoc".equals(appName)
                || "signReport".equals(appName)) {//公文模板
            WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
            if(validateManager!=null){
                List<WorkflowFormFieldVO> fieldList = validateManager.getWorkflowBranchFormFieldVOListById(Long.parseLong(appId));
                if (fieldList != null && fieldList.size() > 0) {
                    for (WorkflowFormFieldVO field : fieldList) {
                        fieldMap.put(field.getName(), field);
                    }
                }
            }
            WorkflowFormFieldVO temp = new WorkflowFormFieldVO();
            temp.setName(WorkFlowFinal.Validate_FormFieldType_NumberAndEnum);
            fieldMap.put(WorkFlowFinal.Validate_FormFieldType, temp);
        }
        return validateAutoCondition("", fieldMap, formAppId, expression, validateRelation);
    }
    
    private String[] validateAutoCondition(String appName, Map<String, WorkflowFormFieldVO> fieldMap, Long formAppId, String branchExpression,
            boolean validateRelation) throws BPMException {
        boolean success = true;
        String text = "";
        Expression e = ExpressionFactory.createExpression( branchExpression, fieldMap);
        e.setFieldType(3);
        e.validate(appName, formAppId, fieldMap);
        if (!e.isSuccess()) {
        	success = false;
        	text = e.getErrorMsg();
        }
        String[] result = new String[3];
        result[0] = String.valueOf(success);
        result[1] = text;
        result[2] = branchExpression;//转换后的field0001类型的分支条件
        return result;
    }

    private boolean[] isMyChildNode(BPMCase theCase, BPMProcess process, String currentSelectedNodeId,
            BPMAbstractNode currentSelectedNode, String currentStepbackNodeId, String permissionAccount,
            String configCategory,Map<String, String> passNodes) throws BPMException {
        boolean[] result = new boolean[9];
        result[0] = false;
        result[1] = false;
        result[2] = false;
        result[3] = false;
        result[4] = false;
        result[5] = false;
        result[6] = false;
        result[7] = false;
        result[8] = false;
        if (BPMAbstractNode.NodeType.end.equals(currentSelectedNode.getNodeType())) {
            result[0] = false;
            return result;
        }
        if(null!=passNodes.get(currentSelectedNode.getId())){
            result[0] = false;
            return result;
        }
        passNodes.put(currentSelectedNode.getId(), currentSelectedNode.getId());
        boolean isInform = ObjectName.isInformObject(currentSelectedNode);//知会节点
        if (BPMAbstractNode.NodeType.humen.equals(currentSelectedNode.getNodeType()) && !isInform) {
            boolean isDoing = WorkflowUtil.isThisState(theCase, currentSelectedNode.getId(), CaseDetailLog.STATE_READY,
                    CaseDetailLog.STATE_NEEDREDO_TOME, CaseDetailLog.STATE_SUSPENDED);
            boolean isDone = WorkflowUtil.isThisState(theCase, currentSelectedNode.getId(), CaseDetailLog.STATE_FINISHED,
                    CaseDetailLog.STATE_CANCEL, CaseDetailLog.STATE_STOP);
            if (isDoing) {//待办
                List<BPMHumenActivity> nodes= new ArrayList<BPMHumenActivity>();
                nodes.add((BPMHumenActivity)currentSelectedNode);
                List list= workItemManager.getWorItemListByStates(theCase.getId(), nodes, new Integer[]{WorkItem.STATE_FINISHED});
                if(null!=list && list.size()>0){
                    //该节点是否为表单审核和核定节点，如果是，则不允许回退到当前选择的节点
                    BPMSeeyonPolicy policy = currentSelectedNode.getSeeyonPolicy();
                    String policyId = policy.getId();
                    String nf = policy.getNF();
                    if (policyId.equals("vouch")) {//被选择的节点与当前处理节点之间有已办的核定节点，不能选择
                        result[3] = true;
                        return result;
//                    } else if (policyId.equals("formaudit")) {//被选择的节点与当前处理节点之间有已办的表单审核节点，不能选择
//                        result[4] = true;
//                        return result;
                    } else if ("1".equals(nf)) {//被选择的节点与当前处理节点之间有已办的节点，且触发了新流程，需要进一步判断
                        boolean isNFFinished = false;
                        List<SubProcessRunning> subProcessList = subProcessManager.getFinishedSubProcess(process.getId(),
                                currentSelectedNode.getId());
                        if (subProcessList.size() > 0) {
                            isNFFinished = true;
                        }
                        if (isNFFinished) {//子流程已经结束了，不能选择进行回退了
                            result[5] = true;
                            if(currentSelectedNodeId.equals(currentSelectedNode.getId())){
                                result[7] = true;
                            }
                            return result;
                        }else{//子流程未结束，不能选择进行回退了
                            result[6] = true;
                        }
                    } else {//被选择的节点与当前处理节点之间有已办的封发节点，不能选择
                        if (Strings.isNotBlank(permissionAccount) && Strings.isNotBlank(configCategory)) {
                            boolean isExChangeNode = workflowApiManager.isExchangeNode(configCategory, policyId,Long.parseLong(permissionAccount));
                            if (isExChangeNode) {
                                result[2] = true;
                                return result;
                            }
                        }
                    }
                }else{
                    //不再继续往后查找
                    return result;
                }
            } else if (isDone) {//已办
                //该节点是否为表单审核和核定节点，如果是，则不允许回退到当前选择的节点
                BPMSeeyonPolicy policy = currentSelectedNode.getSeeyonPolicy();
                String policyId = policy.getId();
                String nf = policy.getNF();
                if (policyId.equals("vouch")) {//被选择的节点与当前处理节点之间有已办的核定节点，不能选择
                    result[3] = true;
                    return result;
//                } else if (policyId.equals("formaudit")) {//被选择的节点与当前处理节点之间有已办的表单审核节点，不能选择
//                    result[4] = true;
//                    return result;
                } else if ("1".equals(nf)) {//被选择的节点与当前处理节点之间有已办的节点，且触发了新流程，需要进一步判断
                    boolean isNFFinished = false;
                    List<SubProcessRunning> subProcessList = subProcessManager.getFinishedSubProcess(process.getId(),
                            currentSelectedNode.getId());
                    if (subProcessList.size() > 0) {
                        isNFFinished = true;
                    }
                    if (isNFFinished) {//子流程已经结束了，不能选择进行回退了
                        result[5] = true;
                        if(currentSelectedNodeId.equals(currentSelectedNode.getId())){
                            result[7] = true;
                        }
                        return result;
                    }else{//子流程未结束，不能选择进行回退了
                        result[6] = true;
                        List<String> nodeIds = new ArrayList<String>();
                        nodeIds.add(currentSelectedNode.getId());
                        List<SubProcessRunning> subList = subProcessManager
                                .getSubProcessRunningListByMainProcessId(process.getId(), nodeIds, true, false);
                        for (SubProcessRunning subProcessRunning : subList) {
                            int vouch = WorkFlowAppExtendInvokeManager.getAppManager("collaboration").getSummaryVouch(
                                    subProcessRunning.getSubProcessProcessId());
                            if (vouch == 1) {//核定通过了
                                result[8] = true;
                                return result;
                            }
                        }
                    }
                } else {//被选择的节点与当前处理节点之间有已办的封发节点，不能选择
                    if (Strings.isNotBlank(permissionAccount) && Strings.isNotBlank(configCategory)) {
                        boolean isExChangeNode = workflowApiManager.isExchangeNode(configCategory, policyId,Long.parseLong(permissionAccount));
                        if (isExChangeNode) {
                            result[2] = true;
                            return result;
                        }
                    }
                }
            }
        }
        List<BPMTransition> downs = currentSelectedNode.getDownTransitions();
        if (null == downs) {
            result[0] = false;
            return result;
        }
        for (BPMTransition bpmTransition : downs) {
            BPMAbstractNode toNode = bpmTransition.getTo();
            boolean isCanPass = WorkflowUtil.isThisState(theCase, toNode.getId(), 0,1);
            if(isCanPass && !toNode.getNodeType().equals(BPMAbstractNode.NodeType.start) 
                    && !toNode.getNodeType().equals(BPMAbstractNode.NodeType.split)
                    && !toNode.getNodeType().equals(BPMAbstractNode.NodeType.join)){
                return result;
            }else{
                isCanPass= true;
                if(toNode.getNodeType().equals(BPMAbstractNode.NodeType.split) 
                        || toNode.getNodeType().equals(BPMAbstractNode.NodeType.join)){
                    List<BPMHumenActivity> myChilds= WorkflowUtil.getChildHumensWithoutDelete((BPMActivity)toNode,false,theCase);
                    for (BPMHumenActivity bpmHumenActivity : myChilds) {
                        boolean isCanPass1 = WorkflowUtil.isThisState(theCase, bpmHumenActivity.getId(), 0,1);
                        if(isCanPass1){
                            isCanPass= false;
                            break;
                        }
                    }
                }
            }
            if(!isCanPass){
                return result;
            }
//            int conditionType = bpmTransition.getConditionType();
//            if(!"collaboration".equals(configCategory)){
//            	 if (conditionType != 3) {
//                     result[1] = true;
//            	 }
//            }
            if (toNode.getId().equals(currentStepbackNodeId.trim())) {
                result[0] = true;
            } else {
                boolean[] result1 = isMyChildNode(theCase, process, currentSelectedNodeId, toNode,
                        currentStepbackNodeId, permissionAccount, configCategory,passNodes);
                result[0] = (result[0] || result1[0]);//是否为该孩子节点
                result[1] = (result[1] || result1[1]);//是否有分支条件
                result[2] = (result[2] || result1[2]);//是否有封发节点
                result[3] = (result[3] || result1[3]);//是否有核定节点
                result[4] = (result[4] || result1[4]);//是否有表单审核节点
                result[5] = (result[5] || result1[5]);//是否有子流程结束的节点
                result[6] = (result[6] || result1[6]);//是否有子流程的节点
                result[7] = (result[7] || result1[7]);//当前选中是否有子流程的节点
                result[8] = (result[8] || result1[8]);//子流程是否已核定
                if (result[0] && (result[2] || result[3] || result[4] || result[5] || result[8])) {
                    return result;
                }
            }
        }
        return result;
    }

    @Override
    public String[] branchTranslateBranchExpression(String appName, String formApp, String branchExpression)
            throws BPMException {
        //不能包含$字符
        if(branchExpression!=null && branchExpression.indexOf("$")>-1){
            return new String[]{"false",ResourceUtil.getString("workflow.branchTranslate.1")+":     $",""};
        }
        //获取到所有的表单域，转换分支条件时需要
        //如果表单Id不存在，那么也就不必校验表单单元格了。
        //如果分支条件表达式校验不通过，那么也没有必要校验表单单元格
        //判断表达式中的表达是否都在指定的表单中
        Map<String, WorkflowFormFieldVO> fieldMap = new HashMap<String, WorkflowFormFieldVO>();
        Long formAppId = null;
        boolean isEdocFlag = false;
        formApp = formApp.trim();
        if ("form".equals(appName) && WorkflowUtil.isLong(formApp) && !"0".equals(formApp) && !"-1".equals(formApp)) {//表单模板 
            formAppId= Long.parseLong(formApp);
        	fieldMap= WorkflowFormDataMapInvokeManager.getAppManager("form").getFormFieldMap(formApp);
        } else if(ApplicationCategoryEnum.edocRec.name().equals(appName)
                || ApplicationCategoryEnum.edocSend.name().equals(appName)
                || ApplicationCategoryEnum.edocSign.name().equals(appName)
                || "sendEdoc".equals(appName) 
                || "recEdoc".equals(appName)
                || "signReport".equals(appName)){//公文模板
        	if(WorkflowUtil.isLong(formApp) && !"0".equals(formApp) && !"-1".equals(formApp)){
            	isEdocFlag = true;
            	WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
                if(validateManager!=null){
                	fieldMap= validateManager.getFormFieldsDefinition(appName, formApp, new ArrayList<String>(), new ArrayList<String>());
                }
        	}else{
        	    logger.info("formApp:="+formApp);
        	}
        }
        String[] result = new String[4];
        result[2] = "";
        if (null == branchExpression || "".equals(branchExpression.trim()) || "null".equals(branchExpression.trim())
                || "undefined".equals(branchExpression.trim()) || null == appName || "".equals(appName.trim())
                || "null".equals(appName.trim()) || "undefined".equals(appName.trim())) {
            result[0] = "true";
            result[1] = ResourceUtil.getString("workflow.branchTranslate.6");//"无";
            return result;
        }
        //原始表达式
        String orignial = branchExpression;
        branchExpression = branchExpression.trim();
        String originalExpression = branchExpression;
        Expression e = ExpressionFactory.createExpression(branchExpression, fieldMap);
        e.validate(appName, formAppId, fieldMap);
        if (!e.isSuccess()) {
            result = new String[4];
            result[0] = "false";
            result[1] = e.getErrorMsg();
            //result[3] = e.translate(1, appName, formBean, fieldMap);
            return result;
        }
        branchExpression = e.translate(2, appName, formAppId, fieldMap);
        
        //如果是公文的话，转换公文枚举
        if(isEdocFlag){
        	String[] edocResult= translateEdocEnum(branchExpression, fieldMap);
        	branchExpression= edocResult[2];
        	if(edocResult[0] == "true"){
        		result[0] = edocResult[0];
                //枚举值不存在
                result[1] = edocResult[1];
        		return result;
        	}else{
        		Set<String> edocFieldSet= fieldMap.keySet();
        		for (String edocField : edocFieldSet) {
        			branchExpression= branchExpression.replaceAll(edocField, fieldMap.get(edocField).getDisplay());
				}
        	}
        }
        result[0] = "true";
        branchExpression= translateExpressionTitle(fieldMap,branchExpression);
        FormulaManager formulaManager= (FormulaManager)AppContext.getBean("formulaManager");
        List<Formula> systemVariablesList= formulaManager.getAllVariable(null);
        if(null!=systemVariablesList){
	        for (Formula formula : systemVariablesList) {
	        	if(null!=formula){
		        	String formulaName= formula.getFormulaName();
		        	String formulaDisplayName= formula.getFormulaAlias();
		        	branchExpression= branchExpression.replaceAll(formulaName, formulaDisplayName);
	        	}
			}
        }
        result[1] = branchExpression;
        if ("false".equals(result[0])) {
            return result;
        }
        
        String newTitle = branchExpression.replaceAll("<span[ 0-9A-Za-z,()=\"]+>", "")
                .replaceAll("</span>", "")
                .replace("&lt;", "<").replace("&gt;", ">");
        newTitle= translateExpressionTitle(fieldMap,newTitle);
        result[3] = newTitle;
        return result;
    }

    private String[] translateEdocEnum(String branchExpression,Map<String, WorkflowFormFieldVO> fieldMap) {
    	String[] result= new String[]{"","",""};
    	String newBranchExpression= branchExpression;
    	String translateGroup = "";
    	Pattern p = Pattern.compile("([^\\s(){}\\[\\]!=<>&|\\^+*/%\\$#'\":;,?\\\\]+)\\s*(==|!=)\\s*(\\d+)");
    	Matcher m = p.matcher(branchExpression);
        StringBuffer sb = new StringBuffer();
    	while(m.find()){
    		String first = m.group(1);
    		String second = m.group(2);
    		String third = m.group(3);
    		WorkflowFormFieldVO field = fieldMap.get(first);
    		if(field!=null && field.getEnumId()!=null && field.getEnumId()!=0L && field.getEnumId()!=-1L){
                //找枚举项
	            CtpEnumItem enumItem = null;
                try {
                    //公文枚举通通使用第一层枚举
                    enumItem = enumManagerNew.getCtpEnumItem(field.getEnumId(), 0, third);
                } catch (BusinessException e1) {
                    logger.error(e1);
                }
	            if (enumItem!=null) {
                    String label = enumItem.getShowvalue();
                    String newLabel = label;
                    if(enumItem.getI18n()!=null && enumItem.getI18n().intValue()==1){
                        newLabel = ResourceUtil.getString(newLabel);
                    }
                    if (newLabel != null && !"".equals(newLabel.trim())) {
                        third = newLabel;
                    } else {
                    	third = label;
                    }
	        		translateGroup = first + " " + second + " " + third;
	                m.appendReplacement(sb, translateGroup);
	            }else{
	                result[0] = "true";
                    //枚举值不存在
                    result[1] = ResourceUtil.getString("workflow.branchValidate.7",m.group(),third);
                    return result;
	            }
    		}
        }
        m.appendTail(sb);
        newBranchExpression = sb.toString();
        result[2]= newBranchExpression;
        return result;
	}

	private String translateExpressionTitle(Map<String, WorkflowFormFieldVO> fieldMap,String expressionTitle) {
    	String newTitle= expressionTitle;
    	//鼠标放上去的分支转义需要加上一步，将表单的fieldName转换为display
        if(fieldMap!=null && fieldMap.size()>0){
            Pattern fieldPattern = Pattern.compile("field\\d+");
            Matcher fieldMatcher = fieldPattern.matcher(expressionTitle);
            StringBuffer sb = new StringBuffer("");
            while(fieldMatcher.find()){
            	String fgroup = fieldMatcher.group();
            	WorkflowFormFieldVO field = fieldMap.get(fgroup);
            	if(field!=null){
            		String display = field.getDisplay();
            		fieldMatcher.appendReplacement(sb, display);
            	}else{
            		fieldMatcher.appendReplacement(sb, fgroup);
            	}
            }
            fieldMatcher.appendTail(sb);
            newTitle = sb.toString();
        }
        return newTitle;
	}

    @Override
    public String[] getCaseState(String caseId) throws BPMException {
        String[] result = new String[1];
        BPMCase theCase = caseManager.getCase(Long.parseLong(caseId));
        if (null != theCase) {
            boolean isCaseStop = theCase.getState() != CaseInfo.STATE_RUNNING ? true : false;
            result[0] = String.valueOf(isCaseStop);
            if("false".equals(result[0])){
              //前端用户校验督办权限,判断是否有督办权限
                User user = AppContext.getCurrentUser();
                boolean hasSupervisorRight = true;
                String appName= theCase.getData(ActionRunner.SYSDATA_APPNAME).toString();
                try {
                    hasSupervisorRight = WorkFlowAppExtendInvokeManager.getAppManager(appName).checkUserSupervisorRight(caseId,
                            user.getId());
                } catch (Throwable e) {
                    logger.error(e.getMessage(), e);
                }
                if(!hasSupervisorRight){
                    result[0]= "true";
                }
            }
            return result;
        }
        throw new BPMException("The process case is not exists,caseId:=" + caseId);//流程实例不存在
    }

    @Override
    public String[] hasConditionAfterSelectNode(String processXml, String currentNodeId) throws BPMException {
        BPMProcess bpmProcess = BPMProcess.fromXML(processXml);
        BPMActivity currentNode = bpmProcess.getActivityById(currentNodeId);
        boolean result = "1".equals(currentNode.getSeeyonPolicy().getNF());
        if (!result) {
            try {
                result = BranchArgs.hasConditionOrSelectForSkipVerify(currentNode);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                throw new BPMException(e);
            }
        }
        String[] myResult = new String[1];
        myResult[0] = String.valueOf(result);
        return myResult;
    }

    @Override
    public String[] hasAutoSkipNodeBeforeSetCondition(String processXml, String currentLinkId) throws BPMException {
        String[] result = new String[2];
        if (null == currentLinkId || "".equals(currentLinkId.trim())) {
            result[0] = String.valueOf(false);
            result[1] = "";
            return result;
        }
        BPMProcess bpmProcess = BPMProcess.fromXML(processXml);
        BPMTransition currentTransaction = bpmProcess.getLinkById(currentLinkId);
        result = BranchArgs.hasAutoSkipNodeBeforeSetCondition(currentTransaction);
        result[1] = ResourceUtil.getString("workflow.dealterm.skip.node.before.branch", result[1]);
        return result;
    }

    @Override
    public String[] isAutoSkipBeforeNewSetFlowOfNode(String processXml, String currentNodeId) throws BPMException {
        boolean result = false;
        BPMProcess bpmProcess = BPMProcess.fromXML(processXml);
        BPMActivity currentNode = bpmProcess.getActivityById(currentNodeId);
        BPMSeeyonPolicy policy = currentNode.getSeeyonPolicy();
        String dealTermType = policy.getDealTermType();
        String dealTerm = policy.getdealTerm();//是否选择处理期限
        if (null != dealTermType && "2".equals(dealTermType.trim()) && null != dealTerm && !"".equals(dealTerm)
                && !"0".equals(dealTerm)) {//自动跳过节点
            result = true;
        }
        String[] returnResult = new String[1];
        returnResult[0] = String.valueOf(result);
        return returnResult;
    }

    @Override
    public CPMatchResultVO transBeforeInvokeWorkFlow(WorkflowBpmContext context, CPMatchResultVO cpMatchResult)
            throws BPMException {
        if (null == cpMatchResult) {
            cpMatchResult = new CPMatchResultVO();
        }
        //context.setValidate(true);
        try{
            CPMatchResultVO vo= workflowApiManager.transBeforeInvokeWorkFlow(context, cpMatchResult);
            vo.setToken("WORKFLOW");
            return vo;
        }
        catch(NoSuchWorkitemException e){//workitem不存在时，模拟一个，允许提交
            logger.error(e);
            cpMatchResult.setCanSubmit("true");
            cpMatchResult.setCannotSubmitMsg("");
            cpMatchResult.setAlreadyChecked("true");
            cpMatchResult.setToken("WORKFLOW");
            return cpMatchResult;
        }
    }
    
    @Override
    public boolean transCheckBrachSelectedWorkFlow(WorkflowBpmContext context,
            String checkedNodeId,
            List<String> allSelectNodes,
            List<String> allNotSelectNodes,
            List<String> allSelectInformNodes,
            List<String> currentSelectInformNodes) throws BPMException {
        boolean result= workflowApiManager.transCheckBrachSelectedWorkFlow(context,checkedNodeId,
                new HashSet(allSelectNodes),
                new HashSet(allNotSelectNodes),
                new HashSet(allSelectInformNodes),
                new HashSet(currentSelectInformNodes));
        return result;
    }

    @Override
    public String addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON,
            String messageDataList, String changeMessageJSON) throws BPMException {
        try{
            ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");


            //客开 加签后再加入当前节点，节点权限保持一致 start
            if(message.get("huishang")!=null){
            	if(message.get("caseId")!=null && StringUtils.isNotBlank(message.get("caseId").toString()) && message.get("flowType")!=null && StringUtils.equalsIgnoreCase("1", message.get("flowType").toString())){
            		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
            		V3xOrgMember m = orgManager.getMemberById(Long.valueOf(userId));
            		String processXml = workFlowDesignerManager.getProcessXml(processId, "3", "false", null, ((CaseManager)AppContext.getBean("caseManager")).getCase(Long.valueOf(message.get("caseId").toString()), false), false)[0];
            		if(StringUtils.isNotBlank(processXml)){
            			processXml = processXml.replaceAll("\\\\", "");
            			Document doc = DocumentHelper.parseText(processXml);
            			Element root = doc.getRootElement();
            			Node n = root.selectSingleNode("p/n[@i="+currentActivityId+"]");
            			if(n!=null){
            				String pid = ((Element)n.selectSingleNode("s[@i]")).attributeValue("i");
            				String pname = ((Element)n.selectSingleNode("s[@i]")).attributeValue("n");

            				String policyId = message.get("policyId").toString();
            				String policyName = message.get("policyName").toString();

            				String[] policyIds = new String[2];
            				String[] policyNames = new String[2];

            				policyIds[0] = policyId;
            				policyIds[1] = pid;

            				policyNames[0] = policyName;
            				policyNames[1] = pname;

            				message.put("policyId", policyIds);
            				message.put("policyName", policyNames);
            			}
            		}
            		List<String> uids = (List<String>)message.get("userId");
            		uids.add(userId);
            		message.put("userId", uids);

            		List<String> users = (List<String>)message.get("userName");
            		users.add(m.getName());
            		message.put("userName", users);

            		List<String> userTypes = (List<String>)message.get("userType");
            		userTypes.add("Member");
            		message.put("userTypes", userTypes);

            		List<Boolean> ueds = (List<Boolean>)message.get("userExcludeChildDepartment");
            		ueds.add(false);
            		message.put("userExcludeChildDepartment",ueds);

            		List<String> aids = (List<String>)message.get("accountId");
            		aids.add(String.valueOf(m.getOrgAccountId()));
            		message.put("accountId", aids);

            		List<String> ans = (List<String>)message.get("accountShortname");
            		ans.add(null);
            		message.put("accountShortname", ans);
            	}
            }
            //客开 end
	        String[] resultArray = engine.addNode(processId, currentActivityId, targetActivityId, userId, changeType,
	                message, baseProcessXML, baseReadyObjectJSON, messageDataList, changeMessageJSON);
	
	        String result = DataContainer.convertArray(resultArray);
	        return result;
        }catch(Exception e){
        	logger.error("", e);
        }
        return null;
    }

    @Override
    public String deleteNode(String processId, String currentActivityId, String userId, List<String> activityIdList,
            String baseProcessXML, String messageDataList, String changeMessageJSON, String summaryId, String affairId) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String[] result = engine.deleteNode(processId, currentActivityId, userId, activityIdList, baseProcessXML,
                messageDataList, changeMessageJSON, summaryId, affairId);
        DataContainer container = new DataContainer();
        container.add("processXML", result[0]);
        container.add("messageDataList", result[1]);
        container.add("processChangeMessage", result[2]);
        return container.getJson();
    }
    
    public String[] canStepBack(String workitemId, String caseId, String processId, String nodeId,String permissionAccount,String configCategory) throws BPMException {
    	return this.canStepBack("",workitemId, caseId, processId, nodeId, permissionAccount, configCategory);
    }

    @Override
    public String[] canStepBack(String matchRequestToken,String workitemId, String caseId, String processId, String nodeId,String permissionAccount,String configCategory) throws BPMException {
        boolean canStepBack = true;
        String msg= "";
        WorkItem workitem = workItemManager.getWorkItemById(null, Long.parseLong(workitemId));
        if( null== workitem ){
            String[] result= new String[2];
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        Object[] processObj= WorkflowUtil.doInitBPMProcessForCache(matchRequestToken, "", processId, "", nodeId);
        BPMProcess process = null;
	   	if(null!=processObj && null!=processObj[0]){
	   		 process=  (BPMProcess)processObj[0];
	   	}
        BPMHumenActivity currentNode = (BPMHumenActivity) process.getActivityById(nodeId);
        BPMCase theCase = caseManager.getCase(workitem.getCaseId());
        if(theCase.getState()==CaseInfo.STATE_CANCEL || theCase.getState()==CaseInfo.STATE_STOP){
            canStepBack= false;
            String[] result= new String[2];
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        int stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
        if(stepCount>0){//流程处于指定回退状态了，不可做回退操作
            canStepBack= false;
            msg= ResourceUtil.getString("workflow.validate.stepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
        }
        String appName= theCase.getData(ActionRunner.SYSDATA_APPNAME).toString();
        if(canStepBack){            
            if (theCase instanceof HistoryCaseRunDAO) {
                canStepBack= false;
                msg= ResourceUtil.getString("workflow.validate.stepback.msg1");//"流程已结束,不能回退！";
            }
        }
        if(canStepBack){
            List<SubProcessRunning> subList1= subProcessManager.getSubProcessRunningListBySubProcessId(processId, true, false);
            if(null!=subList1 && subList1.size()>0){//当前流程为子流程
                List ups= currentNode.getUpTransitions();
                if(ups.size()==1){
                    if(((BPMTransition)ups.get(0)).getFrom().getNodeType().equals(BPMAbstractNode.NodeType.start)){
                        String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummarySubject(processId);
                        canStepBack= false;
                        msg= ResourceUtil.getString("workflow.validate.stepback.msg2",subProcessSubject);//"当前节点为子流程《"+subProcessSubject+"》的第一个处理节点，不能回退！";
                    }else{
                        BPMAbstractNode fromNode= ((BPMTransition)ups.get(0)).getFrom();
                        fromNode= goPreContinue(fromNode);
                        if( fromNode.getNodeType()== BPMAbstractNode.NodeType.start){
                            String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummarySubject(processId);
                            canStepBack= false;
                            msg= ResourceUtil.getString("workflow.validate.stepback.msg2",subProcessSubject);//"当前节点为子流程《"+subProcessSubject+"》的第一个处理节点，不能回退！";
                        }
                    }
                }
                if(canStepBack){
                    Map resultMap= WorkflowUtil.isAllHumenNodeValid(currentNode,theCase);
                    String result_str= (String)resultMap.get("result");
                    if(result_str.equals("-1")){
                    	canStepBack = false;
                    	String invalidateNodeName= (String)resultMap.get("invalidateNodeName");
                        msg = ResourceUtil.getString("workflow.invalidateActivity.label",invalidateNodeName);//"该流程已核定通过，不能回退！";
                    }else if (result_str.equals("0")) {
                        Map<String, String> normal_nodes = (Map) resultMap.get("normal_nodes");
                        Iterator<String> iterators = normal_nodes.keySet().iterator();
                        while (iterators.hasNext()) {
                            String normalNodeId = iterators.next();
                            List<String> nodeIds = new ArrayList<String>();
                            BPMActivity normalActivity = process.getActivityById(normalNodeId);
                            BPMSeeyonPolicy normalPolicy = normalActivity.getSeeyonPolicy();
                            if(normalPolicy.getId().equals("vouch")){//表示遇到核定节点
                                canStepBack = false;
                                msg = ResourceUtil.getString("workflow.validate.stepback.msg5");//"该流程已核定通过，不能回退！";
                                break;
                            }
                        }
                    }
                    if(canStepBack){//查找与我并行的节点
                        if("0".equals(result_str)){
                            Map<String, String> normal_nodes = (Map) resultMap.get("normal_nodes");
                            Iterator<String> iterators = normal_nodes.keySet().iterator();
                            while (iterators.hasNext()) {
                                String normalNodeId = iterators.next();
                                BPMActivity normalActivity = process.getActivityById(normalNodeId);
                                boolean[] results= findTheSpecialNodeDown(normalActivity,theCase,currentNode.getId(),theCase.getProcessId());
                                if(results[1]){//vouch
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg8");//"与当前节点并行的节点已核定通过，不能回退！";
                                }else if(results[2]){//formaudit
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg9");//"与当前节点并行的节点已表单审核通过，不能回退！";
                                }
                                if(!canStepBack){
                                    break;
                                }
                            }
                        }
                    }
                }
                
            }else{//当前流程为主流程
                Map resultMap= WorkflowUtil.isAllHumenNodeValid(currentNode,theCase);
                Map<String, String> normal_nodes = (Map) resultMap.get("normal_nodes");
                List<SubProcessRunning> subProcessList = null;
                String result_str= (String)resultMap.get("result");
                if(result_str.equals("-1")){
                	canStepBack = false;
                	String invalidateNodeName= (String)resultMap.get("invalidateNodeName");
                    msg = ResourceUtil.getString("workflow.invalidateActivity.label",invalidateNodeName);//"该流程已核定通过，不能回退！";
                }else if("0".equals(result_str) || "1".equals(result_str)){//正常回退或撤销，都得对后续的节点的子流程进行删除操作
                    if("1".equals(result_str)){//撤销，放入start节点信息
                    	normal_nodes.put(process.getStart().getId(), process.getStart().getId());
                    }
                    List<String> prevNodeIds= WorkflowUtil.getAllNFNodes(normal_nodes,process,theCase);
                    if(null!=prevNodeIds && prevNodeIds.size()>0){
                        subProcessList = subProcessManager.getSubProcessRunningListByMainProcessId(processId,prevNodeIds,true,false);
                    }
                    if (null!= subProcessList && subProcessList.size() > 0) {
                    	for (SubProcessRunning subProcessRunning : subProcessList) {
                    		String aSubProcessId= subProcessRunning.getSubProcessProcessId();
                            String mainNodeId= subProcessRunning.getMainNodeId();
                            BPMActivity normalActivity = process.getActivityById(mainNodeId);
                            String mainNodeName= normalActivity.getName();
                            BPMSeeyonPolicy normalPolicy = normalActivity.getSeeyonPolicy();
							if(subProcessRunning.getIsFinished()==1){
	                            String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummarySubject(aSubProcessId);
	                            canStepBack= false;
	                            msg= ResourceUtil.getString("workflow.validate.stepback.msg3",mainNodeName,subProcessSubject);//"上节点触发的子流程《"+sub
	                            break;
							}else if(null!=normal_nodes.get(mainNodeId) && "1".equals(normalPolicy.getNF())){
								int vouch = WorkFlowAppExtendInvokeManager.getAppManager(appName).getSummaryVouch(subProcessRunning.getSubProcessProcessId());
                                if (vouch == 1) {//核定通过了
                                    canStepBack = false;
                                    msg = ResourceUtil.getString("workflow.validate.stepback.msg4");//"该流程的子流程已核定通过，不能回退！";
                                    break;
                                }
							}
						}
                    }
                }
                if (canStepBack) {
                    if (result_str.equals("0")) {
                        Iterator<String> iterators = normal_nodes.keySet().iterator();
                        while (iterators.hasNext()) {
                            String normalNodeId = iterators.next();
                            BPMActivity normalActivity = process.getActivityById(normalNodeId);
                            BPMSeeyonPolicy normalPolicy = normalActivity.getSeeyonPolicy();
                            if(normalPolicy.getId().equals("vouch")){//表示遇到核定节点
                                canStepBack = false;
                                msg = ResourceUtil.getString("workflow.validate.stepback.msg5");//"该流程已核定通过，不能回退！";
                                break;
                            }else if( "edoc".equals(appName) ){//公文应用：校验节点权限的交换类型
                                if (Strings.isNotBlank(permissionAccount) && Strings.isNotBlank(configCategory)) {
                                    boolean isExChangeNode= workflowApiManager.isExchangeNode(configCategory, normalPolicy.getId(), Long.parseLong(permissionAccount));
                                    if (isExChangeNode) {
                                        canStepBack = false;
                                        msg = ResourceUtil.getString("workflow.validate.stepback.msg6");//"该流程已被交换类型的节点处理了，不能回退！";
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if(canStepBack){//查找与我并行的节点
                        if("1".equals(result_str)){//撤销，放入start节点信息
                            boolean[] results= findTheSpecialNodeDown(process.getStart(),theCase,currentNode.getId(),theCase.getProcessId());
                            if(results[0]){//fengfa
                                canStepBack= false;
                                msg= ResourceUtil.getString("workflow.validate.stepback.msg7");//"与当前节点并行的节点已封发，不能回退！";
                            }else if(results[1]){//vouch
                                canStepBack= false;
                                msg= ResourceUtil.getString("workflow.validate.stepback.msg8");//"与当前节点并行的节点已核定通过，不能回退！";
                            }else if(results[2]){//formaudit
                                canStepBack= false;
                                msg= ResourceUtil.getString("workflow.validate.stepback.msg9");//"与当前节点并行的节点已表单审核通过，不能回退！";
                            }else if(results[3]){//子流程已经结束了
                                canStepBack= false;
                                msg= ResourceUtil.getString("workflow.validate.stepback.msg10");//"与当前节点并行的节点触发的子流程已结束，不能回退！";
                            }else if(results[4]){//子流程已经结束了
                                canStepBack= false;
                                msg= ResourceUtil.getString("workflow.validate.stepback.msg4");//"与当前节点并行的节点触发的子流程已核定通过，不能回退！";
                            }
                        }else  if("0".equals(result_str)){
                            Iterator<String> iterators = normal_nodes.keySet().iterator();
                            while (iterators.hasNext()) {
                                String normalNodeId = iterators.next();
                                BPMActivity normalActivity = process.getActivityById(normalNodeId);
                                boolean[] results= findTheSpecialNodeDown(normalActivity,theCase,currentNode.getId(),theCase.getProcessId());
                                if(results[0]){//fengfa
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg7");//"与当前节点并行的节点已封发，不能回退！";
                                }else if(results[1]){//vouch
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg8");//"与当前节点并行的节点已核定通过，不能回退！";
                                }else if(results[2]){//formaudit
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg9");//"与当前节点并行的节点已表单审核通过，不能回退！";
                                }else if(results[3]){//子流程已经结束了
                                    canStepBack= false;
                                    msg= ResourceUtil.getString("workflow.validate.stepback.msg10");//"与当前节点并行的节点触发的子流程已结束，不能回退！";
                                }
                                if(!canStepBack){
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        String[] result= new String[2];
        result[0]= String.valueOf(canStepBack);
        result[1]= msg;
        return result;
    }
    
    /**
     * 
     * @param fromNode
     * @param theCase
     * @param currentNodeId
     * @param processId
     * @return
     * @throws BPMException
     */
    private boolean[] findTheSpecialNodeDown(BPMAbstractNode fromNode,BPMCase theCase,String currentNodeId,String processId) throws BPMException {
        boolean[] result = new boolean[5];
        result[0] = false;
        result[1] = false;
        result[2] = false;
        result[3] = false;
        result[4] = false;
        if ( BPMAbstractNode.NodeType.end.equals(fromNode.getNodeType()) || fromNode.getId().equals(currentNodeId) ) {
            return result;
        }
        boolean isInform = ObjectName.isInformObject(fromNode);//知会节点
        if (BPMAbstractNode.NodeType.humen.equals(fromNode.getNodeType())
                && !fromNode.getId().equals(currentNodeId) && !isInform) {
            boolean isDoing = WorkflowUtil.isThisState(theCase, fromNode.getId(), CaseDetailLog.STATE_READY,
                    CaseDetailLog.STATE_NEEDREDO_TOME, CaseDetailLog.STATE_SUSPENDED);
            boolean isDone = WorkflowUtil.isThisState(theCase, fromNode.getId(), CaseDetailLog.STATE_FINISHED,
                    CaseDetailLog.STATE_CANCEL, CaseDetailLog.STATE_STOP);
            if (isDoing) {//待办
                List<BPMHumenActivity> nodes= new ArrayList<BPMHumenActivity>();
                nodes.add((BPMHumenActivity)fromNode);
                List list= workItemManager.getWorItemListByStates(theCase.getId(), nodes, new Integer[]{WorkItem.STATE_FINISHED});
                if(null!=list && list.size()>0){
                    //该节点是否为表单审核和核定节点，如果是，则不允许回退到当前选择的节点
                    BPMSeeyonPolicy policy = fromNode.getSeeyonPolicy();
                    String policyId = policy.getId();
                    String nf = policy.getNF();
                    if (policyId.equals("fengfa")) {//被选择的节点与当前处理节点之间有已办的封发节点，不能选择
                        result[0] = true;
                        return result;
                    } else if (policyId.equals("vouch")) {//被选择的节点与当前处理节点之间有已办的核定节点，不能选择
                        result[1] = true;
                        return result;
//                    } else if (policyId.equals("formaudit")) {//被选择的节点与当前处理节点之间有已办的表单审核节点，不能选择
//                        result[2] = true;
//                        return result;
                    } else if ("1".equals(nf)) {//被选择的节点与当前处理节点之间有已办的节点，且触发了新流程，需要进一步判断
                        boolean isNFFinished = false;
                        List<SubProcessRunning> subProcessList = subProcessManager.getFinishedSubProcess(processId,fromNode.getId());
                        if (subProcessList.size() > 0) {
                            isNFFinished = true;
                        }
                        if (isNFFinished) {//子流程已经结束了，不能选择进行回退了
                            result[3] = true;
                            return result;
                        }
                    }
                }else{
                    //不再继续往后查找
                    return result;
                }
            } else if (isDone) {//已办
                //该节点是否为表单审核和核定节点，如果是，则不允许回退到当前选择的节点
                BPMSeeyonPolicy policy = fromNode.getSeeyonPolicy();
                String policyId = policy.getId();
                String nf = policy.getNF();
                if (policyId.equals("fengfa")) {//被选择的节点与当前处理节点之间有已办的封发节点，不能选择
                    result[0] = true;
                    return result;
                } else if (policyId.equals("vouch")) {//被选择的节点与当前处理节点之间有已办的核定节点，不能选择
                    result[1] = true;
                    return result;
//                } else if (policyId.equals("formaudit")) {//被选择的节点与当前处理节点之间有已办的表单审核节点，不能选择
//                    result[2] = true;
//                    return result;
                } else if ("1".equals(nf)) {//被选择的节点与当前处理节点之间有已办的节点，且触发了新流程，需要进一步判断
                    boolean isNFFinished = false;
                    List<SubProcessRunning> subProcessList = subProcessManager.getFinishedSubProcess(processId,fromNode.getId());
                    if (subProcessList.size() > 0) {
                        isNFFinished = true;
                    }
                    if (isNFFinished) {//子流程已经结束了，不能选择进行回退了
                        result[3] = true;
                        return result;
                    }else{//子流程未结束，核定通过了则不能选择进行回退了
                        List<String> nodeIds = new ArrayList<String>();
                        nodeIds.add(fromNode.getId());
                        List<SubProcessRunning> subList = subProcessManager
                                .getSubProcessRunningListByMainProcessId(processId, nodeIds, true, false);
                        for (SubProcessRunning subProcessRunning : subList) {
                            int vouch = WorkFlowAppExtendInvokeManager.getAppManager("collaboration").getSummaryVouch(
                                    subProcessRunning.getSubProcessProcessId());
                            if (vouch == 1) {//核定通过了
                                result[4] = true;
                                return result;
                            }
                        }
                    }
                }
            }
        }
        List<BPMTransition> downs = fromNode.getDownTransitions();
        if (null == downs) {
            return result;
        }
        for (BPMTransition down : downs) {
            BPMAbstractNode toNode= down.getTo();
            String isDelete= WorkflowUtil.getNodeConditionFromCase(theCase, toNode, "isDelete");
            if("false".equals(isDelete)){
                boolean[] result1 = findTheSpecialNodeDown(toNode,theCase,currentNodeId,processId);
                result[0] = (result[0] || result1[0]);//是否有封发节点
                result[1] = (result[1] || result1[1]);//是否有核定节点
                result[2] = (result[2] || result1[2]);//是否有表单审核节点
                result[3] = (result[3] || result1[3]);//是否有子流程结束的节点
                result[4] = (result[4] || result1[4]);//是否有子流程核定通过了
                if ( result[0] || result[1] || result[2] || result[3] || result[4]) {
                    return result;
                }
            }
        }
        return result;
    }

    private BPMAbstractNode goPreContinue(BPMAbstractNode fromNode) {
        BPMAbstractNode returnNode= null;
        if(fromNode.getNodeType()== BPMAbstractNode.NodeType.split){
            List ups= fromNode.getUpTransitions();
            BPMAbstractNode fromNodeNext= ((BPMTransition)ups.get(0)).getFrom();
            returnNode= goPreContinue(fromNodeNext);
        }else{
            returnNode= fromNode;
        }
        return returnNode;
    }

    @Override
    public String conditionToFieldName(String appName,String formApp, String condition) throws BPMException {
        boolean success = true;
        String result = condition;
        String errorMsg = "";
        if(Strings.isBlank(appName) || "collaboration".equals(appName)){
        	appName= "form";
        }
        //如果分支条件为空，也没有必要进行转换了
        if(result==null || "".equals(result.trim())){
            success = false;
            errorMsg = ResourceUtil.getString("workflow.label.msg.transConditionNull");//"需要转换的分支条件为空！";
            result = "";
        }else{
        	Map<String, WorkflowFormFieldVO> fieldMap= new HashMap<String, WorkflowFormFieldVO>();
        	if("form".equals(appName)){
        		fieldMap= WorkflowFormDataMapInvokeManager.getAppManager(appName).getFormFieldMap(formApp);
        		Pattern pattern = Pattern.compile("\\{([^{}]+)\\}");
                Matcher macher = pattern.matcher(condition);
                //如果分支条件中找到表单单元格的话，再去转换
                if(macher.find()){
                	if(null!=fieldMap && !fieldMap.isEmpty()){
                        //数据准备完毕，开始替换
                        StringBuffer sb = new StringBuffer();
                        do{
                            String display = macher.group(1);
                            WorkflowFormFieldVO field = fieldMap.get(display);
                            if(field!=null){
                                macher.appendReplacement(sb, field.getFieldName());
                            }else{
                                macher.appendReplacement(sb, display);
                            }
                        }while(macher.find());
                        macher.appendTail(sb);
                        result = sb.toString();
                    }
                }
        	}else if(ApplicationCategoryEnum.edocRec.name().equals(appName)
                    || ApplicationCategoryEnum.edocSend.name().equals(appName)
                    || ApplicationCategoryEnum.edocSign.name().equals(appName)
                    || "sendEdoc".equals(appName) 
                    || "recEdoc".equals(appName)
                    || "signReport".equals(appName)){
            		WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
                    if(validateManager!=null){
                    	fieldMap= validateManager.getFormFieldsDefinition(appName, formApp, new ArrayList<String>(), new ArrayList<String>());
                    }
                    if(null!=fieldMap && !fieldMap.isEmpty()){
                    	Set<String> fieldsSet= fieldMap.keySet();
                    	for (String field : fieldsSet) {
                    		WorkflowFormFieldVO fieldVO= fieldMap.get(field);
                    		result= result.replaceAll("\\{"+fieldVO.getDisplay()+"\\}", fieldVO.getFieldName());
    					}
                    }
        	}
        }
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", success);
        resultMap.put("result", result);
        resultMap.put("errorMsg", errorMsg);
        return JSONUtil.toJSONString(resultMap);
    }

    @Override
    public String conditionToFieldDisplay(String appName,String formApp, String condition) throws BPMException {
        boolean success = true;
        String result = condition;
        String errorMsg = "";
        if(Strings.isBlank(appName) || "collaboration".equals(appName)){
        	appName= "form";
        }
        //如果分支条件为空，也没有必要进行转换了
        if(result==null || "".equals(result.trim())){
            success = false;
            errorMsg = ResourceUtil.getString("workflow.label.msg.transConditionNull");//"需要转换的分支条件为空！";
            result = "";
        }else{
        	Map<String, WorkflowFormFieldVO> fieldMap= new HashMap<String, WorkflowFormFieldVO>();
        	if("form".equals(appName)){
	            fieldMap= WorkflowFormDataMapInvokeManager.getAppManager("form").getFormFieldMap(formApp);
	            if(null!=fieldMap && !fieldMap.isEmpty()){
	                result = WorkflowUtil.conditionToFieldDisplay(condition, fieldMap);
	            }
        	}else if(ApplicationCategoryEnum.edocRec.name().equals(appName)
                    || ApplicationCategoryEnum.edocSend.name().equals(appName)
                    || ApplicationCategoryEnum.edocSign.name().equals(appName)
                    || "sendEdoc".equals(appName) 
                    || "recEdoc".equals(appName)
                    || "signReport".equals(appName)){
        		WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
                if(validateManager!=null){
                	fieldMap= validateManager.getFormFieldsDefinition(appName, formApp, new ArrayList<String>(), new ArrayList<String>());
                }
                if(null!=fieldMap && !fieldMap.isEmpty()){
                	Set<String> fieldsSet= fieldMap.keySet();
                	for (String field : fieldsSet) {
                		WorkflowFormFieldVO fieldVO= fieldMap.get(field);
                		result= result.replaceAll(fieldVO.getFieldName(), "{"+fieldVO.getDisplay()+"}");
					}
                }
        	}
        }
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", success);
        resultMap.put("result", result);
        resultMap.put("errorMsg", errorMsg);
        return JSONUtil.toJSONString(resultMap);
    }

    @Override
    @AjaxAccess
    public String[] lockWorkflow(String processId, String currentUserId,int action , String useNowexpirationTime) throws BPMException {
        return processManager.lockWorkflowProcess( processId,  currentUserId, true, action, "", "true".equals(useNowexpirationTime));
    }
    @Override
    public String[] lockWorkflow(String processId, String currentUserId,int action) throws BPMException {
        return processManager.lockWorkflowProcess(processId, currentUserId,true,action);
    }

    @Override
    public String[] releaseWorkflow(String processId, String currentUserId) throws BPMException {
        return processManager.releaseWorkFlowProcessLock(processId, currentUserId);
    }

    @Override
    public String[] checkWorkflowLock(String processId, String currentUserId) throws BPMException {
        return processManager.lockWorkflowProcess(processId, currentUserId,false,-1);
    }
    
    @Override
    public String[] checkWorkflowLock(String processId, String currentUserId,int action) throws BPMException {
        return processManager.lockWorkflowProcess(processId, currentUserId,false,action);
    }

    @Override
    public String[] releaseWorkflow(String processId, String currentUserId, int action) throws BPMException {
        return processManager.releaseWorkFlowProcessLock(processId, currentUserId,action);
    }

    public String[] canWorkflowCurrentNodeSubmit(String workitemId) throws BPMException {
        return workflowApiManager.canWorkflowCurrentNodeSubmit(workitemId);
    }

    @Override
    public String[] getProcessTitleByAppNameAndProcessId(String appName, String processId) throws BPMException {
        String currentProcessTitle = "";
        WorkFlowAppExtendManager extendManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
        if(extendManager!=null){
            currentProcessTitle = extendManager.getSummarySubject(processId);
        }
        if(currentProcessTitle==null){
            currentProcessTitle = "";
        }
        return new String[]{currentProcessTitle};
    }

    @Override
    public String[] canSpecialStepBack(String workitemId) throws BPMException {
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(workitemId)){
            result[0]= "false";
            result[1]= "参数workitemId的值为空,不能进行指定回退操作,请检查canDoSpecialStepBack接口调用参数!";
            return result;
        }
        
        WorkItem myWorkItem= workItemManager.getWorkItemOrHistory(Long.parseLong(workitemId));
        if( null== myWorkItem ){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        int state= myWorkItem.getState();
        //当前人员任务事项状态已是指定回退
        if( state== WorkItem.STATE_SUSPENDED ){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        //当前人员任务事项状态是否是可以做指定回退的状态：就绪和被指定回退节点
        if( state != WorkItem.STATE_READY && state != WorkItem.STATE_NEEDREDO_TOME){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        //同节点的其他人员是否做了指定回退
        long myBatch= myWorkItem.getBatch();
        List<WorkitemDAO> sameBatchItemList = itemlist.getWorkItemByBatch(myBatch,new Integer[]{WorkitemInfo.STATE_SUSPENDED}, myWorkItem);
        if(null!=sameBatchItemList && sameBatchItemList.size()>0){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        //当前流程是否已经处于指定回退状态
        BPMCase theCase= caseManager.getCase(myWorkItem.getCaseId());
        int stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
        if(stepCount>0 && state != WorkItem.STATE_NEEDREDO_TOME){//流程处于指定回退状态了，但当前任务事项不是被指定回退状态，不可继续指定回退
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        if(theCase.getState()==CaseInfo.STATE_CANCEL || theCase.getState()==CaseInfo.STATE_STOP){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        return result;
    }

    @Override
    public String[] canTemporaryPending(String workitemId) throws BPMException {
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(workitemId)){
            result[0]= "false";
            result[1]= "参数workitemId的值为空,不能进行指定回退操作,请检查canTemporaryPending接口调用参数!";
            return result;
        }
        WorkItem myWorkItem= workItemManager.getWorkItemOrHistory(Long.parseLong(workitemId));
        if(null==myWorkItem){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        int state= myWorkItem.getState();
        //当前人员任务事项状态已是指定回退
        if( state== WorkItem.STATE_SUSPENDED ||  state== WorkItem.STATE_NEEDREDO_TOME){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        return result;
    }

    @Override
    public String[] canStopFlow(String caseId) throws BPMException {
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(caseId)){
            result[0]= "false";
            result[1]= "参数workitemId的值为空,不能进行指定回退操作,请检查canDoSpecialStepBack接口调用参数!";
            return result;
        }
        BPMCase theCase= caseManager.getCase(Long.parseLong(caseId));
        if(theCase.getState()==CaseInfo.STATE_CANCEL || theCase.getState()==CaseInfo.STATE_STOP){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        if(theCase!= null && Strings.isNotEmpty( theCase.getProcessId())){
        	
        	List<SubProcessRunning> subProcessRunnings = subProcessManager.getSubProcessRunningListBySubProcessId(  theCase.getProcessId(), null, null);
        	if(Strings.isNotEmpty(subProcessRunnings)){
        		for(SubProcessRunning sp : subProcessRunnings){
        			
        			BPMCase mainCase = caseManager.getCaseOrHistoryCaseByProcessId(sp.getMainProcessId());
        			int stepCount= mainCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(mainCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
        			
        			boolean isInSpecialStepBackStatus  = stepCount > 0 ;
        			
        			if(isInSpecialStepBackStatus){
        				result[0]= "false";
        				
        				/*主流程处于指定回退下，暂不能执行该操作*/
        				result[1]=ResourceUtil.getString("workflow.validate.workitem.stop.msg");
        				return result;
        			}
        			
        		}
        	}
        }
		return result;	
		
		
        
//        int stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
//        if(stepCount>0){//流程处于指定回退状态了，但当前任务事项不是被指定回退状态，不可继续指定回退
//            result[0]= "false";
//            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
//            return result;
//        }
    }

    @Override
    public String[] canChangeNode(String workitemId) throws BPMException {
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(workitemId)){
            result[0]= "false";
            result[1]= "参数workitemId的值为空,不能进行指定回退操作,请检查canTemporaryPending接口调用参数!";
            return result;
        }
        WorkItem myWorkItem= workItemManager.getWorkItemOrHistory(Long.parseLong(workitemId));
        if(null==myWorkItem){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        int state= myWorkItem.getState();
        //当前人员任务事项状态已是指定回退
        if( state== WorkItem.STATE_SUSPENDED ||  state== WorkItem.STATE_NEEDREDO_TOME){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.specialstepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
            return result;
        }
        BPMCase theCase = caseManager.getCase(myWorkItem.getCaseId());
        if(theCase.getState()==CaseInfo.STATE_CANCEL || theCase.getState()==CaseInfo.STATE_STOP){
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        return result;
    }

    @Override
    public String[] validateFormTemplate(String appName, String formApp, String processXML, String subProcessJson) throws BPMException {
        List<SubProcessSetting> subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
        if(subList==null){
            subList = new ArrayList<SubProcessSetting>();
        }
        String[] result = workFlowDesignerManager.validateTemplateXml(appName, processXML,formApp, formApp, subList);
        if(result!=null && result.length>=3){ 
            result[2] = "";
        }
        return result;
    }

    @Override
    public String[] selectProcessTemplateXMLForClone(String appName, String templateIdString, String formAppString,
            String oldWendanId, String newWendanId, String subProcessJson) throws BPMException {
        return workflowApiManager.selectProcessTemplateXMLForClone(appName, templateIdString, formAppString, oldWendanId, newWendanId, subProcessJson);
    }
    
    @Override
    public String[] validateProcessTemplateXMLForEgg(String appName, String workflowId,String myProcessXml, String formAppId,
            String formId, String startDefaultOperationId, String normalDefaultOperationId,String subProcessJson) throws BPMException{
        return workflowApiManager.validateProcessTemplateXMLForEgg(appName, workflowId,myProcessXml, formAppId, formId, startDefaultOperationId, normalDefaultOperationId, subProcessJson);
    }

    @Override
    public String[] getAcountExcludeElements() throws BPMException {
        String[] selectType= workFlowDesignerManager.getAcountExcludeElements();
        return selectType;
    }
    
    public String[] isExchangeNode(String appName, String policyId, String permissionAccount) throws BPMException {
        String[] result= new String[]{"false",""};
        boolean isExhange= workflowApiManager.isExchangeNode(appName, policyId, Long.parseLong(permissionAccount));
        result[0]= String.valueOf(isExhange);
        return result;
    }

    @Override
    public String[] validateCanAddNode(String processId,String caseId, String activityId, String processXml_supervise)
            throws BPMException {
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(processId) || Strings.isBlank(activityId)){
            result[0]= "false";
            return result;
        }
        BPMProcess process= null;
        if(Strings.isNotBlank(processXml_supervise)){
            process= BPMProcess.fromXML(processXml_supervise);
        }else{
            process= processManager.getRunningProcess(processId);
        }
        BPMActivity currentClickNode= process.getActivityById(activityId);
        List<BPMHumenActivity> childs= WorkflowUtil.getChildHumens(currentClickNode,false);
        BPMCase theCase= caseManager.getCase(Long.parseLong(caseId));
        boolean isCanAdd= true;
        for (BPMHumenActivity bpmHumenActivity : childs) {
            boolean isThisState= WorkflowUtil.isThisState(theCase, bpmHumenActivity.getId(), 0,1);
            if(!isThisState){
                isCanAdd= false;
                break;
            }
        }
        result[0]= String.valueOf(isCanAdd);
        return result;
    }

	@Override
	public String[] getHandSelectOptions(String processXml,
			String currentNodeId, String defaultHst) {
//		String[] result= new String[]{"false","该节点处无手动分支，不可选择！"};
		String[] result= new String[]{"false",ResourceUtil.getString("workflow.matchResult.msg7")};
        BPMProcess bpmProcess= BPMProcess.fromXML(processXml);
        int hsn= workflowApiManager.getHandSelectOptionsNumber(bpmProcess, currentNodeId, defaultHst);
        boolean isPreSplit = WorkflowUtil.preIsSplitNode(bpmProcess.getActivityById(currentNodeId));
        if(isPreSplit==true){
        	result[0] = "false";
//        	result[1] = "前方已经存在发散节点，本节点不允许设置手工分支可选数！";
        	result[1] = ResourceUtil.getString("workflow.matchResult.msg8");
        	return result;
        }
        if(hsn>0){
            result[0]= "true";
            StringBuffer sb= new StringBuffer();
            sb.append(ResourceUtil.getString("workflow.matchResult.msg3"));
            sb.append(":&nbsp;&nbsp;&nbsp;<select id='hs_type' name='hs_type'>");
            String msg = ResourceUtil.getString("workflow.matchResult.msg4");
            for(int i=0;i<=hsn;i++){
                if(i==0){
                    if(defaultHst.equals(String.valueOf(i))){
                        sb.append("<option selected value='").append(i).append("'>").append(msg).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>");
                    }else{
                        sb.append("<option value='").append(i).append("'>").append(msg).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>");
                    }
                }else{
                    if(defaultHst.equals(String.valueOf(i))){
                        sb.append("<option selected value='").append(i).append("'>").append(i).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>");
                    }else{
                        sb.append("<option value='").append(i).append("'>").append(i).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>");
                    }
                }
            }
            sb.append("</select>");
            result[1]= sb.toString();
        }
        return result;
	}
	
	@Override
    public boolean isCanPasteAndReplaceNode(String copyNodeId, String currentNodeId, String processXml) {
        boolean result= false;
        BPMProcess bpmProcess= BPMProcess.fromXML(processXml);
        BPMActivity currentNode= bpmProcess.getActivityById(currentNodeId);
        BPMActivity copyNode= bpmProcess.getActivityById(copyNodeId);
        Map<String,BPMAbstractNode> map= new HashMap<String, BPMAbstractNode>();
        BPMActivity copyFromNode= null;
        if( Strings.isNotBlank(copyNode.getCopyFrom()) && !"null".equals(copyNode.getCopyFrom()) && !"undefined".equals(copyNode.getCopyFrom())){
            copyFromNode= bpmProcess.getActivityById(copyNode.getCopyFrom());
        }
        if( null!= copyFromNode){
            result= isMyParentNode(copyFromNode,currentNode,map);
        }else{
            result= isMyParentNode(copyNode,currentNode,map);
        }
        return result;
    }
    
    private boolean isMyParentNode(BPMAbstractNode copyNode, BPMAbstractNode currentNode, Map<String,BPMAbstractNode> map) {
        boolean isParent= false;
        if(null!= map.get(copyNode.getId())){
            return isParent;
        }
        if(copyNode.getNodeType().equals(BPMAbstractNode.NodeType.end)){
            return isParent;
        }
        map.put(copyNode.getId(), copyNode);
        if(copyNode.getId().equals(currentNode.getId())){
            isParent= true;
            return isParent;
        }
        List<BPMTransition> downs= copyNode.getDownTransitions();
        for (BPMTransition down : downs) {
            BPMAbstractNode toNode= down.getTo();
            boolean isMyParent= isMyParentNode(toNode, currentNode, map);
            if(isMyParent){
                isParent= true;
                break;
            }
        }
        return isParent;
    }

	public Map<String, List<? extends Object>> getNeedRepalceTemplateList(WorkflowReplaceVO vo,String appName) throws BPMException{
		Map<String, List<? extends Object>> result = new HashMap<String, List<? extends Object>>(2);
		List<String> head = new ArrayList<String>(0);
    	List<Map<String, Object>> body = new ArrayList<Map<String, Object>>(0);
    	User user = AppContext.getCurrentUser();
    	List<CtpTemplateVO> templateList = null;
    	boolean flag = true;//true显示表单名称， false显示状态。
    	if(ApplicationCategoryEnum.collaboration.name().equals(appName)){
    		flag = false;
    		head = new ArrayList<String>(4);
    		head.add(ResourceUtil.getString("workflow.replaceNode.35"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.42"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.37"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.38"));
    		if(user.isAdmin()){
    			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.collaboration);
    		}else{
    			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),user.getId(), user.getLoginAccount(), vo, ApplicationCategoryEnum.collaboration);
    		}
    	} else if (ApplicationCategoryEnum.form.name().equals(appName)){
    		flag = true;
    		head = new ArrayList<String>(4);
    		head.add(ResourceUtil.getString("workflow.replaceNode.35"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.36"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.37"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.38"));
    		if(user.isAdmin()){
    			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.form);
    		}else{
    			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),user.getId(), user.getLoginAccount(), vo, ApplicationCategoryEnum.form);
    		}
    	} else if (ApplicationCategoryEnum.edoc.name().equals(appName)){
    		flag = false;
    		head = new ArrayList<String>(4);
    		head.add(ResourceUtil.getString("workflow.replaceNode.35"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.42"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.37"));
    		head.add(ResourceUtil.getString("workflow.replaceNode.38"));
    		templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.edocSend, 
    				ApplicationCategoryEnum.edocRec, ApplicationCategoryEnum.edocSign);
    	}
    	if(templateList!=null && templateList.size()>0){
    		body = new ArrayList<Map<String, Object>>(templateList.size());
    		Map<String, Object> temp = null;
    		List<Long> ccIdList = new ArrayList<Long>(templateList.size());
    		//此事vo的formId保存的还是contantall的id
    		for(CtpTemplateVO vo1 : templateList){
    			if(vo1.getFormId()!=null){
    				ccIdList.add(vo1.getFormId()); 
    			}
    		}
    		String ccsql = "from CtpContentAll cc where cc.id in(:ids)";
    		Map<String, Object> ccparam = new HashMap<String, Object>();
    		ccparam.put("ids", ccIdList);
    		List<CtpContentAll> ccresult = new ArrayList<CtpContentAll>();
    		if(Strings.isNotEmpty(ccIdList)){
    			ccresult = DBAgent.find(ccsql, ccparam);
    		}
    		Map<Long, CtpContentAll> ccMap = new HashMap<Long, CtpContentAll>(ccresult.size());
    		if(ccresult!=null && ccresult.size()>0){
    			for(CtpContentAll cc : ccresult){
    				ccMap.put(cc.getId(), cc);
    			}
    		}
    		for(CtpTemplateVO t : templateList){
				try {
					CtpTemplateCategory c = templateManager.getCtpTemplateCategory(t.getCategoryId());
					if(c!=null){
	                    t.setMuduleTypeName(c.getName());
	                    t.setCategoryName(c.getName());
	                    if(t.getFormId()!=null){
	        				CtpContentAll cc = ccMap.get(t.getFormId());
	        				if(cc!=null){
	        					if(null!=cc.getContentTemplateId() &&(cc.getContentTemplateId()>0 || cc.getContentTemplateId()<-1)){
	        						if(t.getFormId()!=null){
	        	                        String formName= WorkflowFormDataMapInvokeManager.getAppManager("form").getFormName(cc.getContentTemplateId());
	        	                        if(Strings.isNotBlank(formName)){
	        	                            t.setFormName(formName);
	        	                        }
	        	                        t.setFormId(cc.getContentTemplateId());
	        	                    }
	        					}else{
	        						t.setFormId(0L);
	        					}
	        				}
	                    }
	                }
	    			//状态，启用和停用
	    			if(!flag){
						if(t.getState()==1){
							t.setFormName(ResourceUtil.getString("common.state.invalidation.label"));
						}else if(t.getState()==0){
							t.setFormName(ResourceUtil.getString("common.state.normal.label"));
						}
	    			}
	    			temp = new HashMap<String, Object>();
	    			temp.put("id", t.getWorkflowId().toString());
	    			temp.put("name", t.getSubject());
	    			temp.put("formname", t.getFormName()==null?"":t.getFormName());
	    			temp.put("formApp", t.getFormId()==null?"":t.getFormId().toString());
	    			temp.put("ownerId", t.getOwnerId().toString());
	    			String ownerName = "";
					com.seeyon.ctp.workflow.vo.User owner = processOrgManager.getUserById(t.getOwnerId().toString(), false);
					if(owner!=null){
						ownerName = owner.getName();
					}
	    			temp.put("muduleMemberName", ownerName);
	    			temp.put("muduleTypeName", t.getMuduleTypeName());
	    			temp.put("moduleType", t.getModuleType().toString());
	    			body.add(temp);
				} catch (BusinessException e) {
					logger.error("",e);
					throw new BPMException("",e);
				}
    		}
    	}
		result.put("head", head);
		result.put("body", body);
    	return result;
    }
    
    @Override
	public int repalceTemplateList(List<String> idList,
			WorkflowReplaceVO vo, String appName) throws BPMException {
    	int count = 0;
		List<Long> idLongList = null;
    	if(idList==null || idList.size()==0){
        	User user = AppContext.getCurrentUser();
        	List<CtpTemplateVO> templateList = null;
        	if(ApplicationCategoryEnum.collaboration.name().equals(appName)){
        		if(user.isAdmin()){
        			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.collaboration);
        		}else{
        			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),user.getId(), user.getLoginAccount(), vo, ApplicationCategoryEnum.collaboration);
        		}
        	} else if (ApplicationCategoryEnum.form.name().equals(appName)
        	        || "simulation".equals(appName)){//流程仿真
        		if(user.isAdmin()){
        			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.form);
        		}else{
        			templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),user.getId(), user.getLoginAccount(), vo, ApplicationCategoryEnum.form);
        		}
        	} else if (ApplicationCategoryEnum.edoc.name().equals(appName)){
        		templateList = workFlowReplaceNodeManager.getNeedRepalceTemplateList(user.getId(),null, user.getLoginAccount(), vo, ApplicationCategoryEnum.edocSend, 
        				ApplicationCategoryEnum.edocRec, ApplicationCategoryEnum.edocSign);
        	}
        	if(templateList!=null && templateList.size()>0){
        		idLongList = new ArrayList<Long>(templateList.size());
        		for(CtpTemplateVO t : templateList){
        			idLongList.add(t.getWorkflowId());
        		}
        	}
    	}else{
    		idLongList = new ArrayList<Long>(idList.size());
    		for(String id : idList){
    			idLongList.add(Long.parseLong(id));
    		}
    	}
		if(idLongList!=null && idLongList.size()>0){
			count = workFlowReplaceNodeManager.saveRepalceNodeList(appName, AppContext.getCurrentUser(), idLongList, vo);
			List<String> formIdStrings = vo.getFormIds();
			if(formIdStrings!=null && formIdStrings.size()>0){
				List<Long> formIds = new ArrayList<Long>();
				for(String idString : formIdStrings){
					try{
						formIds.add(Long.parseLong(idString));
					}catch(NumberFormatException e){}
				}
				if(formIds.size()>0){
					workFlowReplaceNodeManager.updateFormModifyTime(formIds, new Date());
				}
			}
		}
		return count;
	}

	@Override
	public Map<String, Object> updateTemplateList(String templateId, String formApp, String processXml)
			throws BPMException {
		return updateTemplateList("", templateId, formApp, processXml,"");
	}

	@Override
	public String getUnenabledEntity(String key)
			throws BPMException {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		if(key!=null && key.trim().length()==0){
			return "{}";
		}
		User cu = AppContext.getCurrentUser();
		try {
			//List<V3xOrgMember> members = orgManagerDirect.getAllMembers(cu.getLoginAccount(), true);
		    List<? extends V3xOrgEntity > members = orgManagerDirect.getUnenabledEntities(V3xOrgMember.class.getSimpleName(), cu.getLoginAccount());
			addNotValidatePeople(members, result, key);
			//List<V3xOrgAccount> accounts = orgManagerDirect.getAllAccounts(false, true, "", null, null);
			List<? extends V3xOrgEntity > accounts = orgManagerDirect.getUnenabledEntities(V3xOrgAccount.class.getSimpleName(), null);
			//List<V3xOrgDepartment> outAccounts = orgManagerDirect.getAllDepartments(cu.getLoginAccount(), false, false, null, null, null);
			//addNotValidatePeople(outAccounts, result, key);
			addNotValidatePeople(accounts, result, key);
			//List<V3xOrgDepartment> deps = orgManagerDirect.getAllDepartments(cu.getLoginAccount(), false, true, null, null, null);
			List<? extends V3xOrgEntity > deps = orgManagerDirect.getUnenabledEntities(V3xOrgDepartment.class.getSimpleName(), cu.getLoginAccount());
			addNotValidatePeople(deps, result, key);
			//List<V3xOrgLevel> levels = orgManagerDirect.getAllLevels(cu.getLoginAccount(), true);
			List<? extends V3xOrgEntity > levels= orgManagerDirect.getUnenabledEntities(V3xOrgLevel.class.getSimpleName(), cu.getLoginAccount());
			addNotValidatePeople(levels, result, key);
			//List<V3xOrgPost> posts = orgManagerDirect.getAllPosts(cu.getLoginAccount(), true);
			List<? extends V3xOrgEntity > posts= orgManagerDirect.getUnenabledEntities(V3xOrgPost.class.getSimpleName(), cu.getLoginAccount());
			addNotValidatePeople(posts, result, key);
			//List<V3xOrgRole> roles = orgManagerDirect.getAllRoles(cu.getLoginAccount(), true);
//			List<? extends V3xOrgEntity > roles= orgManagerDirect.getUnenabledEntities(V3xOrgRole.class.getSimpleName(), cu.getLoginAccount());
			List<V3xOrgRole> roles = orgManagerDirect.getAllRoles(cu.getLoginAccount(), true);
			addNotValidatePeople(roles, result, key);
			//List<V3xOrgTeam> teams = orgManagerDirect.getAllTeams(cu.getLoginAccount(), true);
			List<? extends V3xOrgEntity > teams= orgManagerDirect.getUnenabledEntities(V3xOrgTeam.class.getSimpleName(), cu.getLoginAccount());
			addNotValidatePeople(teams, result, key);
		} catch (BusinessException e) {
			throw new BPMException(e);
		}
		return JSONUtil.toJSONString(result);
	}
	
	private void addNotValidatePeople(List<? extends V3xOrgEntity> entitys,List<Map<String, Object>> result, String key){
		String id = "id";
		String name = "name";
		String type = "type";
		String typeName = "typeName";
		String accountShortName = "accountShortName";
		if(key!=null && key.trim().length()>0){
			if(entitys!=null && entitys.size()>0){
				for(V3xOrgEntity entity : entitys){
					//无效的、被删除的等等全部放在里边， satus=0表示不显示在选人界面
					if( entity != null 
						&& (!entity.isValid() 
								|| (entity instanceof V3xOrgRole && Integer.valueOf(0).equals(((V3xOrgRole)entity).getStatus()))
						    )){
						boolean isFind= false;
						String entityName= entity.getName();
						if(entity instanceof V3xOrgRole){
							V3xOrgRole role= (V3xOrgRole)entity;
							if(role.getShowName()!=null && role.getShowName().indexOf(key)>-1){
								isFind= true;
								entityName= role.getShowName();
							}
						}
						if(!isFind && !(entity instanceof V3xOrgRole)){
							if(entity.getName() != null && entity.getName().indexOf(key)>-1){
								isFind= true;
							}
						}
					    if(!isFind){
					    	continue;
					    }
						String tempType = entity.getEntityType(); 
		                String tempTypeName = ResourceUtil.getString("workflow.branchGroup.7");//"人员";
		                String accountShortNameName = "";
		                boolean isRole = false;
		                V3xOrgAccount account = null;
		                if(ORGENT_TYPE.Member.name().equals(tempType)){
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.7");//"人员";
		                } else if(ORGENT_TYPE.Department.name().equals(tempType)) {
		                    V3xOrgDepartment d = (V3xOrgDepartment)entity;
		                    if(d.getIsInternal()){
		                        tempTypeName = ResourceUtil.getString("workflow.branchGroup.2");//"部门";
		                    }else{
		                        tempTypeName = ResourceUtil.getString("workflow.branchGroup.1.4");//"外部单位";
		                    }
		                    
		                } else if(ORGENT_TYPE.Team.name().equals(tempType)) {
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.6");//"组";
		                } else if(ORGENT_TYPE.Account.name().equals(tempType)) {
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.1");//"单位";
		                } else if(ORGENT_TYPE.Role.name().equals(tempType)) {
		                    isRole = true;
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.5");//"角色";
		                } else if(ORGENT_TYPE.Post.name().equals(tempType)) {
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.4");//"岗位";
		                } else if(ORGENT_TYPE.Level.name().equals(tempType)) {
		                    tempTypeName = ResourceUtil.getString("workflow.branchGroup.3");//"职务级别";
		                }
						Map<String, Object> map = new HashMap<String, Object>();
						if(isRole){
							V3xOrgRole role = (V3xOrgRole)entity;
							String code = role.getCode();
							if ("DepManager".equals(code)//部门主管
				            	||"AccountManager".equals(code)//单位主管
								||"AccountAdmin".equals(code)//单位管理员
								||"DepLeader".equals(code)//部门分管领导
								||"HrAdmin".equals(code)//HR管理员
								||"FormAdmin".equals(code)//表单管理员
								||"SalaryAdmin".equals(code)){//工资管理员
								map.put(id, role.getCode());
							}else{
								map.put(id, role.getId().toString());
							}
							map.put(name, entityName);
						} else {
							map.put(id, entity.getId().toString());
							map.put(name, entityName); 
						}
						map.put(type, entity.getEntityType());
						map.put(typeName, tempTypeName);
						try {
							account = processOrgManager.getAccountById(String.valueOf(entity.getOrgAccountId()));
							if(account!=null){
								accountShortNameName = account.getShortName();
								if(accountShortNameName==null || "".equals(accountShortNameName.trim())){
									accountShortNameName = account.getName();
								}
							}
						} catch (BPMException e) {}
						map.put(accountShortName, accountShortNameName);
						result.add(map);
					}
				}
			}
		}
	}

	@Override
	public String[] getEditTemplateParams(String appName, String formId,
			String workflowId, String moduleType, WorkflowReplaceVO vo) throws BPMException {
		String[] result = new String[14];
		User cu = AppContext.getCurrentUser();
		result[0] = appName;
		result[1] = "0".equals(formId)?"":formId;
		result[3] = workflowId;
		result[5] = cu.getId().toString();
		result[6] = cu.getName();
		result[7] = cu.getLoginAccountName();
		result[8] = cu.getLoginAccount().toString();
		String configCategory = "";
		if (ApplicationCategoryEnum.collaboration.name().equals(appName)) {
			configCategory = EnumNameEnum.col_flow_perm_policy.name();
		} else if (ApplicationCategoryEnum.form.name().equals(appName)){
			configCategory = EnumNameEnum.col_flow_perm_policy.name();
			result[0] = ApplicationCategoryEnum.collaboration.name();
			String formName= WorkflowFormDataMapInvokeManager.getAppManager("form").getFormName(Long.parseLong(formId));
			result[2] = formName;
			String startViewId= WorkflowFormDataMapInvokeManager.getAppManager("form").getStartFormViewId(Long.parseLong(formId));
			String nomorlViewId= WorkflowFormDataMapInvokeManager.getAppManager("form").getNormalFormViewId(Long.parseLong(formId));
			result[9] = nomorlViewId;
			result[10] = startViewId;
		} else if (ApplicationCategoryEnum.edoc.name().equals(appName)){
			if("19".equals(moduleType)){
				configCategory = EnumNameEnum.edoc_send_permission_policy.name();
				result[0] = ApplicationCategoryEnum.edocSend.name();
			} else if("20".equals(moduleType)){
				configCategory = EnumNameEnum.edoc_rec_permission_policy.name();
				result[0] = ApplicationCategoryEnum.edocRec.name();
			} else if("21".equals(moduleType)){
				configCategory = EnumNameEnum.edoc_qianbao_permission_policy.name();
				result[0] = ApplicationCategoryEnum.edocSign.name();
			} else {
				result[4] = "shenpi";
				result[11] = ResourceUtil.getString("node.policy."+result[4]);
			}
			result[12] = getWendanIdByWorkflowId(workflowId, true);
		}
		try {
			if (Strings.isNotBlank(configCategory)) {
				PermissionVO permiss = permissionManager.getDefaultPermissionByConfigCategory(configCategory,cu.getLoginAccount());
				if (permiss != null) {
					result[4] = permiss.getName();
					result[11] = permiss.getLabel();
				}
			}
		} catch (BusinessException e) {
			logger.error("节点查找替换获取默认节点出错!", e);
		}
		
		if(workflowId!=null && !"".equals(workflowId.trim())){
			ProcessTemplete t = processTemplateManager.selectProcessTempate(workflowId);
			if(t!=null){
				BPMProcess process = BPMProcess.fromXML(t.getWorkflow());
				if(process!=null){
					result[13] = WorkFlowNodeReplaceUtil.validateBeforeReplace(process, vo);
				}
			}
		}
		return result;
	}

    @SuppressWarnings("unchecked")
	@Override
	public String getWendanIdByWorkflowId(String workflowId, boolean isSystem)
    throws BPMException {
        String result = "-1";
        WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(ApplicationCategoryEnum.edocRec.name());
        if(validateManager!=null){
            result = validateManager.getFormIdByWorkflowId(workflowId);
            if(result==null){
                result = "-1";
            }
        }
		return result;
	}

	@Override
    public String[] changeCaseProcess(String str, String[] idArr, String[] typeArr, String[] nameArr,
            String[] accountIdArr, String[] accountShortNameArr, String[] selecteNodeIdArr, String[] _peopleArr,
            String[] condition, String[] nodes, boolean iscol, String[] userExcludeChildDepartmentArr,
            String processXml, String orginalReadyObjectJson, String oldProcessLogJson) throws BPMException {
        return this.changeCaseProcess(str, idArr, typeArr, nameArr, accountIdArr, accountShortNameArr,
                selecteNodeIdArr, _peopleArr, condition, nodes, iscol, userExcludeChildDepartmentArr, 
                processXml, orginalReadyObjectJson, oldProcessLogJson, null, null);
    }
    
    @Override
    public String executeWorkflowBeforeEvent(String event, WorkflowBpmContext context) {
        try {
        	this.removeWorkflowMatchResultCache(context.getMatchRequestToken());
            return this.executeWorkflowBeforeEventInner(event, context);
        }catch (Exception e) {
            logger.error("执行流程事件前事件异常！", e);
        }
        return "";
    }
    
    private String executeWorkflowBeforeEventInner(String event, WorkflowBpmContext context) {
        try {
            if(context.isFreeFlow()){//自由流程不执行事件
                return "";
            }
            String appName= context.getAppName();
            String formAppId= context.getFormAppId();
            String formId= context.getFormId();
            String formOperationId= context.getFormOperationId();
            if((WorkflowUtil.isLong(formAppId) && WorkflowUtil.isLong(formOperationId))
            		|| WorkflowUtil.isLong(context.getFormData())){ 
            	appName= "form";
            }
        	if(WorkflowEventManager.getWfEventManagerMap(appName) == null 
        			|| WorkflowEventManager.getWfEventManagerMap(appName).isEmpty()){
                return "";
            }
            String processId = context.getProcessId();
            String processTemplateId = context.getProcessTemplateId();
            String currentNodeId = context.getCurrentActivityId();
            currentNodeId= (Strings.isBlank(currentNodeId) || "-1".equals(currentNodeId) || "0".equals(currentNodeId))?"start":currentNodeId;
            
            context.setCurrentActivityId(currentNodeId);
            if(WorkflowUtil.isLong(formAppId) && WorkflowUtil.isLong(formOperationId)){ 
            	context.setAppName("form");
	        }else if("form".equals(appName)){//表单才走下面的逻辑
	        	 String processXml= context.getProcessXml();
	        	 Object[] processObj= WorkflowUtil.doInitBPMProcessForCache(context.getMatchRequestToken(),processXml, processId, processTemplateId, currentNodeId);
            	 BPMProcess process = null;
            	 if(null!=processObj && null!=processObj[0]){
            		 process=  (BPMProcess)processObj[0];
            	 }
                 if (null == process) {
                     logger.info("根据参数processId[" + processId + "],processTemplateId[" + processTemplateId
                             + "]查不到对应的流程XML");
                     return "";
                 }
                 context.setProcess(process);
                 BPMAbstractNode currentActivity = null;
                 if("start".equals(currentNodeId)){
                     currentActivity = process.getStart();
                 } else {
                     currentActivity = process.getActivityById(currentNodeId);
                 }
                 BPMSeeyonPolicy currentPolicy = currentActivity.getSeeyonPolicy();
                 formAppId= currentPolicy.getFormApp();
                 formId= currentPolicy.getForm();
                 formOperationId= currentPolicy.getOperationName();
                 context.setFormAppId(formAppId);
                 context.setFormId(formId);
                 context.setFormOperationId(formOperationId);
            }
            WorkflowUtil.doInitFormDataForCache(context, formAppId);
            return WorkflowEventExecute.execute(event, context);
        }catch (Exception e) {
            logger.error("执行流程事件前事件异常！", e);
        }
        return "";
    }

    @Override
    public String exeWorkflowBeforeEvent(String event, String bussinessId, String affairId, String processTemplateId,
            String processId, String activityId, String formData, String appName) {
        WorkflowBpmContext context = new WorkflowBpmContext();
        context.setBussinessId(bussinessId);
        context.setAffairId(affairId);
        context.setProcessTemplateId(processTemplateId);
        context.setProcessId(processId);
        context.setCurrentActivityId(activityId);
        context.setFormData(formData);
        context.setAppName(appName);
        return executeWorkflowBeforeEvent(event, context);
    }

    @Override
    public Map<String, Object> updateTemplateList(String appName, String templateId, String formApp, String processXml,String workflowRule)
            throws BPMException {
        Map<String, Object> result = new HashMap<String, Object>(2);
        boolean success = true;
        String msg = "";
        if(templateId!=null && processXml!=null && !"".equals(processXml.trim())){
            BPMProcess process = BPMProcess.fromXML(processXml);
            if(process==null){
                success = false;
                msg = "ProcessXML is illegal！";//ProcessXML不合法
            }else{
                List<BPMAbstractNode> nodes = process.getActivitiesList();//WorkflowUtil.findAllChildHumenActivitys(process.getStart());
                if(nodes!=null && nodes.size()>0){
                    boolean formFlag = false;
                    if(WorkflowUtil.isLong(formApp)){
                        formFlag= WorkflowFormDataMapInvokeManager.getAppManager("form").isForm(formApp);
                        appName= "form";
                    }
                    for(BPMAbstractNode node : nodes){
                        if(node.getNodeType().equals(BPMAbstractNode.NodeType.humen)){
                            String[] vr = workFlowDesignerManager.validateOrganisation(node, formApp);
                            if(!"true".equals(vr[0])){
                                success = false;
                                msg = vr[1];
                                break;
                            }
                        }
                    }
                    if(success){
                        ProcessTemplete t = processTemplateManager.selectProcessTempate(templateId);
                        t.setWorkflow(processXml);
                        t.setWorkflowRule(workflowRule);
                        List<ProcessTemplete> tlist = new ArrayList<ProcessTemplete>(1);
                        tlist.add(t);
                        processTemplateManager.updateProcessTemplate(tlist);
                        if(Strings.isNotBlank(appName)){
                            AppLogAction appLogAction = AppLogAction.Coll_Template_Edit;
                            if("form".equals(appName)){
                                appLogAction = AppLogAction.Form_Edit;
                            }else if ("edoc".equals(appName) || "edocSend".equals(appName) || "sendEdoc".equals(appName) || "recEdoc".equals(appName)
                                    || "signReport".equals(appName)){
                                appLogAction = AppLogAction.Edoc_Templete_Update;
                            }
                            appLogManager.insertLog(AppContext.getCurrentUser(), appLogAction, AppContext.getCurrentUser().getName(), t.getProcessName());
                        }
                        //更新模板的修改时间
                        try {
							CtpTemplate ct = templateManager.getCtpTemplateByWorkFlowId(t.getId());
							ct.setModifyDate(new Date());
							templateManager.updateCtpTemplate(ct);
						} catch (BusinessException e) {//更新失败也无妨，感觉不应该抛出异常，影响正常功能的使用
							throw new BPMException(e);
						}
						//如果是表单的话，修改表单的修改时间
						if(formFlag){
							workFlowReplaceNodeManager.updateFormModifyTime(Long.parseLong(formApp), new Date());
						}
						try {
                            updatePermissinRef(appName, processXml, AppContext.getCurrentUser().getLoginAccount());
                        } catch (BusinessException e) {
                            logger.warn("更新节点权限引用异常!",e);
                        }
                    }
                }else{
                    success = false;
                    msg = ResourceUtil.getString("workflow.label.msg.haveNoNode");//"流程中没有节点！";
                }
            }
        }
        result.put("success", success);
        result.put("msg", msg);
        return result;
    }
    
    /**
     * 
     * @param processXml
     * @return
     */
    public FlashProcessNodePositionVO analysisProcessDataForFlash(String processXml,String caseId,boolean isForce){
        //计算位置
        CalculateProcessNodePosition caculate= new CalculateProcessNodePosition();
        FlashProcessNodePositionVO vo= caculate.analysisProcessDataForFlash(processXml,caseId,isForce);
        return vo;
    }
	
	/**
     * 校验模版流程是否有问题
     * @param templateId
     * @return
     * @throws BusinessException
     */
    @AjaxAccess
    public String validateWFTemplete(String templateId) throws BPMException{
    	return workFlowDesignerManager.validateTemplete(templateId, "");
    }

	@Override
	public void removeWorkflowMatchResultCache(String key) throws BPMException {
		workFlowMatchUserManager.removeWorkflowMatchResult(key);
	}

	public void setWorkFlowMatchUserManager(WorkFlowMatchUserManager workFlowMatchUserManager) {
		this.workFlowMatchUserManager = workFlowMatchUserManager;
	}

	@Override
	public String[] lockWorkflowForStepBack(WorkflowBpmContext context, int action,String event,String permissionAccount,String configCategory) throws BPMException {
		String processId= context.getProcessId();
		String matchRequestToken= context.getMatchRequestToken();
		long caseIdLong= context.getCaseId();
		String caseId= caseIdLong+"";
		long workitemIdLong= context.getCurrentWorkitemId();
		String workitemId= workitemIdLong+"";
		String currentUserId= context.getCurrentUserId();
		String currentActivityId= context.getCurrentActivityId();
		this.removeWorkflowMatchResultCache(matchRequestToken);
		//第一步：判断是否可以获取流程锁
		String[] result= this.lockWorkflow(processId, currentUserId, action);
		//第二步：判断是否可以回退
		if("true".equals(result[0])){
			result= this.canStepBack(matchRequestToken, workitemId, caseId, processId, currentActivityId, permissionAccount, configCategory);
		}
		//第三步：执行回退前拦截事件
		if("true".equals(result[0])){
			String processTemplateId= context.getProcessTemplateId();
			if(Strings.isNotBlank(processTemplateId) && Strings.isNotBlank(processId)){//模板流程才有高级事件拦截
				String eventMsg= this.executeWorkflowBeforeEventInner(event, context);
				String[] eventMsgResult= new String[]{"true",""};
				if(Strings.isNotBlank(eventMsg)){
					eventMsgResult[0]= "false";
					eventMsgResult[1]= eventMsg;
				}
				result =  eventMsgResult;
			}
		}
		return result;
	}
}
