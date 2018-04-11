<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%@ include file="webmailheader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
showCtpLocation("F13_sysMail");
function sendMail(){
	var testEmail = document.all.testEmail;
	if(!notNull(testEmail)){
		return false;
	}
	if(isEmail(testEmail)){
		try {
			var host = document.all.SMTP.value;
			var mailAddress = document.all.MailAddress.value;
			var password = document.all.Password.value;
			var smtpport = document.all.smtpport.value;
			var userName = document.getElementById("userName").value;
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxWebMailManager", "testSendEMail", false);
			requestCaller.addParameter(1, "String", host);
			requestCaller.addParameter(2, "String", mailAddress);
			requestCaller.addParameter(3, "String", password);
			requestCaller.addParameter(4, "String", testEmail.value);
			requestCaller.addParameter(5, "String", userName);
			requestCaller.addParameter(6, "String", smtpport);
			requestCaller.needCheckLogin = true;
			var result = requestCaller.serviceRequest();
			if(result == "true"){			
				alert("<fmt:message key='mail.test.send.ok'/>");
			}
			else{
				alert("<fmt:message key='mail.test.send.faile'/>");
			}
		}
		catch (ex1) {
			alert(ex1.message);
		}
	}
}

function setTimeInput(flag){
	var timeInputObj = document.getElementById("availTime");
	if(flag){
		timeInputObj.disabled = false;
	}
	else{	
		timeInputObj.disabled = true;
	}
}

function checkIsNum(){
	if(document.getElementById("radioYes").checked){
		var timeInputObj = document.getElementById("availTime");
		return isNumber(timeInputObj);
	}
}

<%--取消邮箱设置--%>
function cancelSetting(){
	if(confirm(_("MailLang.systemMailSetting_alertSure"))){
		location.href = "${webmailURL}?method=cancelSystemMailbox";
	}
}
<%--取消邮箱设置--%>
function sysback(){
		location.href = getA8Top().v3x.baseURL +"/portal/portalController.do?method=showSystemNavigation";
}
</script>
</head>
<body scroll="auto">
<form method="post" action="${webmailURL}" onsubmit="return checkForm(this)&&checkIsNum()">
<input type="hidden" name="configId" value="${configId}">
<input type="hidden" name="method" value="updateSystemMailbox">
<input type="hidden" name="oldAvailTime" value="${sysMailConfig.availableTime}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="emailSet"></div></td>
        <td class="page2-header-bg"><fmt:message key="label.mail.set" /></td>
        <td class="page2-header-line">&nbsp;</td>
	</tr>
