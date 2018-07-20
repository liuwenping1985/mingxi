<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html style="overflow:hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<c:set var="controller" value="edocController.do"/>
</head>
<body onkeydown="listenerKeyESC()" scroll="no">
	<iframe src="${controller}?method=showArchiveModifyLog&summaryId=${summaryId}" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
</body>
</html>