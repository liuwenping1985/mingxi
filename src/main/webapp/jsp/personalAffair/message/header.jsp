<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.v3x.peoplerelate.resources.i18n.RelateResources" var="v3xRelateI18N" />
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.online.resource.i18n.WIMSynchronResources" var="wim"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/v3xmain/css/message.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<html:link renderURL="/message.do" var="messageURL"/>
<html:link renderURL="/online.do" var="onlineURL"/>
<c:set value="${v3x:currentUser()}" var="currentUser"/>
<c:set value="${currentUser.id}" var="currentUserId"/>
<c:set value="${v3x:toHTMLWithoutSpaceEscapeQuote(currentUser.name)}" var="currentUserName"/>
<script type="text/javascript">
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
var messageURL = "${messageURL}";
var onlineURL = "${onlineURL}";
var mainURL = "<html:link renderURL='/main.do'/>";
var genericControllerURL = "<html:link renderURL='/genericController.do' />";
var userLoginAccountId = "${v3x:currentUser().loginAccount}";
var hiddenSaveAsTeam_selDep = true;
var isNeedCheckLevelScope_selDep = false;
var onlyLoginAccount_selDep = false;
var showDeptPanelOfOutworker_selDep = true;

var currentUserId = "${currentUserId}";
var currentUserName = "${currentUserName}";
</script>
<script language="JavaScript" type="text/JavaScript" src="<c:url value="/apps_res/v3xmain/js/OnlineUser.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/jquery/themes/default/easyui.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/jquery/themes/icon.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.easyui.js${v3x:resSuffix()}" />"></script>