<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="bul.data.title" var="_myLabel"/>
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
<input type="text" 
	class="input-100per" 
	name="title"
	id="title"
	value="<c:out value="${bean.title}" default="${_myLabelDefault}" escapeXml="true" />" 
	title="${v3x:toHTML(_value)}"
	defaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}"
	validate="notNull,isDefaultValue,isWord"
	maxSize="${_myLengthValueTrue}"
	${v3x:outConditionExpression(readOnly, 'readonly', '')}
/>