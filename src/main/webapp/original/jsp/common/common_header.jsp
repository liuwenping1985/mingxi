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

<%
    Locale _language_ = AppContext.getLocale();
    String editorNames = AppContext.getSystemProperty("editor.FontNames");
%>

<script type="text/javascript">
  var _language = '<%=_language_%>';
</script>
<input type="hidden" id="fontNames" name="fontNames" value="<%=editorNames%>">
<c:set var="path" value="${pageContext.request.contextPath}" />
<link href="/seeyon/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" href="/seeyon/common/all-min.css${ctp:resSuffix()}">
<c:if test="${CurrentUser.skin != null}">
    <link rel="stylesheet" href="/seeyon/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
    <link rel="stylesheet" href="/seeyon/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<link rel="stylesheet" href="/seeyon/common/css/peoplecard.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css"  href="/seeyon/common/css/dd.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css"  href="/seeyon/main/skin/frame/default/default_common.css${ctp:resSuffix()}">
<link rel="stylesheet" id="mainSkinCss" type="text/css"  href="${ctp:getUserDefaultCssPath()}">
<link rel="stylesheet" href="/seeyon/common/image/css/touchTouch.css${ctp:resSuffix()}">
<link href="/seeyon/common/css/select2.css${ctp:resSuffix()}" type="text/css" rel="stylesheet" />
