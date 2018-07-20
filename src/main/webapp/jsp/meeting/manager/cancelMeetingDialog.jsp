<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head>
<title><fmt:message key="meeting.alert.cancle"></fmt:message></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

function ok(){
	if($("#comment").val() == "<fmt:message key='meeting.common.workflow.label2'></fmt:message>"){
		alert("<fmt:message key='meeting.revocation.noEmpty'></fmt:message>");  //  撤销附言不能为空！
		return ;
	};
	//如果勾选了发送短信按钮则设置隐藏域的值
	var canSendSMSObj=document.getElementById("isCanSendSMS");
	var _parent = null;
	if(typeof(transParams)!="undefined"){
		_parent = transParams.parentWin;
	}else{
		_parent = window.opener;
		if (_parent == null) {
			_parent = window.dialogArguments;
		}
	}
	if(canSendSMSObj&&canSendSMSObj.checked){
		var smsObj=_parent.document.getElementById("canSendSMS");
		if(smsObj){
			smsObj.value="true";
		}
	}
	var theForm = document.forms["commentForm"];
	if(checkForm(theForm)){
		closeWindow(); //需要在调用回调前执行
		_parent.cancelMeetingCallback(theForm.comment.value);
	}
}

function closeWindow(){
	var targetWin = transParams.parentWin;
    var popWinName = transParams.popWinName;
    if((!targetWin.closed && popWinName) || getA8Top().win123){
    	if(popWinName){
               targetWin[popWinName].close();
           }else{
               commonDialogClose('win123');
           }
    }
}
</script>
<script  type="text/javascript">
window.onload = function(){
	checkCommentOut();
}
// 实现通过点击提示附言的消失
function checkComment(){
    var content = $("#comment").val();
    var defaultValue = "<fmt:message key='meeting.common.workflow.label2'></fmt:message>";
    if (content == defaultValue) {
        $("#comment").val("");
        $("#comment").css("color","");
    }
}
function checkCommentOut(){
    var content = $("#comment").val();
    var defaultValue = "<fmt:message key='meeting.common.workflow.label2'></fmt:message>";
    if (content == "") {
        $("#comment").val(defaultValue);
        $("#comment").css("color","#a3a3a3");
    }
}

</script>
</head>
<body style="height:100%;background:#fafafa;" scroll="no" onkeydown="listenerKeyESC()">
<form name="commentForm" style="height:100%;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="font_size12">
				<tr>
					<td height="100%" style="padding:15px 25px 0px 13px;" >
						<textarea name="comment" id="comment"  style="width:100%;height:145px;padding:6px;" inputName="" validate="notNull,maxLength" maxSize="100"
								 onclick="checkComment();" onblur="checkCommentOut();"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<c:if test="${isCanSendSMS}">
							<input type="checkbox" id="isCanSendSMS" name="isCanSendSMS"/> <fmt:message key="meeting.cancel.sendSMS.label"  ></fmt:message>
						</c:if>
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
		<td height="30px" align="right" class="bg-advance-bottom" style="border-bottom:none">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
			<input type="button" onclick="closeWindow()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
		</tr>
	</table>
</form>
</body>
</html>