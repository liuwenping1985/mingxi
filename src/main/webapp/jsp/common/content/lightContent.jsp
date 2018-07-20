<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>

<%if(request.getParameter("isFullPage")!=null){ %>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta charset="utf-8">
<meta name="apple-touch-fullscreen" content="yes"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>
<meta content="telephone=no" name="format-detection" />
<script type="text/javascript" src="${ctp_contextPath}/common/form/lightForm/js/jquery-1.8.3.min.js"></script>
</head>
<body>
<section>
<%}%>

<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
    boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link href="${ctp_contextPath}/common/form/lightForm/css/light-form.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <c:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </c:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
  var style = "${style}";
</script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.checkform-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/ui/calendar/calendar-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.jsonsubmit-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/common-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.json-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="${ctp_contextPath}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<c:if test="${style==4}">
	<!--  这个js中的jquery库会和上面的jquery库冲突 先注释-->
	<%@ include file="/cmp/plugins/form/CMPFormAllInOne.jsp"%>
</c:if>
<c:if test="${style!=4}">
    <link href="${ctp_contextPath}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
    <link rel="stylesheet" href="${ctp_contextPath}/common/all-min.css${ctp:resSuffix()}">
    <c:if test="${CurrentUser.skin != null}"><link rel="stylesheet" href="${ctp_contextPath}/skin/${CurrentUser.skin}/skin.css${ctp:resSuffix()}"></c:if>
    <c:if test="${CurrentUser.skin == null}"><link rel="stylesheet" href="${ctp_contextPath}/skin/default/skin.css${ctp:resSuffix()}"></c:if>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.fillform-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.autocomplete-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.code-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.progress-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/seeyon.ui.core-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.tree-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.calendar-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.dialog-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/office/js/hw.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightForm/js/comp/seeyon.ui.selectPeople.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.comp.lbs-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightForm/js/lightFormComp4PC.js"></script>
</c:if>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/common/header_js.jsp"%>
</script>

<div id="mainbodyDiv" class="mainbodyDiv">
<%@ include file="/WEB-INF/jsp/common/content/include/include_variables.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_changeModel.jsp"%><%--切换查看模式区域--%>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_mainbody.jsp"%><%--正文区域--%>
</div>
    <c:if test="${contentCfg.useWorkflow}">
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" /><%--工作流相关--%>
    </c:if>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_html_hw.jsp"%><%--HTML签章相关--%>
    <%@ include file="/WEB-INF/jsp/common/content/include/include_content_js_end.jsp"%>
<%if(request.getParameter("isFullPage")!=null){ %>    
</section>  
</body>
</html>
<%}%>

