<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="edoc.docmark.chooseallmark" /></title>
</head>
<body scroll=no>
	<IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%" src="${mark}?method=docMarkChoose&twoDocmark=${param.twoDocmark}&edocId=${param.edocId }&affairId=${param.affairId}&edocType=${param.edocType }&selDocmark=${param.selDocmark}&orgAccountId=${param.orgAccountId}&templeteId=${param.templeteId}"></IFRAME>
</body>
</html>