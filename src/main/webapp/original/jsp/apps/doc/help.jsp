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
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource"/>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
</head>
<body scroll="no">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="popupTitleRight" id="sdfdsfss">
	<tr><td colspan="3" class="PopupTitle"><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></td></tr>	
	<tr>
		<td width="10">&nbsp;</td>
		<td height="100%">
			<div class="border-top border-left border-right border-bottom scrollList" id="divScrollListId" style="height: 300px">
				<ul class="help-content">
					<c:if test="${isPersonLib == 'false'}">
					<li>
						<ul>
							<li><a ><fmt:message key="doc.index.help1.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help1.1.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help2.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help2.1.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help3.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help3.1.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help4.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help4.1.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help5.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help5.1.label"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help6.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help6.1.label"/></span></li>
						</ul>
					</li>
					</c:if>
					<li>
						<ul>
							<li><a><fmt:message key="doc.index.help7.label"/>:</a></li>
							<li><span><fmt:message key="doc.index.help7.1.label"/></span></li>
						</ul>
					</li>
				</ul>
			</div>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colspan="3" class="bg-advance-middel" align="right">
		 <input name="ok" type="button" onClick="getA8Top().helpWin.close()" class="button-default-2" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />"  />
	</td>
	</tr>	
</table>
</body>
</html>