<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="41%,*" border="0" name="sx" id="sx" framespacing="3" frameborder="no">

	<frame src="${managerURL}?method=docLibTopFrame&flag=${param.flag}" id="top" name="top" scrolling="yes"/>
	
	<frame src="<c:url value='/common/detail.jsp?direction=Down'/>" name="bottom" id="bottom" scrolling="no" />
</frameset>
<noframes>
<body>
</body>
</html>