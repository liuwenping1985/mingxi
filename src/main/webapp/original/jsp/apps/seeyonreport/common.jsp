<%--
 $Author: wuym $
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
<!DOCTYPE html>
<%-- 解决360兼容问题 --%>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%-- common_header.jsp内容 --%>
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
<%--common_footer.jsp内容 --%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    boolean isDevelop = AppContext.isRunningModeDevelop();
	String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + com.seeyon.ctp.util.Strings.getServerName(request) + ":"
        + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <c:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </c:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
  var systemfileUploadmaxsize="${ctp:getSystemProperty("fileUpload.image.maxSize")}";
</script>

<script type="text/javascript" src="/seeyon/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%@ include file="/WEB-INF/jsp/common/editor_js.jsp"%>
<%
    if (isDevelop) {
%>

<script type="text/javascript" src="/seeyon/common/js/ui/calendar/calendar-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.json-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.fillform-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.jsonsubmit-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.hotkeys-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.ajaxgridbar-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.code-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/common-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/seeyon.ui.core-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.comp.lbs-debug.js"></script>
<!--seeyonUI start-->
<script type="text/javascript" src="/seeyon/common/js/ui/searchBox-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.checkform-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.dialog-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.grid-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.layout-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.menu-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.progress-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.tab-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.toolbar-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.tree-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.calendar-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.tooltip-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.common-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.comLanguage-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.print-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.shortCutSet-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.colorPanel-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.peopleCrad-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.projectTaskDetailDialog-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.zsTree-debug.js"></script>
<!--seeyonUI end-->
<script type="text/javascript" src="/seeyon/common/js/jquery.comp.lbs-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.comp-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.tree-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.autocomplete-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.dd-debug.js"></script>
<%
    } else {
%>
<script type="text/javascript" src="/seeyon/common/all-min.js${ctp:resSuffix()}"></script>
<%
    }
%>
<script type="text/javascript" src="/seeyon/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript">
var addinMenus = new Array();
<c:forEach var="addinMenu" items="${AddinMenus}" varStatus="status">
    var index = ${status.index};
    addinMenus[index] = {pluginId : '${addinMenu.pluginId}',name : '${addinMenu.label}',className : '${addinMenu.icon}',click : '${addinMenu.url}'};
</c:forEach>

$.ctx._currentPathId = '${_currentPathId}';
$.ctx._pageSize = ${ctp:getSystemProperty("paginate.page.size")};

$.ctx._emailShow = ${v3x:hasPlugin("webmail")}; 
$.ctx.fillmaps = <c:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
<c:if test="${fn:length(EXTEND_JS)>0}">

$(document).ready(function() {
    $(window).load(function() {
        <c:forEach var="js" items="${EXTEND_JS}">
            $.getScript("/seeyon/${js}");
        </c:forEach>
    });
});
</c:if>
$.releaseOnunload();
</script>
<script type="text/javascript" src="/seeyon/ajaxStub.js?v=<%=com.seeyon.ctp.common.SystemEnvironment.getServerStartTime()%>"></script>
<script type="text/javascript" src="/seeyon/common/image/jquery.touchTouch-debug.js${ctp:resSuffix()}"></script>