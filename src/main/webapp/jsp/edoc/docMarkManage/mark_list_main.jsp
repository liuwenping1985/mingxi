<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<html>
<head>
<script type="text/javascript">

showCtpLocation("F07_edocSystem1");
//-->
</script>
</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${mark}?method=list&id=${param['id']}&companyId=${companyId}" name="listFrame" scrolling="yes" id="listFrame" />
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>