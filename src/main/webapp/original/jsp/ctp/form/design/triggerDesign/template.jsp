<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<script type="text/javascript">
function OK(){
	if($("#formId",parent.currentTr).val()!=$("#formId").val()){
		$("#fillBackType",parent.currentTr).val("");
		$("#fillBackKey",parent.currentTr).val("");
		$("#fillBackValue",parent.currentTr).val("");
	}
	$("#formId",parent.currentTr).val($("#formId").val());
	$("#templateId",parent.currentTr).val($("#templateId").val());
	$("#content",parent.currentTr).val($("#templateName").val());
	return "";
}

$(document).ready(function(){
	$("#formId").val($("#formId",parent.currentTr).val());
	$("#templateId").val($("#templateId",parent.currentTr).val());
	var content = $("#content",parent.currentTr).val();
	$("#templateName").val(content=="<点击选择模板>"?"":content);
});
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body >
<form id="myform" name="myform">
<table class="popupTitleRight" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%"  >
	<tr class="bg-advance-middel">
		<td>
		表单ID<input id="formId">
		</td>
		</tr>
		<tr class="bg-advance-middel">
		<td>
		模板ID<input id="templateId">
		</td>
		</tr>
		<tr class="bg-advance-middel">
		<td>
		模板名称<input id="templateName">
		</td>
		</tr>
		</table>
		</form>
</body>
</html>