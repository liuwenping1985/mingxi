<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.flowperm.resources.i18n.FlowPermResource" var="permRes"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="edocRes"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResources" var="bulI18N" />
<fmt:setBundle basename="com.seeyon.v3x.taskmanage.resources.i18n.TaskManageResources" var="taskI18N" />
<fmt:setBundle basename="com.seeyon.v3x.workflowanalysis.resources.i18n.WorkflowAnalysisResources" var="workflowI18N" />
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/performanceReport/WorkFlowAnalysisController.do" var="detailURL" />
<html:link renderURL='/templete.do' var="templeteURL" />
<html:link renderURL='/edocSupervise.do' var="supervise" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/collaboration.do?method=fullEditor" var="fullEditorURL" />
<html:link renderURL="/form.do" var="formURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL='/webmail.do' var='webmailURL' />
<html:link renderURL="/colSupervise.do" var="colSuperviseURL"/>
<html:link renderURL="/workManage.do" var="workManageURL"/>
<html:link renderURL="/processLog.do" var="processLogURL"/>
<html:link renderURL="/exchangeEdoc.do" var="exchangeURL" />
<c:set value="${v3x:currentUser()}" var="currentUser"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var alert_noFlow = "<fmt:message key='alert.sendImmediate.nowf'/>";
var alert_cannotTakeBack = "<fmt:message key='col.takeBack.flowEnd.alert' />";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/flowperm/js/flowperm.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/workflow/workflow.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-ui.custom.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/jquery-ui.custom.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var docURL = "${docURL}";
var edocURL = "${edocURL}";
var genericURL = '${detailURL}';
var edocSuperviseURL = '${supervise}';
var genericControllerURL = "${genericController}?ViewPage=";
var deleteActionURL = genericURL + "?method=delete&from=${param.method}";
var pigeonholeActionURL = genericURL + "?method=pigeonhole&from=${param.method}";
var templeteURL = "${templeteURL}";
var fullEditorURL = "${fullEditorURL}";
var formURL = "${formURL}";
var mailURL = "${webmailURL}";
var colSuperviseURL = "${colSuperviseURL}";
var workManageURL = "${workManageURL}";
var processLogURL = "${processLogURL}";
var colWorkFlowURL=genericURL;
var mtMeetingUrl = "${mtMeetingURL}";

var collaborationCanstant = {
    deleteActionURL : "collaboration.do?method=delete&from=${param.method}",
    takeBackActionURL : "collaboration.do?method=takeBack",
    deletePeopleActionURL : "collaboration.do?method=deletePeople",
	hastenActionURL : "collaboration.do?method=hasten",
	pigeonholeActionURL : "collaboration.do?method=pigeonhole&from=${param.method}",
	issusNewsActionURL : "collaboration.do?method=issusNews",
	issusBulletionActionURL : "collaboration.do?method=issusBulletion"
}

var edocCanstant = {
	hastenActionURL : "edocSupervise.do?method=sendMessage"
}

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/collaboration/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
//-->
</script>