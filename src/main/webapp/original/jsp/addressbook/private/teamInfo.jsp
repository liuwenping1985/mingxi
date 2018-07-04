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
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="15%" nowrap="nowrap"><font color="red">*</font><label for="name"><fmt:message key="addressbook.category_form.name.label" />:</label></td>
			  	<td class="new-column" width="85%">
					<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
					<input name="name" type="text" id="name" style="width: 90%" deaultValue="${defName}" maxlength="20" onKeydown="enter_down();"/
						inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" validate="isDeaultValue,notNull"
					    value="<c:out value="${team.name}" escapeXml="true" default='${defName}' />"
					     ${v3x:outConditionExpression(readOnly, 'readonly', '')}
					    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
			</td>
			</tr>
			<!-- 
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="members"><fmt:message key="addressbook.team_form.members.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input class="cursor-hand input-100per" type="text" name="teamMemNames" readonly="readonly" onclick="selectPrivatedPeople()"
				  			id="teamMemNames" ${dis}
				  			value=""/> 
				  			<input type="hidden" name="teamMemIDs" id="teamMemIDs"
		 value="" />			
				</td>
			</tr>
			 -->
			 <tr height="3px">
			 	<td colspan="2"></td>
			 </tr>
			<tr>
			<fmt:message key="addressbook.category_form.memo.label" var="descLable"/>
			<td class="bg-gray" valign="top" width="15%" nowrap="nowrap"><label for="memo">${descLable}:</label></td>
			<td class="new-column" width="85%">
				<textarea style="width: 245" name="memo" id="memo" maxlength="200" rows="6" cols="" inputName="${descLable}" onKeyDown='checkLength(this,200)' ${ro}>${team.memo}</textarea>
			</td>
		</tr>
		</table>
  </tr>
</table>


<script language="javascript"> 
//??????????????????????????????????? 
function checkLength(object,size) 
{ 
//?????????????????????????? 
if(v3x.getEvent().keyCode!=8) 
{ 
//alert(object.value.length); 
if (object.value.length>=200) 
{ 
v3x.getEvent().returnValue=false 
} 
} 
}

function   enter_down(){   
    if(v3x.getEvent().keyCode=="13") v3x.getEvent().returnValue   =   false;   
}   


</script>