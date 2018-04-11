<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/systemmanager/js/individualManager.js${v3x:resSuffix()}'/>">
</script>
<title><fmt:message key="system.password.protecd.person" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var onlyLoginAccount_members = true;
var showConcurrentMember_members = false;
var hiddenOtherMemberOfTeam_members = true;
function checkWrod(){
  var formObj = document.getElementById('setPassWord') ;
   if(!checkForm(formObj)){
      return false  ;
   }
   if(!validate()){
        return  false;
   }
   return  true ;
}

function cancel(){
	getA8Top().winSalaryPwd.close();
}

function setPeopleFields(elements){
   if(!elements){
   		return ;
   }
   var elementsIds = getIdsString(elements,false) ;
   var memberNames = getNamesString(elements) ;	 
   document.getElementById("updateMembers").value = elementsIds ;
   document.getElementById("members").value = memberNames ;
}

function returnValueAndClose(returnValue) {
    getA8Top().winSalaryPwd.close();
}
 onlyLoginAccount_members = true;
</script>
</head>
<body scroll='no' style="height: 100%;overflow: hidden;">
<v3x:selectPeople id="members" panels="Department,Team,Post" selectType="Member" jsFunction="setPeopleFields(elements)"/>
<form action="${urlHrSalary}?method=updatePersonsPassWord"  target='submitFrame' name="setPassWord" id="setPassWord" method="post" onsubmit="return checkWrod()">
<input type="hidden" name="updateMembers" id="updateMembers" value="">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight" style="background:#fafafa;">
	<tr class="PopupTitle" height="20">
	  <td class="PopupTitle" colspan="2"><fmt:message key="system.password.protecd.person"></fmt:message></td>
	</tr>
    <tr>
      <td height="20" colspan="2"></td>
    </tr>
	<tr>
		<fmt:message key="common.default.selectPeople.value" var="defMember" bundle="${v3xCommonI18N}" />
		<td class="bg-gray" width="30%" nowrap="nowrap"><label for="post.code"><font color="red">*</font><fmt:message key="system.password.protecd.member" />:</label></td>
		<td class="new-column"><input type="text" width="80%" default="${defMember}" value="${defMember}" deaultValue="${defMember}" id="members" class="input-60per" inputName="<fmt:message key="system.password.protecd.member" />" name="members" validate="notNull,isDeaultValue" onclick="selectPeopleFun_members()" readonly="readonly"></td>
	</tr>
	<tr>
		<td class="bg-gray" width="30%" nowrap="nowrap"><label for="post.code"><font color="red">*</font><fmt:message key="sys.password.lable" />:</label></td>
		<td class="new-column"><input type="password" width="80%" id="newPassword" 
		<c:if test="${pwdStrengthValidation==1 }">
			onKeyUp="EvalPwdStrength(document.forms[0],this.value);"  
		</c:if>
		class="input-60per" inputName="<fmt:message key="sys.password.lable" />" name="newPassword" minLength="6" maxLength="50" validate="notNull,isCriterionWord,minLength,maxLength" ></td>
	</tr>
	<c:if test="${pwdStrengthValidation==1 }">
	<tr>
		<td class="bg-gray" width="30%" nowrap="nowrap"><label for="post.code"><fmt:message key="common.pwd.pwdStrength.label" bundle="${v3xCommonI18N }"/>:</label></td>
		<td class="new-column" width="60%">
		<table cellpadding="0" cellspacing="0" class="pwdChkTbl2,input-60per"  width="60%">
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
		<td class="bg-gray" width="30%" nowrap="nowrap"><label for="post.code"> <font color="red">*</font><fmt:message key="manager.validate.notnull" />:</label></td>
		<td class="new-column" width="80%">
			<input id="validatepass" class="input-60per" type="password" name="validatepass" value="" inputName="<fmt:message key="manager.validate.notnull" />" minLength="6" maxLength="50" validate="notNull,isCriterionWord,minLength,maxLength"/>
		</td>
	</tr>
	<tr>
	   	<td>&nbsp;</td>
	   	<td valign="top"><div id="validateInfo" style="color: red;"></div></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td class="description-lable"><fmt:message key="manager.vaildate.length.rep.lable"/></td>
	</tr>
	<tr>
         <td class="bg-advance-bottom" colspan="2">
	          <input type="submit" style="margin-left:226px;" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" id="b1" name="b1"/>
	          <input type="button" onclick="cancel()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" id="b2" name="b2"/>
         </td>
	</tr>
</table>
</form>
<iframe name="submitFrame" frameborder="0"></iframe>
</body>
</html>
