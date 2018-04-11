<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="${newsTypeURL}?method=list&id=${param.id}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
		<frame frameborder="no" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

