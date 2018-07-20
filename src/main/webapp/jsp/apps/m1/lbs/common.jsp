<%--
 $Author: wuym $
 $Rev: 2 $
 $Date:: 2010-01-29 19:12:44#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="cc" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", 0);
	boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<!DOCTYPE html>
<cc:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  <cc:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </cc:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
</script>
<link rel="stylesheet" href="${path}/common/all-min.css${ctp:resSuffix()}">
<cc:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css${ctp:resSuffix()}">
</cc:if>
<cc:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css${ctp:resSuffix()}">
</cc:if>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%
    if (isDevelop) {
%>
<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.hotkeys-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.json-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.fillform-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.jsonsubmit-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.autocomplete-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.code-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/common-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/seeyon.ui.core-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.ajaxgridbar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.base64-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/searchBox-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.checkform-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.dialog-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.contextmenu-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.grid-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.layout-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.menu-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.progress-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tab-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.toolbar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tree-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.calendar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tooltip-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.common-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.focusImage-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.projectList-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.scrollbar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.contextmenu-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.comLanguage-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.print-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.shortCutSet-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.colorpicker-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.pageMenu-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.peopleCrad-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.peopleSquare-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.channel-debug.js"></script>

<script type="text/javascript" src="${path}/common/js/jquery.comp-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.tree-debug.js"></script>
<%
    } else {
%>
<script type="text/javascript" src="${path}/common/all-min.js${ctp:resSuffix()}"></script>
<%
    }
%>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<cc:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="${path}/main.do?method=headerjs&login=${loginTime}"></script>
<script type="text/javascript">
$.ctx._currentPathId = '${_currentPathId}';
$.ctx.fillmaps = <cc:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
<cc:if test="${fn:length(EXTEND_JS)>=0}">
// 保证扩展的js最后执行
$(document).ready(function() {
    $(window).load(function() {
        <cc:forEach var="js" items="${EXTEND_JS}">
            $.getScript("${path}/js/extend/${js}");
        </cc:forEach>
    });
});
</cc:if>
</script>
<script type="text/javascript" src="${path}/ajax.do?managerName=knowledgeFavoriteManager"></script>