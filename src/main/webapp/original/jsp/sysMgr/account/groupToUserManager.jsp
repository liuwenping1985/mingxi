<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<%@include file="../header.jsp"%>
<script type="text/javascript">
<!--
	// 进行编辑
	function showEdit(){
		document.getElementById("submitOk").style.display= "";		
		document.getElementById("groupAdminNames").disabled="";	
	}
	// 取消编辑
	function notEdit(){
		document.getElementById("submitOk").style.display="none";
		document.getElementById("groupAdminNames").disabled="disabled";
	}	
	function setGroupAdminIds(elements){    
	  document.getElementById("groupAdminNames").value = getNamesString(elements);
	  document.getElementById("groupAdminIds").value = getIdsString(elements, false);	
	  elements_groupAdminIds = elements; 
    }  	
//-->
</script>
</head>
<body scroll="no" class="padding5">
<c:set value="${v3x:suffix()}" var="suffix"/>
	<form id="postForm" method="post" action="<html:link renderURL='/accountManager.do' />?method=modifyGroupToUser" onsubmit="return checkForm(this)">
		<input type="hidden" name="id" id="logerName" value="${logerName}" />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="page-list-border">
			<tr>
				<td height="12" colspan="2">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
						myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","showEdit()",[1,2],"", null));
						document.write(myBar);
				    	document.close();
			    	</script>
			    </td>
			</tr>
			<tr >
				<td valign="top" align="center">
				<br/><br/><br/><br/><br/><br/>
				<fieldset class="group-administrator"><legend ><fmt:message key="groupadmin.role.tomember.label${suffix}"/></legend>
					<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td class="new-column" nowrap="nowrap">
							<label for="name"><fmt:message key="groupadmin.member.role.label${suffix}"/>:</label>
							</td>
						</tr>
						<tr>
						  <td class="bg-gray" width="100%" nowrap="nowrap">
						    <c:set value="${v3x:parseElementsOfIds(groupAdminIds, 'Member')}" var="org"/>
						    <v3x:selectPeople id="groupAdminIds" panels="Department,Team" selectType="Member" minSize="0" originalElements="${org }" jsFunction="setGroupAdminIds(elements_groupAdminIds)"/>					    
							<input type="hidden" name="groupAdminIds" id="groupAdminIds" value="${groupAdminIds}">
	                        <input type="text" name="groupAdminNames" id="groupAdminNames" style="font-size:12px;width:100%;font:'宋体'; height:20" 
	                           value="${v3x:showOrgEntitiesOfIds(groupAdminIds, 'Member', pageContext)}" class="cursor-hand" readonly onClick="selectPeopleFun_groupAdminIds()" disabled>					  
						  </td>
						</tr>
					</table>
				</fieldset>
				<div style="height: 20px; width: 600px;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td><fmt:message key="groupadmin.help.message.label${suffix}"/></td></tr>
					</table>
				</div>
				</td>
			</tr>
				<tr id="submitOk" style="display:none">
					<td height="42" align="center" class="bg-advance-bottom" >
						<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
						<input type="button" onclick="notEdit();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
		</table>
</form>
</body>
</html>