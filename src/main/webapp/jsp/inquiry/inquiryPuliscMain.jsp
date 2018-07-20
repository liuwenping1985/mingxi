<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
</head>
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame frameborder="0" src="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}&group=${param.group}&custom=${param.custom}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
	<frame frameborder="0" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>