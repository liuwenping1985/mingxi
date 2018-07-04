<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>editUserMapper</title>
<%@include file="header.jsp"%>
<script type="text/javascript">
function submitForm() {
  var form = document.getElementById("userMapperForm");
  if (checkForm(form)) {
    var valideLogin = document.getElementById("valideLogin").value;
    var ldapUserCodes = document.getElementById("ldapUserCodes").value;
    parent.detailFrame.location.href = "${ldapSynchron}?method=updateUserMapper&id=${member.v3xOrgMember.id}&valideLogin=" + valideLogin + "&ldapUserCodes=" + ldapUserCodes;
  }
}
function openUserTree() {
  var sendResult = v3x.openWindow({
    url: "${ldapSynchron}?method=viewUserTree",
    width: "390",
    height: "210",
    resizable: "false",
    scrollbars: "yes"
  });
  if (!sendResult) {
    return;
  }
  else {
    document.getElementById("ldapUserCodes").value = sendResult;
  }
}
</script>

</head>
<body scroll="no" style="overflow: no">
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<form id="userMapperForm" method="post" target="editMemberFrame" action="${ldapSynchron}?method=updateUserMapper&id=${member.v3xOrgMember.id}" onsubmit="return (submitForm(this))">
	<input type="hidden" name="id" value="${member.v3xOrgMember.id}" />
	<input type="hidden" name="orgAccountId" value="${member.v3xOrgMember.orgAccountId}" />
	<input type="hidden" id="valideLogin" name="valideLogin"  value="${member.v3xOrgMember.loginName}">
	<br/>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	
	<tr>
		<td align="center">
