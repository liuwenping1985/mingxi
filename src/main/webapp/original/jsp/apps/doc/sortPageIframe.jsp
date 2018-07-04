<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp" %>
<%@include file="../../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
	<fmt:message key='doc.menu.sort.label'/>
</title>
</head>
<body onkeydown="listenerKeyESC()" scroll="no">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<!-- <tr>
		<td height="20" class="PopupTitle" ><fmt:message key="doc.contenttype.wenjian" /><fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' /></td>
	</tr> -->
	<tr>
		<td valign="top"><iframe src="${detailURL}?method=sortProperty&resId=${param.resId}&frType=${param.frType}" name="sortPageIframe" id="sortPageIframe" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe></td>
	</tr>
</table>
</body>
</html>