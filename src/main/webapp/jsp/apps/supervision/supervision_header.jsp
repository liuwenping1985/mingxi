<%--
 $Author: wangwy $
 $Rev: 2 $
 $Date:: 2010-01-29 19:12:44#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" href="${path}/common/supervision-all-min.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/skin/default/supervision-skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/common/css/dd.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/common/js/orgIndex/token-input.css${ctp:resSuffix()}" type="text/css" />