<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html" %>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html:link renderURL='/meetingroomList.do' var='mrListUrl' />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/meetingroom/meetingroom.css${v3x:resSuffix()}"/>">
<script type="text/javascript" charset="UTF-8" src="<c:url value='/common/js/menu/xmenu.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/common/js/V3X.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/meetingroom/meetingroom.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/include.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/meetingCommon.js${v3x:resSuffix()}" />"></script>

<c:set value="${ctp:hasPlugin('videoconference') }" var="hasVideoConferencePlugin" />
<c:set value="${ctp:hasPlugin('doc') }" var="hasDocPlugin" />
<c:set value="${ctp:hasPlugin('edoc') }" var="hasEdocPlugin" />
<c:set value="${ctp:hasPlugin('collaboration') }" var="hasColPlugin" />
<c:set value="${ctp:hasPlugin('pubResource') }" var="hasPubRsourcePlugin" />
<c:set value="${ctp:getSystemProperty('meeting.type') }" var="hasMeetingType" />
<c:set value="${ctp:getSystemProperty('meeting.left') }" var="hasMeetingLeft" />
<c:set value="${ctp:getSystemProperty('meeting.leader') }" var="hasMeetingLeader" />
<c:set value="${ctp:getSystemProperty('meeting.room.app') }" var="hasMeetingRoomApp" />

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/meetingroom/i18n");
v3x.loadLanguage("/apps_res/meeting/js/i18n");
try {
getA8Top().endProc();}
catch(e){}
//-->
</script>