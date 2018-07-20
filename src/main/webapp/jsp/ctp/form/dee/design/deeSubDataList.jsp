<%--
 $Author: dengxj $
 $Rev: 9416 $
 $Date:: 2013-11-15 10:46:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>dee数据列表</title>
</head>
<body>
	<div style="height:95%;width:99%;margin-left:10px;">
    <c:forEach items="${slaveHtmlBean}" var="slave" varStatus="status">
    	<h2>${slave.tableName}</h2>
        ${slave.tableHtml}
    </c:forEach>
    </div>
    <br/>
</body>
</html>