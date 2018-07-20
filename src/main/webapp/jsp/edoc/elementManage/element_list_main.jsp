<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.edoc.manager.EdocRoleHelper"%>
<%@include file="../edocHeader.jsp" %>
<html>
<head>
<script type="text/javascript">
<!--
    var menuKey="1508";
    var isGroupManager=<%=EdocRoleHelper.isGroupManager()%>;
    showCtpLocation("F07_edocSystem1");
//-->
</script>
</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="45%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${edocElement}?method=list&id=${param['id']}&condition=${param.condition}&statusSelect=${param.statusSelect}" name="listFrame" scrolling="yes" id="listFrame" />
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>