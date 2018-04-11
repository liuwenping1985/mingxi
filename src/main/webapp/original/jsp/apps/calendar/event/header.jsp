<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<html:link renderURL='/genericController.do' var="genericController" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/peoplerelate/css/css.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/peoplerelate/js/relateMember.js${v3x:resSuffix()}" />"></script>

<fmt:setBundle basename="com.seeyon.v3x.peoplerelate.resources.i18n.RelateResources" />
<fmt:message key="common.date.sample.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/collaboration/collaboration.do" var="colURL" psml="default-page.psml" />
<html:link renderURL="/mtMeeting.do" var="mtURL" psml="default-page.psml" />
<html:link renderURL="/meetingNavigation.do" var="mtingURL" psml="default-page.psml" />
<html:link renderURL="/meeting.do" var="meURL" psml="default-page.psml" />
<html:link renderURL="/relateMember.do" var="relateURL" psml="default-page.psml" />
<html:link renderURL="/plan.do" var="planURL" psml="default-page.psml" />
<html:link renderURL="/plan/plan.do" var="planSysURL" psml="default-page.psml" />
<html:link renderURL="/calendar/calEvent.do" var="calEventURL" />
<html:link renderURL="/blog.do" var="blogURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/peoplerelate/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
var colURL = '${colURL}';
var mtURL = '${mtURL}';
var calEventURL = '${calEventURL}';
//-->
</script>