<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"/>

<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/edocController.do" var="detailURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL='/edocElement.do' var="edocElement" />
<html:link renderURL="/common/detail.html" var="commonDetailURL" />
<html:link renderURL='/edocForm.do' var="edocForm" />

<link href="/common/css/SeeyonForm.css${v3x:resSuffix()}" rel="stylesheet" type="text/css"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">


<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/edoc/SeeyonForm3.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
<!--
var genericURL = '${detailURL}';
var genericControllerURL = "${genericController}?ViewPage=";

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

v3x.loadLanguage("/apps_res/edoc/js/i18n");

//-->
</script>
