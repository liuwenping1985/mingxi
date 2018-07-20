<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<c:set value="${v3x:suffix()}" var="suffix" />
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" valign="center">
	<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
	<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
	<tr>
		<td class="bg-gray" width="30%" nowrap="nowrap">
			<label for="name"> <font color="red">*</font><fmt:message key="org.level_form.name.label" />:</label>
		</td>
		<td class="new-column" width="50%">
			<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" /> 
			<input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}" inputName="<fmt:message key='org.level_form.name.label'/>" maxSize="40" maxlength="40" validate="isDeaultValue,notNull,maxLength,isWord" character="|," value="<c:out value="${level.name}" escapeXml="true" default='${defName}' />" ${ro}
					    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)"></td>
		<td></td>
	</tr>
	<tr>
		<td class="bg-gray" nowrap="nowrap"><label for="level.code"><fmt:message key="org.level_form.code.label" />:</label></td>
		<td class="new-column"><input class="input-100per" type="text" name="code" inputName="<fmt:message key="org.level_form.code.label" />" maxSize="20" maxlength="20" id="level.code" validate="isWord" character="!@#$%^&*'\\\/|><" value=" <c:out value="${level.code}" escapeXml="true" />" ${ro}/></td>
	</tr>
	<tr>
		<td class="bg-gray" nowrap="nowrap"><font color="red">*</font><fmt:message key="org.level_form.levelId.label" />:</td>
		<td class="new-column"><input class="input-100per" maxlength="2" min="1" maxSize="2" type="text" name="levelId" id="level.levelId" value="${level.levelId}" validate="isInteger,notNull" ${ro}
	inputName="<fmt:message key='org.level_form.levelId.label'/>"></td>
		<td></td>
	</tr>
	<tr>
		<td class="bg-gray" nowrap="nowrap" valign="top"><label for="decription"><fmt:message key="common.description.label" bundle="${v3xCommonI18N}" />:</label></td>
		<td class="new-column"><textarea name="description" rows="3" cols="80" maxSize="1000" inputName="<fmt:message key="common.description.label" bundle="${v3xCommonI18N}"/>" maxlength="1000" validate="maxLength" id="description"${ro} >${level.description}</textarea></td>
		<td></td>
	</tr>
	<tr>
		<td class="bg-gray" nowrap="nowrap"><label for="level.enabled"><fmt:message key="common.state.label" bundle="${v3xCommonI18N}" />:</label></td>
		<td class="new-column"><c:set var="c" value="${level.enabled==true ? 'checked' : ''}" /> <c:set var="d" value="${level.enabled!=true ? 'checked' : ''}" /> <label for="enabled1"> <input id="enabled1" type="radio" name="enabled" value="1" ${c} ${dis} /><fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}" /> </label> <label for="enabled2"> <input id="enabled2" type="radio" name="enabled" value="0" ${d} ${dis} /><fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}" /> </label></td>
		<td nowrap="nowrap">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<c:set var="currentUser" value="${v3x:currentUser()}" />
	<c:if test="${!currentUser.groupAdmin}">
		<tr>
			<td class="bg-gray" valign="top"><br>
			<strong><fmt:message key="level.show${suffix}" /></strong></td>
			<td colspan="2"><font color="green"><br>
			<fmt:message key="level.show1${suffix}" /></font></td>
		</tr>
	</c:if>
</table>
<script type="text/javascript">
<!--	
	document.getElementById("name").focus();
//-->
</script>