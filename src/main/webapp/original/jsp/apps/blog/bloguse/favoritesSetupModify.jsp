<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
</head>
<frameset rows="10,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frame src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
  <frame noresize="noresize" frameborder="no" src="${detailURL}?method=oldFavorites&id=${param.id}&viewFlag=${param.viewFlag}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html> 


