<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="page-list-border">
		<iframe id="formqueryframe" name="formqueryframe" src="${urlMyTemplate}?method=myTemplateBorderMain&type=${param.type}" style="width:100%;height: 100%;" border="0px" frameborder="0"></iframe>
		<iframe id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px" frameborder="0"></iframe>
</div>
</body>
</noframes>
</html>