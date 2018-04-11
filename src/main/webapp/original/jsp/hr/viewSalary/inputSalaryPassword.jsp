<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/systemmanager/js/individualManager.js${v3x:resSuffix()}'/>"></script>
<title><fmt:message key="menu.hr.salary.view.manager" bundle="${v3xMainI18N}" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	function checkPassWrod(){
	  var formObj = document.getElementById('setPassWord') ;
	   if(!checkForm(formObj)){
	      return false;
	   }
	   return true;
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
</head>
<body scroll='no' style="overflow: hidden;">
<form action="${urlHrViewSalary}?method=checkPassword" name="setPassWord" id="setPassWord" target="submitFrame" method="post" onsubmit="return checkPassWrod()">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight" style="background:#fafafa;">
	<tr class="PopupTitle" height="20">
	  <td class="PopupTitle" colspan="2"><fmt:message key="sys.password.lable.view.lable"/></td>
	</tr>
    <tr><td height="5" colspan="2"></td></tr>
	<tr valign="middle">
		<td class="bg-gray" width="120" nowrap="nowrap" align="right"><label for="post.code"><font color="red">*</font><fmt:message key="sys.password.lable" />:</label></td>
		<td class="new-column"><input type="password" maxlength="50" id="newPassword" style="width:162px" class="input-80per" inputName="<fmt:message key="sys.password.lable" />" name="newPassword" validate="notNull"></td>
	</tr>
	<tr><td height="5" colspan="2"></td></tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr valign="bottom">
        <td class="bg-advance-bottom" colspan="2">
         <input type="submit" style="margin-left:226px;" class="button-default_emphasize margin_r_10" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" id="b1" name="b1" /><input type="button" onclick="cancel()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" id="b2" name="b2" />
        </td>
	</tr>
</table>
</form>
<iframe name="submitFrame" frameborder="0"></iframe>
</body>
</html>
