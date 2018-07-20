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
<%@page import="net.joinwork.bpm.engine.wapi.WorkItem"%>
<%@page import="com.seeyon.ctp.workflow.engine.enums.ProcessStateEnum"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<script type="text/javascript" src="<c:url value='/common/SelectPeople/js/orgDataCenter.js${ctp:resSuffix()}' />"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager' />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.designer.title')}</title>
</head>
<body>
<form id="form" name="form" action="<c:url value='/workflow/designer.do?method=doWorkItemFinish'/>" method="post">
<input type="hidden" name="workflow_newflow_input" id="workflow_newflow_input">
<input type="hidden" name="workflow_node_peoples_input" id="workflow_node_peoples_input">
<input type="hidden" name="workflow_node_condition_input" id="workflow_node_condition_input">
<input type="hidden" name="caseId" id="caseId" value="${caseId }">
<input type="hidden" name="workitemId" id="workitemId" value="">
<input type="hidden" name="activityId" id="activityId" value="">
<input type="hidden" name="performer" id="performer" value="">
<input type="hidden" name="processId" id="processId" value="${processId }">
<input type="hidden" name="currentUserId" id="currentUserId" value="<%=AppContext.getCurrentUser().getId()%>">
<input type="hidden" name="currentAccountId" id="currentAccountId" value="<%=AppContext.currentAccountId()%>">
<input type="hidden" name="appName" id="appName" value="collaboration">
<table width="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
    <th>序号</th>
    <th>任务事项标识</th>
    <th>节点ID</th>
    <th>执行人员</th>
    <th>任务事项状态</th>
    <th>操作</th>
</tr>
<c:forEach items="${pedingList }" var="t" varStatus="status">
<tr>
    <td>${ status.index}</td>
    <td>${t.id}</td>
    <td>${t.activityId}</td>
    <td>${t.performer}</td>
    <td>${t.state}
    <c:choose>
        <c:when test="${ t.state==6}">
                         挂起
        </c:when>
        <c:when test="${ t.state==7}">
                        待办(正常)
        </c:when>
        <c:when test="${ t.state==40}">
                        待办(流程重走)
        </c:when>
        <c:when test="${ t.state==41}">
                        待办(提交给回退节点)
        </c:when>
        <c:otherwise>
                        未知状态
        </c:otherwise>
    </c:choose>
    </td>
    <td>
        <c:choose>
            <c:when test="${ t.state==6}">
                <input type="button" disabled="disabled" value="提交">
                <br/><a href="javascript:showOpreation('${t.id}','${t.processId }','${t.activityId }','${t.performer }','${t.caseId }')">操作</a>
                <br/><input type="button" disabled="disabled" value="回退">
                <br/><input type="button" disabled="disabled" value="指定回退">
            </c:when>
            <c:otherwise>
                <a href="javascript:doSign(window,'${t.id}','-1','${t.processId }','${t.activityId }','<%=AppContext.getCurrentUser().getId() %>','${t.caseId }','<%=AppContext.getCurrentUser().getAccountId() %>','','collaboration','',false)">提交</a>
                <br/><a href="javascript:showOpreation('${t.id}','${t.processId }','${t.activityId }','${t.performer }','${t.caseId }')">操作</a>
                <br/><a href="javascript:stepBackCommon('${t.id}','${t.processId }','${t.activityId }','${t.performer }','${t.caseId }')">回退</a>
                <br/><a href="javascript:stepBackToTargetNode1(window.top,window.top,'${t.id}','${t.processId }','${t.caseId }','${t.activityId }');">指定回退</a>
                <br/><a href="javascript:readWorkItem('${t.id}','${t.processId }','${t.caseId }');">读取</a>
            </c:otherwise>
        </c:choose>
            </td>
