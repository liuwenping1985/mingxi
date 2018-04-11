<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
	showCtpLocation('F12_perSalary');
//-->
</script>
</head>
<frameset rows="35%,*" cols="*" name="sx" id="sx" framespacing="0" frameborder="no" border="0">
	<frameset id="detailandlist" rows="40,*" framespacing="0" frameborder="no" border="0" scrolling="no">
		<frame frameborder="no" src="${urlHrViewSalary}?method=toolBar" name="toolbarFrame" id="toolbarFrame" scrolling="no" noresize="noresize" />
		<frame frameborder="no" src="${urlHrViewSalary}?method=viewData" name="listFrame" id="listFrame" scrolling="no" noresize="noresize" />
	</frameset>
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
		<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no" />
	</c:if>
</frameset>
<noframes>
	<body scroll="no"></body>
</noframes>
</html>