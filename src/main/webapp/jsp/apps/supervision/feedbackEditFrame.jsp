<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>新建反馈</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
</head>
<body scroll="no" style="overflow: auto;">
	<iframe id="feedbackIframe" scrolling="no" frameborder="0" width="100%" height="420px" src="${path}/supervision/supervisionController.do?method=enterFeedbackPage&tableName=feedback&masterDataId=${masterDataId}"></iframe>
</body>
</html>