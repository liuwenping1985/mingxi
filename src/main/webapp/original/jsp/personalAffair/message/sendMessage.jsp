<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="message.sendDialog.title"/></title>
<script type="text/javascript">
<!--
	//服务器时间和本地时间的差异
	var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();

	//通讯录等选中人员发消息
	function checkGetData(getData){
		if(getData == "fromParent"){
			var parentWin = transParams.parentWin;
			var ids = parentWin.receiveIds;
			var names = parentWin.receiveNames;
			if(ids){
				$("#receiverIds").val(ids);
				$("#sendTo").val(names);
				$("#selectRecHref").hide();
			}
		}
	}

	function showReceiver(elements){
		if(!elements){
			return;
		}
		$("#receiverIds").val(getIdsString(elements, false));	
		$("#sendTo").val(getNamesString(elements).getLimitLength(20,'...'));
		$("#sendTo").attr("title", getNamesString(elements));
	}

	var thisContentText = "";
	var sendMembers = new ArrayList();
	function submitForm(){
		if($("#sendTo").val() == ""){
			alert(_("MainLang.onlineMsg_send_alert_noReceiver"));
			selectPeopleFun_addReceiver();
			return;
		}
		
		thisContentText = $("#content").val();
		thisContentText = thisContentText.trim();
		if(thisContentText == "" || thisContentText.length == 0){
			//if(!isUploadAttachment()){
				return;
			//}
		}else if(thisContentText.length > 1000){
			// 快速需求响应：通讯录发送消息字数放宽至1000字
			alert(_("MainLang.message_content_length_too_long", 1000));
			return;
		}

		$("#b1").attr("disabled", true);
		$("#b2").attr("disabled", true);

		var obj = transParams.parentWin.getA8Top().v3x.getParentWindow();
		var memberIds = new ArrayList();
		var tIDs = $("#receiverIds").val();
		var ids = tIDs.split(",");
		for (var i = 0; i < ids.length; i++) {
		
				sendMembers.add(ids[i]+'@localhost');
			
		}
	    handleJids();
	}

	function handleJids() {
		var obj = transParams.parentWin.getA8Top().v3x.getParentWindow();
		for (var i = 0; i < sendMembers.size(); i++) {
			var aMessage = obj.getA8Top().newJSJaCMessage();
			aMessage.setType('chat');
			aMessage.setFrom(obj.getA8Top().jid);
			aMessage.setTo(sendMembers.get(i));
			aMessage.setBody(thisContentText);
			aMessage.setName(obj.getA8Top().curUserName);
			aMessage.appendNode(aMessage.buildNode('toname', ''));
			obj.getA8Top().con.send(aMessage);
		}
	    getA8Top().sendMessageWin.close();
	}

	function doKeyPressedEvent(sendForm){
		 var event = v3x.getEvent();
		 if(event.ctrlKey && event.keyCode == 13){
			 submitForm();
		 }else if(event.keyCode == 27){
			 getA8Top().sendMessageWin.close();
		 }
	}

	$(document).ready(function(){
		$('#content').focus();
		checkGetData('${param.getData}');
	});
//-->
</script>
</head>
<v3x:selectPeople id="addReceiver" panels="Department,Team,Outworker" showMe="false" selectType="Member" departmentId="${currentUser.departmentId}" jsFunction="showReceiver(elements)"/>
<body scroll="no" style="overflow: hidden;" onkeydown="doKeyPressedEvent()" style="background:#fafafa;">
<form name="sendForm" id="sendForm" method="post" action="">
<input type="hidden" id="receiverIds" name="receiverIds" value="${receiverIds}"/>
<table class="popupTitleRight" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" style="background: #fafafa;">
	<tr>
		<td class="PopupTitle" style="line-height:20px;height:20px;margin-left:20px;color:#999;">
			<font color="#000"><fmt:message key="message.sendTo.label"/></font>
			<input type="text" id="sendTo" name="sendTo" class="textfield" style="width:50%;border-style:none;background: #fafafa;" readonly title="${v3x:toHTML(v3x:showOrgEntitiesOfIds(receiverIds, 'Member', pageContext))}" value="${v3x:toHTML(v3x:showOrgEntitiesOfIds(receiverIds, 'Member', pageContext))}">
			<c:if test="${receiverNum == 0}">
				<a id="selectRecHref" href="#" onclick="selectPeopleFun_addReceiver()"><fmt:message key="message.addReceiver.label"/></a>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" valign="top" style="padding:0px 20px;">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<textarea name="content" id="content" cols="" rows="" style="width:100%;height:160px;"></textarea>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<c:if test="${v3x:getBrowserFlagByRequest('OnDbClick', pageContext.request)}">
		<tr>
			<td height="35" align="right" class="bg-advance-bottom">
			    <input type="button" id="b1" name="b1" class="button-default_emphasize" style="margin-right:-7px;" value="<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}'/>" onclick="submitForm()"/>&nbsp;&nbsp;
			    <input type="button" id="b2" name="b2" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="getA8Top().sendMessageWin.close();"/>
			</td>
		</tr>
	</c:if>
</table>
</form>
</body>
</html>