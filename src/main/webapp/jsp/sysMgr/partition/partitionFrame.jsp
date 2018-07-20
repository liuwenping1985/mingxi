<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>mainframe</title>
<%@include file="../header.jsp"%>
</head>
<frameset rows="35%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame src="${partitionURL}?method=listPost" name="listFrame" id="listFrame" frameborder="no" scrolling="no"/>
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>