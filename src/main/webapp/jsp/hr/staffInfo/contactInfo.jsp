<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html>
<head>
<script type="text/javascript">
//4.11??????????��??
//if("${isManager}"=="Manager"){
//    getA8Top().showLocation(null, getA8Top().findMenuName(12), getA8Top().findMenuItemName(1202), "<fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/>");
//}
//else{
//   getA8Top().showLocation(null, getA8Top().findMenuName(8), getA8Top().findMenuItemName(801), "<fmt:message key='hr.staffInfo.contactInfo.label' bundle='${v3xHRI18N}'/>");
//}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/string.extend.js${v3x:resSuffix()}" />"></script>
<script   language="JavaScript">  
$(function(){
	$("#btsubmit").click(function() {
		if ($('#postalcode').val() != '' && !$('#postalcode').val().isZipCode()) {
			alert(v3x.getMessage("HRLang.hr_staffInfo_input_validation",v3x.getMessage("HRLang.hr_staffInfo_postcode")));
			return false;
		}
		//if ($('#telephone').val() != '' && !$('#telephone').val().isPhoneCall()) {
		//	alert(v3x.getMessage("HRLang.hr_staffInfo_input_validation",v3x.getMessage("HRLang.hr_staffInfo_telphone")));
		//	return false;
		//}
		if($('#telephone').val() != '' && $('#telephone').val().length>20){
			alert("固定电话输入不要超过20个字符！");
   			return false;
		}
		//if ($('#telNumber').val() != '' && !$('#telNumber').val().isMobile()) {
		//	alert(v3x.getMessage("HRLang.hr_staffInfo_input_validation",v3x.getMessage("HRLang.hr_staffInfo_mobilephone")));
		//	return false;
		//}
		if ($('#telNumber').val() != '' && $('#telNumber').val().length>20) {
			alert("移动电话输入不要超过20个字符！");
   			return false;
		}
		if ($('#email').val() != '' && !$('#email').val().isEmail()) {
			alert(v3x.getMessage("HRLang.hr_staffInfo_input_validation",v3x.getMessage("HRLang.hr_staffInfo_email")));
			return false;
		}
		//if(!isEmail(this.email)){
		//    return false;
		//}
		if ($('#website').val() != '' && !$('#website').val().isUrl()) {
			alert(v3x.getMessage("HRLang.hr_staffInfo_input_url_validation",v3x.getMessage("HRLang.hr_staffInfo_website")));
			return false;
		}
		if ($('#blog').val() != '' && !$('#blog').val().isUrl()) {
			alert(v3x.getMessage("HRLang.hr_staffInfo_input_url_validation",v3x.getMessage("HRLang.hr_staffInfo_blog")));
			return false;
		}
	});
});
   	 
function modify(){
   window.location.href="${hrStaffURL}?method=initContactInfo&isManager=${isManager}&staffId="+document.getElementById("staffId").value;
}
function cancel(){
   parent.window.location.href="${hrStaffURL}?method=initInfoHome&isManager=${isManager}&isReadOnly=ReadOnly&staffId="+document.getElementById("staffId").value;
}
function cancelContactInfo(){
   window.location.href="${hrStaffURL}?method=initContactInfo&isReadOnly=ReadOnly&staffId="+document.getElementById("staffId").value;
}
</script>
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />
</head>
<body scroll="no" style="overflow: no">

	<script>	
	//def toolbar
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
	
	//add buttons
	//myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "add()", "<c:url value='/common/images/toolbar/new.gif'/>"));
	myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));
	//myBar1.add(new WebFXMenuButton("cancel", "<fmt:message key='hr.staffInfo.cancel.label' bundle='${v3xHRI18N}' />", "cancel()", "<c:url value='/common/images/toolbar/back.gif'/>"), "",null );
	//myBar1.add(new WebFXMenuButton("send", "<fmt:message key='hr.staffInfo.send.label' bundle='${v3xHRI18N}' />",  null, "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
	//myBar1.add(new WebFXMenuButton("export", "<fmt:message key='hr.staffInfo.export.label' bundle='${v3xHRI18N}'/>",  null, "<c:url value='/common/images/toolbar/importExcel.gif'/>", "", null));	
	
	//WebFXMenuButton???????HtmlId, ??????, ??????, ???, alt/title, ??????
	document.write(myBar1);
	document.close();
	</script>


