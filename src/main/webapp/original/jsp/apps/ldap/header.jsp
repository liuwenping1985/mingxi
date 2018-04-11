<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datePatternOrg" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL='/genericController.do' var="genericController" />

<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css${v3x:resSuffix()}" />">    
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">

<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
</script>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="locale"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.data.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources" var="ldaplocale"/>

<html:link renderURL="/ldap.do" var="ldapSynchron" />                                     
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
