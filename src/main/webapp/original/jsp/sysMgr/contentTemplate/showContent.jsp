<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="taglib.jsp" %>
<%@ include file="header.jsp" %>
<title>Insert title here</title>
</head>
<body class="body-bgcolor">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">
<div id="colBody">
	<v3x:showContent content="${bean.content}" type="${bean.templateFormat}" createDate="${bean.createDate}" htmlId="col-contentText" />
	<div class="body-line-sp"></div>
</div>
</body>
</html>
