<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>

<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>

<frameset  rows="*" cols="*" frameBorder="1"  frameSpacing="5" bordercolor="#ececec">
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="${mtAdminController}?method=listMeetingType&stateStr=${param.stateStr}&from=${param.from}" name="listFrame" scrolling="no" id="listFrame" />
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if>
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

