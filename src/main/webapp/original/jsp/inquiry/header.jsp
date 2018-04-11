<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/inquiry" prefix="inquiry"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/inquiry.do" var="detailURL" />
<html:link renderURL="/inquirybasic.do" var="basicURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/{pageContext.request.contextPath}/apps_res/inquiry/preview.jsp" var="previewURL" />
<html:link renderURL="/{pageContext.request.contextPath}/apps_res/inquiry/merge.jsp" var="merge" />
<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingUrl" />
<html:link renderURL="/edocController.do" var="edocDetailURL"/>
<html:link renderURL="/doc.do" var="docURL" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/bbs/css/bbs.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/apps_res/bulletin/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/inquiry/js/inquiry.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/inquiry/i18n");
v3x.loadLanguage("/apps_res/bulletin/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;   
var jsColURL = "${colDetailURL}";
var docURL = "${docURL}";
var edocDetailURL = "${edocDetailURL}";
var mtMeetingUrl = "${mtMeetingUrl}";
var colURL = "${colURL}";
//-->
</script>