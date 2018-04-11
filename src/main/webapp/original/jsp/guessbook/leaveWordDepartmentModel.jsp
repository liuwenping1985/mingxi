<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<html:link renderURL="/project.do" var="basicURL" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
</title>
</head>
<body>
<iframe src="${guestbookURL}?method=moreLeaveWordNew&project=${project}&departmentId=${departmentId}&fromModel=${fromModel}&custom=${custom}&phaseId=${phaseId}" name="contentFrame" frameborder="0" height="100%" width="100%"  marginheight="0" marginwidth="0"></iframe>
</body>
</html>
