<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/meeting/include/meeting_taglib.jsp" %>
<%@ include file="/WEB-INF/jsp/meeting/include/meeting_header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
.dialog_main_body {
	buttom: 30px;
}
.dialog_main_footer {
	height: 30px;
	bottom: 0px;
}
</style>

<script>

window.transParams = window.transParams || window.parent.transParams || {};//弹出框参数传递

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

function closeWindow(){
	commonDialogClose('win123');
}

function initData() {
	if(parentWindow) {
		document.getElementById("prompt").innerHTML = parentWindow.document.getElementById("resourceMsg").innerHTML;	
		document.getElementById("roomAppId").value = parentWindow.document.getElementById("roomAppId").value;
	}
}

function doIt() {
	var description = document.getElementById("description").value;
	if(description.length>80){
		alert(v3x.getMessage("meeting_params_use_exceed", description.length));
		return;
	}
	roomAppForm.submit();
}

function addRoomDesc() {
	if(document.getElementById("descTr").style.display == 'none') {
		document.getElementById("descTr").style.display = '';
		document.getElementById("useIcon").className = 'arrow_1_b';
	}
}

function showRoomDesc() {
	if(document.getElementById("descTr").style.display=='') {
		document.getElementById("descTr").style.display = 'none';
		document.getElementById("useIcon").className = 'arrow_1_b';
	} else {
		document.getElementById("descTr").style.display = '';
		document.getElementById("useIcon").className = 'arrow_1_t';
	}
}

function addMeetingByRoom() {	
	var portalRoomAppId = document.getElementById("roomAppId").value;
	if(parentCallback) {
		parentCallback("create");
	} else {
		if(parentWindow) {
			var url = "${path}/meetingNavigation.do?method=entryManager&entry=meetingArrange&listType=create&portalRoomAppId="+portalRoomAppId;
			parentWindow.parent.location.href = url;
		}
	}
	closeWindow();
}

function _submitCallback(errorMsg) {
	if(errorMsg != "") {
		alert(errorMsg);
	}/*  else {
		alert("操作成功");
	} */
	if(parentCallback) {
		parentCallback("addDesc");
	}
	closeWindow();
}
</script>
<title><fmt:message key='mr.tab.app' /></title>
</head>
<body scroll="no" class="w100b h100b bg_color_gray" onload="initData()" >

<div id="dialog_main" class="dialog_main bg_color_white margin_lr_5" style="height:220px">

<div id="dialog_main_body" class="dialog_main_body center bg_color_white over_auto w100b h100b">

<form id="roomAppForm" name="roomAppForm" method="post" action="meetingroom.do?method=addRoomAppDesc" target="formTarget">
	<input id="roomAppId" name="roomAppId" type="hidden" />
	<table width="100%" height="100%"  border="0" cellspacing="5" cellpadding="0" align="center" style="font-size:12px" class="w100b h100b bg_color_white">
		<tr height="30">
			<td style="width:30px;">
				<span class="msgbox_img_0 margin_l_10"></span>
			</td>
			
			<td valign="top" class="padding_t_10">
				<span id="prompt"></span>
			</td>
		</tr>		
		<tr height="30">
			<td valign="top" class="padding_l_30" colspan="2">
				<fmt:message key='mr.add.allowed' /><a class="color_blue" href="javascript:addRoomDesc()"><fmt:message key='mr.add.description' /></a>
                <c:if test="${hasMeetingArrangeMenu}">
                	<fmt:message key='mr.add.or' /><a class="color_blue" href="javascript:addMeetingByRoom()"><fmt:message key='mr.add.meeting' /></a>
                </c:if>
			</td>
		</tr>
		
		<tr height="140">
			<td valign="top" colspan="2" class="padding_l_10">
				<div>
					<fmt:message key='mr.add.description' /><span id="useIcon" onClick="javascript:showRoomDesc()" class="arrow_1_b"></span> <br />
				</div>
				<div id="descTr" style="display:none;">
					<textarea id="description" name="description" validate="maxLength" maxSize="80" maxLength="80" style="width:360px;height:120px;"></textarea>
				</div>
			</td>
		</tr>
		
	</table>
</form>

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->

<div class="dialog_main_footer bg_color_gray w100b padding_b_5 padding_t_5 absolute align_right" style="width:100%;">
	<input id="doItButton" type="button" onclick="doIt()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
	<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_r_10" onclick="closeWindow()">		
</div>


<iframe name="formTarget" style="display:none;width:0%;heigh:0%" ></iframe>
</body>
</html>