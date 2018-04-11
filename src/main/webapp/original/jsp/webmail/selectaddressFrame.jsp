<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="webmailheader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body scroll=no>
<IFRAME name="myframe" id="myframe" scrolling="no" frameborder="0" width="100%" height="100%" src="${webmailURL}?method=getAddress"></IFRAME>
</body>
</html>