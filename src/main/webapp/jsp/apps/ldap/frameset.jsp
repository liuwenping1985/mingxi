<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>hand</title>
<%@include file="header.jsp"%>
</head>
<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame src="${ldapSynchron}?method=listUsers" name="listFrame" id="listFrame" frameborder="no" scrolling="no"/>
	<frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>