<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<html>
<head>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%-- 测试工作流操作页面 --%></title>
</head>
<body style="height: 100%;width: 100%">
<form id="form" name="form" action="<c:url value='/workflow/designer.do?method=doWorkItemFinish'/>" method="post">
<input type="hidden" id="process_xml" name="process_xml" value="">
<input type="hidden" id="processId" name="processId" value="">
<input type="hidden" id="caseId" name="caseId" value="">
<input type="hidden" id="workitemId" name="workitemId" value="">
<input type="hidden" id="nodeId" name="nodeId" value="">
<input type="hidden" id="readyObjectJSON" name="baseReadyObjectJSON" value="">
<input type="hidden" id="process_message_data" name="process_message_data" value="">
<input type="hidden" name="workflow_newflow_input" id="workflow_newflow_input">
<input type="hidden" name="workflow_node_peoples_input" id="workflow_node_peoples_input">
<input type="hidden" name="workflow_node_condition_input" id="workflow_node_condition_input">
<input type="hidden" name="currentUserId" id="currentUserId" value="<%=AppContext.getCurrentUser().getId()%>">
<input type="hidden" name="currentAccountId" id="currentAccountId" value="<%=AppContext.currentAccountId()%>">
<input type="hidden" name="appName" id="appName" value="collaboration">
<table width="100%" height="100%" border="0">
<tr height="100%">
<td width="80%" height="100%" valign="top">
<iframe id="workflowDesignerIframe" height="580" width="100%"></iframe>
</td>
<td width="20%" height="100%" valign="top">
    <table width="100%" border="0">
        <tr>
            <td align="center">操作</td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collAddNode('1')">加签</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collInformNode()">知会</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collAssignNode()">当前会签</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:multistageSignTest()">多级会签(公文)</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:passReadTest()">传阅(公文)</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collDeleteNode()">减签</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:doSign()">提交</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collStepBack()">回退</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collCanTakeNode()">是否允许回收？</a></td>
        </tr>
        <tr>
            <td align="center"><a href="javascript:collCanRepeal()">是否允许撤销？</a></td>
        </tr>
    </table>
</td>
</tr>
</table>
</form>
<script type="text/javascript">
var processId, caseId, workitemId, nodeId, performer, defaultPolicyId, accountId;
if(window.dialogArguments){
    param = window.dialogArguments;
    processId = param.processId;
    caseId = param.caseId;
    workitemId = param.workitemId;
    nodeId = param.nodeId;
    performer = param.performer;
    defaultPolicyId = "collaboration";
    accountId = param.currentAccountId;
    $("#processId").val(processId);
    $("#workitemId").val(workitemId);
    $("#caseId").val(caseId);
    $("#nodeId").val(nodeId);
    $("#workflowDesignerIframe").attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=3&processId='/>"+processId + "&caseId=" + caseId);
}
function collDeleteNode(){
    deleteNode(workitemId, processId, nodeId, performer, caseId)
}
function collAddNode(changeType){
    insertNode(workitemId, processId, nodeId, performer, caseId, "collaboration", false, defaultPolicyId, accountId);
}
function collStepBack(){
    stepBack(workitemId, processId, nodeId, performer,caseId)
}
function collInformNode(){
    informNode(workitemId, processId, nodeId, performer, caseId, "collaboration", false, defaultPolicyId, accountId);
}
function collAssignNode(){
    assignNode(workitemId, processId, nodeId, performer, caseId, "collaboration", false, defaultPolicyId, accountId);
}
function collCanTakeNode(){
    var result = $.toJSON(canTakeBack(workitemId, processId, nodeId, performer, caseId, "collaboration", false));
    alert(result);
}
function collCanRepeal(){
    var result = $.toJSON(canRepeal(workitemId, processId, nodeId, performer, caseId, "collaboration", false));
    alert(result);
}
function refreshWorkflow(obj){
  var iframeObj = $("#workflowDesignerIframe");
  if(iframeObj!=null){
      var oldSrc = iframeObj.prop("src");
      newSrc = oldSrc + "&newDate="+new Date().getTime();
      iframeObj.prop("src", newSrc);
      iframeObj = null;
  }
  //alert(obj.type+"-"+obj.currentNodeId+"-"+obj.names.join(","));
}

function doSign(){
  //debugger;
  var workitemId= $("#workitemId").attr("value");
  var processId= $("#process_id").attr("value");
  var caseId= $("#caseId").attr("value");
  var activityId= $("#nodeId").attr("value");
  var processXml= $("#process_xml").attr("value");
  preSendOrHandleWorkflow(window,workitemId,"-1",processId,activityId,
      '<%=AppContext.getCurrentUser().getId() %>',caseId,'<%=AppContext.getCurrentUser().getAccountId() %>',
      '',"collaboration",processXml);
}

function multistageSignTest(){
  var workitemId= $("#workitemId").attr("value");
  var processId= $("#processId").attr("value");
  var caseId= $("#caseId").attr("value");
  var activityId= $("#nodeId").attr("value");
  multistageSign(
      "edoc",
      "-1",
      "-1",
      "-1",
      workitemId,
      processId,
      activityId,
      "<%=AppContext.getCurrentUser().getId() %>",
      "<%=AppContext.getCurrentUser().getName() %>",
      "<%=AppContext.getCurrentUser().getLoginAccount() %>",
      "<%=AppContext.getCurrentUser().getLoginAccount() %>"
      );
}

function passReadTest(){
  passRead(workitemId, processId, nodeId, performer,"edoc",accountId,"-1","-1","-1");
}

/**
 * 测试用
 */
 $.content.callback.workflowFinish= function(){
   document.getElementById("form").submit();
 }
</script>
</body>
</html>