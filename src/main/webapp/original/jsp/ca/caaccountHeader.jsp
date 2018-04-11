<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../common/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ca.caaccount.resources.i18n.CAAccountResources" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css${v3x:resSuffix()}" />">    
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">

<html:link renderURL="/caAccountManagerController.do" var="caacountURL" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

<script type="text/javascript">

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/organization/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/edoc/js/i18n");
v3x.loadLanguage("/apps_res/ca/js/i18n");
var caacountURL='${caacountURL}';
var organizationCancale = "<c:url value='/common/detail.html'/>";

</script>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources" var="ldaplocale"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/organization/js/organization.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8"src="<c:url value="/apps_res/ca/js/ca.js${v3x:resSuffix()}" />"></script>