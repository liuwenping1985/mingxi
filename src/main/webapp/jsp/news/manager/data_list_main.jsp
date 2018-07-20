<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head><title></title></head>
<frameset rows="*" border="0" frameborder="no">
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame frameborder="0" src="${newsDataURL}?method=list&condition=${v3x:toHTML(param['condition'])}&textfield=${param['textfield']}&type=${v3x:toHTML(param['type'])}&spaceType=${v3x:toHTML(param.spaceType)}&spaceId=${v3x:toHTML(param.spaceId)}&showAudit=${v3x:toHTML(param.showAudit)}&custom=${v3x:toHTML(param.custom)}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="0" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>



