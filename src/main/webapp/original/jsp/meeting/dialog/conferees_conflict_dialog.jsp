<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<title>
<fmt:message key="meeting.collide.remind"/>
</title>
</head>
<script type="text/javascript">
var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

function ok() {
    document.getElementById("okButton").disabled = true;
  	if(parentCallback) {
  		parentCallback();
  	} else {
  		parentWindow.submitForm();	
  	}
  	closeWindow(); 	
}

function init() {
	document.getElementById("conferees").value = parentWindow.document.getElementById("conferees").value;
	var myform = document.getElementsByName("submitDataForm")[0];
    myform.submit();
}

function closeWindow() {
    commonDialogClose('win123');
}
function cancle() {
    if (typeof(parentWindow.setApplicationButtons) != "undefined" &&typeof(parentWindow.sendCount) != "undefined") {
        parentWindow.setApplicationButtons(false);
        parentWindow.sendCount = 0;
    }
    closeWindow();
}

</script>

<body onload="init();" scroll="no" style="padding:0;margin:0;">

<form method="post" id="submitDataForm" name="submitDataForm" target="myiframe" action="meeting.do">
	<input type="hidden" id="method" name="method" value="listConfereesConflict" />
    <input type="hidden" id="meetingId" name="meetingId" value="${v3x:toHTML(param.meetingId)}" />
	<input type="hidden" id="beginDatetime" name="beginDatetime" value="${param.beginDatetime}" />
	<input type="hidden" id="endDatetime" name="endDatetime" value="${param.endDatetime}" />
	<input type="hidden" id="emceeId" name="emceeId" value="${param.emceeId}" />
	<input type="hidden" id="recorderId" name="recorderId" value="${param.recorderId}" />
	<input type="hidden" id="conferees" name="conferees" />
</form>
		
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td class="bg-advance-middel" sytle="padding:0;">
		<iframe src="about:blank" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
	</td>
</tr>
<tr>
	<td height="42" align="right" class="bg-advance-bottom">
		<input id="okButton" type="button" onclick="ok();" onfocus="this.blur();" style="line-height:16px;outline:none;" value="<fmt:message key="meeting.collied.continue"/>" class="button-default_emphasize">
		<input type="button" onclick="cancle();" style="line-height:16px" value="<fmt:message key="modifyBody.cancel.label"/>" class="button-default-2">&nbsp;&nbsp;&nbsp;&nbsp;
	</td>
</tr>
</table>
	
</body>
</html>
