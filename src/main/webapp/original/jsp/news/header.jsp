<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp" %>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/news" prefix="news"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<%-- 新闻类型 --%>
<html:link renderURL="/newsType.do" var="newsTypeURL" />
<%-- 新闻查看、审核、管理、发布 --%>
<html:link renderURL="/newsData.do" var="newsDataURL" />
<html:link renderURL="/doc.do" var="docURL" />

<html:link renderURL="/collaboration/collaboration.do" var="colURL" />
<html:link renderURL="/edocController.do" var="edocDetailURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingUrl" />

<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" /><!-- guan lian File -->
<c:url value="/common/detail.jsp?direction=Down" var="commonDetailURL" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="inquiryI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.news.resources.i18n.NewsResource"/>

<!-- guan lian File -->
<script type="text/javascript">
var jsColURL = "${colDetailURL}";
var docURL = "${docURL}";
var mtMeetingUrl = "${mtMeetingUrl}";
var colURL = "${colURL}";
var edocDetailURL = "${edocDetailURL}";
</script>

<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/jquery-ui.custom.css${v3x:resSuffix()}" />">

<html:link renderURL='/genericController.do' var="genericController" />

<script type="text/javascript">
<!--
    var v3x = new V3X();
    v3x.init("<c:out value='${pageContext.request.contextPath}' />", "${v3x:getLanguage(pageContext.request)}");
    v3x.loadLanguage("/apps_res/bulletin/js/i18n");
    v3x.loadLanguage("/apps_res/news/js/i18n");
    _ = v3x.getMessage;

    var genericControllerURL = "${genericController}";
    
    var _baseApp = 8;
    var _baseObjectId = "${param.id}";
//-->
</script>
<link rel="stylesheet" href="/seeyon/skin/default/skin.css${v3x:resSuffix()}">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/prototype.js${v3x:resSuffix()}" />"></script>
<c:set var="path" value="${pageContext.request.contextPath}" />