<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<script type="text/javascript">
function OK(){
	$("#taskId",parent.currentTr).val($("#taskId").val());
	$("#taskName",parent.currentTr).val($("#taskName").val());
	return "";
}

$(document).ready(function(){
	$("#taskId").val($("#taskId",parent.currentTr).val());
	$("#taskName").val($("#taskName",parent.currentTr).val());
});
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body >
<form id="myform" name="myform">
<table class="popupTitleRight" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%"  >
	<tr class="bg-advance-middel">
		<td>
		${ctp:i18n('form.trigger.triggerSet.DEETask.id') }<input id="taskId">
		</td>
		</tr>
		<tr class="bg-advance-middel">
		<td>
		${ctp:i18n('form.trigger.triggerSet.DEETask.name') }<input id="taskName">
		</td>
		</tr>
		</table>
		</form>
</body>
</html>