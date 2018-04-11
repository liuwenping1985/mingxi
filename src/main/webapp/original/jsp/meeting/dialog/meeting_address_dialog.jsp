<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<fmt:message key="mt.meetingAddress.input" var="addressLabel" />
<fmt:message key="mt.meetingAddress.input.plea" var="roomInput" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>${addressLabel }</title>
<script type="text/javascript">

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

window.onload = function() {
	var handWriteInput = document.getElementById("hand_write");
	if(handWriteInput.value == "") {
		handWriteInput.value = handWriteInput.getAttribute("defaultValue");
	}
}

function doIt() {
	var arr = new Array();
	//var patrn=/^[^\|"']*$/;
	var patrn = /^[^\|#￥%&+<>"']*$/;
	var handWrite=document.getElementById("hand_write");
	var handWriteValue= handWrite.value;
	if(handWriteValue==handWrite.getAttribute("defaultValue")) {
		handWriteValue = "";
	}
	if (handWriteValue == "") {
		alert(v3x.getMessage('meetingLang.alert_meetingAddress'));
		handWrite.focus();
		return false;
	}else if(handWriteValue.length > 60){
	    alert(v3x.getMessage("meetingLang.meeting_name_maxlength"));
	    handWrite.focus();
	    return ;
	}else if(!patrn.test(handWriteValue)){
	    alert(v3x.getMessage("meetingLang.meeting_noAllowed_character"));
	    handWrite.focus();
	    return ;
	}
	
	if(parentCallback) {
		parentCallback(handWriteValue);
	} else {
		parentWindow.meetingAddressChangeCallback(handWriteValue);
	}
	closeWindow();
}

function closeWindow() {
	commonDialogClose('win123');
}
</script>
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
</head>

<body scroll=no class="w100b h100b bg_color_gray">

<div id="dialog_main" class=" bg_color_white" style="height:130px">
	<div id="dialog_main_body" class="dialog_main_body center bg_color_white over_auto" style="height:120px;">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="popupTitleRight">
			<tr>
				<td class="padding010">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="new-column" nowrap="nowrap" style="padding:10px 2px;">
								<c:set value="${addressLabel }" var="_myLabel"></c:set>
					            <c:set value="&lt;${roomInput}&gt;" var="_myLabelDefault"></c:set>
					            
								<input type="text" class="input-300px" name="hand_write" id="hand_write"
					                value="<c:out value="${v3x:toHTML(meetingPlace)}" default="${_myLabelDefault}" escapeXml="false" />" 
					                title="${v3x:toHTML(meetingPlace)}"
					                defaultValue="${_myLabelDefault}"
					                onfocus="checkDefSubject(this, true)"
					                onblur="checkDefSubject(this, false)"
					                inputName="${addressLabel }"
					                validate="isDefaultValue,notSpecChar"
					                ${param.clearValue}
					            />
							</td>	
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>

<div class="dialog_main_footer left w100b" style="background:#4d4d4d;color:#fff;height:50px;">
	<div class="right padding_t_10 padding_r_10 align_right">
		<input id="doItButton" type="button" onclick="doIt()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="common_button common_button_emphasize margin_r_10">&nbsp;&nbsp;
		<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="common_button common_button_gray margin_r_10" onclick="closeWindow();">
	</div>		
</div>
</body>
</html>