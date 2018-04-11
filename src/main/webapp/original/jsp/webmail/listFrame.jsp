<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%-- 写到header.jsp中去 --%>
<%@ include file="webmailheader.jsp" %>
</head>
<frameset rows="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request) ? '35%,*' : '*'}" id='sx' cols="*" framespacing="0" frameborder="no" border="0" >
  <frame frameborder="0" src="${webmailURL}?method=${method}" name="listFrame" scrolling="no" id="listFrame"/>
  <c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
  <frame frameborder="0" src="<c:url value='/common/detail.jsp?direction=Down' />" name="detailFrame" id="detailFrame" scrolling="no" />
  </c:if>
</frameset>
<noframes><body scroll='no'>
</body>
</noframes>
</html>