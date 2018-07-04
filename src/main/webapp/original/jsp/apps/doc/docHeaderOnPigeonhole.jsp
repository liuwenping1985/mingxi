<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="cxt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<html:link renderURL="/doc.do" var="detailURL" />
<html:link renderURL="/doc.do" psml="default-page.psml" forcePortal="true" var="detailPortalURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/newsData.do" var="newsURL" />
<html:link renderURL="/bulData.do" var="bulURL" />
<html:link renderURL="/plan.do" var="planURL" />
<html:link renderURL="/webmail.do" var="mailURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/inquirybasic.do" var="inquiryURL" />
<html:link renderURL="/docManager.do" var="managerURL" />
<html:link renderURL="/doc.do?method=xmlJsp" var="srcJURL" />
<html:link renderURL="/doc.do?method=listDocs" var="actionJURL" />
<html:link renderURL="/rssManager.do" var="rssURL" />
<html:link renderURL="/docSpace.do" var="spaceURL" />
<html:link renderURL="/infoDetailController.do" var="infoURL" />
<html:link renderURL="/infoStatController.do" var="infoStatURL" />

<cxt:url value="/apps_res/doc/images/docIcon/" var="imgURL"/>
<link rel="stylesheet" type="text/css" href="<cxt:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<cxt:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<cxt:url value="/apps_res/doc/css/property.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="dateTimePattern" bundle="${v3xCommonI18N}"/>

<script type="text/javascript">
var docjsshowlabel = "<fmt:message key='doc.menu.show.label'/>";
var docjshiddenlabel = "<fmt:message key='doc.menu.hidden.label'/>";
var dtb = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(new java.util.Date())%>";
var dte = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(com.seeyon.ctp.util.Datetimes.addDate(new java.util.Date(),180))%>";
var contpath = "${pageContext.request.contextPath}";

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
var treeImgURL = "${imgURL}";
var jsURL = "${detailURL}";
var docURL = jsURL;
var jsColURL = "${colDetailURL}";
var jsMeetingURL = "${mtMeetingURL}";
var jsPlanURL = "${planURL}";
var jsMailURL = "${mailURL}";
var jsNewsURL = "${newsURL}";
var jsBulURL = "${bulURL}";
var jsEdocURL = "${edocURL}";
var jsInquiryURL = "${inquiryURL}";
var managerURL="${managerURL}";
var spaceURL="${spaceURL}";
var infoURL="${infoURL}";
var infoStatURL="${infoStatURL}";
var baseurl = v3x.baseURL;
var srcURL = baseurl + "/doc.do?method=xmlJsp";
var actionURL = jsURL + "?method=listDocs";
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/doc/i18n");
v3x.loadLanguage("/common/pdf/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
<%-- ææ¡£åºç¨éç¶æå¸¸éå®ä¹ --%>
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>"
</script>

<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/xtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/xmlextras.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/xloadtree.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<cxt:url value='/apps_res/doc/css/xtree.css${v3x:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/controllerFuncs.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<cxt:url value="/apps_res/doc/js/property.js${v3x:resSuffix()}" />"></script>


