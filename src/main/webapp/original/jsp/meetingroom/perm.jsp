<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="header.jsp" %>
</head>
<c:set value="16" var="cols" />
<c:set value="waitReview" var="flag" />
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:set value="0" var="cols" />
	<c:set value="all" var="flag" />
<% } %>

<frameset cols="${cols }%,*" framespacing="0" frameborder="no" border="0" scrolling="no">
<frame  frameborder="no" src="${mrUrl}?method=meetListLeft&from=perm" name="treeFrame" scrolling="yes" id="treeFrame"/>
	<frameset rows="40%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="no" src="meetingroomList.do?method=listPerm&flag=${flag }&list=waitReview" name="listFrame" scrolling="auto" id="listFrame" />
	  <frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>