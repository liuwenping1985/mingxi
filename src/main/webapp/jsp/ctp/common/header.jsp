<%@ page isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<fmt:setBundle basename="com.seeyon.ctp.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>

<%-- TODO: 等相关模块移植后再开放此注释 <fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrgI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL='/individual.do' var="individualController" />
<html:link renderURL='/accountManager.do' var="accountManagerController" />
<html:link renderURL="/manager.do" var="managerController"/>
<html:link renderURL="/collaboration.do" var="colGeneralURL" />
<html:link renderURL="/edocController.do" var="edocGeneralURL" /> --%>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/v3x-debug.js" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
var genericControllerURL = "${genericController}";


var colGeneralURL = "${colGeneralURL}";
var edocGeneralURL =  "${edocGeneralURL}";
//-->
</script>
