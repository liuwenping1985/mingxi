<%@ include file="../../common/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link type="text/css" rel="stylesheet" href="<c:url value="/apps_res/bulletin/css/default.css${v3x:resSuffix()}" />">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />","${v3x:getLanguage(pageContext.request)}");
	v3x.loadLanguage("/apps_res/bulletin/js/i18n");
	v3x.loadLanguage("/common/pdf/js/i18n");
	_ = v3x.getMessage;

	var _baseApp = 7;
	var _baseObjectId = "${param.id}";
</script>
