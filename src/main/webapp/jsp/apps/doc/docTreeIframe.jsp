<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="docHeader.jsp"%>
</head>
<frameset rows="25,*" id='sx' cols="*" framespacing="0" frameborder="no" border="1">
	<frame src="${detailURL}?method=docTreeLable" frameborder="no" noresize name="treeLable" id="treeLable" scrolling="NO">
	<frame src="${detailURL}?method=listRoots" frameborder="0" name="treeFrame" id="treeFrame">
</frameset>

</html>