<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
</head>
<frameset rows="*" border="0" frameborder="no">
<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${basicURL}?method=getAllCheck&group=${param.group}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="no" src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>