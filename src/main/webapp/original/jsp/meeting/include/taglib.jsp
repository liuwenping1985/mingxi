<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<%-- 会议正文格式 --%>
<html:link renderURL="/mtContentTemplate.do" var="mtContentTemplateURL" />
<%-- 会议总结格式 --%>
<html:link renderURL="/mtSummaryTemplate.do" var="mtSummaryTemplateURL" />
<%-- 会议基础数据 --%>
<html:link renderURL="/mtAdminController.do" var="mtAdminController" />

<html:link renderURL="/mtSummary.do" var="mtSummaryURL" />

<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />

<html:link renderURL="/mtTemplate.do" var="mtTemplateURL" />

<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colURL" />

<c:set value="${pageContext.request.contextPath}" var="path" />

<c:url value="/common/detail.html" var="commonDetailURL" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.meeting.resources.i18n.MeetingResources"/>
<fmt:setBundle basename="com.seeyon.apps.videoconference.resource.i18n.VideoConferenceResources" var="v3xVideoConfI18n"/>

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<c:set var="datetimePattern" value="yyyy-MM-dd HH:mm" />
<c:set var="timePattern" value="HH:mm" />