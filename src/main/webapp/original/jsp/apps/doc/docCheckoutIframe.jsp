<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.jsp.checkout.title"/></title>
</head>
<body>
<IFRAME name="coframe" id="coframe" frameborder="0" width="100%" height="100%" 
	src="${detailURL}?method=docCheckoutView&docLibId=${param.docLibId}"></IFRAME>
</body>
</html>