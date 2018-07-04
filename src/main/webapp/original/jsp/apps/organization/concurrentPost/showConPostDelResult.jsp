<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	$(document).ready(function(){
		function showMessage(){
			var batch = window.dialogArguments;
			if(!batch){
				returnVal = false;
				return false;
			}
			//不能批处理的项
			var batchList = batch.delConPostList;
			var html = "";
			for(var i =0;i< batchList.length;i++){
				var data = batchList[i];
				var failMsg = "人员&lt" + data.userName + "&gt从&lt" + data.sourceUnitName + "&gt兼职到&lt" + data.targetUnitName + "&gt";
				html += "<p style='display:inline-block;height:24px;line-heigth:24px;color:#333;'>" + failMsg + "</p>";
				html += "</p>";
			}
			document.getElementById("total").innerText = batch.allCount;
			document.getElementById("okBacthCount").innerText = (batch.allCount - batch.failCount);
			document.getElementById("onBacthCount").innerText = batch.failCount; 
			
			document.getElementById("messageBox").innerHTML = html;
			$('#messageBox').height("275").css({'overflow':'auto',"width":"550px","padding":"0px 20px","background":"rgb(250,250,250)"});
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
	        <p class="border_b" style="display:inline-block;height:24px;line-heigth:24px;color:#333;width:550px;margin:0px 20px;background:rgb(250,250,250)">
	        	${ctp:i18n('collaboration.parBacth.selectAll')}<span id="total"></span>
	        	${ctp:i18n('collaboration.parBacth.one')}
	        	<!-- 删除成功 -->
	        	${ctp:i18n('org.conpost.manage.del.ok')}
	        	<span style="color:green;" id="okBacthCount"></span>
	        	<!-- 项  -->
	        	${ctp:i18n('org.conpost.manage.del.item')}
	        	${ctp:i18n('collaboration.parBacth.one')}
	        	<!--以下 -->
	        	${ctp:i18n('org.conpost.manage.del.yixia')}
	        	<span style="color:red;" id="onBacthCount"></span>
	        	<!-- 项删除失败， -->
	        	${ctp:i18n('org.conpost.manage.del.item')}
	        	${ctp:i18n('org.conpost.manage.del.delfail')}
	        	<span style="color:red;">${ctp:i18n('org.conpost.manage.del.failurereason')}</span><!-- 原因是其兼职单位不在您的管辖范围内 -->
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