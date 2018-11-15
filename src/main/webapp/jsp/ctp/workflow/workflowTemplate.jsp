<%--
/**
 * $Author: wangchw $
 * $Rev: 28330 $
 * $Date:: 2013-08-12 19:48:30#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<script type="text/javascript" src="<c:url value='/common/SelectPeople/js/orgDataCenter.js${ctp:resSuffix()}' />"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager' />"></script>
<script type="text/javascript">
<!--
function getA8Top(){
  return top;
}
//-->
</script>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%--工作流流程图测试 --%></title>
<style>html,body{height:100%}</style>
</head>
<body class="h100b over_hidden">
<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2" height="5%">
  <input type="hidden" id="process_desc_by" name="process_desc_by" value="">
  <input type="hidden" id="process_xml" name="process_xml" value="">
  <input type="hidden" id="process_info" name="process_info" value="">
  <input type="hidden" id="process_rulecontent" name="process_rulecontent" value="">
  <input type="hidden" id="process_subsetting" name="process_subsetting" value="">
  <input type="hidden" id="process_id" name="process_id" value="">
  <input type="radio" name="workflowType" value="0" onclick="sendWorkFlow();">发送流程
  <input type="radio" name="workflowType" value="0" onclick="showWorkFlowTemplate();" checked="checked">流程模版列表
  <input type="radio" name="workflowType" value="1" onclick="showWorkFlowFormTemplate();">表单流程模版列表
  <input type="radio" name="workflowType" value="3" onclick="showWorkFlowCase();">流程实例列表
  <input type="radio" name="workflowType" value="7" onclick="showTemplateWorkFlowCase();">表单/模板流程实例列表
  <input type="radio" name="workflowType" value="4" onclick="showFormWorkFlowCreatePage();">新建表单模版流程
  <input type="radio" name="workflowType" value="5" onclick="showWorkFlowCreatePage();">新建协同模版流程
  <input type="radio" name="workflowType" value="8" onclick="showEdocWorkFlowCreatePage();">新建公文模版流程
  <input type="radio" name="workflowType" value="6" onclick="showPersonWorkFlowCreatePage();">新建个人模版流程
</td>
</tr>
<tr>
    <td width="40%" height="95%">
        <iframe id="iframeleft" src="<c:url value="/workflow/designer.do?method=showProcessTemplateList"/>" width="100%" height="100%"></iframe>
    </td>
    <td width="60%" height="95%">
        <iframe id="iframeright" src="about:blank" width="100%" height="100%"></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script>
function sendWorkFlow(){
  window.location.href= "<c:url value='/workflow/designer.do?method=showSendWorkflowPage'/>";
}

function showWorkFlowTemplate(){
  $('#iframeleft').attr("src","<c:url value='/workflow/designer.do?method=showProcessTemplateList'/>");
}
  
function showWorkFlowCase(){
  $('#iframeleft').attr("src","<c:url value='/workflow/designer.do?method=showProcessCaseList'/>");
} 

function showTemplateWorkFlowCase(){
  $('#iframeleft').attr("src","<c:url value='/workflow/designer.do?method=showProcessCaseList'/>&isTemplate=true");
}

function showWorkFlowFormTemplate(){
  $('#iframeleft').attr("src","<c:url value='/workflow/designer.do?method=showProcessTemplateList&form=true'/>");
}

function showWorkFlowCreatePage(){
  //$('#iframeright').attr("src","<c:url value='/workflow/designer.do?method=showProcessCreatePage'/>");
  window.location.href= "<c:url value='/workflow/designer.do?method=showProcessCreatePage'/>";
}

function showFormWorkFlowCreatePage(){
  //$('#iframeright').attr("src","<c:url value='/workflow/designer.do?method=showProcessCreatePage'/>");
  window.location.href= "<c:url value='/workflow/designer.do?method=showProcessCreatePage&from=form'/>";
}

function showEdocWorkFlowCreatePage(){
  window.location.href= "<c:url value='/workflow/designer.do?method=showProcessCreatePage&from=edoc'/>";
}

function showPersonWorkFlowCreatePage(){
  //$('#iframeright').attr("src","<c:url value='/workflow/designer.do?method=showProcessCreatePage'/>");
  window.location.href= "<c:url value='/workflow/designer.do?method=showProcessCreatePage&from=person'/>";
}
function hastenCallBack(){
  alert("hastenCallBack");
}
</script>