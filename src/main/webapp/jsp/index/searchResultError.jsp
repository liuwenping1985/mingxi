<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Result Page</title>
<link href="<c:url value="/apps_res/index/css/searchresult.css${v3x:resSuffix()}" />" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script Language="JavaScript">
parent.document.getElementById("searchBtn").disabled=false;
new V3X().init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
</script>
${v3x:skin()}
</head>

<body scroll="no" class="main-bg">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<tr height="15">
	<td valign="top" style="padding: 5px;">
		<div class="gov_border" style="padding: 5px;">		  	
			<span class="searchSectionTitle"><fmt:message key='index.com.seeyon.v3x.index.searchKey'/></span>
		</div> 
		
	</td>
  </tr>
</table>
</body>
</html>
