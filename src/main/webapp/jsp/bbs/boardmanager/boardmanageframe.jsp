<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
</head>
<frameset rows="50%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
  <frame frameborder="0" src="${detailURL}?method=listArticleMain&boardId=${param.boardId}" name="mainFrame" scrolling="no" id="mainFrame" />
  <frame frameborder="0" src="<c:url value='/common/detail.jsp' />" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html> 