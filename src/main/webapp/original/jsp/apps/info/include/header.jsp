<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<META http-equiv=X-UA-Compatible content=IE=EmulateIE9>
<link href="<c:url value="/common/skin/default${v3x:getSysFlagByName('SkinSuffix')}/images/favicon.ico" />" type="image/x-icon" rel="icon"/>
<link href="<c:url value="/common/skin/default${v3x:getSysFlagByName('SkinSuffix')}/images/favicon.ico" />" type="image/x-icon" rel="shortcut icon"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/workflow/workflow.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/info/InfoSeeyonForm3.js" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/info/js/info.js${v3x:resSuffix()}" />"></script>


<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/infoController.do" var="fullEditorURL" />
<html:link renderURL="/doc.do" var="pigeonholeDetailURL" />
<html:link renderURL="/metadata.do" var="metadataMgrURL" />
<%--
<html:link renderURL="/collaboration.do" var="colWorkFlowURL" />
 --%>
 <html:link renderURL="/infoDetailController.do" var="colWorkFlowURL" />
 <html:link renderURL='/genericController.do' var="genericController" />

<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.loadLanguage("/apps_res/info/js/i18n");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
	v3x.loadLanguage("/apps_res/collaboration/js/i18n");
	v3x.loadLanguage("/common/office/js/i18n");
	_ = v3x.getMessage;

	var docURL = '${docURL}' ;
	var colURL = '${colURL}' ;
	
	var pigeonholeURL = "${pigeonholeDetailURL}";
	var metadataURL = "${metadataMgrURL}";
	
	var colWorkFlowURL = "${colWorkFlowURL}";

	var genericControllerURL = "${genericController}?ViewPage=";
	
	var colInsertPeopleUrl = "infoDetailController.do";

	var jsStr_ClickInput = v3x.getMessage("edocLang.edoc_alertClickInput");
	
	var collaborationCanstant = {
	    deleteActionURL : "collaboration.do?method=delete&from=${param.method}",
	    takeBackActionURL : "collaboration.do?method=takeBack",
	    deletePeopleActionURL : "collaboration.do?method=deletePeople",
			hastenActionURL : "collaboration.do?method=hasten",
			pigeonholeActionURL : "collaboration.do?method=pigeonhole&from=${param.method}",
			issusNewsActionURL : "collaboration.do?method=issusNews",
			issusBulletionActionURL : "collaboration.do?method=issusBulletion",
			updateInfoFormURL:"infoDetailController.do?method=updateFormData"
	}


	var fullEditorURL = "${fullEditorURL}?method=fullEditor";
	var jsContextPath="${pageContext.request.contextPath}";
	
</script>

