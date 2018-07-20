<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>

	<c:if test="${canCreate}">
		<input type="button" value="<fmt:message key="oper.new" /><fmt:message key="news.data_shortname" />" onclick="parent.document.location.href='${bulDataURL}?method=writeListMain'" />
	</c:if>
	<c:if test="${canAudit}">
		<input type="button" value="<fmt:message key="oper.audit" /><fmt:message key="news.data_shortname" />" onclick="parent.document.location.href='${bulDataURL}?method=auditListMain'" />
	</c:if>
	<c:if test="${false && canManage}">
		<input type="button" value="<fmt:message key="oper.manage" /><fmt:message key="news.data_shortname" />" onclick="parent.document.location.href='${bulDataURL}?method=listMain'" />
	</c:if>
