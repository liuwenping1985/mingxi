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
	    $.alert("${ctp:i18n('collaboration.cancel.workflow.tip.length')}" + length);
	    return false;
	}

	
	var trackType = "0";
	try{trackType = parent.document.getElementById("trackWorkflow").checked ? "1":"0" ;}catch(e){}
	return [comment,trackType];//jquery attr返回的对象是object
}
window.onload = function(){
	<%--if("${template}"){--%>
		<%--if("${template}" == 1){--%>
			<%--try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}--%>
		<%--}else if("${template}" == 2){--%>
			<%--try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}--%>
		<%--}--%>
	<%--}else if("${affairApp}" == "4"){ //判断是新公文的话回退时默认选中“追溯流程”--%>
		<%--try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}--%>
	<%--}--%>
	var template = '${template}';
	var affairApp= '${affairApp}';
	if( template!=''&&template.indexOf(',')==-1&&template==1){//单个公文之模板流程
		try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
	}else if(template!=''&&template.indexOf(',')==-1&&template==2){
		try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
	}else if(affairApp!=''){//是公文的无论单个还是多个都默认勾选上
		try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}
	}
	<%--if( template!=''&&affairApp==''&&template.indexOf(',')==-1){//单个公文之模板流程
		if(template == 1){
			try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
		}else if(template == 2){
			try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
		}
	}else if(template==''&&affairApp!=''&&affairApp.indexOf(',')==-1){//单个公文之自由流程
		if(affairApp=='4'){//判断是新公文的话回退时默认选中“追溯流程”
			try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}
		}
	}else{//多个公文
		try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
	}--%>

//	if(template!=''){//模板流程
//		// 单个
//		if(template.length==1){
//			if(template == 1){
//				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
//			}else if(template == 2){
//				try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
//			}
//		}else{// 多个
//			var split = template.split(',');
//			var track1=0;
//			var track2=0;
//			for (var obj in split) {
//				if (obj=='1') {
//					track1++;
//				}
//				if (obj=='2') {
//					track2++;
//				}
//			}
//			if (track1==split.length) {//都是追溯
//				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
//			}else if(track2==split.length){//都是不追溯
//				try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
//			}
//		}
//	}else{//自由流程
//		if (affairApp.length==1) {//单个
//			if(affairApp=='4'){//判断是新公文的话回退时默认选中“追溯流程”
//				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}
//			}
//		}else{//多个
//			var split = affairApp.split(',');
//			var isNewEdoc = true;
//			for (var obj in split) {
//				if ((obj!='4')) {
//					isNewEdoc = false;
//					break;
//				}
//			}
//			if (isNewEdoc) {
//				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}
//			}
//		}
//	}
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