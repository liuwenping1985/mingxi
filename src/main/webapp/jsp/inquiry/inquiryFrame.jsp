<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="*" border="0" frameborder="no">
<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame src="${basicURL}?method=getAllCheck&group=${group}&surveyTypeId=${surveyTypeId}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}" id="top" name="top" scrolling="no" frameborder="0" style="padding-left: 0px;" />
	<frame src="<c:url value='/common/detail.jsp?direction=Down'/>" name="detailFrame" scrolling="no" id="detailFrame" frameborder="0" />
</frameset>
</frameset>
<noframes>
<body>
</body>
</html>