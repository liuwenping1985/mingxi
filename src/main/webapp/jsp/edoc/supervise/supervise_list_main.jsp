<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
</script>
</head>
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${supervise}?method=list" name="listFrame" scrolling="no" id="listFrame" />
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
	<frame src="<c:url value="/common/detail.html" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</c:if>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>