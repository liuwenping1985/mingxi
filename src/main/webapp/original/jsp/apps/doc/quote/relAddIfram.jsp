<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.rel.title'/></title>
</head>

<body scroll="no" onkeydown="listenerKeyESC()">
<form action="" name="mainForm" id="mainForm" method="post">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='doc.jsp.rel.title'/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
					<iframe src="${detailURL}?method=docRelAddView&docLibId=${param.docLibId}&sourceId=${param.sourceId}&flag=${param.flag }&deletedId=${param.deletedId}" name="docIframe" id="docIframe" frameborder="1"
			height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
			
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="docIframe.addDocLink()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>

</table>
</form>
</body>

</html>