<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>

<c:set value="list" var="listMethod" />
<c:set value="meetingResource.do" var="listController" />
<c:if test="${param.from == 'listMeetingType' }">
	<c:set value="meetingType.do" var="listController" />
</c:if>
<c:if test="${param.from == 'listMeetingRoom' }">
	<c:set value="meetingroomList.do" var="listController" />
	<c:set value="listAdd" var="listMethod" />
</c:if>

<frameset rows="35%,*" id="sx" name="sx" cols="*" frameborder="no">
	<frame frameborder="no" src="${listController }?method=${listMethod }&stateStr=${v3x:toHTML(param.stateStr)}&from=${v3x:toHTML(from)}" name="listFrame" scrolling="no" id="listFrame" />
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
		<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
	</c:if>
</frameset>

<noframes>
	<body scroll='no'>
	</body>
</noframes>

</html>

