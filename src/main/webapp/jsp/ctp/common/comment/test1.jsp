<%--
 $Author: wuym $
 $Rev: 282 $
 $Date:: 2012-07-31 18:06:42#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>协同回复测试</title>
<style>
.comment .header {
	background-color: #EEEEEE;
}

.comment .btnReply {
	align: right;
	float: right;
}

.comment .content {
	margin: 5px;
}

.comment .reply {
	border: 1px solid #EEEEEE;
	margin: 8px
}
</style>
</head>
<body>

	<jsp:include page="comment.jsp" />

</body>
</html>
