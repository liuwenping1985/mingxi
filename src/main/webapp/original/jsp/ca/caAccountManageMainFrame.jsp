<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>caAccountManageMainFrame.jsp</title>
<%@include file="caaccountHeader.jsp"%>
</head>
<frameset rows="35%,*" id='sx' name='sx' cols="*" border="0" frameBorder="no" frameSpacing="0">
	<frame name="listFrame" id="listFrame" src="${caacountURL}?method=listCAAccount" frameborder="0" scrolling="no"/>
	<frame name="detailFrame" id="detailFrame" src="<c:url value="/common/detail.jsp" />" frameborder="0" border="0" scrolling="no"/>
</frameset>
<noframes>
<body scroll="no"></body>
</noframes>
</html>