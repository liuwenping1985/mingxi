<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
</head>
<frameset rows="*" id="bbsFrame" framespacing="0" frameborder="no" border="0">
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="0" src="${detailURL}?method=listBoardMain&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="listBoard" scrolling="no" id="listBoard"  />
	  <frame frameborder="0" src="<c:url value='/common/detail.jsp?direction=Down' />" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes>
<body scroll='no'>
</body>
</noframes>
</html> 