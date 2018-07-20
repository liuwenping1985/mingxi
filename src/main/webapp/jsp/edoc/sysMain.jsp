<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>


<%-- 写到header.jsp中去 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<html:link renderURL='/flowPerm.do' var="perm" />
<html:link renderURL='/edocController.do' var='edoc' />
<html:link renderURL='/edocElement.do' var='edocElement' />
<html:link renderURL='/edocForm.do' var='edocForm' />
<html:link renderURL='/exchangeEdoc.do' var="exchange" />
<html:link renderURL='/edocDocTemplate.do' var="edocTemplate" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
//-->
</script>
<%-- 写到header.jsp中去 --%>


</head>
<body class="tab-body" onload="setDefaultTab(0);">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div id="menuTabDiv" class="div-float">				
				
				<!-- 
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${perm}?method=listMain&category=edoc"><fmt:message key='menu.edoc.auth'/></div>
				<div class="tab-tag-right"></div>
				
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${edocElement}?method=listMain"><fmt:message key='menu.edoc.property.setup'/></div>
				<div class="tab-tag-right"></div>
				
				<div class="tab-separator"></div>
				
				-->
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${edocForm}?method=listMain"><fmt:message key='menu.edoc.doc.Form'/></div>
				<div class="tab-tag-right"></div>
								
			</div>
		</td>		
	</tr>
	<!-- 
	<tr>
		<td height="26" class="tab-operate-bg" width="100%">
			<a href="<html:link renderURL='/collaboration.do?method=statisticsToExcel'/>" class="non-a"><img align="absmiddle" src="<c:url value='/common/images/toolbar/importExcel.gif'/>" width="16" border="0">&nbsp;<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a>
		</td>
	</tr>
	 -->
	<tr>
		<td class="tab-body-bg" style="margin: 0px;padding:0px;">
		<iframe id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>		
		</td>
	</tr>
</table>
</body>
</html>