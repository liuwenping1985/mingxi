<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="spaceHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<frameset rows="40,*" name="sx1" id="sx1" framespacing="0" >
	<frame src="${spaceURL}?method=spaceMenu" id="thetop" name="thetop" scrolling="no" frameborder="0" noresize="noresize"/>
	<frameset id="treeFrameset" cols="22%,*" border="0" frameborder="1" framespacing="5" bordercolor="#ececec" >
    <frame src="${spaceURL}?method=spaceTree" name="treeFrame" scrolling="no" id="treeFrame"  frameborder="0"/>
    <frameset rows="35%,*" id='sx' framespacing="3" frameborder="no" border="0">
		<frame src="${spaceURL}?method=spaceList" id="main" name="main" scrolling="yes"/>
		<frame src="<c:url value='/common/detail.jsp?direction=Down'/>" name="bottom" scrolling="no" id="bottom" />
	</frameset>
  </frameset>
</frameset>

<noframes>
<body>
</body>
</html>