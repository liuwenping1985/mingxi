<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<fmt:message key="label.please.select" var="_myLabelDefault">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<input type="hidden" name="${param['_id_property']}" id="${param['_id_property']}" value="${bean[param['_id_property']]}"/>

	<c:if test="${param['noClick'] == 'true'}">
<input type="text" class="cursor-hand input-100per" name="${param['_name_property']}" id="${param['_name_property']}" readonly="true" 
	value="<c:out value="${bean[param['_name_property']]}" default="${_myLabelDefault}" escapeXml="true" />"
	title="${bean[param['_name_property']]}"
	defaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}" 
	validate="${param['_validate']}"
	${v3x:outConditionExpression(readOnly, 'disabled', '')}
	${v3x:outConditionExpression(param['noclick'] == 'true', 'disabled', '')}
	onclick="noEditAuditUserAlert()"
	/>
	</c:if>
	<c:if test="${param['noClick'] != 'true'}">
<input  type="text" class="cursor-hand input-100per"  name="managerUserNames" id="managerUserIds" readonly="true" 
	value="<c:out value="${bean[managerUserNames]}" default="${_myLabelDefault}" escapeXml="true" />"
	title="${bean[param['_name_property']]}"
	defaultValue="${_myLabelDefault}"
	onfocus="checkDefSubject(this, true)"
	onblur="checkDefSubject(this, false)"
	inputName="${_myLabel}" 
	validate="${param['_validate']}"
	${v3x:outConditionExpression(readOnly, 'disabled', '')}
	${v3x:outConditionExpression(param['noclick'] == 'true', 'disabled', '')}
	onclick="selectPeople('manager','managerUserIds','managerUserNames');"
	/>
	</c:if>



<c:set var="maxSize" value="${param['_maxSize']}" />
<c:if test="${maxSize==null}">
	<c:set var="maxSize" value="" />
</c:if>
<c:set var="selectType" value="${param['_selectType']}" />
<c:if test="${bean[param['_id_property']] != 0}">
	<c:set value="${v3x:parseElementsOfIds(bean[param['_id_property']], 'Member')}" var="org"/>
</c:if>
<c:if test="${selectType==null}">
	<c:set var="selectType" value="Member" />
</c:if>
<v3x:selectPeople id="manager" originalElements="${org }" panels="Department" maxSize="${maxSize}" selectType="${selectType}" jsFunction="setBulPeopleFields(elements,'managerUserIds','managerUserNames')" />