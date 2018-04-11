<%--
 $Author: wangwy $
 $Rev: 13072 $
 $Date:: 2014-06-04 19:29:23#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%if("true".equals(request.getAttribute("editor.enabled"))){%>
<%
	String ua = request.getHeader("User-Agent");
	String version = (ua.indexOf("MSIE 8.0")>0) || (ua.indexOf("MSIE 7.0")>0) ? "" : "45";
    // 防360，只要是windows10，就使用高版本
    if( ua.indexOf("Windows NT 10.0") >0 ){
        version = "45";
    }
%>
<script type="text/javascript"> var useHighVersionEditor = <%="45".equals(version)%>;</script>
<script type="text/javascript" src="/seeyon/common/ckeditor<%=version%>/ckeditor.js${ctp:resSuffix()}"></script>
<%}%>