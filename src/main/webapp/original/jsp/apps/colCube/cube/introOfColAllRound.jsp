<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp" %>
<html class="h100b">

<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
<body class="h100b">
	<c:if test="${!isG6}"><img src="${path }/apps_res/colCube/cube360.jpg"/></c:if>
	<c:if test="${isG6}"><img src="${path }/apps_res/colCube/cube360g6.jpg"/></c:if>
</body>

</html>
