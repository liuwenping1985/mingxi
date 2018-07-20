<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<%@ include file="./mobileOfficeUserAuth_js.jsp"%>
<link type="text/css" rel="stylesheet"  href="<c:url value='/apps_res/m1/css/orgAuth.css${v3x:resSuffix()}' />">
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
	  	<div class="comp" comp="type:'breadcrumb',code:'M01_officeAuth'"></div> 
	    <div class="layout_north" layout="height:30,sprit:false,border:false">
	         <div id="toolbar"></div>
	    </div>
	    <div class="layout_center over_hidden" layout="border:true" id="center">
				
			<div class="stadic_layout form_area" id='form_area'>
				<form id="auth_form" method="post" action="<c:url value='/m1/mobileOfficeAuth.do' />?method=saveUserAuthList">
					<input type = "hidden" id = "entityIDs" name = "entityIDs" value = "${entityID}">
					<input type = "hidden" id = "maxAuthNumber" name = "maxAuthNumber" value = "${maxAuthNumber}">
					<input type = "hidden" id = "userdAuthNumber" name = "userdAuthNumber" value = "${userdAuthNumber}">
					<input type = "hidden" id = "remainAuthNumber" name = "remainAuthNumber" value = "${remainAuthNumber}">
					<br/>
					<br/>
					<br/> 
					<table border="0" bordercolor="black" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
						
						<tr>
							<td>
							<div>
							<fieldset ><legend><font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('m1.mobileOfficeAuth.mobileOfficeAuthLabel')}</font></legend>
						 
							<table id="tablestyle" >
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.seriesNumber')}:</td>
								<td class="new-column" ><font id ="seriesNumber">${seriesNumber}</font> </td>
							</tr>
							<tr class="trstyle">
							 	<td> </td>
								<td  class="bg-gray" align="left" colspan="2"><font color="red">${ctp:i18n('m1.mobileOfficeAuth.messageInfo')}</font></td>
							</tr>
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.maxAuthNumberLabel')}:</td>
								<td class="new-column" ><font id = "maxAuthNumberLabel">${maxAuthNumber}</font></td>
							</tr>
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.userdAuthNumberLabel')}:</td>
								<td class="new-column" ><font id = "userdAuthNumberLabel"> ${userdAuthNumber}</font></td>
							</tr>
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.remainAuthNumberLabel')}:</td>
								<td class="new-column" ><font id = "remainAuthNumberLabel">${remainAuthNumber}</font></td>
							</tr>
							<tr class="trstyle">
					   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.mobileOfficeAuthLabel')}:</td>
								<td class="new-column"><textarea  id = "authlist" rows="5" cols="60" readonly="readonly" style="color:gray;overflow-y:auto" disabled="disabled" >${entityNameList}</textarea></td>
							</tr>
							</table>
							</fieldset>
							</div>
							</td>
							</tr>
						</table>
					</form>
					
			</div>
				
				
		</div>
		<div class="stadic_layout_footer stadic_footer_height">
         	<div id="button_area" align="center" class="page_color button_container">
				<a id="btnsubmit" href="javascript:void(0)"
					class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
					&nbsp; 
				<a id="btncancel" href="javascript:void(0)"
				class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
			</div>
		</div>
	</div>
</body>
</html>