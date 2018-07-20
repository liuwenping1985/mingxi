<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource" />

<html:link renderURL="/isearch.do" var="detailURL" />
<c:url value="/apps_res/doc/images/docIcon/" var="imgURL"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>


<script type="text/javascript">
var docjsshowlabel = "<fmt:message key='doc.menu.show.label'/>";
var docjshiddenlabel = "<fmt:message key='doc.menu.hidden.label'/>";
var dtb = "<%=com.seeyon.v3x.util.Datetimes.formatDatetime(new java.util.Date())%>";
var dte = "<%=com.seeyon.v3x.util.Datetimes.formatDatetime(com.seeyon.v3x.util.Datetimes.addDate(new java.util.Date(),7))%>";
var contpath = "${pageContext.request.contextPath}";

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

var baseurl = v3x.baseURL;

_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/isearch/i18n");
v3x.loadLanguage("/apps_res/doc/i18n");
var jsURL = "${detailURL}";
</script>
		
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/property.js${v3x:resSuffix()}" />"></script>

