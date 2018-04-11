<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="edocHeader.jsp"%>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
</head>
<body style="overflow:hidden;">
<iframe src="<html:link renderURL='/edocController.do?method=wendanTaohong&summaryId=${summaryId}&tempContentType=${tempContentType}' />" style="width:100%;height: 100%;scroll:no;border-bottom-width: 0px;border-top-width: 0px;border-left-width: 0px;border-right-width: 0px;"></iframe>
</body>
</html>
