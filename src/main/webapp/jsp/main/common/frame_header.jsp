<%--
 $Author: maxc $
 $Rev: 8002 $
 $Date:: 2013-06-17 16:39:04#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.apps.agent.utils.AgentUtil"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.flag.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="main" uri="http://v3x.seeyon.com/taglib/main"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%
response.setDateHeader("Expires",-1);
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
%>
<%
boolean isNeedMetaCompatible = request.getAttribute("isNeedMetaCompatible") == null ? true : (Boolean)request.getAttribute("isNeedMetaCompatible");
String browserString=BrowserEnum.valueOf1(request);
if(!isNeedMetaCompatible){
   if(browserString == "IE11"||browserString == "IE9"||browserString == "IE7"||browserString == "IE10"){
%>
    <META http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<%
    } else {
%>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
    }
}
%>
<%
 BrowserEnum browser=BrowserEnum.valueOf(request);
if(isNeedMetaCompatible){
   if(browser == BrowserEnum.IE11){
%>
    <META http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<%
    } else {
%>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
    }
}
%>
<META HTTP-EQUIV="pragma" CONTENT="no-cache" /> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-store, must-revalidate" /> 
<META HTTP-EQUIV="expires" CONTENT="-1" />
<%
    Locale locale = AppContext.getLocale();
    boolean isDevelop = AppContext.isRunningModeDevelop();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set value="${ctp:currentUser().userSSOFrom}" var="topFrameName" />
<script type="text/javascript">
  var _locale = '<%=locale%>';
  var _ctxPath = '${path}';
  var _isDevelop = <%=isDevelop%>;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <%-- 是否从致信那边进入协同 --%>
  var openFrom = "${ctp:escapeJavascript(openFrom)}";
</script>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%
    if (isDevelop) {
%>
<script type="text/javascript" src="${path}/common/js/V3X.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.hotkeys-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/seeyon.ui.core-debug.js${ctp:resSuffix()}"></script>

<script type="text/javascript" src="${path}/common/js/misc/Moo-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/misc/jsonGateway-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.json-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.fillform-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.jsonsubmit-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.autocomplete-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.code-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.dialog-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.progress-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.arraylist-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.checkform-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tooltip-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.timeLine-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.scrollbar-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.projectTaskDetailDialog-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/BaseMessage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/onlinemessage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/imMessage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/openMessage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/Message.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/message/sectionMappingLinkType.js${ctp:resSuffix()}"></script>
<%-- 选人界面缓存 --%>
<script type="text/javascript" src="${path}/common/SelectPeople/js/orgDataCenter.js${ctp:resSuffix()}"></script>
<%-- 时间轴JS --%>
<script type="text/javascript" src="${path}/apps_res/calendar/js/showTimeLineData.js${ctp:resSuffix()}"></script>
<%-- 文档打开  --%>
<script type="text/javascript" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/frame-ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/skinChange.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/timeline.js${ctp:resSuffix()}"></script>

<script type="text/javascript" src="${path}/common/collaboration/collShowSummary.js${ctp:resSuffix()}"></script>
<%
    } else {
%>
<script type="text/javascript" src="${path}/main/common/js/frame-min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.projectTaskDetailDialog-debug.js${ctp:resSuffix()}"></script>
<%
    }
