<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="head.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>videoconf</title>
</head>
<frameset rows="40,*" id='main' cols="*" framespacing="0" frameborder="no" border="0">
        <frame src="${videoconfURL}?method=synchronOrg" frameborder="no"  name="menuFrame" id="menuFrame" scrolling="no" noresize="noresize"/>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>