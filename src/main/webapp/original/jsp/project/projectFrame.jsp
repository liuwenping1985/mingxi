<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  	<frame frameborder="no" src="${basicURL}?method=getAllProjectList" name="listFrame"  id="listFrame"  scrolling="no"/>
	  	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
	  		<frame frameborder="no" src="<c:url value='/common/detail.jsp?direction=Down' />" name="detailFrame" id="detailFrame" scrolling="no"/>
	  	</c:if>
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>