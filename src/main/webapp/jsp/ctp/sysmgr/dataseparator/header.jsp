<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants" %>  
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@page import="com.seeyon.ctp.common.authenticate.domain.User"%>
<%@page import="com.seeyon.v3x.common.web.login.CurrentUser"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="v3xCollaborationI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/plan/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/systemmanager/css/css.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
//-->
</script>
<html:link renderURL="/messageManager.do" var="urlMessageManager" />