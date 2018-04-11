<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<script language="JavaScript">
function cancel(){
    var isManager="";
    if("${Manager}"=="true"){
       isManager = "Manager";
    }
     parent.parent.window.location.href="${hrStaffURL}?method=initHome&staffId="+document.getElementById("staffId").value+"&infoType=3&isManager="+isManager;
}  
function selectDateTime(request,whoClick,width,height){
   var date = whenstart(request, whoClick, width, height);
   if(null!=date&&date!=""){
      whoClick.value = date;
   }
}
</script>
<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
<form id="editForm" method="post" action="${hrStaffURL}?method=updateRelationship" onsubmit="return checkForm(this)">
<input type="hidden" name="id" id="id" value="${relationship.id}" />
<input type="hidden" name="staffId" id="staffId" value="${staffId}" />	
<input type="hidden" name="Manager" id="Manager" value="${Manager}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap">&nbsp;<fmt:message key="hr.staffInfo.modifyItem.label" bundle="${v3xHRI18N}"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" valign="top">
			<div class="categorySet-body" id="editRelationship">
             <br />           
	             <div style="padding:8px">
                   	<table align="center" width="80%">
                   	  <tr>
					   <td colspan="2"><div class="hr-blue-font"><strong>&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="hr.staffInfo.family.label" bundle="${v3xHRI18N}"/></strong></div></td>                       
					  </tr>
			          <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">
			               <input type="text" id="name" name="name" class="input-100per" validate="notNull" maxlength="40"
			                 inputName="<fmt:message key="hr.staffInfo.relaname.label"  bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(relationship.name)}" ${ro}/>
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.post.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap">
                           <input type="text" id="post" name="post" maxlength="40" class="input-100per" value="${v3x:toHTML(relationship.post)}" ${ro} />
                       </td>                     
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.name.relationship.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">   
			               <input type="text" id="relationship" name="relationship" validate="notNull" maxlength="40" class="input-100per" 
			                inputName="<fmt:message key="hr.staffInfo.name.relationship.label"  bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(relationship.relationship)}" ${ro} />
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.birthday.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap"> 
			              <input type="text" name="birthday" id="birthday" class="input-100per" onClick="selectDateTime('${pageContext.request.contextPath}',this, 675, 440);" readonly
                            value="<fmt:formatDate value='${relationship.birthday}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />" ${dis}/>
                       </td>                      
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.workorganization.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap">    
			               <input type="text" id="organization" name="organization" class="input-100per" maxlength="40" value="${v3x:toHTML(relationship.organization)}" ${ro} />
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.position.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap">   
                           <select class="input-100per" name="political_position" id="political_position" ${dis}>
			            	 <c:choose>
		  	           	        <c:when test="${relationship.political_position == 1}">
		              	        <option value="1" selected><fmt:message key="hr.staffInfo.commie.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.staffInfo.others.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			            	    <c:when test="${relationship.political_position == 2}">
				        	    <option value="1"><fmt:message key="hr.staffInfo.commie.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2" selected><fmt:message key="hr.staffInfo.others.label" bundle="${v3xHRI18N}"/>	    
			           	        </c:when>
			           	        <c:otherwise>
			           	        <option value="-1">
		               	        <option value="1"><fmt:message key="hr.staffInfo.commie.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.staffInfo.others.label" bundle="${v3xHRI18N}"/>
			           	        </c:otherwise>
			          	     </c:choose>
                           </select>
                       </td>                     
                      </tr>
		            </table>
                 </div>             
             
			</div>		
		</td>
	</tr>
	       <c:if test="${!ReadOnly}">
		    <tr><td align="center" class="bg-advance-bottom">
			   <input type="submit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			   <input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		    </td></tr>
		    </c:if>
</table>
<script type="text/javascript">
	bindOnresize('editRelationship',30,105);
</script>