</table>
</td>
</tr>
<tr>
	<td>
		<div class="scrollList">
			<table width="100%" height="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="280" align="center">
					<br><br>
						<fieldset style="width: 80%">
							<legend><b><fmt:message key="label.mail.set" /></b></legend>
							<TABLE width="100%" height="200" align="center" border="0" cellpadding="2" cellspacing="2">
							 <TR>
							   <TD height="32" align="right" width="35%">
									<font color="red">*</font><fmt:message key="label.alert.email"/>：
							   </TD>
							   <TD>
									<input type="text" name="MailAddress" class="input-300px" inputName="<fmt:message key='label.alert.email'/>" validate="notNull,isEmail" value="${sysMailConfig.emailAddress}">
							   </TD>
							</TR>
							<tr>
								<td height="32" align="right" width="35%"><fmt:message key='label.alert.pop' /><fmt:message key='label.mail.pop3.port' />:</td>
		                         <td >
		                          <input type="text" name="pop3port" class="input-300px" id="pop3port" maxlength="8" inputName="<fmt:message key='label.mail.pop3.port' />" validate="notNull,isNumber" 
		                             value="${sysMailConfig.pop3Port}"  />
		                          <fmt:message key='label.example'/>:110</td>
							</tr>
							
							<tr>
								<td height="32" align="right" width="35%"><fmt:message key='label.alert.smtp' /><fmt:message key='label.mail.pop3.port' />:</td>
				                <td class="new-column , bbs-tb-padding-topAndBottom">
				                 <input name="smtpport" type="text" id="smtpport" class="input-300px" maxlength="8" inputName="<fmt:message key='label.mail.pop3.port' />" validate="notNull,isNumber" 
				                 value="${sysMailConfig.smtpPort}" />
		                         <fmt:message key='label.example'/>:25</td>
							</tr>
							 <TR>
							   <TD height="32" align="right">
									<font color="red">*</font><fmt:message key="label.alert.smtp"/>：
							   </TD>
							   <TD>
									<input type="text" name="SMTP" class="input-300px" inputName="<fmt:message key='label.alert.smtp'/>" validate="notNull" value="${sysMailConfig.smtpHost}">
							   </TD>
							</TR>
							 <TR>
							   <TD height="32" align="right">
									<font color="red">*</font><fmt:message key="label.alert.username"/>：
							   </TD>
							   <TD>
									<input type="text" name="userName" id="userName"  class="input-300px" inputName="<fmt:message key='label.alert.username'/>" validate="notNull" value="${sysMailConfig.userName}">
							   </TD>
							</TR>  
							 <TR>
							   <TD height="32" align="right">
									<font color="red">*</font><fmt:message key="label.alert.password"/>：
							   </TD>
							   <TD>
									<input type="password" name="Password" class="input-300px" style="border: 1px solid #ccc;" inputName="<fmt:message key='label.alert.password'/>" validate="notNull" value="${sysMailConfig.emailPwd}">
							   </TD>
							</TR>  
							 <TR>
							   <TD height="32" align="right">
									<font color="red">*</font><fmt:message key="label.content.hasLink"/>：
							   </TD>
							   <TD>
							   		<label for="radioYes">
										<input id="radioYes" type="radio" name="isAppendLink" value="true" ${sysMailConfig.appendLink? 'checked':''} onclick="setTimeInput(true)"><fmt:message key="common.yes" bundle="${v3xCommonI18N}"/>
						   			</label>
						   			&nbsp;&nbsp;
						   			<label for="radioNo">
										<input id="radioNo" type="radio" name="isAppendLink" value="false" ${sysMailConfig.appendLink? '':'checked'} onclick="setTimeInput(false)"><fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
						   			</label>
							   </TD>
							</TR>
							<TR>
							   <TD height="32" align="right">
									<font color="red">*</font><fmt:message key="label.content.link.availTime"/>：
							   </TD>
							   <TD>
							   		<input type="text" id="availTime" class="input-300px" name="availTime" ${sysMailConfig.appendLink? '':'disabled'} value="${sysMailConfig.availableTime}" inputName="<fmt:message key='label.content.link.availTime'/>" integerMax='2147483647' integerMin='0' validate="isNumber">
							   </TD>
							</TR>							
							<TR>
							   <TD height="32" align="right">
									<fmt:message key="label.content.message.suffer"/>：
							   </TD>
							   <TD>
							   		<input type="text" id="suffer" class="input-300px" name="Suffer" value="${sysMailConfig.suffer}" inputName="<fmt:message key='label.content.message.suffer'/>" >
							   </TD>
							</TR>
							<TR>
                               <TD height="32" align="right">
                                    <fmt:message key="label.content.message.coll"/>：
                               </TD>
                               <TD>
                                    <label >
                                        <input id="radioSendYes" type="radio" name="isSendOnline" value="true" ${sysMailConfig.sendOnline ? 'checked':''} ><fmt:message key="common.yes" bundle="${v3xCommonI18N}"/>
                                    </label>
                                    &nbsp;&nbsp;
                                    <label >
                                        <input id="radioSendNo" type="radio" name="isSendOnline" value="false" ${sysMailConfig.sendOnline ? '':'checked'} ><fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
                                    </label>
                               </TD>
                            </TR>
							<tr>
								<td height="80" align="right" class="description-lable" valign="top">
									<br>
									<b><fmt:message key='common.description.label' bundle='${v3xCommonI18N}' />:</b>
								</td>
								<td class="description-lable" valign="top">
									<br>
									<fmt:message key="systemMailbox.setting.description"/>
								</td>
							</tr>
							<tr>
							</tr>
							</TABLE>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td height="100%" valign="top" align="center">                                 
						<br><br>
							<fieldset style="width: 80%">
								<legend><b><fmt:message key="mail.test.send"/></b></legend>
								<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
									<tr>
										<td align="right" width="30%" style="padding-right: 12px;">
											<fmt:message key="mail.test.address"/>：
										</td>
										<td width="30%">
											<input type="text" name="testEmail" inputName="<fmt:message key="mail.test.address"/>" class="input-300px">
										</td>
										<td width="40%" style="padding-left: 12px;">
											<input type="button" name="testBtn" value="<fmt:message key="mail.test.send.label"/>" class="button-default-4" onclick="sendMail()">
										</td>
									</tr>
								</table>
								<br>
							</fieldset>
						</td>
					</tr>
			</table>
		</div>
	</td>
</tr>	
	<tr>
		<td colspan="2" height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
			<input type="button" onclick="cancelSetting()" value="<fmt:message key='systemMailbox.setting.cancel' />" class="button-default-2">&nbsp;&nbsp;
			<input type="button" onclick="sysback()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</TABLE>
</form>
</body>
</html>