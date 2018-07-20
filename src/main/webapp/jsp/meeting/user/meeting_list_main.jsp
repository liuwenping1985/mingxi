<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<c:choose>
<c:when test="${param.listType=='listAppAuditingMeeting' || param.listType=='listAppAuditingMeetingAudited' || param.listType=='listMyAppMeeting' || param.listType=='listMyAppMeetingWaitVarificate'}">
	<c:set var="controllerStr" value="mtAppMeetingController.do"/>
</c:when>
<c:when test="${param.listType=='listNoticeMeeting'}">
	<c:set var="controllerStr" value="mtMeeting.do"/>
</c:when>
<c:otherwise>
	<c:set var="controllerStr" value="mtMeeting.do"/>
</c:otherwise>
</c:choose>
<c:set value="14" var="cols" />
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:if test="${param.from != 'notice'}">
		<c:set value="0" var="cols" />
	</c:if>
<% } %>
<frameset  rows="*" cols="${cols}%,*" frameBorder="1"  frameSpacing="5" bordercolor="#ececec"><%-- xiangfan添加了 参数summaryId AffairId 等，修复协同转会议通知的问题GOV-3397 --%>
	<frame src="mtMeeting.do?method=listLeft&menuId=${param.menuId}&listType=${param.listType}&collaborationFrom=${param.collaborationFrom}" name="treeFrame" frameborder="0" scrolling="auto"  id="treeFrame"/>
	<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="${controllerStr}?method=${(param.listMethod==null || param.listMethod=='')?'list':param.listMethod}&listType=${param.listType}&stateStr=${param.stateStr}&from=${param.from}&menuId=${param.menuId }&sendType=${param.sendType}&mtAppId=${param.mtAppId}&summaryId=${param.summaryId}&affairId=${param.affairId}&collaborationFrom=${param.collaborationFrom}&formOper=${param.formOper}&portalRoomAppId=${param.portalRoomAppId}&projectId=${param.projectId}" name="listFrame" scrolling="no" id="listFrame" />
		<!-- 
		<frame src="" name="detailFrame" id="detailFrame" frameborder="0" scrolling="no"/>
		 -->
		 <c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if>
	</frameset>
</frameset>
<noframes>
	<body scroll='no' onload="">
	</body>
</noframes>
</html>

