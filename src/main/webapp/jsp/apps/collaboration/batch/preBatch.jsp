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
		var batchList = batch.getCancelData();
		var html = "";
		document.getElementById("total").innerText = "("+batchList.size()+"/"+batch.eleSize()+")";
		for(var i =0;i< batchList.size();i++){
			var data = batchList.get(i);
			var code = data.code;
			html += "&lt;"+data.subject+"&gt;<br/>";
			html += "${ctp:i18n('collaboration.batch.forbidder.reason')}";
			if (code == 13 || code == 9999) {
				html += data.msg;
			}else{
				html += $.i18n("collaboration.batch.alert.notdeal."+data.code);
			}
			html += "<br/>";
		}
		document.getElementById("messageBox").innerHTML = html;
		$('#messageBox').height("315").css('overflow','auto');
	}
	showMessage();
});	
</script>
<title></title>
</head>
<body class="over_hidden">
<table border="0" cellspacing="0" cellpadding="0" class="w100b h100b">
	<tr>
		<td  class="align_left font_size12" height="30px">
		<!-- 以下事项不能进行批处理 -->
        ${ctp:i18n('collaboration.parBacth.noBacth')}<span id="total"></span>
		</td>
	</tr>
	<tr valign="top">
		<td align="center">
    		<div style="width:96%;height:315px;" class="border_t padding_5 font_size12 align_left word_break" id="messageBox" >
    		</div>
		</td>
	</tr>
</table>
</body>
</html>