<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>

<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>
<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="mt.meetingAddress.input" /></title>
<script type="text/javascript">
function doIt() {
	var arr = new Array();
	var handWrite=document.getElementById("hand_write");
	var handWriteValue= handWrite.value;
	if (handWriteValue == "") {
		alert(v3x.getMessage('meetingLang.alert_meetingAddress'));
		handWrite.focus();
		return false;
	}
	window.returnValue = handWriteValue;
	window.close();
}
</script>
</head>
<body scroll=no>

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="popupTitleRight">
		<tr>
			<td height="20" class="PopupTitle">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr valign="bottom" id="tdPanel">
					<td  valign="middle"><font size="4"><strong><fmt:message key="mt.meetingAddress.input" /></strong></font></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td class="padding010">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="new-column" nowrap="nowrap">
							<div><fmt:message key='mt.meetingAddress.input.plea' />:</div>
							<input type="text" name="hand_write" id="hand_write" value="${meetingPlace}" onkeypress="" class="input-300px">
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<tr valign="middle">
			<td height="35" align="right" class="bg-advance-bottom">
				<input id="doItButton" type="button" onclick="doIt()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
				<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="window.close();">
			</td>
		</tr>
	</table>


</body>
</html>