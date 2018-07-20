<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="inquiry.select.template.label" /></title>

</head>
<body scroll="no">
<iframe src="${basicURL}?method=${url}" name="tframe" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
</body>
</html>