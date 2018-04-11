
</html> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<html>
<head>
</head>
<frameset rows="10,*" cols="*" framespacing="0" frameBorder="no" border="0" scrolling="no">
	<frame frameBorder="no" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
  <frame noresize="noresize" frameBorder="no" src="${detailURL}?method=newFavorites" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
</frameset>
<noframes>
	<body scroll='no'>
	</body>
</noframes>
</html>

