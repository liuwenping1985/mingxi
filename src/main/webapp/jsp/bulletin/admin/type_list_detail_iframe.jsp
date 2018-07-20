<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>

</head>
<body class="detailBody">
<script type="text/javascript">
<!--
getDetailPageBreak();
//-->
</script>

<div class="detailDiv">
	<c:if test="${bean==null}">

	</c:if>
	<c:if test="${bean!=null}">
	<table class="detailTable">
		<tr>
			<td class="label"><fmt:message key="bul.type.typeName" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.typeName}</td>
			<td class="label"><fmt:message key="bul.type.usedFlag" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<c:if test="${bean.usedFlag}"><fmt:message key="label.used" /></c:if>
				<c:if test="${not bean.usedFlag}"><fmt:message key="label.noused" /></c:if>
			</td>
		</tr>
		<tr>
			<td class="label"><fmt:message key="bul.type.auditFlag" /><fmt:message key="label.colon" /></td>
			<td class="value">
				<c:if test="${bean.auditFlag}"><fmt:message key="label.audit" /></c:if>
				<c:if test="${not bean.auditFlag}"><fmt:message key="label.noaudit" /></c:if>
			</td>
			<td class="label"><fmt:message key="bul.type.auditUser" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.auditUserName}</td>
		</tr>
		<tr>
			<td class="label"><fmt:message key="bul.type.defaultTemplate" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.defaultTemplate.templateName}</td>
			<td class="label"><fmt:message key="bul.type.managerUsers" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.managerUserNames}</td>
		</tr>
		<tr>
			<td class="label"><fmt:message key="bul.type.createUser" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.createUserName}</td>
			<td class="label"><fmt:message key="bul.type.createDate" /><fmt:message key="label.colon" /></td>
			<td class="value"><fmt:formatDate value="${bean.createDate}" type="both" /></td>
		</tr>
		<tr>
			<td class="label"><fmt:message key="bul.type.topCount" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.topCount}</td>
			<td class="label"></td>
			<td class="value"></td>
		</tr>
		<tr>
			<td class="label"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
			<td class="value">${bean.description}</td>
			<td class="label"></td>
			<td class="value"></td>
		</tr>
	</table>
	</c:if>
</div>
</body>
</html>