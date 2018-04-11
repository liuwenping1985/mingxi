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
			//不能批处理的项
			var batchList = batch.getCancelData();
			var html = "";
			
			for(var i =0;i< batchList.size();i++){
				var data = batchList.get(i);
				html += "<p style='display:inline-block;height:24px;line-heigth:24px;color:#333;'>&lt;"+data.subject+"&gt;</p><br/>";
				html += "<p style='color:red;display:inline-block;height:24px;line-heigth:24px;'>${ctp:i18n('collaboration.batch.forbidder.reason')}";
				if (data.msg) {
					html += data.msg;
				}else if(data.message){
					html += data.message;
				}
				html += "</p><br/>";
			}
			//处理失败的项
			var batchResultList = batch.doBatchResult;
			for(var i =0;i< batchResultList.size();i++){
				var data = batchResultList.get(i);
				var el = batch.getBatchData(data.affairId,data.summaryId);
				html += "<p style='display:inline-block;height:24px;line-heigth:24px;color:#333;'>&lt;"+el.subject+"&gt;</p><br/>";
				html += "<p style='color:red;display:inline-block;height:24px;line-heigth:24px;'>${ctp:i18n('collaboration.batch.forbidder.reason')}";
				if(data.message){
					html += data.message;
				}
				html += "</p><br/>";
			}
			var noBatctSize = batchList.size()+batchResultList.size();
			var totalCount = batch.eleSize();
			var okBacthCount = totalCount - noBatctSize;
			document.getElementById("total").innerText = batch.eleSize();
			document.getElementById("okBacthCount").innerText = okBacthCount;
			document.getElementById("onBacthCount").innerText = noBatctSize;
			
			document.getElementById("messageBox").innerHTML = html;
			$('#messageBox').height("275").css({'overflow':'auto',"width":"410px","padding":"0px 20px","background":"rgb(250,250,250)"});
		}
		showMessage();
	});	
</script>
<title></title>
</head>
<body class="over_hidden">
<table border="0" cellspacing="0" cellpadding="0" class="w100b h100b">
	<tr>   																																
		<td  class="align_left font_size12" height="30px" style="background:rgb(250,250,250)">
			<!-- 选择x个，批处理 x 个，以下 x 个不能批处理 -->
	        <p class="border_b" style="display:inline-block;height:24px;line-heigth:24px;color:#333;width:410px;margin:0px 20px;background:rgb(250,250,250)">
	        	${ctp:i18n('collaboration.parBacth.selectAll')}<span id="total"></span>
	        	${ctp:i18n('collaboration.parBacth.one')}
	        	${ctp:i18n('collaboration.parBacth.batchProcessing')}
	        	<span style="color:green;" id="okBacthCount"></span>
	        	${ctp:i18n('collaboration.parBacth.one')}
	        	${ctp:i18n('collaboration.parBacth.following')}
	        	<span style="color:red;" id="onBacthCount"></span>
	        	${ctp:i18n('collaboration.parBacth.noBacth')}
	        	
	        </p>
		</td>
	</tr>
	<tr valign="top">
		<td align="center" style="background:rgb(250,250,250);">
    		<div class="padding_5 font_size12 align_left word_break" id="messageBox">
    		</div>
		</td>
	</tr>
</table>
</body>
</html>