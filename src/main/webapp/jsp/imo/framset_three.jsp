<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="head.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>aa111</title>
</head>
<frameset rows="40,*" id='main' cols="*" framespacing="0" frameborder="no" border="0">
<frame src="${imoURL}?method=synchronOrg" frameborder="no"  name="menuFrame" id="menuFrame" scrolling="no" noresize="noresize"/>
	<frameset id="treeandlist" rows="*" cols="20%,*" framespacing="0" frameborder="yes" border="0">
	<frame src="${imoURL}?method=showLeftTree" name="treeFrame" id="treeFrame"  scrolling="yes"/>
	<frame src="${imoURL}?method=showAccountState" name="detailFrame" id="DetailFrame" scrolling="yes"/>
    </frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>