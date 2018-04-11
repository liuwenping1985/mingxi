<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<c:set value="${(param.listMethod==null || param.listMethod=='') ? 'listSendMeeting' : param.listMethod}" var="listMethod" />
<c:set value="${(param.listType==null || param.listType=='') ? 'listSendMeeting' : param.listType}" var="listType" />
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>

<frame rows="*" cols="0%,*" frameBorder="0"  frameSpacing="0" bordercolor="#ececec">	
	<!-- 列表 -->
	<frameset rows="35%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
		<frame frameborder="no" src="${meetingNavigationURL }?method=list&listMethod=${listMethod }&listType=${listType }&meetingNature=${param.meetingNature }&sendType=${param.sendType}&mtAppId=${param.mtAppId}&meetingId=${param.meetingId }&summaryId=${param.summaryId}&affairId=${param.affairId}&collaborationFrom=${param.collaborationFrom}&formOper=${param.formOper}&moduleTypeFlag=${param.moduleTypeFlag}&portalRoomAppId=${ctp:toHTML(param.portalRoomAppId)}&projectId=${param.projectId}&time=${param.time}" name="listFrame" scrolling="no" id="listFrame" />
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if>
	</frameset>
</frame>

</html>

