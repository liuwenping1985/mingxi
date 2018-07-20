<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="label.please.input" var="_myLabelDefault">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<c:set var="_value" value="${bean[param['_property']]}" />

<c:set var="_myLengthValue" value="${param['_myLength']}" />


<c:if test="${_myLengthValue == null}">
<c:set var="_myLengthValueTrue" value="15" />
</c:if>
<c:if test="${_myLengthValue != null}">
<c:set var="_myLengthValueTrue" value="${_myLengthValue}" />
</c:if>
<br/>
<br/>
<br/>
<br/>
<input type="text" class="cursor-hand input-300px" name="${param['_property']}"
	value="<c:out value="${_value}" default="${_myLabelDefault}" escapeXml="true" />" 
	title="${_value}"
	defaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}"
	validate="${param['_validate']}"
	maxSize="${_myLengthValueTrue}"
	clearValue = "true"
	${v3x:outConditionExpression(readOnly, 'disabled', '')}
/>