<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.plugin.gke.resource.i18n.GKESynchronResources"/>
<html:link renderURL="/gke.do" var="gkeURL"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css" />">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css" />">    
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js" />"></script>
<link href="<c:url value="/common/js/menu/xmenu.css" />" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<c:url value="/common/js/V3X.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css" />" type="text/css" rel="stylesheet">



<script type="text/javascript">
var genericControllerURL = "${genericController}?ViewPage=";
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/organization/js/i18n");
var gkeURL = "<html:link renderURL='/gke.do' />";
</script>
<script type="text/javascript" src="<c:url value="/common/js/xtree/xtree.js"/>"></script>
