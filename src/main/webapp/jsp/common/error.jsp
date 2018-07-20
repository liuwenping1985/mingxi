<%--
 $Author: wangwy $
 $Rev: 17321 $
 $Date:: 2015-05-27 16:17:41#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" import="com.seeyon.ctp.common.AppContext" isELIgnored="false" isErrorPage="true"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%
response.setStatus(HttpServletResponse.SC_OK);
AppContext.initSystemEnvironmentContext(request, response, false);
%>
<!DOCTYPE html>
<html>
<head>
<title>异常处理页面</title>
<%
String msg = (String) request.getAttribute("THROWABLE_MESSAGE");
if(!"true".equals(request.getAttribute("THROWABLE_ISFULLPAGE")))
    // msg = msg==null?"":msg.replaceAll("<","&lt;").replaceAll(">","&gt;");
%>
<link rel="stylesheet" href="${path}/common/all-min.css">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
<script type="text/javascript">
if(parent && parent.errorHandle)
    parent.errorHandle("${ctp:escapeJavascript(THROWABLE_MESSAGE)}");
</script>
</head>
<body class="page_color">
    <%
        if ("false".equals(request.getAttribute("THROWABLE_ISALERT"))) {
            String eid = (String) request.getAttribute("THROWABLE_ID");
            String est = (String) request.getAttribute("THROWABLE_STACKTRACE");
    %>
    <font color='red'>${ctp:i18n('error.label')}(<font id="THROWABLE_ID"><%=eid%></font>):<font id="THROWABLE_MESSAGE">${ctp:toHTML(requestScope.THROWABLE_MESSAGE)}</font></font>&nbsp;
    <%  if(!AppContext.isRunningModeProduction()) { %>
    ${ctp:i18n('error.detail.label')}
    <textarea rows="15" style="width: 500; font-size: 10pt" readonly="readonly"><%=est%></textarea>
    <%  } %>
    <%
        } else {
    %>
    <%if(!"true".equals(request.getAttribute("THROWABLE_ISFULLPAGE"))){%>${ctp:i18n('error.message.label')}<%}%><%=msg%>
    <%
        }
    %>

</body>
</html>