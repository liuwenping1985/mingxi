<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
</head>
<body style="overflow: hidden" scroll="no" class="padding5">
	<iframe id="auditListIndex" name="auditListIndex" src="${bulDataURL}?method=entry&spaceType=${param.spaceType}&showAudit=true&spaceId=${param.spaceId}&bulTypeId=${bulTypeId}" style="width:100%;height: 99%;" frameborder="0"></iframe>
</body>
</html>