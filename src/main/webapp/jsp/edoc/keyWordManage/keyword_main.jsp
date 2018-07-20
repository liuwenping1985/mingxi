<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<html>
<head>
<script type="text/javascript">
showCtpLocation("F07_edocSystem1");
</script>
</head>
<frameset cols="22%,*"  border="5" frameBorder="1" framespacing="5"  bordercolor="#ececec">
    <frame src="${edocKeyWordUrl}?method=tree" name="treeFrame" frameborder="0" scrolling="no" id="treeFrame" />
    <frameset rows="35%,*" id='sx' cols="*" frameborder="0">
		<frame src="${edocKeyWordUrl}?method=list" name="listFrame" scrolling="no" id="listFrame" />
		<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" scrolling="no" id="detailFrame" />
	</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>