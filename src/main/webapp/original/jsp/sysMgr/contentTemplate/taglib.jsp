<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<%-- 会议正文格式 --%>
<c:url value="/contentTemplate.do" var="contentTemplateURL" />
<%-- 会议总结格式 --%>
<html:link renderURL="/mtSummaryTemplate.do" var="mtSummaryTemplateURL" />

<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />

<html:link renderURL="/mtTemplate.do" var="mtTemplateURL" />

<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/collaboration.do" var="colURL" />

<c:url value="/common/detail.jsp?direction=Down" var="commonDetailURL" />

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.contentTemplate.resources.i18n.ContentTemplateResources"/>

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<c:set var="datetimePattern" value="yyyy-MM-dd HH:mm" />
<c:set var="timePattern" value="HH:mm" />