<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysMgrI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.workflowanalysis.resources.i18n.WorkflowAnalysisResources"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="v3xCollaborationI18N"/>
<%-- <fmt:setBundle basename="com.seeyon.apps.performanceReport.i18n.WorkflowAnalysisResources" var="v3xAffair"> --%>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL='/template.do' var="templeteURL" />
<html:link renderURL='/edocTempleteController.do' var="edocTempleteURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL='/formappMgrController.do' var="formappMgrController" />
<html:link renderURL="/colSupervise.do" var="colSuperviseURL"/>
<html:link renderURL="/performanceReport/WorkFlowAnalysisController.do" var="workFlowAnalysisURL"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/workFlowAnalysis/js/workflowAnalysis.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/hr_common.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/date.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var genericControllerURL = "${genericController}?ViewPage=";
var collaborationURL = "<html:link renderURL='/collaboration.do' />";
var templeteURL = "${templeteURL}";
var edocTempleteURL = "${edocTempleteURL}";
var colSuperviseURL = "${colSuperviseURL}";
var formappMgrController = "${formappMgrController}";

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/common/js/i18n");
_ = v3x.getMessage;
//-->
</script>

