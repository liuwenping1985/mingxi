<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="bul.userView.CallInfo" /></title>
</head>
<body scroll=no>
<IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%" src="${bulDataURL}?method=bulReadIframe&deptId=${param.deptId}&beanId=${param.beanId}&fromPigeonhole=${param.fromPigeonhole}"></IFRAME>
</body>
</html>