<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title>${article.articleName}</title>
</head>
<body style="overflow:hidden;">
<iframe src="${detailURL}?method=showPostFrame&articleId=${param.articleId}&resourceMethod=${v3x:toHTML(param.resourceMethod)}&group=${v3x:toHTML(param.group)}&from=${v3x:toHTML(param.from)}&dept=${param.dept}&custom=${custom}&pageSizePara=${v3x:toHTML(param.pageSizePara)}&nowPagePara=${v3x:toHTML(param.nowPagePara)}&fromPigeonhole=${v3x:toHTML(param.fromPigeonhole)}&fromIsearch=${param.fromIsearch or param.from eq 'isearch'}&isCollCube=${v3x:toHTML(param.isCollCube)}" name="showPostFrame" id="showPostFrame" frameborder="0" height="100%" width="100%" scrolling="auto" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
