<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<fmt:message key='meeting.title.checkLog' bundle='${v3xCommonI18N}' var="titleLabel"/>
<c:set var="controller" value="mtMeeting.do"/>
<html>
<head>
<title>${titleLabel}</title>
</head>
<body scroll="no" style="padding:0;margin:0;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">${meeting.title.checkLog}
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" sytle="padding:0;">
		
			<iframe src="${controller}?method=listMtLookRecord&id=${param.id}" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="window.close()" value="${meeting.bottom.closed}" class="button-default-2">
		</td>
	</tr>
</table>
	
</body>
</html>
