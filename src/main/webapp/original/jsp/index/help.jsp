<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
</head>
<body scroll="no">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr><td colspan="3" class="PopupTitle"><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></td></tr>	
	<tr>
		<td width="10">&nbsp;</td>
		<td height="100%">
			<div class="border-top border-left border-right border-bottom scrollList">
				<ul class="help-content">
					<li>
						<ul>
							<li><a ><fmt:message key="index.help.label"/>:</a></li>
							<li><span><fmt:message key="index.help.1.label"/></span></li>
							<li><span><fmt:message key="index.help.2.label"/></span></li>
							<li><span><fmt:message key="index.help.3.label"/></span></li>
							<li><span><fmt:message key="index.help.4.label"/></span></li>
							<li><span><fmt:message key="index.help.5.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="index.help2.label"/>:</a></li>
							<li><span><fmt:message key="index.help2.1.label"/></span></li>
							<li><span><fmt:message key="index.help2.2.label"/></span></li>
							<li><span><fmt:message key="index.help2.3.label"/></span></li>
						</ul>
					</li>
				</ul>
			</div>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colspan="3" class="bg-advance-middel" align="right">
		 <input name="ok" type="button" onClick="window.close()" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />
	</td>
	</tr>	
</table>
</body>
</html>