<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="edocHeader.jsp" %>
<title><fmt:message key='col.repeal.comment' /></title>
<script type="text/javascript">
function ok(){
	var theForm = document.forms["commentForm"];
	if(checkForm(theForm)){
		var returnValues = [theForm.comment.value,document.getElementById("trackWorkflow").checked ? "1" :"0"];
		if(returnValues[0] == "<fmt:message key='edoc.revocation.comment' />"){
			alert("<fmt:message key='edoc.revocation.noEmpty' />"); // 撤销附言不能为空
			return ;
		}
		transParams.parentWin.repealItemsCallback(returnValues);
		commonDialogClose('win123');
	}
}
function OK(){
	var theForm = document.forms["commentForm"];
	if(checkForm(theForm)){
		return  theForm.comment.value;
	}
}
window.onload=function(){
	var obj = document.getElementById("trackWorkflow");
	if("${template}"){
		if("${template}" == 1){
			obj.checked = true;
			obj.disabled= true;
		}else if("${template}" == 2){
			obj.disabled= true;
		}
	}
	checkCommentOut();
}

//实现通过点击提示附言的消失
function checkComment(){
    var content = $("#comment").val();
    var defaultValue = "<fmt:message key='edoc.revocation.comment' />";
    if (content == defaultValue) {
        $("#comment").val("");
        $("#comment").css("color","");
    }
}
function checkCommentOut(){
    var content = $("#comment").val();
    var defaultValue = "<fmt:message key='edoc.revocation.comment' />";
    if (content == "") {
        $("#comment").val(defaultValue);
        $("#comment").css("color","#a3a3a3");
    }
}
//关闭页面并释放锁
function dialogClose(){
	transParams.parentWin.repealItemsCallback();//释放流程锁
	commonDialogClose('win123');//关闭页面
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="commentForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="100%"  style="padding:30px 6px 0px 6px;">
						<textarea name="comment" id="comment" cols="" rows="7" style="width:100%;padding:6px;" inputName="<fmt:message key='col.repeal.comment' />" validate="notNull,maxLength" maxSize="100"
							onclick="checkComment();" onblur="checkCommentOut();"></textarea>
						<span>
                        	<!--label for="trackWorkflow" class="margin_t_5 hand"><input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">${ctp:i18n('collaboration.workflow.trace.traceworkflow')}</label>
    						<span class="color_blue hand" style="color:#318ed9;" title="${ctp:i18n('collaboration.workflow.trace.summaryDetail2')}">[${ctp:i18n('collaboration.workflow.trace.title')}]</span-->
						</span>
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
		<td height="30px" align="right" class="bg-advance-bottom">
			<span style="float:left">
			  <label for="trackWorkflow" class="margin_t_5 hand" style="color:white;"><input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">${ctp:i18n('collaboration.workflow.trace.traceworkflow')}</label>
			  <span class="color_blue hand" style="color:#318ed9;" title="${ctp:i18n('collaboration.workflow.trace.summaryDetail2')}">[${ctp:i18n('collaboration.workflow.trace.title')}]</span>
			</span>	
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
			<input type="button" onclick="dialogClose()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
		</tr>
	</table>
</form>
</body>
</html>