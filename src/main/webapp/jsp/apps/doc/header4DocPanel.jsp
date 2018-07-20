<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="docResource"/>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="organizations"/>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="localeI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.link.i18n.LinkResource" var="v3xLinkI18N"/>
<fmt:setBundle basename="www.seeyon.com.v3x.form.resources.i18n.FormResources" var="v3xFormI18N"/>

<html:link renderURL='/genericController.do' var="genericController" />

<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">

<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/systemmanager/css/css.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/partition.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/metadata.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/space.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/signet.js${v3x:resSuffix()}"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">
<html:link renderURL='/worksarea.do' var="workURL" />
<html:link renderURL="/space.do" var="spaceURL"/>
<html:link renderURL='/doc.do' var="docURL" />
<html:link renderURL="/space.do" psml="default-page.psml" forcePortal="true" var="spacePortalURL"/>
<html:link renderURL='/accountManager.do' var="accountManagerURL"/>
<html:link renderURL="/partition.do" var="partitionURL"/>
<html:link renderURL="/roleManage.do" var="roleURL"/>
<html:link renderURL="/plurality.do" var="pluralityURL"/>
<html:link renderURL="/mobileManager.do" var="mobileManagerURL"/>
<html:link renderURL="/menuManager.do" var="menuManagerURL"/>
<html:link renderURL="/metadata.do" var="metadataMgrURL" />
<html:link renderURL="/processLog.do" var="processLogURL"/>
<html:link renderURL="/signet.do"  var="signetURL"/>
<html:link renderURL="/lockedUserManager.do" var="lockedUserManagerURL"/>
<html:link renderURL="/ipcontrol.do" var="ipcontrolURL"/>
<html:link renderURL="/storeRule.do" var="storeRuleURL"/>
${v3x:skin()}

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/systemmanager/js/i18n");
v3x.loadLanguage("/apps_res/plugin/USBKey/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;
//-->
var partitionURL = "${partitionURL}";
var managerURL = "<html:link renderURL='/manager.do' />";
var signetURL = "${signetURL}";
var postURL = "<html:link renderURL='/post.do' />";
var spaceURL = "${spaceURL}";
var spacePortalURL = "${spacePortalURL}";
var distributeURL = "<html:link renderURL='/distribute.do'/>";
var pluralityURL = "<html:link renderURL='/plurality.do'/>";
var metadataURL = "${metadataMgrURL}";
var menuManagerURL = "${menuManagerURL}";
</script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/mobileManager.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/menuManager.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xmlextras.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xloadtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/plugin/USBKey/js/USBKeyManage.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/plugin/USBKey/js/IPInput.js${v3x:resSuffix()}" />"></script>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" />
<fmt:setBundle basename="com.seeyon.v3x.main.decorations.resources.i18n.DecorationsResources" var="decorationI18N"/>