<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title id="ititle"><fmt:message key="edoc.docmark.title" /></title>
</head>
<body scroll=no>
<IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%" src="${mark}?method=manageBigStreamPage"></IFRAME>
</body>
</html>