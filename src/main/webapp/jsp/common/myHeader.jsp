<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="colI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.exchange.resources.i18n.ExchangeResource" var="exchangeI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.flowperm.resources.i18n.FlowPermResource" var="permI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.workflowanalysis.resources.i18n.WorkflowAnalysisResources" var="workflowI18N" />

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/${controller}" var="edocNavigationControllerURL" />

<html:link renderURL="/edocController.do" var="detailURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/doc.do" var="pigeonholeDetailURL" />
<html:link renderURL='/edocElement.do' var="edocElement" />
<html:link renderURL='/edocDocTemplate.do' var="edocTemplate" />
<html:link renderURL='/edocStat.do' var="edocStat" />
<html:link renderURL="/common/detail.html" var="commonDetailURL" />
<html:link renderURL='/edocForm.do' var="edocForm" />
<html:link renderURL="/collaboration.do" var="colWorkFlowURL" />
<html:link renderURL="collaboration/collaboration.do" var="colURL" />
<html:link renderURL="/edocController.do" var="fullEditorURL" />
<html:link renderURL='/edocTempleteController.do' var="edocTempleteURL" />
<html:link renderURL='/exchangeEdoc.do' var="exchageEdoc" />
<html:link renderURL='/edocMark.do' var="mark" />
<html:link renderURL='/edocController.do' var="edoc" />
<html:link renderURL='/edocSupervise.do' var="supervise" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/edocObjTeamController.do" var="edocObjTeamUrl" />
<html:link renderURL="/colSupervise.do" var="colSuperviseURL"/>
<html:link renderURL="/processLog.do" var="processLogURL"/>
<html:link renderURL="/enum.do" var="metadataMgrURL" />
<html:link renderURL="/edocKeyWordController.do" var="edocKeyWordUrl" />
<html:link renderURL="/edocCategoryController.do" var="edocCategoryUrl" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />

<c:set value="${ctp:getSystemProperty('edoc.list.left') }" var="hasEdocLeft" />
<%--G6版本区隔标识变量 --%>
<c:set value="${ctp:getSystemProperty('edoc.isG6') }" var="isG6Ver" />

<c:set value="${pageContext.request.contextPath}" var="path" />

<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/jquery-ui.custom.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
</c:if>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocMark.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowEvent_edoc.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/SeeyonForm3.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var docURL = "${docURL}";
/** 关闭进度条 */
window._editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
getA8Top()._editionI18nSuffix = window._editionI18nSuffix;
try{getA8Top().endProc();}catch(e){}
var jsContextPath="${pageContext.request.contextPath}";
var genericURL = '${detailURL}';
var edocNavigationControllerURL = '${edocNavigationControllerURL}';
var genericControllerURL = "${genericController}?ViewPage=";
var colWorkFlowURL="${colWorkFlowURL}";
var fullEditorURL="${fullEditorURL}?method=fullEditor";
var edocMarkURL = "${mark}";
var templateURL = "${edocTemplate}";
var superviseURL = "${supervise}";
var colSuperviseURL = "${colSuperviseURL}";
var processLogURL = "${processLogURL}";
var metadataURL = "${metadataMgrURL}";
var edocURL="${edoc}";
var edocCategoryUrl="${edocCategoryUrl}";
var pigeonholeURL = "${pigeonholeDetailURL}";
var colURL = "${colURL}";
var mtMeetingUrl = "${mtMeetingURL}";
//??¨?o???3è???????￡
var edocDetailURL = genericURL;
var commonCombsearchLabel = '<fmt:message key='common.combsearch.label'/>';
var colRepealComment = '<fmt:message key='col.repeal.comment' />';
var exchangeStepBack = '<fmt:message key='exchange.stepBack'/>';
var edocCanstant = {
	hastenActionURL : "<html:link renderURL='/edocSupervise.do?method=sendMessage' />"
}
var collaborationCanstant = {
    deleteActionURL : "<html:link renderURL='/edocController.do?method=delete&from=${param.method}' />",
    resendActionURL : "<html:link renderURL='/collaboration.do?method=newColl&from=resend' />",    
	hastenActionURL : "<html:link renderURL='/collaboration.do?method=hasten' />",
	takeBackURL:"<html:link renderURL='/edocController.do?method=takeBack' />",
	updateEdocFormURL:"<html:link renderURL='/edocController.do?method=updateFormData' />",
	changeEdocFormURL:"<html:link renderURL='/edocForm.do?method=getEdocFormModel' />",
	pigeonholeActionURL:"<html:link renderURL='/edocController.do?method=pigeonhole&from=${param.method}' />",
	doCommentActionURL:"<html:link renderURL='/edocController.do?method=doComment' />",
	addMoreSignActionURL:"<html:link renderURL='/edocController.do?method=addMoreSign' />"
}

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/exchange/js/i18n");
v3x.loadLanguage("/apps_res/edoc/js/i18n");
v3x.loadLanguage("/common/office/js/i18n");
v3x.loadLanguage("/common/pdf/js/i18n");
v3x.loadLanguage("/apps_res/edoc/js/coli18n"); 
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
var jsStr_ClickInput=v3x.getMessage("edocLang.edoc_alertClickInput");

/** 当前位置标识 */
var isLocationOnLoad = false;

function hasEdocResourceCode(resCode) {
	var edocResources = '${CurrentUser.resourceJsonStr}';
	if(edocResources != '') {
		if(edocResources.indexOf(resCode)>=0) {
			return true;
		}
		return false;
	}
	return false;
}

function p_getCtpTop(){
	return parent.parent.getCtpTop();
}
function p_$(){
	var p$;
	if(parent.$ && parent.$.dialog){
		p$ = parent.$;
	}else if(parent.parent.$ && parent.parent.$.dialog){
		p$ = parent.parent.$;
	}else if(parent.parent.parent.$ && parent.parent.parent.$.dialog){
		p$ = parent.parent.parent.$;
	}else if(parent.parent.parent.parent.$ && parent.parent.parent.parent.$.dialog){
		p$ = parent.parent.parent.parent.$;
	}
	return p$;		
}
function V5_Edoc(){
	var p = 1;
	if(parent.$ && parent.$.dialog){
		p = parent;
	}else if(parent.parent.$ && parent.parent.$.dialog){
		p = parent.parent;
	}else if(parent.parent.parent.$ && parent.parent.parent.$.dialog){
		p = parent.parent.parent;
	}else if(parent.parent.parent.parent.$ && parent.parent.parent.parent.$.dialog){
		p = parent.parent.parent.parent;
	}
	return p;
}

//-->
</script>
<style>
.mxtgrid div.bDiv td div{
padding-bottom:2px;
padding-top:2px;
height:auto;
line-height:1.5;
}
</style>