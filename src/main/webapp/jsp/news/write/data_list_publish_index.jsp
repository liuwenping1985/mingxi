<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

</head>
<body scroll='no' class="padding5">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="page-list-border"><tr><td>
	<iframe id="publishListMainFrame" src="${newsDataURL}?method=publishListMain&spaceType=${v3x:toHTML(param.spaceType)}&newsTypeId=${param.newsTypeId}&spaceId=${param.spaceId}&custom=${param.custom}" style="width: 100%; height: 100%;" frameborder="0"></iframe>
</td></tr></table>
</body>
</html>