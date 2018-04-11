<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>撤销附言</title>


<script type="text/javascript">
function OK(){
	var comment = $.trim($('#comment').val());
	if(comment === "" || comment === "${ctp:i18n('collaboration.common.workflow.label2')}"){
	    $.alert("${ctp:i18n('collaboration.cancel.workflow.tip')}");
	    return false;
	}
	var length = comment.length;
	if(length > 100){
	    $.alert($.i18n('collaboration.cancel.workflow.tip.length', length));
	    return false;
	}

	
	var trackType = "0";
	try{trackType = parent.document.getElementById("trackWorkflow").checked ? "1":"0" ;}catch(e){}
	return [comment,trackType];//jquery attr返回的对象是object
}
window.onload = function(){
	if("${template}"){
		if("${template}" == 1){
			try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
		}else if("${template}" == 2){
			try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
		}
	}
	checkCommentOut();
}
//实现通过点击提示附言的消失
function checkComment(){
    var content = $("#comment").val();
    var defaultValue = "${ctp:i18n('collaboration.common.workflow.label2')}";
    if (content == defaultValue) {
        $("#comment").val("");
        $("#comment").css("color","");
    }
}
function checkCommentOut(){
    var content = $("#comment").val();
    var defaultValue = "${ctp:i18n('collaboration.common.workflow.label2')}";
    if (content == "") {
        $("#comment").val(defaultValue);
        $("#comment").css("color","#a3a3a3");
    }
}
</script>
</head>
<body scroll="no" onkeydown="" class="page_color h100b over_hidden" style="padding:0 26px;">
<form name="commentForm" id="commentForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="font_size12">
				<tr>
					<td height="100%" style="padding:25px 20px 0px 4px;">
                        <!-- 撤销附言 -->
						<textarea name="comment" id="comment" style="width:100%;height:170px;padding:6px;" inputName="${ctp:i18n('collaboration.common.workflow.revokePostscript')}" class="validate" 
							validate="type:'string',name:'${ctp:i18n('collaboration.common.workflow.revokePostscript')}',notNull:true,minLength:0,maxLength:100" 
							onclick="checkComment();" onblur="checkCommentOut();"></textarea>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>