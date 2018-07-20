<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"/>
<html>
<head>
<script type="text/javascript">
<!--
  //window.attachEvent("onload",   setSize);   
  //function   setSize(){   
  //   var   myHeight=200;        
  //   var   myWidth=500;   
  //   window.resizeTo(myWidth,myHeight);   
  //   window.moveTo((window.screen.availWidth-myWidth)/2,     (window.screen.availHeight-myHeight)/2);    
  //} 
 function reSet() {
	document.location.href = '<c:url value="/common/detail.jsp" />';
 }
 function check(){
   var ce=/^\d+$/;
   var beginHour = document.getElementById("beginHour").value;
   var beginMinute = document.getElementById("beginMinute").value;
   var endHour = document.getElementById("endHour").value;
   var endMinute = document.getElementById("endMinute").value;
   if(beginHour=="" || beginMinute=="" || endHour=="" || endMinute==""){
     alert(v3x.getMessage("HRLang.hr_record_workingTime_notNull"));
     return false;
   }

   if(ce.test(beginHour) && ce.test(beginMinute) && ce.test(endHour) && ce.test(endMinute)){     
     if(parseInt(beginHour,10)>=0 && parseInt(beginHour,10)<25 && parseInt(endHour,10)>=0 && parseInt(endHour,10)<25){
       if(parseInt(beginMinute,10)>=0&parseInt(beginMinute,10)<60&parseInt(endMinute,10)>=0&parseInt(endMinute,10)<60){
       	 if((parseInt(beginHour,10)<parseInt(endHour,10))||(parseInt(beginHour,10)==parseInt(endHour,10)&&parseInt(beginMinute,10)<parseInt(endMinute,10))){
         	if(confirm(v3x.getMessage("HRLang.hr_record_workingTime_submit"))){
         		workingTimeForm.submit();  
         	}
         }else{
         		alert(v3x.getMessage("HRLang.hr_record_workingTime_confine"));
         		return false;
         		}
       }
       else{
         alert(v3x.getMessage("HRLang.hr_record_workingTime_number"));
         return false;
       }
     }
     else{
       alert(v3x.getMessage("HRLang.hr_record_workingTime_number"));
       return false;
     }
   }
   else{
     alert(v3x.getMessage("HRLang.hr_record_workingTime_number"));
     return false;
   } 

 }
//-->
</script>
</head>
<body scroll="no" style="overflow: no">
<form name="workingTimeForm" method="post" action="${hrRecordURL}?method=workingTime">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak();  
			//document.write("<img src=\"/seeyon/common/images/button.preview.up.gif\" height=\"8\" onclick=\"previewFrame('Up')\" class=\"cursor-hand\">");
			//document.write("<img src=\"/seeyon/common/images/button.preview.down.gif\" height=\"8\" onclick=\"previewFrame('Down')\" class=\"cursor-hand\">");
			//document.close();
		</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="hr.toolbar.salaryinfo.setWorkingTime.label" bundle="${v3xHRI18N}" /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  					<tr align="center">
   		 				<td width="50%">
   		 					<fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.checkin.label" bundle="${v3xHRI18N}" /></strong></legend>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
									<tr>
										<td><p>&nbsp;</p></td>
									</tr>
									<tr>
										<td width="50%" align="center">
											<label style="width:80"><fmt:message key="hr.record.checkinTime.stated.label" bundle="${v3xHRI18N}" /></label>
										</td>
										<td width="50%" align="center">
  											<input type="text" size="12" name="beginHour" id="beginHour" value="${workingTime.begin_hour}">
  											<fmt:message key="hr.workingtime.hour.label" bundle="${v3xHRI18N}" />
  										</td>
  									</tr>
  									<tr>
										<td><p>&nbsp;</p></td>
									</tr>
  									<tr>
  										<td>
  											<label style="with:20">&nbsp;</label>
  										</td>
  										<td align="center">
  											<input type="text" size="12" name="beginMinute" id="beginMinute" value="${workingTime.begin_minute}">
  											<fmt:message key="hr.workingtime.minute.label" bundle="${v3xHRI18N}" />
  										</td>
									</tr>
									<tr>
										<td><p>&nbsp;</p></td>
									</tr>
								</table>
							</fieldset>
							<p></p>
   		 				</td>
   		 			</tr>
   		 			<tr align="center">
   		 				<td width="50%">
   		 					<fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.checkout.label" bundle="${v3xHRI18N}" /></strong></legend>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
									<tr>
										<td><p>&nbsp;</p></td>
									</tr>
									<tr>
										<td width="50%" align="center">
											<label style="width:80"><fmt:message key="hr.record.checkoutTime.stated.label" bundle="${v3xHRI18N}" /></label>
										</td>
										<td width="50%" align="center">
  											<input type="text" size="12" name="endHour" id="endHour" value="${workingTime.end_hour}">
  											<fmt:message key="hr.workingtime.hour.label" bundle="${v3xHRI18N}" />
  										</td>
  									</tr>
  									<tr>
										<td><p>&nbsp;</p></td>
									</tr>
  									<tr>
  										<td>
  											<label style="with:20">&nbsp;</label>
  										</td>
  										<td align="center">
  											<input type="text" size="12" name="endMinute" id="endMinute" value="${workingTime.end_minute}">
  											<fmt:message key="hr.workingtime.minute.label" bundle="${v3xHRI18N}" />
  										</td>
									</tr>
									<tr>
										<td><p>&nbsp;</p></td>
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
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<button onclick="check()" class="button-default-2"><fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" /></button>&nbsp;
			<button onclick="reSet()" class="button-default-2"><fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" /></button>
		</td>
	</tr>
</table>
</form>
</body>
</html>