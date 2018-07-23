<%@ page import="com.seeyon.v3x.meetingroom.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html" %>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources"/>
<fmt:setBundle basename="com.seeyon.v3x.meeting.resources.i18n.MeetingResources" var="v3xMeetingI18N"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}"/>"><%--xiangfan modify,use A8 Meari CSS --%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/js/menu/xmenu.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/meetingroom/meetingroom.css${v3x:resSuffix()}"/>">
<script type="text/javascript" charset="UTF-8" src="<c:url value='/common/js/menu/xmenu.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/common/js/V3X.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/meetingroom/meetingroom.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/collaboration/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/meetingroom/i18n");
//-->
</script>