<table width="550px" border="0" cellspacing="0" height="96%" cellpadding="0" align="center">
  <tr valign="top">
    <td width="50%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td class="bg-gray" nowrap="nowrap" align="right">
					<div class="hr-blue-font"><strong><fmt:message key="org.member_form.system_fieldset.label"/></strong></div>
				</td>
				<td>&nbsp;</td>				
			</tr>	
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label
					for="name"><fmt:message key="org.member_form.name.label"/>:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
					<input name="name" type="text" id="name" style="width: 350px" deaultValue="${defName}"
						inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" maxSize="40" maxlength="40" validate="notNull,isDeaultValue,maxLength,isWord" character="|,"
					    value="<c:out value="${member.v3xOrgMember.name}" escapeXml="true" default='${defName}' />"
					     disabled
					    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
				</td>	
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.loginName"><fmt:message key="org.member_form.loginName.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input style="width: 350px" type="text" name="loginName" ${ro} maxSize="40" maxLength="40"
					id="loginName" value="${member.v3xOrgMember.loginName}" validate="notNull,isCriterionWord" disabled
					inputName="<fmt:message key="org.member_form.loginName.label" />" onfocus="setLoginName();"/></td>
			</tr>			
			<tr>
				<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="organization.member.state"/>:</td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<c:set value="${member.v3xOrgMember.enabled ? 'checked' : ''}" var="c"/>
				<c:set value="${!member.v3xOrgMember.enabled ? 'checked' : ''}" var="d" />
					<label for="enabled1">
						<input id="enabled1" type="radio" name="enabled" value="1" ${c} disabled onclick="enabledMem()"/><fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
					</label>
					<label for="enabled2">
						<input id="enabled2" type="radio" name="enabled" value="0" ${d} disabled/><fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/>
					</label>
				</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="ldap.user.account" bundle="${ldaplocale}"/>:</td>
				<td class="new-column" width="75%">
				<input ${member.v3xOrgMember.enabled ? '' : 'disabled'} style="width: 350px"  type="text" name="ldapUserCodes" <c:if test="${oper == 'edit'}">disabled</c:if>
					id="ldapUserCodes" value="${member.stateName}" validate="isWord" character="，"
					inputName="<fmt:message key="ldap.user.account" bundle="${ldaplocale}"/>" <c:if test="${oper != 'edit'}">onclick="openUserTree()"</c:if> title="${member.stateName}"/>
				</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">&nbsp;</td>
				<td class="new-column" width="75%" nowrap="nowrap"><font color="red"><fmt:message key="ldap.user.account.more" bundle="${ldaplocale}"/></font></td>
			</tr>
			<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
		</table>
    </td width="50%">
    <td  valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td class="bg-gray" nowrap="nowrap" align="right">
					<div class="hr-blue-font"><strong><fmt:message key="org.member_form.org_fieldset.label"/></strong></div>
				</td>
				<td>&nbsp;</td>				
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="deptName"><fmt:message key="org.member_form.deptName.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input style="width: 350px" type="text" name="deptName" readonly="readonly" ${dis}
					id="deptName" disabled
					value="<c:out value="${member.departmentName}" escapeXml="true" />" onclick="memberSelectDepartment()" validate="notNull"
					inputName="<fmt:message key="org.member_form.deptName.label" />" />
					<input type="hidden" name="orgDepartmentId" id="orgDepartmentId" value="${member.v3xOrgMember.orgDepartmentId}"/>
			  </td>
			</tr>			
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.code"><fmt:message key="org.member_form.code"/>:</label></td>
				<td class="new-column" width="75%">
				<input style="width: 350px" type="text" name="code" id="member.code" ${ro} maxSize="20" maxLength="20" disabled
					value="<c:out value="${member.v3xOrgMember.code}" escapeXml="true" />" /></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.sortId"><fmt:message key="common.sort.label" bundle="${v3xCommonI18N}" />:</label></td>
				<td class="new-column" width="75%">
				<input style="width: 350px" maxlength="6" min="1" type="text" name="sortId" id="member.sortId" disabled value="${member.v3xOrgMember.sortId}"
					inputName="<fmt:message key="common.sort.label" bundle="${v3xCommonI18N}" />" 
					validate="isInteger,notNull"/></td>
			</tr>	
			<tr>
			<td colspan="2">
			<div id="intenalDiv">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">					
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="postName"><fmt:message key="org.member_form.primaryPost.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				
				<input type="text" disabled
					name="postName" id="postName" style="width: 350px"
					 value="${member.v3xOrgMember.orgPostId!=-1? member.postName : type=='create'? '':noPostLabel}" onclick="selectPeopleFun_post()" validate="notNull"
					 inputName="<fmt:message key="org.member_form.primaryPost.label" />" />
					<input type="hidden" name="orgPostId" id="orgPostId" value="${member.v3xOrgMember.orgPostId}"/>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="orgLevelId"><fmt:message key="org.member_form.levelName.label" />:</label></td>
				<td class="new-column" width="75%">
				    <input type="text" disabled
					name="postName" id="postName" style="width: 350px"
					 value="${member.levelName}" />
				</td>
			  </td>
			</tr>
			</table>
			</div>
			</td>
			</tr>				   
		</table>
	<p></p>    	
    </td>
  </tr>  
</table>
		</td>
	</tr>
	<c:if test="${!readOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
		
		<c:choose>
		<c:when test="${member.v3xOrgMember.enabled}">
		
			<input id="submintButton" type="button" <c:if test="${oper == 'edit'}">disabled</c:if> onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input id="submintCancel" type="button" <c:if test="${oper == 'edit'}">disabled</c:if> onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		
		</c:when>
		<c:otherwise>
		<input id="submintButton" type="button" <c:if test="${oper == 'edit'}">disabled</c:if> onclick="submitForm()" value="<fmt:message key='ldap.alert.delete' bundle="${ldaplocale}"/>" class="button-default-2">&nbsp;
		<input id="submintCancel" type="button" <c:if test="${oper == 'edit'}">disabled</c:if> onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</c:otherwise>
		</c:choose>
		</td>
	</tr>
	</c:if>
</table>
</form>
<iframe name="editMemberFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<c:if test="${member.v3xOrgMember.enabled}">

<script type="text/javascript">
document.getElementById("ldapUserCodes").focus();
</script>
</c:if>
</body>
</html>