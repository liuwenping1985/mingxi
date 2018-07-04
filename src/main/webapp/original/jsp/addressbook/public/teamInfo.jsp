<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readOnly', '')}" />
<style>

	.hr-blue-font{
		color: #0046d5;
		padding: 4px 0px 0px 0px;	
	}

</style>
<table>
  <tr>
    <td height="20"></td>
  </tr>
</table>	
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%">
    <div class="hr-blue-font"><legend><strong><fmt:message key="addressbook.team_form.info.label"/></strong></legend></div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><font color="red">*</font><label for="name"><fmt:message key="addressbook.team_form.name.label" />:</label></td>
			  	<td class="new-column" width="75%">
					<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
					<input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}" maxlength="50"
						inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" validate="isDeaultValue,notNull,maxLength,isWord"
					    value="<c:out value="${team.name}" escapeXml="true" default='${defName}' />"
					     ${v3x:outConditionExpression(readOnly, 'readonly', '')}
					    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
			</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="leader"><fmt:message key="addressbook.team_form.leader.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input type="text" readonly="readonly" ${dis}
					name="teamLeaderNames" id="teamLeaderNames" class="cursor-hand input-100per" onclick="selectPeopleFun_leader()"
					 value="${leaderNames}"/>
				<input type="hidden" name="teamLeaderIDs" id="teamLeaderIDs" value="${teamLeaderIDs}" />
			  </td>
			</tr>
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="members"><fmt:message key="addressbook.team_form.members.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input class="cursor-hand input-100per" type="text" name="teamMemNames" readonly="readonly" onclick="selectPeopleFun_mem()"
				  			id="teamMemNames" ${dis}
				  			value="${memberNames}"/> 
				  			<input type="hidden" name="teamMemIDs" id="teamMemIDs" value="${teamMemIDs}" />			
				</td>
			</tr>
			<tr>
			<fmt:message key="addressbook.team_form.memo.label" var="descLable"/>
			<td class="bg-gray" valign="top" width="25%" nowrap="nowrap"><label for="memo">${descLable}:</label></td>
			<td class="new-column" width="90%">
				<textarea class="input-100per" style="width: 245" maxlength="200" name="memo" id="memo" rows="6" cols="" inputName="${descLable}" onKeyDown='checkLength(this,200)'  ${ro}>${team.description}</textarea>
			</td>
		</tr>
		</table>
	
	<p></p>
  </tr>
</table>


<script language="javascript"> 


function checkLength(object,size) 
{ 

if(event.keyCode!=8) 
{ 
//alert(object.value.length); 
if (object.value.length>=200) 
{ 
event.returnValue=false 
} 
} 
} 
</script>
