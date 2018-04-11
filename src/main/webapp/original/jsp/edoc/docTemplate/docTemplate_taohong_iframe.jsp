<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../edocHeader.jsp" %>
<title><fmt:message key='templete.select.label' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body scroll=no>
<IFRAME name="myframe" id="myframe" frameborder="no" scrolling="no" src="${edocTemplate}?method=taoHong&templateType=${templateType}&bodyType=${bodyType}&isUniteSend=${param.isUniteSend}&orgAccountId=${param.orgAccountId}" style="width:100%;height: 100%;" border="0px"></iframe>
</body>
</html>
