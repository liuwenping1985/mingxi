<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/taskmanage/taskinfo.do" var="taskManageUrl" />
<html:link renderURL="/doc.do" var="docUrl" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/collaboration.do" var="colURL" />
<html:link renderURL="/colSupervise.do" var="colSuperviseURL"/>
<html:link renderURL="/project.do" var="projectURL" />

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.project.resources.i18n.ProjectResources" var="projectI18N" />
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.dateselected.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.taskmanage.resources.i18n.TaskManageResources" />
<%-- <%@ page import="com.seeyon.v3x.taskmanage.*" %> --%>
<%@ page import="com.seeyon.apps.taskmanage.po.TaskRole" %>
<%@ page import="com.seeyon.apps.taskmanage.util.TaskMsgUtils" %>
<c:url value="/common/detail.jsp" var="commonDetailURL" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link type="text/css" rel="stylesheet" href="<c:url value="/apps_res/taskmanage/css/taskmanage.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/apps_res/form/css/form.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/top.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<%-- <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script> --%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/taskmanage/js/taskmanage.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.loadLanguage("/apps_res/taskmanage/js/i18n");
	_ = v3x.getMessage;
	var taskManageUrl = '${taskManageUrl}';
	var jsURL = "${docUrl}";
	var docURL = jsURL;
	var mtMeetingUrl = "${mtMeetingURL}";
	var jsColURL = "${colURL}"
	var colSuperviseURL = "${colSuperviseURL}";
	var genericControllerURL = "${genericController}?ViewPage=";
	var projectUrl ='${projectURL}';
	var commonDetailURL = '${commonDetailURL}';

	var TaskDeleted = <%=TaskMsgUtils.ExceptionMsg.TaskDeleted.ordinal()%>;
    var NoReplyAuth = <%=TaskMsgUtils.ExceptionMsg.NoReplyAuth.ordinal()%>;
    var SaveReplyFail = <%=TaskMsgUtils.ExceptionMsg.SaveReplyFail.ordinal()%>;
    var SendMsgFail = <%=TaskMsgUtils.ExceptionMsg.SendMsgFail.ordinal()%>;
    var OtherException = <%=TaskMsgUtils.ExceptionMsg.OtherException.ordinal()%>;
    var None = <%=TaskMsgUtils.ExceptionMsg.None.ordinal()%>;	

	var logger = {
		// 开发模式
		devMode : false,
		isDebugEnabled : function() {
			return this.devMode;
		},
		debug : function(message){
			if(this.isDebugEnabled()) {
				alert("任务管理JS调试信息【" + message + "】");
			}
		}
	}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>