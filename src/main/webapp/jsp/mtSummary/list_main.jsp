<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>

<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>

<c:set var="leftWidth" value="140px"/>
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:set var="leftWidth" value="0"/>
<% } %>
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
	<c:if test="${param.from=='publish' }">
		<c:set var="leftWidth" value="0"/>
	</c:if>
<% } %>

<frameset rows="*" cols="${leftWidth},*" frameBorder="0" frameSpacing="5" bordercolor="#ececec">
	<frame src="${mtSummaryURL}?method=listLeft&from=${param.from}&listType=${param.listType}" name="treeFrame" frameborder="0" scrolling="yes" id="treeFrame" />
	<frameset rows="*" id='sx' cols="*" frameborder="0">
		<%--xiangfan 修改 2012-04-17 默认情况下右侧显示列表信息 --%>
		<c:if test="${empty param.editSummaryId}">
		<frame frameborder="0" src="${mtSummaryURL}?method=list&listType=${param.listType}&from=${param.from}&listType=${listType}" name="listFrame" scrolling="yes" id="listFrame" />
		</c:if>
		<%--xiangfan 修改  2012-04-17 publish_list_iframe.jsp中的edit()方法 跳转 解决GOV-447 和GOV-451 页面跳转错误 --%>
		<c:if test="${not empty param.editSummaryId}">
		<frame frameborder="0" src="${mtSummaryURL}?method=create&id=${param.editSummaryId}&from=${param.editFrom}&listType=${param.editListType}" name="listFrame" scrolling="yes" id="listFrame" />
		</c:if>
	</frameset>
</frameset>
<noframes>
<body scroll='no'>
</body>
</noframes>
</html>

