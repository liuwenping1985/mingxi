<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
<title></title>
</head>

<frameset id='sx' rows="35%,*" cols="*" framespacing="0"
	frameborder="yes" bordercolor="#ececec">
	<frame src="${ipcontrolURL}?method=list&id=${param.accountId}" name="list"
		frameborder="0" id="list" scrolling="no" />
	<frame src="<c:url value="/common/detail.jsp" />" frameborder="0" name="detailFrame" id="detailFrame"
		scrolling="no" />
</frameset>

<noframes>
<body scroll="no"></body>
</noframes>
</html>