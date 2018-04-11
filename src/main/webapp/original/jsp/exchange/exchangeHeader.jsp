<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.exchange.resources.i18n.ExchangeResource"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="edocI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="colI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>

<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/${controller}" var="detailURL" />

<c:set var="current_user_id" value="${CurrentUser.id}"/>
<c:set var="current_user_name" value="${CurrentUser.name}"/>
<c:set var="current_user_depId" value="${CurrentUser.departmentId}"/>

<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL='/edocController.do' var="edocController" />
<html:link renderURL="/common/detail.html" var="commonDetailURL" />
<html:link renderURL="/collaboration.do" var="colWorkFlowURL" />
<html:link renderURL="/exchangeEdoc.do" var="exchange" />
<html:link renderURL="/WEB-INF/jsp/edoc/fullEditor.jsp" var="fullEditorURL" />

<fmt:message key='common.toolbar.presend.label' bundle='${v3xCommonI18N}' var="presendLabel" />
<fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}' var="presignLabel" />
<fmt:message key='common.toolbar.sent.label' bundle='${v3xCommonI18N}' var="sendLabel" />
<fmt:message key='common.toolbar.sign.label' bundle='${v3xCommonI18N}' var="signLabel" />

<c:set value="${pageContext.request.contextPath}" var="path" />
<c:set value="${ctp:getSystemProperty('edoc.isG6') }" var="isG6Ver" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/exchange/css/exchange.css${v3x:resSuffix()}" />">
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/exchange/js/exchange.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/SeeyonForm3.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var genericURL = '${detailURL}';
var genericControllerURL = "${genericController}?ViewPage=";
var colWorkFlowURL="${colWorkFlowURL}";
var fullEditorURL="${fullEditorURL}";
var exchangeURL = '${exchange}';
var commonURL = '${commonDetailURL}';
var edocURL = "${edocController}";

var collaborationCanstant = {
    deleteActionURL : "<html:link renderURL='/collaboration.do?method=delete&from=${param.method}' />",
    resendActionURL : "<html:link renderURL='/collaboration.do?method=newColl&from=resend' />",
    takeBackActionURL : "<html:link renderURL='/collaboration.do?method=takeBack' />",
    insertPeopleActionURL : "<html:link renderURL='/collaboration.do?method=insertPeople' />",
    preDeletePeopleActionURL : "<html:link renderURL='/collaboration.do?method=preDeletePeople' />",
    deletePeopleActionURL : "<html:link renderURL='/collaboration.do?method=deletePeople' />",
	hastenActionURL : "<html:link renderURL='/collaboration.do?method=hasten' />"
}

var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

v3x.loadLanguage("/apps_res/exchange/js/i18n");
v3x.loadLanguage("/apps_res/edoc/js/i18n");

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
	var p;
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