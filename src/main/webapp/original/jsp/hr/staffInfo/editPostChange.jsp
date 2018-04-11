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
    parent.parent.window.location.href="${hrStaffURL}?method=initHome&staffId="+document.getElementById("staffId").value+"&infoType=6&isManager="+isManager;
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
<form id="editForm" method="post" action="${hrStaffURL}?method=updatePostChange" onsubmit="return checkForm(this)">
<input type="hidden" name="id" id="id" value="${postChange.id}" />
<input type="hidden" name="staffId" id="staffId" value="${staffId}" />	
<input type="hidden" name="Manager" id="Manager" value="${Manager}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23" >
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
		<td class="categorySet-head" valign="top">
			<div class="categorySet-body" id="editPostChange">
				<br />
                 <div style="padding:8px">
                   	<table align="center" width="80%">
			           <tr>
                   	    <td class="bg-gray">
                   	    <div class="hr-blue-font"><strong><fmt:message key="hr.staffInfo.postchange.label" bundle="${v3xHRI18N}"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></div></td>
                   	    <td>&nbsp;</td>
                   	  </tr>                    
                       <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.postchange.startdate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3"> 
			              <input type="text" name="start_time" id="start_time" class="input-100per" onpropertychange="selectDateTime(this);" readonly
                            value="<fmt:formatDate value="${postChange.start_time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" ${dis}${mdis} onClick="whenstart('${pageContext.request.contextPath}', this, 175, 440)">
                       </td>                  
                      </tr>
                      <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.postchange.enddate.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3"> 
			              <input type="text" name="end_time" id="end_time" class="input-100per" onpropertychange="selectDateTime(this);" readonly
                            value="<fmt:formatDate value="${postChange.end_time}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" ${dis}${mdis} onClick="whenstart('${pageContext.request.contextPath}', this, 175, 440)">
                       </td> 
                      </tr>
			          <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.postchange.post.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">    
			               <input type="text" id="post_name" name="post_name" class="input-100per"  validate="notNull" maxLength="70"
				            inputName="<fmt:message key="hr.staffInfo.postchange.post.label"  bundle="${v3xHRI18N}"/>" value="${v3x:toHTML(postChange.post_name)}" ${ro} ${mro}/>
                       </td>
                       </tr>
			           <tr>
                       <td class="bg-gray" width="12%" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.postchange.wordnumber.label" bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">    
			               <input type="text" id="wordnumber" name="wordnumber"  maxLength="70" class="input-100per" value="${v3x:toHTML(postChange.wordnumber)}" ${ro} ${mro}/>
                       </td>          
                       </tr>
                       <tr>
			           <td class="bg-gray" width="12%" nowrap="nowrap">
			               <font color="red">*</font><fmt:message key="hr.staffInfo.postchange.organization.label" bundle="${v3xHRI18N}" />:
			           </td>
			           <td class="new-column" width="35%" nowrap="nowrap" colspan="3">    
			               <input type="text" id="organization" name="organization" class="input-100per" validate="notNull"  maxLength="70"
				            inputName="<fmt:message key="hr.staffInfo.postchange.organization.label"  bundle="${v3xHRI18N}"/>"  value="${v3x:toHTML(postChange.organization)}" ${ro} ${mro}/>
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
	bindOnresize('editPostChange',30,105);
</script>
</body>
</html>