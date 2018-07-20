<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
</head>
<body style="overflow: hidden" scroll="no" class="padding5">
<div class="page-list-border">
	<iframe frameborder="no" scrolling="no" src="${log}?method=main&category=${category}" id="mainFrame" name="mainFrame" style="width:100%;height: 100%;" border="0px"></iframe>
</div>
</body>
</html>
