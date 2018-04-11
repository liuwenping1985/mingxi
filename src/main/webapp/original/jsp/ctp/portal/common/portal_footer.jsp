<%--
 $Author: wangwy $
 $Rev: 2 $
 $Date:: 2010-01-29 19:12:44#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@page import="com.seeyon.ctp.util.Strings"%>
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
    String language= locale.getLanguage().toLowerCase();
    String country= locale.getCountry().toLowerCase();
    String localeLowerCase= language;
    if(Strings.isNotBlank(country)){
    	localeLowerCase += "-"+country;
    }
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

<script type="text/javascript" src="/seeyon/common/js/index_i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%
    if (isDevelop) {  //isDevelop
%>
<script type="text/javascript" src="/seeyon/common/js/ui/calendar/calendar-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/Moo-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/jsonGateway-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.json-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.fillform-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.jsonsubmit-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/v3x-debug.js${ctp:resSuffix()}"></script>
<!--seeyonUI start-->
<script type="text/javascript" src="/seeyon/common/js/seeyon.ui.core-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.dialog-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.menu-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.progress-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.arraylist-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.peopleCrad-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.projectTaskDetailDialog-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/jquery.slide.js${ctp:resSuffix()}"></script>
<!--seeyonUI end-->
<script type="text/javascript" src="/seeyon/common/js/jquery.comp-debug.js${ctp:resSuffix()}"></script>
<%
    } else {
%>
<script type="text/javascript" src="/seeyon/decorations/js/decorations-min.js${ctp:resSuffix()}"></script>
<%
    }
%>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="/seeyon/main.do?method=headerjs&login=${loginTime}"></script>
<script type="text/javascript">
//从seeyon.ui.checkform-debug.js中提取的几个函数
function isANumber(value) {
    if (typeof value == "string") {
        value = value;
    }
    return /^[-+]?\d+([\.]\d+)?$/.test(value);
}
function isNull(value, notTrim) {
    if (value == null) {
        return true;
    } else if (typeof (value) == "string") {
        value = notTrim == true ? $.trim(value) : value;
        if (value == "") {
            return true;
        }
    }
    return false;
}
var invalid = [];
$._invalidObj = function(obj) {
if (obj)
  invalid.push(obj);
invalid.contains(obj);
};

$._isInValid = function(obj) {
if(invalid.contains){
  return invalid.contains(obj);
}
return null;
};
$.isNull = isNull;
$.isANumber = isANumber;
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
<script type="text/javascript" src="/seeyon/common/js/portal_ajax.js?v=<%=com.seeyon.ctp.common.SystemEnvironment.getServerStartTime()%>"></script>
<script type="text/javascript">
<!--
var decoration = "${decoration.id}";
try{
  var uri = location.href;
  //getA8Top().contentFrame.topFrame.focusSpaceButton(uri);
}
catch(e){
}

var contextPath = "<%=ctxPath%>";
var v3x = new V3X();
v3x.init(contextPath, "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;

var isA8geniusAdded;
try{
  var ufa = new ActiveXObject("UFIDA_IE_Addin.Assistance");
  isA8geniusAdded = true;
}catch(e){
  isA8geniusAdded = false;
}
var downloadURL = "/seeyon/fileUpload.do?type=0&applicationCategory=1&extensions=jpeg,gif,png,bmp,jpg&maxSize=&isEncrypt=true&popupTitleKey=&isA8geniusAdded=" + isA8geniusAdded;

$(function(){
  if($.browser.safari){
    $("body,html").height("");
  }
});
//-->
</script>
</head>
<body style='height:100%;overflow:hidden;background:none;' onload="initPortalLayout()">
<div class='portalScrollMask hidden'></div><div class="main_div_center"><div class="right_div_center"><div id="right_div_portal_sub" class="center_div_center">
<link rel="stylesheet" href="/seeyon/decorations/css/portal_default_main_all-min.css?V=V6_1_2017-05-09">
<%
    if (isDevelop) {  //isDevelop
%>
<script type="text/javascript" src="/seeyon/common/js/i18n/zh-cn.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/section.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/portal-common.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/jquery.metadata.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/space.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/jquery-ui.custom.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/decorations/js/spacedd.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.tab-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/memberMenu.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/apps_res/v3xmain/js/guestbook.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<%
    } else {
%>
<script type="text/javascript" src="/seeyon/decorations/js/portal_<%=localeLowerCase%>_main_all-min.js?V=V6_1_2017-05-09"></script>
<%
    }
%>