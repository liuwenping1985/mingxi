<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datePatternOrg" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL='/genericController.do' var="genericController" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css" />">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css" />">    
<script type="text/javascript" src="<c:url value="/common/js/V3X.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/prototype.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css" />" type="text/css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css" />">

<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/plugin/u8/js/i18n");
var organizationURL = "<html:link renderURL='/organization.do' />";
var genericURL = "${genericController}?ViewPage=";
var organizationCancale = "<c:url value='/common/detail.html' />";

function canDoUserMapper(userid){
	var requestCaller = new XMLHttpRequestCaller(this, "U8SynchronController", "canDoUserMapper", false);
	if(userid!=null){
	    requestCaller.addParameter(1, "String", userid);
	}
	var org = requestCaller.serviceRequest();
	//alert(org);
	return org;
}
</script>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="locale"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.data.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/organization.do" var="organizationURL"/>    
<html:link renderURL="/u8OrgController.do" var="urlNCSynchron" />
<html:link renderURL="/u8FilderController.do" var="u8FilderSynchron" />    
                                
<script type="text/javascript" src="<c:url value="/common/js/xtree/xtree.js"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css" />">
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrganizationIl8n"/>
<fmt:setBundle basename="com.seeyon.apps.u8.i18n.U8Resources"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link href="${pageContext.request.contextPath}/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico" type="image/x-icon" rel="icon"/>