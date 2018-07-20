<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
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
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocMark.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowEvent_edoc.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/SeeyonForm3.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script> 

<script type="text/javascript"> 

/** 关闭进度条 */
window._editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
getA8Top()._editionI18nSuffix = window._editionI18nSuffix;
try{getA8Top().endProc();}catch(e){}
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

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