</tr> 
</c:forEach>
</table>
<br/>
<br/>
<%
   int state= request.getAttribute("state")==null?-1:Integer.parseInt(String.valueOf(request.getAttribute("state")));
   if(state== ProcessStateEnum.processState.startNodeTome.ordinal()){
%>
发起人(提交给上节点回退人):<a href="javascript:doSign(window,'-1','-1','${processId }','start','<%=AppContext.getCurrentUser().getId() %>','${caseId }','<%=AppContext.getCurrentUser().getAccountId() %>','','collaboration','',false)">提交</a>
<%
   }else if(state== ProcessStateEnum.processState.startNodeRego.ordinal()){
%>
发起人(流程重走):<a href="javascript:doSign(window,'-1','-1','${processId }','start','<%=AppContext.getCurrentUser().getId() %>','${caseId }','<%=AppContext.getCurrentUser().getAccountId() %>','','collaboration','',false)">提交</a>
<%
   }
%>
<!-- <table align="center">
    <tr>
        <td>
        <input type="button" value="取消" onclick="cancelWorkFlowTempalte();">
        </td>
    </tr>
</table> -->
</form>
</body>
</html>
<script>


function stepBackToTargetNode1(tWindow,vWindow,workitemId,processId,caseId,activityId){
  stepBackToTargetNode(tWindow,vWindow,workitemId,processId,caseId,activityId,stepBackToTargetNode1CallBackFn,true,true);
}

function stepBackToTargetNode1CallBackFn(workitemId,processId,caseId,activityId,theStepBackNodeId,submitStyle,falshDialog){
  //alert(workitemId+","+processId+","+caseId+","+activityId+","+theStepBackNodeId+","+submitStyle);  
  falshDialog.close();
  document.getElementById("form").action="<c:url value='/workflow/designer.do?method=stepBack'/>&workitemId="+workitemId
      +"&processId="+processId+"&caseId="+caseId+"&activityId="+activityId+"&theStepBackNodeId="+theStepBackNodeId+"&submitStyle="+submitStyle;
  document.getElementById("form").submit();
}


function doSign(tWindow,workitemId,processTemplateId,processId,activityId,performer,caseId,currentAccountId,formData,
    appName,processXml){
  $("#workitemId").attr("value",workitemId);
  $("#processId").attr("value",processId);
  $("#caseId").attr("value",caseId);
  preSendOrHandleWorkflow(tWindow,workitemId,processTemplateId,processId,activityId,performer,caseId,currentAccountId,formData,
      appName,processXml);
}



/**
 * 测试用
 */
 $.content.callback.workflowFinish= function(){
   document.getElementById("form").submit();
 }
 
 $.content.callback.workflowNew= function(){
   document.getElementById("form").action="<c:url value='/workflow/designer.do?method=sendWorkFlow'/>";
   document.getElementById("form").submit();
 }
 
function cancelWorkFlowTempalte(){
  window.location.href= "<c:url value='/workflow/designer.do'/>";
}

function showOpreation(workitemId,processId,nodeId,performer,caseId){
  var dialog = $.dialog({
    url : '<c:url value="/workflow/designer.do?method=showTestOperation"/>',
    transParams : {
      processId : processId
      ,caseId : caseId
      ,workitemId : workitemId
      ,nodeId : nodeId
      ,performer : performer
      ,currentAccountId : $("#currentAccountId").val()
    },
    width : 1024,
    height : 600,
    title : '流程处理页面 ',
    targetWindow: top,
    minParam:{show:false},
    maxParam:{show:false}
  });
}

function readWorkItem(workitemId,processId,caseId){
  $("#workitemId").attr("value",workitemId);
  $("#processId").attr("value",processId);
  $("#caseId").attr("value",caseId);
  document.getElementById("form").action="<c:url value='/workflow/designer.do?method=readWorkItem'/>";
  document.getElementById("form").submit();
}

function stepBackCommon(workitemId, processId, nodeId, performer, caseId){
  $("#workitemId").attr("value",workitemId);
  $("#processId").attr("value",processId);
  $("#caseId").attr("value",caseId);
  $("#activityId").attr("value",nodeId);
  $("#performer").attr("value",performer);
  stepBack(workitemId, processId, nodeId, performer,caseId,commonStepBack);
}

function commonStepBack(){
  document.getElementById("form").action="<c:url value='/workflow/designer.do?method=stepBack'/>";
  document.getElementById("form").submit();
}
</script>
