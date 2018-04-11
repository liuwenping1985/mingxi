<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
</head>
<frameset rows="*" framespacing="0" id="inquiryFrame" frameborder="no" border="0" scrolling="no">
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="no" src="${detailURL}?method=categoryList&group=${param.group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
	  <frame frameborder="no" src="<c:url value='/common/detail.jsp?direction=Down' />" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>