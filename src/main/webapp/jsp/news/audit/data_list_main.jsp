
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<frameset rows="*" id="newsFrame" border="0" frameborder="no">
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame frameborder="0" src="${newsDataURL}?method=auditList&spaceType=${param.spaceType}&showAudit=${param.showAudit}&spaceId=${param.spaceId}&newsTypeId=${newsTypeId}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="0" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

