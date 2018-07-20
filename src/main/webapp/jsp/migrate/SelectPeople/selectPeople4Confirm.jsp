<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../collaboration/Collaborationheader.jsp"%>
<link href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript">
var contain = 2;
function ok(c){
	contain = c;
	window.returnValue = c;
	window.close();
}
</script>
</head>
<title><fmt:message key="selectPeople4Confirm"/></title>
<body scroll="no" onkeypress="listenerKeyESC()" onunload="if(contain==2)ok(2)">
<form name="selectNextAction" method="post" >
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#BADCE8">
	<tr>
		<td class="PopupTitle" ><fmt:message key="selectPeople4Confirm"/></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input class="button-default-2" type="button" name="operation" id="selectContain" value="<fmt:message key="selectPeople4Confirm.yes"/>" onclick="ok(0);">&nbsp;&nbsp;
			<input class="button-default-2" type="button" name="operation" id="selectNotContain" value="<fmt:message key="selectPeople4Confirm.no"/>" onclick="ok(1);">&nbsp;&nbsp;
			<input class="button-default-2" type="button" name="operation" id="selectContainCanel" value="<fmt:message key="selectPeople4Confirm.canel"/>" onclick="ok(2);">
		</td>
	</tr>
</table>
</form>
</body>
</html>