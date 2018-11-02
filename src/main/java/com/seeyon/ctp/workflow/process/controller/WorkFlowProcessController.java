//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.workflow.process.controller;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.workflow.designer.WorkFlowBaseController;
import com.seeyon.ctp.workflow.designer.manager.WorkFlowDesignerManager;
import com.seeyon.ctp.workflow.manager.ProcessManager;
import com.seeyon.ctp.workflow.manager.ProcessOrgManager;
import com.seeyon.ctp.workflow.process.manager.WorkFlowProcessManager;
import com.seeyon.ctp.workflow.vo.NodeAuthorityVO;
import com.seeyon.ctp.workflow.vo.NodeDeadlineTimeVO;
import com.seeyon.ctp.workflow.vo.WFMoreSignSelectPerson;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.engine.wapi.ProcessEngine;
import net.joinwork.bpm.engine.wapi.WAPIFactory;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class WorkFlowProcessController extends WorkFlowBaseController {
    private static final Log logger = LogFactory.getLog(WorkFlowProcessController.class);
    private WorkflowApiManager wapi;
    private WorkFlowProcessManager workFlowProcessManager;
    private ProcessOrgManager processOrgManager;
    private WorkFlowDesignerManager workFlowDesignerManager;
    private ProcessManager processManager;

    public WorkFlowProcessController() {
    }

    public void setWorkFlowDesignerManager(WorkFlowDesignerManager workFlowDesignerManager) {
        this.workFlowDesignerManager = workFlowDesignerManager;
    }

    public void setProcessOrgManager(ProcessOrgManager processOrgManager) {
        this.processOrgManager = processOrgManager;
    }

    public WorkflowApiManager getWapi() {
        return this.wapi;
    }

    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public WorkFlowProcessManager getWorkFlowProcessManager() {
        return this.workFlowProcessManager;
    }

    public void setWorkFlowProcessManager(WorkFlowProcessManager workFlowProcessManager) {
        this.workFlowProcessManager = workFlowProcessManager;
    }

    public void setProcessManager(ProcessManager processManager) {
        this.processManager = processManager;
    }

    public ModelAndView preStepBack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreStepBack");
        String processId = request.getParameter("processId");
        String nodeId = request.getParameter("nodeId");
        List<Map<String, String>> nodes = this.workFlowProcessManager.getAllParentNodes(processId, nodeId);
        mav.addObject("nodes", nodes);
        return mav;
    }

    public ModelAndView preAssignNode(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreAssignNode");
        String appName = ReqUtil.getString(request, "appName", ApplicationCategoryEnum.collaboration.name());
        String isForm = ReqUtil.getString(request, "isForm", "false");
        if ("true".equals(isForm)) {
            appName = "form";
        }

        String defaultPolicyId = ReqUtil.getString(request, "defaultPolicyId", ApplicationCategoryEnum.collaboration.name());
        String accountId = ReqUtil.getString(request, "accountId", String.valueOf(AppContext.currentAccountId()));
        String nodeId = request.getParameter("nodeId");
        List<NodeAuthorityVO> policyList = this.workFlowDesignerManager.getNodeAuthorityList(appName, defaultPolicyId, accountId, nodeId, false, true);
        NodeAuthorityVO policy = null;
        if (policyList != null && policyList.size() > 0) {
            Iterator var11 = policyList.iterator();

            while(var11.hasNext()) {
                NodeAuthorityVO vo = (NodeAuthorityVO)var11.next();
                if (vo.getValue().equals(defaultPolicyId)) {
                    policy = vo;
                    break;
                }
            }
        }

        if (policy == null) {
            policy = new NodeAuthorityVO();
            policy.setName(ResourceUtil.getString("workflow.createProcessXml.nodePolicy_Collaboration"));
            policy.setValue("collaboration");
        }

        String type = "2";
        if (ApplicationCategoryEnum.edocRec.name().equals(appName) || ApplicationCategoryEnum.edocSend.name().equals(appName) || ApplicationCategoryEnum.edocSign.name().equals(appName) || "sendEdoc".equals(appName) || "recEdoc".equals(appName) || "signReport".equals(appName)) {
            type = "1";
        }

        mav.addObject("appName", appName);
        mav.addObject("policy", policy);
        mav.addObject("type", type);
        return mav;
    }

    public ModelAndView preAddNodeToDiagram(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPreAddNodeToDiagram");
        String appName = ReqUtil.getString(request, "appName", ApplicationCategoryEnum.collaboration.name());
        String defaultPolicyId = ReqUtil.getString(request, "defaultPolicyId", ApplicationCategoryEnum.collaboration.name());
        String accountId = ReqUtil.getString(request, "accountId", String.valueOf(AppContext.currentAccountId()));
        boolean isForm = ReqUtil.getBoolean(request, "isForm", false);
        if (isForm) {
            appName = ApplicationCategoryEnum.form.name();
        }

        String nodeId = ReqUtil.getString(request, "nodeId", (String)null);
        Long caseId = ReqUtil.getLong(request, "caseId", -1L);
        List<NodeDeadlineTimeVO> nodeDeadlineTimeList = this.workFlowDesignerManager.getNodeDeadlineTimeList(appName, caseId);
        String isTemplete = ReqUtil.getString(request, "isTemplete", "false");
        boolean isTempleteFlag = "true".equals(isTemplete);
        List<NodeAuthorityVO> policyList = this.workFlowDesignerManager.getNodeAuthorityList(appName, defaultPolicyId, accountId, nodeId, true, isTempleteFlag);
        mav.addObject("appName", appName);
        mav.addObject("policyList", policyList);
        mav.addObject("defaultPolicyId", defaultPolicyId);
        mav.addObject("nodeDeadlineTimeList", nodeDeadlineTimeList);
        Date d = new Date(System.currentTimeMillis());
        mav.addObject("defaultCustomDealTerm", Datetimes.format(d, "yyyy-MM-dd HH:mm"));
        String processId = ReqUtil.getString(request, "processId", (String)null);
        boolean isFormReadonly = this.wapi.isNodeFormReadonly(nodeId, processId);
        mav.addObject("isFormReadonly", isFormReadonly);
        return mav;
    }

    public ModelAndView prePreDeleteNodeFromDiagram(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("ctp/workflow/workflowPrePreDeleteNodeFromDiagram");
        return mav;
    }

    public ModelAndView preDeleteNodeFromDiagram(HttpServletRequest request, HttpServletResponse response) throws Exception {
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

    public ModelAndView preAddMoreSign(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String selObj = request.getParameter("selObj");
        String appName = request.getParameter("appName");
        String flowPermAccountId = request.getParameter("flowPermAccountId");
        String nodeId = request.getParameter("nodeId");
        ModelAndView mv = new ModelAndView("ctp/workflow/workflowAddMoreSignSelect");
        List<WFMoreSignSelectPerson> msps = this.processOrgManager.findMoreSignPersons(selObj);
        mv.addObject("msps", msps);
        List<NodeAuthorityVO> nodePolicyList = this.workFlowDesignerManager.getNodeAuthorityList(appName, "", flowPermAccountId, nodeId, true, true);
        mv.addObject("nodePolicyList", nodePolicyList);
        return mv;
    }
}
