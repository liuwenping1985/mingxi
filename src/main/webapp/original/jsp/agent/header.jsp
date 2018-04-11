<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<html:link renderURL="/agent.do" var="detailURL" />
<html:link renderURL="/agentManager.do" var="agentManagerURL" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.apps.agent.resources.i18n.AgentResources" var="agentI18N"/>
<fmt:message key="common.datetime.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/agent/css/agent.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/agent/js/agent.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/agent/js/i18n");
var detailURL = "${detailURL}";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>