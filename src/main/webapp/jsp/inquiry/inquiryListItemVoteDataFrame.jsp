<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<link rel="STYLESHEET" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="inquiry.view.poll" /></title>
</head>
<body scroll="no">
	<iframe noresize src="${basicURL}?method=survey_listItemVoteData&itemId=${param.itemId}" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>	
</body>
</html>