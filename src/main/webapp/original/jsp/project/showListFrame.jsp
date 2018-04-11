<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="projectHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
	<frameset rows="35%,*" id='sx' cols="*" frameborder="no" border="0">	
		<frame src="project.do?method=systemList&projectTypeId=${param.projectTypeId}&condition=${param.condition}&textfield=${param.textfield}&textfield1=${param.textfield1}" name="listFrame" id="listFrame" frameborder="no"  scrolling="no" />
		<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no" />
	</frameset>
<noframes>
<body>
</body>
</noframes>
</html>