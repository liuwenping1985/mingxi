<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
${v3x:skin()}
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>致信服务配置</title>
<style type="text/css">
	* {
		padding: 0px;
		margin: 0px;
	}

	.text {
		font-size: 12px;
	}

	input[type="text"] {
		border: 1px solid #000000;
		font-size: 12px;
		color: gray;
		padding-left: 15px;
	}

	.super {
		color: blue;
	}

	.button_group {
		margin-left: 340px;
		display: none;
	}

</style>
<script type="text/javascript">
	window.fileCallback = function(obj) {
		var proce = $.progressBar({
		    text: "${ctp:i18n('uc.config.rong.js.syn.title9.js')}"
		});
		var fileId = obj.get(0).fileUrl;
		var createDate = obj.get(0).createDate || obj.get(0).createdate;
		var URL = "${path}/uc/rong/config.do?method=convertJsonAndSynUcGroupInfo";
		var datas = {"fileId" : fileId, "createDate" : createDate};
		$.ajax({
		    url: URL,
		    type: "POST",  
		    data: datas,
		    success : function(json){
		    	var jso = eval(json);
		    	if(jso[0].res == "true"){
		    		proce.close();
	        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title2.js')}");
	        	}else{
	        		proce.close();
	        		$.alert("${ctp:i18n('uc.config.rong.js.syn.title3.js')}");
	       	 	}
		    }
		});
	}

	

	$(function() {
		//高级设置
		$("#displayButton").click(function() {
			var isDisplay = $(".button_group").css("display");
			if (isDisplay == "none") {
				$(".button_group").show();
				$("#icon").attr("class", "ico16 arrow_2_t");
			} else {
				$(".button_group").hide();
				$("#icon").attr("class", "ico16 arrow_2_b");
			}
		})
		//------群聊管理------
		$("#displayGroups").click(function() {
			window.location.href = "/seeyon/uc/rong/config.do?method=displayUcGroupInfoList&page=1&size=8";
		})
		var dialog;
	
		//------导入升级数据------
		$("#uploadGroups").click(function() {
			var alertObj = $.alert({
				"msg": "${ctp:i18n('uc.config.rong.js.syn.title7.js')}",
				"type": 1,
				ok_fn: function() {
					dymcCreateFileUpload("uploadBar", "13", "json", "1", true, 'fileCallback', null, true, true, null, true, false, '512000');
  					insertAttachment();
				}
			});
		})

		//------token管理------
		$("#synToken").click(function() {
			window.location.href = "/seeyon/uc/rong/config.do?method=displayUcTokenList&page=1&size=5";
		})
	})
</script>
</head>
<html:link renderURL='/uc/config.do' var="ucconfigurl" />
<html:link renderURL='/uc/rong/config.do' var="ucrongconfigurl" />

<body>
<div class="comp" comp="type:'breadcrumb',code:'F16_UCcenter'"></div>

<form id="submitform" name="submitform" method="post" target="hiddenIframe">

<input id="ucRongAppKeyOld" name="ucRongAppKeyOld" type="hidden" value="${ucRongAppKey}"/>
<TABLE width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="">
	<tr id="table_head" class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        	<td width="45" class="page2-header-img">
		        		
		        	</td>
			        <td class="page2-header-bg">
			        	${ctp:i18n('uc.config.title.ucconfig.js')}
			        </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" valign="top" height="100%">
			<div style="margin-top: 80px;">
				<div class="app">
					<span class="text">App Key：</span>
					<input type="text" name="ucRongAppKey" id="ucRongAppKey" value="${ucRongAppKey}" disabled="true" />
				</div>
				<div class="app app_secret" style="margin-top: 20px;margin-left: -15px;">
					<span class="text">App Secret：</span>
					<input type="text" name="ucRongAppSecret" id="ucRongAppSecret" value="${ucRongAppSecret}" disabled="true"/>
				</div>
				
				<!-- 上传组件位置 -->
				<div style="height: 40px; width: auto; display: none;">
					<div id="uploadBar"></div>
				</div>
				<!-- <input type="button" style="margin-top: 20px;max-width: 160px;" class="common_button" id="displayGroups" value="${ctp:i18n('uc.config.rong.btn.group.js')}"> -->
				
				<div class="other text super" id="displayButton" style="margin-top: 30px;margin-left: -150px;">
					<span style="cursor: pointer;">${ctp:i18n('uc.config.rong.btn.senior.js')}</span>
					<span id="icon" class="ico16 arrow_2_b"></span>
				</div>
				<div class="button_group" style="margin-left: 60px;">	
					<input type="button" class="common_button" style="max-width: 160px;" id="uploadGroups" value="${ctp:i18n('uc.config.rong.btn.upload.js')}">
					<!-- <input type="button" class="common_button" style="margin-left: 20px;max-width: 160px;" id="synToken" value="${ctp:i18n('uc.config.rong.btn.token.js')}"> -->
				</div>
			</div>
		</td>
  	</tr>

</table>
</form>
<iframe name="hiddenIframe" frameborder="0" height="0" width="0"></iframe>
</body>
</html>