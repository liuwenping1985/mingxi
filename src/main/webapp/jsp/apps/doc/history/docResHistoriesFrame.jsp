<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/doc/docHeaderOnPigeonhole.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.menu.history.label"/>:${param.docResName}</title>
</head>
<body  scroll='no' onkeydown="listenerKeyESC()" >
<IFRAME name="versionsFrame" id="versionsFrame" frameborder="0" width="100%" height="100%" 
	src="${detailURL}?method=listAllDocVersions&docResId=${param.docResId}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&isBorrowOrShare=${param.isBorrowOrShare}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&entranceType=${param.entranceType}"></IFRAME>
</body>
</html>