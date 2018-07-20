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
    parent.parent.window.location.href="${hrStaffURL}?method=initHome&staffId="+document.getElementById("staffId").value+"&infoType=5&isManager="+isManager;
} 
function post(){
	saveAttachment();  
	//兼容ie9设置 OA-49055 HR管理-员工档案管理，修改员工教育培训信息插入附件，附件未插入成功
	if(document.getElementById("attachmentInputs") && v3x.isMSIE9 ){ 
		var newdiv = document.createElement("div");
		newdiv.innerHTML=document.getElementById("attachmentInputs").innerHTML;
		document.getElementById("attachmentInputs").innerHTML="";
	    document.getElementById("editForm").appendChild(newdiv);
   }
	if(checkForm(editForm)){
		editForm.submit();
	}
}
function selectDateTime(whoClick){
    var date = whoClick.value;
    var newDate = new Date();
    var strDate = newDate.getFullYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
    strDate = formatDate(strDate);
    if(whoClick.name=='start_time'){
      if(document.getElementById('end_time').value!="" && date!="" &&
        date>document.getElementById('end_time').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlateend"));
        whoClick.value="";
      }
      else if(strDate<date){
          alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlatenow"));
          whoClick.value="";
        }
    }
    if(whoClick.name=='end_time'){
      if(document.getElementById('start_time').value!="" &&  date!="" &&
        date<document.getElementById('start_time').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"));
        whoClick.value="";
      }
      else if(strDate<date){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_endcannotlatenow"));
        whoClick.value="";
      }
    }   
}
</script>
<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
<c:set var="mdis" value="${v3x:outConditionExpression(!Manager, 'disabled', '')}" />
<c:set var="mro" value="${v3x:outConditionExpression(!Manager, 'readOnly', '')}" />
<form id="editForm" method="post" action="${hrStaffURL}?method=updateEduExperience" onsubmit="return checkForm(this)">
	<input type="hidden" name="staffId" id="staffId" value="${staffId}" />	
    <input type="hidden" name="Manager" id="Manager" value="${Manager}" />
	<input type="hidden" name="id" id="id" value="${eduExperience.id}" />	
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
			<div class="categorySet-body" id="editEduExperience">
				<br />            
	            
	             <div style="padding:8px">
                   	<table align="center" width="80%">
                   	  <tr>
                   	    <td>
                   	    <div class="hr-blue-font"><strong><fmt:message key="hr.staffInfo.eduAndTrain.label" bundle="${v3xHRI18N}"/></strong></div></td>
                   	    <td colspan="3">&nbsp;</td>
                   	  </tr>
			          <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.bengindate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap"> 
			              <input type="text" name="start_time" id="start_time" class="input-100per" onpropertychange="selectDateTime(this);" readonly
                            value="<fmt:formatDate value="${eduExperience.start_time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" ${dis}${mdis} onClick="whenstart('${pageContext.request.contextPath}', this, 175, 440);selectDateTime(this);">
                       </td>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.enddate.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap"> 
			              <input type="text" name="end_time" id="end_time" class="input-100per" onpropertychange="selectDateTime(this);" readonly
                            value="<fmt:formatDate value="${eduExperience.end_time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" ${dis}${mdis} onClick="whenstart('${pageContext.request.contextPath}', this, 675, 440);selectDateTime(this);">
                       </td>                     
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.eduorganization.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">   
			               <input type="text" id="organization" name="organization" class="input-100per" validate="notNull" maxlength="70"
				             inputName="<fmt:message key="hr.staffInfo.eduorganization.label"  bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(eduExperience.organization)}" ${ro} ${mro}/>
                       </td>
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.certificate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">   
			               <input type="text" id="certificate_name" name="certificate_name" class="input-100per" validate="notNull" maxlength="70"
				             inputName="<fmt:message key="hr.staffInfo.certificate.label"  bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(eduExperience.certificate_name)}" ${ro} ${mro}/>
                       </td>
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.attachment.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">  
			              <c:choose> 
			               <c:when test="${!ReadOnly && Manager}">
			                <input type="button" onclick="insertAttachment();" value="<fmt:message key='hr.staffInfo.imattachment.label' bundle='${v3xHRI18N}' />" class="button-default-2"> 
			                <div class="div-float">(<span id="attachmentNumberDiv"></span><fmt:message key='hr.staffInfo.attachment.count.label' bundle="${v3xHRI18N}" />)</div>
    	                    <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
			               </c:when>
			               <c:otherwise>	
			                <div class="div-float">(<span id="attachmentNumberDiv"></span><fmt:message key='hr.staffInfo.attachment.count.label' bundle="${v3xHRI18N}" />)</div>
    	                    <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="false" />		      	
			               </c:otherwise>
			              </c:choose>
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
			<input type="button" onclick="post()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
<script type="text/javascript">
	bindOnresize('editEduExperience',20,85);
</script>
</body>
</html>