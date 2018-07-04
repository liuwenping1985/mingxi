<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function OK(){
	var retVal;
	var nodeattitude=getA8Top().$("#nodeattitude").val();
	if(nodeattitude == 3){
		retVal=nodeattitude;
	}else{
		retVal=$("input[name='attitude']:checked").val();
	}
	return retVal;
}

$(document).ready(function() {
	var nodeattitude = getA8Top().$("#nodeattitude").val();
	var superNodestatus = getA8Top().$("#superNodestatus").val();
	if (nodeattitude == 3) {
		$("#theAttitudeTR").css("display","none");
	}
	if (nodeattitude == 2) {
		$("#haveRead").css("display","none");
	}
	if (superNodestatus == 2) {
		$("#disagree").css("display","none");
	}
});

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
<div class="padding_l_10" style="height: 180px; background: #fafafa;">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
	<tr>
		<td height="20" class="PopupTitle"></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" valign="top" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr>
					<br/><span><span class='msgbox_img_4' style="display:inline-block;margin-bottom:-4px;"></span>&nbsp;${ctp:i18n('collaboration.confirmStepBackToItem')}</span><br/><br/>
				</tr>

				<tr id="theAttitudeTR">
					<td>
					<span style="padding-left: 24px;">
						<span style="font-size: 12px;padding-left: 10px">
							${ctp:i18n('permission.nodeAttitude')}：
						</span>&nbsp;
						
						<label id="haveRead" class="margin_r_10 hand" for="afterRead"> <input
							id="afterRead" class="radio_com" name="attitude"
							value="collaboration.dealAttitude.haveRead" type="radio"
							>${ctp:i18n('collaboration.dealAttitude.haveRead')}
							<!-- 已阅 -->
						</label>

						<label id="isagree" class="margin_r_10 hand" for="agree"> <input id="agree"
							class="radio_com" name="attitude"
							value="collaboration.dealAttitude.agree" type="radio"
							>${ctp:i18n('collaboration.dealAttitude.agree')}
							<!-- 同意 -->
						</label>

						<label id="disagree" class="margin_r_10 hand" for="notagree"> <input
							id="notagree" class="radio_com" name="attitude"
							value="collaboration.dealAttitude.disagree" type="radio" checked="checked"
							/>${ctp:i18n('collaboration.dealAttitude.disagree')}
							<!-- 不同意 -->
						</label>
	    			</span>
	    			</td>
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