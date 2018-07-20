<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="../common/INC/noCache.jsp" %>
<%@ include file="header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='common.my.peoplerelate.add' bundle='${v3xMainI18N}' /></title>
<script type="text/javascript">
var dia = window.parentDialogObj['url'];
function closeMe() {
	if(window.parentDialogObj['url']){
		dia.close();
	}else{
		window.close();
	}
}
	
function returnValue(){
	alertSuccess(v3x.getMessage("relateLang.save_success"));
	closeMe();
}
function isSelect(){

	if(document.getElementById('relateType').disabled){
		closeMe();
		return false;
	}
	
	var obj = document.getElementById('relateType');
	var objId = document.getElementById('receiverId');
	var relateType = "${relateType}";
	var memberName = "${v3x:showMemberNameOnly(receiverId)}";
	var sValue = obj.value;
	if(sValue!='' && objId.value!=''){
		if(relateType == '1'  && sValue != '3'){
			alertInfo(v3x.getMessage("relateLang.has_set_leader",memberName));
			return false;
		}
		if(relateType == '2' && sValue != '1'){
			alertInfo(v3x.getMessage("relateLang.has_set_assistant",memberName));
			return false;
		}
		if(relateType == '3' && sValue != '1'){
			alertInfo(v3x.getMessage("relateLang.has_set_junior",memberName));
			return false;
		}
		if(relateType == '4' && sValue != '4'){
			alertInfo(v3x.getMessage("relateLang.has_set_confrere",memberName));
			return false;
		}
		return true;
	}else{
		alertInfo(v3x.getMessage("relateLang.select_relation"));
		return false;
	}
}
function funException(){
	alertInfo(v3x.getMessage("relateLang.save_error"));
}
function alertInfo(message){
	try{
		getA8Top().$.alert(message);
	}catch(e){
		alert(message);
	}
}
function alertSuccess(message) {
	try{
		getA8Top().$.infor(message);
	}catch(e) {
		alert(message);
	}
	
}
window.onload = function(){
	if("${type}"!=""){
		document.getElementById('relateType').value = "${type}";
		document.getElementById('relateType').disabled = true;
	}
}
</script>

</head>
<html:link renderURL='/relateMember.do?method=saveRelatePeople'  var="setURL"/>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyESC()">
<form  target="iframeForm" action="${setURL}" method="post" name="relateform" onsubmit="return isSelect()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='common.my.peoplerelate.add' bundle='${v3xMainI18N}' /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<table width="100%" border="0" height="50" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<fmt:message key="relate.memberinfo.type" />:<input type="hidden" id="receiverId" name="receiverId" value="${receiverId}"/>
					</td>
					<td>
						<select name="relateType" id="relateType" style="width:220px">
						<%---1.上级    2.下级   3.秘书   4. 我的同事---%>
							<option value=""></option>	
							<option value="1"><fmt:message key="relate.type.leader"/></option>	
							<option value="3"><fmt:message key="relate.type.junior"/></option>	
							<option value="2"><fmt:message key="relate.type.assistant"/></option>	
							<option value="4"><fmt:message key="relate.type.confrere"/></option>	
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
		<input type="submit" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp; 
		<input type="button" name="b2" id="b2" onclick="closeMe()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>	
<iframe name="iframeForm" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>