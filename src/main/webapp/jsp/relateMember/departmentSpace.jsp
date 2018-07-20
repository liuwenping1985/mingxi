<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" />
<link rel="stylesheet" type="text/css" href="<c:url value='/apps_res/systemmanager/css/css.css${v3x:resSuffix()}' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/common/css/default.css${v3x:resSuffix()}' />">
<table width="98%" height="475px" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="departmentSpace-top-left" height="20" width="10">&nbsp;</td>
		<td class="departmentSpace-top-center" rowspan="2" valign="top">
		<table height="100%" width="100%">
		<tr><td height="60">
			<div>
				<div class="departmentSpace-dotted"><fmt:message key="space.department.manager.label" />:
					<fmt:message bundle="${v3xCommonI18N}" key="common.separator.label" var="separatorC" />					
					<c:set var="dmns" value="" />
					<c:forEach items="${depManagerMember}" var="depManager" varStatus="depManagerS">
						<c:if test="${depManagerS.index > 0}">
							<c:set var="dmns" value="${dmns}${separatorC}" />
						</c:if>
						<c:set var="dmns" value="${dmns}${v3x:showOrgMemberName(depManager)}" />
					</c:forEach>
					<span class="fontNormal" title="${v3x:toHTML(dmns)}">${v3x:getLimitLengthString(dmns, 22, '...')}</span>
				</div>
				<c:set var="departmentMotto" value="${main:getDepartmentMotto(requestScope['PortletEntityProperty.ownerId'])}" />
				<div class="departmentSpace-motto" title="${departmentMotto}">${v3x:toHTML(v3x:getLimitLengthString(departmentMotto, 130, "..."))}</div>
			</div>
		</td></tr>
		<tr><td height="20">
			<div class="departmentSpace-sp"></div>
			<div class="departmentSpace-dotted"><fmt:message key="space.department.member.label">
				<fmt:param value="${fn:length(memberList)}" />
			</fmt:message></div>
		</td></tr>
		<tr><td>
			<div class="scrollList">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<c:forEach items="${memberList}" var="m" varStatus="ordinal">
							<c:set value="${v3x:showOrgMemberName(m)}" var="name" />
							<td class="departmentSpace-memberName" title="${name}">
								<html:link renderURL="/relateMember.do?method=relateMemberInfo&memberId=${m.id}&relatedId=${v3x:currentUser().id}&departmentId=${m.orgDepartmentId}" psml="default-page.psml" var="url" />
								<c:choose>
								<c:when test="${v3x:currentUser().id!=m.id}">
									<a class='defaulttitlecss' href="${url}">${v3x:getLimitLengthString(name, 11, '...')}</a>
								</c:when>
								<c:otherwise>
									<span>${v3x:getLimitLengthString(name, 11, '...')}</span>
								</c:otherwise>
								</c:choose>
							</td>
							${(ordinal.index + 1) % 2 == 0 && !ordinal.last ? "</tr><tr>" : ""}
						</c:forEach>
					</tr>
				</table>
				</div>
		</td></tr>
		</table>
		</td>
		<td class="departmentSpace-top-right" width="10">&nbsp;</td>
	</tr>
	<tr>
		<td class="departmentSpace-left" height="420">&nbsp;</td>
		<td class="departmentSpace-right">&nbsp;</td>
	</tr>
	<tr>
		<td class="departmentSpace-left">&nbsp;</td>
		<td class="departmentSpace-bottom-center" rowspan="2" align="right">
			&nbsp;<%-- 
			<a href="<html:link renderURL="/main.do?method=departmentSpaceMore&departmentId=${requestScope['PortletEntityProperty.ownerId']}" psml="default-page.psml" />">[<fmt:message key="common.more.label" bundle="${v3xCommonI18N}"/>]</a>
			--%>
		</td>
		<td class="departmentSpace-right">&nbsp;</td>
	</tr>
	<tr>
		<td class="departmentSpace-bottom-left" height="20">&nbsp;</td>
		<td class="departmentSpace-bottom-right">&nbsp;</td>
	</tr>
</table>