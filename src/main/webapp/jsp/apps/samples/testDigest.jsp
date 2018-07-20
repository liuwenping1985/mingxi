<%--
 $Author: wuym $
 $Rev: 3833 $
 $Date:: 2013-01-17 22:05:09#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>Digest测试</title>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <%
        Long testId1 = 123L, testId2 = 234L;
        request.setAttribute("testId1", testId1);
        request.setAttribute("testId2", testId2);
    %>
    <a href="${path}/samples/test.do?method=testDigest1&testId1=<%=testId1%>&v=${ctp:digest_1(testId1)}">安全URL测试1</a>
    <a href="${path}/samples/test.do?method=testDigest2&testId1=<%=testId1%>&testId2=<%=testId2%>&v=${ctp:digest_2(testId1,testId2)}">安全URL测试2</a>
</body>
</html>
