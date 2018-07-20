<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="60%,*" border="0" name="sx" id="sx" framespacing="3" frameborder="no">
	
	<frame src="${edoc}?method=edocSearchWhere" id="top" name="top" scrolling="yes"/>
	
	<frame src="<c:url value='/common/detail.html'/>" name="bottom" id="bottom" scrolling="yes" />
</frameset>
<noframes>
<body>
</body>
</html>