<c:set var="dis" value="${v3x:outConditionExpression(ReadOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(ReadOnly, 'readOnly', '')}" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="95%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="120" nowrap="nowrap"><fmt:message key="hr.staffInfo.contactInfo.label" bundle="${v3xHRI18N}"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" valign="top">
			<div class="categorySet-body" id="contactInfo">
			<form id="editForm" method="post" action="${hrStaffURL}?method=updateContactInfo">
	           <input type="hidden" name="staffId" id="staffId" value="${member.id}">
			 <table border="0" cellspacing="0" cellpadding="0" width="100%">
			 <tr>
			 <td>
                    <table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                     <tr>
                       <td class="bg-gray" width="25%" align="right" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="25%" nowrap="nowrap">
			               ${member.name}
                       </td>
                       <td class="bg-gray" width="10%" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.memberno.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="40%" nowrap="nowrap">
			               ${member.code}
                       </td>
                     </tr>
                    </table>
               </td>
               </tr>
               <tr><td><hr /></td></tr>
               <tr><td height="30">&nbsp;</td></tr>
               <tr>
               <td>
                    
                   	<table align="center" width="10%" border="0" cellspacing="0" cellpadding="0">
			          <tr>
                       <td class="bg-gray" nowrap="nowrap" ${dis }>
                           <fmt:message key="hr.staffInfo.workTelephone.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap" ${dis }>
                            <input type="text" id="telephone" name="officeNum" size="70" maxLength="70" value="${v3x:toHTML(officeNum)}" ${ro}/>  
                       <!-- <input type="text" id="telephone" name="telephone" size="70" value="${contactInfo.telephone}" ${ro}/> -->
                       </td> 
                      </tr>
			          <tr>                    
			           <td class="bg-gray" nowrap="nowrap" ${dis }>
			               <fmt:message key="hr.staffInfo.mobileTelephone.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" nowrap="nowrap" ${dis }>   
			               <input type="text" id="telNumber" name="telephone" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.telephone)}" ${ro}/>
                       </td>
                      </tr>
			          <tr>
                       <td class="bg-gray" nowrap="nowrap" ${dis }>
                           <fmt:message key="hr.staffInfo.emailDetail.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap" ${dis }> 
			                <!--  <input type="text" id="email" name="email" inputName="<fmt:message key='hr.staffInfo.emailDetail.label'  bundle='${v3xHRI18N}'/>" size="70" maxSize="40" maxLength="40" value="${member.emailAddress}" ${ro}/>   -->
			            <input type="text" id="email" name="email" size="70" value="${v3x:toHTML(contactInfo.email)}" ${ro}/> 
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap" ${dis }>
                           <fmt:message key="hr.staffInfo.communication.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap" ${dis }> 
			               <input type="text" id="communication" name="communication" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.communication)}" ${ro}/>
                       </td>                     
                      </tr>
			          <tr>
			           <td class="bg-gray" nowrap="nowrap" ${dis }>
			               <fmt:message key="hr.staffInfo.postalcode.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" nowrap="nowrap" ${dis }>
			               <input type="text" id="postalcode" name="postalcode" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.postalcode)}" ${ro}/>
                       </td>
                      </tr>
			          <tr>
			           <td class="bg-gray" width="25%" nowrap="nowrap" align="right" ${dis }>
			               <fmt:message key="hr.staffInfo.address.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="75%" nowrap="nowrap" ${dis }>    
			               <input type="text" id="address" name="address" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.address)}" ${ro}/>
                       </td>
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap" ${dis }>
                           <fmt:message key="hr.staffInfo.website.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap" ${dis }> 
			               <input type="text" id="website" name="website" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.website)}" ${ro}/>
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap" ${dis }>
                           <fmt:message key="hr.staffInfo.blog.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap" ${dis }> 
			               <input type="text" id="blog" name="blog" size="70" maxLength="70" value="${v3x:toHTML(contactInfo.blog)}" ${ro}/>
                       </td>                     
                      </tr>
		            </table>
		       </td>
		       </tr>
		       
		       </table>
		    
			</div>		
		</td>
	</tr>
    <c:if test="${!ReadOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" id="btsubmit" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancelContactInfo()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
	
</table>
<script>
  bindOnresize('contactInfo',20,110);
</script>
</body>
</html>