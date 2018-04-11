<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="${param['_key']}" var="_myLabel"/>
<fmt:message key="label.please.select" var="_myLabelDefault">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<input type="hidden" name="${param['_id_property']}" value="${bean[param['_id_property']]}"/>
<input type="text" class="input-100per cursor-hand" name="${param['_name_property']}" readonly="true" 
	value="<c:out value="${bean[param['_name_property']]}" default="${_myLabelDefault}" escapeXml="true" />"
	title="${bean[param['_name_property']]}"
	deaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}" 
	validate="${param['_validate']}"
	onclick="selectMtPeople('${param['_type']}','${param['_id_property']}');"
	/>

<c:set var="maxSize" value="${param['_maxSize']}" />
<c:if test="${maxSize==null}">
	<c:set var="maxSize" value="" />
</c:if>
<c:set var="selectType" value="${param['_selectType']}" />
<c:if test="${selectType==null}">
	<c:set var="selectType" value="Member" />
</c:if>
<v3x:selectPeople id="${param['_type']}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" panels="Department,Team,Outworker" maxSize="${maxSize}" selectType="${selectType}" jsFunction="setMtPeopleFields(elements,'${param['_id_property']}','${param['_name_property']}')" />