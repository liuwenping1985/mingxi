<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../ctp/common/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>示例</title>

</head>
<body>
<div width="1010px" height="580px">
	<c:choose>
		<c:when test="${language eq 'en'}">
			<img src="${path}/apps_res/datarelation/image/dealCopyEn.png" width="100%" height="100%">
		</c:when>
		<c:otherwise>
	       <img src="${path}/apps_res/datarelation/image/dealCopy.png" width="100%" height="100%">
	    </c:otherwise>
    </c:choose>
</div>

</body>
</html>