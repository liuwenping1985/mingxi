<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>密码安全设置</title>
<%@include file="../header.jsp"%>
<script type="text/javascript">
showCtpLocation('F13_passwordSecuritySet');
function setDivStyle(){
	var lan= "${v3x:getLanguage(pageContext.request)}";
	if(lan=="en"){
		$("#secDiv").attr("style","width: 800px;")
	}
}

function validate(){
//设置"登录失败次数"时必须设置"禁止登录期限"
var userLoginCountValue = document.getElementById("user_login_count").value;
var forbiddenLoginTimeValue = document.getElementById("forbidden_login_time").value;
var submitForm = document.getElementById("postForm");
var result = checkForm(submitForm);
	if(result){
		if(parseInt(userLoginCountValue) > 0 && parseInt(forbiddenLoginTimeValue) <= 0){
			alert(_("MainLang.userLoginCount_must_forbiddenLoginTime"));
			return false;
		}
	}
 	var initpwd = $("#initPassword").val();
 	var includeBytes = new Array('>', '<','\'', '|', ',','\"');
    var i;
    for (i = 0; i < includeBytes.length; i++)
    {
	    if (initpwd.indexOf(includeBytes[i])>=0){
	       var msg = "<fmt:message key='common.pwd.bytes.notinclude'/>"
		   msg= msg+"><\'|,\"";
		   alert(msg);
		   return false;
	    }
	}	
	   return true;
}

function changeShowType(showtype){
	if(showtype==1){
		//显示密文
		$("#initPasswordText").hide();
		$("#initPasswordTextView").hide();
		
		$("#initPassword").show();
		$("#initPasswordView").show();
		
	}else{
		//显示明文
		var pwd = $("#initPassword").val();
		$("#initPasswordText").val(pwd);
		
		$("#initPassword").hide();
		$("#initPasswordView").hide();
		
		$("#initPasswordText").show();
		$("#initPasswordTextView").show();
	}
	
}
</script>
</head>
<body class="padding5" scroll="yes" onload="setDivStyle();">
<form id="postForm" method="post" action="<html:link renderURL='/manager.do' />?method=passwordSecuritySet" onsubmit="return (checkForm(this) && validate())"><input id="individualName" type="hidden" name="individualName" value="${logerName}"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"> 
	  <tr>
	    <td valign="top" class="tab-body-bg" height="100%" align="center">
			<br><br><br><br>
			<div style="width: 500px;" id="secDiv">	
			<fieldset>
			<legend>
			<fmt:message key="system.menuname.passwordSecuritySet" />
			</legend>	<br/>			
						<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="common.pwd.pwdStrength.label" />:</label></td>
								<td class="new-column" width="80%">
								    <select name="pwd_strong_require" id="pwd_strong_require" class="condition" style="width:100px">
										<option value="weak" ${pwd_strong_require=='weak' ? "selected" : ""}><fmt:message key="common.pwd.pwdStrength.value1" /></option>
										<option value="medium" ${pwd_strong_require=='medium' ? "selected" : ""}><fmt:message key="common.pwd.pwdStrength.value2" /></option>
										<option value="strong" ${pwd_strong_require=='strong' ? "selected" : ""}><fmt:message key="common.pwd.pwdStrength.value3" /></option>
										<option value="best" ${pwd_strong_require=='best' ? "selected" : ""}><fmt:message key="common.pwd.pwdStrength.value4" /></option>
									</select>
								</td>
							</tr>
