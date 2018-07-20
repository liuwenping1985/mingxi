<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
<title><fmt:message key="selectPeople.page.title" /></title>
<script type="text/javascript">
<!--
var parentWindow = v3x.getParentWindow();
var postDataBodyObj = parentWindow.document.getElementById("PostDataBody");

function init(){
	loadData();
}
function loadData(keyword){
	if(keyword){
		keyword = keyword.toLowerCase();
	}
	if(postDataBodyObj != null){
		var id = postDataBodyObj.value;
		var html = parentWindow.getMembersHTML("Post", id, keyword, true);
		document.getElementById("h").innerHTML = html;
		document.getElementById("t").innerText = "<fmt:message key='org.post.label'/>: " + postDataBodyObj.options[postDataBodyObj.selectedIndex].text;
	}
}

function searchItems(){
	var q = document.getElementById("q");
	loadData(q.value);
}

function listenermemberDataBody(){
	
}

function selectOneMember(){

}

function ok(){
	var tempNowSelected = new Array();
	var objTD = document.getElementById("memberDataBody");
	var ops = objTD.options;
	var count = 0;
	for(var i = 0; i < ops.length; i++) {
		var option = ops[i];
		if(option.selected){
			var e = getElementFromOption(option);
			if(e){
				tempNowSelected[tempNowSelected.length] = (e);
				count++;
			}
		}
	}
	
	window.returnValue = tempNowSelected;
	window.close();
}

function getElementFromOption(option){
	if(!option){
		return null;
	}
	
	var _accountId = option.getAttribute("accountId");
	var typeStr = option.getAttribute("type");
	var idStr  = option.value;
	
	var types = typeStr.split(parentWindow.valuesJoinSep);
	var ids   = idStr.split(parentWindow.valuesJoinSep);
	var elementName = [];
	
	for(var i = 0; i < types.length; i++) {
		var entity = parentWindow.topWindow.getObject(types[i], ids[i]);
		
		elementName[elementName.length] = entity.name;
	}
	
	//Element(type, id, name, typeName, accountId, accountShortname, description)
	return [typeStr, idStr, elementName.join(parentWindow.arrayJoinSep), "", _accountId, "", ""];
}
//-->
</script>
</head>
<body>
<body scroll="no" style="overflow: hidden;height:100%;" onload="loadData()" onkeydown="listenerKeyESC()">
 <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">
			<div id="t" class="div-float "></div>
			<div class="div-float-right" style="padding: 6px 20px 0px 0px ">
				<span id="searchArea" style="line-height:18px;height:22px;background:#fff;">
					<input style="border:none;height:18px;" onkeypress="if(event.keyCode == 13) searchItems()" 
					id="q" class="" type="text" value="" maxlength="10" />
					<img style="vertical-align:middle;" src="common/SelectPeople/images/search_button_rest.gif" border="0" align="absmiddle" class="cursor-hand" onclick="searchItems()" />
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" align="center" id="h" style="height:260px;"></td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2"> 
		</td>
	</tr>
</table>
</body>
</body>
</html>