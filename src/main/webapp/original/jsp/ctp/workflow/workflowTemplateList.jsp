<%--
/**
 * $Author: zhoulj $
 * $Rev: 7326 $
 * $Date:: 2012-11-13 10:35:49#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.designer.title')}</title>
</head>
<body>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
    <th>序号</th>
    <th>标识</th>
    <c:if test="${isForm }">
    <th>表单Id</th>
    </c:if>
    <th>流程模版名称</th>
</tr>
<c:forEach items="${list }" var="t" varStatus="status">
<tr>
    <td>${ status.index}</td>
    <td>${t.id}</td>
    <c:if test="${isForm }">
    <td>${t.appId}</td>
    </c:if>
    <td>
    ${t.processName }<br/>
    <a href='javascript:showDiagram("${t.id}","${t.appId}");'>[查看]</a>
    <a href='javascript:showDiagram1("${t.id}","${t.appId}");'>[弹出查看]</a><br/>
    <a href='javascript:editDiagram("${t.id}","${t.appId}");'>[修改]</a>
    <a href='javascript:editDiagram1("${t.id}","${t.appId}");'>[弹出修改]</a><br/>
    <a href='javascript:copyTemplate("${t.id}","${t.appId}");'>[拷贝]</a>
    <a target="_blank" href='<c:url value="/workflow/cie.do?method=exportProcess"/>&templateId=${t.id}&appId=${t.appId}'>[导出]</a>
    </td>
</tr> 
</c:forEach>
</table>
</body>
</html>
<script>
function editDiagram(processId,formId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  <c:choose>
  <c:when test="${form == 'true' }">
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=0&processId='/>"+processId+"&formApp="+formId+"&formName=1"); 
  </c:when>
  <c:otherwise>
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=0&processId='/>"+processId); 
  </c:otherwise>
  </c:choose>
}

function editDiagram1(processId, formId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  <c:choose>
  <c:when test="${form == 'true' }">
  createWFTemplate(window.parent,"collaboration", formId,'1',processId);
  </c:when>
  <c:otherwise>
  createWFTemplate(window.parent,"collaboration", '','',processId);
  </c:otherwise>
  </c:choose>
}

function showDiagram(processId, formId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=2&processId='/>"+processId); 
}

function showDiagram1(processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  showWFTDiagram(window.parent,processId);
}
function copyTemplate(templateId){
	var result = window.confirm("确定拷贝？");
	if(result){
	    var wfAjax = new WFAjax();
	    var newId = wfAjax.cloneWorkflowTemplateById(templateId, 1);
	    alert("新的流程Id="+newId);
	    window.location.reload();
	}
}
function exportTemplate(templateId){
	
}
</script>
