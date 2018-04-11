<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    request.setAttribute("editor.enabled","true");
%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
	<div>
		<div class="content margin_5" style="width: 787px;">
			<textarea id="fck1" class="comp" comp="type:'editor',contentType:'html',toolbarSet:'Simple'">${ctp:toHTMLWithoutSpace(notice.paramValue)}</textarea>
		</div>
		<div class="footer">
			<div class="left margin_l_5">
				<%-- <label for="sendMessage">
					<input id="sendMessage" type="checkbox"><span class="font_size12 margin_l_5">${ctp:i18n("guestbook.leaveword.sent.message")}</span>
				</label> --%>
			</div>
			<div class="right">
				<a class="common_button common_button_emphasize margin_r_5" onclick="OK()">${ctp:i18n("guestbook.leaveword.send")}</a>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var transParams = window.dialogArguments;
	var parentWin = transParams.parentWin;
	var spaceType = transParams.spaceType;
	var spaceId = transParams.spaceId;
	var fragmentId = transParams.fragmentId;
	var ordinal = transParams.ordinal;
	var boardId = transParams.boardId;
	var sectionId = transParams.sectionId;
	
	$().ready(function() {
		$('#fck1').bind('editorReady', function(){
			var editor = CKEDITOR.instances['fck1'];
	        if (!editor) return;
	        var space = editor.ui.space('contents');
	        if (!space) return;
	        space.setStyle("height", "270px");
		});
	});
	
	function OK() {
		sendNotice();
	}
	
	function sendNotice(){
		try{
			var sendMessage = 'true';
			var oSendMessage = document.getElementById('sendMessage');
			if(oSendMessage && !oSendMessage.checked){
				sendMessage = 'false';
			}
			
			var content = $("#fck1").getEditorContent();
			if(content == ''){
				alert("${ctp:i18n('notice.content.notnull')}");
				return;
			}
			
	    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxNoticeManager", "saveNotice", false);
	    	requestCaller.addParameter(1, "String", sendMessage);
	    	requestCaller.addParameter(2, "String", content);
	    	requestCaller.addParameter(3, "String", spaceType);
	    	requestCaller.addParameter(4, "String", spaceId);
	    	requestCaller.addParameter(5, "String", fragmentId);
	    	requestCaller.addParameter(6, "String", ordinal);
	    	requestCaller.addParameter(7, "String", boardId);
	    	var resultStr = requestCaller.serviceRequest();
	    	if(resultStr == 'true'){
	    		if(sectionId){
	    			parentWin.sectionHandler.reload(sectionId, true);
	    		}else{
	    			parentWin.sectionHandler.reload("noticeSection", true);
	    		}
	    		window.parentDialogObj['noticeDialog'].close();
	    	}
	    }catch(e){
	    	
	    }
	}
</script>
</html>