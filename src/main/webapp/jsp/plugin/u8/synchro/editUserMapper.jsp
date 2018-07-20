<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>editUserMapper</title>
<%@include file="header_userMapper.jsp"%>

<script type="text/javascript">
	function submitForm(){
		var oldNcUserCodes = "${member.stateName}";
		var valideLogin = document.getElementById("valideLogin").value;
        var ncUserCodes = encodeURI(document.getElementById("ncUserCodes").value);
        var newNcUserCodes = (document.getElementById("ncUserCodes").value).replace(/\s+/g,"");

		if(oldNcUserCodes=='' && newNcUserCodes==''){
			alert("<fmt:message key='nc.user.mapper.empty'/>");
			document.getElementById("ncUserCodes").value = "";
			document.getElementById("ncUserCodes").focus();
			return false;
		}
	    var form = document.getElementById("userMapperForm");
	    if(checkForm(form)){
	        parent.detailFrame.location.href = "${urlNCUserMapper}?method=updateUserMapper&id=${member.v3xOrgMember.id}&valideLogin="+valideLogin+"&ncUserCodes="+ncUserCodes+"&oper=update";
	    }
	}
</script>

</head>
<body scroll="no" style="overflow: no">
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<form id="userMapperForm" method="post" target="editMemberFrame" action="${urlNCUserMapper}?method=updateUserMapper&id=${member.v3xOrgMember.id}" onsubmit="return (submitForm(this))">
	<input type="hidden" name="id" value="${member.v3xOrgMember.id}" />
	<input type="hidden" name="orgAccountId" value="${member.v3xOrgMember.orgAccountId}" />
	<input type="hidden" id="valideLogin" name="valideLogin"  value="${member.v3xOrgMember.loginName}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	<tr>
		<td class="">
			<div class="scrollList">
<table width="100%" border="0" cellspacing="0" height="96%" cellpadding="0" align="center">
  <tr valign="top">
    <td width="50%">
    <fieldset style="width:95%;border:0px;" align="center">
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
					<input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}"
						inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" maxSize="40" maxlength="40" validate="notNull,isDeaultValue,maxLength,isWord" character="|,"
					    value="<c:out value="${member.v3xOrgMember.name}" escapeXml="true" default='${defName}' />"
					     disabled
					    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
				</td>	
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.loginName"><fmt:message key="org.member_form.loginName.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-100per" type="text" name="loginName" ${ro} maxSize="40" maxLength="40"
					id="loginName" value="${v3x:toHTML(member.v3xOrgMember.loginName)}"  disabled
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
			<fmt:setBundle basename="com.seeyon.v3x.plugin.nc.resources.i18n.NCResources"/>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="nc.user.account"/>:</td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-100per" type="text" name="ncUserCodes" maxSize="40" maxLength="40" <c:if test="${oper == 'edit'}">disabled readonly="readonly"</c:if>
					id="ncUserCodes" value="${member.stateName}" validate="isWord" character="，"
					inputName="<fmt:message key="nc.user.account" />" /></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"></td>
				<td class="new-column" width="75%" nowrap="nowrap"><font color="#008000"><fmt:message key="nc.user.account.label"/></font></td>
			</tr>
			<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
		</table>
	</fieldset>
	<p></p>
    	
    </td width="50%">
    <td  valign="top">
    <fmt:message key="org.member.noPost" var="noPostLabel"/>
    	<fieldset style="width:95%;border:0px;" align="center">
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
				<input class="cursor-hand input-100per" type="text" name="deptName" readonly="readonly" ${dis}
					id="deptName" disabled
					value="<c:out value="${v3x:toHTML(member.departmentName)}" escapeXml="true" />" onclick="memberSelectDepartment()" validate="notNull"
					inputName="<fmt:message key="org.member_form.deptName.label" />" />
					<input type="hidden" name="orgDepartmentId" id="orgDepartmentId" value="${member.v3xOrgMember.orgDepartmentId}"/>
			  </td>
			</tr>			
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.code"><fmt:message key="org.member_form.code"/>:</label></td>
				<td class="new-column" width="75%">
				<input class="input-100per" type="text" name="code" id="member.code" ${ro} maxSize="20" maxLength="20" disabled
					value="<c:out value="${v3x:toHTML(member.v3xOrgMember.code)}" escapeXml="true" />" /></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="member.sortId"><fmt:message key="common.sort.label" bundle="${v3xCommonI18N}" />:</label></td>
				<td class="new-column" width="75%">
				<input class="input-100per" maxlength="6" min="1" type="text" name="sortId" id="member.sortId" disabled value="${member.v3xOrgMember.sortId}"
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
					name="postName" id="postName" class="cursor-hand input-100per"
					 value="${member.v3xOrgMember.orgPostId!=-1? member.postName : type=='create'? '':noPostLabel}"/>
					<input type="hidden" name="orgPostId" id="orgPostId" value="${member.v3xOrgMember.orgPostId}"/>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="orgLevelId"><fmt:message key="org.member_form.levelName.label" />:</label></td>
				<td class="new-column" width="75%">
				    <input type="text" disabled
					name="postName" id="postName" class="cursor-hand input-100per"
					 value="${v3x:toHTML(member.levelName)}"/>
				</td>
			</tr>
			<c:if test="${sys_isGroupVer}">
				<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="orgLevelId"><fmt:message key="org.member_form.account" />:</label></td>
				<td class="new-column" width="75%">
				    <input type="text" disabled
					name="postName" id="postName" class="cursor-hand input-100per"
					 value="${v3x:toHTML(member.accountName)}"/>
				</td>
			       </tr>
			</c:if>
			</table>
			</div>
			</td>
			</tr>				   
		</table>
	</fieldset>
	<p></p>    	
    </td>
  </tr>  
</table>
			</div>		
		</td>
	</tr>
	<c:if test="${!readOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input id="submintButton" type="button" <c:if test="${oper == 'edit'}">style="display:none"</c:if> onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input id="submintCancel" type="button" <c:if test="${oper == 'edit'}">style="display:none"</c:if> onclick="previewFrame('Down');" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>

</form>
<iframe name="editMemberFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<c:if test="${oper != 'edit'}">
<script type="text/javascript">
	document.getElementById("ncUserCodes").focus();
</script>
</c:if>
</body>
</html>