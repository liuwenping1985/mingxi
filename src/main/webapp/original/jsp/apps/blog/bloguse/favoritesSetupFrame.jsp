<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<html>
<head>
</head>
 <frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameBorder="no" border="0">
	<frame frameBorder="no" src="${detailURL}?method=listFavoritesSetup" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameBorder="no" src="${commonDetailURL}?direction=Down" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>