<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<title></title>
</head>
<c:if test="${v3x:currentUser().groupAdmin}">
    <frameset id="treeandlist" rows="*" cols="20%,*" framespacing="5" frameborder="yes" bordercolor="#ececec">
        <frame src="${agentManagerURL}?method=showTree" name="treeFrame" frameborder="0" id="treeFrame" scrolling="no" />
        <frame src="${detailURL}?method=agentFrame" name="listFrame" frameborder="0" id="listFrame" scrolling="no" />
    </frameset>
</c:if>
<c:if test="${v3x:currentUser().administrator}">
    <frameset id="treeandlist" rows="*" cols="*" framespacing="5" frameborder="yes" bordercolor="#ececec">
        <frame src="${detailURL}?method=agentFrame" name="listFrame" frameborder="0" id="listFrame" scrolling="no" />
    </frameset>
</c:if>
<noframes>
    <body scroll="no"></body>
</noframes>
</html>