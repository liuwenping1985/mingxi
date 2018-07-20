<%--
/**
 * $Author: wangchw $
 * $Rev: 10893 $
 * $Date:: 2012-12-28 16:50:52#$:
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
<script type="text/javascript" src="<c:url value='/common/SelectPeople/js/orgDataCenter.js' />"></script>
<script type="text/javascript" src="<c:url value='/ajax.do?managerName=selectPeopleManager' />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.designer.title')}</title>
</head>
<body>
<form name="form" id="form" action="<c:url value='/workflow/designer.do?method=sendWorkFlow'/>" method="post">
<input type="hidden" name="workflow_newflow_input" id="workflow_newflow_input">
<input type="hidden" name="workflow_node_peoples_input" id="workflow_node_peoples_input">
<input type="hidden" name="workflow_node_condition_input" id="workflow_node_condition_input">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:createTemplate();">新建流程</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
调用流程模版:<select id="processTemplateId" name="processTemplateId">
    <option value="">--请选择流程模版--</option>
    <c:forEach items="${templates }" var="t">
        <option value="${t.id }">${t.processName }</option>
    </c:forEach>
</select>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
    <th align="right">流程模版名称</th>
    <td align="left"><input type="text" id="process_name" name="process_name" value=""></td>
    <th align="right">描述格式</th>
    <td align="left"><input type="text" id="process_desc_by" name="process_desc_by" value="" readonly="readonly"></td>
</tr>
<tr>
    <th align="right">选人信息</th>
    <td align="left" colspan="3" onclick="createProcessXml('coll',window,window)"><input type="text" id="workFlowContent"/></td>
</tr>
<tr>
    <th align="right">流程信息</th>
    <td align="left" colspan="3" onclick=""><textarea type="text" id="process_info" name="process_info" value="" readonly="readonly"></textarea></td>
</tr>
<!-- 
<tr>
    <th align="right">流程规则内容</th>
    <td align="left" colspan="3"><textarea type="text" id="process_rulecontent" name="process_rulecontent" value="" readonly="readonly"></textarea></td>
</tr>
 -->
<tr>
    <th align="right">子流程触发设置</th>
    <td align="left" colspan="3"><textarea id="process_subsetting" name="process_subsetting" value="" readonly="readonly"></textarea></td>
</tr>
<tr>
    <th align="right">流程模版定义xml内容</th>
    <td align="left" colspan="3"><textarea cols="100" rows="10" id="process_xml" name="process_xml" value="" readonly="readonly"></textarea></td>
</tr>
</table>
<table align="center">
    <tr>
        <td>
        <input type="button" value="发送" onclick="sendWorkFlow();">
        </td>
        <td>
        <input type="button" value="取消" onclick="cancelWorkFlowTempalte();">
        </td>
    </tr>
</table>
</form>
</body>
</html>
<script>
function createTemplate(){
  <c:choose>
  <c:when test="${form == 'form' }">
  createWFTemplate(window,'collaboration','1','1','');
  </c:when>
  <c:when test="${form == 'person' }">
  createWFPersonal(window,'collaboration','currentUserId','currentUserName','currentUserAccountName');
  </c:when>
  <c:otherwise>
  /* createWFTemplate(window,'collaboration','','',''); */
  createWFPersonal(window,'collaboration','currentUserId','发起者','currentUserAccountName','',window,'','');
  </c:otherwise>
  </c:choose>
}

function sendWorkFlow(){
  var process_xml= $("#process_xml")[0].value;
  var processTemplateId= $("#processTemplateId")[0].value;
  var processId= "";
  if(process_xml=='' && processTemplateId==''){
    showFlashAlert("请新建流程或选择流程模版，再发送！");
  }else{
    if( processTemplateId != '' ){
      preSendOrHandleWorkflow(window,"-1",processTemplateId,"-1","start","<%=AppContext.getCurrentUser().getId()%>","-1","<%=AppContext.getCurrentUser().getAccountId()%>","",
          "collaboration","");
    }else if( process_xml != '' ){
      preSendOrHandleWorkflow(window,"-1","-1","-1","start","<%=AppContext.getCurrentUser().getId()%>","-1","<%=AppContext.getCurrentUser().getAccountId()%>","",
          "collaboration",process_xml);
    }else if( processId != '' ){
      preSendOrHandleWorkflow(window,"-1","-1",processId,"start","<%=AppContext.getCurrentUser().getId()%>","-1","<%=AppContext.getCurrentUser().getAccountId()%>","",
          "collaboration","");
    }
    
  }
}

$.content.callback.workflowNew= function(){
  document.getElementById("form").submit();
}

function cancelWorkFlowTempalte(){
  window.location.href= "<c:url value='/workflow/designer.do'/>";
}
</script>
