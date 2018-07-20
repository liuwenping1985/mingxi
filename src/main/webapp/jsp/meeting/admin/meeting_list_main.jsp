<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>

<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<c:set value="16" var="cols" />
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:set value="0" var="cols" />
<% } %>
<c:set value="showEdocSendSet" var="listMethod" />
<c:choose>
	<c:when test="${from=='listMeetingRoomAdmin' }">
		<c:set value="listMeetingRoom" var="listMethod" />
	</c:when>
    <c:when test="${from=='listMeetingResource' }">
        <c:set value="initList" var="listMethod" />
    </c:when>
</c:choose>

<frameset  rows="*" cols="${cols }%,*" frameBorder="0"  frameSpacing="0" bordercolor="#ececec">
		<frame src="${mtAdminController}?method=listBaseDataLeft&from=${v3x:toHTML(param.from)}&stateStr=${v3x:toHTML(param.stateStr)}" name="treeFrame" frameborder="0" scrolling="yes"  id="treeFrame"/>
	<frameset rows="35%,*" id="sx" name="sx" cols="*" frameborder="no">
		<frame frameborder="no" src="${mtAdminController}?method=${listMethod }&stateStr=${v3x:toHTML(param.stateStr)}&from=${v3x:toHTML(from)}" name="listFrame" scrolling="no" id="listFrame" />
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if>
	</frameset>
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

