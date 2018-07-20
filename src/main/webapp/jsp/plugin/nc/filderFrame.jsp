<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<title><fmt:message key="nc.org.hand.account"/>--${v3x:toHTML(param.ncOrgCorpName)}--<fmt:message key="nc.syn.filter.title"/></title>
</head>
<frameset rows="*,1" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
	<frame src="${ncFilderSynchron}?method=viewBindingdepTree&ncOrgCorp=${param.ncOrgCorp}&ncOrgCorpName=${v3x:toHTML(param.ncOrgCorpName)}" name="listFrame" id="listFrame" frameborder="no" scrolling="no"/>
	
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>