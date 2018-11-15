<%--
 $Author: wuym $
 $Rev: 2 $
 $Date:: 2010-01-29 19:12:44#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = "http://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>';
  var _isDevelop = <%=isDevelop%>;
</script>

<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>