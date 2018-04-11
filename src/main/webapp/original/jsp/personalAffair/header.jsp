<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysMgrI18N" />
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}

<html:link renderURL="/systemopen.do" var="systemopenURL"/>
<html:link renderURL="/space.do" psml="default-page.psml" forcePortal="true" var="spacePortalURL"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<html:link renderURL='/personalAffair.do' var='personalAffairURL'/>
<html:link renderURL='/personalBind.do' var='personalBindURL'/>
<html:link renderURL='/main.do' var='mainURL'/>
<c:set value="${v3x:currentUser()}" var="currentUser"/>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");

var depId = ${currentUser.departmentId};

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/edoc/js/i18n");
_ = v3x.getMessage;

var systemPhraseURL = "<html:link renderURL='/phrase.do' />";

var currentUserId = "${currentUser.id}";
var currentUserName = "${v3x:toHTML(currentUser.name)}";
//-->
</script>