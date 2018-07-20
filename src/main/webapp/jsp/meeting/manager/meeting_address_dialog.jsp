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
	if(typeof(transParams)!="undefined"){
		transParams.parentWin.meetingAddressChangeCallback(handWriteValue);
	}
	commonDialogClose('win123');
}

window.onload = function() {
	//initIe10AutoScroll('dialog_main', 50);
	//initIe10AutoScroll('dialog_main_body', 95);
}
function cancleMeetAddress() {
	if(typeof(transParams)!="undefined"){
		 transParams.parentWin.document.getElementById("meetingPlace").value="";
	} 
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

<div id="dialog_main" class=" bg_color_white" style="height:180px">

<%-- <div class="margin_l_10 margin_t_10 padding_b_10">
	<fmt:message key='mt.meetingAddress.input.plea' />:
</div> --%>

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

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->

<div class="dialog_main_footer bg-advance-bottom padding_t_5 margin_r_10 absolute align_right" style="width:97%">
	<input id="doItButton" type="button" onclick="doIt()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
	<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="cancleMeetAddress();">		
</div>

</body>
</html>