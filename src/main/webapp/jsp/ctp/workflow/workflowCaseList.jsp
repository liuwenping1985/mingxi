<%--
/**
 * $Author: wangchw $
 * $Rev: 7587 $
 * $Date:: 2012-11-15 21:37:00#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="workflowDesigner_js_api.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.designer.title')}</title>
</head>
<body>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
<tr>
    <th>序号</th>
    <th>实例标识</th>
    <th>状态</th>
    <th>实例操作</th>
</tr>
<c:forEach items="${list }" var="t" varStatus="status">
<tr>
    <td>${ status.index}</td>
    <td>${t.caseId}</td>
    <td>
        <c:choose>
            <c:when test="${t.state== 2 }">运行(${t.state })</c:when>
            <c:when test="${t.state== 3 }">完成(${t.state })</c:when>
            <c:when test="${t.state== 4 }">取消(${t.state })</c:when>
            <c:when test="${t.state== 5 }">挂起(${t.state })</c:when>
            <c:when test="${t.state== 6 }">终止(${t.state })</c:when>
            <c:otherwise>未知(${t.state })</c:otherwise>
        </c:choose>
    </td>
    <td>
    <a href='javascript:showDiagram("${t.caseId}","${t.processId}");'>[查看]</a>
    <a href='javascript:showDiagram1("${t.caseId}","${t.processId}");'>[弹出查看]</a><br/>
    <a href='javascript:superviousDiagram("${t.caseId}","${t.processId}");'>[督办]</a>
    <a href='javascript:superviousDiagram1("${t.caseId}","${t.processId}");'>[弹出督办]</a><br/>
    <a href='javascript:adminDiagram("${t.caseId}","${t.processId}");'>[管控]</a>
    <a href='javascript:adminDiagram1("${t.caseId}","${t.processId}");'>[弹出管控]</a></br>
    <a href='javascript:editDiagram1("${t.caseId}","${t.processId}");'>[已发流程编辑]</a></br>
    <a href='javascript:showDiagram2("${t.caseId}","${t.processId}");'>[已发/督办流程图查看]</a>
    </td>
    <td><a href='javascript:showWorkitemList("${t.caseId}","${t.processId}");'>处理</a></td>
</tr> 
</c:forEach>
</table>
</body>
</html>
<script>
var isTemplate = ${isTemplate};
function showDiagram(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=3&processId='/>"+processId+"&caseId="+caseId+"&isTemplate="+isTemplate); 
}

function editDiagram1(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  editWFCDiagram(window.parent,caseId,processId,window.parent,"collaboration");
}

function showDiagram1(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  showWFCDiagram(window.parent,caseId,processId,isTemplate,false);
}



function showDiagram2(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  showWFCDiagram(window.parent,caseId,processId,isTemplate,true,null,null,"collaboration");
}

function superviousDiagram(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=4&showHastenButton=false&processId='/>"+processId+"&caseId="+caseId+"&isTemplate="+isTemplate); 
}

function superviousDiagram1(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  superviousWFCDiagram(window.parent,caseId,processId,isTemplate,window.parent,"collaboration");
}

function adminDiagram(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=5&processId='/>"+processId+"&caseId="+caseId+"&isTemplate="+isTemplate); 
}

function adminDiagram1(caseId,processId){
  var process_id= $("#process_id",window.parent.document)[0];
  if(process_id.value!=processId){
    var parent_process_xml= $("#process_xml",window.parent.document)[0];
    if(parent_process_xml && parent_process_xml.value && parent_process_xml.value!=''){
      parent_process_xml.value= "";
    }
    $("#process_id",window.parent.document)[0].value= processId;
  }
  adminWFCDiagram(window.parent,caseId,processId,isTemplate,window.parent,"collaboration",repealWorkflowFn1,stopWorkflowFn1);
}

function repealWorkflowFn1(tWindow,caseId,processId,isTemplate,vWindow,appName,dialog){
  alert("请结合协同应用进行测试!");
  dialog.close();
}

function stopWorkflowFn1(tWindow,caseId,processId,isTemplate,vWindow,appName,dialog){
  alert("请结合协同应用进行测试!");
  dialog.close();
}

/**
 * 显示任务事项
 */
function showWorkitemList(caseId,processId){
  $("#iframeright",parent.document.body).attr("src","<c:url value='/workflow/designer.do?method=showWorkitemList&caseId='/>"+caseId+"&processId="+processId+"&isTemplate="+isTemplate); 
  //parent.window.location.href= "<c:url value='/workflow/designer.do?method=showWorkitemList&caseId='/>"+caseId+"&processId="+processId;
}
</script>
