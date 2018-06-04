<%--
 $Author: wangwy $
 $Rev: 13277 $
 $Date:: 2014-06-17 11:22:48#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<div id="workflow_definition" style="display: none">
    <%-- 流程描述信息，目前固定xml--%>
    <input type="hidden" id="process_desc_by">
    <input type="hidden" id="process_xml">
    <%-- 当前会签的时候，需要激活的节点--%>
    <input type="hidden" id="readyObjectJSON">
    <%--WORKFLOW_SEEYON,后台校验是否传递到后台，参数是否完整--%>
    <input type="hidden" id="workflow_data_flag" name="workflow_data_flag" value="WORKFLOW_SEEYON">
    <%--新建页面的input的人员信息--%>
    <input type="hidden" id="process_info">
    <%--暂无用处--%>
    <input type="hidden" id="process_info_selectvalue">
    <%--模板设计，绑定子流程信息--%>
    <input type="hidden" id="process_subsetting">
    <input type="hidden" id="moduleType" value='1' >
    <%--运行时候，选择的子流程信息--%>
    <input type="hidden" id="workflow_newflow_input">
    <%--流程说明--%>
    <input type="hidden" id="process_rulecontent"/>
    <%--运行时候:选人信息--%>
    <input type="hidden" id="workflow_node_peoples_input">
    <%--运行时候:选分支--%>
    <input type="hidden" id="workflow_node_condition_input">
    <input type="hidden" id="processId" value="${contentContext.wfProcessId==null?"" : contentContext.wfProcessId}">
    <input type="hidden" id="caseId" value="${contentContext.wfCaseId==null?"-1" : contentContext.wfCaseId}">
    <input type="hidden" id="subObjectId" value="${contentContext.wfItemId==null?"-1" : contentContext.wfItemId}">
    <input type="hidden" id="currentNodeId" value="${contentContext.wfActivityId==null?"start" : contentContext.wfActivityId}">
    <%--运行时候:流程加签、减签的日志--%>
    <input type="hidden" id="process_message_data">
    <%--运行时候:流程加签、减签数据--%>
    <input type="hidden" id="processChangeMessage">
    <%--运行时候:节点高级事件--%>
    <input type="hidden" id="process_event">
    <%--运行时候:指定回退提交的时候是否需要流程重走--%>
    <input type="hidden" id="toReGo">
    <%--运行时候:流程动态表单的表单数据Id--%>
    <input type="hidden" id="dynamicFormMasterIds">
</div>
<script type="text/javascript">
  $.content.getWorkflowDomains = function(moduleType, domains) {
    if (!domains)
      domains = [];
    $("#workflow_definition #moduleType").val(moduleType);
    domains.push("workflow_definition");
    return domains;
  };

</script>