%>
<script type="text/javascript" src="${path}/messageLinkConstants.js${ctp:resSuffix()}"></script>
<%-- <script type="text/javascript" src="${path}/main/common/js/ConvertPinyin.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/spotlight.js${ctp:resSuffix()}"></script> --%>
<script type="text/javascript">
  $.ctx = {};
  $.ctx.customize = <c:out value="${CurrentUser.customizeJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.CurrentUser = <c:out value="${CurrentUser.userInfoJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.menu = <c:out value="${CurrentUser.menuJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.space = <c:out value="${CurrentUser.spaceJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.template = <c:out value="${CurrentUser.templatesJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.shortcut = <c:out value="${CurrentUser.shortcutsJsonStr}" default="null" escapeXml="false"/>;
  $.ctx.concurrentAccount = <c:out value="${CurrentUser.concurrentAccountJsonStr}" default="null" escapeXml="false"/>;
  <%-- 是否admin --%>
  var isCurrentUserAdmin = "${CurrentUser.admin}";
  <%-- 验证登录验证类名--%>
  var loginAuthentication="${loginAuthentication}";
   <%-- 是否需修改密码--%>
  var pwd_needUpdate="${pwd_NeedUpdate}";
  <%--获取密码强度--%>
  var PwdStrengthValidationValue="${PwdStrengthValidationValue}";
  <%--获取登陆时密码的强度--%>
  var power="${power}";
  <%-- 是否集团管理员 --%>
  var isCurrentUserGroupAdmin = "${CurrentUser.groupAdmin}";
  <%-- 是否单位管理员 --%>
  var isCurrentUserAdministrator = "${CurrentUser.administrator}";
  <%-- 是否超级管理员 --%>
  var isCurrentUserSuperAdmin = "${CurrentUser.superAdmin}";
  <%-- 是否系统管理员 --%>
  var isCurrentUserSystemAdmin = "${CurrentUser.systemAdmin}";
  <%-- 是否审计管理员 --%>
  var isCurrentUserAuditAdmin = "${CurrentUser.auditAdmin}";
  <%-- 头像地址 --%>
  var memberImageUrl = "${ctp:avatarImageUrl(CurrentUser.id)}";  
  var currentSpaceForNC = "${currentSpaceForNC}";  
  var isAdmin = "${CurrentUser.admin}";
  <%-- 换肤变量 --%>
  var skinPathKey = "${skinPathKey}";
  var resSuffix = "${ctp:resSuffix()}";
  <%-- 字体变量 --%>
  var font_size = "${CurrentUser.fontSize}";
  <%-- 显示产品导航  --%>
  var productVersion = "${ctp:getSystemProperty('portal.porletSelectorFlag')}";
  var productAbout = "${ctp:getSystemProperty('portal.about')}";
  var systemProductId = "${ctp:getSystemProperty('system.ProductId')}";
  var isProductViewRefresh = "${isRefresh}";
  var hasPluginUC = "${ctp:hasPlugin('uc')}";
  var logoutConfirm_I18n = "${ctp:i18n('system.logout.confirm')}";
  <%-- 换肤组件切换首页模版后默认显示换肤组件 --%>
  var showSkinchoose = "${ctp:escapeJavascript(showSkinchoose)}";
  <%-- 集团/单位管理员是否刚切换过布局（尚未保存到数据库） --%>
  var isPortalTemplateSwitching = "${ctp:escapeJavascript(isPortalTemplateSwitching)}";
  <%-- 是否具有发送手机短信的权限 --%>
  var isCanSendSMS = "${isCanSendSMS}";  
  <%-- 是否需要播放声音 --%>
  var isEnableMsgSound = <c:out value="${isEnableMsgSound}" default="false" />;
  <%-- 消息查看后是否关闭 --%>
  var msgClosedEnable = <c:out value="${msgClosedEnable}" default="false" />;
  <%-- 判断是否显示公文数据 --%>
  var isShowEdoc = "${v3x:getSysFlagByName('edoc_notShow')}";
  <%-- 判断是否显示薪资查看 --%>
  var isShowSalary = "${v3x:getSysFlagByName('hr_showSalary')}";
  
  var message_header_system_label = "${ctp:i18n('message.header.system.label')}";
  var message_header_person_label = "${ctp:i18n('messageManager.count.person')}";
  var message_person_reply_label = "${ctp:i18n('message.person.reply.label')}";
  var message_header_unit_label = "${ctp:i18n('message.header.unit.label')}";
  var message_header_close_alt = "${ctp:i18n('message.header.close.alt')}";
  var message_header_max_alt = "${ctp:i18n('message.header.max.alt')}";
  var message_header_mini_alt = "${ctp:i18n('message.header.mini.alt')}";
  var message_header_more_alt = "${ctp:i18n('message.header.more.alt')}";
  
  <%-- 添加"匿名"发起者名称作为全局变量 --%>
  var ANNONYMOUS_NAME = "${ctp:i18n('annonymous_name')}";

  var v3x = new V3X();
  v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
  v3x.loadLanguage("/apps_res/agent/js/i18n");  
  var indexErr = "${ctp:i18n('index.input.error')}";
  
  var isPwdExpirationInfoNotEmpty = ${!empty pwdExpirationInfo};
  var isPwdExpirationInfo1Empty = ${empty pwdExpirationInfo[1]};
  var isNotPersonModifyPwd = ${!personModifyPwd};
  var datePwd = "";
  <c:if test="${not empty pwdExpirationInfo[1]}" >
  datePwd = "${ctp:formatDateTime(pwdExpirationInfo[1])}";
  </c:if>
  <% 
  //代理判断
  boolean hasAgent = AgentUtil.hasAgentInfo();
  pageContext.setAttribute("hasAgent", hasAgent);
  String agentInfo = AgentUtil.agentSettingAlert();
  if (agentInfo != null && !"".equals(agentInfo)) {
      String info[] = agentInfo.split("::");
      pageContext.setAttribute("message", info[0]);
      pageContext.setAttribute("ids", info[1]);
  }
  %>
  var messageForAgentAlert = "${ctp:urlEncoder(message)}";
  var idsForAgentAlert = "${ids}";
  var isMessageForAgentAlertNotEmpty = ${not empty message};
  var isIdsForAgentAlertNotEmpty = ${not empty ids};
  var requestSchemeServerName = "<%=request.getScheme()%>://<%=com.seeyon.ctp.util.Strings.getServerName(request)%>";
  var requestServerPort = "<%=request.getServerPort()%>";
  var currentUserLoginName = "${ctp:escapeJavascript(CurrentUser.loginName)}";
  var currentUserName = "${ctp:escapeJavascript(CurrentUser.name)}";
  <%
  String sessionId = session.getId();
  Cookie[] cookie = request.getCookies();
  for(int i = 0; i < cookie.length; i++)
  {
      if(cookie[i].getName().trim().equalsIgnoreCase("JSESSIONID"))
      {
          sessionId = cookie[i].getValue().trim();
          break;
      }
  }
  %>
  var sessionId = "<%=sessionId%>";
  var currentSessionId = "<%=session.getId()%>";
  var geniusVersion_sysProperty = "${ctp:getSystemProperty('genius.version')}";
  var systemHelp_sysProperty = "${ctp:getSystemProperty('system.help')}";
  var currentUserLocale = "${CurrentUser.locale}";
  var isTopFrameNameNotNull = "${topFrameName != null}";
  var browserFlagByUser = ${ctp:getBrowserFlagByUser("CloseWindowLogout", ctp:currentUser())};
  var currentPortalTemplate = "${ctp:escapeJavascript(portal_default_page)}";
  if(currentPortalTemplate == ""){
	  currentPortalTemplate = !$.ctx.customize.default_page ? "default" : $.ctx.customize.default_page;
  }
  if(pwd_needUpdate!=0){
	  $(document).off().on("keydown", function(event) {
	    var e = event || window.event;
	    if(e.keyCode==27||e.keyCode==116){ // esc 键
	    	window.event.keyCode=0;
	    	event.returnValue = false; 
	    	isDirectClose = false;  
	    	window.location.href = _ctxPath+"/main.do?method=logout";
	    }
	});
  }
  //解除键盘监视事件的绑定
  function cancelKeyDownEvent(){
	 	 $(document).off("keydown");
  }
</script>
<%--密码复杂度检测 --%>
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="${path}/common/js/jquery.comp-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/common/js/frame-common.js${ctp:resSuffix()}"></script>
<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="${path}/main/common/css/frame-common.css${ctp:resSuffix()}" />
<%-- <link rel="stylesheet" type="text/css" href="${path}/main/common/css/spotlight.css${ctp:resSuffix()}" /> --%>