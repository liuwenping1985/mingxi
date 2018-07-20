<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<title><fmt:message key="oper.preview" /><fmt:message key="news.template_shortname" /></title>
</head>
<body class="detailBody">
<div style="overflow:auto">
	<c:if test="${bean==null}">
		
	</c:if>
	<c:if test="${bean!=null}">
		<v3x:showContent content="${bean.content}" type="${bean.templateFormat}" createDate="${bean.createDate}" htmlId="content" />
	</c:if>
</div>

</body>
</html>