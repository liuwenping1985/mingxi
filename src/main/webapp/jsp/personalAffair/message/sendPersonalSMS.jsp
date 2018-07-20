<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.mobile.resources.i18n.MobileResources" var="v3xMobileI18N"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/message.js${v3x:resSuffix()}" />"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html:link renderURL='/message.do?method=sendPersonalSMS' var='sendSMSURL'/>
<title><fmt:message key="online.sendMsg.shortmess" bundle="${v3xMobileI18N}"/></title>
</head>
<body scroll="no" style="overflow: hidden;" onkeydown="doKeyPressedEvent()" onload="document.all.content.focus();" >
<form name="sendForm" method="post" action="${sendSMSURL}" onsubmit="return checkForm(this) && check()" target="hiddenIFrame">
<input type="hidden" name="phoneMembers" value="${param.phoneMembers}"/>
<table class="popupTitleRight" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
	<tr>
		<td height="20" width="100%" class="PopupTitle">
			<fmt:message key="online.sendMsg.shortmess" bundle="${v3xMobileI18N}"/>&nbsp;:&nbsp;
			<input type="text" name="sendTo" class="textfield" style="width:45%;" value="${param.names}" readonly>
		</td>
	</tr>
	<%
	Integer largestNum = com.seeyon.ctp.common.constants.SystemProperties.getInstance().getIntegerProperty("mobile.largestNum", 120);
	pageContext.setAttribute("largestNum", largestNum);
	%>
	<tr class="bg-advance-middel">
		<td valign="top"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="100%"><textarea id="msgContent" name="content" cols="" rows="6" style="width:100%" inputName="<fmt:message key='message.tableHeader.content'/>" validate="notNull" maxSize="${largestNum}"></textarea></td>
			</tr>
			<tr>
				<td height="20">
					<div style="color: green">
						<fmt:message key="guestbook.content.help">
							<fmt:param value="${largestNum}"/>
						</fmt:message>
					</div>
				</td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
		    <input type="submit" id="submitButton" class="button-default_emphasize" value="<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}'/>"/>&nbsp;&nbsp;&nbsp;&nbsp;
		    <input type="button" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="getA8Top().senSmsWin.close();"/>
		</td>
	</tr>
</table>
</form>
<iframe name="hiddenIFrame" frameborder="0" width="0" height="0"></iframe>
</body>
</html>