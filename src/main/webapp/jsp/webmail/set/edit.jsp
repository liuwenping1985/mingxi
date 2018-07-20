<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>	
<%@ include file="../webmailheader.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='label.mail' />-<fmt:message key='label.mail.set' /></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">

function doSave()
{
	var form = document.getElementById("setForm");
	if(checkForm(form))
	{
		form.action="${webmailURL}?method=doSet";
		if(v3x.getBrowserFlag('pageBreak')){
			form.target= "_parent";
		}else{
			form.target= "_self";
		}
		form.submit();
		try{
		    getA8Top().startProc('');
		}catch(e){}
	}
}

function doReset(){
	document.getElementById("to").value = "";
	document.getElementById("pop3port").value = "110";
	document.getElementById("pop3host").value = "";
	document.getElementById("smtphost").value = "";
	document.getElementById("smtpport").value = "25";
	document.getElementById("username").value = "";
	document.getElementById("password").value = "";
	document.getElementById("pop3ssl").checked = false;
	document.getElementById("smtpssl").checked = false;
	document.getElementById("isBackup1").checked = true;
	document.getElementById("isDefault1").checked = true;
}
</script>
<script type="text/javascript">
<!--

var showButtonFlag = true; 
if(window.dialogArguments || window.opener){
	showButtonFlag = false;
}


//-->
</script>
<style>

