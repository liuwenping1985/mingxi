<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.log.resources.i18n.LogResource"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.webmail.resources.i18n.WebMailResources" var="v3xMailI18N"/>

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/${controller}" var="detailURL" />

<html:link renderURL='/genericController.do' var="genericController" />

<html:link renderURL='/edocElement.do' var="edocElement" />
<html:link renderURL='/edocDocTemplate.do' var="edocTemplate" />
<html:link renderURL='/edocStat.do' var="edocStat" />
<html:link renderURL="/common/detail.jsp" var="commonDetailURL" />
<html:link renderURL='/edocForm.do' var="edocForm" />
<html:link renderURL="/collaboration.do" var="colWorkFlowURL" />
<html:link renderURL="/WEB-INF/jsp/edoc/fullEditor.jsp" var="fullEditorURL" />
<html:link renderURL='/edocTempleteController.do' var="edocTempleteURL" />
<html:link renderURL='/exchangeEdocController.do' var="exchageEdoc" />
<html:link renderURL='/log.do' var="log" />
<html:link renderURL='/edocController.do' var="edoc" />
<html:link renderURL='/edocSupervise.do' var="supervise" />
<html:link renderURL='/logonLog.do' var="logonLog" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
	
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/log/js/log.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/edoc/SeeyonForm3.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
<!--
var jsContextPath="${pageContext.request.contextPath}";
var genericURL = '${detailURL}';
var genericControllerURL = "${genericController}?ViewPage=";
var colWorkFlowURL="${colWorkFlowURL}";
var fullEditorURL="${fullEditorURL}";
var edocMarkURL = "${mark}";
var templateURL = "${edocTemplate}";
var superviseURL = "${supervise}";
var logonLog = "${logonLog}";

var collaborationCanstant = {
    deleteActionURL : "<html:link renderURL='/edocController.do?method=delete&from=${param.method}' />",
    resendActionURL : "<html:link renderURL='/collaboration.do?method=newColl&from=resend' />",    
	hastenActionURL : "<html:link renderURL='/collaboration.do?method=hasten' />",
	takeBackURL:"<html:link renderURL='/edocController.do?method=takeBack' />",
	updateEdocFormURL:"<html:link renderURL='/edocController.do?method=updateFormData' />",
	changeEdocFormURL:"<html:link renderURL='/edocForm.do?method=getEdocFormModel' />",
	pigeonholeActionURL:"<html:link renderURL='/edocController.do?method=pigeonhole&from=${param.method}' />",
	doCommentActionURL:"<html:link renderURL='/edocController.do?method=doComment' />"
}

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/log/i18n");

var jsStr_ClickInput=v3x.getMessage("edocLang.edoc_alertClickInput");
//-->
</script>