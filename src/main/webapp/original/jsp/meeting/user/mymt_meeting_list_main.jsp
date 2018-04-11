<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>

<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>

<frameset  rows="*" cols="16%,*" frameBorder="1"  frameSpacing="5" bordercolor="#ececec">
		<frame src="mtMeeting.do?method=mymtListLeft&from=${param.from}&stateStr=${param.stateStr}" name="treeFrame" frameborder="0" scrolling="yes"  id="treeFrame"/>
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="mtMeeting.do?method=list&stateStr=${param.stateStr}&from=${param.from}" name="listFrame" scrolling="no" id="listFrame" />
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail_edoc.html" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if>
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

