<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../INC/noCache.jsp" %>
<head>
<%@ include file="../header.jsp" %>
<title><fmt:message key="selectPeople.page.title" /></title>
<script type="text/javascript">
<!--
function showOriginalDate(originalData){
	if(originalData){
		var elements = originalData[0];
		var _flowtype = originalData[1];
		
		var flowtypes = document.getElementsByName("flowtype");
		for(var i = 0; i < flowtypes.length; i++){
			if(flowtypes[i].value == _flowtype){
				flowtypes[i].checked = true;
				break;
			}
		}
		
		addElementsToList3(elements);
	}
}

function getIsCheckSelectedData(){
	return document.getElementById("sequence").checked == false;
}

function selected(){
	var data = null;
	
	try{
		data = getSelectedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	
	//正常返回数据，如果没有人，则data是一个length为0的数组，即data = []
		
	var flowtypes = document.getElementsByName("flowtype");
	for(var i = 0; i < flowtypes.length; i++){
		if(flowtypes[i].checked){
			flowtypes = flowtypes[i].value;
			break;
		}
	}
	
	var rValue = new Array();
	
	rValue[0] = data;
	rValue[1] = flowtypes;
	rValue[2] = showAccountShortname;
	
	window.returnValue = rValue;
		
	window.close();
}
function OK(){
	var data = null;
	
	try{
		data = getSelectedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	
	//正常返回数据，如果没有人，则data是一个length为0的数组，即data = []
		
	var flowtypes = document.getElementsByName("flowtype");
	for(var i = 0; i < flowtypes.length; i++){
		if(flowtypes[i].checked){
			flowtypes = flowtypes[i].value;
			break;
		}
	}
	
	var rValue = new Array();
	
	rValue[0] = data;
	rValue[1] = flowtypes;
	rValue[2] = showAccountShortname;
	
	return rValue;
}
//-->
</script>

<%@ include file="AbstractSelectPeople.jsp" %>
<tr>
<td height="25" class="bg-button-select">
<table width="100%" border="0" height="100%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center">
		<td width="70%">
			<div id="flowTypeDiv">
				<table>
					<td id="concurrentType">
						<label for="concurrent">
							<input id="concurrent" name="flowtype" type="radio" value="1"><fmt:message key="selectPeople.flowtype.concurrent.lable"/>
						</label>
					</td>
					<td id="sequenceType" >
						<label for="sequence">
							<input id="sequence" name="flowtype" type="radio" value="0" checked><fmt:message key="selectPeople.flowtype.sequence.lable"/>
						</label>
					</td>
					<c:if test="${v3x:getBrowserFlagByUser('SelectPeople', v3x:currentUser())==true}">
					<td id="multipleType">
						<label for="multiple">
							<input id="multiple" name="flowtype" type="radio" value="2"><fmt:message key="selectPeople.flowtype.multiple.lable"/>
						</label>
					</td>
					<td id="colAssignType">
						<label for="colAssign">
							<input id="colAssign" name="flowtype" type="radio" value="3"><fmt:message key="selectPeople.flowtype.colAssign.lable"/>
						</label>
					</td>
					</c:if>
				</table>
			</div>
		</td>
		<c:if test="${v3x:getBrowserFlagByUser('SelectPeople', v3x:currentUser())==true}">
		<td width="30%" align="right"  style="height:33px;*height:45px;">
			<input name="Submit" type="button" onclick="selected()" class="button-default-2"
				value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>
			<input name="close" type="button" onclick="window.close()" class="button-default-2"
				value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
		</td>
		</c:if>
	</tr>
</table>
</td>
</tr>
</table>
<script type="text/javascript">
<!--

var invalidationMultipleRadio = eval("parentWindow.invalidationMultipleRadio_" + spId);
if(invalidationMultipleRadio == true){
	document.getElementById("multipleType").disabled = true;
}

var hiddenMultipleRadio = eval("parentWindow.hiddenMultipleRadio_" + spId);
if(hiddenMultipleRadio == true){
	document.getElementById("multipleType").style.display = "none";
}

var invalidationColAssignRadio = eval("parentWindow.invalidationColAssignRadio_" + spId);
if(invalidationColAssignRadio == true){
	document.getElementById("colAssignType").disabled = true;
}

var hiddenColAssignRadio = eval("parentWindow.hiddenColAssignRadio_" + spId);
if(hiddenColAssignRadio == true){
	document.getElementById("colAssignType").style.display = "none";
}

var _flowtype = eval("parentWindow.flowtype_" + spId);
if(_flowtype){
	var flowtypeObj = document.getElementById(_flowtype);
	if(flowtypeObj){
		flowtypeObj.checked = true;
	}
}

var hiddenFlowTypeRadio = eval("parentWindow.hiddenFlowTypeRadio_" + spId);
if(hiddenFlowTypeRadio == true){
	document.getElementById("flowTypeDiv").style.display = "none";
}

//-->
</script>
</head>
<body>
</body>
</html>

