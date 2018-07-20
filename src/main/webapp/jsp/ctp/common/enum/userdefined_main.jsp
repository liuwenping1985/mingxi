<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<c:choose>
	<c:when test="${param.account=='account'}">
	<frameset id="treeandlist" rows="*" cols="24%,*" frameBorder="1" frameSpacing="5" bordercolor="#ececec">
		<frame frameborder="0" src="${metadataMgrURL}?method=userDefinedmetadataTree" name="treeFrame" scrolling="yes" id="treeFrame"/>
		<frameset id="sx" rows="35%,*" framespacing="0" frameborder="yes" border="0" scrolling="no">
		    <frame frameborder="0" src="${metadataMgrURL}?method=userDefinedmetadataList" name="listFrame" scrolling="no" id="listFrame" />
		    <frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="0" scrolling="no"/>
		</frameset>
	</frameset>
	</c:when>
	<c:otherwise>
		<frameset  rows="30,*" framespacing="0">
		<frame frameborder="0" src="${metadataMgrURL}?method=userDefinedtoobar" name="treeFrame" scrolling="no" id="toolbarFram" noresize="noresize"/>
		<frameset id="treeandlist" rows="*" cols="24%,*" frameBorder="1" frameSpacing="5" bordercolor="#ececec">
			<frame frameborder="0" src="${metadataMgrURL}?method=userDefinedmetadataTree" name="treeFrame" scrolling="yes" id="treeFrame"/>
			<frameset id="sx" rows="35%,*" framespacing="0" frameborder="yes" border="0" scrolling="no">
			    <frame frameborder="0" src="${metadataMgrURL}?method=userDefinedmetadataList" name="listFrame" scrolling="no" id="listFrame" />
			    <frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="0" scrolling="no"/>
			</frameset>
		</frameset>
		</frameset>
	</c:otherwise>
</c:choose>
<noframes>
<body scroll="no">
</body>
</noframes>
</html>