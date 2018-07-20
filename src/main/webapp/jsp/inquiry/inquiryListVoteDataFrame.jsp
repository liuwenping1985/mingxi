<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<link rel="STYLESHEET" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
	<c:choose>
		<c:when test="${flag == 'hadVote'}"><fmt:message key="inquiry.voting.staff" /></c:when>
		<c:when test="${flag == 'noVote'}"><fmt:message key="inquiry.novoting.staff" /></c:when>
		<c:otherwise><fmt:message key="inquiry.officers.investigation" /></c:otherwise>
	</c:choose>
</title>
</head>
<body scroll="no" style="height: 100%">
	<iframe noresize src="${basicURL}?method=survey_listVoteData&bid=${param.bid}&flag=${flag}&semiAnonymous=${semiAnonymous}" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>	
</body>
</html>