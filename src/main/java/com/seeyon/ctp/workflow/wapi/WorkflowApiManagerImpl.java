/**
 * Author: wangchw
 * Rev: WorkflowApiManagerImpl.java
 * Date: 20122012-8-3上午08:49:15
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
*/
package com.seeyon.ctp.workflow.wapi;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPrintSetup;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.PrintSetup;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.processlog.ProcessLog;
import com.seeyon.ctp.common.po.processlog.ProcessLogDetail;
import com.seeyon.ctp.common.processlog.ProcessLogAction;
import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
import com.seeyon.ctp.common.template.vo.CtpTemplateVO;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.rest.resources.SeeyonBPMAppHandler;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Deal;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4SpecifyBack;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Start;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4StepBack;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Tackback;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandResult;
import com.seeyon.ctp.rest.resources.SeeyonBPMManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowDesignerManager;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowHastenManager;
import com.seeyon.ctp.workflow.designer.util.WorkflowDesignerUtil;
import com.seeyon.ctp.workflow.engine.enums.ProcessStateEnum;
import com.seeyon.ctp.workflow.engine.enums.WorkflowLockActionEnum;
import com.seeyon.ctp.workflow.engine.listener.ActionRunner;
import com.seeyon.ctp.workflow.engine.log.Recorder;
import com.seeyon.ctp.workflow.event.EventDataContext;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.exception.NoSuchWorkitemException;
import com.seeyon.ctp.workflow.manager.CaseManager;
import com.seeyon.ctp.workflow.manager.HumenNodeMatchManager;
import com.seeyon.ctp.workflow.manager.ProcessManager;
import com.seeyon.ctp.workflow.manager.ProcessOrgManager;
import com.seeyon.ctp.workflow.manager.ProcessTemplateManager;
import com.seeyon.ctp.workflow.manager.SubProcessManager;
import com.seeyon.ctp.workflow.manager.WFProcessPropertyManager;
import com.seeyon.ctp.workflow.manager.WorkFlowAppExtendInvokeManager;
import com.seeyon.ctp.workflow.manager.WorkFlowMatchUserManager;
import com.seeyon.ctp.workflow.manager.WorkflowAjaxManager;
import com.seeyon.ctp.workflow.manager.WorkflowFormDataMapInvokeManager;
import com.seeyon.ctp.workflow.manager.WorkflowSuperNodeControlManager;
import com.seeyon.ctp.workflow.po.HistoryWorkitemDAO;
import com.seeyon.ctp.workflow.po.ProcessInRunningDAO;
import com.seeyon.ctp.workflow.po.ProcessTemplete;
import com.seeyon.ctp.workflow.po.SubProcessRunning;
import com.seeyon.ctp.workflow.po.SubProcessSetting;
import com.seeyon.ctp.workflow.po.WFProcessProperty;
import com.seeyon.ctp.workflow.po.WorkflowSuperNodeControl;
import com.seeyon.ctp.workflow.po.WorkitemDAO;
import com.seeyon.ctp.workflow.util.BranchArgs;
import com.seeyon.ctp.workflow.util.CalculateProcessNodePosition;
import com.seeyon.ctp.workflow.util.GenerationProcessNodeGraph;
import com.seeyon.ctp.workflow.util.ImExportUtil;
import com.seeyon.ctp.workflow.util.MessageUtil;
import com.seeyon.ctp.workflow.util.WorkFlowFinal;
import com.seeyon.ctp.workflow.util.WorkflowEventConstants;
import com.seeyon.ctp.workflow.util.WorkflowEventConstants.WorkflowEventEnum;
import com.seeyon.ctp.workflow.util.WorkflowMatchLogMessageConstants;
import com.seeyon.ctp.workflow.util.WorkflowNodeBranchLogUtil;
import com.seeyon.ctp.workflow.util.WorkflowUtil;
import com.seeyon.ctp.workflow.vo.BPMCircleBackNodeVO;
import com.seeyon.ctp.workflow.vo.CPMatchResultVO;
import com.seeyon.ctp.workflow.vo.ConditionMatchResultVO;
import com.seeyon.ctp.workflow.vo.ProcessNodePositionVO;
import com.seeyon.ctp.workflow.vo.SubProcessMatchResultVO;
import com.seeyon.ctp.workflow.vo.User;
import com.seeyon.ctp.workflow.vo.ValidateResultVO;
import com.seeyon.ctp.workflow.vo.WFMoreSignSelectPerson;
import com.seeyon.ctp.workflow.vo.WFPropertyBean;
import com.seeyon.ctp.workflow.vo.WorkflowFormFieldVO;
import com.seeyon.ctp.workflow.vo.WorkflowMatchLogVO;
import com.seeyon.v3x.common.web.login.CurrentUser;

import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMActor;
import net.joinwork.bpm.definition.BPMAndRouter;
import net.joinwork.bpm.definition.BPMCircleTransition;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMParticipant;
import net.joinwork.bpm.definition.BPMParticipantType;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.definition.BPMSeeyonPolicy;
import net.joinwork.bpm.definition.BPMStart;
import net.joinwork.bpm.definition.BPMStatus;
import net.joinwork.bpm.definition.BPMTransition;
import net.joinwork.bpm.definition.ObjectName;
import net.joinwork.bpm.engine.execute.BPMCase;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;
import net.joinwork.bpm.engine.wapi.WorkItem;
import net.joinwork.bpm.engine.wapi.WorkItemManager;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;

/**
 * <p>Title: 工作流（V3XWorkflow）</p>
 * <p>Description: 工作流对外暴露的接口实现类</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 北京致远协创软件有限公司</p>
 * <p>Author: wangchw
 * <p>Time: 2012-8-3 上午08:49:15
*/
public class WorkflowApiManagerImpl implements WorkflowApiManager {

    private static final Log       logger                 = LogFactory.getLog(WorkflowApiManagerImpl.class);
    
    /** 指定回退流程重走 **/
    private static final String STEP_BACK_STYLE_REGO = "0";
    
    /** 指定回退直接提交给我 **/
    private static final String STEP_BACK_STYLE_TOME = "1";
    

    private ProcessTemplateManager processTemplateManager = null;

    private ProcessManager         processManager         = null;

    private CaseManager            caseManager            = null;

    private WorkItemManager        workItemManager        = null;

    private SubProcessManager      subProcessManager      = null;

    private ProcessOrgManager      processOrgManager      = null;

    private PermissionManager      permissionManager      = null;
    
    private WorkFlowMatchUserManager workflowMatchUserManager = null;
    
    private WorkFlowDesignerManager workFlowDesignerManager = null;
    
    private WFProcessPropertyManager wfProcessPropertyManager;
    
    private WorkflowSuperNodeControlManager workflowSuperNodeControlManager;
    
    private ProcessLogManager processLogManager;
    
    private CellStyle styleTitle;
	private CellStyle styleColumn;
	private CellStyle styleContentText;
	private CellStyle styleContentBlank;
	private CellStyle styleContentDate;
	private CellStyle styleContentDatetime;
	private CellStyle styleContentNumeric;
	private CellStyle styleContentInteger;
    
    private WorkflowAjaxManager WFAjax =  null;
    
    private WorkFlowHastenManager workFlowHastenManager;

    public void setWorkFlowHastenManager(WorkFlowHastenManager workFlowHastenManager) {
        this.workFlowHastenManager = workFlowHastenManager;
    }
    
	public void setWFAjax(WorkflowAjaxManager wFAjax) {
		WFAjax = wFAjax;
	}

    public void setWfProcessPropertyManager(WFProcessPropertyManager wfProcessPropertyManager) {
        this.wfProcessPropertyManager = wfProcessPropertyManager;
    }

    public void setWorkFlowDesignerManager(WorkFlowDesignerManager workFlowDesignerManager) {
        this.workFlowDesignerManager = workFlowDesignerManager;
    }

    public void setWorkflowMatchUserManager(WorkFlowMatchUserManager workflowMatchUserManager) {
        this.workflowMatchUserManager = workflowMatchUserManager;
    }
    
    public BPMProcess getTemplateProcess(Long processTempleteId) throws BPMException {
    	if(processTempleteId == null ){
    		return null;
    	}
        ProcessTemplete template = processTemplateManager.selectProcessTemplateById(processTempleteId);
        if (template != null) {
            return BPMProcess.fromXML(template.getWorkflow());
        }
        
        return null;
    }

    public String getNodeFormViewAndOperationName(Long workflowId, String nodeId) throws BPMException {
        ProcessTemplete template = processTemplateManager.selectProcessTemplateById(workflowId);
        if (template != null) {
            BPMProcess process = BPMProcess.fromXML(template.getWorkflow());
            
            return this.getNodeFormViewAndOperationName(process, nodeId);
        }
        else {
            String errorMsg = ResourceUtil.getString("workflow.wapi.exception.msg001");//"模板已经被删除，您不能执行调用该模板的操作！";
            logger.info(errorMsg + "workflowId: "+workflowId);
            throw new BPMException(errorMsg);
        }
    }
    
	public String getNodeFormViewAndOperationName(BPMProcess process, String nodeId) throws BPMException {
    	String result = "";
        if (process != null) {
            if (nodeId != null && !"".equals(nodeId.trim())) {
                BPMActivity node = process.getActivityById(nodeId);
                if (node != null) {
                    result = node.getSeeyonPolicy().getForm() + "." + node.getSeeyonPolicy().getOperationName();
                } else {
                    //"Process=" + process.getId() + "的模版中id=" + nodeId + "的节点不存在！"
                    throw new BPMException(ResourceUtil.getString("workflow.label.notExistNode", process.getId(), nodeId));
                }
            } else {
                BPMStatus startNode = process.getStart();
                result = startNode.getSeeyonPolicy().getForm() + "." + startNode.getSeeyonPolicy().getOperationName();
            }
        }
        
        return result;
	}

