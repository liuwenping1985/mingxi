<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="header.jsp" %>
</head>

<frameset rows="40%,*" id='sx' name="sx" cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="meetingroom.do?method=createApp&list=yesApp" name="listFrame" scrolling="auto" id="listFrame" />
	<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'></body>
</noframes>
</html>