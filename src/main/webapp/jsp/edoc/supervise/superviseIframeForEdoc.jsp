<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title id="ititle"><fmt:message key="edoc.supervise.label" /></title>
</head>
<body scroll=no style="height:100%;">
<IFRAME name="myframe" id="myframe" scrolling="no" frameborder="0" width="100%" height="100%" src="edocTempleteController.do?method=superviseWindow&summaryId=${param.summaryId}&sVisorsFromTemplate=${param.sVisorsFromTemplate}&unCancelledVisor=${param.unCancelledVisor}"></IFRAME>
</body>
</html>