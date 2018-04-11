<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>mainframe</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/systemmanager/js/i18n");
v3x.loadLanguage("/apps_res/plugin/USBKey/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;
//-->
</script>
</head>
<frameset rows="35%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame src="${path }/performanceReport/WorkFlowAnalysisController.do?method=authorizationList" name="listFrame" id="listFrame" frameborder="no" scrolling="no"/>
	<frame src="${path }/common/detail.jsp?direction=Down" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
</html>