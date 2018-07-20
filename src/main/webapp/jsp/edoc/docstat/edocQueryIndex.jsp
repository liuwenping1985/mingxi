<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="41%,*" border="0" name="sx" id="sx" framespacing="3" frameborder="no">
	
	<frame src="${edocStat}?method=edocQueryTopFrame" id="top" name="top" scrolling="yes"/>
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
	<frame src="<c:url value='/common/detail.jsp?direction=Down'/>" name="bottom" id="bottom" scrolling="no" />
	</c:if>
</frameset>
<noframes>
<body>
</body>
</html>