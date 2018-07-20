<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key="common.page.title" bundle="${v3xCommonI18N}" /></title>
</head>
<body>
<script language="javascript">
   alert('${message}');
   parent.window.returnValue = "true";
   parent.window.close();
</script>
</body>

</html>