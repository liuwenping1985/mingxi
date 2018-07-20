<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="govdocHeader.jsp"%>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function pageTaohongForm()
{
    window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
    
	if(getOcxState()!="complete")
	{
	  window.setTimeout("pageTaohongForm();",1000);	  
	  return;
	}
	var pw = null;	
	if(window.dialogArguments){
	    pw=window.dialogArguments
	}else if(transParams){
	    pw = transParams.parentWin;
	}
	var all_data = $(pw.componentDiv.zwIframe.document);
	govdoctaohongForm(all_data,pw.page_receivedObj,pw.page_templateType,pw.page_extendArray);
	//吧文单的标题设置进来，以便套红后正确读取标题 OA-50556
	var doc_subject = null;
	var all_data_filed = all_data.find("[id^=field]");
	for(var i = 0;i<all_data_filed.length;i++){
		var data = all_data_filed[i];
		if(data.getAttribute("mappingField") == "subject"){//找到标题
			doc_subject = data;
			break;
		}
	}
	if(null != doc_subject){
		document.getElementById("subject").value = doc_subject.value;
	}
}
</script>
</head>
<body style="scroll:no" onload="pageTaohongForm();">
<input type="hidden" id="subject" value="" /><!-- 吧文单的标题设置进来，以便套红后正确读取标题 OA-50556-->
<form name="sendForm" id="sendForm" method="post" action="">
<!--
<input type="hidden" name="tempContentId" value="${body.content}">
-->
		<%-- <input type="hidden" name="bodyContentId" value="${body.id}"> --%>
		<input type="hidden" name="bodyContentId" value="">
		<v3x:showContent  htmlId="edoc-contentText" content="0" type="${tempContentType}"/>
</form>
</body>
</html>