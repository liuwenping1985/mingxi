<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/bulletin" prefix="bulletin"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<html:link renderURL="/bulType.do" var="bulTypeURL" />
<html:link renderURL="/bulData.do" var="bulDataURL" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" />
<html:link renderURL="/edocController.do" var="edocDetailURL" />

<html:link renderURL="/collaboration/collaboration.do" var="colURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingUrl" />

<c:url value="/common/detail.jsp?direction=Down" var="commonDetailURL" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource"/>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="inquiryI18N"/>


<script type="text/javascript">

var docURL = "${docURL}";
var jsColURL = "${colDetailURL}";
var edocDetailURL = "${edocDetailURL}";

var mtMeetingUrl = "${mtMeetingUrl}";
var colURL = "${colURL}";
</script>
