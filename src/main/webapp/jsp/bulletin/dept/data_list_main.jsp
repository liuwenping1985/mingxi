<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${bulDataURL}?method=deptManageList&condition=${param['condition']}&textfield=${param['textfield']}&type=${param['type']}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="no" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>
