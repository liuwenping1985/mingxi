<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body style="overflow: hidden" scroll="no" class="padding5">
	<div class="page-list-border">
		<iframe id="auditListIndex" name="auditListIndex" src="${newsDataURL}?method=entry&spaceType=${param.spaceType}&showAudit=true&spaceId=${param.spaceId}&newsTypeId=${newsTypeId}" style="width:100%;height: 99%;" frameborder="0">
		</iframe>
	</div>
</body>
</html>