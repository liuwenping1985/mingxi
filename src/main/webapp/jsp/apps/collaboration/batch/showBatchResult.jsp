<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var returnVal=true;
function OK(){
	return returnVal;
}
$(document).ready(function(){
	function showMessage(){
		var batch = window.dialogArguments;
		if(!batch){
			returnVal = false;
			return false;
		}
		var batchList = batch.doBatchResult;
		var html = "";
		for(var i =0;i< batchList.length;i++){
			var data = batchList[i];
			var el = batch.getBatchData(data.affairId,data.summaryId);
			el.code =  data.resultCode;
			el.parameter =  data.message;
			html += "&lt;"+el.subject+"&gt;<br/>";
			html += "${ctp:i18n('collaboration.batch.showBacth.elCode" + el.code + "')}";
			html+="<br/>";
		}
		document.getElementById("messageBox").innerHTML = html;
	}
	showMessage();
});	
</script>
<title></title>
</head>
<body scroll="no" style="overflow: hidden">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td  class="font_bold" align="left" height="30px">
           <!-- 以下事项批处理未成功 -->
		  ${ctp:i18n('collaboration.batch.showBacth.elCode20')}
		</td>
	</tr>
	<tr valign="top">
		<td align="center">
		<div style="border: solid 1px #666666;width:98%;height:100%">
		<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr height="100%">
			<td class="bg-advance-middel" height="100%">
			<div id="messageBox"  class="font_size12 align_left"></div>
			</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
</table>
</body>
</html>