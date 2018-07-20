<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ include file="../header.jsp" %>
<title><fmt:message key="selectPeople.saveAsTeam.lable" /></title>
<script type="text/javascript">
var _parent = window.opener;
if(window.dialogArguments){
	_parent = window.dialogArguments;
}

var members = _parent.saveAsTeamData; //Element[]
var memberIds = getIdsString(members, false);
var memberNames = getNamesString(members);
			
function endSaveAsTeam(teamId){
	_parent.addPersonalTeam(teamId, document.getElementById("teamName").value, members);
	window.close();
}
// 判断是否用重复的名
function validateName(){
	var nameValue = document.getElementById("teamName").value;
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManagerDirect", "isPropertyDuplicatedTeam", false);
	requestCaller.addParameter(1, "String", "V3xOrgTeam");
	requestCaller.addParameter(2, "String", "name");
	requestCaller.addParameter(3, "String", nameValue);
	var team = requestCaller.serviceRequest();
	if (team=="true") {
			alert(_("V3XLang.selectPeople_saveAsTeam_same_personal_name"));
		return false ;
	}else{
		return true ;
	}
}

function save(){
	var thisForm = document.getElementById("teamForm");
	if(checkForm(thisForm) && validateName()){
		thisForm.submit();
		document.getElementById("b1").disabled = true;
		document.getElementById("b2").disabled = true;
	}
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form id="teamForm" action="<html:link renderURL='/main.do?method=saveAsTeam' />" method="post" target="saveAsTeamFrame">
<input id="memberIds" type="hidden" name="memberIds" value="" inputName='<fmt:message key="selectPeople.saveAsTeam.members.lable" />' validate="notNull">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="selectPeople.saveAsTeam.lable" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></div>
			<div><input type="text" class="input-100per" name="teamName" id="teamName"
				inputName='<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />'
				maxSize="40" maxlength="40"  validate="isDeaultValue,notNull,maxLength,isWord">
			</div>
			<div style="padding-top: 5px"><fmt:message key="selectPeople.saveAsTeam.members.lable" /></div>
			<div><input id="memberNames" value="" readonly="readonly" class="input-100per"></div>			 
			<script type="text/javascript">			
			document.getElementById("memberIds").value = memberIds;
			document.getElementById("memberNames").value = memberNames;
			document.getElementById("memberNames").title = memberNames;
			</script>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input id="b1" type="button" onclick="save()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input id="b2" type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<iframe src="javascript:void(null)" name="saveAsTeamFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>