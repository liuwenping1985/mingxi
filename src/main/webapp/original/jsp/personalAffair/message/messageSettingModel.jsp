<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.plan.resource.i18n.PlanResources" var="v3xPlanI18N"/>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='message.setting.title' /></title>
</head>
<body scroll="no">
<iframe src="${messageURL}?method=showMessageSetting&fromModel=top" name="contentFrame" frameborder="0" height="100%" width="100%" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
</body>
</html>