<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="head.jsp"%>
</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="65%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
  <frame frameborder="no" src="${imoURL}?method=autoSynchronList" name="listFrame" scrolling="no" id="listFrame" />
  <frame frameborder="no" src="${imoURL}?method=toAutoSynchron" name="detailFrame" id="detailFrame" scrolling="no" />
</frameset>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>