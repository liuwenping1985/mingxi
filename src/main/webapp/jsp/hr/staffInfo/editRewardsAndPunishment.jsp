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
    parent.parent.window.location.href="${hrStaffURL}?method=initHome&staffId="+document.getElementById("staffId").value+"&infoType=8&isManager="+isManager;
}  
function selectDateTime(whoClick,width,height){
   var date = whoClick.value;
   var newDate = new Date();
   var strDate = newDate.getFullYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
   strDate = formatDate(strDate);
   if(null!=date&&date!=""){
      if(strDate<date){
        alert(v3x.getMessage("HRLang.hr_insert_date_lable"));
        whoClick.value = "";
      }
   }
}
function validateLength(){
		var rLength=document.editForm.reason.value.length;
		var cLength=document.editForm.content.value.length;
		  if(rLength>10000){
		        alert(v3x.getMessage("HRLang.hr_rember_edit_lable"));
			    return false;
		    }else if(cLength>10000) {
		    	alert(v3x.getMessage("HRLang.hr_rember_edit_lable"));
		   	    return false;
		    } 
		  return true;  
	}
</script>
<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
<c:set var="mdis" value="${v3x:outConditionExpression(!Manager, 'disabled', '')}" />
<c:set var="mro" value="${v3x:outConditionExpression(!Manager, 'readOnly', '')}" />
<form id="editForm" name="editForm" method="post" action="${hrStaffURL}?method=updateRewardsAndPunishment" onsubmit="return (checkForm(this)&&validateLength())">
<input type="hidden" name="id" id="id" value="${rewardsAndPunishment.id}" />
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
					<td class="categorySet-title" width="80" nowrap="nowrap">&nbsp;<c:if test="${!ReadOnly}"><fmt:message key="hr.staffInfo.detail.label" bundle="${v3xHRI18N}"/></c:if></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body" id="editRewardsAndPunishment">
				<br />             
	             <div style="padding:8px">
                   	<table align="center" width="80%">
			         <tr>
                   	    <td class="bg-gray">
                   	    <div class="hr-blue-font"><strong><fmt:message key="hr.staffInfo.rewardsAndPunishment.label" bundle="${v3xHRI18N}"/></strong></div></td>
                   	    <td>&nbsp;</td>
                   	  </tr> 
                        <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.RAndPtype.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">             
                           <select class="input-100per" name="type" id="type" ${dis} ${mdis}>
			            	 <c:choose>
		  	           	        <c:when test="${rewardsAndPunishment.type == 2}">
		              	        <option value="1"><fmt:message key="hr.staffInfo.reward.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2" selected><fmt:message key="hr.staffInfo.punishment.label" bundle="${v3xHRI18N}"/>
			           	        </c:when>
			           	        <c:otherwise>
				       	        <option value="1" selected><fmt:message key="hr.staffInfo.reward.label" bundle="${v3xHRI18N}"/>
				       	        <option value="2"><fmt:message key="hr.staffInfo.punishment.label" bundle="${v3xHRI18N}"/>	
			           	        </c:otherwise>
			          	     </c:choose>
                           </select>
                       </td>
                       </tr>
                       <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.RAndPdate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3"> 
			              <input type="text" name="time" id="time" class="input-100per" onpropertychange="selectDateTime(this);" readonly  onClick="whenstart('${pageContext.request.contextPath}', this, 175, 440)"
                            value="<fmt:formatDate value="${rewardsAndPunishment.time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" ${dis}${mdis}>
                       </td>                  
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.RAndP.organization.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">   
			               <input type="text" id="organization" name="organization" class="input-100per" validate="notNull" maxlength="70"
			                 inputName="<fmt:message key="hr.staffInfo.RAndP.organization.label" bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(rewardsAndPunishment.organization)}" ${ro} ${mro}/>
                       </td>
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.RAndPreason.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">  
			               <textarea class="input-100per" name="reason" id="reason" rows="5" cols=""  ${ro} ${mro}>${v3x:toHTML(rewardsAndPunishment.reason)}</textarea>  			           
                       </td>
                      </tr>	
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.RAndP.content.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">  
			               <textarea class="input-100per" name="content" id="content" rows="5" cols=""  ${ro} ${mro}>${v3x:toHTML(rewardsAndPunishment.content)}</textarea>  			           
                       </td>
                      </tr>	          
		            </table>
                 </div>             
			</div>		
		</td>
	</tr>
	<c:if test="${!ReadOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
<script type="text/javascript">
	bindOnresize('editRewardsAndPunishment',20,85);
</script>
</body>
</html>