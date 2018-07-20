<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset rows="25,*" framespacing="0" frameborder="no" border="0" scrolling="no">
    <frame noresize="noresize" frameborder="no" src="${urlHR}?method=initToolBar" name="toolbarFrame" id="toolbarFrame" scrolling="no" />
	<frameset id="detailandlist" rows="35%,*" framespacing="0" frameborder="no" border="0" scrolling="no">
	    <frame noresize="noresize" frameborder="no" src="${urlHR}?method=initList" name="listFrame" scrolling="no" id="listFrame" />
	    <frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</frameset>
</frameset>

<noframes>
<body scroll="no">
</body>
</noframes>

</html>