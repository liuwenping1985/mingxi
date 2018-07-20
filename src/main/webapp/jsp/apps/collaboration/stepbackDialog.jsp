<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<title></title>
<script type="text/javascript">
function OK(){
	//var ton = $("#trackWorkflow").attr("checked") ? "1":"0";
	var trackType = "0";
	try{trackType = parent.document.getElementById("trackWorkflow").checked ? "1":"0" ;}catch(e){}
	window.returnValue = [trackType];
	return window.returnValue;
}


window.onload = function(){
		var template = '${template}';
		var affairApp= '${affairApp}';
			if(template!=''&& template == 1){
				//$("#trackWorkflow").attr("checked",true).disable();
				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true).disable();}catch(e){}
			}else if(template!=''&& template ==  2){
				//$("#trackWorkflow").disable();
				try{$(parent.document.getElementById("trackWorkflow")).disable();}catch(e){}
			}else if(affairApp!=''&& affairApp ==  4){ //判断是新公文的话回退时默认选中“追溯流程”
				try{$(parent.document.getElementById("trackWorkflow")).attr("checked",true);}catch(e){}
			}
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<div class="margin_l_10">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
	<tr>
		<td height="20" class="PopupTitle"></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr>
					<br/><span><span class='msgbox_img_4' style="display:inline-block;margin-bottom:-4px;"></span>&nbsp;${ctp:i18n('collaboration.confirmStepBackItem')}</span><br/><br/>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	</tr>
</table>
</div>
</body>
</html>