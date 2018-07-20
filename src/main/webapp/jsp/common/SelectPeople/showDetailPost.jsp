<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css" />" />
<title>${ctp:i18n("selectPeople.page.title")}</title>
<script type="text/javascript">
<!--
var parentWindow = window.dialogArguments._window;
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
		var html0 = parentWindow.getMembersHTML("Post", id, keyword, true);
		$("#h").html(html0);
		$("#t").html("${ctp:i18n('org.post.label')}: " + postDataBodyObj.options[postDataBodyObj.selectedIndex].text);
	}
}

function searchItems(){
	loadData($("#q").val());
}

function listenermemberDataBody(){
	
}

function selectOneMember(){

}

function OK(){
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
	
	return tempNowSelected;
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
<body class="page_color h100b" scroll="no" style="overflow: hidden;height:100%;" onload="loadData()">
 <table class="" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" width="50%" class="font_bold padding_10">
			<div id="t"></div>
        </td>
        <td width="50%" class="padding_10">
			<div style="float: right;">
				<span id="searchArea" style="line-height:18px;height:22px;background:#fff;">
					<input style="border:none;height:18px;" onkeypress="if(event.keyCode == 13) searchItems()" 
					id="q" class="" type="text" value="" maxlength="10" />
					<img style="vertical-align:middle;" src="common/SelectPeople/images/search_button_rest.gif" border="0" align="absmiddle" class="cursor-hand" onclick="searchItems()" />
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td class="border_b padding_10" colspan="2" align="center" id="h" style="height:260px;"></td>
	</tr>
</table>
</body>
</body>
</html>