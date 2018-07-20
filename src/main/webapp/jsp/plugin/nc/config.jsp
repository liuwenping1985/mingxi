<script type="text/javascript">
function setOrg(elements){
		if (!elements) {
	    	return;
		}
    	document.getElementById("orgName").value = getNamesString(elements);
    	document.getElementById("orgId").value = getIdsString(elements,false);
    	if(elements[0].type == 'Account'){
    	    document.getElementById("orgType").value = '${accountOrg}';
    	}else if(elements[0].type == 'Department'){
    	    document.getElementById("orgType").value = '${deptOrg}';
    	}    	
}

function setDepart(){
	var isMenberChecked = document.getElementById("people").checked;
	var departMentCheckBox = document.getElementById("department");
	if(isMenberChecked){
		departMentCheckBox.checked = true;
		document.getElementById("mobile").checked = true;
		document.getElementById("mobile").disabled  = false;
		document.getElementById("office").checked = true;
		document.getElementById("office").disabled  = false;
	    document.getElementById("email").checked = true;
		document.getElementById("email").disabled  = false;
		document.getElementById("isNewPerson").disabled = false;   
	}else{
		document.getElementById("mobile").checked = false;
		document.getElementById("mobile").disabled  = true;
		document.getElementById("office").checked = false;
		document.getElementById("office").disabled  = true;
		document.getElementById("email").checked = false;
		document.getElementById("email").disabled  = true;  
		document.getElementById("isNewPerson").checked = false;
		document.getElementById("isNewPerson").disabled = true;
		}
}
function  checkCommunication(){
	var isMobileChecked = document.getElementById("mobile").checked;
	var isOfficeChecked = document.getElementById("office").checked;
	var isEmailChecked = document.getElementById("email").checked;
	var isNewPersonCheck = document.getElementById("isNewPerson");
	
	   if(!isMobileChecked&&!isOfficeChecked&&!isEmailChecked)
	    {
		isNewPersonCheck.checked=false;
		isNewPersonCheck.disabled=true;
	     }
	   else{
		   isNewPersonCheck.disabled=false;
		   }
	
}

