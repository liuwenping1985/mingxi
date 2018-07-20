<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>

</head>
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame frameborder="0" src="${bulDataURL}?method=publishList&spaceType=${param.spaceType}&bulTypeId=${param.bulTypeId}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="0" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

