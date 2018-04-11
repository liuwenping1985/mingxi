<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<title><fmt:message key='meeting.cmp.title'/></title>

<%
	//读取传递过来的其它参数
	String name = "";
	StringBuffer params = new StringBuffer();
	Enumeration paramKeys = request.getParameterNames();
	while(paramKeys.hasMoreElements()) {
  		name = paramKeys.nextElement().toString();
  		if("entry".equals(name) || "_spage".equalsIgnoreCase(name) || "method".equals(name) || "varTempPageController".equals(name)){continue;}
  			params.append("&").append(name).append("=").append(request.getParameter(name));
	}
	request.setAttribute("otherParams",params.toString());
%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
</head>
<body style="overflow: hidden;height: 100%;width: 100%;" scroll="no"  onload="onLoadLeft()" onunload="unLoadLeft()">

<iframe width="100%" height="100%" frameborder="no" src="${meetingNavigationURL}?method=${entry}${otherParams}&listType=${ctp:toHTML(param.listType)}&listMethod=${param.listMethod}&summaryId=${param.summaryId}&affairId=${ctp:toHTML(param.affairId)}&collaborationFrom=${ctp:toHTML(param.collaborationFrom)}&formOper=${ctp:toHTML(param.formOper)}&portalRoomAppId=${param.portalRoomAppId}&projectId=${param.projectId}&time=${param.time}" id="detailIframe" name="detailIframe" scrolling="no" class="page-list-border"></iframe>

</body>
</html>