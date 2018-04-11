<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html" %>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col" %>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N" />
<fmt:setBundle basename="com.seeyon.apps.videoconference.resource.i18n.VideoConferenceResources" var="v3xVideoConfI18n" />
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N" />

<c:set value="${pageContext.request.contextPath}" var="path" />

<html:link renderURL="/meeting.do" var="meetingURL" />
<html:link renderURL="/meetingSummary.do" var="meetingSummaryURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/mtSummary.do" var="mtSummaryURL" />
<html:link renderURL="/mtTemplate.do" var="mtTemplateURL" />
<html:link renderURL='/meetingroom.do' var='meetingRoomURL' />
<html:link renderURL="/meetingNavigation.do" var="meetingNavigationURL" />
<html:link renderURL="/mtContentTemplate.do" var="mtContentTemplateURL" />
<html:link renderURL="/mtSummaryTemplate.do" var="mtSummaryTemplateURL" />
<html:link renderURL="/mtAdminController.do" var="mtAdminController" />
<html:link renderURL='/meetingroom.do' var='mrUrl' />

<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/doc.do" var="pigeonholeDetailURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colURL" />

<c:url value="/common/detail.html" var="commonDetailURL" />

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}" />
<c:set var="datetimePattern" value="yyyy-MM-dd HH:mm" />
<c:set var="timePattern" value="HH:mm" />

<c:set value="${ctp:hasPlugin('videoconference') }" var="hasVideoConferencePlugin" />
<c:set value="${ctp:hasPlugin('doc') }" var="hasDocPlugin" />
<c:set value="${ctp:hasPlugin('edoc') }" var="hasEdocPlugin" />
<c:set value="${ctp:hasPlugin('collaboration') }" var="hasColPlugin" />
<c:set value="${ctp:hasPlugin('pubResource') }" var="hasPubRsourcePlugin" />
<c:set value="${ctp:getSystemProperty('meeting.type') }" var="hasMeetingType" />
<c:set value="${ctp:getSystemProperty('meeting.left') }" var="hasMeetingLeft" />
<c:set value="${ctp:getSystemProperty('meeting.leader') }" var="hasMeetingLeader" />
<c:set value="${ctp:getSystemProperty('meeting.room.app') }" var="hasMeetingRoomApp" />

<c:set value="<%= ApplicationCategoryEnum.meeting.key() %>" var="AppKey_Meeting" />
