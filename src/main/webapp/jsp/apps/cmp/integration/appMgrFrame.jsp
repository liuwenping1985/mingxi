<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="${managerURL}?method=list&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
		<frame frameborder="no" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

