<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>

<html xmlns="http://www.w3.org/1999/xhtml" class="h100b w100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="mt.resource"/></title>
<script type="text/javascript">

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

function closeWindow() {
	commonDialogClose('win123');
}

$(function() {
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", v3x.getMessage("meetingLang.meeting_choose_all"));
		}
	}, 100);
});

function ok(){
	var elements=new Array();
	var total=0;

	var finputs = document.getElementsByName("id");
	for(var i = 0; i < finputs.length; i++){
		if(finputs[i].checked){
	        var element = new Element();
	        element.id=finputs[i].value;
	        element.name=replace039(finputs[i].getAttribute("resourceName"));
	        elements[total++]=element;
		}
	}
	
	if(parentCallback) {
		parentCallback(elements);
	} else {
		parentWindow.selectResourcesCallback(elements);
	}
	closeWindow();
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
  <v3x:table htmlId="listTable" data="resourceMap" var="resource_" showPager="false">
    <v3x:column width="10%" type="String" label="${selectAllInput }" className="cursor-hand sort" maxLength="45" symbol="...">
        <input name="id" id="in${resource_.id}" type="checkbox" value="${resource_.id}" resourceName="${resource_.name}"></input>
    </v3x:column>

    <v3x:column width="88%" type="String" label="meeting.name" className="cursor-hand sort" maxLength="45" symbol="...">
        <label for="in${resource_.id}">${resource_.name}</label>
    </v3x:column>
</v3x:table>
</div>
</c:if>

<c:if test="${fn:length(resourceMap)==0 }">
	<div align="center" class="border_all" style="width:99%;height:195px;">
		<div class="padding_t_30"><br /><br /><font size="4"></font></div>
	</div>
</c:if>

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->

<div class="dialog_main_footer bg-advance-bottom padding_t_5 padding_b_5 margin_r_10 absolute align_right" style="width:98%;">
	<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;&nbsp;
	<input type="button" onclick="closeWindow();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">	
</div>

</body>
</html>
