<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../exchangeHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="exchange.account.modify" /></title>

</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${exchangeEdoc}?method=list&id=${param['id']}" name="listFrame" scrolling="no" id="listFrame" />
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>