<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ page import="com.seeyon.v3x.common.constants.Constants" %>	
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@page import="com.seeyon.v3x.common.authenticate.domain.User"%>
<%@page import="com.seeyon.v3x.common.web.login.CurrentUser"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources" var="v3xAddressBookI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.calendar.resources.i18n.CalendarResources" var="v3xCalI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="orgI18N"/>

<%@ include file="../common/INC/noCache.jsp" %>
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/hr_common.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/util/URI.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
v3x.loadLanguage("/apps_res/addressbook/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;
var currentUserId = "${CurrentUser.id}";
var addressbookURL = "<html:link renderURL='/addressbook.do' />";
var skinCss = "<c:url value="${v3x:getSkin()}/skin.css" />";
//-->
</script>
<html:link renderURL="/addressbook.do" var="urlAddressBook" />
<html:link renderURL="/addressbook.do" var="addressbookURL" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/default.css${v3x:resSuffix()}" />">
<c:set var="leastSize" value="6"/>