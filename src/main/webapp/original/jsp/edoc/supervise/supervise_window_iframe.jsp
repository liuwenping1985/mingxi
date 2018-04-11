<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title id="ititle"></title>
</head>
<body scroll=no>
<IFRAME name="myframe" id="myframe" scrolling="no" frameborder="0" width="100%" height="100%" src="${supervise}?method=superviseWindow&summaryId=${param.summaryId}&superviseId=${param.superviseId}&supervisorId=${param.supervisorId}&unCancelledVisor=${param.unCancelledVisor}&awakeDate=${param.awakeDate}&count=${param.count}&superviseTitle=${param.superviseTitle}"></IFRAME>
</body>
</html>