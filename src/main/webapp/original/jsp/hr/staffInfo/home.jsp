<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">

	<frameset id="sx" rows="35%,*" cols="*"  framespacing="3" frameborder="no" border="1" scrolling="no">
	    <frame  frameborder="no" src="${hrStaffURL}?method=init${listType}&isManager=${isManager}&staffId=${staffId}" name="listFrame" id="listFrame"/>
	    <frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>

</html>