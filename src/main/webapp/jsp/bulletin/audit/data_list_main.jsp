<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<frameset rows="*" border="0" frameborder="no">
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
    <!-- yangwulin Sprint4 2012-11-05 添加一个传递的参数bulTypeId -->
	<frame frameborder="0" src="${bulDataURL}?method=auditList&spaceType=${v3x:toHTML(param.spaceType)}&showAudit=${v3x:toHTML(param.showAudit)}&spaceId=${v3x:toHTML(param.spaceId)}&bulTypeId=${v3x:toHTML(bulTypeId)}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="0" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

