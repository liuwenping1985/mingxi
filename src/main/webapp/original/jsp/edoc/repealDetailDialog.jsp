<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title><fmt:message key='col.repeal.comment' /></title>
<script type="text/javascript">
function OK(){
	//var ton = $("#trackWorkflow").attr("checked") ? "1":"0";
	var trackType = "0";
	try{trackType = parent.document.getElementById("trackWorkflow").checked ? "1":"0" ;}catch(e){}
	window.returnValue = [trackType];
	return window.returnValue;
}


window.onload = function(){
		if("${template}"){
			if("${template}" == 1){
				//$("#trackWorkflow").attr("checked",true).disable();
				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
			}else if("${template}" == 2){
				//$("#trackWorkflow").disable();
				try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
			}
		}
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="commentForm">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:12px;">
				<tr>
					<br/><span><span class='msgbox_img_4' style="display:inline-block;margin-bottom:-4px;"></span>&nbsp;${ctp:i18n('collaboration.workflow.trace.confirmrepeal')}</span><br/><br/>
				</tr>
				<tr valign="top">
				</tr>
		</table>
		</td>
		</tr>
	</table>
</form>
</body>
</html>