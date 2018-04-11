<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='project.body.phase.label' /></title>
<script type="text/javascript">
function ok(){
	var theForm = document.getElementById("phaseForm");
	theForm.submit();
	setTimeout(function(){
		transParams.parentWin.callBackSetPhase();
		closeWindow();
	},500);
}

function closeWindow(){
	getA8Top().setPhaseDialog.close();
}
</script>
</head>
<body style="overflow: hidden;">
<form name="phaseForm" id="phaseForm" method="post" action="${basicURL}?method=savePhase" target="phaseIframe">
<input type="hidden" id="projectId" name="projectId" value="${param.projectId}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key="project.body.phase.label" /></td>
	</tr>
	<tr>
		<td align="center" valign="top" style="padding-top: 10px;">
			<select id="phaseId" name="phaseId" class="condition" style="width:150px;">
				<c:forEach items="${phaseList}" var="phase">
					<option value="${phase.id}" ${currentPhase == phase.id ? 'selected' : ''}>${phase.phaseName}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td height="25" align="right" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onclick="ok()">&nbsp;
			<input type="button" onclick="closeWindow();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe name="phaseIframe" id="phaseIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>