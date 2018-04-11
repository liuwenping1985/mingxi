<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset  rows="*"  border="5" frameBorder="1"  bordercolor="#ececec">
<frameset id="treeandlist" rows="*" cols="20%,*">
	<frame frameborder="0" src="${metadataMgrURL}?method=metadataTree" name="treeFrame" scrolling="yes" id="treeFrame"/>
	<frameset id="sx" rows="35%,*" framespacing="0" frameborder="yes" border="0" scrolling="no">
	    <frame frameborder="0" src="${metadataMgrURL}?method=metadataList" name="listFrame" scrolling="no" id="listFrame" />
	    <frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="0" scrolling="no"/>
	</frameset>
</frameset>
</frameset>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>