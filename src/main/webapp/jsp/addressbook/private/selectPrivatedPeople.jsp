<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
%>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<html>
<head>
<%@ include file="../header.jsp" %>
<title><fmt:message key="addressbook.popup.member.label"  bundle='${v3xAddressBookI18N}' /></title>

<script type="text/javascript">
<!--
function showOriginalDate(originalData){
	addElementsToList3(originalData);
}

function getIsCheckSelectedData(){
	return true;
}

function selected(){
	var data = null;
	
	try{
		data = getSelectedPrivatedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	window.returnValue = data;
	
	window.close();
}
//-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var basePath = "${pageContext.request.contextPath}";

function getSelectedPrivatedPeoples() {
	var someNodeList = $('List3').getElementsByTagName('option');
	var nodes = $A(someNodeList);
	var data = '';
	nodes.each(function(node){
		data = data + node.text + '|'+ node.value + ',';
	});

	return data;
}

function moveOption(pOrg,pDes){
  var ops = $(pOrg).options;
  var ops_ = $(pDes).options;
  var op;
  for(var i=ops.length - 1;i>=0;i--){
  //for(var i = 0;i<ops.length;i++){
   op = ops[i];
   if(op.selected)
    try{
     ops_.add(op);//For Firefox
    }catch(e){//For IE!
     ops_.add(new Option(op.text,op.value));
     ops.remove(i);
    }
  }
 }
 
function upDown(sel, direction){
	var list3Object = $(sel);
	var list3Items = list3Object.options;
	var nowIndex = list3Object.selectedIndex;

	if(direction == "up"){
		if(nowIndex > 0){
			var nowOption = list3Items.item(nowIndex);
			var nextOption = list3Items.item(nowIndex - 1);
			
			var newOption = new Option(nowOption.text, nowOption.value);
			newOption.className = nowOption.className;
			newOption.selected = true;
			
			list3Object.add(newOption, nowIndex - 1);
			list3Object.remove(nowIndex + 1);
		}
	}
	else if(direction == "down"){
		if(nowIndex > -1 && nowIndex < list3Items.length){
			var nowOption = list3Items.item(nowIndex);
			var nextOption = list3Items.item(nowIndex + 1);
			
			var newOption = new Option(nowOption.text, nowOption.value);
			newOption.className = nowOption.className;
			newOption.selected = true;
			
			list3Object.add(newOption, nowIndex + 2);
			list3Object.remove(nowIndex);
		}
	}
	else{
		alert('The direction ' + direction + ' is not defined.');
	}
}
//-->
</script>

</head>
<body onkeypress="listenerKeyESC()" scroll="no">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="10" class="bg-imges1"></td>
		<td align="center" class="bg-imges3">
		<table width="560" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="2"></td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="2"><img src="<c:url value="/common/SelectPeople/images/xrjm1.gif"/>" width="2" height="367"></td>
						<td align="center" class="bg-xrjmbj">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="40" align="right">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
										</td>
										<td valign="middle" class="td-left-5">&nbsp;</td>
										<td>
										</td>
										<td class="td-left-5">&nbsp;</td>
										<td align="right" class="td-left-5">&nbsp;</td>
									</tr>
								</table>
								</td>
								<td>&nbsp;</td>
								<td><img src="<c:url value="/common/SelectPeople/images/yxe.gif"/>" width="36" height="12"></td>
								<td width="35">&nbsp;</td>
							</tr>
							<tr>
								<td width="240" valign="top" class="iframe1-">
										<select id="memberDataBody"
											ondblclick="Selectbox.moveSelectedOptions(memberDataBody,List3,false,'')"
											multiple="multiple" style="width:240px;" size="21">
											<c:forEach items="${members}" var="member">
												<option value="${member.id }">${member.name }</option>
											</c:forEach>
										</select>
								</td>
								<td width="35" align="center">
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
									alt='<fmt:message key="selectPeople.alt.select"/>' width="15"
									height="12" class="cursor-hand" onClick="Selectbox.moveSelectedOptions(memberDataBody,List3,false,'')"></p>
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
									alt='<fmt:message key="selectPeople.alt.unselect"/>' width="15"
									height="12" class="cursor-hand" onClick="Selectbox.moveSelectedOptions(List3,memberDataBody,false,'')"></p>
								</td>
								<td width="240" valign="top" class="iframe1-">
									<select id="List3" onclick="" ondblclick="Selectbox.moveSelectedOptions(List3,memberDataBody,false,'')" 
										multiple="multiple" style="width:240px" size="21">
									</select>
								</td>
								<td width="35" align="center">
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
									alt='<fmt:message key="selectPeople.alt.up"/>'width="12"
									height="15" class="cursor-hand" onClick="Selectbox.moveOptionUp(List3)"></p>
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
									alt='<fmt:message key="selectPeople.alt.down"/>' width="12"
									height="15" class="cursor-hand" onClick="Selectbox.moveOptionDown(List3)"></p>
								</td>
							</tr>
						</table>
						</td>
						<td width="2" align="right" class="bg-xrjm2"></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="10" class="bg-imges2"></td>
	</tr>
	<tr>
		<td colspan="3" height="83" class="bg-bottom" align="center">
			<input name="Submit" type="button" onClick="selected()" class="button-default-2"
				value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>
			<input name="close" type="button" onclick="window.close()" class="button-default-2"
				value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
		</td>
	</tr>
</table>
</body>
</html>

