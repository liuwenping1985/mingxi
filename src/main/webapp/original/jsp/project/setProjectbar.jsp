<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="project.progress" /></title>
<style type="text/css">
</style>
</head>
<script>
var projectId = "${param.projectId}";
function save(){
	var process = document.getElementById("condition").value;
	
    projectProcess.action = "${basicURL}?method=setProcess&process=" + process + "&projectId=" + projectId; 	
  	projectProcess.target = "projectIframe";
	projectProcess.submit();
	setTimeout(function(){
		transParams.parentWin.callBackSetProcess();
		closeWindow();
	},500);
}
function closeWindow(){
	getA8Top().setProcessDialog.close();
}
</script>
<body style="overflow: hidden;">
<form name="projectProcess" id="projectProcess" method="post" action="" onsubmit="">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key="project.progress" /></td>
	</tr>
	<tr>
		<td align="center" valign="top" style="padding-top: 10px;">
				<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition" style="width:150px;">
					<option value=""><fmt:message key="project.edit.process" /></option>
					<option value="0">0</option>
					<option value="5">5</option>
					<option value="10">10</option>
					<option value="15">15</option>
					<option value="20">20</option>
					<option value="25">25</option>
					<option value="30">30</option>
					<option value="35">35</option>
					<option value="40">40</option>
					<option value="45">45</option>
					<option value="50">50</option>
					<option value="55">55</option>
					<option value="60">60</option>
					<option value="65">65</option>
					<option value="70">70</option>
					<option value="75">75</option>
					<option value="80">80</option>
					<option value="85">85</option>
					<option value="90">90</option>
					<option value="95">95</option>
					<option value="100">100</option>
					
				</select>
				&nbsp;%
		</td>
	</tr>
	<tr>
		<td height="25" align="right" class="bg-advance-bottom">
			<input type="button" onclick="save()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="closeWindow();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe name="projectIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>