<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.agent.resources.i18n.AgentResource"/>
<html:link renderURL="/agent.do" var="detailURL" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
function reFlesh(){
	window.location.href = window.location.href;
}
</script>
${v3x:showAlert(pageContext)}
</head>
<frameset rows="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request) ? '35%,*' : '*'}" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
  <frame frameborder="no" src="${detailURL}?method=list&accountId=${accountId}" name="listFrame" scrolling="no" id="listFrame" frameborder="no" />
  <c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
  	<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no" />
  </c:if>
</frameset>
<noframes>
<body scroll='no'></body>
</noframes>
</html>