function checkPeopleBeSet(){
	var isPeopleChecked = document.getElementById("people").checked;
	var isDepartmentChecked = document.getElementById("department").checked
	if(!isDepartmentChecked && isPeopleChecked){
		alert("<fmt:message key="nc.org.alert.noPeopleChecked"/>");
		document.getElementById("department").checked = true;
	}
}
var hiddenRootAccount_org = true;
var isCanSelectGroupAccount_org = false;
</script>
<v3x:selectPeople id="org" panels="Account,Department" selectType="Account,Department" jsFunction="setOrg(elements)" minSize="1" maxSize="1"/>
<input type="hidden" name="orgType" id="orgType" value="${v3x:toHTML(ncMap.type)}" />
<table  border="0" cellspacing="0" cellpadding="0" align="center" width="90%" height="100%">
<tr>
<td valign="top" align="center">
<fieldset style="padding: 2px">
<legend><fmt:message key="nc.org.synchron.hand.org"/></legend>
<table  width="90%" height="100%" border="0" cellspacing="0" cellpadding="0"  align="center">
	<tr>
		 <td class="bg-gray" width="30%" nowrap="NOWRAP"><label for="name"><font color="red">*</font><fmt:message key="nc.org.list.name${v3x:getSysFlagByName('NCSuffix')}"/>:</label></td>
		 <td class="new-column" width="70%" nowrap="nowrap">
			<input type="text" id="orgName" name="orgName" deaultValue=""  readonly="readonly"
			    ${v3x:outConditionExpression(edit == "1", 'disabled', '')}
				inputName="<fmt:message key="nc.org.list.name"/>" validate="notNull" class="cursor-hand input-80per"
				onclick="selectPeopleFun_org()" value="${ncMap.type == accountOrg ? ncMap.v3xOrgAccount.name : ncMap.v3xOrgDept.name}" />
			<input type="hidden" name="orgId" id="orgId" value="${ncMap.type == accountOrg ? ncMap.v3xOrgAccount.id : ncMap.v3xOrgDept.id}">	
		</td>
	</tr>
	<tr>
		<td class="bg-gray"  nowrap="nowrap"><font color="red">*</font><label for="code"><fmt:message key="nc.org.list.nc.org" />:</label></td>
		<td class="new-column" >
		    <select id="ncId" name="ncId" class="input-80per" validate="notNull" inputName="<fmt:message key="nc.org.list.nc.org" />" ${v3x:outConditionExpression(edit == "1"||edit == "2", 'disabled', '')}>
		    
					${main:accountNcTree(ncAccounts,null,ncAccountString,ncMap.erpOrgCorp.pkCorp,0, pageContext)}
					
			</select>
			<input type="hidden" name="curNcId" id="curNcId" value="${ncMap.erpOrgCorp.pkCorp}">
		</td>
	</tr>
	<tr>
		<td class="bg-gray"  nowrap="nowrap"><font color="red">*</font><label for="dept.sortId"><fmt:message key="nc.org.hand.content" />:</label></td>
		<td class="new-column" nowrap="nowrap">
		<label for="department">
        	<input name="department" id="department" type="checkbox" onclick="checkPeopleBeSet()"
        	             value="department" ${v3x:outConditionExpression(edit == "1", 'disabled', '')} 
        	             <c:if test="${department}">checked</c:if>><fmt:message key="nc.org.hand.dept" />
        	</label>
        	<label for="level">
        	<input name="level" id="level" type="checkbox" 
        	             value="level" ${v3x:outConditionExpression(edit == "1", 'disabled', '')} 
        	             <c:if test="${level}">checked</c:if>><fmt:message key="nc.org.hand.level" />
        	</label>
        	<label for="post">         
        	<input name="post" id="post" type="checkbox" value="post" ${v3x:outConditionExpression(edit == "1", 'disabled', '')} 
        	            <c:if test="${post}">checked</c:if>><fmt:message key="nc.org.hand.post" />
        	</label>
        	<label for="people">             
        	<input name="people" id="people" type="checkbox" onclick="setDepart()" value="people" ${v3x:outConditionExpression(edit == "1", 'disabled', '')} 
        	            <c:if test="${people}">checked</c:if>><fmt:message key="nc.org.hand.member" />  
        	</label>                 			    			      
		</td>
	</tr>	
	<tr>
		<td class="bg-gray"  nowrap="nowrap"><label for="person.sortId"><fmt:message key="nc.org.user.communication" />:</label></td>
		<td class="new-column" nowrap="nowrap">
		<label for="mobile">   
        	<input onclick="checkCommunication()" name="mobile" id="mobile" type="checkbox" 
        	             value="<%=com.seeyon.apps.nc.constants.NCConstants.CommunicationType.mobile.name()%>" 
                             ${v3x:outConditionExpression(edit != "1" && people, '', 'disabled')} 
        	             <c:if test="${mobile!=null}">checked</c:if>><fmt:message key="nc.org.user.communication.mobile" />
        	</label>
        	<label for="office">               
        	<input onclick="checkCommunication()" name="office" id="office" type="checkbox" 
        	             value="<%=com.seeyon.apps.nc.constants.NCConstants.CommunicationType.officePhone.name()%>" ${v3x:outConditionExpression(edit != "1" && people, '', 'disabled')} 
        	            <c:if test="${office!=null}">checked</c:if>><fmt:message key="nc.org.user.communication.office" />
        	 </label>   
        	 <label for="email">         
        	<input onclick="checkCommunication()" name="email" id="email" type="checkbox" value="<%=com.seeyon.apps.nc.constants.NCConstants.CommunicationType.eMail.name()%>" ${v3x:outConditionExpression(edit != "1" && people, '', 'disabled')} 
        	            <c:if test="${email!=null}">checked</c:if>><fmt:message key="nc.org.user.communication.email" />
        	 </label>                  		
		</td>
	</tr>	
	<tr>
		<td class="bg-gray"  nowrap="nowrap"></td>
		<td class="new-column">
		 <label for="isNewPerson"> 
        	<input name="isNewPerson" id="isNewPerson" type="checkbox"  onclick="checkCommunication()"
        	             value="<%=com.seeyon.apps.nc.constants.NCConstants.CommunicationType.isNewPerson.name()%>" 
                           ${v3x:outConditionExpression(edit != "1" && people, '', 'disabled')} 
        	             <c:if test="${isNewPerson!=null}">checked</c:if>><fmt:message key="nc.org.user.communication.newoperation" />
        	 </label>            
        	       		
		</td>
	</tr>	
    <input type="hidden" name="startTime" id="startTime" class="cursor-hand" inputName="startTime" validate="notNull" value="2000-01-01 00:00" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" ${v3x:outConditionExpression(edit == "1", 'disabled', 'readonly')}/>
</table>
</fieldset>
</td>
</tr>
<tr>
<td valign="top" align="left">
 <label for="allMap"> 
<input name="allMap" id="allMap" type="checkbox" value="allMap" ${v3x:outConditionExpression(edit == "1", 'disabled', '')}><fmt:message key="nc.org.user.all" />
</label>
</td>
</tr>
</table>