/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
  position:absolute;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:12px 0px 0px 0px;
  position:absolute;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
  position:absolute;
  bottom:10px;
  top:10px;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:12px;
 bottom:0px;
}
.top_div_row2 {
 height:12px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
.text-align{
	text-align:left;
	}
/***layout*row1+row2****end**/
</style>
</head>
<body scroll="no" topmargin="0px" leftmargin="0px">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
			<tr align="center">
				<td height="8" class="">
					<script type="text/javascript">
					getDetailPageBreak(); 
				</script>
				</td>
			</tr>	
		</table>	
    </div>
    <div class="center_div_row2" style="overflow-x:hidden;">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"  align="center" class="">
		<form name=setForm id="setForm" method="post" onsubmit="return checkForm(this)">
		<input type="hidden" name="id_email" value='<c:out value="${bean.email}" />' />
		<input type="hidden" name="timeout" class="form1" value="120">
			<tr>
				<td class="">
					<div class=""><br/><br/>
						<center><table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top" style="padding-top:2px;"><fmt:message key='label.alert.email' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align" nowrap="nowrap">
		        <input name=email type="text" id="to" style="width:200px" deaultValue="" inputName="<fmt:message key='label.alert.email' />"
		               validate="notNull,isEmail" value='<c:out value="${bean.email}" />' escapeXml="true" default=''  
		               <c:if test="${param.flag == 'view'}">disabled</c:if>
		               />
		               <fmt:message key='label.example'/>:sameone@sina.com</td>
							</tr>
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top" style="padding-top:2px;"><fmt:message key='label.alert.pop' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=pop3host type="text" id="pop3host" style="width:200px" deaultValue="" inputName="<fmt:message key='label.alert.pop' />"
		               validate="notNull" value='<c:out value="${bean.pop3Host}" />' escapeXml="true" default='' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               />
		               <fmt:message key='label.example'/>:pop3.sina.com</td>
							</tr>
								<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top" style="padding-top:2px;"><fmt:message key='label.alert.pop' /><fmt:message key='label.mail.pop3.port' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=pop3port type="text" id="pop3port" style="width:200px" deaultValue="" inputName="<fmt:message key='label.mail.pop3.port' />"
		               validate="isInteger,notNull" max="65535" min="0" value='<c:out value="${bean.pop3Port}" />' escapeXml="true" default='110' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               />
		               <fmt:message key='label.example'/>:110</td>
							</tr>
							
								<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='label.mail.pop3.ssl' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input type="checkbox" <c:if test="${param.flag == 'view'}">disabled</c:if> <c:if test="${bean.pop3Ssl == true}">checked</c:if> name="pop3ssl" id="pop3ssl" value="1" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</tr>
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top" style="padding-top:2px;"><fmt:message key='label.alert.smtp' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=smtphost type="text" id="smtphost" style="width:200px" deaultValue="" inputName="<fmt:message key='label.alert.smtp' />"
		               validate="notNull" value='<c:out value="${bean.smtpHost}" />' escapeXml="true" default='' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               />
		               <fmt:message key='label.example'/>:smtp.sina.com</td>
							</tr>
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top" style="padding-top:2px;"><fmt:message key='label.alert.smtp' /><fmt:message key='label.mail.pop3.port' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=smtpport type="text" id="smtpport" style="width:200px" deaultValue="" inputName="<fmt:message key='label.mail.pop3.port' />"
		               validate="isInteger,notNull" max="65535" min="0" value='<c:out value="${bean.smtpPort}" />' escapeXml="true" default='25' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               />
		               <fmt:message key='label.example'/>:25</td>
							</tr>
								<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='label.mail.pop3.ssl' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input type="checkbox" <c:if test="${param.flag == 'view'}">disabled</c:if> <c:if test="${bean.smtpSsl == true}">checked</c:if> name="smtpssl" id="smtpssl" value="1"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</tr>
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='label.alert.username' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=username type="text" id="username" style="width:200px" deaultValue="" inputName="<fmt:message key='label.alert.username' />"
		               validate="notNull" value='<c:out value="${bean.userName}" />' escapeXml="true" default='' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               /></td>
							</tr>
							
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='label.alert.password' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		        <input name=password type="password" id="password" style="width:200px" deaultValue="" inputName="<fmt:message key='label.alert.password' />"
		               validate="notNull" value='<c:out value="${bean.password}" />' escapeXml="true" default='' 
		                <c:if test="${param.flag == 'view'}">disabled</c:if>
		               /></td>
							</tr>
							
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='label.alert.backupflag' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		    	<label for="isBackup1">
		        <input type="radio" <c:if test="${param.flag == 'view'}">disabled</c:if> id="isBackup1" name="isBackup" value="1" <c:choose><c:when test="${bean.backup}">checked</c:when><c:otherwise></c:otherwise></c:choose> />&nbsp;<fmt:message key='label.new.saveprepare' /></label>&nbsp;&nbsp;&nbsp;&nbsp;
		        <label for="isBackup2">
		        <input type="radio" <c:if test="${param.flag == 'view'}">disabled</c:if> id="isBackup2" name="isBackup" value="0" <c:choose><c:when test="${bean.backup}"></c:when><c:otherwise>checked</c:otherwise></c:choose> />&nbsp;<fmt:message key='label.new.delete' /></label></td>
							</tr>
							
							<tr>
								<td width="15%" height="29" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap><fmt:message key='button.setdefault' />:</td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
		    	<label for="isDefault1">
				<input type="radio" <c:if test="${param.flag == 'view'}">disabled</c:if> id="isDefault1" name="isDefault" value="1" <c:choose><c:when test="${bean.defaultBox}">checked</c:when><c:otherwise></c:otherwise></c:choose> /><fmt:message key='label.new.yes' /></label>&nbsp;&nbsp;
				<label for="isDefault2">
				<input type="radio" <c:if test="${param.flag == 'view'}">disabled</c:if> id="isDefault2"  name="isDefault" value="0" <c:choose><c:when test="${bean.defaultBox}"></c:when><c:otherwise>checked</c:otherwise></c:choose> /><fmt:message key='label.new.not' /></label>&nbsp;&nbsp;
			</td>
							</tr>
					<tr>
								<td width="15%" height="29" align="right" class="bg-gray , bbs-tb-padding-topAndBottom " nowrap><font class="description-lable">*</font></td>
		    <td class="new-column , bbs-tb-padding-topAndBottom text-align">
			<font class="description-lable"><fmt:message key="label.set.pop.service.open" /></font>
			</td>
							</tr>
							
						</table></center>
					</div>		
				</td>
			</tr>
			 <c:if test="${param.flag == 'edit' || param.flag == 'new'}">
			 <tr>
				<td height="30" align="center" class="">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td height="30" align="center" class="">
					<input type="button" class="button-default-2" value="<fmt:message key='button.sure'/>" onclick="doSave()" />	
					<input type="button" class="button-default-2" value="<fmt:message key='button.reset'/>" onclick="doReset()" />
				</td>
			</tr>
			</c:if>
		
		</form>	
		</table>
    </div>
  </div>
</div>

</body>
</html>