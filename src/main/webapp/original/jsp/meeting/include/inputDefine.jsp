<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="${param['_key']}" var="_myLabel"/>
<fmt:message key="label.please.input" var="_myLabelDefault">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<c:set var="_value" value="${bean[param['_property']]}" />

<input type="text" class="input-100per" id="${param['_property']}" name="${param['_property']}" maxlength="60"
	value="<c:out value="${_value}" default="${_myLabelDefault}" escapeXml="true" />" 
	title="${_value}"
	deaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}"
	validate="${param['_validate']}"
	${param.clearValue}
/>