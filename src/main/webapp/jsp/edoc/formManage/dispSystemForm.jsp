<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.form.sysEdocForm'/></title>
</head>
<body>
<html:link renderURL='/edocForm.do?method=listSystemFormIframe' var="sysFormIframUrl" />
<iframe name="includIframe" id="includIframe" style ="width:100%;height:100%" src="${sysFormIframUrl}"></iframe>
</body>
</html>