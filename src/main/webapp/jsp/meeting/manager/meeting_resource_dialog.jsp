<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<c:set value="全选" var="selectAllLabel" />
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>

<html xmlns="http://www.w3.org/1999/xhtml" class="h100b w100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="mt.resource"/></title>
<script type="text/javascript">
<!--

function _closeWin(){
    var targetWin = transParams.parentWin;
    var popWinName = transParams.popWinName;
    if(popWinName){
        targetWin[popWinName].close();
    }else{
        commonDialogClose('win123');
    }
}

$(function() {
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
		}
	}, 100);
});

function ok(){
	// dosomething()
	window.close();
}

function selectP(){
	var elements=new Array();
	var total=0;

	//$$('input[type="checkbox"][name="id"]').select(function(i){return i.checked}).each(function(i){
	//	var element=new Element();
	//	element.id=i.value;
	//	element.name=replace039(i.getAttribute("resourceName"));
	//	elements[total]=element;
	//	total=total+1;
	//});

	var finputs = document.getElementsByName("id");
	for(var i = 0; i < finputs.length; i++){
		if(finputs[i].checked){
	        var element = new Element();
	        element.id=finputs[i].value;
	        element.name=replace039(finputs[i].getAttribute("resourceName"));
	        elements[total++]=element;
		}
	}
	if(typeof(transParams)!="undefined"){
		transParams.parentWin.selectResourcesCallback(elements);
	}
	_closeWin();
}

function replace039(str){
	return str.replace(/"/g,"'");
}

function init(){
	var oldResourceIds = "${v3x:escapeJavascript(oldResourceIds)}";
	if(oldResourceIds==null || oldResourceIds==""){
		return;
	}
	var ids = oldResourceIds.split(',');
	var selects = document.getElementsByName("id");
	for(var i=0;i<selects.length;i++){
		for(var j=0;j<ids.length;j++){
			if(selects[i].value==ids[j]){
				selects[i].checked="checked";
				break;
			}
		}
	}
}

//-->
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
.dialog_main_body {
	buttom: 35px;
}
.dialog_main_footer {
	height: 30px;
	bottom: 0px;
}
</style>
</head>
<body scroll="no" class="w100b h100b bg_color_gray"  onkeydown="listenerKeyESC()" onload="init();" style="height:270px; overflow: hidden;">

<div id="dialog_main" class="dialog_main bg_color_white " style="height:280px;">

<div class="margin_l_10 margin_t_10 padding_b_10" style="color:#a3a3a3">
	<fmt:message key='mt.resource.yyyp' />
</div>

<div id="dialog_main_body" class="dialog_main_body center bg_color_white margin_lr_5 " style="width:98%; height:240px">
<c:if test="${fn:length(resourceMap)!=0 }">
<div id="scrollListDiv" style="width: 100%;height: 100%;">
  <v3x:table htmlId="listTable" data="resourceMap" var="resource" showPager="false">
    <v3x:column width="10%" type="String" label="${selectAllInput }" className="cursor-hand sort" maxLength="45" symbol="...">
        <input name="id" id="in${resource.id}" type="checkbox" value='${resource.id}' resourceName="${resource.name}"></input>
    </v3x:column>

    <v3x:column width="88%" type="String" label="meeting.name" className="cursor-hand sort" maxLength="45" symbol="...">
        <label for="in${resource.id}">${resource.name}</label>
    </v3x:column>
</v3x:table>
</div>
</c:if>

<c:if test="${fn:length(resourceMap)==0 }">
	<div align="center" class="border_all" style="width:99%;height:195px;">
		<div class="padding_t_30"><br /><br /><font size="4">管理员还未添加与会用品</font></div>
	</div>
</c:if>

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->

<div class="dialog_main_footer bg-advance-bottom padding_t_5 margin_r_10 absolute align_right" style="width:98%;">
	<input type="button" onclick="selectP()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;&nbsp;
	<input type="button" onclick="_closeWin();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">	
</div>

</body>
</html>
