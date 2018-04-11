<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${meetingTitle }</title>

</head>
<body scroll="no">
	<iframe src="mtAppMeetingController.do?method=mydetail&id=${param.id}&state=${param.state}&proxy=${param.proxy}&proxyId=${param.proxyId}&eventId=${param.eventId}" name="mtFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
</body>
</html>