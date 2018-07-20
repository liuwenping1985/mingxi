<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="headerbyopen.jsp" %>
<title><fmt:message key='common.toolbar.view.label' bundle='${v3xCommonI18N}'/></title>
</head>
<frameset rows="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	<frameset rows="350,0" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	  <frame frameborder="no" src="${mrUrl }?method=listView" name="listFrame" scrolling="auto" id="listFrame" />
	  <frame frameborder="no" src="${mrUrl }?method=viewByCalendar" name="detailFrame" id="detailFrame" scrolling="no" />
	</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>