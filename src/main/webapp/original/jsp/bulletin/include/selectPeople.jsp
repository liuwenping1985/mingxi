<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="${param['_key']}" var="_myLabel"/>
<fmt:message key="label.please.select" var="_myLabelDefault">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<input type="hidden" name="${param['_id_property']}" value="${bean[param['_id_property']]}"/>
<input type="text" class="cursor-hand input-100per" name="${param['_name_property']}" readonly="true" 
	value="<c:out value="${param['_name_value']}" default="${_myLabelDefault}" escapeXml="true" />"
	defaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}" 
	validate="${param['_validate']}"
	${v3x:outConditionExpression(readOnly, 'disabled', '')}
	onclick="selectPeople('${param['_type']}','${param['_id_property']}','${param['_name_property']}');"
	/>

<c:set var="maxSize" value="${param['_maxSize']}" />
<c:if test="${maxSize==null}">
	<c:set var="maxSize" value="" />
</c:if>
<c:set var="selectType" value="${param['_selectType']}" />
<c:set value="${v3x:parseElementsOfIds(bean[param['_id_property']], 'Member')}" var="org"/>
<c:if test="${selectType==null}">
	<c:set var="selectType" value="Member" />
</c:if>
<v3x:selectPeople id="${param['_type']}" originalElements="${org }" panels="${noshowlp == 'noshowlp' ? 'Department' : 'Department'}" maxSize="${maxSize}" selectType="${selectType}" jsFunction="setBulPeopleFields(elements,'${param['_id_property']}','${param['_name_property']}')" />