<%-- 							<tr>
							  <td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="systemswitch.pwdShowStrength.lable" />:</label></td>
							  <td class="new-column" width="80%">
							  <label for="pwdStrengthValidationEnable">
							  	<input id="pwdStrengthValidationEnable" name="pwd_strength_validation_enable" type="radio" value="enable" ${pwd_strength_validation_enable=='enable' ? 'checked' : ''}>
							    <fmt:message key="systemswitch.yes.lable"/>
							  </label>
							  <label for="pwdStrengthValidationDisable">
							      <input id="pwdStrengthValidationDisable" name="pwd_strength_validation_enable" type="radio" value="disable" ${pwd_strength_validation_enable=='disable' ? 'checked' : ''}>
							      <fmt:message key="systemswitch.no.lable"/>
							   </label>
							   </td>
							  </tr> --%>
							  
						     <tr>
						      <td class="bg-gray" width="15%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="systemswitch.userLoginCount.lable" />:</label></td>
							    <td class="new-column" width="85%">
							    	<input class="input-date" maxlength="6" type="text" id="user_login_count" name="user_login_count"
							    	 value="${user_login_count}" inputName="<fmt:message key='systemswitch.userLoginCount.lable'/>" validate="notNull,isInteger" style="width:100px">
							    	<fmt:message key="systemswitch.userLoginCount.lable.desc"/>
							   </td>
							  </tr>
							  <!-- 新增禁止登录期限 -->
							   <tr>
							   <td class="bg-gray" width="15%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="systemswitch.forbiddenLoginTime.lable" />:</label></td>
							    <td class="new-column" width="85%">
							    	<input class="input-date" maxlength="6" type="text" id=forbidden_login_time name="forbidden_login_time" style="width:100px"
							    	 type="input" value="${forbidden_login_time}" inputName="<fmt:message key='systemswitch.forbiddenLoginTime.lable'/>" validate="notNull,isInteger">
							    	<fmt:message key="systemswitch.forbiddenLoginTime.lable.desc"/></td>
							  </tr>			  
							<tr>
							<input id="oldpwd_expiration_time" type="hidden" name="oldpwd_expiration_time" value="${pwd_expiration_time}" />
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font> <fmt:message key="common.pwd.expirationime.label" />:</label></td>
								<td class="new-column" width="80%">
									<select name="pwd_expiration_time" id="pwd_expiration_time" class="condition" style="width:100px">
										<option value="30" ${pwd_expiration_time=='30' ? "selected" : ""}><fmt:message key="common.pwd.expirationime.value1" /></option>
										<option value="90" ${pwd_expiration_time=='90' ? "selected" : ""}><fmt:message key="common.pwd.expirationime.value2" /></option>
										<option value="180" ${pwd_expiration_time=='180' ? "selected" : ""}><fmt:message key="common.pwd.expirationime.value3" /></option>
										<option value="360" ${pwd_expiration_time=='360' ? "selected" : ""}><fmt:message key="common.pwd.expirationime.value4" /></option>
										<option value="0" ${pwd_expiration_time=='0' ? "selected" : ""}><fmt:message key="common.pwd.expirationime.value0" /></option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap">
									<input class="bg-gray" width="20%" class="radio_com" type="checkbox"   id="pwdmodify_force_enable" name="pwdmodify_force_enable" ${pwdmodify_force_enable == 'disable'? '':'checked'}>
								</td>
								<td class="new-column" width="80%"><fmt:message key="common.pwd.modifyForce.label" /></td>
							</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap">
									<input class="bg-gray" width="20%" class="radio_com" type="checkbox"  id="pwdmodify_same_enable" name="pwdmodify_same_enable" ${pwdmodify_same_enable == 'disable'? '':'checked'}>
								</td>
								<td class="new-column" width="80%"><fmt:message key="common.pwd.modifysame.label" /></td>
							</tr>
							<!-- 新增新建账号初始密码 -->
							   <tr>
							   <td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="systemswitch.initPassword.lable" />:</label></td>
							    <td class="new-column" width="80%">
							    	<input class="input-date" type="password" id="initPassword" style="width:100px" name="initPassword" maxLength="50" validate="minLength,maxLength" maxSize="50" minLength="6"
							    	  value="${initPassword}" inputName="<fmt:message key='systemswitch.initPassword.lable'/>">
							    	  <a id="initPasswordView" onclick="changeShowType(2);"><img src="<c:url value="/apps_res/sysMgr/img/hiddenpwd.gif${v3x:resSuffix()}" />" align="center"/></a>
							    	  
							    	 <input  onfocus="this.blur();" class="input-date" type="text" id="initPasswordText" readonly="readonly" style="width:150px;display:none;background:#F8F8F8;"  maxLength="50" validate="minLength,maxLength" maxSize="50" minLength="6"
							    	  value="${initPassword}" inputName="<fmt:message key='systemswitch.initPassword.lable'/>">
							    	  <a style="display:none;" id="initPasswordTextView" onclick="changeShowType(1);"><img src="<c:url value="/apps_res/sysMgr/img/showpwd.gif${v3x:resSuffix()}" />" align="center"/></a>
							    </td>
							  </tr>	
							  <tr>
						</table>
						<label><font color="red"><fmt:message key="systemswitch.initPassword.desc.lable" /></font></label>
						<br/>			
						</fieldset>				
			</div>
			
		</td>
	</tr>
	<tr id="submitOk" style="display: ">
		<td height="42" align="center" class="tab-body-bg bg-advance-bottom" >
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="getA8Top().document.getElementById('homeIcon').click();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
$(document).ready(function(){
	　　var width = $("#initPassword").width(); 
		$("#initPassword").width(width+50);
	}); 
</script>
</body>
</html>
