/**
 * $Author: zhoulj $
 * $Rev: 44172 $
 * $Date:: 2014-12-30 17:14:53#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.workflow.process.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.workflowmanage.manager.WorkflowManageManagerImpl;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.workflow.designer.WorkFlowBaseController;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowDesignerManager;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.manager.CaseManager;
import com.seeyon.ctp.workflow.manager.ProcessManager;
import com.seeyon.ctp.workflow.manager.ProcessOrgManager;
import com.seeyon.ctp.workflow.manager.WorkflowFormDataMapInvokeManager;
import com.seeyon.ctp.workflow.po.ProcessInRunningDAO;
import com.seeyon.ctp.workflow.process.manager.WorkFlowProcessManager;
import com.seeyon.ctp.workflow.util.WorkflowUtil;
import com.seeyon.ctp.workflow.vo.NodeAuthorityVO;
import com.seeyon.ctp.workflow.vo.NodeDeadlineTimeVO;
import com.seeyon.ctp.workflow.vo.WFMoreSignSelectPerson;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;

import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;

/**
 *
 * <p>Title: T4工作流</p>
 * <p>Description: 流程处理控制器类</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class WorkFlowProcessController extends WorkFlowBaseController {

    private final static Log logger = LogFactory.getLog(WorkFlowProcessController.class);

    private WorkflowApiManager wapi;

    private WorkFlowProcessManager workFlowProcessManager;

    private ProcessOrgManager processOrgManager;

    private WorkFlowDesignerManager workFlowDesignerManager;

    private ProcessManager processManager;

    /**
     * @param workFlowDesignerManager the workFlowDesignerManager to set
     */
    public void setWorkFlowDesignerManager(WorkFlowDesignerManager workFlowDesignerManager) {
        this.workFlowDesignerManager = workFlowDesignerManager;
    }

    /**
     * @param processOrgManager the processOrgManager to set
     */
    public void setProcessOrgManager(ProcessOrgManager processOrgManager) {
        this.processOrgManager = processOrgManager;
    }

    public WorkflowApiManager getWapi() {
        return wapi;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public WorkFlowProcessManager getWorkFlowProcessManager() {
        return workFlowProcessManager;
    }

    public void setWorkFlowProcessManager(WorkFlowProcessManager workFlowProcessManager) {
        this.workFlowProcessManager = workFlowProcessManager;
    }

    public void setProcessManager(ProcessManager processManager) {
		this.processManager = processManager;
	}

	/**
     * 预回退
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView preStepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreStepBack");
        String processId = request.getParameter("processId");
        String nodeId = request.getParameter("nodeId");
        List<Map<String, String>> nodes = workFlowProcessManager.getAllParentNodes(processId, nodeId);
        mav.addObject("nodes", nodes);
        return mav;
    }

    /**
     * 预会签
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView preAssignNode(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreAssignNode");
        String appName = ReqUtil.getString(request, "appName", ApplicationCategoryEnum.collaboration.name());
        String isForm= ReqUtil.getString(request, "isForm", "false");
        if("true".equals(isForm)){
            appName= "form";
        }
        String defaultPolicyId = ReqUtil.getString(request, "defaultPolicyId", ApplicationCategoryEnum.collaboration.name());
        String accountId = ReqUtil.getString(request, "accountId", String.valueOf(AppContext.currentAccountId()));
        String nodeId= request.getParameter("nodeId");
        List<NodeAuthorityVO> policyList = workFlowDesignerManager.getNodeAuthorityList(appName, defaultPolicyId,
                accountId, nodeId,false,true);
        NodeAuthorityVO policy = null;
        if(policyList!=null && policyList.size()>0){
            for(NodeAuthorityVO vo : policyList){
                if(vo.getValue().equals(defaultPolicyId)){
                    policy = vo;
                    break;
                }
            }
        }
        if(policy==null){
            policy = new NodeAuthorityVO();
            policy.setName("协同");
            policy.setValue("collaboration");
        }
        String type="2";
        if(ApplicationCategoryEnum.edocRec.name().equals(appName)
                || ApplicationCategoryEnum.edocSend.name().equals(appName)
                || ApplicationCategoryEnum.edocSign.name().equals(appName)
                || "sendEdoc".equals(appName) 
                || "recEdoc".equals(appName)
                || "signReport".equals(appName)){//公文种类较多，兼容处理下
        	type="1";
        }
        mav.addObject("appName", appName);
        mav.addObject("policy", policy);
        mav.addObject("type", type);
        return mav;
    } 
    
    /**
     * 预加签
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView preAddNodeToDiagram(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreAddNodeToDiagram");
        String appName = ReqUtil.getString(request, "appName", ApplicationCategoryEnum.collaboration.name());
        String defaultPolicyId = ReqUtil.getString(request, "defaultPolicyId", ApplicationCategoryEnum.collaboration.name());
        String accountId = ReqUtil.getString(request, "accountId", String.valueOf(AppContext.currentAccountId()));
        boolean isForm = ReqUtil.getBoolean(request, "isForm", false);
        if(isForm){
            appName = ApplicationCategoryEnum.form.name();
        }
        String nodeId= ReqUtil.getString(request, "nodeId", null);
        Long caseId = ReqUtil.getLong(request, "caseId", -1L);
        //节点处理期限列表
        List<NodeDeadlineTimeVO> nodeDeadlineTimeList = workFlowDesignerManager
                .getNodeDeadlineTimeList(appName, caseId);
        //节点提前提醒时间列表
        String isTemplete= ReqUtil.getString(request, "isTemplete", "false");
        boolean isTempleteFlag= "true".equals(isTemplete);
        List<NodeAuthorityVO> policyList = workFlowDesignerManager.getNodeAuthorityList(appName, defaultPolicyId, accountId, nodeId,true,isTempleteFlag);
        mav.addObject("appName", appName);
        mav.addObject("policyList", policyList);
        mav.addObject("defaultPolicyId", defaultPolicyId);
        mav.addObject("nodeDeadlineTimeList", nodeDeadlineTimeList);
        Date d = new Date(System.currentTimeMillis());
        mav.addObject("defaultCustomDealTerm", Datetimes.format(d, "yyyy-MM-dd HH:mm"));
        String processId = ReqUtil.getString(request, "processId", null);
        
        //客开 gxy 20180723 只显示本流程内的节点名称 start
    	try{
			String result[] = workFlowDesignerManager.getProcessXml(processId, "3", "false", appName, ((CaseManager)AppContext.getBean("caseManager")).getCase(caseId, false), false);
			String processXml = result[0];
			if(StringUtils.isNotBlank(processXml)){
				processXml = processXml.replaceAll("\\\\", "");
				Document doc = DocumentHelper.parseText(processXml);
				Element root = doc.getRootElement();
				List<Node> ns = root.selectNodes("p/n[@i!='start' and @i!='end' and @n!='split' and @n!='join']");
				Set<String> p = new HashSet<String>();
				for(Node n:ns){
					p.add(((Element)n.selectSingleNode("s[@i]")).attributeValue("i"));
				}
				List<NodeAuthorityVO> tempList = new ArrayList<NodeAuthorityVO>();
				for(NodeAuthorityVO o:policyList){
					if(p.contains(o.getValue())){
						tempList.add(o);
						if (o.getValue().equalsIgnoreCase("加签")){
							mav.addObject("jiaqian", "1");
						}
					}
				}
				mav.addObject("policyList", tempList);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
        //客开 gxy 20180723 只显示本流程内的节点名称 end
        
        boolean isFormReadonly = wapi.isNodeFormReadonly(nodeId, processId);
        mav.addObject("isFormReadonly", isFormReadonly);
        
        //客开 gxy start 绑定是否重定向参数
        String isChongdingxiang = request.getParameter("isChongdingxiang");
        mav.addObject("isChongdingxiang", isChongdingxiang);
        //客开 gxy end 绑定是否重定向参数
        
        return mav;
    }



    //客开 会商操作中的节点权限列表改为当前流程中所拥有的节点权限 start
    /**
     * 预会商
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView preAddNodeToDiagram1(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreAddNodeToDiagram1");
        String appName = ReqUtil.getString(request, "appName", ApplicationCategoryEnum.collaboration.name());
        String defaultPolicyId = ReqUtil.getString(request, "defaultPolicyId", ApplicationCategoryEnum.collaboration.name());
        String accountId = ReqUtil.getString(request, "accountId", String.valueOf(AppContext.currentAccountId()));
        boolean isForm = ReqUtil.getBoolean(request, "isForm", false);
        if(isForm){
            appName = ApplicationCategoryEnum.form.name();
        }
        String nodeId= ReqUtil.getString(request, "nodeId", null);
        Long caseId = ReqUtil.getLong(request, "caseId", -1L);
        //节点处理期限列表
        List<NodeDeadlineTimeVO> nodeDeadlineTimeList = workFlowDesignerManager
                .getNodeDeadlineTimeList(appName, caseId);
        //节点提前提醒时间列表
        String isTemplete= ReqUtil.getString(request, "isTemplete", "false");
        boolean isTempleteFlag= "true".equals(isTemplete);
        List<NodeAuthorityVO> policyList = workFlowDesignerManager.getNodeAuthorityList(appName, defaultPolicyId, accountId, nodeId,true,isTempleteFlag);
        mav.addObject("appName", appName);
        mav.addObject("policyList", policyList);
        mav.addObject("huishang", "0");
        mav.addObject("defaultPolicyId", defaultPolicyId);
        mav.addObject("nodeDeadlineTimeList", nodeDeadlineTimeList);
        Date d = new Date(System.currentTimeMillis());
        mav.addObject("defaultCustomDealTerm", DateUtil.getDate(d, "yyyy-MM-dd HH:mm"));
        String processId = ReqUtil.getString(request, "processId", null);
    	try{
    		String result[] = workFlowDesignerManager.getProcessXml(processId, "3", "false", appName, ((CaseManager)AppContext.getBean("caseManager")).getCase(caseId, false), false);
    		String processXml = result[0];
    		if(StringUtils.isNotBlank(processXml)){
    			processXml = processXml.replaceAll("\\\\", "");
    			Document doc = DocumentHelper.parseText(processXml);
    			Element root = doc.getRootElement();
    			List<Node> ns = root.selectNodes("p/n[@i!='start' and @i!='end' and @n!='split' and @n!='join']");
    			Set<String> p = new HashSet<String>();
    			for(Node n:ns){
    				p.add(((Element)n.selectSingleNode("s[@i]")).attributeValue("i"));
    			}
    			List<NodeAuthorityVO> tempList = new ArrayList<NodeAuthorityVO>();
    			for(NodeAuthorityVO o:policyList){
    				if(p.contains(o.getValue())){
    					tempList.add(o);
    					if (o.getValue().equalsIgnoreCase("会商")){
    						mav.addObject("huishang", "1");
    					}
    				}
    			}
    			mav.addObject("policyList", tempList);
    		}
    	}catch(Exception e){
    		e.printStackTrace();
    	}
        boolean isFormReadonly = wapi.isNodeFormReadonly(nodeId, processId);
        mav.addObject("isFormReadonly", isFormReadonly);
        return mav;
    }
    //客开 end



    /**
     * 预减签
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView prePreDeleteNodeFromDiagram(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPrePreDeleteNodeFromDiagram");
        return mav;
    }

    public ModelAndView preDeleteNodeFromDiagram(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        @SuppressWarnings("unchecked")
        Map<Object, Object> map = ParamUtil.getJsonParams();
        String processId = String.valueOf(map.get("processId"));
        String nodeId = String.valueOf(map.get("nodeId"));
        String processXML = String.valueOf(map.get("processXML"));
        ProcessEngine engine = WAPIFactory.getProcessEngine("Engine_1");
        List<BPMHumenActivity> activityList = engine.preDeleteNode(processId, nodeId, processXML);
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreDeleteNodeFromDiagram");
        mav.addObject("processId", processId);
        mav.addObject("nodeId", nodeId);
        mav.addObject("processXML", processXML);
        mav.addObject("activityList", activityList);
        return mav;
    }

    /**
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView preAddMoreSign(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String selObj = request.getParameter("selObj");
        String appName = request.getParameter("appName");
        String flowPermAccountId= request.getParameter("flowPermAccountId");
        String nodeId= request.getParameter("nodeId");
        ModelAndView mv = new ModelAndView("ctp/workflow/workflowAddMoreSignSelect");
        List<WFMoreSignSelectPerson> msps= processOrgManager.findMoreSignPersons(selObj);
        mv.addObject("msps",msps);
        List<NodeAuthorityVO> nodePolicyList= workFlowDesignerManager.getNodeAuthorityList(appName, "", flowPermAccountId,nodeId,true,true);
        mv.addObject("nodePolicyList",nodePolicyList);
        return mv;
    }
}
