<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title><fmt:message key='bbs.boardmanager.boardManageauth.accredit'/></title>
</head>
<body scroll="no">
<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" src="${detailURL}?method=oldBoardAuth&boardId=${boardId}&authType=${param.authType}" name="detailMainFrame" scrolling="no"></iframe>
</body>
</html> 