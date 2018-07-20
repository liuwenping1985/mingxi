<%--
 $Author: wangwy $
 $Rev: 13072 $
 $Date:: 2014-06-04 19:29:23#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
$.ctx.plugins = <c:out value="${_JSON_PLUGIN}" default="null" escapeXml="false"/>;
$.ctx.resources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
$.ctx.customize = <c:out value="${CurrentUser.customizeJsonStr}" default="null" escapeXml="false"/>;
$.ctx.CurrentUser = <c:out value="${CurrentUser.userInfoJsonStr}" default="null" escapeXml="false"/>;
var enu = <%=com.seeyon.ctp.common.code.EnumsConfigLoader.getEnumJSON() %>;
var v3x = new V3X();
v3x.init(_ctxPath, '<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>');
$.v3x = v3x;
$.content = {
    callback : {}
};
//取消遮罩
try{
  if(getCtpTop() && getCtpTop().endProc)getCtpTop().endProc();
}catch(e){}