<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html style="overflow:hidden; height:100%;">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${v3x:toHTML(meetingTitle) }</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
 var fromPage = "${param.from}";//全文检索isearch
 var openFromUC = "${param.openFrom}"=="" ? "${param.openFromUC}":"${param.openFrom}";
</script>
<c:set var="openFromUc" value="${param.openFrom}"/>
<c:if test="${param.baseApp == 'null'}"><c:set var="baseApp" value=""/></c:if>
	<c:if test="${param.baseApp != 'null'}"><c:set var="baseApp" value="${param.baseApp }"/></c:if>
</head>
<body scroll="no" style="height:100%;">
	
	<iframe src="${mtMeetingURL}?method=mydetail&id=${param.id}&openfrom=${param.openfrom}&state=${param.state}&proxy=${param.proxy}&proxyId=${param.proxyId}&eventId=${param.eventId}&affairId=${affairId}&isQuote=${param.isQuote}&baseObjectId=${param.baseObjectId}&senderId=${param.senderId}&dealerId=${dealerId}&isColl360=${param.isColl360}&isCollCube=${param.isCollCube}&baseApp=${baseApp}&openFromUc=${param.openFrom}&fromPage=${param.from}" name="mtFrame" frameborder="0" height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
</body>
</html>