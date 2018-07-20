<%@ page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<%-- 新闻类型 --%>
<html:link renderURL="/newsType.do" var="newsTypeURL" />
<%-- 新闻版面 --%>
<html:link renderURL="/newsTemplate.do" var="newsTemplateURL" />
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