	@Override
    public String[] getNodePolicyInfosFromTemplate(Long templateId, String nodeId) throws BPMException {
        String[] result = new String[]{"",""};
        ProcessTemplete template = processTemplateManager.selectProcessTemplateById(templateId);
        if (template != null) {
            BPMProcess process = BPMProcess.fromXML(template.getWorkflow());
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        result[0] =  node.getSeeyonPolicy().getOperationName();
                        result[1] =  node.getSeeyonPolicy().getDR();
                    } else {
                        logger.info("templateId=" + templateId + "的模版中id=" + nodeId + "的节点不存在！");
                        throw new BPMException("The Node witch id=" + nodeId + " in the Process Templete witch id="+templateId+" does not exist!");
                    }
                } else {
                    BPMStatus startNode = process.getStart();
                    result[0] =  startNode.getSeeyonPolicy().getOperationName();
                    result[1] =  startNode.getSeeyonPolicy().getDR();
                }
            } else {
                logger.info("templateId=" + templateId + "的模版xml无法转换为BPMProcess对象！");
                throw new BPMException("Cannot transfer the Process Template witch id=" + templateId + " to BPMProcess Object!");
            }
        } else {
            String errorMsg = ResourceUtil.getString("workflow.wapi.exception.msg001");//"模板已经被删除，您不能执行调用该模板的操作！";
            logger.info(errorMsg+"templeteId:"+templateId);
            throw new BPMException(errorMsg);
        }
        return result;
    }
	
	@Override
    public String getNodeFormOperationName(Long templateId, String nodeId) throws BPMException {
        return getNodePolicyInfosFromTemplate(templateId, nodeId)[0];
    }
    /**
     * @return the processTemplateManager
     */
    public ProcessTemplateManager getProcessTemplateManager() {
        return processTemplateManager;
    }

    /**
     * @param processTemplateManager the processTemplateManager to set
     */
    public void setProcessTemplateManager(ProcessTemplateManager processTemplateManager) {
        this.processTemplateManager = processTemplateManager;
    }

    @Override
    public String selectWrokFlowTemplateXml(String processTempateId) throws BPMException {
        return this.selectWrokFlowTemplateXml(processTempateId, true);
    }

    @Override
    public String selectWrokFlowXml(String processId) throws BPMException {
        String result = "";
        ProcessInRunningDAO process = processManager.getProcessInRunningDAO(processId);
        if (process != null) {
        	BPMProcess temp = process.getProcessObject();
        	WorkflowUtil.changeFormFieldNodeName(null, temp,null);
        	result = temp.toXML(null,true);
        }
        return result;
    }

    @Override
    public String[] transRunCase(WorkflowBpmContext context) throws BPMException {
    	context.setFreeFlow(true);
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String processXml = context.getProcessXml();
        String processId = context.getProcessId();
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        int state = this.getProcessStateFromCache(processId, matchRequestToken);
        if (state == ProcessStateEnum.processState.startNodeTome.ordinal() && !context.isToReGo()) {
            String[] result = engine.runCaseToMe(context);
            return result;
        } else {
        	if (null != processXml && !"".equals(processXml.trim())) {
    		    context.setProcessId(null);
    		} else if (null != processId && !"".equals(processId.trim()) && !"-1".equals(processId.trim())) {
    		    BPMProcess process = processManager.getRunningProcess(context.getProcessId());
    		    List<BPMAbstractNode> activities =  process.getActivitiesList();
    		    for (BPMAbstractNode n : activities) {
    		        n.getSeeyonPolicy().setIsDelete("false");
    		        n.getSeeyonPolicy().setIsPass("success");
    		    }
    		    processXml = process.toXML(null,true);
    		    context.setProcessXml(processXml);
    		    context.setProcessId(null);
    		}
    		String[] result = engine.runCase(context);
    		return result;
        }

    }

    @Override
    public String[] transRunCaseFromTemplate(WorkflowBpmContext context) throws BPMException {
    	context.setFreeFlow(false);
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        if("collaboration".equals(context.getAppName()) || "form".equals(context.getAppName())){//添加表单数据
            WorkflowUtil.addFormDataDisplayName(context);
        }else if("edoc".equals(context.getAppName()) 
                || "sendEdoc".equals(context.getAppName())
                || "edocSend".equals(context.getAppName()) 
                || "signReport".equals(context.getAppName())
                || "edocSign".equals(context.getAppName())
                || "recEdoc".equals(context.getAppName())
                || "edocRec".equals(context.getAppName())){//添加公文数据
            WorkflowUtil.addEdocDataDisplayName(context);
        }
        
        String matchRequestToken= context.getMatchRequestToken();
        if(!context.isSubProcess() && !context.isAddFirstNode()){
        	matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        	context.setMatchRequestToken(matchRequestToken);
        }
        String processId = context.getProcessId();
        if(!context.isAddFirstNode()){
        	int state= getProcessStateFromCache(processId, matchRequestToken);
            if (state != -1) {
                if (state == ProcessStateEnum.processState.startNodeTome.ordinal() && !context.isToReGo()) {
                    String[] result = engine.runCaseToMe(context);
                    return result;
                } else {
                    BPMProcess process = processManager.getRunningProcess(context.getProcessId());
                    List<BPMAbstractNode> activities =  process.getActivitiesList();
                    for (BPMAbstractNode n : activities) {
                        n.getSeeyonPolicy().setIsDelete("false");
                        n.getSeeyonPolicy().setIsPass("success");
                    }
                    String processXml = process.toXML(null,true);
                    context.setProcessXml(processXml);
                    context.setProcessId(null);
                    String[] result = engine.runCase(context);
                    return result;
                }
            } else {
                if(Strings.isNotBlank(context.getProcessXml())){
                    context.setProcessId(null);
                    String[] result =  engine.runCase(context);
                    return result;
                }else{
                    String[] result = engine.runCaseFromTemplate(context);
                    return result;
                }
            }
        }else{
            String[] result = engine.runCaseFromTemplate(context);
            return result;
        }
    }

    /**
     * 从缓存中获取流程运行状态，如果没有则从数据库查询
     * @param processId
     * @param matchRequestToken
     * @return
     * @throws BPMException
     */
    private int getProcessStateFromCache(String processId,String matchRequestToken) throws BPMException {
    	int state = -1;
    	if(Strings.isNotBlank(processId)){
	    	Integer cachedState= workflowMatchUserManager.getProcessStateFromCacheRequestScope(matchRequestToken);
	    	if(null==cachedState){
	    		state = processManager.getProcessState(processId);
	    	}else{
	    		state= cachedState.intValue();
	    	}
    	}
    	return state;
	}

	@Override
    public String[] finishWorkItem(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        String[] result= engine.finishWorkItem(context);
        return result;
        
    }
    
    @Override
    public String[] transFinishWorkItem(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        String[] result= engine.finishWorkItem(context);
        return result;
    }
    
    @Override
    public CPMatchResultVO transBeforeInvokeWorkFlow(WorkflowBpmContext context, CPMatchResultVO cpMatchResult)
            throws BPMException {
    	if (null == cpMatchResult) {
            cpMatchResult = new CPMatchResultVO();
        }
        cpMatchResult.setPop(false);
        Map<String, ConditionMatchResultVO> condtionResultAll= new HashMap<String, ConditionMatchResultVO>();
        String processXml = context.getProcessXml();
        String processId = context.getProcessId();
        String processTemplateId = context.getProcessTemplateId();
        Long caseId = context.getCaseId();
        logger.info("P:="+processId);
        String currentNodeId = context.getCurrentActivityId();
        currentNodeId= (Strings.isBlank(currentNodeId) || "-1".equals(currentNodeId) || "0".equals(currentNodeId))?"start":currentNodeId;
        Long currentWorkitemId = context.getCurrentWorkitemId();
        if (caseId == -1 || caseId == 0) {
            currentWorkitemId = -1l;
            currentNodeId = "start";
        }
        Object[] processObj= WorkflowUtil.doInitBPMProcessForCache(context.getMatchRequestToken(),processXml, processId, processTemplateId, currentNodeId);
        BPMProcess process = (BPMProcess)processObj[0];
        int state= (Integer)processObj[1];
        context.setProcess(process);
        context.setCaseId(caseId);
        BPMAbstractNode currentActivity = null;
        
        if(!StringUtil.checkNull(currentNodeId)){
        	if("start".equals(currentNodeId)){
        		currentActivity = process.getStart();
        	} else {
        		currentActivity = process.getActivityById(currentNodeId);
        	}
        	if(currentActivity!=null){
			    //手动分支最大可选分支数量
        		String hst = WorkflowUtil.getFirstNextSplitNode(currentActivity);
        		cpMatchResult.setHst(hst);
        	}
        }
        BPMCase theCase = null;
        WorkItem workitem= null;
        if (!"start".equals(currentNodeId)) {
            theCase = caseManager.getCase(caseId);
            context.setTheCase(theCase);
            workitem = workItemManager.getWorkItemOrHistory(currentWorkitemId);
            if(null==workitem){//workitem不存在时，模拟一个，允许提交
                throw new NoSuchWorkitemException(null, processId, context.getCurrentWorkitemId());
            }
        }
        WorkflowUtil.changeFormFieldNodeName(theCase,process,null);
        if(context.isValidate() &&  !context.isSysAutoFinishFlag()){//需要校验
            String alreadyChecked= cpMatchResult.getAlreadyChecked();
            //上节点触发的子流程《(自动发起)请假单-子流程(t1 2016-02-20 13:41)》未结束，该协同暂不能处理！
            String[] result= getValidateResult(currentWorkitemId, alreadyChecked, context.getCurrentUserId(), processId, process, theCase, workitem,context.getUseNowExpirationTime());
            if(!"true".equals(result[0])){
                cpMatchResult.setCanSubmit("false");
                cpMatchResult.setCannotSubmitMsg(result[1]);
                cpMatchResult.setAlreadyChecked("true");
                logger.info("preSubmit:="+processId);
                return cpMatchResult;
            }
        }
        
        WorkflowUtil.putCaseToWorkflowBPMContext(theCase, context);
        
        if (!"start".equals(currentNodeId)) {
            BPMActor startActor = (BPMActor) process.getStart().getActorList().get(0);
            String sender = startActor.getParty().getId() + "";
            context.setStartUserId(sender);
            context.setStartAccountId(startActor.getParty().getAccountId());
        } else {
            context.setStartUserId(context.getCurrentUserId());
            context.setStartAccountId(context.getCurrentAccountId());
        }
        String formAppId= process.getStart().getSeeyonPolicy().getFormApp();
        context.setFormAppId(formAppId);
        WorkflowUtil.doInitFormDataForCache(context, formAppId);

        //协同和表单，指定回退-直接提交给我，  检验中间分支条件是否有变动
            
        boolean isReMe = false;
        boolean isNeedReGo = false;
        
        if (!"start".equals(currentNodeId)) {
            int wState = workitem.getState();
            isReMe = wState == WorkItem.STATE_NEEDREDO_TOME;
        }else{
            isReMe = state == ProcessStateEnum.processState.startNodeTome.ordinal();
        }
        
        if (isReMe) {  //是否需要流程重走
//            if("collaboration".equals(context.getAppName()) 
//                    || "form".equals(context.getAppName())){
//                
                BPMCase _newCase = theCase;
                BPMAbstractNode _oldCurrentActivity = currentActivity;
                if("start".equals(currentNodeId)){
                    _newCase = caseManager.getCase(caseId);
                    BPMProcess _Oldprocess = processManager.getRunningProcess(processId);
                    context.setProcess(_Oldprocess);
                    _oldCurrentActivity = _Oldprocess.getStart();
                }   
               
                isNeedReGo = WorkflowUtil.isRego(context, _newCase, _oldCurrentActivity);
//            }
            
            if(isNeedReGo){
                cpMatchResult.setToReGo(true);
                context.setProcess(process);
            }
        }
        
        String dynamicFormMasterIds  = "";
        if(theCase != null){
        	dynamicFormMasterIds = (String) theCase.getDataMap().get(ActionRunner.WF_DYNAMIC_FORM_KEY);	
        }
        context.setDynamicFormMasterIds(dynamicFormMasterIds);
        String popNodeSelected = context.getSelectedPeoplesOfNodes();
        Map<String, String[]> addition = WorkflowUtil.getPopNodeSelectedValues(popNodeSelected);
        context.setCopyNodePeopleMap(addition);
        
        boolean isClearAddition = true;
        
        boolean isNeedMatch = false;
        boolean isNeedCircleMatch= false;
        BPMSeeyonPolicy seeyonPolicy = null;
        BPMStatus startNode = process.getStart();
        Set<String> preSelectInformNodes = new HashSet<String>();
        if (null != cpMatchResult.getCurrentSelectInformNodes()) {
            preSelectInformNodes = cpMatchResult.getCurrentSelectInformNodes();
        }
        String matchMsg= "";
        Map<String,Boolean> autoSkipNodeMap= new HashMap<String, Boolean>();
        if (preSelectInformNodes.size() == 0) {
        	String selectedPeoplesOfNodesJson= context.getSelectedPeoplesOfNodes();
            boolean hasNewflow = false;
            if (!"start".equals(currentNodeId)) {//处理节点才需要做校验是否需要进行节点匹配，发起节点不管什么时候都要匹配
                BPMActivity myNode= process.getActivityById(currentNodeId);
                if(null==myNode){
                    cpMatchResult.setPop(false);
                    cpMatchResult.setHasSubProcess(false);
                    logger.info("preSubmit2:="+processId);
                    return cpMatchResult;
                }
                currentActivity = (BPMHumenActivity) myNode;
                seeyonPolicy = currentActivity.getSeeyonPolicy();
                hasNewflow = seeyonPolicy != null && "1".equals(seeyonPolicy.getNF());
                if(Strings.isBlank(selectedPeoplesOfNodesJson)){ 
	                //判断当前处理人员是否为当前流程节点的最后一个处理人
	                boolean[] allExecuteFinished = workItemManager.isAllExcuteFinished(workitem, process,theCase,currentActivity,context);
	                boolean isExecuteFinished= allExecuteFinished[0];
	                isNeedCircleMatch= allExecuteFinished[1];
	                isNeedMatch = isExecuteFinished && !ObjectName.isInformObject(currentActivity);
	                String affairMemberId= workitem.getPerformer();
	                if( Strings.isNotBlank(context.getCurrentUserId()) && !context.getCurrentUserId().trim().equals(affairMemberId.trim())){//如果是代理人员处理待办，则当前节点处理人员id应更新为performer值
	                    User affairMember= processOrgManager.getUserById(affairMemberId,true,false);
	                    if(null!=affairMember){
	                        String affairMemberAccountId= affairMember.getAccountId();
	                        context.setCurrentUserId(affairMemberId);
	                        context.setCurrentAccountId(affairMemberAccountId);
	                    }
	                }
                }
            } else {
                seeyonPolicy = startNode.getSeeyonPolicy();
                currentActivity = startNode;
            }
            if(Strings.isBlank(selectedPeoplesOfNodesJson)){ 
	            if(isNeedCircleMatch){
	            	List<BPMCircleTransition> circleList= currentActivity.getDownCirlcleTransitions();
	            	List<BPMCircleBackNodeVO> circleNodes = new ArrayList<BPMCircleBackNodeVO>();
	                 if(Strings.isNotEmpty(circleList)){ 
	                	 
	                 	for (BPMCircleTransition circleCondition : circleList) {
	                 		BPMAbstractNode toNode= circleCondition.getTo();
	                 		if(null==toNode){
	                 			continue;
	                 		}
	                 		Map<String,String> conditionMap = circleCondition.getConditionMapFromCase(theCase,circleCondition.getTo().getId());
	                 		String isDelete = "";
	                 		if(null!=conditionMap.get("isDelete")){
	                    	    isDelete= conditionMap.get("isDelete")==null?"false":conditionMap.get("isDelete");
	                    	}
	                 		if("true".equals(isDelete)){
	                 			continue;
	                 		}
	                 		String formCondition= circleCondition.getFormCondition();
	                 		int conditionType= circleCondition.getConditionType();
	                 		String conditionBase= circleCondition.getConditionBase();
	                 		if( conditionType ==1 || conditionType == 4 ){//自动分支
	 	                		boolean result= ActionRunner.getConditionValue(context, formCondition, conditionBase);
	 	                		if(result){//非强制分支
	 	                			if(toNode !=null ){
	 	                				
	 	                				BPMCircleBackNodeVO circleBackNodeVO = new BPMCircleBackNodeVO();
	 	                				if(!"start".equals(toNode.getId())){
	 	                					circleBackNodeVO.setNodePolicy(toNode.getSeeyonPolicy().getName());
	 	                				}
	 	                				
	 	                				circleBackNodeVO.setNodeName(toNode.getName());
	 	                				circleBackNodeVO.setNodeId(toNode.getId());
	 	                				circleBackNodeVO.setConditionTitle(circleCondition.getConditionTitle());
	 	                				circleBackNodeVO.setSubmitStyle(circleCondition.getSubmitStyle());
	 	                				circleNodes.add(circleBackNodeVO);
	 	                			}
	 	                		}
	                 		}
	 					}
	                 }
	                 if(Strings.isNotEmpty(circleNodes)){
	                	boolean isInSpecialStepBackStatus = isInSpecialStepBackStatus(caseId);
	                	cpMatchResult.setIsInSpecialStepBackStatus(String.valueOf( !isInSpecialStepBackStatus));
	                 	cpMatchResult.setCircleNodes(circleNodes);
	                 }
	            }
	            
	            //指定回退-提交回退者，并且流程不重走， 没有环形分支的时候，有环形分支进行环形分支判断
	            if(isReMe && !isNeedReGo && Strings.isEmpty(cpMatchResult.getCircleNodes())){
	                cpMatchResult.setPop(false);
	                //logger.info("preSubmit1:="+processId);
	                return cpMatchResult;
	            }
	            
	            
	            if ((!isReMe || isNeedReGo) // 非 指定回退并且是流程需要重新选择 
	                    && (isNeedMatch || "start".equals(currentNodeId))) {
	                 /*if (!"start".equals(currentNodeId)) {
	                     int wState = workitem.getState();
	                     if (wState == WorkItem.STATE_NEEDREDO_TOME) {
	                         isClearAddition = false;
	                         cpMatchResult.setPop(false);
	                         return cpMatchResult;
	                     }
	                 }*/
	            	 context.setActivateNode(currentActivity);
	                 context.setCurrentActivityId(currentNodeId);
	                 Set<String> myCurrentSelectNodes= new HashSet<String>();
	                 myCurrentSelectNodes.add(currentNodeId);
	                 matchMsg= BranchArgs.doMatchAll(cpMatchResult,myCurrentSelectNodes,context,isClearAddition,process,startNode,condtionResultAll,autoSkipNodeMap);
	            }
            }
            /*if (!"start".equals(currentNodeId)) {
                int wState = workitem.getState();
                if (wState == WorkItem.STATE_NEEDREDO_TOME) {
                    isClearAddition = false;
                    cpMatchResult.setPop(false);
                    return cpMatchResult;
                }
            }*/
            
            
            String popNodeSubProcessJson= context.getPopNodeSubProcessJson();//fix bug:(自动发起)BUG_普通_V5_V5.6sp1_一星卡_云南工商学院_子流程设置为“子流程结束后主流程才可继续”，但是子流程还未结束，主流程继续往下流转了_20170612038151_2017-06-12
            if (hasNewflow && Strings.isBlank(popNodeSubProcessJson)) {//当前节点触发了子流程
                cpMatchResult.setHasSubProcess(true);
                List<String> currentNodes = new ArrayList<String>();
                currentNodes.add(currentNodeId);
                List<SubProcessRunning> subPSet = subProcessManager.getSubProcessRunningListByMainProcessId(processId,
                        currentNodes, false, false);
                if (null != subPSet && subPSet.size() > 0) {
                    cpMatchResult.setPop(true);
                    Map<String, SubProcessMatchResultVO> subProcessMatchMap = new HashMap<String, SubProcessMatchResultVO>();
                    WorkflowNodeBranchLogUtil.initCacheSubflowMatchResult();
                    WorkflowNodeBranchLogUtil.initCacheFormFieldValue();
                    /*String baseCurrentNode = "<span class='color_gray2'>[" + ResourceUtil.getString("workflow.branch.currentnode") + "]</span><br/>";
                    String baseSender = "<span class='color_gray2'>[" + ResourceUtil.getString("workflow.branch.sender") + "]</span><br/>";*/
                    String baseCurrentNode = "[" + ResourceUtil.getString("workflow.branch.currentnode") + "]\r";
                    String baseSender = "[" + ResourceUtil.getString("workflow.branch.sender") + "]\r";
                    for (SubProcessRunning subProcessRunning : subPSet) {
                    	ProcessTemplete subTemplete = processTemplateManager.selectProcessTemplateById(subProcessRunning.getSubProcessTempleteId());
                        if(subTemplete==null){
                        	//如果子流程已经被删除，那么流程设置页面不允许出现该子流程
                        	continue;
                        }
                    	String newflowSender = subProcessRunning.getSubProcessSender();
                        List<User> peoples = new ArrayList<User>();
                        if ("CurrentNode".equals(newflowSender)) {//当前节点
                            String currentUserId = context.getCurrentUserId();
                            User user = processOrgManager.getUserById(currentUserId,true);
                            peoples.add(user);
                        } else if ("CurrentSender".equals(newflowSender)) { //当前流程发起者
                            String startUserId = context.getStartUserId();
                            User user = processOrgManager.getUserById(startUserId,true);
                            peoples.add(user);
                        } else { //所选择人员
                            //如果是表单控件的话，形式是这样的FormField|Member.field0001
                            //子流程触发选人只支持单人控件，不支持多人控件
                            //所以获取到的表单值，就只有一个Id
                            if(newflowSender.startsWith("FormField")){
                                @SuppressWarnings("unchecked")
                                Map<String,Object> formFieldData = (Map<String,Object>)context.getBusinessData().get(EventDataContext.CTP_FORM_DATA);
                                peoples = workflowMatchUserManager.getUserListFormField(newflowSender.substring("FormField".length()+1), formFieldData,context,true, "1");
                            }else{
                                peoples = workflowMatchUserManager.getUserListByTypeAndId(newflowSender);
                            }
                            
                            //去重
                            Map<String,Boolean> filterMap = new HashMap<String,Boolean>();
                            if(Strings.isNotEmpty(peoples)){
                            	for(java.util.Iterator<User> it = peoples.iterator();it.hasNext();){
                            		User u = it.next();
                            		if(filterMap.get(u.getId()) != null){
                            			it.remove();
                            		}else{
                            			filterMap.put(u.getId(), true);
                            		}
                            	}
                            }
                        }
                        String conditionBase = subProcessRunning.getConditionBase();
                        String conditionBaseTitle = "";
                        if("currentNode".equals(conditionBase)){
                        	conditionBaseTitle = baseCurrentNode;
                        } else if("CurrentSender".equals(conditionBase)){
                        	conditionBaseTitle = baseSender;
                        } else if("start".equals(conditionBase)){
                        	conditionBaseTitle = baseSender;
                        }
                        Long id = subProcessRunning.getId();
                        String subject = subProcessRunning.getSubject();
                        String triggerCondition = subProcessRunning.getTriggerCondition();
                        String originalTitle = subProcessRunning.getConditionTitle();
                        String triggerConditionTitle = "";
                        if(originalTitle==null || "".equals(originalTitle.trim()) || "null".equals(originalTitle.trim())){
                        	triggerConditionTitle = ResourceUtil.getString("workflow.matchResult.msg5");
                        }else{
                        	triggerConditionTitle = conditionBaseTitle + originalTitle;
                        }
                        boolean subProcessConditionResult = false;
                        boolean isForce = subProcessRunning.getIsForce();
                        if (null == triggerCondition || "".equals(triggerCondition.trim()) || "null".equals(triggerCondition.trim())  || "undefined".equals(triggerCondition.trim())) {
                            subProcessConditionResult = true;
                        } else {
                            //triggerCondition = BranchArgs.parseCondition(triggerCondition, conditionBase, "false");
                            subProcessConditionResult = ActionRunner.getConditionValue(context, triggerCondition,
                                    conditionBase);
                            WorkflowNodeBranchLogUtil.addCacheSubflowMatchResult(subProcessRunning.getSubject(), "", conditionBase, String.valueOf(subProcessConditionResult), triggerCondition);
                        }
                        SubProcessMatchResultVO subVO = new SubProcessMatchResultVO();
                        subVO.setId(String.valueOf(id));
                        subVO.setSubProcessTempleteName(subject);
                        subVO.setSubProcessSender(newflowSender);
                        subVO.setForce(isForce);
                        subVO.setTriggerResult(subProcessConditionResult);
                        String triggerResultName = MessageUtil.getString("workflow.commonpage.subprocessbranch.sucess");
                        if (subProcessConditionResult) {
                            triggerResultName = MessageUtil.getString("workflow.commonpage.subprocessbranch.sucess");
                        } else {
                            triggerResultName = MessageUtil.getString("workflow.commonpage.subprocessbranch.failed");
                        }
                        subVO.setTriggerResultName(triggerResultName);
                        subVO.setPeoples(peoples);
                        subVO.setTriggerConditionTitle(triggerConditionTitle);
                        subProcessMatchMap.put(String.valueOf(id), subVO);
                    }
                    cpMatchResult.setSubProcessMatchMap(subProcessMatchMap);
                }
                WorkflowNodeBranchLogUtil.printLogCacheSubflowMatchResult();
                WorkflowNodeBranchLogUtil.printLogCacheFormFieldValue();
            }
        } else {
        	matchMsg= BranchArgs.doMatchAll(cpMatchResult,preSelectInformNodes,context,isClearAddition,process,null,condtionResultAll,autoSkipNodeMap);
        }
        String invalidateActivityMapStr= WorkflowUtil.getInvalidateActivityMapStr(cpMatchResult.getInvalidateActivityMap(),true);
        cpMatchResult.setInvalidateActivityMapStr(invalidateActivityMapStr);
        //logger.info("cpMatchResult:=" + JSONUtil.toJSONString(cpMatchResult));
        Set<String> currentSelectInformNodes= cpMatchResult.getCurrentSelectInformNodes();
        Set<String> currentSelectNodes= cpMatchResult.getCurrentSelectNodes();
        if(null!=currentSelectNodes && null!=currentSelectInformNodes && !currentSelectInformNodes.isEmpty()){
            for (String nodeId : currentSelectNodes) {
                BPMAbstractNode myNode= null;
                if("end".equals(nodeId)){
                    myNode= (BPMAbstractNode)process.getEnds().get(0);
                }else{
                    myNode= process.getActivityById(nodeId);
                }
                findMyParent(myNode,currentSelectInformNodes,true);
            }
        }
        boolean isEnd= false;
        if(!cpMatchResult.isPop() && null!=process){//不弹出时，看当前处理人提交后，是否流程就结束了
            Set<String> allSelectNodes= cpMatchResult.getAllSelectNodes();
            if(null!=allSelectNodes){ 
                for (String nodeId : allSelectNodes) {
                    if("end".equals(nodeId)){
                        isEnd= true;
                        break;
                    }else{
                        BPMAbstractNode node= process.getActivityById(nodeId);
                        if(ObjectName.isInformObject(node)){
                            continue;
                        }else{
                            isEnd= false;
                        }
                    }
                }
            }
        }
        cpMatchResult.setLast(String.valueOf(isEnd));
        cpMatchResult.setMatchResultMsg(matchMsg);
        
        if(context.isValidate()){//需要校验
            String alreadyChecked= cpMatchResult.getAlreadyChecked();
            //指定回退状态下，(核定\最后一个节点)不能提交
            if("false".equals(alreadyChecked)){
            	String[] result= getValidateResult2(currentActivity, cpMatchResult, theCase, process);
            	if(!"true".equals(result[0])){
            		cpMatchResult.setCanSubmit("false");
            		cpMatchResult.setCannotSubmitMsg(result[1]);
            		cpMatchResult.setAlreadyChecked("true");
            		matchMsg= result[1];
            		cpMatchResult.setMatchResultMsg(matchMsg);
            		logger.info("preSubmit3:="+processId);
            		return cpMatchResult;
            	}
            }
        }
        
        cpMatchResult.setCanSubmit("true"); 
        cpMatchResult.setCannotSubmitMsg("");
        cpMatchResult.setAlreadyChecked("true");   
        
        cpMatchResult.setDynamicFormMasterIds(context.getDynamicFormMasterIds());
        cpMatchResult.setHumenNodeMatchAlertMsg(context.getHumenNodeMatchAlertMsg());
        
        //预处理：对强制分支或不带分支的自动跳过的非知会节点做一次预处理，看这些节点后面是否有分支和选人节点，如果有，则不能自动跳过，得选人
        if(context.isMobile()){
            this.doAfterM1(context, process, cpMatchResult, isClearAddition,condtionResultAll,autoSkipNodeMap);
        }else{
            this.doAfter(context, process, cpMatchResult, isClearAddition,condtionResultAll,autoSkipNodeMap);
        }
        logger.info("preSubmit4:="+processId);
        return cpMatchResult; 
    }

	private String[] getValidateResult2(BPMAbstractNode currentNode,CPMatchResultVO cpMatchResult,BPMCase theCase,BPMProcess process) {
    	//1、当前结点是主流程的节点 ： 当主流程处于指定回退状态，核定节点不能提交
    	
    	/*2、当前结点是子流程的节点
    	1、主流程处于指定回退的状态、核定\最后一个节点不能提交
    	2、子流程处于指定回退的状态、核定节点不能提交*/
    	
    	String[] result= new String[]{"true",""};
    	if("vouch".equals(currentNode.getSeeyonPolicy().getId()) || "true".equals(cpMatchResult.getLast())  ){
    		try {
    			int stepCount = 0 ;
    			boolean isInSpecialStepBackStatus  = false;
    			if(theCase!=null){
    				
    				stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
    				
    				isInSpecialStepBackStatus  = stepCount > 0 ;
    				if(isInSpecialStepBackStatus){
    					
    					/*當前流程處於指定回退狀態，你不能進行此操作！*/
    					result[1]= ResourceUtil.getString("workflow.validate.submit.msg0");
    					result[0]= "false";
    					return result;
    				}
    			}
				
				List<SubProcessRunning> subProcessRunnings = subProcessManager.getSubProcessRunningListBySubProcessId(process.getId(), null, null);
				if(Strings.isNotEmpty(subProcessRunnings)){
					for(SubProcessRunning sp : subProcessRunnings){
						if(sp.getMainProcessId() != null){
							
							BPMCase mainCase = caseManager.getCaseOrHistoryCaseByProcessId(sp.getMainProcessId());
							if(mainCase != null){
								stepCount= mainCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(mainCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
								
								isInSpecialStepBackStatus  = stepCount > 0 ;
								
								if(isInSpecialStepBackStatus){
									/*主流程处于指定回退下，该节点暂不能提交*/
									result[1]= ResourceUtil.getString("workflow.validate.submit.msg1");
									result[0]= "false";
									return result;
								}
							}
						}
						
					}
				}
				
			} catch (BPMException e) {
				logger.error("", e);
			}
    	}
    	
		return result;
	}

	/**
     * 校验结果
     * @param currentWorkitemId
     * @param alreadyChecked
     * @param currentUserId
     * @param processId
     * @param process
     * @param theCase
     * @param workItem
     * @return
     * @throws BPMException
     */
    private String[] getValidateResult(Long currentWorkitemId,String alreadyChecked,String currentUserId,
            String processId,BPMProcess process,BPMCase theCase,WorkItem workItem,String useNowExpirationTime) throws BPMException {
        String currentWorkitemIdStr= String.valueOf(currentWorkitemId);
        boolean isUsed= null!=currentWorkitemIdStr && !"-1".equals(currentWorkitemIdStr) 
        && !"0".equals(currentWorkitemIdStr)&& !"null".equals(currentWorkitemIdStr) && !"undefined".equals(currentWorkitemIdStr);
        String[] result= new String[]{"true",""};
        if("false".equals(alreadyChecked) && Strings.isNotBlank(processId) && isUsed){
        	
        	String from = Constants.login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
            result= this.canWorkflowCurrentNodeSubmit(process, theCase, workItem);
            if("true".equals(result[0])){
                result= lockWorkflowProcess(processId, currentUserId, 14, from , "true".equals(useNowExpirationTime));
            }
        }
        return result;
    }

    private void doAfterM1(WorkflowBpmContext context, BPMProcess process, CPMatchResultVO cpMatchResult,
            boolean isClearAddition, Map<String, ConditionMatchResultVO> condtionResultAll,Map<String,Boolean> autoSkipNodeMap) throws BPMException {
        Set<String> allSelectNodes= new HashSet<String>();
        Set<String> allSelectInformNodes= new HashSet<String>();
        Set<String> allNotSelectNodes= new HashSet<String>();
        Set<String> allCurrentSelectInformNodes= new HashSet<String>();
        Set<String> myCurrentSelectInformNodes= cpMatchResult.getCurrentSelectInformNodes();
        if(null!= cpMatchResult.getAllSelectInformNodes()){
            allSelectInformNodes.addAll(cpMatchResult.getAllSelectInformNodes());
        }
        if(null!=myCurrentSelectInformNodes){
            allSelectInformNodes.addAll(myCurrentSelectInformNodes);
            allCurrentSelectInformNodes.addAll(myCurrentSelectInformNodes);
        }
        List<String> checkedNodeIds= new ArrayList<String>();
        if(null!=myCurrentSelectInformNodes){
            for (String myNodeId : myCurrentSelectInformNodes) {
                BPMAbstractNode myNode= process.getActivityById(myNodeId);
                if(!ObjectName.isInformObject(myNode)){//非知会节点
                    checkedNodeIds.add(myNodeId);
                    allSelectInformNodes.remove(myNodeId);
                }
                allSelectNodes.add(myNodeId);
            }
        }
        
        boolean isNeedDo= false;
        List<String> virtualCheckedNodeIds= new ArrayList<String>();
        Map<String, ConditionMatchResultVO> conditionMatchResultVOMap= cpMatchResult.getCondtionMatchMap();
        if(null!=conditionMatchResultVOMap){
            Set<String> keys= conditionMatchResultVOMap.keySet();
            for (String myNodeId : keys) {
                ConditionMatchResultVO conditionMVO= conditionMatchResultVOMap.get(myNodeId);
                if(conditionMVO.isHand()){
                    if(conditionMVO.getNa()=="2"){
                        virtualCheckedNodeIds.add(myNodeId);
                        allSelectInformNodes.add(myNodeId);
                        allSelectNodes.add(myNodeId);
                    }else{
                        allNotSelectNodes.add(myNodeId);
                    }
                }
                if(conditionMVO.isHand() && conditionMVO.getNa()=="2"){
                    checkedNodeIds.add(myNodeId);
                    allSelectInformNodes.add(myNodeId);
                    allSelectNodes.add(myNodeId);
                }
                if(conditionMVO.getNa()=="2"){
                    isNeedDo= true;
                }
            }
        }
        checkedNodeIds.addAll(virtualCheckedNodeIds);
        if(!checkedNodeIds.isEmpty()){//确实存在自动跳过的非知会节点
            
            if(isNeedDo){
                if(null!= cpMatchResult.getAllNotSelectNodes()){
                    allNotSelectNodes.addAll(cpMatchResult.getAllNotSelectNodes());
                }
                if(null!= cpMatchResult.getAllSelectNodes()){
                    allSelectNodes.addAll(cpMatchResult.getAllSelectNodes());
                }
                if(null!= cpMatchResult.getCurrentSelectNodes()){
                    allSelectNodes.addAll(cpMatchResult.getCurrentSelectNodes());
                }
                
                for(int i=0;i<checkedNodeIds.size();i++){
                    String checkedNodeId= checkedNodeIds.get(i);
                    boolean myResult= this.doAfterMatch(context, process, checkedNodeId, allNotSelectNodes,
                            allSelectNodes, allSelectInformNodes, allCurrentSelectInformNodes, isClearAddition,true,autoSkipNodeMap);
                    if(myResult){//需要选人
                        ConditionMatchResultVO conditionMVO= null;
                        if(null!=conditionMatchResultVOMap.get(checkedNodeId)){
                            conditionMVO= conditionMatchResultVOMap.get(checkedNodeId);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setId(checkedNodeId);
                            conditionMVO.setNeedSelectPeople(true);
                            
                            conditionMVO.setNa("0");
                            conditionMVO.setToNodeIsInform(false);
                        }else if(null!=condtionResultAll.get(checkedNodeId)){
                            conditionMVO= condtionResultAll.get(checkedNodeId);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setId(checkedNodeId);
                            conditionMVO.setNeedSelectPeople(true);
                            conditionMVO.setNa("0");
                            conditionMVO.setToNodeIsInform(false);
                        }else{
                            BPMAbstractNode myNode= process.getActivityById(checkedNodeId);
                            conditionMVO = new ConditionMatchResultVO();
                            conditionMVO.setConditionDesc("");
                            conditionMVO.setConditionTitle("");
                            conditionMVO.setNodePolicy(myNode.getSeeyonPolicy().getName());
                            conditionMVO.setConditionType("3");
                            conditionMVO.setHand(false);
                            conditionMVO.setHasBranch(false);
                            conditionMVO.setNeedSelectPeople(true);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setNa("0");
                            conditionMVO.setNeedPeopleTag(true);
                            conditionMVO.setMatchResult(true);
                            conditionMVO.setDefaultShow(true);
                            String matchResultName= "";
                            conditionMVO.setMatchResultName(matchResultName);
                            conditionMVO.setProcessMode(myNode.getSeeyonPolicy().getProcessMode());
                            String processModeName= MessageUtil.getString("workflow.commonpage.processmode."+myNode.getSeeyonPolicy().getProcessMode());
                            conditionMVO.setProcessModeName(processModeName);
                            conditionMVO.setToNodeId(checkedNodeId);
                            conditionMVO.setToNodeIsInform(false);
                            conditionMVO.setToNodePolicyId(myNode.getSeeyonPolicy().getId());
                            conditionMVO.setToNodeName(myNode.getName());
                        }
                        conditionMatchResultVOMap.put(checkedNodeId, conditionMVO);
                        cpMatchResult.getCurrentSelectInformNodes().remove(checkedNodeId);
                        cpMatchResult.getAllSelectInformNodes().remove(checkedNodeId);
                        if(!conditionMVO.isHand()){
                            cpMatchResult.getCurrentSelectNodes().add(checkedNodeId); 
                        }else{
                            allCurrentSelectInformNodes.add(checkedNodeId);
                            allSelectInformNodes.add(checkedNodeId);
                        }
                    }else{
                        ConditionMatchResultVO conditionMVO= null;
                        if(null!=conditionMatchResultVOMap.get(checkedNodeId)){
                            conditionMVO= conditionMatchResultVOMap.get(checkedNodeId);
                        }else if(null!=condtionResultAll.get(checkedNodeId)){
                            conditionMVO= condtionResultAll.get(checkedNodeId);
                        }
                        if(null!=conditionMVO){
                            conditionMVO.setNa("0");
                            conditionMatchResultVOMap.put(checkedNodeId, conditionMVO);
                        }
                        allCurrentSelectInformNodes.add(checkedNodeId);
                        allSelectInformNodes.add(checkedNodeId);
                    }
                }
            }
        }
    }

    /**
     * 预处理：对强制分支或不带分支的自动跳过的非知会节点做一次预处理，看这些节点后面是否有分支和选人节点，如果有，则不能自动跳过，得选人
     * @param context
     * @param process
     * @param cpMatchResult
     * @param isClearAddition
     * @throws BPMException 
     */
    private void doAfter(WorkflowBpmContext context,BPMProcess process,CPMatchResultVO cpMatchResult,
            boolean isClearAddition,Map<String, ConditionMatchResultVO> condtionResultAll,Map<String,Boolean> autoSkipNodeMap) throws BPMException {
        Set<String> allSelectNodes= new HashSet<String>();
        Set<String> allSelectInformNodes= new HashSet<String>();
        Set<String> allNotSelectNodes= new HashSet<String>();
        Set<String> allCurrentSelectInformNodes= new HashSet<String>();
        Set<String> myCurrentSelectInformNodes= cpMatchResult.getCurrentSelectInformNodes();
        if(null!= cpMatchResult.getAllSelectInformNodes()){
            allSelectInformNodes.addAll(cpMatchResult.getAllSelectInformNodes());
        }
        if(null!=myCurrentSelectInformNodes){
            allSelectInformNodes.addAll(myCurrentSelectInformNodes);
            allCurrentSelectInformNodes.addAll(myCurrentSelectInformNodes);
        }
        List<String> checkedNodeIds= new ArrayList<String>();
        if(null!=myCurrentSelectInformNodes){
            for (String myNodeId : myCurrentSelectInformNodes) {
                BPMAbstractNode myNode= process.getActivityById(myNodeId);
                if(!ObjectName.isInformObject(myNode)){//非知会节点
                    checkedNodeIds.add(myNodeId);
                    allSelectInformNodes.remove(myNodeId);
                }
                allSelectNodes.add(myNodeId);
            }
        }
        
        boolean isNeedDo= false;
        Map<String, ConditionMatchResultVO> conditionMatchResultVOMap= cpMatchResult.getCondtionMatchMap();
        if(null!=conditionMatchResultVOMap){
            Set<String> keys= conditionMatchResultVOMap.keySet();
            for (String myNodeId : keys) {
                ConditionMatchResultVO conditionMVO= conditionMatchResultVOMap.get(myNodeId);
                if(conditionMVO.isHand()){ 
                    allNotSelectNodes.add(myNodeId);
                }
                if(conditionMVO.isHand() && conditionMVO.getNa()=="2"){
                    checkedNodeIds.add(myNodeId);
                    allSelectInformNodes.add(myNodeId);
                    allSelectNodes.add(myNodeId);
                }
                if(conditionMVO.getNa()=="2"){
                    isNeedDo= true;
                }
            }
        }
        
        if(!checkedNodeIds.isEmpty()){//确实存在自动跳过的非知会节点
            
            if(isNeedDo){
                if(null!= cpMatchResult.getAllNotSelectNodes()){
                    allNotSelectNodes.addAll(cpMatchResult.getAllNotSelectNodes());
                }
                if(null!= cpMatchResult.getAllSelectNodes()){
                    allSelectNodes.addAll(cpMatchResult.getAllSelectNodes());
                }
                if(null!= cpMatchResult.getCurrentSelectNodes()){
                    allSelectNodes.addAll(cpMatchResult.getCurrentSelectNodes());
                }
                
                for(int i=0;i<checkedNodeIds.size();i++){
                    String checkedNodeId= checkedNodeIds.get(i);
                    boolean myResult= this.doAfterMatch(context, process, checkedNodeId, allNotSelectNodes,
                            allSelectNodes, allSelectInformNodes, allCurrentSelectInformNodes, isClearAddition,true,autoSkipNodeMap);
                    if(myResult){//需要选人
                        ConditionMatchResultVO conditionMVO= null;
                        if(null!=conditionMatchResultVOMap.get(checkedNodeId)){
                            conditionMVO= conditionMatchResultVOMap.get(checkedNodeId);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setId(checkedNodeId);
                            conditionMVO.setNeedSelectPeople(true);
                            
                            conditionMVO.setNa("00");
                            if(!conditionMVO.isHand()){
                                conditionMVO.setToNodeIsInform(false);
                            }
                        }else if(null!=condtionResultAll.get(checkedNodeId)){
                            conditionMVO= condtionResultAll.get(checkedNodeId);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setId(checkedNodeId);
                            conditionMVO.setNeedSelectPeople(true);
                            conditionMVO.setNa("00");
                            if(!conditionMVO.isHand()){
                                conditionMVO.setToNodeIsInform(false);
                            }
                        }else{
                            BPMAbstractNode myNode= process.getActivityById(checkedNodeId);
                            conditionMVO = new ConditionMatchResultVO();
                            conditionMVO.setConditionDesc("");
                            conditionMVO.setConditionTitle("");
                            conditionMVO.setNodePolicy(myNode.getSeeyonPolicy().getName());
                            conditionMVO.setConditionType("3");
                            conditionMVO.setHand(false);
                            conditionMVO.setHasBranch(false);
                            conditionMVO.setNeedSelectPeople(true);
                            conditionMVO.setCanAutoSkip(false);
                            conditionMVO.setNa("0");
                            conditionMVO.setNeedPeopleTag(true);
                            conditionMVO.setMatchResult(true);
                            conditionMVO.setDefaultShow(true);
                            String matchResultName= "";
                            conditionMVO.setMatchResultName(matchResultName);
                            conditionMVO.setProcessMode(myNode.getSeeyonPolicy().getProcessMode());
                            String processModeName= MessageUtil.getString("workflow.commonpage.processmode."+myNode.getSeeyonPolicy().getProcessMode());
                            conditionMVO.setProcessModeName(processModeName);
                            conditionMVO.setToNodeId(checkedNodeId);
                            conditionMVO.setToNodeIsInform(false);
                            conditionMVO.setToNodePolicyId(myNode.getSeeyonPolicy().getId());
                            conditionMVO.setToNodeName(myNode.getName());
                        }
                        conditionMatchResultVOMap.put(checkedNodeId, conditionMVO);
                        cpMatchResult.getCurrentSelectInformNodes().remove(checkedNodeId);
                        cpMatchResult.getAllSelectInformNodes().remove(checkedNodeId);
                        if(!conditionMVO.isHand()){
                            cpMatchResult.getCurrentSelectNodes().add(checkedNodeId); 
                        }else{
                            allCurrentSelectInformNodes.add(checkedNodeId);
                            allSelectInformNodes.add(checkedNodeId);
                        }
                    }else{
                        allCurrentSelectInformNodes.add(checkedNodeId);
                        allSelectInformNodes.add(checkedNodeId);
                    }
                }
            }
        }
    }

    private void findMyParent(BPMAbstractNode myNode, Set<String> currentSelectInformNodes,boolean isFirst) {
        if(null== currentSelectInformNodes || currentSelectInformNodes.isEmpty()){
            return;
        }
        if(myNode.getNodeType().equals(BPMAbstractNode.NodeType.start)){
            return;
        }
        if(myNode.getNodeType().equals(BPMAbstractNode.NodeType.humen)){
            if(!ObjectName.isInformObject(myNode) && !isFirst){
                return;
            }
        }
        List<BPMTransition> ups= myNode.getUpTransitions();
        for (BPMTransition bpmTransition : ups) {
            if(currentSelectInformNodes.isEmpty()){
                break;
            }
            BPMAbstractNode p= bpmTransition.getFrom();
            if(ObjectName.isInformObject(p)){
                if(currentSelectInformNodes.contains(p.getId())){
                    currentSelectInformNodes.remove(p.getId());
                }
                if(currentSelectInformNodes.isEmpty()){
                    break;
                }
                findMyParent(p,currentSelectInformNodes,false);
            }else if( p.getNodeType().equals(BPMAbstractNode.NodeType.split) || p.getNodeType().equals(BPMAbstractNode.NodeType.join)){
                findMyParent(p,currentSelectInformNodes,false);
            }
        }
    }

    /**
     * @return the workItemManager
     */
    public WorkItemManager getWorkItemManager() {
        return workItemManager;
    }

    /**
     * @param workItemManager the workItemManager to set
     */
    public void setWorkItemManager(WorkItemManager workItemManager) {
        this.workItemManager = workItemManager;
    }

    /**
     * @return the caseManager
     */
    public CaseManager getCaseManager() {
        return caseManager;
    }

    /**
     * @param caseManager the caseManager to set
     */
    public void setCaseManager(CaseManager caseManager) {
        this.caseManager = caseManager;
    }

    @Override
    public int cancelCase(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        return engine.cancelCase(context);
    }

    @Override
    public int takeBack(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        return engine.takeBack(context);
    }

    @Override
    public void stopCase(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        engine.stopCase(context);
    }

    @Override
    public void temporaryPending(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(context.getConditionsOfNodes());
        context.setMatchRequestToken(matchRequestToken);
        engine.temporaryPending(context);
    }

    @Override
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON, String changeMessageJSON)
            throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String[] result= engine.addNode(processId, currentActivityId, targetActivityId, userId, changeType, message,
                baseProcessXML, baseReadyObjectJSON,null, changeMessageJSON);
        DBAgent.commit();//解决移动端调用问题
        return result;
    }
    
    
    @Override
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON,String messageDataList
            , String changeMessageJSON, List<BPMHumenActivity> addHumanNodes)
            throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String[] result= engine.addNode(processId, currentActivityId, targetActivityId, userId, changeType, message,
                baseProcessXML, baseReadyObjectJSON,messageDataList, changeMessageJSON, addHumanNodes);
        DBAgent.commit();//解决移动端调用问题
        return result;
    }
    
    @Override
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON,String messageDataList, String changeMessageJSON)
            throws BPMException {
        String[] result= addNode(processId, currentActivityId, targetActivityId, userId, changeType, message, baseProcessXML
                , baseReadyObjectJSON, messageDataList, changeMessageJSON, null);
        DBAgent.commit();//解决移动端调用问题
        return result;
    }

    @Override
    public String[] deleteNode(String processId, String currentActivityId, String userId, List<String> activityIdList,
            String baseProcessXML, String changeMessageJSON) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String[] result= engine.deleteNode(processId, currentActivityId, userId, activityIdList, baseProcessXML,null,changeMessageJSON,null,null);
        return result;
    }
    
    @Override
    public String[] deleteNode(String processId, String currentActivityId, String userId, List<String> activityIdList,
            String baseProcessXML, String messageDataList, String changeMessageJSON, String summaryId, String affairId) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String[] result = engine.deleteNode(processId, currentActivityId, userId, activityIdList, baseProcessXML,
                messageDataList, changeMessageJSON, summaryId, affairId);
        return result;
    }

    @Override
    public void readWorkItem(Long workitemId) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        engine.readWorkItem(workitemId);
    }

    /**
     * @return the subProcessManager
     */
    public SubProcessManager getSubProcessManager() {
        return subProcessManager;
    }

    /**
     * @param subProcessManager the subProcessManager to set
     */
    public void setSubProcessManager(SubProcessManager subProcessManager) {
        this.subProcessManager = subProcessManager;
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

    @Override
    public void awakeCase(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        String appName = context.getAppName();
        String processTemplateId = context.getProcessTemplateId();
        String currentUserId = context.getStartUserId();
        String currentUserName = context.getStartUserName();
        long currentWorkitemId = context.getCurrentWorkitemId();
        String currentAccountId = context.getStartAccountId();
        String currentAccountName = context.getStartAccountName();
        String statusId = context.getNextActivityId();
        engine.awakeCase(context);
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

    @Override
    public String saveProcessXmlDraf(String processId, String processXml, String moduleType) throws BPMException {
        com.seeyon.ctp.common.authenticate.domain.User user= AppContext.getCurrentUser();
        String startUserId= user.getId().toString();
        String startUserName= user.getName();
        String startUserLoginAccountId= user.getLoginAccount().toString();
        if (processId != null && !processId.trim().equals("") && !processId.trim().equals("-1")) {//更新
            if (processXml != null && !"".equals(processXml.trim())) {
                //自由流程保存待发
                BPMProcess process= BPMProcess.fromXML(processXml);
                process.setId(processId);
                process = processManager.saveOrUpdateProcessByXML(process, processId, null, null,startUserId,startUserName,startUserLoginAccountId);
                processManager.updateRunningProcess(process,null);
            } else {
                //模版协同保存待发什么都不做
                return null;
            }
        } else {//新增
            BPMProcess process= BPMProcess.fromXML(processXml);
            process = processManager.saveOrUpdateProcessByXML(process, null, null, null,startUserId,startUserName,startUserLoginAccountId);
            processId = processManager.saveRunningProcess(process,null);
        }
        return processId;
    }

    @Override
    public void deleteProcessXmlDraf(String processId, String moduleType, Long currentUserId, String currentUserName)
            throws BPMException {
        if (processId != null && !processId.trim().equals("") && !processId.trim().equals("-1")) {//删除
            processManager.deleteRunningProcess(processId);
        }
    }

    public String[] getWorkflowInfos(String processId, String moduleType, CtpEnumBean nodePermissionPolicy)
            throws BPMException {
    	 if (Strings.isNotBlank(processId) && !processId.trim().equals("-1")) {//删除
             return processManager.getWorkflowNodesInfoAndDR(processId, nodePermissionPolicy);
         } else {
             return new String[2];
         }
    }
    
    public String[] getWorkflowInfos(BPMProcess process, String moduleType, CtpEnumBean nodePermissionPolicy)
            throws BPMException {
        if (process != null) {//删除
            return processManager.getWorkflowNodesInfoAndDR(process, nodePermissionPolicy);
        } else {
            return new String[2];
        }
    }
    @Override
    public String getWorkflowNodesInfo(String processId, String moduleType, CtpEnumBean nodePermissionPolicy)
            throws BPMException {
        if (Strings.isNotBlank(processId) && !processId.trim().equals("-1")) {//删除
            return processManager.getWorkflowNodesInfo(processId, nodePermissionPolicy);
        } else {
            return "";
        }
    }

    @Override
    public List<String> getWorkflowUsedPolicyIds(String moduleType, String processXml, String processId,
            String processTemplateId) throws BPMException {
        List<String> returnList = new ArrayList<String>();
        if (null != processXml && !"".equals(processXml.trim())) {
            BPMProcess bpmProcess = BPMProcess.fromXML(processXml);
            if(bpmProcess!=null){
                returnList = processManager.getWorkflowUsedPolicyIds(bpmProcess);
            }
            return returnList;
        }
        if (null != processId && !"".equals(processId.trim()) && !"-1".equals(processId.trim())) {
            BPMProcess bpmProcess = processManager.getRunningProcess(processId);
            if(bpmProcess!=null){
                returnList = processManager.getWorkflowUsedPolicyIds(bpmProcess);
            }
            return returnList;
        }
        if (null != processTemplateId && !"".equals(processTemplateId.trim()) && !"-1".equals(processTemplateId.trim())) {
            String processXml1 = processTemplateManager.selectProcessTempateXml(processTemplateId);
            BPMProcess bpmProcess = BPMProcess.fromXML(processXml1);
            if(bpmProcess!=null){
                returnList = processManager.getWorkflowUsedPolicyIds(bpmProcess);
            }
            return returnList;
        }
        return returnList;
    }

    @Override
    public String getWorkflowRuleInfo(String moduleType, String processTemplateId) throws BPMException {
        ProcessTemplete pt = processTemplateManager.selectProcessTempate(processTemplateId);
        if (null != pt) {
            return pt.getWorkflowRule();
        }
        return "";
    }

    @Override
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId)
            throws BPMException {
//        int state = 0;//草稿
//        long id = processTemplateManager.insertProcessTemplate(moduleType, processName, processXml, workflowRule,
//                createUser, formId, batchId, state, subProcessSetting);
//        return id;
        return insertWorkflowTemplate(moduleType, processName, processXml, subProcessSetting, workflowRule, createUser, formId, batchId, null);
    }
    
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId, String processEventJson)
            throws BPMException {
        int state = 0;//草稿
        long id = processTemplateManager.insertProcessTemplate(moduleType, processName, processXml, workflowRule,
                createUser, formId, batchId, state, subProcessSetting, processEventJson);
        return id;
    }

    @Override
    public long updateWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String modifyUser, long formId, long batchId, long id)
            throws BPMException {
        int state = 0;//草稿
        long newId = processTemplateManager.updateProcessTemplate(moduleType, processName, processXml, workflowRule,
                modifyUser, formId, batchId, state, id, subProcessSetting);
        return newId;
    }
    
    @Override
    public long updateWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String modifyUser, long formId, long batchId, long id, String processEventJson)
            throws BPMException {
        int state = 0;//草稿
        long newId = processTemplateManager.updateProcessTemplate(moduleType, processName, processXml, workflowRule,
                modifyUser, formId, batchId, state, id, subProcessSetting, processEventJson);
        return newId;
    }

    @Override
    public long saveWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId, long id)
            throws BPMException {
        if (id == 0 || id == -1) {
            id = this.insertWorkflowTemplate(moduleType, processName, processXml, subProcessSetting, workflowRule,
                    createUser, formId, batchId);
        } else {
            this.updateWorkflowTemplate(moduleType, processName, processXml, subProcessSetting, workflowRule,
                    createUser, formId, batchId, id);
        }
        return id;
    }

    @Override
    public void deleteWorkflowTemplate(long batchId, long id) throws BPMException {
        processTemplateManager.deleteWorkflowTemplate(batchId, id);
    }

    public void mergeWorkflowTemplate(long templateId) throws BPMException{
        
        //根据原始ID查询对应记录的状态:
        //修改模板时通过新的模板，将新的模板ID的信息同步到老的模板里面，并删除新生成的模板信息
        processTemplateManager.mergeWorkflowTemplate(templateId);
    }
    
    @Override
    public  List<ProcessTemplete>  saveWorkflowTemplates(long batchId) throws BPMException {
        //根据原始ID和BATCH查询对应记录的状态:
        //1.如果为草稿状态，则将状态直接改为已发布状态，将对应的子流程设置表中的记录标志为生效状态。
        //2.如果为已发布状态，则根据原始ID、BATCH来查询old_template_Id对应的记录，如果有对应的记录，且记录状态为草稿状态，将这条记录的workflow等信息更新到已发布记录的对应字段中，然后删除old_template_Id对应的记录，将对应的子流程设置表中的记录标志为生效状态。
        //3.如果为待删除状态，则直接将该条记录删除掉,根据ID将子流程设置表中为草稿状态的记录删除掉。
        List<ProcessTemplete> pts = processTemplateManager.saveWorkflowTemplates(batchId);
        return pts;
    }

    @Override
    public void deleteWorkflowTemplates(long batchId) throws BPMException {
        //1.根据BATCH将所有草稿状态的记录删除
        //2.根据ID将子流程设置表中为草稿状态的记录删除掉。
        //3.根据BATCH和ID将待删除状态记录修改为已发布状态。
        List<ProcessTemplete> pts = processTemplateManager.deleteWorkflowTemplates(batchId);
    }

    @Override
    public void deleteJunkDataOfWorkflowTemplates(long formId) throws BPMException {
        processTemplateManager.deleteJunkDataOfWorkflowTemplates(formId);
    }

    @Override
    public long saveWorkflowTemplate(String moduleType, String processName, long processTemplateId, String processXml,
            String workflowRule, String createUser) throws BPMException {
//        if (processTemplateId != -1 && processTemplateId != 0) {
//            return processTemplateManager.updateProcessTemplate(moduleType, processName, processXml, workflowRule,
//                    createUser, -1, -1, 1, processTemplateId, null);
//        } else {
//            return processTemplateManager.insertProcessTemplate(moduleType, processName, processXml, workflowRule,
//                    createUser, -1, -1, 1, null);
//        }
        return saveWorkflowTemplate(moduleType, processName, processTemplateId, processXml, workflowRule, createUser, null);
    }
    
    @Override
    public long saveWorkflowTemplate(String moduleType, String processName, long processTemplateId, String processXml,
            String workflowRule, String createUser, String processEventJson) throws BPMException {
        if (processTemplateId != -1 && processTemplateId != 0) {
            return processTemplateManager.updateProcessTemplate(moduleType, processName, processXml, workflowRule,
                    createUser, -1, -1, 1, processTemplateId, null, processEventJson);
        } else {
            return processTemplateManager.insertProcessTemplate(moduleType, processName, processXml, workflowRule,
                    createUser, -1, -1, 1, null, processEventJson);
        }
    }
    
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String workflowRule, String createUser) throws BPMException {
        return processTemplateManager.insertProcessTemplate(moduleType, processName, processXml, workflowRule,
                createUser, -1, -1, 1, null);
    }
    
    public long updateWorkflowTemplate(long id,String moduleType, String processName, String processXml,
            String workflowRule, String modifyUser) throws BPMException {
        ProcessTemplete oldPT= processTemplateManager.selectProcessTempate(String.valueOf(id));
        ProcessTemplete pt= new ProcessTemplete();
        pt.setId(id);
        pt.setProcessName(processName);
        pt.setAppId(-1);
        pt.setBatchId(-1L);
        pt.setModifyUser(modifyUser);
        pt.setModifyDate(new Timestamp(System.currentTimeMillis()));
        pt.setState(1);
        pt.setWorkflow(processXml);
        pt.setWorkflowRule(workflowRule);
        pt.setCreateDate(oldPT.getCreateDate());
        pt.setCreateUser(oldPT.getCreateUser());
        processTemplateManager.updateProcessTemplate(pt);
        return id;
    }
    

    @Override
    public void deleteWorkflowTemplate(long processTemplateId) throws BPMException {
        processTemplateManager.deleteWorkflowTemplate(processTemplateId);
    }

    @Override
    public String[] getNodePolicyIdAndName(String appName, String processId, String activityId) throws BPMException {
        if (processId == null || "0".equals(processId.trim()) || "-1".equals(processId.trim())
                || "".equals(processId.trim())) {
            return null;
        }
        if (appName == null || "".equals(appName.trim())) {
            return null;
        }
        BPMProcess process = processManager.getRunningProcess(processId);
        BPMSeeyonPolicy seeyonPolicy = null;
        if ("start".equals(activityId)) {
            BPMStart start = (BPMStart) process.getStart();
            seeyonPolicy = start.getSeeyonPolicy();
        } else {
            BPMActivity activity = process.getActivityById(activityId);
            if(activity!=null){
            	seeyonPolicy = activity.getSeeyonPolicy();
            }else{
                logger.warn("找不到节点activityId:="+activityId);
            }
        }
        String[] result = null;
        if(seeyonPolicy!=null){
            result = new String[] { seeyonPolicy.getId(), seeyonPolicy.getName() };
        }
        if(null==result){
            logger.warn("appName:="+appName);
            if(Strings.isNotBlank(appName) && "edoc".equals(appName)){
                result = new String[] { BPMSeeyonPolicy.EDOC_POLICY_CHUANYUE.getId(), BPMSeeyonPolicy.EDOC_POLICY_CHUANYUE.getName() };
            }else if(Strings.isNotBlank(appName) && "collaboration".equals(appName)){
                result = new String[] { BPMSeeyonPolicy.SEEYON_POLICY_COLLABORATE.getId(), BPMSeeyonPolicy.SEEYON_POLICY_COLLABORATE.getName() };
            }else{
                result = new String[] { BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getId(), BPMSeeyonPolicy.SEEYON_POLICY_INFORM.getName() };
            }
        }
        return result;
    }

    @Override
    public Long cloneWorkflowTemplateById(Long templateId, int state) throws BPMException {
        Long newId = 0L;
        if (templateId != null) {
            ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(templateId);
            if (oldTemplete != null) {
                String newName = oldTemplete.getProcessName() + "(copyedBy" + oldTemplete.getId() + ")";
                newId = processTemplateManager.insertProcessTemplate(null, newName, oldTemplete.getWorkflow(),
                        oldTemplete.getWorkflowRule(), String.valueOf(AppContext.getCurrentUser().getId()),
                        oldTemplete.getAppId(), 0L, state, null);
                String newIdString = String.valueOf(newId);
                //将老模版的子流程全部拷贝一份，设置为新的草稿状态的记录Id
                List<SubProcessSetting> subProcessSettingList = subProcessManager.getAllSubProcessSettingByTemplateId(
                        String.valueOf(oldTemplete.getId()), null);
                if (subProcessSettingList != null && subProcessSettingList.size() > 0) {
                    List<SubProcessSetting> newSubList = new ArrayList<SubProcessSetting>();
                    SubProcessSetting newSub = null;
                    for (SubProcessSetting setting : subProcessSettingList) {
                        newSub = new SubProcessSetting();
                        newSub.setId(UUIDLong.longUUID());
                        newSub.setConditionBase(setting.getConditionBase());
                        newSub.setConditionTitle(setting.getConditionTitle());
                        newSub.setCreateTime(setting.getCreateTime());
                        newSub.setFlowRelateType(setting.getFlowRelateType());
                        newSub.setIsCanViewByMainFlow(setting.getIsCanViewByMainFlow());
                        newSub.setIsCanViewMainFlow(setting.getIsCanViewMainFlow());
                        newSub.setIsForce(setting.getIsForce());
                        newSub.setNewflowSender(setting.getNewflowSender());
                        newSub.setNewflowTempleteId(setting.getNewflowTempleteId());
                        newSub.setNodeId(setting.getNodeId());
                        newSub.setSubject(setting.getSubject());
                        newSub.setTempleteId(newId);
                        newSub.setTriggerCondition(setting.getTriggerCondition());
                        newSubList.add(newSub);
                    }
                    subProcessManager.saveSubProcessSetting(newSubList);
                }
            } else {
                logger.info("Workflow:模版复制：指定的templateId不存在对应模版：" + templateId);
            }
        } else {
            logger.info("Workflow:模版复制：没有给定正确的模版Id：null");
        }
        return newId;
    }
    
    public Map<Long, Long> cloneWorkflowFormTemplateById(Map<Long, String> templateIdMap, Long newFormApp, Map<String, String> newViewOperationId,Map<String,String> otherIdMaps, int state) throws BPMException{
        Map<Long, Long> result = new HashMap<Long, Long>(0);
        if (templateIdMap!=null && templateIdMap.size()>0) {
            result = new HashMap<Long, Long>(templateIdMap.size());
            //ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(templateId);
            List<Long> oldTemplateIdList = new ArrayList<Long>();
            for(Map.Entry<Long, String> entry : templateIdMap.entrySet()){
                oldTemplateIdList.add(entry.getKey());
            }
            List<ProcessTemplete> templeteList = processTemplateManager.selectProcessTemplateByIdList(oldTemplateIdList);
            Map<Long, ProcessTemplete> templeteMap = new HashMap<Long, ProcessTemplete>();
            if(templeteList!=null && templeteList.size()>0){
                //所有的模版先拷贝一份
                for(ProcessTemplete templete : templeteList){
                    templeteMap.put(templete.getId(), templete);
                    ProcessTemplete oldTemplete = templete;
                    String newName = templateIdMap.get(templete.getId());
                    if (oldTemplete != null) {
                        String newWorkflow = oldTemplete.getWorkflow();
                        //将老的模版中的表单id和视图id替换为新的。
                        if(newViewOperationId!=null && newViewOperationId.size()>0){
                            if(newWorkflow==null){
                                newWorkflow =  "";
                            }
                            BPMProcess process = BPMProcess.fromXML(newWorkflow);
                            if(process!=null){
                            	
                            	//数据关联配置不支持复制， 相关数据进行重置
                                reSetProcessDR(process);
                                
                                BPMStatus start = process.getStart();
                                String oldOperationId="", oldViewid="", temp="", newOperationId="", newViewId="",oldFormApp="";
                                int index = -1;
                                {
                                    oldFormApp= start.getSeeyonPolicy().getFormApp();
                                    start.getSeeyonPolicy().setFormApp(newFormApp.toString());
                                    oldOperationId = start.getSeeyonPolicy().getOperationName();
                                    Long operationIdNew= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestOperationId(Long.parseLong(oldFormApp), Long.parseLong(oldOperationId));
                                    oldViewid = start.getSeeyonPolicy().getForm();
                                    temp = newViewOperationId.get(oldViewid+"."+operationIdNew.toString());
                                    if(temp!=null){
                                        index = temp.indexOf(".");
                                        newViewId = temp.substring(0,index);
                                        newOperationId = temp.substring(index+1);
                                        if(!"".equals(newOperationId)){
                                            start.getSeeyonPolicy().setOperationName(newOperationId);
                                        }
                                        if(!"".equals(newViewId)){
                                            start.getSeeyonPolicy().setForm(newViewId);
                                        }
                                    }
                                }
                                List<BPMAbstractNode> allNodes = process.getActivitiesList();//WorkflowUtil.findAllChildHumenActivitys(process.getStart());
                                if(allNodes!=null && allNodes.size()>0){
                                    for(BPMAbstractNode node : allNodes){
                                        if(node.getNodeType().equals(BPMAbstractNode.NodeType.humen)){
                                            node.getSeeyonPolicy().setFormApp(newFormApp.toString());
                                            {
                                                node.getSeeyonPolicy().setFormApp(newFormApp.toString());
                                                oldOperationId = node.getSeeyonPolicy().getOperationName();
                                                Long operationIdNew= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestOperationId(Long.parseLong(oldFormApp), Long.parseLong(oldOperationId));
                                                oldViewid = node.getSeeyonPolicy().getForm();
                                                temp = newViewOperationId.get(oldViewid+"."+operationIdNew.toString());
                                                if(temp!=null){
                                                    index = temp.indexOf(".");
                                                    newViewId = temp.substring(0,index);
                                                    newOperationId = temp.substring(index+1);
                                                    if(!"".equals(newOperationId)){
                                                        node.getSeeyonPolicy().setOperationName(newOperationId);
                                                    }
                                                    if(!"".equals(newViewId)){
                                                        node.getSeeyonPolicy().setForm(newViewId);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                newWorkflow = process.toXML(null,true);
                            }
                        }
                        if(null!=newViewOperationId){//对一些老的ID做统一的替换 
                            Set<String> oldIds= newViewOperationId.keySet();
                            for (String oldId : oldIds) {
                                int oldIndex= oldId.indexOf(".");
                                String oldViewId = oldId.substring(0,oldIndex);
                                String oldOperationId = oldId.substring(oldIndex+1);
                                String temp = newViewOperationId.get(oldId);
                                int index = temp.indexOf(".");
                                String newViewId = temp.substring(0,index);
                                String newOperationId = temp.substring(index+1);
                                if(!"".equals(newOperationId)){
                                    newWorkflow= newWorkflow.replaceAll(oldOperationId, newOperationId);
                                }
                                if(!"".equals(newViewId)){
                                    newWorkflow= newWorkflow.replaceAll(oldViewId, newViewId);
                                }
                            }
                        }
                        if(null!=otherIdMaps){
                            Set<String> oldIds= otherIdMaps.keySet();
                            for (String oldId : oldIds) {
                                String newId = otherIdMaps.get(oldId);
                                newWorkflow= newWorkflow.replaceAll(oldId, newId);
                            }
                        }
                        Long newId = processTemplateManager.insertProcessTemplate(null, newName, newWorkflow,
                                oldTemplete.getWorkflowRule(), String.valueOf(AppContext.getCurrentUser().getId()),
                                newFormApp, 0L, state, null);
                        result.put(templete.getId(), newId);
                    }
                }
                //在拷贝所有的子流程
                for(ProcessTemplete templete : templeteList){
                    ProcessTemplete oldTemplete = templete;
                    //将老模版的子流程全部拷贝一份，设置为新的草稿状态的记录Id
                    List<SubProcessSetting> subProcessSettingList = subProcessManager.getAllSubProcessSettingByTemplateId(
                            String.valueOf(oldTemplete.getId()), null);
                    if (subProcessSettingList != null && subProcessSettingList.size() > 0) {
                        List<SubProcessSetting> newSubList = new ArrayList<SubProcessSetting>();
                        SubProcessSetting newSub = null;
                        Long newTemplateId = result.get(templete.getId());
                        for (SubProcessSetting setting : subProcessSettingList) {
                            newSub = new SubProcessSetting();
                            newSub.setId(UUIDLong.longUUID());
                            newSub.setConditionBase(setting.getConditionBase());
                            newSub.setConditionTitle(setting.getConditionTitle());
                            newSub.setCreateTime(setting.getCreateTime());
                            newSub.setFlowRelateType(setting.getFlowRelateType());
                            newSub.setIsCanViewByMainFlow(setting.getIsCanViewByMainFlow());
                            newSub.setIsCanViewMainFlow(setting.getIsCanViewMainFlow());
                            newSub.setIsForce(setting.getIsForce());
                            newSub.setNewflowSender(setting.getNewflowSender());
                            Long newSubTemplateId = result.get(setting.getNewflowTempleteId());
                            //如果子流程没有新id存在，那么就不复制子流程绑定数据
                            if(newSubTemplateId==null){
                                continue;
                            }
                            newSub.setNewflowTempleteId(newSubTemplateId);
                            newSub.setNodeId(setting.getNodeId());
                            String newName = templateIdMap.get(setting.getNewflowTempleteId());
                            if(newName!=null && !"".equals(newName.trim())){
                                newSub.setSubject(newName);
                            } else {
                                newSub.setSubject(setting.getSubject());
                            }
                            newSub.setTempleteId(newTemplateId);
                            newSub.setTriggerCondition(setting.getTriggerCondition());
                            newSubList.add(newSub);
                        }
                        subProcessManager.saveSubProcessSetting(newSubList);
                    }
                }
            }
        } else {
            logger.info("Workflow:表单模版复制：没有给定正确的模版Id：" + templateIdMap);
        }
        return result;
    }

    @Override
	public Map<Long, Long> cloneWorkflowFormTemplateById(
			Map<Long, String> templateIdMap, Long newFormApp,
			Map<String, String> newViewOperationId, int state)
			throws BPMException {
    	return this.cloneWorkflowFormTemplateById(templateIdMap, newFormApp, newViewOperationId, null, state);
	}

	@Override
    public Map<String, String> exportWorkFlow(List<String> workflowIds) throws BPMException {
        return exportWorkFlow(workflowIds, true);
    }

    private Map<String, String> exportWorkFlow(List<String> workflowIds, boolean flag) throws BPMException {
        Map<String, String> result = new HashMap<String, String>();
        if (workflowIds != null && workflowIds.size() > 0) {
            List<Long> templateIdList = new ArrayList<Long>();
            for (String idString : workflowIds) {
                templateIdList.add(Long.parseLong(idString));
            }
            List<ProcessTemplete> templateList = processTemplateManager.selectProcessTemplateByIdList(templateIdList);
            List<SubProcessSetting> subSettingList = subProcessManager.getAllSubProcessSettingByTemplateId(templateIdList);
            //如果标记为true，进行子流程模版的校验，如果子流程模版不是下载列中，将它加入进来
            //看下子流程是否都在下载列中
            if (flag && subSettingList != null && subSettingList.size() > 0) {
                List<Long> subTempleteIdList = new ArrayList<Long>();
                Map<Long, ProcessTemplete> templeteMap = new HashMap<Long, ProcessTemplete>();
                for (ProcessTemplete templete : templateList) {
                    templeteMap.put(templete.getId(), templete);
                }
                //查看子流程对应的模版是否在导出之列，如果不在，就查询出来
                for (SubProcessSetting subSetting : subSettingList) {
                    Long templeteId = subSetting.getNewflowTempleteId();
                    if (templeteMap.get(templateIdList) == null) {
                        subTempleteIdList.add(templeteId);
                    }
                }
                //如果找到子流程模版没有在下载列中，将它查询出来加入
                if (subTempleteIdList.size() > 0) {
                    List<ProcessTemplete> subTemplateList = processTemplateManager
                            .selectProcessTemplateByIdList(subTempleteIdList);
                    if (subTemplateList != null && subTemplateList.size() > 0) {
                        templateList.addAll(subTemplateList);
                    }
                }
            }
            //创建导出数据，其实就转换成xml
            result = ImExportUtil.createExpertMap(templateList, subSettingList);
        }
        return result;
    }
    
    @Override
	public List<File> exportWorkflowDiagram(Long workflowId, boolean isZip) throws BPMException {
		ProcessTemplete processTemplete= processTemplateManager.selectProcessTemplateById(workflowId);
		if(null!=processTemplete){
			String processXml= processTemplete.getWorkflow();
			List<File> files= generateWorkflowDiagramFiles(processXml,isZip);
			return files;
		}
		return null;
	}

	@Override
	public List<File> generateWorkflowDiagramFiles(String processXml, boolean isZip) throws BPMException {
		if(Strings.isNotBlank(processXml)){
			try{
				List<Object[]> linkDatas = new ArrayList<Object[]>();
	    		String currentPath = new File("").getAbsolutePath() + "/temp";
	    		long currentTime = System.currentTimeMillis();
	    		File temp = new File(currentPath+"/"+currentTime);
	    		temp.mkdirs();
	    		String imagePath= temp.getAbsolutePath() + "/"+ResourceUtil.getString("workflow.export.file.image")+".png";
	    		String branchPath= temp.getAbsolutePath() + "/"+ResourceUtil.getString("workflow.export.file.xls")+".xls";
	    		String zipPath= temp.getAbsolutePath() + "/workflow.zip";
	            File zipFile = new File(zipPath);
	            File imageFile = new File(imagePath);
	            File branchFile = new File(branchPath);
	            //绘图
	            CalculateProcessNodePosition caculate= new CalculateProcessNodePosition();
	            ProcessNodePositionVO vo= caculate.analysisProcessData(processXml);
	            GenerationProcessNodeGraph.generateGraph2D(vo, imagePath, linkDatas);
	            //分支放到excel中
	            DataRecord dataRecords = new DataRecord();
	            dataRecords.setTitle(ResourceUtil.getString("workflow.export.content.title0"));
	            dataRecords.setSheetName(ResourceUtil.getString("workflow.export.file.xls"));
	            dataRecords.setColumnName(new String[]{
	            		ResourceUtil.getString("workflow.export.content.title1")
	            		, ResourceUtil.getString("workflow.export.content.title2")
	            		, ResourceUtil.getString("workflow.export.content.title3")
	            		, ResourceUtil.getString("workflow.export.content.title4")
	            		, ResourceUtil.getString("workflow.export.content.title5")
	            		, ResourceUtil.getString("workflow.export.content.title6")});
				dataRecords.setColumnWith(new short[]{10,30,20,60,100,60});
	            if(linkDatas!=null && !linkDatas.isEmpty()){
	            	DataRow[] datarow = new DataRow[linkDatas.size()];
	            	for(int i=0,len=linkDatas.size(); i<len; i++){
	            		DataRow row = new DataRow();
	    				Object[] ele = linkDatas.get(i);
	    				row.addDataCell(String.valueOf(ele[0]), 1);
	    				row.addDataCell(String.valueOf(ele[1]), 2);
	    				row.addDataCell(String.valueOf(ele[2]), 3);
	    				row.addDataCell(String.valueOf(ele[3]), 4);
	    				row.addDataCell(String.valueOf(ele[4]), 5);
	    				row.addDataCell(String.valueOf(ele[5]), 6);
	    				datarow[i] = row;
	    			}
	    			dataRecords.setRow(datarow);
	            }
				Workbook wb = new HSSFWorkbook();
				wb = doSheets(wb,dataRecords);
				branchFile.createNewFile();
				OutputStream out_ = new BufferedOutputStream(new FileOutputStream(new File(branchPath)));
				wb.write(out_);
	            out_.flush();
	            out_.close();
	            List<File> allFiles= new ArrayList<File>();
				if(!isZip){
					allFiles.add(imageFile);
					allFiles.add(branchFile);
				}else{
					File[] files = new File[2];
	            	files[0] = imageFile;
	            	files[1] = branchFile;
	            	ZipUtil.zip(files, zipFile);
					allFiles.add(zipFile);
				}
				return allFiles;
			}catch(Exception e){
				logger.error("generateWorkflowDiagramFiles失败！", e);
				throw new BPMException("An error occurred in the method generateWorkflowDiagramFiles", e);
			}
		}
		return null;
	}
	
	/**
	 * 创建一个或多个sheet
	 * 
	 * @param dataRecords
	 */
	private Workbook doSheets(Workbook wb,DataRecord... dataRecords) throws Exception {
		int sheetNum = dataRecords.length;
		if (sheetNum == 0) {
			throw new Exception("The data record is empty, cannot creat workbook!");
		}
		Sheet[] sheets = new Sheet[sheetNum];
		DataRecord dataRecord = null;
//		Workbook wb = new HSSFWorkbook();

		this.initStyle(wb);
		for (int i = 0; i < sheetNum; i++) { // 多个sheet
			dataRecord = dataRecords[i];
			if (dataRecord == null) {
				throw new Exception("DataRecord is disabled");
			}
			sheets[i] = wb.createSheet();
			Sheet sheet = sheets[i];
			wb.setSheetName(i, dataRecord.getSheetName()); // 设置表的名字
			if(CollectionUtils.isEmpty(dataRecord.getDataHeadList())){
				doSheet(sheet,dataRecord);
			}else{
				doCrossSheet(sheet,dataRecord);
			}
		}
		return wb;
	}
	
	
	/**
	 * 处理单个sheet
	 * @param sheet
	 * @param dataRecord
	 * @param wb
	 * @param sheetIndex
	 */
	private void doSheet(Sheet sheet,DataRecord dataRecord){
		if(sheet instanceof HSSFSheet){
            HSSFSheet s = (HSSFSheet) sheet;
            s.setGridsPrinted(true); // 打印网格线
        }
		sheet.setHorizontallyCenter(true); // 水平居中
		sheet.setAutobreaks(true);

		String[] columnName = dataRecord.getColumnName();
		int colunmLength = 0;
		if (columnName != null) {
			colunmLength = columnName.length;
		}
		int rowNumber = 0;
		Row row = sheet.createRow(rowNumber++);
		row.setHeightInPoints(25);
		Cell cell = row.createCell(0);
		if (colunmLength > 0) {
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, (colunmLength - 1)));
		}
		cell.setCellValue(dataRecord.getTitle());
		cell.setCellStyle(styleTitle);
		
		if(dataRecord.getSubTitle() != null){
			row = sheet.createRow(rowNumber++);
			row.setHeightInPoints(25);
			cell = row.createCell(0);
			if (colunmLength > 0) {
				sheet.addMergedRegion(new CellRangeAddress(rowNumber - 1, rowNumber - 1, 0, (colunmLength - 1)));
			}
			cell.setCellValue(dataRecord.getSubTitle());
			cell.setCellStyle(styleContentText);
		}
		// 表头
		boolean isAllNull = true;//标识表头是否全为NULL
		for (int c = 0; c < colunmLength; c++) {
			if(Strings.isNotBlank(columnName[c])){
				isAllNull = false;
				break;
			}
		}
		if(!isAllNull){//如果表头全为NULL，则不输出表头
			row = sheet.createRow(rowNumber++);
			row.setHeightInPoints(20);
			for (int c = 0; c < colunmLength; c++) {
				cell = row.createCell( c);
				cell.setCellValue(columnName[c]);
				cell.setCellStyle(styleColumn);
				cell.setAsActiveCell();
			}
		}
		doSheetContent(sheet, dataRecord, rowNumber);
	}
	
	/**
	 * 处理单个sheet的数据内容
	 * @param sheet
	 * @param dataRecord
	 * @param rowNumber
	 */
	private void doSheetContent(Sheet sheet,DataRecord dataRecord,int rowNumber){
		// 列宽度
		short[] columnWith = dataRecord.getColumnWith();
		if(columnWith != null){
			for (int j = 0; j < columnWith.length; j++) {
				sheet.setColumnWidth(j, columnWith[j] * 200);
			}
		}
		// 内容
		for (int index = 0; index < dataRecord.getRow().length; index++) { // 多行数据
			Row row = sheet.createRow(rowNumber++);
			row.setHeightInPoints(20);
			DataRow dataRow = dataRecord.getRow()[index];
			if(dataRow ==null) continue;
            DataCell[] dataCells = dataRow.getCell();

			for (int col = 0; col < dataCells.length; col++) { // 一行数据多单元格
				Cell cell = row.createCell(col);
				DataCell dataCell = dataCells[col];
				if(dataCell == null){
					continue ;
				}
				switch (dataCell.getType()) {
				case DataCell.DATA_TYPE_TEXT:
					cell.setCellStyle(styleContentText);
					cell.setCellValue(dataCell.getContent());
					break;
				case DataCell.DATA_TYPE_BLANK:
					cell.setCellStyle(styleContentBlank);
					cell.setCellType(HSSFCell.CELL_TYPE_BLANK);
					cell.setCellValue(dataCell.getContent());
					break;
				case DataCell.DATA_TYPE_DATE:
					cell.setCellStyle(styleContentDate);
					cell.setCellValue(dataCell.getContent());
					break;
				case DataCell.DATA_TYPE_DATETIME:
					cell.setCellStyle(styleContentDatetime);
					cell.setCellValue(dataCell.getContent());
					break;
				case DataCell.DATA_TYPE_NUMERIC:
					cell.setCellStyle(styleContentNumeric);
					cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
					if(Strings.isBlank(dataCell.getContent())){
						cell.setCellValue("");
					}else{
						try{
							cell.setCellValue(Double.parseDouble(dataCell.getContent()));
						} catch (NumberFormatException e) {
							cell.setCellValue(dataCell.getContent());
						}
					}
					
					break;
				case DataCell.DATA_TYPE_INTEGER:
					cell.setCellStyle(styleContentInteger);
					if(Strings.isBlank(dataCell.getContent())){
						cell.setCellValue("");
					}else{
						try{
							cell.setCellValue(Long.parseLong(dataCell.getContent()));
						} catch (NumberFormatException e) {
							cell.setCellValue(dataCell.getContent());
						}
					}						
					break;
				default:
					cell.setCellStyle(styleContentText);
					cell.setCellValue(dataCell.getContent());
					break;
				}
			}
			// 打印属性
			PrintSetup print = sheet.getPrintSetup();
			sheet.setAutobreaks(true);
			print.setPaperSize(HSSFPrintSetup.A4_PAPERSIZE);
			print.setFitHeight((short) 1);
			print.setFitWidth((short) 1);
		}
	}
	
	/**
	 * 处理单个sheet（两行表头）
	 * @param sheet
	 * @param dataRecord
	 */
	private void doCrossSheet(Sheet sheet,DataRecord dataRecord){
	    if(sheet instanceof HSSFSheet){
	        HSSFSheet s = (HSSFSheet) sheet;
	        s.setGridsPrinted(true); // 打印网格线
	    }
		sheet.setHorizontallyCenter(true); // 水平居中
		sheet.setAutobreaks(true);

		int colunmLength = 0;
		for(DataCell dataCell:dataRecord.getDataHeadList().get(0)){
			colunmLength += dataCell.getColSpan();
		}
		int rowNumber = 0;
		Row row = sheet.createRow(rowNumber++);
		row.setHeightInPoints(25);
		Cell cell = row.createCell(0);
		if (colunmLength > 0) {
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, (colunmLength - 1)));
		}
		cell.setCellValue(dataRecord.getTitle());
		cell.setCellStyle(styleTitle);
		
		if(dataRecord.getSubTitle() != null){
			row = sheet.createRow(rowNumber++);
			row.setHeightInPoints(25);
			cell = row.createCell(0);
			if (colunmLength > 0) {
				sheet.addMergedRegion(new CellRangeAddress(rowNumber - 1, rowNumber - 1, 0, (colunmLength - 1)));
			}
			cell.setCellValue(dataRecord.getSubTitle());
			cell.setCellStyle(styleContentText);
		}
		// 两行表头
		List<DataCell> dataCellsFirst = dataRecord.getDataHeadList().get(0);
		List<DataCell> dataCellsSecond = dataRecord.getDataHeadList().get(1);
		int dataCellsSecondColIndex = 0;
		row = sheet.createRow(rowNumber);
		row.setHeightInPoints(20);
		int columnIndex = 0;
		for (DataCell dataCell:dataCellsFirst) {
			cell = row.createCell(columnIndex);
			if(dataCell.getRowSpan()>1){
				sheet.addMergedRegion(new CellRangeAddress(rowNumber, (rowNumber+dataCell.getRowSpan() -1), columnIndex, columnIndex));
				dataCellsSecondColIndex++;
			}
			if(dataCell.getColSpan()>1){
				sheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber,columnIndex,  (columnIndex+dataCell.getColSpan() -1)));
				columnIndex+=dataCell.getColSpan();
			}else{
				columnIndex++;
			}
			cell.setCellValue(dataCell.getContent());
			cell.setCellStyle(styleColumn);
			cell.setAsActiveCell();
		}
		row = sheet.createRow(++rowNumber);
		row.setHeightInPoints(20);
		columnIndex = dataCellsSecondColIndex;
		for (DataCell dataCell:dataCellsSecond) {
			cell = row.createCell(columnIndex);
			if(dataCell.getRowSpan()>1){
				sheet.addMergedRegion(new CellRangeAddress(rowNumber, (rowNumber+dataCell.getRowSpan() -1), columnIndex, columnIndex));
			}
			if(dataCell.getColSpan()>1){
				sheet.addMergedRegion(new CellRangeAddress(rowNumber, rowNumber,columnIndex,  (columnIndex+dataCell.getColSpan() -1)));
				columnIndex+=dataCell.getColSpan();
			}else{
				columnIndex++;
			}
			cell.setCellValue(dataCell.getContent());
			cell.setCellStyle(styleColumn);
			cell.setAsActiveCell();
		}
		rowNumber++;
		doSheetContent(sheet,dataRecord,rowNumber);
	}
	
	/**
	 * 初始化样式
	 */
	private void initStyle(Workbook wb) {
		styleTitle = wb.createCellStyle();
		styleColumn = wb.createCellStyle();
		styleContentText = wb.createCellStyle();
		styleContentBlank = wb.createCellStyle();
		styleContentDate = wb.createCellStyle();
		styleContentDatetime = wb.createCellStyle();
		styleContentNumeric = wb.createCellStyle();
		styleContentInteger = wb.createCellStyle();		
		DataFormat format = wb.createDataFormat();

		// 标题字体
		Font fontTitle = wb.createFont();
		fontTitle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		fontTitle.setFontHeightInPoints((short) 16);
		// 标题样式
		styleTitle.setFont(fontTitle);
		styleTitle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleTitle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		short dataformat = format.getFormat("text");
        styleTitle.setDataFormat(dataformat);
		// 表头字体
		Font fontCulumn = wb.createFont();
		// fontCulumn.setFontName("宋体");
		// fontCulumn.setFontHeightInPoints( (short) 9);
		fontCulumn.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		// 表头样式
		styleColumn.setFont(fontCulumn);
		styleColumn.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleColumn.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		styleColumn.setDataFormat(dataformat);
		// 内容字体
		Font fontContent = wb.createFont();
		// fontContent.setFontName("宋体");
		// fontContent.setFontHeightInPoints( (short) 12);
		// 内容样式
		// 文本
		styleContentText.setFont(fontContent);
		styleContentText.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleContentText.setHidden(true);
		styleContentText.setWrapText(true);
		styleContentText.setDataFormat(dataformat);
		// 日期
		styleContentDate.setFont(fontContent);
		styleContentDate.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleContentDate.setHidden(true);
		styleContentDate.setWrapText(true);
		styleContentDate.setDataFormat(format.getFormat("yyyy-m-d"));
		// 日期+时间
		styleContentDatetime.setFont(fontContent);
		styleContentDatetime.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleContentDatetime.setHidden(true);
		styleContentDatetime.setWrapText(true);
		styleContentDatetime.setDataFormat(format.getFormat("yyyy-m-d H:mm:ss"));
		// 小数
		styleContentNumeric.setFont(fontContent);
		styleContentNumeric.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleContentNumeric.setHidden(true);
		styleContentNumeric.setWrapText(true);
		styleContentNumeric.setDataFormat(HSSFDataFormat.getBuiltinFormat("0.00"));
		// 整数
		styleContentInteger.setFont(fontContent);
		styleContentInteger.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleContentInteger.setHidden(true);
		styleContentInteger.setWrapText(true);
		styleContentInteger.setDataFormat(format.getFormat("0"));
	}

    @Override
    public Map<String, String> importWorkFlow(File[] files) throws BPMException {
        Map<String, String> resultMap = new HashMap<String, String>();
        boolean success = true;
        String msg = "";
        //从文件解析成工作流模版对象和子流程绑定数据
        Map<ProcessTemplete, List<SubProcessSetting>> templeteMap = ImExportUtil.createImportMap(files);
        if (templeteMap != null && templeteMap.size() > 0) {
            List<Long> willImportTempleteIdList = new ArrayList<Long>();
            List<ProcessTemplete> templeteList = new ArrayList<ProcessTemplete>();
            List<SubProcessSetting> subSettingList = new ArrayList<SubProcessSetting>();
            //把解析得到的工作流模版数据和子流程绑定数据分别放到两个List里
            //应该在这里作流程校验
            for (Map.Entry<ProcessTemplete, List<SubProcessSetting>> entry : templeteMap.entrySet()) {
                ProcessTemplete templete = entry.getKey();
                List<SubProcessSetting> subList = entry.getValue();
                if (templete != null) {
                    //导入的流程暂时设置为草稿状态
                    templete.setState(0);
                    templeteList.add(templete);
                    willImportTempleteIdList.add(templete.getId());
                    if (subList != null && subList.size() > 0) {
                        subSettingList.addAll(subList);
                    }
                }
            }
            if (templeteList.size() > 0) {
                //先判断将要导入的工作流模版是否已经存在
                List<ProcessTemplete> oldTemplateList = processTemplateManager
                        .selectProcessTemplateByIdList(willImportTempleteIdList);
                if (oldTemplateList != null && oldTemplateList.size() > 0) {
                    success = false;
                    //msg = "流程已经导入过，不能再次导入！";
                    msg = ResourceUtil.getString("workflow.label.msg.repeatImport");
                }
                //保存导入的流程！
                if(success){
                    try {
                        processTemplateManager.saveImportedProcessTemplate("collaboration", templeteList);
                        if (subSettingList.size() > 0) {
                            subProcessManager.saveSubProcessSetting(subSettingList);
                        }
                    } catch (Exception e) {
                        logger.error(e);
                        success = false;
                        msg = ResourceUtil.getString("workflow.label.msg.errorWhenSave");//"保存时抛出异常！";
                    }
                }
            }
        }
        resultMap.put("success", String.valueOf(success));
        resultMap.put("msg", msg);
        return resultMap;
    }

    @Override
    public Map<String, String> setWorkflowUseFlag(List<String> workflowIds, int flag) throws BPMException {
        int state = -2;
        boolean success = true;
        String msg = "";
        //把flag的值转换成工作流模版字段的值
        switch (flag) {
            case 1:
                state = 1;
                break;
            case 0:
                state = 0;
                break;
            case -1:
                state = 2;
                break;
        }
        if (state != -2) {
            try {
                processTemplateManager.updateProcessState(workflowIds, state);
            } catch (Exception e) {
                logger.error(e);
                success = false;
                msg = ResourceUtil.getString("workflow.label.msg.updateFail");//"更新失败！";
            }
        }
        Map<String, String> result = new HashMap<String, String>();
        result.put("success", String.valueOf(success));
        result.put("msg", msg);
        return result;
    }

    public PermissionManager getPermissionManager() {
        return permissionManager;
    }

    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }

    @Override
    public BPMProcess getBPMProcessForM1(String processId) throws BPMException {
        return processManager.getRunningProcess(processId);
    }
    @Override
    public BPMProcess getBPMProcessHis(String processId) throws BPMException {
        return processManager.getRunningProcessHis(processId);
    }
    @Override
    public Object[] getNodeStatusForM1(long caseId) throws BPMException {
        try{
            Map<String, String[]> nodesStatus = new HashMap<String, String[]>();
            nodesStatus= caseManager.getNodesStatus(caseId);
            //key:节点ID
            //String[0]:节点状态
            //String[1]:节点是否读取了
            Map<String, List<String[]>> nodesItemsStatus = new HashMap<String, List<String[]>>();
            //key:节点ID
            //value:List<String[]>
            //String[0]:人员ID
            //String[1]:人员名称
            //String[2]:单位简称
            //String[3]:人员状态
            //String[4]:人员处理状态
            //String[5]:人员是否读取了:true/false
            nodesItemsStatus = workItemManager.getNodesItemsStatus(caseId,nodesStatus);
            Object[] result = new Object[2];
            result[0] = nodesStatus; 
            result[1] = nodesItemsStatus;
            return result;
        }catch(Throwable e){
            logger.error(e.getMessage(), e);
            throw new BPMException(e);
        }
    }

    @Override
    public boolean isExecuteFinished(String processId, long workitemId) throws BPMException {
        try {
            BPMProcess process = processManager.getRunningProcess(processId);
            WorkItem workitem = workItemManager.getWorkItemOrHistory(workitemId);
            boolean isExecuteFinished = workItemManager.isExcuteFinished(workitem, process);
            return isExecuteFinished;
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
            throw new BPMException(e);
        }
    }

    @Override
    public BPMActivity replaceWorkItemMember(String processId, long workitemId, String activityId, V3xOrgMember nextMember)
            throws BPMException {
        try {
            WorkItem workitem = workItemManager.getWorkItemOrHistory(workitemId);
            if(workitem instanceof WorkitemDAO){
                WorkitemDAO wdao= (WorkitemDAO)workitem;
                wdao.setPerformer(nextMember.getId().toString());
                workItemManager.updateWorkItem(wdao);
            }else if(workitem instanceof HistoryWorkitemDAO){
                HistoryWorkitemDAO hwdao= (HistoryWorkitemDAO)workitem;
                hwdao.setPerformer(nextMember.getId().toString());
                workItemManager.updateHistoryWorkItem(hwdao);
            }
            BPMProcess process = processManager.getRunningProcess(processId);
            BPMCase theCase= caseManager.getCase(workitem.getCaseId());
            Map<String,String> nodeAdditionMap= WorkflowUtil.getNodeAdditionMap(theCase);
            Map<String,String> nodeRAdditionMap= WorkflowUtil.getNodeRAdditionMap(theCase);
            BPMHumenActivity bpmActivity = (BPMHumenActivity) process.getActivityById(activityId);
            BPMActor bpmActor = (BPMActor) bpmActivity.getActorList().get(0);
            String partyType = bpmActor.getType().id;
            if ("user".equals(partyType)) {//如果节点类型为user，则需要将流程图中的节点名称进行修改，否则不需要
                bpmActivity.setName(nextMember.getName());
                bpmActor.getParty().setAddition(nextMember.getId().toString());
                bpmActor.getParty().setRaddition(nextMember.getId().toString());
                nodeAdditionMap.put(bpmActivity.getId(), nextMember.getId().toString());
                nodeRAdditionMap.put(bpmActivity.getId(), nextMember.getId().toString());
                bpmActor.getParty().setId(nextMember.getId().toString());
                bpmActor.getParty().setName(nextMember.getName());
                bpmActor.getParty().setAccountId(nextMember.getOrgAccountId().toString());
                ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
                WorkflowUtil.putWorkflowBPMContextToCase(nodeAdditionMap, nodeRAdditionMap, theCase);
                engine.updateRunningProcess(process,theCase,null);
                caseManager.save(theCase);
            }
            return bpmActivity;
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
            throw new BPMException(e);
        }
    }
    
    @Override
    /**
     * 
     * @param isUpdateProcess
     * @param memberId
     * @param processId
     * @param workitemId
     * @param activityId
     * @param nextMembers
     * @param isTransfer  是否是转办
     * @return
     * @throws BPMException
     */
    public Object[] replaceWorkItemMembers(boolean isUpdateProcess,Long memberId,String processId, long workitemId, String activityId, List<V3xOrgMember> nextMembers,boolean isTransfer)throws BPMException {
        try {
            if( null!=nextMembers && !nextMembers.isEmpty()){
                long batch= WorkflowUtil.getTableKey();
                int itemNum = 0;
                boolean isHistory= false;
                //查到当前要替换的workitem
                WorkItem workitem = workItemManager.getWorkItemOrHistory(workitemId);
                Long caseId= workitem.getCaseId();
                if(workitem instanceof WorkitemDAO){
                    WorkitemDAO wdao= (WorkitemDAO)workitem;
                    itemNum= wdao.getItemNum();
                    batch= wdao.getBatch();
                }else if(workitem instanceof HistoryWorkitemDAO){
                    HistoryWorkitemDAO hwdao= (HistoryWorkitemDAO)workitem;
                    itemNum= hwdao.getItemNum();
                    batch= hwdao.getBatch();
                    isHistory= true;
                }
                
                Object[] result = new Object[2];
                BPMHumenActivity bpmActivity = null;
                if(isUpdateProcess){
                    itemNum= itemNum-1+nextMembers.size();
                    //查找流程信息
                    BPMProcess process = processManager.getRunningProcess(processId);
                    BPMCase theCase= caseManager.getCaseOrHistoryCaseByProcessId(processId);
                    bpmActivity = (BPMHumenActivity) process.getActivityById(activityId);
                    
                    //产生待办
                    List<BPMActor> actors = bpmActivity.getActorList();
                    BPMActor actor = actors.get(0);
                    BPMParticipant party = actor.getParty();
                    String partyTypeId = party.getType().id;
                    String engineDomain= "Engine_1";
                    
                    result = workItemManager.generateWorkItems(nextMembers,bpmActivity,processId, theCase.getId(), engineDomain,itemNum,batch);
                    
                    List<String> actorStr = (List<String>) result[0];
                    List<WorkitemDAO> workitems = (List<WorkitemDAO>) result[1];
                    workItemManager.saveWorkitems(workitems);
                    
                    Map<String,String> nodeAdditionMap= WorkflowUtil.getNodeAdditionMap(theCase);
                    Map<String,String> nodeRAdditionMap= WorkflowUtil.getNodeRAdditionMap(theCase);
                    
                    String addition= nodeAdditionMap.get(activityId);
                    String raddition= nodeRAdditionMap.get(activityId);
                    
                    WorkflowUtil.putNodeBakAdditionInfoToCase(theCase,bpmActivity,addition,raddition);
                  
                    addition = addition == null ? "" :addition;
                    raddition = raddition == null ? "": raddition;

                    addition= addition.replaceAll(memberId.toString(), "");
                    raddition= raddition.replaceAll(memberId.toString(), "");
                    
                    addition= addition+","+StringUtils.join(actorStr, ",");
                    raddition= raddition+","+StringUtils.join(actorStr, ",");
                    
                    BPMSeeyonPolicy policy= bpmActivity.getSeeyonPolicy();
                    String dealUserId= policy.getDealTermUserId();
                    String dealUserName= policy.getDealTermUserName();
                    if (Strings.isBlank(dealUserId)||"null".equals(dealUserId) || isTransfer) {//转办的时候policy里面没有这个值，转办传递进来的是一个固定的人员
                    	dealUserId = String.valueOf(nextMembers.get(0).getId());
                    	dealUserName = String.valueOf(nextMembers.get(0).getName());
                    }
                    actor.getParty().setAddition(addition);
                    actor.getParty().setRaddition(raddition);
                    nodeAdditionMap.put(bpmActivity.getId(), addition);
                    nodeRAdditionMap.put(bpmActivity.getId(), raddition);
                    boolean isNeedSaveProcess= false;
                    String processMode= policy.getProcessMode();
                    String partyTypeId_tmp = dealUserId;
                    String newNodeName= dealUserName;//新节点名称
                    if ("user".equals(partyTypeId)) {//如果节点类型为user，则需要将流程图中的节点名称进行修改，否则不需要
                        WorkflowUtil.putNodeBakUserInfoToCase(theCase,bpmActivity);
                        boolean isIncludeChild= true;
                        if(dealUserId.startsWith("CurrentNodeDeptMember") 
                                || dealUserId.startsWith("CurrentNodeSuperDeptDeptMember")
                                || dealUserId.startsWith("SenderDeptMember")
                                || dealUserId.startsWith("NodeUserDeptMember")
                                || dealUserId.startsWith("SenderSuperDeptDeptMember")
                                || dealUserId.startsWith("NodeUserSuperDeptDeptMember")){
                            if(dealUserId.endsWith("|0")){
                                isIncludeChild= false;
                            }
                            int endPosition= partyTypeId_tmp.indexOf("|");
                            if(endPosition>0){
                                partyTypeId_tmp= partyTypeId_tmp.substring(0,endPosition);
                            }
                            actor.getParty().setId(partyTypeId_tmp);
                            actor.getParty().setIncludeChild(isIncludeChild);
                        }else{
                            actor.getParty().setId(dealUserId);
                        }
                        boolean isCurrentNodeRole= false;
                        if(partyTypeId_tmp.startsWith("CurrentNodeSuperDept")){//当前节点上级部门+角色
                            String role= partyTypeId_tmp.substring("CurrentNodeSuperDept".length());
                            String roleName= processOrgManager.getRoleShowNameByName(role, null);
                            newNodeName= bpmActivity.getName()+ResourceUtil.getString("sys.role.rolename.SuperDept")+roleName;
                            isCurrentNodeRole= true;
                        }else if(partyTypeId_tmp.startsWith("CurrentNode")){//当前节点+角色
                            String role= partyTypeId_tmp.substring("CurrentNode".length());
                            String roleName= processOrgManager.getRoleShowNameByName(role, null);
                            newNodeName= bpmActivity.getName()+roleName;
                            isCurrentNodeRole= true;
                        }
                        if(isCurrentNodeRole && !isIncludeChild){
                            newNodeName += "("+ResourceUtil.getString("workflow.branch.excludeChildren")+")";
                        }
                        bpmActivity.setName(newNodeName);
                        actor.getParty().setName(newNodeName);
                        actor.getParty().setAccountId(nextMembers.get(0).getOrgAccountId().toString());
                        if(WorkflowUtil.isLong(dealUserId)){//一个具体的人
                            actor.getParty().setAccountId(nextMembers.get(0).getOrgAccountId().toString());
                        }else{//相对角色
                            BPMParticipantType type= new BPMParticipantType("Node");
                            actor.getParty().setType(type);
                            actor.getParty().setAccountId(nextMembers.get(0).getOrgAccountId().toString());
                        }
                        isNeedSaveProcess= true;
                        //清除复制粘贴标记
                    	WorkflowUtil.clearCopyNodeProperty(process, activityId);
                    }
                    if(nextMembers.size()>1 && "single".equals(processMode)){//如果超过1个人，则执行模式改为竞争执行
                        policy.setProcessMode("competition");//竞争执行
                        isNeedSaveProcess= true;
                    }
                    if(isNeedSaveProcess){
                        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
                        engine.updateRunningProcess(process,theCase,null);
                    }
                    Recorder recorder= new Recorder(theCase);
                    recorder.onNodeReady(bpmActivity);

                    WorkflowUtil.putWorkflowBPMContextToCase(nodeAdditionMap, nodeRAdditionMap, theCase);
                    caseManager.save(theCase);
                    
                    
                    WorkFlowAppExtendManager workFlowAppExtendManager = WorkFlowAppExtendInvokeManager.getAppManager("collaboration");
                	if(workFlowAppExtendManager != null){
                		List<Map<String,String>> list = WorkflowUtil.getNodeMemberInfos(process);
                		workFlowAppExtendManager.processNodesChanged(processId,null, list);
                	}
                    
                    
                }else{
                    itemNum= itemNum-1;
                }
                //将当前workitem删除掉
                workItemManager.deleteWorkitem(workitemId,isHistory);
                //该节点上已有事项的itemNum
                workItemManager.updateWorkItem(caseId,workitem.getActivityId(),itemNum);
                
              
                
                
                Object[] returnObj= new Object[3];
                returnObj[0]= result[0];
                returnObj[1]= result[1];
                returnObj[2]= bpmActivity;
                return returnObj;
            }
            return null;
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
            throw new BPMException(e);
        }
    }

    @Override
    public boolean hasUnFinishedNewflow(String processId,String activityId) throws BPMException {
        boolean hasUnFinishedNewflow= false;
        BPMProcess process = processManager.getRunningProcess(processId);
        BPMHumenActivity bpmActivity = (BPMHumenActivity) process.getActivityById(activityId);
        if(ObjectName.isInformObject(bpmActivity)){//知会节点不需判断前面的节点触发的子流程是否结束
            return hasUnFinishedNewflow;
        }
        BPMCase theCase= caseManager.getCaseOrHistoryCaseByProcessId(processId);
        List<String> hasNewflowNodeIds = WorkflowUtil.checkPrevNodeHasNewflow(bpmActivity,theCase);
        if(hasNewflowNodeIds != null && !hasNewflowNodeIds.isEmpty()){
//            List<SubProcessRunning> subList = subProcessManager.getUnfinishedSubProcess(processId, hasNewflowNodeIds);
            List<SubProcessRunning> subList = subProcessManager.checkHasNoFinishNewflow(processId, hasNewflowNodeIds);
            if(subList != null && subList.size()>0){
                hasUnFinishedNewflow= true;//有子流程没有结束
            }
        }
        return hasUnFinishedNewflow;
    }

    @Override
    public boolean validateTemplate(Long formApp, String templateXML) throws BPMException {
        return true;
    }

    @Override
    public String[] getStartNodeFormPolicy(Long templateId) throws BPMException {
        String[] result= new String[5];
        ProcessTemplete template = processTemplateManager.selectProcessTemplateById(templateId);
        if (template != null) {
            BPMProcess process = BPMProcess.fromXML(template.getWorkflow());
            if (process != null) {
                BPMStatus startNode = process.getStart();
                BPMSeeyonPolicy startPolicy= startNode.getSeeyonPolicy();
                result[0] = startPolicy.getFormApp();
                result[1] = startPolicy.getForm();
                result[2] = startPolicy.getOperationName();
                result[3] = startPolicy.getName();
                result[4] = startPolicy.getDR();
            } else {
                logger.info("templateId=" + templateId + "的模版xml无法转换为BPMProcess对象！");
            }
        } else {
            logger.info("templateId=" + templateId + "的模版不存在！");
        }
        return result;
    }

    @Override
    public String[] stepBack(WorkflowBpmContext context) throws BPMException {
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        if(Strings.isBlank(context.getMatchRequestToken())){
        	Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
    		String conditionsOfNodes= wfdef.get("workflow_node_condition_input");
            String matchRequestToken= WorkflowUtil.getWorkflowMatchRequestToken(conditionsOfNodes);
            context.setMatchRequestToken(matchRequestToken);
        }
        return engine.stepBack(context);
    }

    @Override
    public int checkWorkflowBatchOperation(
            String appName,
            String processId,
            long caseId,
            String currentNodeId,
            String currentUserId,
            String currentAccountId,
            long currentWorkitemId,
            String masterId
            ) throws BPMException {
        WorkflowBpmContext context= new WorkflowBpmContext();
        context.setAppName(appName);
        context.setProcessId(processId);
        context.setCaseId(caseId);
        context.setCurrentActivityId(currentNodeId);
        context.setCurrentUserId(currentUserId);
        context.setCurrentAccountId(currentAccountId);
        context.setCurrentWorkitemId(currentWorkitemId);
        context.setMastrid(masterId);
        String[] result= processManager.lockWorkflowProcess(processId, currentUserId,false,14);
        boolean isChange= "false".equals(result[0]);//调用工作流锁组件判断流程是否正在被修改
        if(isChange){//流程正在被修改
            return 13;
        }else{
            context.setIsValidate(false);
            if(
                    null!=context.getMastrid()
                    && Strings.isNotBlank(context.getMastrid())
                    && !"null".equals(context.getMastrid())
                    && !"undefined".equals(context.getMastrid())
                    && !"-1".equals(context.getMastrid())){
                ProcessInRunningDAO process= processManager.getProcessInRunningDAO(processId);
                try{
                    context.setFormData(process.getProcess().getStart().getSeeyonPolicy().getFormApp());
                }catch(Throwable e){
                    logger.warn("",e);
                }
            }
            CPMatchResultVO vo= this.transBeforeInvokeWorkFlow(context, null);
            if(vo.isPop() || vo.isBackgroundPop()){
                if(vo.isHasSubProcess()){//有子流程
                    return 15;
                }else{//有需要选择分支或选择人员
                    return 17;
                }
            }
            return 0;
        }
    }
    
	@Override
	public String[] checkWorkflowBatchOperationWithMsg(String appName, String processId, long caseId, String currentNodeId, String currentUserId, String currentAccountId, long currentWorkitemId,
			String masterId) throws BPMException {
		String[] msg = new String[] { "0", "", "false", "" };
		WorkflowBpmContext context = new WorkflowBpmContext();
		context.setAppName(appName);
		context.setProcessId(processId);
		context.setCaseId(caseId);
		context.setCurrentActivityId(currentNodeId);
		context.setCurrentUserId(currentUserId);
		context.setCurrentAccountId(currentAccountId);
		context.setCurrentWorkitemId(currentWorkitemId);
		context.setMastrid(masterId);
		context.setIsValidate(true);
		
		if (null != context.getMastrid() && Strings.isNotBlank(context.getMastrid()) && !"null".equals(context.getMastrid()) && !"undefined".equals(context.getMastrid())
				&& !"-1".equals(context.getMastrid())) {
			ProcessInRunningDAO process = processManager.getProcessInRunningDAO(processId);
			try {
				context.setFormData(process.getProcess().getStart().getSeeyonPolicy().getFormApp());
			} catch (Throwable e) {
				logger.warn("", e);
			}
		}
		CPMatchResultVO vo = this.transBeforeInvokeWorkFlow(context, null);
		String conditionsOfNodes = WorkflowUtil.parseConditionsOfNodes(vo);
		msg[3] = conditionsOfNodes;
		msg[2] = vo.getLast();

		if (Strings.isNotEmpty(vo.getHumenNodeMatchAlertMsg())) { // 动态匹配节点不让提交
			msg[0] = "29";
			msg[1] = vo.getHumenNodeMatchAlertMsg();
			return msg;
		}
		else if (vo.isPop()) {
			if (vo.isHasSubProcess()) {// 有子流程
				msg[0] = "15";
				return msg;
				// return 15;
			}
			else {// 有需要选择分支或选择人员
				msg[0] = "17";
				return msg;
				// return 17;
			}
		}
		else if (Strings.isNotEmpty(vo.getCircleNodes()) && vo.getCircleNodes().size() > 0) {// 环形流程分支
			msg[0] = "26";
			return msg;
		}
		else if ("false".equals(vo.getCanSubmit())) {
			msg[0] = "28";
			msg[1] = vo.getCannotSubmitMsg();
			return msg;
		}

		else {
			if (null != vo.getInvalidateActivityMap() && vo.getInvalidateActivityMap().size() > 0) {// 后面节点有人员离职
				msg[0] = "18";
				return msg;
			}
			else {
				String[] result1 = this.canWorkflowCurrentNodeSubmit(String.valueOf(currentWorkitemId));
				if ("false".equals(result1[0])) {
					msg[0] = "9999";
					msg[1] = result1[1];
				}
			}
		}
		return msg;
		// }
	}

    @Override
    public WorkItem getWorkItemById(String appName,long id) throws BPMException {
        return workItemManager.getWorkItemById(appName,id);
    }

    @Override
    public String[] lockWorkflowProcess(String processId, String userId,int action) throws BPMException {
        return processManager.lockWorkflowProcess(processId, userId,true,action);
    }
    
    @Override
    public String[] lockWorkflowProcess(String processId, String userId,int action,String from) throws BPMException {
        return processManager.lockWorkflowProcess(processId, userId,true,action,from);
    }
    @Override
    public String[] lockWorkflowProcess(String processId, String userId,int action,String from,boolean useNowexpirationTime) throws BPMException {
        return processManager.lockWorkflowProcess(processId, userId,true,action,from,useNowexpirationTime);
    }
    @Override
    public String[] releaseWorkFlowProcessLock(String processId, String userId) throws BPMException {
        return processManager.releaseWorkFlowProcessLock(processId, userId);
    }
    
    @Override
    public String[] releaseWorkFlowProcessLock(String processId, String userId,String loginFrom) throws BPMException {
        return processManager.releaseWorkFlowProcessLock(processId, userId,loginFrom);
    }
    
    @Override
    public String[] releaseWorkFlowProcessLock(String processId, String userId,int action) throws BPMException {
        return processManager.releaseWorkFlowProcessLock(processId, userId,action);
    }
    
    @Override
    public String[] checkWorkFlowProcessLock(String processId, String userId) throws BPMException {
        //注意：目前这个方法只有协同和公文的批处理再调用，所以强制将action设置为14，如果其他模块要调用，则要仔细考虑下
        return processManager.lockWorkflowProcess(processId, userId,false,14);
    }

    @Override
    public void updateSubProcessRunning(long id,String subProcessId, long subCaseId,String subStartUserId,String subStartUserName) throws BPMException {
        boolean isActivate = subCaseId != -1L;
        SubProcessRunning runFlow= subProcessManager.getSubProcessRunningById(id);
        runFlow.setSubProcessProcessId(subProcessId);
        runFlow.setSubProcessCaseId(subCaseId);
        runFlow.setSubProcessSenderId(Long.parseLong(subStartUserId));
        //runFlow.setSubProcessSender(subStartUserName);
        runFlow.setUpdateTime(new Date());
        runFlow.setIsActivate(isActivate);
        subProcessManager.updateSubProcessRunning(runFlow);
    }

    @Override
    public boolean isHaveFormFieldNodeByAttrAndProcessXML(String formFieldAttr, String processXML) throws BPMException {
        boolean result = false;
        if(formFieldAttr!=null && processXML!=null){
            BPMProcess process = BPMProcess.fromXML(processXML);
            if(process!=null){
                List<BPMAbstractNode> allNodes = process.getActivitiesList();//WorkflowUtil.findAllChildHumenActivitys(process.getStart());
                if(allNodes!=null && allNodes.size()>0){
                    firstLoop:for(BPMAbstractNode node : allNodes){
                        if(node.getNodeType().equals(BPMAbstractNode.NodeType.humen)){
                            @SuppressWarnings("rawtypes")
                            List actorList = node.getActorList();
                            for (int i = 0; i < actorList.size(); i++) {
                                BPMActor actor = (BPMActor) actorList.get(i);
                                BPMParticipant party = actor.getParty();
                                //actor标签的partyType属性值
                                String partyTypeId = party.getType().id;
                                //actor标签的partyId属性值
                                String partyId = party.getId();
                                if(WorkFlowFinal.FORMFIELD.equals(partyTypeId) && partyId!=null){
                                    int firstIndex= partyId.indexOf("@");
                                    int sencondIndex= partyId.indexOf("#");
                                    if( firstIndex > -1 && sencondIndex > -1){
                                        String fieldName = partyId.substring(firstIndex+1, sencondIndex);
                                        if(fieldName.trim().equals(formFieldAttr.trim())){
                                            result = true;
                                            break firstLoop;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
    public String getNodeFormOperationNameFromRunning(String processId, String nodeId) throws BPMException {
    	String[] infos =  getNodePolicyInfos(processId,nodeId);
    	return infos[0];
    }
    @Override
    public String[] getNodePolicyInfos(String processId, String nodeId) throws BPMException {
    	String[] arr = new String[]{null,null};
        if(Strings.isNotBlank(processId)){
            ProcessInRunningDAO dao= processManager.getProcessInRunningDAO(processId);
            BPMProcess process= null;
            try {
                process = dao.getProcess();
            } catch (Throwable e) {
                logger.error(e);
                
            }
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        arr[0] = node.getSeeyonPolicy().getOperationName();
                        arr[1] = node.getSeeyonPolicy().getDR();
                    } 
                } else {
                    BPMStatus startNode = process.getStart();
                    arr[0] = startNode.getSeeyonPolicy().getOperationName();
                    arr[1] = startNode.getSeeyonPolicy().getDR();
                }
            }
        }
        return arr;
    }
    
    @Override
    public String getNodeFormOperationNameFromRunning(String processId, String nodeId,boolean isHistoryFlag) throws BPMException {
        if(Strings.isNotBlank(processId)){
            ProcessInRunningDAO dao= processManager.getProcessInRunningDAO(processId,isHistoryFlag);
            BPMProcess process= null;
            try {
                process = dao.getProcess();
            } catch (Throwable e) {
                logger.error(e);
            }
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        return node.getSeeyonPolicy().getOperationName();
                    } else {
                        return null;
                    }
                } else {
                    BPMStatus startNode = process.getStart();
                    return startNode.getSeeyonPolicy().getOperationName();
                }
            }
            return null;
        }else{
            return null;
        }
    }
    
    @Override
    public String getNodeMutilFormOperationNameFromRunning(String processId, String nodeId) throws BPMException {
        if(Strings.isNotBlank(processId)){
            ProcessInRunningDAO dao= processManager.getProcessInRunningDAO(processId);
            BPMProcess process= null;
            try {
                process = dao.getProcess();
            } catch (Throwable e) {
                logger.error(e);
            }
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        return node.getSeeyonPolicy().getOperationm();
                    } else {
                        return null;
                    }
                }
            }
            return null;
        }else{
            return null;
        }
    }
    
    @Override
    public int getDealTermFromTemplate(Long templateId, String nodeId) throws BPMException {
        int result = 0;
        ProcessTemplete template = processTemplateManager.selectProcessTemplateById(templateId);
        if (template != null) {
            String resultString = "";
            BPMProcess process = BPMProcess.fromXML(template.getWorkflow());
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        resultString = node.getSeeyonPolicy().getdealTerm();
                    } else {
                        logger.info("templateId=" + templateId + "的模版中id=" + nodeId + "的节点不存在！");
                        throw new BPMException("The Node witch id=" + nodeId + " in the Process Templete witch id="+templateId+" does not exist!");
                    }
                } else {
                    BPMStatus startNode = process.getStart();
                    resultString = startNode.getSeeyonPolicy().getdealTerm();
                }
            } else {
                logger.info("templateId=" + templateId + "的模版xml无法转换为BPMProcess对象！");
                throw new BPMException("Cannot transfer the Process Template witch id=" + templateId + " to BPMProcess Object!");
            }
            try{
                result = Integer.parseInt(resultString);
            }catch(NumberFormatException e){
                result = 0;
                logger.error(e);
            }
        } else {
            logger.info("templateId=" + templateId + "的模版不存在！");
            throw new BPMException(ResourceUtil.getString("workflow.label.notExistTemp", templateId)/*"templateId=" + templateId + "的模版不存在！"*/);
        }
        return result;
    }

    @Override
    public int getDealTermFromRunning(String processId, String nodeId) throws BPMException {
        int result = 0;
        if(Strings.isNotBlank(processId)){
            String resultString = "";
            ProcessInRunningDAO dao= processManager.getProcessInRunningDAO(processId);
            BPMProcess process= null;
            try {
                process = dao.getProcess();
            } catch (Throwable e) {
                logger.error(e);
            }
            if (process != null) {
                if (nodeId != null && !"".equals(nodeId.trim())) {
                    BPMActivity node = process.getActivityById(nodeId);
                    if (node != null) {
                        resultString = node.getSeeyonPolicy().getdealTerm();
                    }
                } else {
                    BPMStatus startNode = process.getStart();
                    resultString = startNode.getSeeyonPolicy().getdealTerm();
                }
            }
            try{
                result = Integer.parseInt(resultString);
            }catch(NumberFormatException e){
                result = 0;
                logger.error(e);
            }
        }
        return result;
    }

    @Override
    public String[] selectProcessTemplateXMLForClone(String appName, String templateIdString, String newFormApp,
            String oldWendanId, String newWendanId, String subProcessJson) throws BPMException {
        String processXML = "", validateXML = "", oldFormApp = "";
        Long templateId = null, newFormAppId = null;
        if(null!=templateIdString && !"".equals(templateIdString) && !"-1".equals(templateIdString)
                && !"null".equals(templateIdString) && !"undefined".equals(templateIdString)){
            templateId = Long.parseLong(templateIdString);
        }
        if(WorkflowUtil.isLong(newFormApp)){
            newFormAppId = Long.parseLong(newFormApp);
        }
        boolean isSameForm = false; //是否是同一个单子
        if (templateId != null) {
            ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(templateId);
            if (oldTemplete != null) {
                BPMProcess process = BPMProcess.fromXML(oldTemplete.getWorkflow());
                if(process!=null){
                    BPMStatus start = process.getStart();
                    oldFormApp = start.getSeeyonPolicy().getFormApp().trim();
                    Long oldFormAppId = null;
                    if(WorkflowUtil.isLong(oldFormApp)){
                        oldFormAppId = Long.parseLong(oldFormApp);
                    }
                    
					// 重置数据关联的ID
					reSetProcessDR(process);
                    
					//如果新表单和老表单相同，复制的时候要进行一下替换
                    WorkflowUtil.changeFormFieldNodeName(null,process, oldFormApp);
                    //如果流程中保存的表单id和传进来的表单id不相同，那么就有必要转换了
                    //如果相同就没有必要转换了
                    //如果两个都是空的话，那就没有必要转换了
                    if(null!=newFormAppId && !newFormAppId.equals(-1L) && null!=oldFormAppId && !oldFormAppId.equals(-1L)){
                        //对于表单控件节点，如果field001存在，且类型相同，但名称属性display不相同。则直接替换display
                        //对于分支条件，，如果field001存在，且类型相同，但名称属性display不相同。则直接替换display
                        //新老表单是同一个，那么就不需要进行这些替换
                        if(!newFormApp.equals(oldFormApp)){
                            //此处替换表单控件节点 开始
                            replaceNodeMessage(process.getStart(), oldFormApp, newFormApp);
                            List<BPMAbstractNode> allNodes = process.getActivitiesList();//WorkflowUtil.findAllChildHumenActivitys(process.getStart());
                            if(allNodes!=null && allNodes.size()>0){
                                for(BPMAbstractNode node : allNodes){
                                    replaceNodeMessage(node, oldFormApp, newFormApp);
                                }
                            }
                            //此处替换表单控件节点 结束
                            //此处替换分支条件 开始
                            List<BPMTransition> conditionLinkList = process.getLinks();//WorkflowUtil.getAllConditionLink(process);
                            if(conditionLinkList!=null && conditionLinkList.size()>0){
                                for(BPMTransition link : conditionLinkList){
                                    if(link.getConditionType()==1 || link.getConditionType()==4){
                                        String condition = link.getFormCondition();
                                        String title = link.getConditionTitle();
                                        String formCondition= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFormCondition(title, condition, oldFormApp, newFormApp);
                                        link.setFormCondition(formCondition);
                                    }
                                }
                            }
                            
                            
                            List<BPMCircleTransition> conditionClinkList = process.getClinks();//WorkflowUtil.getAllConditionLink(process);
                            if(conditionClinkList!=null && conditionClinkList.size()>0){
                                for(BPMCircleTransition link : conditionClinkList){
                                    if(link.getConditionType()==1 || link.getConditionType()==4){
                                        String condition = link.getFormCondition();
                                        String title = link.getConditionTitle();
                                        String formCondition= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFormCondition(title, condition, oldFormApp, newFormApp);
                                        link.setFormCondition(formCondition);
                                    }
                                }
                            }
                            //此处替换分支条件 结束
                        }else{
                        	isSameForm = true;
                        }
                        processXML = process.toXML(null,true);
                    }else{
                        if(oldWendanId!=null && !"".equals(oldWendanId) && !"-1".equals(oldWendanId)
                                && !"null".equals(oldWendanId) && !"undefined".equals(oldWendanId)
                                && newWendanId!=null && !"".equals(newWendanId) && !"-1".equals(newWendanId)
                                && !"null".equals(newWendanId) && !"undefined".equals(newWendanId)){
                        	//如果是公文模板替换，需要判断其中有没有公文模板分支条件
                        	List<BPMTransition> conditionLinkList = process.getLinks();//WorkflowUtil.getAllConditionLink(process);
                        	Map<String, WorkflowFormFieldVO> oldFieldMap = new HashMap<String, WorkflowFormFieldVO>();
                        	Map<String, WorkflowFormFieldVO> newFieldMap = new HashMap<String, WorkflowFormFieldVO>();
                        	WorkFlowAppExtendManager validateManager = WorkFlowAppExtendInvokeManager.getAppManager(appName);
                        	if(validateManager!=null){
                                if(WorkflowUtil.isLong(oldWendanId)){
                                    List<WorkflowFormFieldVO> fieldList = validateManager.getWorkflowBranchFormFieldVOListById(Long.parseLong(oldWendanId));
                                    if(fieldList!=null && fieldList.size()>0){
                                        for(WorkflowFormFieldVO field : fieldList){
                                            oldFieldMap.put(field.getName(), field);
                                        }
                                    } 
                                }
                                if(WorkflowUtil.isLong(newWendanId)){
                                    List<WorkflowFormFieldVO> fieldList = validateManager.getWorkflowBranchFormFieldVOListById(Long.parseLong(newWendanId));
                                    if(fieldList!=null && fieldList.size()>0){
                                        for(WorkflowFormFieldVO field : fieldList){
                                            newFieldMap.put(field.getName(), field);
                                        }
                                    }
                                }
                        	}
                        	if(oldFieldMap.size()>0 && newFieldMap.size()>0 && conditionLinkList!=null && conditionLinkList.size()>0){
                                Pattern pattern1 = Pattern.compile("([a-zA-Z_][a-zA-z_0-9]*?)\\s*(>|<|>=|<=|==|!=)\\s*[-+]?\\d+");
                                Pattern pattern2 = Pattern.compile("[-+]?\\d+\\s*(>|<|>=|<=|==|!=)\\s*([a-zA-Z_][a-zA-z_0-9]*?)");
                                for(BPMTransition link : conditionLinkList){
                                    if(link.getConditionType()==1 || link.getConditionType()==4){
                                        String condition = link.getFormCondition();
                                        Matcher matcher1 = pattern1.matcher(condition);
                                        forLoopFlag:{
                                            while(matcher1.find()){
                                                String eleName = matcher1.group(1);
                                                if(oldFieldMap.get(eleName)!=null && newFieldMap.get(eleName)==null){
                                                    link.setFormCondition("");
                                                    break forLoopFlag;
                                                }
                                            }
                                            Matcher matcher2 = pattern2.matcher(condition);
                                            while(matcher2.find()){
                                            	if(matcher1.groupCount()>2){
                                            		String eleName = matcher1.group(2);
                                            		if(oldFieldMap.get(eleName)!=null && newFieldMap.get(eleName)==null){
                                            			link.setFormCondition("");
                                            			break forLoopFlag;
                                            		}
                                            	}
                                            }
                                        }
                                    }
                                }
                            }
                        	processXML = process.toXML(null,true);
                        }else{
                        	//不需要替换的直接返回
	                        processXML = oldTemplete.getWorkflow();
	                        if(Strings.isNotBlank(processXML)){
	                        	BPMProcess tprocess = BPMProcess.fromXML(processXML);
	                        	reSetProcessDR(tprocess);
	                            processXML= tprocess.toXML(null,true);
	                        }
                        }
                    }
                    //流程校验
                    List<SubProcessSetting> subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
                    if(subList==null){
                        subList = new ArrayList<SubProcessSetting>();
                    }
                    String[] validate = workFlowDesignerManager.validateTemplateXml(appName, processXML,newFormApp, newWendanId, subList,false,isSameForm);
                    if(validate!=null && validate.length>=3 && "false".equals(validate[0])){
                        validateXML = validate[1];
                        processXML = validate[2];
                    }
                }
            }
        }
        return new String[]{processXML, validateXML, oldFormApp};
    }

	private void reSetProcessDR(BPMProcess process) {
	    
        BPMStatus start = process.getStart();
	    start.getSeeyonPolicy().setDR("");
		List list = process.getActivitiesList();
		if (Strings.isNotEmpty(list)) {
			for (Object _node : list) {
				BPMAbstractNode node = (BPMAbstractNode) _node;
				node.getSeeyonPolicy().setDR("");
			}
		}
	}

    private void replaceNodeMessage(BPMAbstractNode node, String oldFormAppId, String newFormAppId){
        List actorList = node.getActorList();
        if(null!=actorList && !actorList.isEmpty()){
            for (int i = 0; i < actorList.size(); i++) {
                BPMActor actor = (BPMActor) actorList.get(i);
                BPMParticipant party = actor.getParty();
                //actor标签的partyType属性值
                String partyTypeId = party.getType().id;
                //actor标签的partyId属性值
                String partyId = party.getId();
                //表单控件节点partyId实例
                //Multidepartment@field0006#有效期结束日期
                //Department@field0005#有效期开始日期
                //Multiaccount@field0004#执行状态
                //Account@field0003#审核状态
                //Multimember@field0002#合同金额
                //Member@field0001#合同编号
                if(WorkFlowFinal.FORMFIELD.equals(partyTypeId) && partyId!=null){
                    String[] partyIdValue = partyId.split("[@|#]");
                    String displayName = "";
                    String type = "Member";
                    String roleIdOrName = "";
                    if(partyIdValue.length>=3){
                        displayName = partyIdValue[2];
                        type = partyIdValue[0];
                    } else if(partyIdValue.length>0){
                        displayName = partyIdValue[0];
                    }
                    String fieldNode= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFormFieldNode(displayName, newFormAppId);
                    if(Strings.isNotBlank(fieldNode)){ 
                      //如果数组元素为4个，表示是表单控件下的角色，需要加上角色名
                        if(partyIdValue.length>=4){
                            roleIdOrName = "#"+partyIdValue[3];
                        }
                        party.setId(fieldNode+roleIdOrName);
                    }
                } else if(WorkFlowMatchUserManager.ORGENT_META_KEY_NODE.equals(partyTypeId) 
                        || partyTypeId.equals(V3xOrgEntity.ORGENT_TYPE_DYNAMIC_ROLE)){
                    if(partyId.equals(WorkFlowMatchUserManager.ORGENT_META_KEY_SEDNER)){
                        String newName = ResourceUtil.getString(WorkFlowMatchUserManager.ORGENT_META_KEY_SEDNER_I18N_KEY);
                        party.setName(newName);
                        node.setName(newName);
                    } else if (partyId.equals(WorkFlowMatchUserManager.ORGENT_META_KEY_BlankNode)){
                        String newName = ResourceUtil.getString(WorkFlowMatchUserManager.ORGENT_META_KEY_BlankNode_I18N_KEY);
                        party.setName(newName);
                        node.setName(newName);
                    } else {
                        String type = "", roleNameOrId = "";
                        if (partyId.startsWith(WorkFlowMatchUserManager.ORGENT_META_KEY_SEDNER)){
                            type = ResourceUtil.getString(WorkFlowMatchUserManager.ORGENT_META_KEY_SEDNER_I18N_KEY);
                            roleNameOrId = partyId.substring(WorkFlowMatchUserManager.ORGENT_META_KEY_SEDNER.length());
                        } else if (partyId.startsWith(WorkFlowMatchUserManager.ORGENT_META_KEY_NODEUSER)){
                            type = ResourceUtil.getString(WorkFlowMatchUserManager.ORGENT_META_KEY_NODEUSER_I18N_KEY);
                            roleNameOrId = partyId.substring(WorkFlowMatchUserManager.ORGENT_META_KEY_NODEUSER.length());
                        }
                        if(!"".equals(type)){
                            try {
                                if(WorkFlowMatchUserManager.ORGENT_META_KEY_DEPMEMBER.equals(roleNameOrId)){
                                    String newName = type + ResourceUtil.getString(WorkFlowMatchUserManager.ORGENT_META_KEY_DEPMEMBER_I18N_KEY);
                                    party.setName(newName);
                                    node.setName(newName);
                                } else {
                                    V3xOrgRole role = null;
                                    boolean isSystem = false;
                                    try{
                                        Long roleId = Long.parseLong(roleNameOrId);
                                        role = processOrgManager.getRoleById(roleId);
                                    } catch (NumberFormatException e) {
                                        isSystem = true;
                                        role = processOrgManager.getRoleByName(roleNameOrId, Long.parseLong(party.getAccountId()));
                                    }
                                    if(role!=null){
                                        String newName = "";
                                        if(isSystem){
                                            newName = type + ResourceUtil.getString("sys.role.rolename."+role.getName());
                                        } else {
                                            newName = type + role.getName();
                                        }
                                        party.setName(newName);
                                        node.setName(newName);
                                    }
                                }
                            } catch (NumberFormatException e) {
                                logger.error("复制时出现异常！角色节点中单位id不是Long型"+party.getAccountId(), e);
                            } catch (BPMException e) {
                                logger.error("复制时出现异常！查询角色出现错误！"+roleNameOrId, e);
                            }
                        }
                    }
                }
            }
        }
        replaceOnlyFormInfo(node, oldFormAppId, newFormAppId);
    }
    
    private void replaceOnlyFormInfo(BPMAbstractNode node, String oldFormAppId, String newFormAppId) {
        //node.getSeeyonPolicy().setOperationm("");//默认去掉多视图
    	String operationm= node.getSeeyonPolicy().getOperationm();
    	String newOperationm= getNewOperationm(operationm, oldFormAppId, newFormAppId);
    	node.getSeeyonPolicy().setOperationm(newOperationm);
        node.getSeeyonPolicy().setFormApp(newFormAppId);
        //替换集团基准岗由表单控件决定的fieldName
        //根据被复制的表单中的fieldName或display，找到老表单中表单域的display，
        //然后根据这个display找到新表单中的表单域，获取新表单与的fieldName
        if("4".equals(node.getSeeyonPolicy().getMatchScope())){
            //匹配范围是4表明是集团基准岗由表单控件决定
            String fieldName = node.getSeeyonPolicy().getFormField();
            String newFieldName= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFieldName(fieldName, oldFormAppId, newFormAppId);
            if(Strings.isNotBlank(newFieldName)){
                node.getSeeyonPolicy().setFormField(newFieldName);
            }
        }
        //替换表单绑定
        String operationNameString = node.getSeeyonPolicy().getOperationName();
        String formNameString = node.getSeeyonPolicy().getForm();
        String formAppString = node.getSeeyonPolicy().getFormApp();
        String[] formInfo= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFormInfo(oldFormAppId, formAppString, formNameString, operationNameString);
        if(null!=formInfo){
            node.getSeeyonPolicy().setForm(formInfo[0]);
            node.getSeeyonPolicy().setOperationName(formInfo[1]);
        }
    }
    
    private String getNewOperationm(String operationm,String oldFormAppId,String formAppString) {
    	String[] operationmArr= operationm.split(",");
    	String newOperationm= "";
    	int k=0;
    	if(null!=operationmArr){
    		for (int i=0;i<operationmArr.length;i++) {
    			String myOperationM = operationmArr[i];
    			if(Strings.isNotBlank(myOperationM)){
    				String[] myOperationMArr= myOperationM.split("[|]");
    				String myFormViewId= myOperationMArr[0];
    				String myOperationId= myOperationMArr[1];
        			String[] formInfo= WorkflowFormDataMapInvokeManager.getAppManager("form").getLatestFormInfo(oldFormAppId, formAppString, myFormViewId, myOperationId);
                    if(null!=formInfo){
                    	if(k==0){
                    		newOperationm= formInfo[0]+"|"+formInfo[1];
                    	}else{
                    		newOperationm += ","+formInfo[0]+"|"+formInfo[1];
                    	}
                    	k++;
                    }
    			}
			}
    	}
    	return newOperationm;
	}

	public boolean isExchangeNode(String appName, String policyId, long permissionAccount) {
        try {
            if("office".equalsIgnoreCase(appName)){
                return false;
            }
            String categoryName = "";
            if("sendEdoc".equalsIgnoreCase(appName) || "edocSend".equals(appName)){
                categoryName=EnumNameEnum.edoc_send_permission_policy.name();
            }else if("recEdoc".equalsIgnoreCase(appName) || "edocRec".equals(appName)){
                categoryName=EnumNameEnum.edoc_rec_permission_policy.name();
            }else if("signReport".equalsIgnoreCase(appName) || "edocSign".equals(appName)){
                categoryName=EnumNameEnum.edoc_qianbao_permission_policy.name();
            }else if("sendInfo".equalsIgnoreCase(appName) || "info".equalsIgnoreCase(appName)){
                categoryName = "info_send_permission_policy";
            }else if("collaboration".equals(appName)|| "form".equalsIgnoreCase(appName)){
                categoryName = EnumNameEnum.col_flow_perm_policy.name();
            }
            Permission permission = permissionManager.getPermission(categoryName, policyId,permissionAccount);
            boolean isExChangeNode = permissionManager.isContainsExchangeType(permission);
            return isExChangeNode;
        } catch (Throwable e) {
            logger.error(e);
            return false;
        }
    }

    @Override
    public boolean isRelateNewflow(String processId, String relativeProcessId) throws BPMException {
        boolean result= subProcessManager.isRelateNewflow(processId,relativeProcessId);
        return result;
    }
    
    @Override
    public String[] canWorkflowCurrentNodeSubmit(String workitemId) throws BPMException {
        long beginTime= System.currentTimeMillis();
        String[] result= new String[]{"true",""};
        if(Strings.isBlank(workitemId)){
            result[0]= "false";
            result[1]= "workitemId is missing, cannot execute Return(Assigned), please check the parameters of canWorkflowCurrentNodeSubmit!";
            return result;
        }
        WorkItem workItem= workItemManager.getWorkItemOrHistory(Long.parseLong(workitemId));
        if(null!=workItem){
            int state= workItem.getState();
            //当前人员任务事项状态已是指定回退
            if( state== WorkItem.STATE_SUSPENDED ){
                result[0]= "false";
                result[1]= ResourceUtil.getString("workflow.validate.submit.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
                return result;
            }
            String activityId= workItem.getActivityId();
            String processId= workItem.getProcessId();
            BPMProcess process= processManager.getRunningProcess(processId);
            if(null!=process){
                BPMCase theCase= caseManager.getCase(workItem.getCaseId());
                BPMActivity activity = process.getActivityById(activityId);
                if( null!=activity ){
                    List<String> hasNewflowNodeIds = WorkflowUtil.checkPrevNodeHasNewflow(activity,theCase);
                    if(hasNewflowNodeIds != null && !hasNewflowNodeIds.isEmpty()){
                        List<SubProcessRunning> subList = subProcessManager.checkHasNoFinishNewflow(processId, hasNewflowNodeIds);
                        if(subList != null && subList.size()>0){
                            String aSubProcessId= subList.get(0).getSubProcessProcessId();
                            String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager("collaboration").getSummarySubject(aSubProcessId);
                            result[0]= "false";
                            result[1]= ResourceUtil.getString("workflow.subprocess.not.end.cannot.process", subProcessSubject);//"上节点触发的子流程《"+subProcessSubject+"》未结束，该协同暂不能处理！";
                            return result;
                        }
                    }
                }
            }
        }else{
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        long endTime= System.currentTimeMillis();
        //logger.info("本次工作流ajax校验耗时:"+(endTime-beginTime)+"ms");
        return result;
    }
    
    @Override
    public String[] canWorkflowCurrentNodeSubmit(BPMProcess process,BPMCase theCase,WorkItem workItem) throws BPMException {
        String[] result= new String[]{"true",""};
        if(null!=workItem){
            int state= workItem.getState();
            // 1、当前人员任务事项状态已是指定回退
            if( state== WorkItem.STATE_SUSPENDED ){
                result[0]= "false";
                result[1]= ResourceUtil.getString("workflow.validate.submit.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
                return result;
            }
            //2、主子流程关系控制
            String activityId= workItem.getActivityId();
            String processId= workItem.getProcessId();
            if(null!=process){
                BPMActivity activity = process.getActivityById(activityId);
                if( null!=activity ){
                    List<String> hasNewflowNodeIds = WorkflowUtil.checkPrevNodeHasNewflow(activity,theCase);
                    if(hasNewflowNodeIds != null && !hasNewflowNodeIds.isEmpty()){
                        List<SubProcessRunning> subList = subProcessManager.checkHasNoFinishNewflow(processId, hasNewflowNodeIds);
                        if(subList != null && subList.size()>0){
                            String aSubProcessId= subList.get(0).getSubProcessProcessId();
                            String subProcessSubject= WorkFlowAppExtendInvokeManager.getAppManager("collaboration").getSummarySubject(aSubProcessId);
                            result[0]= "false";
                            result[1]= ResourceUtil.getString("workflow.subprocess.not.end.cannot.process", subProcessSubject);//"上节点触发的子流程《"+subProcessSubject+"》未结束，该协同暂不能处理！";
                            return result;
                        }
                    }
                }
            }
        }else{
            result[0]= "false";
            result[1]= ResourceUtil.getString("workflow.validate.workitem.cancel.msg");//该待办事项可能被删除了，不可进行此操作！
            return result;
        }
        return result;
    }

	@Override
	public List<String> isWorkflowTemplateHasOperationId(
			List<String> operationIdList, Long workTemplateId)
			throws BPMException {
		List<String> result = new ArrayList<String>();
		if(workTemplateId!=null && operationIdList!=null && operationIdList.size()>0){
			Map<String, Integer> operationMap = new HashMap<String, Integer>(operationIdList.size());
			//把权限id放到map中去，key是权限id，value是索引
			for(int i=0,len=operationIdList.size();i<len;i++){
				String operation = operationIdList.get(i);
				operationMap.put(operation, Integer.valueOf(i));
			}
			ProcessTemplete templete = processTemplateManager.selectProcessTemplateById(workTemplateId);
			if(templete!=null){
				BPMProcess process = BPMProcess.fromXML(templete.getWorkflow());
				if(process!=null){
					BPMStatus start = process.getStart();
					String operationName = start.getSeeyonPolicy().getOperationName();
					Integer index = operationMap.get(operationName);
					if(index!=null){
						//如果指定的索引存在，就把结果中对应的索引值设置为权限id
						result.add(operationName);
					}
					List<BPMAbstractNode> allNodes = process.getActivitiesList();//WorkflowUtil.findAllChildHumenActivitys(process.getStart());
					if(allNodes!=null && allNodes.size()>0){
						for(BPMAbstractNode node : allNodes){
						    if(node.getNodeType().equals(BPMAbstractNode.NodeType.humen)){
						        String nodeOperationName = node.getSeeyonPolicy().getOperationName();
	                            Integer nodeIndex = operationMap.get(nodeOperationName);
	                            if(nodeIndex!=null){
	                                //如果指定的索引存在，就把结果中对应的索引值设置为权限id
	                                result.add(nodeOperationName);
	                            }
						    }
						}
					}
				}
			}
		}
		return result;
	}

    @Override
    public boolean isInSpecialStepBackStatus(long caseId) throws BPMException {
    	 BPMCase theCase= caseManager.getCase(caseId);
    	 return isInSpecialStepBackStatus(theCase);
    }
    
    public boolean isInSpecialStepBackStatus(BPMCase theCase) throws BPMException {
        //当前流程是否已经处于指定回退状态
        boolean canStepBack= true;
        Object backCount = theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT);
        int stepCount= backCount == null ? 0 : Integer.valueOf(String.valueOf(backCount));
        
        if(stepCount>0){//流程处于指定回退状态了，不可做回退操作
            canStepBack= false;
            //msg= ResourceUtil.getString("workflow.validate.stepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
        }
        return canStepBack;
    }
    @Override
    public boolean isInSpecialStepBackStatus(long caseId, boolean isHistoryFlag) throws BPMException{
      //当前流程是否已经处于指定回退状态
      boolean canStepBack= true;
      BPMCase theCase= caseManager.getCase(caseId, isHistoryFlag);
      if(theCase != null) {
	      int stepCount= theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)==null?0:Integer.valueOf(String.valueOf(theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT)));
	      if(stepCount>0){//流程处于指定回退状态了，不可做回退操作
	          canStepBack= false;
	          //msg= ResourceUtil.getString("workflow.validate.stepback.msg0");//"当前流程处于指定回退状态,你不能进行此操作!";
	      }
      }
      return canStepBack;
    }

	@Override
	public Long getMainProcessIdBySubProcessId(Long subProcessId)
			throws BPMException {
		if(subProcessId!=null){
			List<SubProcessRunning> subRunningList = subProcessManager.getSubProcessRunningListBySubProcessId(String.valueOf(subProcessId), null, null);
			if(subRunningList!=null && subRunningList.size()>0){
				for(SubProcessRunning subRun : subRunningList){
					if(subRun.getIsActivate()){
						try{
							return Long.parseLong(subRun.getMainProcessId());
						} catch(NumberFormatException e){}
					}
					if(!subRun.getIsDelete()){
						try{
							return Long.parseLong(subRun.getMainProcessId());
						} catch(NumberFormatException e){}
					}
				}
			}
		}
		return null;
	}

    @Override
    public int getHandSelectOptionsNumber(BPMProcess bpmProcess, String currentNodeId, String defaultHst) {
        int hsn=0;
        if( null== bpmProcess){
            return hsn;
        }
        BPMAbstractNode fromNode= null;
        if("start".equals(currentNodeId)){
            fromNode= bpmProcess.getStart();
        }else{
            fromNode= bpmProcess.getActivityById(currentNodeId);
            //split节点这个属性为true
            if(fromNode instanceof BPMAndRouter && ((BPMAndRouter)fromNode).isStartAnd()){
            	fromNode = ((BPMTransition)fromNode.getUpTransitions().get(0)).getFrom();
            }
        }
        HashMap<String,String> conditonMap= new HashMap<String, String>();
        HashMap<String,String> nodeTypes= new HashMap<String, String>();
        List<BPMHumenActivity> children = WorkflowUtil.findDirectHumenChildrenXNDX(fromNode, conditonMap,nodeTypes);
        Map<String,Object> hash = null;
        if(conditonMap.size()>0) {
            Map<String,Object> map = WorkflowUtil.splitCondition(conditonMap);
            if(map == null){
                return hsn;
            }
            List<String> conditions = (List<String>)map.get("conditions");
            if(conditions==null || conditions.size()==0){
                return hsn;
            }
            for(String condition:conditions) {
                if(condition.indexOf("handCondition")!=-1) {
                    hsn++;
                }
            }
        }
        return hsn;
    }

    @Override
    public boolean isNodeDelete(long caseId, String activityId) throws BPMException {
        BPMCase theCase= caseManager.getCase(caseId);
        String processId= theCase.getProcessId();
        ProcessInRunningDAO processInRunningDAO= processManager.getProcessInRunningDAO(processId);
        try {
            BPMProcess process= processInRunningDAO.getProcess();
            if(null!=process){
                BPMActivity activity= process.getActivityById(activityId);
                if(activity==null){
                    return true;
                }
            }
        } catch (Throwable e) {
            logger.error("",e);
        }
        Map<String, Map<String,String>> nodeConditionMap= WorkflowUtil.getNodeConditionChangeInfoMap(theCase);
        if(null!=nodeConditionMap){
            Map<String,String> conditionInfo= nodeConditionMap.get(activityId);
            if(null!=conditionInfo){
                String isDelete= conditionInfo.get("isDelete");
                if(Strings.isNotBlank(isDelete) && "true".equals(isDelete)){
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public boolean isNodeDelete(long caseId, String activityId,
            boolean isHistoryFlag) throws BPMException {
        BPMCase theCase= caseManager.getCase(caseId, isHistoryFlag);
        String processId= theCase.getProcessId();
        ProcessInRunningDAO processInRunningDAO= processManager.getProcessInRunningDAO(processId, isHistoryFlag);
        try {
            BPMProcess process= processInRunningDAO.getProcess();
            if(null!=process){
                BPMActivity activity= process.getActivityById(activityId);
                if(activity==null){
                    return true;
                }
            }
        } catch (Throwable e) {
            logger.error("",e);
        }
        Map<String, Map<String,String>> nodeConditionMap= WorkflowUtil.getNodeConditionChangeInfoMap(theCase);
        if(null!=nodeConditionMap){
            Map<String,String> conditionInfo= nodeConditionMap.get(activityId);
            if(null!=conditionInfo){
                String isDelete= conditionInfo.get("isDelete");
                if(Strings.isNotBlank(isDelete) && "true".equals(isDelete)){
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public BPMProcess getBPMProcessForM1(String processId, Long caseId) throws BPMException {
        if(Strings.isBlank(processId)){
            return null;
        }
        BPMCase theCase= null;
        if(caseId!= null){
            theCase= caseManager.getCase(caseId);
        }
        BPMProcess process= processManager.getRunningProcess(processId);
        if(null==process){
            logger.warn("process为null,processId:="+processId+",请检查!");
            return null;
        }
        String processXml= process.toXML(theCase, true);
        if(Strings.isNotBlank(processXml) && null!= theCase){
            processXml= workFlowDesignerManager.repairProcessData(theCase, processXml, processId); 
        }
        return BPMProcess.fromXML(processXml);
    }

    @Override
    public boolean transCheckBrachSelectedWorkFlow(WorkflowBpmContext context, String checkedNodeId,
            Set<String> allSelectNodes, Set<String> allNotSelectNodes, Set<String> allSelectInformNodes
            ,Set<String> currentSelectInformNodes) throws BPMException {
        logger.info("pId=" + context.getProcessId()+
                    ";pTID="+context.getProcessTemplateId()+
                    ";cId="+context.getCaseId()+
                    ";cAID="+context.getCurrentActivityId()+
                    ";cWID="+context.getCurrentWorkitemId()+
                    ";sUID="+context.getStartUserId()+
                    ";cUID="+context.getCurrentUserId()+
                    ";cAID="+context.getCurrentAccountId()+
                    ";mID="+context.getMastrid()
                    );
        logger.info("fData=" + context.getFormData());
        String processXml = context.getProcessXml();
        String processId = context.getProcessId();
        String processTemplateId = context.getProcessTemplateId();
        Long caseId = context.getCaseId();
        String currentNodeId = context.getCurrentActivityId();
        currentNodeId= (Strings.isBlank(currentNodeId) || "-1".equals(currentNodeId) || "0".equals(currentNodeId))?"start":currentNodeId;
        String formData = context.getFormData();
        BPMProcess process = null;
        try {
            process = BPMProcess.fromXML(processXml);
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
        }
        if (null == process) {
            process = processManager.getRunningProcess(processId);
        }
        if (null == process) {
            processXml = processTemplateManager.selectProcessTempateXml(processTemplateId);
            process = BPMProcess.fromXML(processXml);
        }
        if (null == process) {
            //"根据参数processId[" + processId + "],processTemplateId[" + processTemplateId + "]查不到对应的流程XML"
            throw new BPMException(ResourceUtil.getString("workflow.label.notFindXML", processId, processTemplateId));
        }
        context.setProcess(process);
        context.setCaseId(caseId);
        if (caseId == -1 || caseId == 0) {
            currentNodeId = "start";
        }
        BPMCase theCase = null;
        if (!"start".equals(currentNodeId)) {
            theCase = caseManager.getCase(caseId);
            context.setTheCase(theCase);
        }
        WorkflowUtil.putCaseToWorkflowBPMContext(theCase, context);
        boolean isClearAddition = true;
        
        if (!"start".equals(currentNodeId)) {
            BPMActor startActor = (BPMActor) process.getStart().getActorList().get(0);
            String sender = startActor.getParty().getId() + "";
            context.setStartUserId(sender);
            context.setStartAccountId(startActor.getParty().getAccountId());
        } else {
            context.setStartUserId(context.getCurrentUserId());
            context.setStartAccountId(context.getCurrentAccountId());
        }
        //获取表单数据
        boolean isFromForm = Strings.isNotBlank(formData);
        if (isFromForm) {//表单流程
            if("collaboration".equals(context.getAppName()) 
                    || "form".equals(context.getAppName())){//添加表单数据
                if(context.getFormData().equals(context.getMastrid())){//这种情况是有问题的，要特殊处理下才行
                    String formAppId= process.getStart().getSeeyonPolicy().getFormApp();
                    context.setFormData(formAppId);
                }
                WorkflowUtil.addFormDataDisplayName(context);
            }else if("edoc".equals(context.getAppName()) 
                    || "sendEdoc".equals(context.getAppName())
                    || "edocSend".equals(context.getAppName()) 
                    || "signReport".equals(context.getAppName())
                    || "edocSign".equals(context.getAppName())
                    || "recEdoc".equals(context.getAppName())
                    || "edocRec".equals(context.getAppName())){//添加公文数据
                WorkflowUtil.addEdocDataDisplayName(context);
            }else{
                WorkflowUtil.addAppDataDisplayName(context);
            }
        }
        Map<String,Boolean> autoSkipNodeMap= new HashMap<String, Boolean>();
        boolean result= this.doAfterMatch(context, process, checkedNodeId, allNotSelectNodes,
                allSelectNodes, allSelectInformNodes, currentSelectInformNodes, isClearAddition,false,autoSkipNodeMap);
        return result;
    }
    
    /**
     * 分支匹配后处理
     * @param context
     * @param process
     * @param checkedNodeId
     * @param allNotSelectNodes
     * @param allSelectNodes
     * @param allSelectInformNodes
     * @param currentSelectInformNodes
     * @param isClearAddition
     * @return
     * @throws BPMException
     */
    private boolean doAfterMatch(WorkflowBpmContext context,BPMProcess process,
            String checkedNodeId,Set<String> allNotSelectNodes,
            Set<String> allSelectNodes,Set<String> allSelectInformNodes,
            Set<String> currentSelectInformNodes,boolean isClearAddition,boolean isSystemAutoSelect,Map<String,Boolean> autoSkipNodeMap) throws BPMException{
        Set<String> preSelectInformNodes = new HashSet<String>();
        preSelectInformNodes.add(checkedNodeId);
        CPMatchResultVO cpMatchResult = new CPMatchResultVO();
        cpMatchResult.setAllNotSelectNodes(allNotSelectNodes);
        cpMatchResult.setAllSelectNodes(allSelectNodes);
        if(null==cpMatchResult.getAllSelectInformNodes()){
            cpMatchResult.setAllSelectInformNodes(allSelectInformNodes);
        }else{
            cpMatchResult.getAllSelectInformNodes().addAll(allSelectInformNodes);
        }
        if(null!=currentSelectInformNodes){
            for (String myNodeId : currentSelectInformNodes) {
                BPMAbstractNode aNode= process.getActivityById(myNodeId);
                if(isSystemAutoSelect){//系统自动选择
                  if(ObjectName.isInformObject(aNode)){
                    cpMatchResult.getAllSelectInformNodes().add(aNode.getId());
                  }
                }else{
                    cpMatchResult.getAllSelectInformNodes().add(aNode.getId());
                }
            }
        }
        Map<String, ConditionMatchResultVO> condtionResultAll= new HashMap<String, ConditionMatchResultVO>();
        BranchArgs.doMatchAll(cpMatchResult,preSelectInformNodes,context,isClearAddition,process,null,condtionResultAll,autoSkipNodeMap);
        if(cpMatchResult.isPop() || cpMatchResult.isBackgroundPop()){
            return true;
        }
        return false;
    }

    @Override
    public Map<String, String> importWorkFlow(File[] files, Map<String, String> workflowIdsMap) throws BPMException {
        Map<String, String> resultMap = new HashMap<String, String>();
        boolean success = true;
        String msg = "";
        //从文件解析成工作流模版对象和子流程绑定数据
        Map<ProcessTemplete, List<SubProcessSetting>> templeteMap = ImExportUtil.createImportMap(files);
        if (templeteMap != null && templeteMap.size() > 0) {
            List<Long> willImportTempleteIdList = new ArrayList<Long>();
            List<ProcessTemplete> templeteList = new ArrayList<ProcessTemplete>();
            List<SubProcessSetting> subSettingList = new ArrayList<SubProcessSetting>();
            //把解析得到的工作流模版数据和子流程绑定数据分别放到两个List里
            //应该在这里作流程校验
            for (Map.Entry<ProcessTemplete, List<SubProcessSetting>> entry : templeteMap.entrySet()) {
                ProcessTemplete templete = entry.getKey();
                List<SubProcessSetting> subList = entry.getValue();
                if (templete != null) {
                    //导入的流程暂时设置为草稿状态
//                    templete.setState(0);
                    templete.setState(1);
                    if(null!=workflowIdsMap.get(String.valueOf(templete.getId())+"_name")){
                        templete.setProcessName(workflowIdsMap.get(String.valueOf(templete.getId())+"_name"));
                    }
                    if(null!=workflowIdsMap.get(String.valueOf(templete.getId()))){
                        templete.setId(Long.parseLong(workflowIdsMap.get(String.valueOf(templete.getId()))));
                    }
                    if(null!=workflowIdsMap.get(String.valueOf(templete.getAppId()))){
                        templete.setAppId(Long.parseLong(workflowIdsMap.get(String.valueOf(templete.getAppId()))));
                    }
                    String workflow= templete.getWorkflow();
                    BPMProcess process= BPMProcess.fromXML(workflow);
                    if(process!=null){
                        BPMStart startNode= (BPMStart)process.getStart();
                        String snodeFormAppId= startNode.getSeeyonPolicy().getFormApp();
                        String snodeFormId= startNode.getSeeyonPolicy().getForm();
                        String snodeOperationId= startNode.getSeeyonPolicy().getOperationName();
                        if(null!=workflowIdsMap.get(snodeFormAppId)){
                            startNode.getSeeyonPolicy().setFormApp(workflowIdsMap.get(snodeFormAppId));
                        }
                        if(null!=workflowIdsMap.get(snodeFormId)){
                            startNode.getSeeyonPolicy().setForm(workflowIdsMap.get(snodeFormId));
                        }
                        if(null!=workflowIdsMap.get(snodeOperationId)){
                            startNode.getSeeyonPolicy().setOperationName(workflowIdsMap.get(snodeOperationId));
                        }
                        List<BPMAbstractNode> nodes= process.getActivitiesList();
                        for (BPMAbstractNode node : nodes) {
                            String nodeFormAppId= node.getSeeyonPolicy().getFormApp();
                            String nodeFormId= node.getSeeyonPolicy().getForm();
                            String nodeOperationId= node.getSeeyonPolicy().getOperationName();
                            if(null!=workflowIdsMap.get(nodeFormAppId)){
                                node.getSeeyonPolicy().setFormApp(workflowIdsMap.get(nodeFormAppId));
                            }
                            if(null!=workflowIdsMap.get(nodeFormId)){
                                node.getSeeyonPolicy().setForm(workflowIdsMap.get(nodeFormId));
                            }
                            if(null!=workflowIdsMap.get(nodeOperationId)){
                                node.getSeeyonPolicy().setOperationName(workflowIdsMap.get(nodeOperationId));
                            }
                        }
                        String processXml= process.toXML(null,true);
                        if(null!=workflowIdsMap){//对一些老的ID做统一的替换 
                            Set<String> oldIds= workflowIdsMap.keySet();
                            for (String oldId : oldIds) {
                                processXml= processXml.replaceAll(oldId, workflowIdsMap.get(oldId));
                            }
                        }
                        templete.setWorkflow(processXml);
                    }
                    templeteList.add(templete);
                    willImportTempleteIdList.add(templete.getId());
                    if (subList != null && subList.size() > 0) {
                        int subListSize= subList.size();
                        for(int i=0;i<subListSize;i++){
                            SubProcessSetting sps= subList.get(i);
                            sps.setId(UUIDLong.longUUID());
                            if(null!=workflowIdsMap.get(String.valueOf(sps.getNewflowTempleteId())+"_name")){
                                sps.setSubject(workflowIdsMap.get(String.valueOf(sps.getNewflowTempleteId())+"_name"));
                            }
                            if(null!=workflowIdsMap.get(String.valueOf(sps.getTempleteId()))){
                                sps.setTempleteId(Long.parseLong(workflowIdsMap.get(String.valueOf(sps.getTempleteId()))));
                            }
                            if(null!=workflowIdsMap.get(String.valueOf(sps.getNewflowTempleteId()))){
                                sps.setNewflowTempleteId(Long.parseLong(workflowIdsMap.get(String.valueOf(sps.getNewflowTempleteId()))));
                            }
                            String triggerCondition= sps.getTriggerCondition();
                            if(null!=workflowIdsMap){//对一些老的ID做统一的替换 
                                Set<String> oldIds= workflowIdsMap.keySet();
                                for (String oldId : oldIds) {
                                    triggerCondition= triggerCondition.replaceAll(oldId, workflowIdsMap.get(oldId));
                                }
                            }
                            sps.setTriggerCondition(triggerCondition);
                        }
                        subSettingList.addAll(subList);
                    }
                }
            }
            if (templeteList.size() > 0) {
                //先判断将要导入的工作流模版是否已经存在
                List<ProcessTemplete> oldTemplateList = processTemplateManager
                        .selectProcessTemplateByIdList(willImportTempleteIdList);
                if (oldTemplateList != null && oldTemplateList.size() > 0) {
                    success = false;
                    msg = ResourceUtil.getString("workflow.label.msg.repeatImport");//"流程已经导入过，不能再次导入！";
                    logger.error(msg);
                }
                //保存导入的流程！
                if(success){
                    try {
                        processTemplateManager.saveImportedProcessTemplate("collaboration", templeteList);
                        if (subSettingList.size() > 0) {
                            subProcessManager.saveSubProcessSetting(subSettingList);
                        }
                    } catch (Exception e) {
                        success = false;
                        msg = ResourceUtil.getString("workflow.label.msg.errorWhenSave");//"保存时抛出异常！";
                        logger.error(msg,e);
                    }
                }
            }
        }
        resultMap.put("success", String.valueOf(success));
        resultMap.put("msg", msg);
        return resultMap;
    }

    @Override
    public List<ValidateResultVO> validateWorkflowForBusinessGenerator(long formAppId) throws BPMException {
        List<ValidateResultVO> all= new ArrayList<ValidateResultVO>();
        List<ProcessTemplete> processTemplateList= processTemplateManager.selectProcessTemplateList(formAppId, 1);
        if(null!=processTemplateList && !processTemplateList.isEmpty()){
            int totalSize= processTemplateList.size();
            for(int i=0;i<totalSize;i++){
                ProcessTemplete pTemplate= processTemplateList.get(i);
                String templateId= pTemplate.getId().toString();
                String processName= pTemplate.getProcessName();
                String workflowXml= pTemplate.getWorkflow();
                BPMProcess process= BPMProcess.fromXML(workflowXml);
                List<BPMAbstractNode> nodes= process.getActivitiesList();
                List<ValidateResultVO> nodesVResult= processOrgManager.validateNodeInfo(templateId,processName,"main",nodes);
                List<BPMTransition> links= process.getLinks();
                List<ValidateResultVO> linksVResult= processOrgManager.validateLinkCondition(templateId,processName,"main",links);
                all.addAll(nodesVResult);
                all.addAll(linksVResult);
            }
            //校验子流程触发信息
        }
        return all;
    }
    

    @Override
    public String getWorkflowProcessEventValue(Long processId) {
    	List<WFProcessProperty> processPropertyList = wfProcessPropertyManager.findProcessPropertyByProcessId(processId);
        WFProcessProperty processProperty = null;
        if(processPropertyList != null && processPropertyList.size() >= 1){
            processProperty = processPropertyList.get(0);
        }
        if(processProperty == null){
            return "";
        }
        WFPropertyBean propertyBean = new WFPropertyBean();
        propertyBean.fromJson(processProperty.getValue());
        Map<String, String> processEventMap = new HashMap<String, String>();
        Map<String, Object> processProps = propertyBean.getProcessProps();
        if(!processProps.isEmpty()){
            String workflowEventStr = (String)processProps.get(WorkflowEventConstants.WORKFLOWEVENT);
            Map<String, String> workflowEventMap = (Map<String, String>)JSONUtil.parseJSONString(workflowEventStr);
            List<String> tempList = new ArrayList<String>();
            for(Map.Entry<String, String> entry:workflowEventMap.entrySet()){
                String workflowEventId = entry.getKey();
                String workflowEventValue = entry.getValue();
                tempList.add(workflowEventId + "=" + workflowEventValue);
            }
            processEventMap.put("global", Strings.join(tempList, "|"));
        }
        
        Map<String, Map<String, Object>> activityProps = propertyBean.getActivityProps();
        for (Map.Entry<String, Map<String, Object>> entry:activityProps.entrySet()) {
            String nodeId = entry.getKey();
            Map<String, Object> p = entry.getValue();
            String workflowEventStr = (String)p.get(WorkflowEventConstants.WORKFLOWEVENT);
            Map<String, String> workflowEventMap = (Map<String, String>)JSONUtil.parseJSONString(workflowEventStr);
            List<String> tempList = new ArrayList<String>();
            for(Map.Entry<String, String> entry2:workflowEventMap.entrySet()){
                String workflowEventId = entry2.getKey();
                String workflowEventValue = entry2.getValue();
                tempList.add(workflowEventId + "=" + workflowEventValue);
            }
            processEventMap.put(nodeId, Strings.join(tempList, "|"));
        }
        return JSONUtil.toJSONString(processEventMap);
    }

    @Override
    public boolean hasWorkflowProcessEventValue(Long processId, boolean isStart) {
        WFProcessProperty processProperty = null;
        if(isStart){
            processProperty = wfProcessPropertyManager.getTemplateProcessPropertyByProcessId(processId);
        } else {
            processProperty = wfProcessPropertyManager.getCaseProcessPropertyByProcessId(processId);
        }
        return processProperty != null;
    }

    @Override
    public String[] validateProcessTemplateXMLForEgg(String appName, String workflowId,String myProcessXml, String formApp,
            String formId, String startDefaultOperationId, String normalDefaultOperationId,String subProcessJson) throws BPMException {
        String processXML = "";
        String validateXML = "";
        Long templateId = null;
        Long formAppId = null;
        if(Strings.isNotBlank(workflowId) && !"-1".equals(workflowId) && WorkflowUtil.isLong(workflowId)){
            templateId = Long.parseLong(workflowId);
        }
        if(Strings.isNotBlank(formApp)  && !"-1".equals(formAppId) && WorkflowUtil.isLong(formApp)){
            formAppId= Long.parseLong(formApp);
        }
        if (templateId != null) {
            ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(templateId);
            if (oldTemplete != null) {
                processXML = oldTemplete.getWorkflow();
                if(Strings.isNotBlank(processXML)){
                    //流程校验
                    List<SubProcessSetting> subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
                    if(subList==null){
                        subList = new ArrayList<SubProcessSetting>();
                    }
                    if(Strings.isNotBlank(myProcessXml)){
                        processXML= myProcessXml;
                    }
                    if(Strings.isBlank(subProcessJson)){
                        subProcessJson = workFlowDesignerManager.getSubProcessSettingJson(workflowId, WorkflowDesignerUtil.SCENE_DESIGNER_ADMIN,"true",formApp);
                    }
                    //因为是重定向导入，表单域的display有可能有变化，这里在校验前先做下替换
                    BPMProcess process= BPMProcess.fromXML(processXML);
                    String newProcessXML = WorkflowUtil.changeFormFieldNodeName(null,process,formApp);
                    if(Strings.isNotBlank(newProcessXML)){
                    	processXML= newProcessXML;
                    }
                    subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
                    String[] validate = workFlowDesignerManager.validateTemplateXml(appName, processXML, null, formApp, subList,true);
                    if(validate!=null && validate.length>=3 && "false".equals(validate[0])){
                        validateXML = validate[1];
                        processXML = validate[2];
                    }else{
                        processXML = validate[2];
                    }
                }
            }
        }
        return new String[]{processXML, validateXML, formApp,subProcessJson};
    }

    @Override
    public boolean isProcessTemplateOk(String appName,String formApp,String workflowId)
            throws BPMException {
        ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(Long.parseLong(workflowId));
        String processXml= oldTemplete.getWorkflow();
        String subProcessJson = workFlowDesignerManager.getSubProcessSettingJson(workflowId, WorkflowDesignerUtil.SCENE_DESIGNER_ADMIN,"false",formApp);
        List<SubProcessSetting> subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
        if(subList==null){
            subList = new ArrayList<SubProcessSetting>();
        }
        String[] result = workFlowDesignerManager.validateTemplateXml(appName, processXml, formApp, null, subList);
        if(result!=null && result.length>=3){
            result[2] = "";
        }
        if("false".equals(result[0])){
            return false;
        }else{
            return true;
        }
    }
    
    @Override
    public String[] isProcessTemplatesOk(String appName,String formApp,String[] workflowIds)
            throws BPMException {
        String[] validateResult= new String[workflowIds.length];
        for(int i=0;i<workflowIds.length;i++){
            String workflowId= workflowIds[i];
            ProcessTemplete oldTemplete = processTemplateManager.selectProcessTemplateById(Long.parseLong(workflowId));
            String processXml= oldTemplete.getWorkflow();
            String subProcessJson = workFlowDesignerManager.getSubProcessSettingJson(workflowId, WorkflowDesignerUtil.SCENE_DESIGNER_ADMIN,"false",formApp);
            List<SubProcessSetting> subList = WorkflowUtil.createSubSettingFromStringArray(subProcessJson);
            if(subList==null){
                subList = new ArrayList<SubProcessSetting>();
            }
            String[] result = workFlowDesignerManager.validateTemplateXml(appName, processXml, formApp, null, subList);
            if(result!=null && result.length>=3){
                result[2] = "";
            }
            validateResult[i]= result[0];
        }
        return validateResult;
    }
    
    public List<WFMoreSignSelectPerson> findMoreSignPersons(String typeAndIds){
        return processOrgManager.findMoreSignPersons(typeAndIds);
    }

    @Override
    public String[] isPop(WorkflowBpmContext context) throws BPMException{
        String[] result= new String[]{"false","",""};
        CPMatchResultVO crvo = this.transBeforeInvokeWorkFlow(context, new CPMatchResultVO());
        if( null!= crvo.getInvalidateActivityMap() && crvo.getInvalidateActivityMap().size()>0 ){
            crvo.setPop(true); 
        }
        if(crvo.isPop() || "false".equals(crvo.getCanSubmit()) || Strings.isNotEmpty(crvo.getHumenNodeMatchAlertMsg())){//不能自动跳过
            result[0]= "true";
            if("false".equals(crvo.getCanSubmit())){
            	result[2] = crvo.getCannotSubmitMsg();
            }
            else if( Strings.isNotEmpty(crvo.getHumenNodeMatchAlertMsg())){
            	result[2] =  crvo.getHumenNodeMatchAlertMsg();
            }
        }else{//进一步判断
           String conditon_Str = WorkflowUtil.parseConditionsOfNodes(crvo);
           if(Strings.isNotBlank(conditon_Str)){
               result[0]= "false";
               result[1]= conditon_Str;
           }else{
               result[0]= "false";
           }
        }
        if(Strings.isBlank( result[2])){
        	result[2]= crvo.getMatchResultMsg();
        }
        return result;
    }

	

    @Override
    public int getSuperNodeStatus(String processId, String nodeId) throws BPMException {
        WorkflowSuperNodeControl control= workflowSuperNodeControlManager.getWorkflowSuperNodeControl(processId, nodeId);
        if(null!=control){
            if(control.getPendingType()==WorkflowSuperNodeControlManager.PENDING_TYPE_HUMAN_EXCEPTION
                    || control.getPendingType()==WorkflowSuperNodeControlManager.PENDING_TYPE_HUMAN_SUBMIT
                    || control.getPendingType()==WorkflowSuperNodeControlManager.PENDING_TYPE_HUMAN_BACK){
                return control.getPendingType();
            }
        }
        return WorkflowSuperNodeControlManager.PENDING_TYPE_HUMAN_DEFAULT;
    }

    /**
     * @param workflowSuperNodeControlManager the workflowSuperNodeControlManager to set
     */
    public void setWorkflowSuperNodeControlManager(WorkflowSuperNodeControlManager workflowSuperNodeControlManager) {
        this.workflowSuperNodeControlManager = workflowSuperNodeControlManager;
    }

    @Override
    public List<V3xOrgMember> getUserListForNodeReplace(String processId, String activityId, Long currentUserId,
            Long currentAccountId) {
        try{
            BPMCase theCase= caseManager.getCaseOrHistoryCaseByProcessId(processId);
            BPMProcess process= processManager.getRunningProcess(processId);
            WorkflowBpmContext wfContext = new WorkflowBpmContext();
            wfContext.setCurrentUserId(currentUserId.toString());
            wfContext.setCurrentAccountId(currentAccountId.toString());
            wfContext.setCurrentActivityId(activityId);
            wfContext.setTheCase(theCase);
            wfContext.setProcess(process);
            if(null==process){
                logger.warn("processId is null ");
                return null;
            }
            BPMAbstractNode currentNode= process.getActivityById(activityId);
            if(null==currentNode){
                logger.warn("currentNode is null ");
                return null;
            }
            BPMHumenActivity humenActivity= (BPMHumenActivity)process.getActivityById(activityId);
            BPMSeeyonPolicy policy= humenActivity.getSeeyonPolicy();
            BPMActor actor= (BPMActor)humenActivity.getActorList().get(0);
            BPMParticipant party = actor.getParty();
            
            String processMode_bak= policy.getProcessMode();
            String partyId_bak = party.getId();
            String partyTypeId_bak = party.getType().id;
            BPMParticipantType party_type_bak = party.getType();
            String copyFrom= humenActivity.getCopyFrom();
            String copyNumber= humenActivity.getCopyNumber();
            
            String processMode_tmp = "all";
            String partyId_tmp = "Node";
            String partyTypeId_tmp = policy.getDealTermUserId();
            BPMParticipantType party_tmp = new BPMParticipantType(partyId_tmp);
            boolean isIncludeChild_bak= party.isIncludeChild();
            
            boolean isIncludeChild= true;
            if(partyTypeId_tmp.startsWith("CurrentNodeDeptMember") //当前节点成员
                    || partyTypeId_tmp.startsWith("CurrentNodeSuperDeptDeptMember")//当前节点上级部门成员
                    || partyTypeId_tmp.startsWith("SenderDeptMember") //发起者部门成员
                    || partyTypeId_tmp.startsWith("NodeUserDeptMember") //上节点部门成员 
                    || partyTypeId_tmp.startsWith("SenderSuperDeptDeptMember")//发起者上级部门部门成员
                    || partyTypeId_tmp.startsWith("NodeUserSuperDeptDeptMember")//上节点上级部门部门成员
                    ){
                if(partyTypeId_tmp.endsWith("|0")){
                    isIncludeChild= false;
                }else{
                    isIncludeChild= true;
                }
                int endPosition= partyTypeId_tmp.indexOf("|");
                if(endPosition>0){
                    partyTypeId_tmp= partyTypeId_tmp.substring(0,endPosition);
                }
                party.setId(partyTypeId_tmp);
                party.setIncludeChild(isIncludeChild); 
            }else{
                party.setId(partyTypeId_tmp); 
            }
            party.setType(party_tmp);
            policy.setProcessMode(processMode_tmp);
            humenActivity.setCopyFrom("");
            humenActivity.setCopyNumber("");
            
            wfContext.setFindReplaceNodeUser(true);//标识为查找超期指定人员
            List<V3xOrgMember> list= workflowMatchUserManager.getUserList("Engine_1", humenActivity, wfContext, false);
            List<V3xOrgMember> result= new ArrayList<V3xOrgMember>();
            if(null!=list && !list.isEmpty()){
                for (V3xOrgMember v3xOrgMember : list) {
                    if(v3xOrgMember.isValid() && !Strings.equals(v3xOrgMember.getId(), currentUserId)){//当前人除外
                        result.add(v3xOrgMember); 
                    }
                }
            }
            party.setType(party_type_bak);
            policy.setProcessMode(processMode_bak);
            humenActivity.setCopyFrom(copyFrom);
            humenActivity.setCopyNumber(copyNumber);
            party.setId(partyId_bak);
            party.setIncludeChild(isIncludeChild_bak); 
            return result;
        }catch(Throwable e){
            logger.error("超期转指定人，根据相对角色查找人员出现异常!",e);
        }
        return null;
    }

    @Override
    public void moveWorkitemHistoryToRun(Long workitemId) throws BPMException {
        int state= 7;
        String actionstate="0,26";
        workItemManager.updateWorkItemToRunState(workitemId, state, actionstate);
    }
    
    @Override
	public String getWorkflowNodeRelationInfoJsonForSass(String currentUserId,String currentUserName,String processId,
			String currentNodeId) throws BPMException {
		if(Strings.isBlank(processId) || Strings.isBlank(currentNodeId)){
			return "";
		}
		BPMProcess process = processManager.getRunningProcess(processId);
		if(null==process){
			return "";
		}
		BPMAbstractNode currentNode= process.getActivityById(currentNodeId);
		if(null==currentNode){
			return "";
		}
		BPMCase theCase= caseManager.getCaseOrHistoryCaseByProcessId(processId);
		BPMStart startNode= (BPMStart)process.getStart();
		String nodeName= startNode.getName();
		BPMActor startActor = (BPMActor) process.getStart().getActorList().get(0);
		String startUserId= startActor.getParty().getId();
		
		boolean sp= false;
		boolean hasp= false;
		int pt= 0;
		String pn= "";
		List<String> ph= new ArrayList<String>();
		//获得所有父亲节点集合
		List<BPMHumenActivity> parents= WorkflowUtil.getParentHumens(theCase,currentNode);
		if(null==parents || parents.isEmpty()){//当前节点之前为发起者
			sp= false;
		}else{
			pn= parents.get(0).getName();
			for (BPMHumenActivity bpmHumenActivity : parents) {
				BPMActor bpmactor= (BPMActor)bpmHumenActivity.getActorList().get(0);
				BPMParticipant party= bpmactor.getParty();
				String addition= WorkflowUtil.getNodeAdditionFromCase(theCase, bpmHumenActivity.getId(), party, "addition");
				if(Strings.isNotBlank(addition)){
					String[] addtions= addition.split(",");
					for (String userIdStr : addtions) { 
						pt++;
						User user= processOrgManager.getUserById(userIdStr, false);
						String userInfo= "{\"i\":\""+userIdStr+"\",\"n\":\""+user.getName()+"\",\"d\":\""+bpmHumenActivity.getName()+"\"}";
						ph.add(userInfo);
					}
				}
				if(!sp){
					List<BPMHumenActivity> parents1= WorkflowUtil.getParentHumens(theCase, bpmHumenActivity);
					if(null!=parents1 && !parents1.isEmpty()){
						sp= true;
					}
				}
			}
		}
		
		String current= "\"c\":{\"i\":\""+currentUserId+"\",\"n\":\""+currentUserName+"\",\"d\":\""+currentNode.getName()+"\"}";
		
		//所有孩子节点集合
		List<BPMHumenActivity> childs= WorkflowUtil.getChildHumens((BPMActivity)currentNode);
		boolean cn= false;
		if(null!=childs && !childs.isEmpty()){
			cn= true;
		}
		
		
		StringBuffer sb= new StringBuffer("{");
		sb.append("\"s\":{").append("\"i\":\"").append(startUserId).append("\",\"n\":\"").append(nodeName).append("\"},");//发起者
		if(sp){
			sb.append("\"sp\":\"1\",");
		}else{
			sb.append("\"sp\":\"0\",");
		}
		if(pt>0){
			sb.append("\"p\":{");
			sb.append("\"n\":\"").append(pn).append("\",");
			sb.append("\"t\":\"").append(pt).append("\",");
			sb.append("\"h\":[");
			for(int i=0;i<ph.size();i++){
				String h= ph.get(i);
				if(i==0){
					sb.append(h);
				}else{
					sb.append(",").append(h);
				}
			}
			sb.append("]");
			sb.append("},");
		}
		sb.append(current).append(",");
		if(cn){
			sb.append("\"cn\":\"1\"");
		}else{
			sb.append("\"cn\":\"0\"");
		}
		sb.append("}");
		return sb.toString();
	}

	@Override
	public String getWorkflowJsonForMobile(boolean isRunning,String processId,String caseId) throws BPMException {
		return getWorkflowJsonForMobile(isRunning, processId, caseId, true, null);
	}
	
	@Override
	public String getWorkflowJsonForMobileNoMembers(boolean isRunning, String processId, String caseId, String currentUserName)
	        throws BPMException {
	    return getWorkflowJsonForMobile(isRunning, processId, caseId, false, currentUserName);
	}
	
	
	/**
	 * 重写getWorkflowJsonForMobile 方法
	 * @param isRunning
	 * @param processId
	 * @param caseId
	 * @param loadMembers
	 * @return
	 * @throws BPMException 
	 *
	 * @Since A8-V5 6.1
	 * @Author      : xuqw
	 * @Date        : 2017年4月1日下午4:33:27
	 *
	 */
	private String getWorkflowJsonForMobile(boolean isRunning,
	                         String processId,String caseId, 
	                         boolean loadMembers, String startMemberName) throws BPMException{
	    
	    String processXml= "";
        Map<String,String[]> nodesStatus= null;
        Map<String, List<String[]>> nodesItemsStatus= null;
        //计算位置
        CalculateProcessNodePosition caculate= new CalculateProcessNodePosition();
        caculate.setAddMembers4Mobile(loadMembers);
        
        String workflowJson= "";
        if(isRunning){//查实例流程
            BPMProcess process = processManager.getRunningProcess(processId);
            if(process == null){
                process = processManager.getRunningProcessHis(processId);
            }
            BPMCase theCase= null;
            if(Strings.isNotBlank(caseId)){
                theCase= caseManager.getCase(Long.parseLong(caseId));
                Object[] result = getNodeStatusForM1(Long.parseLong(caseId));
                nodesStatus= (Map<String,String[]>)result[0]; 
                
                int startState = processManager.getProcessState(processId);
                if(startState == ProcessStateEnum.processState.startNodeTome.ordinal()){
                    //开始节点为指定回退状态
                    nodesStatus.put("start", new String[]{String.valueOf(WorkItem.STATE_NEEDREDO_TOME), "true"});
                }
                
                nodesItemsStatus= (Map<String, List<String[]>>)result[1];
            }
            //caculate.setTheCase(theCase);
            processXml= process.toXML(theCase, true);
            process= BPMProcess.fromXML(processXml);
            workflowJson= caculate.analysisProcessDataForMobileJson(process,caseId,nodesStatus,nodesItemsStatus);
        }else{//查模板流程
            caculate.setStartMemberName(startMemberName);
            ProcessTemplete processTemplate = processTemplateManager.selectProcessTempate(processId);
            processXml= processTemplate.getWorkflow();
            workflowJson= caculate.analysisProcessDataForMobileJson(processXml,caseId,nodesStatus,nodesItemsStatus);
        }
        return workflowJson;
	}

	@Override
	public String getWorkflowXMLForMobile(boolean isRunning,String processId,String caseId) throws BPMException{
	    String processXml= "";
        if(isRunning){//查实例流程
            BPMProcess process = processManager.getRunningProcess(processId);
            BPMCase theCase= null;
            if(Strings.isNotBlank(caseId)){
                theCase= caseManager.getCase(Long.parseLong(caseId));
            }
            processXml= process.toXML(theCase, true);
        }else{//查模板流程
            ProcessTemplete processTemplate = processTemplateManager.selectProcessTempate(processId);
            processXml= processTemplate.getWorkflow();
        }
        return processXml;
	}
	
	
	@Override
	public String canTakeBack(String appName, String processId, String activityId, String workitemId) throws BPMException {
		return WFAjax.canTakeBack(appName, processId, activityId, workitemId);
	}

	@Override
	public String freeAddNode(String workflowXml,String orgJson,String currentNodeId,String type,
	                      String currentUserId,String currentUserName, String currentAccountId,
	                      String currentAccountName,String defaultPolicyId,String defaultPolicyName,
	                      List<BPMHumenActivity> addHumanNodes) throws BPMException {
	    
	String processXml= processManager.freeAddNode(workflowXml, orgJson, currentNodeId, type, currentUserId, currentUserName,
				currentAccountId, currentAccountName, defaultPolicyId, defaultPolicyName, addHumanNodes);
		
		return processXml;
	}

	@Override
	public String getWorkflowJsonForMobile(String processXml, List<String> showNodes,String caseId) throws BPMException {
		
	    Map<String,String[]> nodesStatus= null;
        Map<String, List<String[]>> nodesItemsStatus= null;
        if(Strings.isNotBlank(caseId) && !"-1".equals(caseId)){
            Object[] result = getNodeStatusForM1(Long.parseLong(caseId));
            nodesStatus= (Map<String,String[]>)result[0]; 
            nodesItemsStatus= (Map<String, List<String[]>>)result[1];
        }
	    
	    //计算位置
        CalculateProcessNodePosition caculate= new CalculateProcessNodePosition();
        caculate.setAddMembers4Mobile(false);
        
        String workflowJson= caculate.analysisProcessDataForMobileJson(processXml,caseId,nodesStatus,nodesItemsStatus, showNodes);
		return workflowJson;
	}
	
	@Override
	public String freeDeleteNode(String workflowXml, String currentNodeId) throws BPMException {
		
		String processXml= processManager.freeDeleteNode(workflowXml,currentNodeId);
		
		return processXml;
	}

	@Override
	public String[] freeReplaceNode(String workflowXml, String currentNodeId,String oneOrgJson,String defaultPolicyId,String defaultPolicyName,BPMCase theCase) throws BPMException {
		
		String[] processXml = processManager.freeReplaceNode(workflowXml,currentNodeId,oneOrgJson,defaultPolicyId,defaultPolicyName,theCase);
		
		return processXml;
	}

	@Override
	public String freeChangeNodeProperty(String workflowXml, String currentNodeId, String nodePropertyJson
	        , boolean updateAll, List<String> updateNodesList,BPMCase theCase) throws BPMException {
		
		String processXml= processManager.freeChangeNodeProperty(workflowXml,currentNodeId,nodePropertyJson, updateAll, updateNodesList,theCase);
		
		return processXml;
	}

	@Override
	public String selectWrokFlowTemplateXml(String processTempateId, boolean isUpdateFormFieldName) throws BPMException {
		String processXml= processTemplateManager.selectProcessTempateXml(processTempateId);
        if(Strings.isNotBlank(processXml) && isUpdateFormFieldName){
            BPMProcess process= BPMProcess.fromXML(processXml);
        	String newProcessXml = WorkflowUtil.changeFormFieldNodeName(null, process,null);
        	if(Strings.isNotBlank(newProcessXml)){
        	    processXml= newProcessXml;
        	}
        }
        return processXml;
	}

	@Override
	public List<BPMAbstractNode> getHumenNodeInOrderFromId(String processId) throws BPMException {
		BPMProcess process= this.getBPMProcessForM1(processId);
		List<BPMAbstractNode> nodes= this.getHumenNodeInOrderFromProcess(process);
		return nodes;
	}

	@Override
	public List<BPMAbstractNode> getHumenNodeInOrderFromProcess(BPMProcess process) throws BPMException {
		CalculateProcessNodePosition cal= new CalculateProcessNodePosition();
		List<BPMAbstractNode> lists= cal.getHumenNodeInOrderFromProcess(process);
		return lists;
	}

	@Override
	public List<BPMAbstractNode> getHumenNodeInOrderFromXml(String processXml) throws BPMException {
		BPMProcess process= BPMProcess.fromXML(processXml);
		List<BPMAbstractNode> nodes= this.getHumenNodeInOrderFromProcess(process);
		return nodes;
	}
	
	@Override
	public String[] validateCurrentSelectedNode(String caseId, String currentSelectedNodeId,
	            String currentSelectedNodeName, String currentStepbackNodeId, String initialize_processXml,
	            String permissionAccountId, String configCategory,String processId) throws BPMException {
		return WFAjax.validateCurrentSelectedNode(caseId, currentSelectedNodeId, currentSelectedNodeName, currentStepbackNodeId, initialize_processXml, permissionAccountId, configCategory, processId);
	}

	@Override
	public boolean isNodeFormReadonly(String nodeId, String processId) throws BPMException {

		boolean isFormReadonly = false;
        if(processId!=null && nodeId!=null){
	        ProcessInRunningDAO dao= processManager.getProcessInRunningDAO(processId);
	        BPMProcess process= null;
	        try {
	            process = dao.getProcess();
	            if(process!=null){
	            	BPMActivity node = process.getActivityById(nodeId);
	            	if(node!=null){
	            		if("1".equals(node.getSeeyonPolicy().getFR())){
	            			isFormReadonly = true;
	            		} else {
	            			String operationIdString = node.getSeeyonPolicy().getOperationName();
	            			String formAppString = node.getSeeyonPolicy().getFormApp();
	                        if(WorkflowUtil.isLong(formAppString) && WorkflowUtil.isLong(operationIdString)){
	                            isFormReadonly= WorkflowFormDataMapInvokeManager.getAppManager("form").isFormOperationReadOnly(Long.parseLong(formAppString),
	                                    Long.parseLong(operationIdString));
	                        }
	            		}
	            	}
	            }
	        } catch (Throwable e) {
	            logger.error(e);
	        }
        }
		return isFormReadonly;
	
	}

	@Override
	public List<CtpTemplateVO> getCtpTemplateByOrgIdsAndCategory(Long currentUserId,boolean isLeave,Long memberId, Long accountId, List<String> ids,
			boolean blur, ApplicationCategoryEnum... types) throws BusinessException {
		List<CtpTemplateVO> list= processTemplateManager.getCtpTemplateByOrgIdsAndCategory(currentUserId,isLeave,memberId, accountId, ids, blur, types);
		return list;
	}
	
	public List<CtpTemplateVO> getCtpTemplateByOrgIdsAndCategory(Long currentUserId, Long accountId, String orgId, ApplicationCategoryEnum... types) throws BusinessException {
	    List<CtpTemplateVO> list= processTemplateManager.getCtpTemplateByOrgIdsAndCategory(currentUserId, accountId, orgId, types);
	    return list;
	}
	
	/**
	 * 获取节点名字
	 * @param processTemplateId 模板流程ID
	 * @param nodeId  节点Id
	 * @return
	 */
	public String getBPMActivityDesc(Long processTemplateId, String nodeId) {
		return processTemplateManager.getBPMActivityDesc(processTemplateId, nodeId);
	}

	@Override
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache() {
		List<ProcessLogDetail> allProcessLogDetailList= new ArrayList<ProcessLogDetail>();
		String key = "";
		try {
			Map<String, String> wfdef = ParamUtil.getJsonDomain("workflow_definition");
			String conditionsOfNodes= wfdef.get("workflow_node_condition_input");
			key = WorkflowUtil.getWorkflowMatchRequestToken(conditionsOfNodes);
			return this.getAllWorkflowMatchLogAndRemoveCache(key, conditionsOfNodes);
		} catch (Throwable e) {
			logger.warn("",e);
		}
		return allProcessLogDetailList;
	}
	

	@Override
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache(String conditionsOfNodes) {
		List<ProcessLogDetail> allProcessLogDetailList= new ArrayList<ProcessLogDetail>();
		String key = "";
		try {
			key = WorkflowUtil.getWorkflowMatchRequestToken(conditionsOfNodes);
			return this.getAllWorkflowMatchLogAndRemoveCache(key, conditionsOfNodes);
		} catch (Throwable e) {
			logger.warn("",e);
		}
		return allProcessLogDetailList;
	}
	
	
	@Override
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache(String matchRequestToken,String conditionsOfNodes) {
		List<ProcessLogDetail> allProcessLogDetailList= new ArrayList<ProcessLogDetail>();
		try {
			Map<String,String> conditionNodes= new HashMap<String, String>();
			if(Strings.isNotBlank(matchRequestToken)){
				if(Strings.isNotBlank(conditionsOfNodes)){
					conditionNodes= WorkflowUtil.getPopNodeConditionValues(conditionsOfNodes, new HashMap());
				}
				ProcessLogDetail processLogDetail= null;
				LinkedHashMap<String,WorkflowMatchLogVO> needSelectBranchNodeMap= workflowMatchUserManager.getAllWorkflowNeedSelectBranchNodeCacheMap(matchRequestToken);
				Set<String> selectNodeIds= new HashSet<String>();
				if(null!=needSelectBranchNodeMap && !needSelectBranchNodeMap.isEmpty() && null!=conditionNodes && !conditionNodes.isEmpty()){
					StringBuilder branchSelectPeopleBuilder= new StringBuilder();
					StringBuilder allNodeNames= new StringBuilder();
					StringBuilder selectNodeNames= new StringBuilder();
					Set<String> nodes= needSelectBranchNodeMap.keySet();
					int i=0;
					int j=0;
					for (String nodeId : nodes) {
						
						if(!conditionNodes.containsKey(nodeId)){
							continue;
						}
						WorkflowMatchLogVO vo= needSelectBranchNodeMap.get(nodeId);
						String nodeName= vo.getNodeName();
						String isDelete= conditionNodes.get(nodeId);
						if(Strings.isNotBlank(isDelete) && !isDelete.equals("true")){
							selectNodeIds.add(nodeId);
							if(i>0){
								selectNodeNames.append("、");
							}
							selectNodeNames.append(nodeName);
							i++;
						}
						
						if(j>0){
							allNodeNames.append("、");
						}
						allNodeNames.append(nodeName);
						j++;
					}
					Set<String> nodeIds= conditionNodes.keySet();
					for (String nodeId : nodeIds) {
						String isDelete= conditionNodes.get(nodeId);
						if(Strings.isNotBlank(isDelete) && !isDelete.equals("true")){
							selectNodeIds.add(nodeId);
						}
					}
					
					if(Strings.isNotBlank(allNodeNames.toString())){
						com.seeyon.ctp.common.authenticate.domain.User currentUser= CurrentUser.get();
						branchSelectPeopleBuilder.append("{\"").append(WorkflowMatchLogMessageConstants.step4).append("\":[\"");
						if(Strings.isNotBlank(selectNodeNames.toString())){
						    
						    //{0}提交时，手动选择了分支节点<font color=''blue''>{1}</font>。
						    branchSelectPeopleBuilder.append(ResourceUtil.getString("workflow.label.msg.manuallySelectedNode", currentUser.getName(), selectNodeNames));
						}else{
						    //{0}提交时，由于有其他分支能够走通，系统没有强制要求手动选择
							branchSelectPeopleBuilder.append(ResourceUtil.getString("workflow.label.msg.branchSelect1", currentUser.getName()));
						}
						branchSelectPeopleBuilder.append("\"]}");
						processLogDetail= new ProcessLogDetail();
						processLogDetail.setIdIfNew();
						processLogDetail.setNodeName("-");
						processLogDetail.setNodeType("-");
						processLogDetail.setProcessMode("[\"-\"]");
						processLogDetail.setMatchSate(0);
						processLogDetail.setNodeMsg(branchSelectPeopleBuilder.toString()); 
					}
				}
				allProcessLogDetailList= workflowMatchUserManager.getAllWorkflowMatchLogStr(matchRequestToken,selectNodeIds,processLogDetail);
			}
		} catch (Throwable e) {
			logger.warn("",e);
		} finally{
			if(Strings.isNotBlank(matchRequestToken)){
				workflowMatchUserManager.removeWorkflowMatchResult(matchRequestToken);
			}
		}
		return allProcessLogDetailList;
	}

	@Override
	public void putWorkflowMatchLogMatchStateToCache(String matchRequestToken, String autoSkipNodeId,
			String autoSkipNodeName, int matchState) {
		workflowMatchUserManager.putWorkflowMatchLogMatchStateToCache(matchRequestToken, autoSkipNodeId, autoSkipNodeName, matchState);
	}

	@Override
	public void putWorkflowMatchLogProcessModeToCache(String matchRequestToken, String autoSkipNodeId,
			String autoSkipNodeName, List<String> processMode) {
		workflowMatchUserManager.putWorkflowMatchLogProcessModeToCache(matchRequestToken, autoSkipNodeId, autoSkipNodeName, processMode);
	}

	@Override
	public void putWorkflowMatchLogNodeTypeToCache(String matchRequestToken, String autoSkipNodeId,
			String autoSkipNodeName, String nodeType) {
		workflowMatchUserManager.putWorkflowMatchLogNodeTypeToCache(matchRequestToken, autoSkipNodeId, autoSkipNodeName, nodeType);
	}

	@Override
	public void putWorkflowMatchLogToCache(String stepIndex, String key, String autoSkipNodeId, String nodeName,
			List<String> canNotSkipMsgList) {
		workflowMatchUserManager.putWorkflowMatchLogToCache(stepIndex, key, autoSkipNodeId, nodeName, canNotSkipMsgList);
		
	}

	@Override
	public void putWorkflowMatchLogMsgToCache(String stepIndex, String key, String autoSkipNodeId, String nodeName,
			String canNotSkipMsg) {
		workflowMatchUserManager.putWorkflowMatchLogMsgToCache(stepIndex, key, autoSkipNodeId, nodeName, canNotSkipMsg);
	}

	@Override
	public void putWorkflowMatchLogToCacheHead(String stepIndex, String key, String autoSkipNodeId, String nodeName,
			List<String> canNotSkipMsgList) {
		workflowMatchUserManager.putWorkflowMatchLogToCacheHead(stepIndex, key, autoSkipNodeId, nodeName, canNotSkipMsgList);
	}

	@Override
	public String getLockMsg(String action, String userName, String from,Long lockTime) {
		return processManager.getLockMsg(action, userName, from,lockTime);
	}

	@Override
	public void removeAllWorkflowMatchLogCache(String matchRequestToken) {
		workflowMatchUserManager.removeWorkflowMatchResult(matchRequestToken);
	}

	@Override
	public void putWorkflowMatchLogMatchNodeNameToCache(String matchRequestToken, String autoSkipNodeId, String nodeName) {
		workflowMatchUserManager.putWorkflowMatchLogMatchNodeNameToCache(matchRequestToken, autoSkipNodeId, nodeName);
	}

	@Override
	public String[] getNodeTypeName(BPMActivity bpmActivity, com.seeyon.ctp.common.authenticate.domain.User user) {
		String nodeTypeName= "-";
		String nodeName= bpmActivity.getName();
		List actorList = bpmActivity.getActorList();
		BPMActor actor = (BPMActor) actorList.get(0);
		BPMParticipant party = actor.getParty();
        //partyTypeId就是actor标签的partyType属性的值
        String partyTypeId = party.getType().id;
        HumenNodeMatchInterface humenNodeMatchInterface= HumenNodeMatchManager.getHumenNodeMatchInterface(partyTypeId);
        if(null!=humenNodeMatchInterface){//给应用扩展留个接口
        	nodeTypeName= humenNodeMatchInterface.getTypeName();
        }
        if(!"Member".equals(partyTypeId) && !"user".equals(partyTypeId)){
        	nodeName += "("+user.getName()+")";
        }
		return new String[]{nodeTypeName,nodeName}; 
	}

	@Override
	public void saveMatchProcessLog(int state,String matchRequestToken,String processId,
			BPMActivity bpmActivity,com.seeyon.ctp.common.authenticate.domain.User user,String... params) {
		String[] nodeInfo= this.getNodeTypeName(bpmActivity,user);
		String nodeTypeName= nodeInfo[0];
		String nodeName= nodeInfo[1];
		this.putWorkflowMatchLogMatchNodeNameToCache(matchRequestToken, bpmActivity.getId(),nodeName);
		this.putWorkflowMatchLogMatchStateToCache(matchRequestToken, bpmActivity.getId(), "", state);
		this.putWorkflowMatchLogNodeTypeToCache(matchRequestToken, bpmActivity.getId(), "", nodeTypeName);
		BPMSeeyonPolicy policy= bpmActivity.getSeeyonPolicy();
        String processModeName= ResourceUtil.getString("workflow.commonpage.processmode."+policy.getProcessMode());
		List<String> processMode= new ArrayList<String>();
		processMode.add(processModeName);
		this.putWorkflowMatchLogProcessModeToCache(matchRequestToken, bpmActivity.getId(), "", processMode);
		List<ProcessLogDetail> allProcessLogDetailList= this.getAllWorkflowMatchLogAndRemoveCache(matchRequestToken,"");
		if(null!=allProcessLogDetailList && !allProcessLogDetailList.isEmpty()){
			List<ProcessLogDetail> myAllProcessLogDetailList= new ArrayList<ProcessLogDetail>();
			for (ProcessLogDetail processLogDetail : allProcessLogDetailList) {
				if(bpmActivity.getId().equals(processLogDetail.getNodeId())){
					myAllProcessLogDetailList.add(processLogDetail);
				}
			}
			String desc= "";
			if(state==2){
				desc= ResourceUtil.getString(WorkflowMatchLogMessageConstants.NODE_CANNOT_AUTOSKIP);//"不能超期自动跳过。";
				ProcessLog log = new ProcessLog(Long.parseLong(processId), Long.parseLong(bpmActivity.getId()), ProcessLogAction.processColl_SysAuto, user.getId());
				log.setProcessLogDetailList(myAllProcessLogDetailList);
				log.setDesc(desc);
				processLogManager.insertLog(log);
			}else if(state==3){
				desc= ResourceUtil.getString(WorkflowMatchLogMessageConstants.NODE_CANNOT_REPEATSKIP);//"不能重复合并处理。";
				ProcessLog log = new ProcessLog(Long.parseLong(processId), Long.parseLong(bpmActivity.getId()), ProcessLogAction.autoskip, user.getId());
				log.setProcessLogDetailList(myAllProcessLogDetailList);
				log.setDesc(desc);
				processLogManager.insertLog(log);
			}else if(state == 4){
				desc = ResourceUtil.getString(WorkflowMatchLogMessageConstants.NODE_CAN_AUTOSKIP);// "节点超期自动跳过";
				ProcessLog log = new ProcessLog(Long.parseLong(processId), Long.parseLong(bpmActivity.getId()), ProcessLogAction.processColl_SysAuto, user.getId());
				log.setProcessLogDetailList(myAllProcessLogDetailList);
				log.setDesc(desc);
				processLogManager.insertLog(log);
			}
		}
	}

	public ProcessLogManager getProcessLogManager() {
		return processLogManager;
	}

	public void setProcessLogManager(ProcessLogManager processLogManager) {
		this.processLogManager = processLogManager;
	}

	
	
    @Override
    public SeeyonBPMHandResult transTakeBack(SeeyonBPMHandParam4Tackback takeBackParam) throws BusinessException {

        SeeyonBPMHandResult ret = new SeeyonBPMHandResult();
        String appName = takeBackParam.getAppName();
        
        SeeyonBPMAppHandler handler = SeeyonBPMManager.getBPMHandler(appName);
        
        if(handler != null){
            
            V3xOrgMember currentUser = takeBackParam.getCurrentUser();
            String workitemId = takeBackParam.getWorkitemId();
            Long itemId = Long.valueOf(workitemId);
            
            WorkItem item = workItemManager.getWorkItemOrHistory(itemId);
            if(item == null)
                throw new BusinessException("Invalid workitemId" + workitemId + "!");
            
          //数据预处理
            if(ret.isHandResult()){
                
                String[] preRet =  handler.preTackBack(takeBackParam.getAppData(), itemId);
                if(preRet == null || preRet.length < 2 || !"0".equals(preRet[0])){
                    ret.setError(preRet[0], preRet[1]);
                    return ret;
                }
            }
            
            String processId = item.getProcessId();
            String activityId = item.getActivityId();
            
            //流程校验通过
            String wfCheck = canTakeBack(appName, processId, activityId, workitemId);
            Map wfCheckJson = JSONUtil.parseJSONString(wfCheck, Map.class);
            Boolean canTackback = (Boolean) wfCheckJson.get("canTakeBack");
            if(canTackback == null || !canTackback){
                String state = (String)wfCheckJson.get("state");
                if(state != null){
                    state = state.replace("-", "_");
                }
                ret.setError(state, ResourceUtil.getString("workflow.action.takeback.msg" + state));
            }
            
            //调用处理器进行应用层校验
            if(ret.isHandResult()){
                String[] appCheck = handler.tackBackCheck(takeBackParam.getAppData());
                if(appCheck == null || appCheck.length < 2 || !"0".equals(appCheck[0])){
                    ret.setError(appCheck[0], appCheck[1]);
                }
            }
            
            //校验通过，进行处理
            if(ret.isHandResult()){
                
                //加锁
                String[] lockRet = processManager.lockWorkflowProcess(processId, currentUser.getId().toString(),
                        true, WorkflowLockActionEnum.TAKE_BACK.getCode());
                
                if("false".equals(lockRet[0])){
                    ret.setError(lockRet[1]);
                }else{
                    
                    try {
                        
                      //触发事件
                        String eventMsg = null;
                        WorkflowBpmContext eventContext = null;
                        
                        //TODO 这里没有实现
                        if((eventContext = handler.getEventContext(takeBackParam.getAppData())) != null){
                            eventMsg = WFAjax.executeWorkflowBeforeEvent(WorkflowEventEnum.BeforeTakeBack.name(), eventContext);
                        }
                        if(Strings.isNotBlank(eventMsg)){
                            ret.setError(eventMsg);
                        }else{
                            
                            //if (handler != null) {
                                String[] exeRet = handler.transTackBack(takeBackParam.getAppData());
                                if(exeRet == null || exeRet.length < 2 || !"0".equals(exeRet[0])){
                                    ret.setError(exeRet[0], exeRet[1]);
                                }
                            //}
                        }
                    }finally{
                        //解锁
                        releaseWorkFlowProcessLock(processId, currentUser.getId().toString());
                    }
                }
            }
        }else{
            ret.setError("Does not find handler for app " + appName);
        }
        
        return ret;
    }
    
    @Override
    public SeeyonBPMHandResult transSpecifyBack(SeeyonBPMHandParam4SpecifyBack backParam) throws BusinessException {

        SeeyonBPMHandResult ret = new SeeyonBPMHandResult();
        String appName = backParam.getAppName();
        
        SeeyonBPMAppHandler handler = SeeyonBPMManager.getBPMHandler(appName);
        
        if(handler != null){
            
            V3xOrgMember currentUser = backParam.getCurrentUser();
            String workitemId = backParam.getWorkitemId();
            String stepbackStyle = backParam.getStepbackStyle();
            String targetNodeId = backParam.getTargetNodeId();
            Long itemId = Long.valueOf(workitemId);
            
            WorkItem item = workItemManager.getWorkItemOrHistory(itemId);
            if(item == null)
                throw new BusinessException("Invalid workitemId " + workitemId);
            
          //数据预处理
            if(ret.isHandResult()){
                
                String[] preRet =  handler.preSpecifyBack(backParam.getAppData(), itemId);
                if(preRet == null || preRet.length < 2 || !"0".equals(preRet[0])){
                    ret.setError(preRet[0], preRet[1]);
                    return ret;
                }
            }
            
            
            String processId = item.getProcessId();
            Long caseId = item.getCaseId();
            String currentSelectedNodeId = item.getActivityId();
            
            //流程校验
            String[] checkBack = WFAjax.canSpecialStepBack(workitemId);
            if("false".equals(checkBack[0])){
                ret.setError(checkBack[1]);
            }
            
            BPMProcess process = processManager.getRunningProcess(processId);
            BPMCase theCase = caseManager.getCase(caseId);
            BPMActivity targetNode = process.getActivityById(targetNodeId);
            
            //知会节点校验
            if(ret.isHandResult()){
                if(WorkflowUtil.isInformNode(targetNode)){//知会节点
                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert9"));
                }else if(WorkflowUtil.isBlankNode(targetNode)){//空节点
                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert9"));
                }
            }

            //加锁
            if(ret.isHandResult()){
                String[] lockRet = WFAjax.lockWorkflow(processId, currentUser.getId().toString(), 
                        WorkflowLockActionEnum.SPECIFIES_RETURN.getCode());
                if("false".equals(lockRet[0])){
                    ret.setError(lockRet[1]);
                }else{
                    
                    try {
                        
                        String[] validBack = WFAjax.validateCurrentSelectedNode(caseId.toString(), 
                                currentSelectedNodeId, "", targetNodeId, null, backParam.getPermissionAccount(), 
                                backParam.getConfigCategory(), processId);
                        
                        if("true".equals(validBack)){
                            String nodePolicyId = targetNode.getSeeyonPolicy().getId();
                            if("vouch".equals(nodePolicyId)){
                                ret.setError(ResourceUtil.getString("workflow.special.stepback.alert10"));
                            }else{
                                
                                int processState = processManager.getProcessState(processId, false);
                                int stepBackCount = 0;
                                Object stepBackAtt = theCase.getDataMap().get(ActionRunner.STEPBACK_COUNT);
                                if(stepBackAtt != null){
                                    stepBackCount = Integer.valueOf(stepBackAtt.toString());
                                }
                                
                                if(processState == ProcessStateEnum.processState.startNodeRego.ordinal()
                                        || processState == ProcessStateEnum.processState.startNodeTome.ordinal() 
                                        || processState == ProcessStateEnum.processState.humenNodeTome.ordinal() 
                                        || stepBackCount > 0){
                                    
                                    if("true".equals(validBack[2])
                                            || "true".equals(validBack[8])){
                                        
                                        //流程处于【直接提交给我】状态，当前节点只能进行【直接提交给我】的指定回退操作，但当前节点与被选择节点之间存在分支条件或子流程，
                                        //因此不能选择该节点进行指定回退操作！
                                        ret.setError("workflow.special.stepback.alert7");
                                    }else{
                                        //只能选择直接提交给我
                                        if(STEP_BACK_STYLE_REGO.equals(stepbackStyle)){
                                            ret.setError(ResourceUtil.getString("workflow.special.stepback.alert8"));
                                        }
                                    }
                                }else{
                                    if("true".equals(validBack[2])
                                            || "true".equals(validBack[8])){
                                        
                                        if(STEP_BACK_STYLE_TOME.equals(stepbackStyle)){
                                            //只能选择流程重走
                                            ret.setError(ResourceUtil.getString("workflow.special.stepback.label12"));
                                        }
                                    }
                                }
                            }
                        } else{
                          
                            if("true".equals(validBack[13])){
                                ret.setError(ResourceUtil.getString("workflow.validate.stepback.msg13"));
                            }else if("true".equals(validBack[12])){
                                ret.setError(ResourceUtil.getString("workflow.validate.stepback.msg4"));
                            }else if("true".equals(validBack[11])){
                                ret.setError(ResourceUtil.getString("workflow.special.stepback.alert11"));
                            }else{
                                
                                if("true".equals(validBack[3])){
                                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert1"));
                                } else if("true".equals(validBack[4])){
                                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert2"));
                                } else if("true".equals(validBack[5])){
                                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert3"));
                                } else if("true".equals(validBack[6])){
                                    if("true".equals(validBack[9])){
                                        ret.setError(ResourceUtil.getString("workflow.special.stepback.alert4"));
                                    }else {
                                        ret.setError(ResourceUtil.getString("workflow.special.stepback.alert5"));
                                    }
                                }else if("true".equals(validBack[7])){
                                    ret.setError(ResourceUtil.getString("workflow.special.stepback.alert6"));
                                }
                            }
                        }
                        
                        //应用层执行指定回退
                        if(ret.isHandResult()){
                            
                            String[] exeRet = handler.transSpecifyBack(backParam.getAppData(), targetNodeId, stepbackStyle);
                            if(exeRet == null || exeRet.length < 2 || !"0".equals(exeRet[0])){
                                ret.setError(exeRet[0], exeRet[1]);
                            }
                        }
                    } finally {
                      //解锁
                        releaseWorkFlowProcessLock(processId, currentUser.getId().toString());
                    }
                    
                }
            }
            
        }else{
            ret.setError("Does not find handler for app " + appName);
        }
        
        return ret;
    }
    
    @Override
    public SeeyonBPMHandResult transStepBack(SeeyonBPMHandParam4StepBack stepBackParam) throws BusinessException {

        SeeyonBPMHandResult ret = new SeeyonBPMHandResult();
        String appName = stepBackParam.getAppName();
        SeeyonBPMAppHandler handler = SeeyonBPMManager.getBPMHandler(appName);
        
        if(handler != null){
            
            V3xOrgMember currentUser = stepBackParam.getCurrentUser();
            String workitemId = stepBackParam.getWorkitemId();
            Long itemId = Long.valueOf(workitemId);
            
            WorkItem item = workItemManager.getWorkItemOrHistory(itemId);
            if(item == null)
                throw new BusinessException("Invalid workitemId " + workitemId);
            
            //数据预处理
            if(ret.isHandResult()){
                
                String[] preRet =  handler.preStepBack(stepBackParam.getAppData(), itemId);
                if(preRet == null || preRet.length < 2 || !"0".equals(preRet[0])){
                    ret.setError(preRet[0], preRet[1]);
                    return ret;
                }
            }
            
            //应用层校验
            if(ret.isHandResult()){
                String[] appCheck = handler.stepBackCheck(stepBackParam.getAppData());
                if(appCheck == null || appCheck.length < 2 || !"0".equals(appCheck[0])){
                    ret.setError(appCheck[0], appCheck[1]);
                }
            }
            
            //流程校验
            if(ret.isHandResult()){
                
                WorkflowBpmContext context = handler.getEventContext(stepBackParam.getAppData());
                if(context == null){
                    context = new WorkflowBpmContext();
                }
                
                String[] lockRet = WFAjax.lockWorkflowForStepBack(context, WorkflowLockActionEnum.STEP_BACK.getCode(), 
                        WorkflowEventEnum.BeforeStepBack.name(),
                        stepBackParam.getPermissionAccount(), 
                        stepBackParam.getConfigCategory());
                
                if("true".equals(lockRet[0])){
                    try {
                        
                        String[] exeRet = handler.transStepBack(stepBackParam.getAppData());
                        if(exeRet == null || exeRet.length < 2 || !"0".equals(exeRet[0])){
                            ret.setError(exeRet[0], exeRet[1]);
                        }
                        
                    } finally {
                      //解锁
                        releaseWorkFlowProcessLock(context.getProcessId(), currentUser.getId().toString());
                    }
                }else{
                    ret.setError(lockRet[1]);
                }
            }
        }else{
            ret.setError("Does not find handler for app " + appName);
        }
        return ret;
    }
    
    
    
    @Override
    public SeeyonBPMHandResult transStartProcess(SeeyonBPMHandParam4Start startParam) throws BusinessException {

        SeeyonBPMHandResult ret = new SeeyonBPMHandResult();
        String appName = startParam.getAppName();
        SeeyonBPMAppHandler handler = SeeyonBPMManager.getBPMHandler(appName);
        
        if(handler != null){
            
            //TODO 模版校验等公共处理进行校验
            
            //TODO... collaborationFormBindEventListener.achieveTaskType
            //TODO... WFAjax.executeWorkflowBeforeEvent BeforeStart
            
            //预发送
            Map<String, String> preRet = handler.preStartProcess(startParam.getAppData());
            
            String status = preRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_STATUS);
            
            if(Strings.isBlank(status) || !status.equals(SeeyonBPMAppHandler.BPM_RESPONSE_ERROR)){
                
                //公共流程逻辑:分支匹配和人员匹配处理
                if(startParam.getParam(SeeyonBPMAppHandler.BPM_REQUEST_CTPTEMPLATE) != null 
                        && !"1".equals(startParam.getStringParam(SeeyonBPMAppHandler.BPM_REQUEST_DRAFT))){//如果是模板流程，则进行分支匹配和人员匹配处理，否则直接发送
                   
                    String[] matchResult= doPersonAndConditionMatchForStartProcess(startParam.getAppData(), startParam);
                    if("true".equals(matchResult[0])){
                        startParam.getAppData().put(SeeyonBPMAppHandler.BPM_REQUEST_DRAFT, "1");
                    }else{
                        String conditionMatchResult= matchResult[1];
                        startParam.getAppData().put(SeeyonBPMAppHandler.BPM_REQUEST_NODECONDITION, conditionMatchResult);
                    }
                }
                
                //发送接口
                Map<String, String> startRet = handler.startProcess(startParam.getAppData());
                
                status = startRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_STATUS);
                if(Strings.isBlank(status) || !status.equals(SeeyonBPMAppHandler.BPM_RESPONSE_ERROR)){
                    
                    String processId= startRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_PROCESSID);
                    String subject= startRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_SUBJECT);
                    
                    List<Map<String,String>> workitems = workItemManager.getWorkItemList(processId, 7);
                    Map<String,Object> dataMap = new HashMap<String, Object>();
                    
                    dataMap.put(SeeyonBPMAppHandler.BPM_RESPONSE_PROCESSID, processId);
                    dataMap.put(SeeyonBPMAppHandler.BPM_RESPONSE_SUBJECT, subject);
                    dataMap.put(SeeyonBPMAppHandler.BPM_RESPONSE_WORKITEMS, workitems);
                    
                    ret.setSuccess();
                    ret.addResultData(SeeyonBPMAppHandler.BPM_RESPONSE_PROCESSID, processId);
                    ret.addResultData(SeeyonBPMAppHandler.BPM_RESPONSE_SUBJECT, subject);
                    ret.addResultData(SeeyonBPMAppHandler.BPM_RESPONSE_WORKITEMS, workitems);
                }else{
                    ret.setError(startRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_STATUS), 
                            startRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_ERRORMSG));
                }
                
            } else{
                ret.setError(preRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_STATUS), 
                        preRet.get(SeeyonBPMAppHandler.BPM_RESPONSE_ERRORMSG));
            }
        }else{
            ret.setError("Does not find handler for app " + appName);
        }
        
        return ret;
    }
    
    @Override
    public SeeyonBPMHandResult transFinishOrZcdb(SeeyonBPMHandParam4Deal dealParam) throws BusinessException {

        SeeyonBPMHandResult ret = new SeeyonBPMHandResult();
        String appName = dealParam.getAppName();
        SeeyonBPMAppHandler handler = SeeyonBPMManager.getBPMHandler(appName);
        
        if(handler != null){
            
            String workitemId = dealParam.getWorkitemId();
            Long itemId = Long.valueOf(workitemId);
            
            WorkItem item = workItemManager.getWorkItemOrHistory(itemId);
            if(item == null)
                throw new BusinessException("Invalid workitemId " + workitemId);
            
            
            //数据预处理
            if(ret.isHandResult()){
                
                String[] preRet = handler.preFinishAndZcdb(dealParam.getAppData(), itemId);
                if(preRet == null || preRet.length < 2 || !"0".equals(preRet[0])){
                    ret.setError(preRet[0], preRet[1]);
                    return ret;
                }
            }
            
            //应用层检查
            if(ret.isHandResult()){
                
                String[] appCheck = handler.beforFinishAndZcdb(dealParam.getAppData());
                if(appCheck == null || appCheck.length < 2 || !"0".equals(appCheck[0])){
                    ret.setError(appCheck[0], appCheck[1]);
                }
            }
            
            //事件
            if(ret.isHandResult()){
                
                WorkflowBpmContext eventContext = handler.getEventContext(dealParam.getAppData());
                if(eventContext != null){
                    eventContext.setMatchRequestToken(dealParam.getMatchRequestToken());
                    String eventMsg = WFAjax.executeWorkflowBeforeEvent(WorkflowEventEnum.BeforeFinishWorkitem.name(),
                            eventContext);
                    
                    if(Strings.isNotBlank(eventMsg)){
                        ret.setError(eventMsg);
                    }
                }
            }
            
            //预提交
            if(ret.isHandResult()){
                WorkflowBpmContext context = handler.getBeforeInvokeWorkFlowContext(dealParam.getAppData());
                if(context != null){
                    //设置缓存key
                    context.setMatchRequestToken(dealParam.getMatchRequestToken());
                    String[] matchResult = this.isPop(context);
                    if("true".equals(matchResult[0])){
                        ret.setError(ResourceUtil.getString("workflow.label.msg.branchSelect2")/*"流程处理需要进行分支选择， 请使用PC处理."*/);
                    }else{
                        //分支选择
                        String conditionMatchResult= matchResult[1];
                        dealParam.getAppData().put(SeeyonBPMAppHandler.BPM_REQUEST_NODECONDITION, conditionMatchResult);
                    }
                }
            }
            
            //预提交通过
            if(ret.isHandResult()){
                String[] exeRet = handler.transFinishAndZcdb(dealParam.getAppData());
                if(exeRet == null || exeRet.length < 2 || !"0".equals(exeRet[0])){
                    ret.setError(exeRet[0], exeRet[1]);
                }
            }
        }else{
            ret.setError("Does not find handler for app " + appName);
        }
        
        return ret;
    }
    
    /**
     * 为发起流程接口做人员和分支匹配
     * @param params 参数
     * @return 字符串数组
     * @throws BPMException 流程异常
     */
    private String[] doPersonAndConditionMatchForStartProcess(Map<String,Object> params,
            SeeyonBPMHandParam4Start startParam) throws BPMException {
        //选分支,选人的判断,isPop 为true则保存待发
        WorkflowBpmContext wfContext = new WorkflowBpmContext();
        wfContext.setProcessId(null);
        wfContext.setCaseId(-1L);
        wfContext.setCurrentActivityId(null);
        wfContext.setCurrentWorkitemId(-1L);
        Object masterId= params.get(SeeyonBPMAppHandler.BPM_REQUEST_MASTERID);
        if(null!=masterId){
            wfContext.setMastrid(String.valueOf(masterId));
            wfContext.setFormData(String.valueOf(masterId));
        }else{
            Object formData= params.get(SeeyonBPMAppHandler.BPM_REQUEST_APPDATA);
            if(null !=formData ){
                wfContext.setFormData(formData.toString());
            }
        }
        
        V3xOrgMember startMember = startParam.getCurrentUser();
        
        wfContext.setStartUserId(String.valueOf(startMember.getId()));
        wfContext.setCurrentUserId(String.valueOf(startMember.getId()));
        wfContext.setProcessTemplateId(startParam.getStringParam("processTemplateId"));
        
        String appName= startParam.getAppName();
        wfContext.setAppName(appName);
        wfContext.setStartAccountId(String.valueOf(startMember.getOrgAccountId()));
        wfContext.setCurrentAccountId(String.valueOf(startMember.getOrgAccountId()));
        String[] result= this.isPop(wfContext);
        
        logger.info("r0:=" + result[0] + ";r1:=" + result[1] + ";r2:=" + result[2]);
        
        return result;
    }
    public void reAtiveFlow(String processId,String caseId) {
        try {
            processManager.updateProcessState(processId, ProcessStateEnum.processState.running.ordinal());
            
            BPMCase theCase = caseManager.getCaseOrHistoryCaseByProcessId(processId);
            //theCase.setState(CaseInfo.STATE_RUNNING);
            caseManager.saveHistoryToRun(theCase);
            
        } catch (BPMException e) {
            logger.error("", e);
        }
    }
    public String[] activeNextNode4SeDevelop(WorkflowBpmContext context) throws BPMException{
        
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        
        return engine.activeNextNode4SeDevelop(context);
        
    }
}