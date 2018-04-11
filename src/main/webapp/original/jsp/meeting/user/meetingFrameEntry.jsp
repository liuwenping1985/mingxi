<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>

<%
//读取传递过来的其它参数
String name="";
StringBuffer params=new StringBuffer();
Enumeration paramKeys= request.getParameterNames();
while(paramKeys.hasMoreElements())
{
  name=paramKeys.nextElement().toString();
  if("entry".equals(name) || "_spage".equalsIgnoreCase(name) || "method".equals(name) || "varTempPageController".equals(name)){continue;}
  params.append("&").append(name).append("=").append(request.getParameter(name));
}
request.setAttribute("otherParams",params.toString());
%>
<c:set value="${varTempPageController == null ? edoc : supervise}" var="tempCurrentController" />
</head>
<body style="overflow: hidden" scroll="no"  onload="onLoadLeft()" onunload="unLoadLeft()"><%-- xiangfan添加了 参数summaryId AffairId 等，修复协同转会议通知的问题GOV-3397 --%>
<iframe width="100%" height="100%" frameborder="no" src="${tempCurrentController}?method=${entry}${otherParams}&listType=${param.listType}&listMethod=${param.listMethod}&summaryId=${param.summaryId}&affairId=${param.affairId}&collaborationFrom=${param.collaborationFrom}&formOper=${param.formOper}" id="detailIframe" name="detailIframe" scrolling="no" class="page-list-border"></iframe>
</body>
</html>