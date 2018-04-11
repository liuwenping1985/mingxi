<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp" %>
<title></title>
</head>
<frameset rows="40,*" id='main' cols="*" frameSpacing="5" frameBorder="yes">
	<frame src="${ipcontrolURL}?method=showMenu" frameborder="no" noresize="noresize" name="menuFrame" id="menuFrame" scrolling="no" />
	<c:if test="${v3x:currentUser().groupAdmin}">
	<frameset id="treeandlist"  rows="*" cols="20%,*" framespacing="5" frameborder="yes" bordercolor="#ececec">
		<frame src="${ipcontrolURL}?method=showTree" name="treeFrame" frameborder="0" id="treeFrame"  scrolling="no"/>
		<frame src="${ipcontrolURL}?method=listFrame" name="listFrame" frameborder="0" id="listFrame"  scrolling="no"/>
	</frameset>
	</c:if>
	<c:if test="${v3x:currentUser().administrator}">
		<frame src="${ipcontrolURL}?method=listFrame&accountId=${v3x:currentUser().loginAccount}" name="listFrame" frameborder="0" id="listFrame"  scrolling="no"/>
	</c:if>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>