<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/systemmanager/js/individualManager.js${v3x:resSuffix()}'/>"></script>
<title><fmt:message key="system.password.protecd.set"></fmt:message></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function checkWrod(){
  var formObj = document.getElementById('setPassWord') ;
   if(!checkForm(formObj)){
      return false ;
   }
   if(!validate()){
        return false;
   }
   return true ;
}

function cancel(){
	transParams.parentWin.dialogCollFun('');
}
function OK(){
	var setPassWord = document.getElementById('setPassWord');
	setPassWord.submit();
}

function returnValueAndClose(returnValue) {
	transParams.parentWin.dialogCollFun(returnValue);
}
</script>
<style>
.PopupTitle {
	padding: 0px 0px 15px 15px;
	height: 16px;
	line-height: 16px;
}
</style>
</head>
<body scroll="no" style="overflow:hidden;">
<form action="${urlHrViewSalary}?method=setPassWord" target = 'submitFrame' name="setPassWord" id="setPassWord" method="post" onsubmit="return checkWrod()">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight" style="background:#fafafa;">
	<tr class="PopupTitle" height="20">
	  <td class="PopupTitle" colspan="2"><fmt:message key="system.password.protecd.set"></fmt:message></td>
	</tr>
	<!-- <tr><td height="20" colspan="2"></td></tr> -->
	<tr>
		<td class="bg-gray" width="30%" nowrap="nowrap" align="right"><label for="post.code"><font color="red">*</font><fmt:message key="sys.password.lable" />:</label></td>
		<td class="new-column"><input type="password" width="70%" maxlength="50" id="newPassword" 
		<c:if test="${pwdStrengthValidation==1 }">
		onKeyUp="EvalPwdStrength(document.forms[0],this.value);"  
		</c:if>
		style="width:162px" inputName="<fmt:message key="sys.password.lable" />" name="newPassword"  minLength="6" maxLength="50" validate="notNull,isCriterionWord,minLength,maxLength" ></td>
	</tr>
	<c:if test="${pwdStrengthValidation==1 }">
	<tr>
		<td class="bg-gray" align="right" nowrap="nowrap"><label for="post.code"><fmt:message key="common.pwd.pwdStrength.label" bundle="${v3xCommonI18N }"/>:</label></td>
		<td class="new-column" >
			<table cellpadding="0" cellspacing="0" class="pwdChkTbl2,input-60per" width="60%">
				<tr>
					<td id="idSM1" width="25%" class="pwdChkCon0" align="center"><span
						style="font-size:1px">&nbsp;</span><span id="idSMT1"
						style="display:none;"><fmt:message key="common.pwd.pwdStrength.value1" bundle="${v3xCommonI18N }"/></span></td>
					<td id="idSM2" width="25%" class="pwdChkCon0" align="center"
						style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span>
						<span id="idSMT0" style="display:inline;font-weight:normal;color:#666"><fmt:message key="common.pwd.pwdStrength.value0" bundle="${v3xCommonI18N }"/></span>
						<span id="idSMT2" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value2" bundle="${v3xCommonI18N }"/></span></td>
					<td id="idSM3" width="25%" class="pwdChkCon0" align="center"
						style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
						id="idSMT3" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value3" bundle="${v3xCommonI18N }"/></span></td>
					<td id="idSM4" width="25%" class="pwdChkCon0" align="center"
						style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
						id="idSMT4" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value4" bundle="${v3xCommonI18N }"/></span></td>
				</tr>
			</table>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="bg-gray" align="right" nowrap="nowrap"><label
			for="post.code"> <font color="red">*</font><fmt:message key="manager.validate.notnull" />:</label></td>
		<td class="new-column" >
			<input id="validatepass" style="width:162px" type="password" name="validatepass" value="" inputName="<fmt:message key="manager.validate.notnull" />"  minLength="6" maxLength="50" validate="notNull,isCriterionWord,minLength,maxLength" />
		</td>
	</tr>
	<!-- <tr>
    	<td>&nbsp;</td>
    	<td valign="top"><div id="validateInfo" style="color: red;"></div></td>
    </tr> -->
	<tr>
		<td>&nbsp;</td>
		<td class="description-lable" valign="top"><fmt:message key="manager.vaildate.length.rep.lable"/></td>
	</tr>
	<tr>
	    <td class="bg-advance-bottom" colspan="2">
		     <input type="submit" style="margin-left:226px;" class="button-default_emphasize margin_r_10" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" id="b1" name="b1" /><input type="button" onclick="cancel()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" id="b2" name="b2" />
	    </td>
	</tr>
</table>
</form>
<iframe name="submitFrame" frameborder="0"></iframe>
</body>
</html>
