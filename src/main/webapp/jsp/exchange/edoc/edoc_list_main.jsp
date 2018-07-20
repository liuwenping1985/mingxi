<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../exchangeHeader.jsp" %>
<script type="text/javascript">
<!--
<c:if test="${param.modelType eq 'outerAccount'}" >
showCtpLocation("F07_edocSystem1");
</c:if>
//-->
</script>
</head>
<c:set value="list" var="listMethod" />
<c:if test="${modelType=='outerAccount' }">
<c:set value="listOuterAccount" var="listMethod" />
</c:if>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${exchangeEdoc}?method=${listMethod }&id=${param['id']}&modelType=${v3x:toHTML(modelType)}&listType=${v3x:toHTML(param.listType)}" name="listFrame" id="listFrame" scrolling="no"/>
	<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
	</c:if>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>