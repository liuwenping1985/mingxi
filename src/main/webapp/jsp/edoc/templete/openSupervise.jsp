<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<script>
	/* alert('rr'+window.dialogArguments.document.getElementById('subObjectId')); */
	</script>
	</head>
	<body >
			<iframe src="/f7/supervise/supervise.do?method=openSuperviseWindow&isTemplate=true"
			width="100%" height="100%" frameborder="0" name="myiframe" id="myiframe">
			</iframe>
			
	</body>
</html>