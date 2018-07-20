<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset rows="35%,*" id="sx" framespacing="3" frameborder="no" border="0" >
   	<frame src="${hrUserDefined}?method=initSpace&settingType=${param.settingType}" name="listFrame" scrolling="no" id="listFrame" />
    <frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="0" scrolling="no"/>
</frameset>
<noframes><body scroll="no"></body></noframes>
</html>