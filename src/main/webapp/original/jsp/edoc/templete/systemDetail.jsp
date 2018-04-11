<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../edocHeader.jsp"%>
<title><fmt:message key="common.page.title" bundle="${v3xCommonI18N}" /></title>
</head>
<frameset rows="*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
  <frameset  rows="*" cols="*,45" framespacing="1" id="zy">
    <frame frameborder="no" src="${edocTempleteURL}?method=systemSummary&templeteId=${param.templeteId}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
    <frame frameborder="no" src="${edocTempleteURL}?method=systemWorkflow&templeteId=${param.templeteId}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
  </frameset>
</frameset>

<noframes><body scroll="no">
</body>
</noframes>

</html>