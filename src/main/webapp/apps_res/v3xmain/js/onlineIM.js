var face_texts = new Array("[wx]", "[se]", "[dy]", "[ll]", "[hx]", "[shui]", "[dk]", "[gg]", "[fn]", "[tp]", 
						   "[cy]", "[jy]", "[kuk]", "[lengh]", "[zk]", "[tuu]", "[tx]", "[ka]", "[jie]", "[kun]", 
						   "[jk]", "[lh]", "[hanx]", "[fendou]", "[zhm]", "[yiw]", "[xu]", "[yun]", "[zhem]", "[qiao]", 
						   "[zj]", "[ch]", "[kb]", "[gz]", "[qd]", "[huaix]", "[lq]", "[pp]", "[zq]", "[mg]", 
						   "[dg]", "[lw]", "[yb]", "[qiang]", "[ws]", "[shl]", "[bq]", "[gy]", "[qt]", "[hd]");

var face_texts_replace = new Array(/\[wx\]/g, /\[se\]/g, /\[dy\]/g, /\[ll\]/g, /\[hx\]/g, /\[shui\]/g, /\[dk\]/g, /\[gg\]/g, /\[fn\]/g, /\[tp\]/g, 
								   /\[cy\]/g, /\[jy\]/g, /\[kuk\]/g, /\[lengh\]/g, /\[zk\]/g, /\[tuu\]/g, /\[tx\]/g, /\[ka\]/g, /\[jie\]/g, /\[kun\]/g, 
								   /\[jk\]/g, /\[lh\]/g, /\[hanx\]/g, /\[fendou\]/g, /\[zhm\]/g, /\[yiw\]/g, /\[xu\]/g, /\[yun\]/g, /\[zhem\]/g, /\[qiao\]/g, 
								   /\[zj\]/g, /\[ch\]/g, /\[kb\]/g, /\[gz\]/g, /\[qd\]/g, /\[huaix\]/g, /\[lq\]/g, /\[pp\]/g, /\[zq\]/g, /\[mg\]/g, 
								   /\[dg\]/g, /\[lw\]/g, /\[yb\]/g, /\[qiang\]/g, /\[ws\]/g, /\[shl\]/g, /\[bq\]/g, /\[gy\]/g, /\[qt\]/g, /\[hd\]/g);

/**
 * 判断讨论组是否可用
 */
function isDeleted(teamId){
	/*var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageController", "isDeleted", false);
	requestCaller.addParameter(1, "Long", teamId);
	return requestCaller.serviceRequest();*/
	//性能问题, 暂时先不判断组是否存在
	return "false";
}

/**
 * 聊天时页面调整
 */
var isResize = false;
function resizeIM(){
	if(!isResize){
		var topBodyWidth = parseInt(getA8Top().document.body.clientWidth);
		var eastWidth = 495;
		if(topBodyWidth < 610){
			getA8Top().window.resizeTo(1105, 640);
		}else{
			eastWidth = parseInt(document.body.clientWidth)- 610;
		}
		$('body').layout('panel','east').panel('open');
		$('body').layout('panel','east').panel('resize',{
			width:eastWidth
		});
		$('body').layout().resize();
		isResize = true;
	}
}

/**
 * 聊天页签,如果不存在则添加,如果已存在则获取焦点
 */
function showIMTab(type, tID, tName, isFromMessage,offline){
	resizeIM();
	var dID;
	if(type == '1'){
		dID = currentUserId + '_' + tID;
	}else{
		dID = tID;
	}
	//此处截取长度不可乱改，影响消息接收
	var title = tName.getLimitLength(24, "..").escapeHTML();
	if($('#imTabs').tabs('exists', title)){
		$('#imTabs').tabs('select', title);
    }else{
    	var src = "/seeyon/message.do?method=showMessage&type=" + type + "&dID=" + dID + "&fID=" + currentUserId + "&id=" + tID + "&isFromMessage=" + isFromMessage;
    	var content = '<iframe id="' + dID + '_Iframe" name="' + dID + '_Iframe" src="' + src + '" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>';
    	$('#imTabs').tabs('add', {
			title: title,
			spanTitle: tName.escapeHTML(),
			content: content,
			closable: true
		});
    	if(offline=="true"){
    		var currentPanel = $('#imTabs').tabs('getTab', title);
    		var currentTab = currentPanel.panel('options').tab;
			currentTab.addClass("tabs-selected-off");
    	}
    }
}

/**
 * 关闭聊天页签
 */
function closeIMTab(title){
	if($('#imTabs').tabs('exists', title)){
		$('#imTabs').tabs('close', title);
    }
}

/**
 * Ctrl + Enter发送消息
 */
function onEnterPressSendMessage(ev, type, dID, tID){
	ev = ev || window.event;
	 if(ev.keyCode == 13 && ev.ctrlKey){
		 sendIMMessage(type, dID, tID);
	}
}

//记录上一条发送消息时间,用来限制消息发送速度
var lastMessageSendTime;
//允许的消息发送间隔,单位毫秒(2秒)
var allowedMessageSendInterval = 2000;
//允许的消息内容长度(140个字符)
var allowedMessageContentLength = 140;
//如果一段时间没有发送消息,则需要断开长连接(3分钟)
var notSendToCutTime = 3 * 60 * 1000;
var intervalId;

/**
 * 开始监听
 */
function startMonitor(){
	intervalId = setInterval("calNoSendTime()", 1000);
}

/**
 * 计算多久没有发送消息,如果超过3分钟,则需要断开长连接
 */
function calNoSendTime(){
	if(new Date().getTime() - lastMessageSendTime > notSendToCutTime){
		doStopToken();
		window.clearInterval(intervalId);
		longConnection = false;
		//$("#imStateImg").removeClass("im-online-img").addClass("im-leave-img");
		//$("#imStateTitle").removeClass("im-online-title").addClass("im-leave-title");
		//$("#imStateTitle").text(_("MainLang.im_leave"));
	}
}

/**
 * 发送消息
 */
function sendIMMessage(type, dID, tID, attachment, attachmentUrl,from){
	
	//限制消息发送速度
	var thisMessageSendTime = new Date().getTime();
	if(!from && lastMessageSendTime && thisMessageSendTime - lastMessageSendTime < allowedMessageSendInterval){
		alert(_("MainLang.message_send_fast"));
		return;
	}
	
	lastMessageSendTime = thisMessageSendTime;
	
	var referenceId = "";
	var tIDs = "";
	if(type == "1"){
		referenceId = "-1";
		tIDs = tID;
	}else{
		referenceId = tID;
		if(type == "5" || type == "3"){
			//判断讨论组是否可用
			if(isDeleted(referenceId) == "true"){
				alert(_("MainLang.message_team_already_delete"));
				var pan = $('#imTabs').tabs('getSelected');
				var tab = pan.panel('options').tab;
				closeIMTab(pan.panel('options').title);
				return;
			}
		}
		var memberIds = $("#" + dID + "_Iframe").contents().find("input");
		for(var i = 0; i < memberIds.length; i ++){
			if(memberIds[i].id == "memberId"){
				tIDs += memberIds[i].value + ",";
			}
		}
		tIDs = tIDs.substring(0, tIDs.length - 1)
	}
	
	var thisContentText;
	var thisContentText1;
	
	if(!from){
		//限制消息内容长度
		
		var thisContentTextArea = $("#" + dID + "_Iframe").contents().find("#editContent");
		var messageContent = thisContentTextArea.val();
		messageContent = messageContent.trim();
		
		if((messageContent == "" || messageContent.length == 0)){
			return;
		}else if(messageContent.length > allowedMessageContentLength){
			alert(_("MainLang.message_content_length_too_long", allowedMessageContentLength));
			return;
		}
		
		
		var style = "font-size:" + thisContentTextArea.css("font-size") + 
		";font-weight:" + thisContentTextArea.css("font-weight") + 
		";font-style:" + thisContentTextArea.css("font-style") + 
		";text-decoration:" + thisContentTextArea.css("text-decoration") + ";";
		
		thisContentText = messageContent;
		
		thisContentText = thisContentText.escapeHTML();
		for(var i = 0; i < face_texts_replace.length; i ++){
			thisContentText = thisContentText.replace(face_texts_replace[i],"<img src='/seeyon/common/RTE/editor/images/smiley/msn/" + (i + 1) + ".gif' width='24' height='24'/>");
		}
		
		thisContentText1 = thisContentText = "<font style='" + style + "'>" + thisContentText + "</font>";

		$("#" + dID + "_Iframe").contents().find("#editContent").val("");
		
	}else if(from == "file"){
		
		thisContentText = _("MainLang.message_send_file") + attachment + attachmentUrl + _("MainLang.message_file_download") + "</a>";
		thisContentText1 = _("MainLang.message_send_file_success") + attachment;
		
	}else if(from == "vomeeting"){
		
		if(attachment=='S'){
			thisContentText = "<span class='meeting' id = 'vomeeting'>"+currentUserName + "&nbsp;&nbsp;"+_("MainLang.message_vomeeting_start")+"</span> <input type=\"hidden\" id=\"confKey\" value=\""+attachmentUrl+"\"/><input type=\"hidden\" id=\"meetingcreatername\" value=\""+currentUserName+"\"/>  <script> try{if(vomak==''){$('#vomeeting').append('<span id=\"agreemeeting\" class=\"stopmeeting\">"+_("MainLang.message_vomeeting_agree")+"</span>&nbsp;&nbsp;<span id=\"formeeting\" class=\"stopmeeting\">"+_("MainLang.message_vomeeting_refuse")+"</span>');$('#vomeeting').removeAttr('id');if($('#resavemeeting').val()!=''){stopmeeting();}$('#resavemeeting').val('true');;if(!parent.longConnection){parent.doStart();parent.startMonitor();}addmeeting();}}catch(e){}</script>";
			thisContentText1 = _("MainLang.message_vomeeting_waiting")+"<span id='stopmeeting' class='stopmeeting'>"+_("MainLang.message_vomeeting_stop")+"</span>";
		}else if(attachment=='C'){
			thisContentText = "<span class='meeting'>"+_("MainLang.message_vomeeting_stopedto")+"</span><script>try{if(vomak==''){stopmeeting('');}}catch(e){}</script>";
			thisContentText1 = _("MainLang.message_vomeeting_stopedfrom");
		}else if(attachment=='A'){
			
			var meetingcreaterName = $("#" + dID + "_Iframe").contents().find("#meetingcreatername");
			
			thisContentText = "<span class='meeting'>"+currentUserName + "&nbsp;&nbsp;"+_("MainLang.message_vomeeting_agreeto")+"</span><script>try{if(vomak==''){sstopmeeting('A');}}catch(e){}</script>";
			thisContentText1 = _("MainLang.message_vomeeting_agreefrom1")+meetingcreaterName.val()+_("MainLang.message_vomeeting_agreefrom2");
			
			var confKey = $("#" + dID + "_Iframe").contents().find("#confKey");
			window.open("/seeyon/message.do?method=joinmeeting&confKey="+confKey.val());
			confKey.removeAttr("id");
			meetingcreaterName.removeAttr("id");
			
		}else if(attachment=='F'){
			thisContentText = "<span class='meeting'>"+currentUserName + "&nbsp;&nbsp;</span>"+_("MainLang.message_vomeeting_refuseto")+"<script>try{if(vomak==''){sstopmeeting('F');}}catch(e){}</script>";
			thisContentText1 = _("MainLang.message_vomeeting_refusefrom");
		}
	}
	
	var currentDate = new Date(new Date().getTime() + server2LocalTime);
	var showDate = currentDate.format("HH:mm:ss");
	var saveDate = currentDate.format("yyyy-MM-dd HH:mm:ss");
	var thisContent = "<div style='padding: 5px 10px;'><span style='color: #335186;'>" + currentUserName + "</span>&nbsp;&nbsp;<font class='col-reply-date'>" + showDate + "</font></div><div style='padding: 5px 30px; word-wrap:break-word;word-break:break-all;'>" + thisContentText1 + "</div>";

	$("#" + dID + "_Iframe").contents().find("#sendContent").append(thisContent);
	
	if(from == "vomeeting"&&attachment=='S'){
		var stopmeeting = $("#" + dID + "_Iframe").contents().find("#stopmeeting");
		stopmeeting.unbind("click");
		stopmeeting.click(function(){
			changeobjattr(stopmeeting);
			var confKey = $("#" + dID + "_Iframe").contents().find("#cconfKey");
			$("#" + dID + "_Iframe").contents().find("#lanchmeeting").val("");
			$("#" + dID + "_Iframe").contents().find("#iscreater").val("");
			getA8Top().deletemeeting(confKey.val());
			confKey.val("");
			getA8Top().sendIMMessage(type, dID, tID, 'C', attachmentUrl,from);
		});
	}
	
	//使滚动条拉到最底部
	try{
		$("#" + dID + "_Iframe").contents().find("#sendContent")[0].scrollTop = $("#" + dID + "_Iframe").contents().find("#sendContent")[0].scrollHeight - $("#" + dID + "_Iframe").contents().find("#sendContent").height();
	}catch(e){
		
	}
	
	//如果长连接已断开,则需要建立长连接
	if(!longConnection){
		doStart();
		startMonitor();
		//$("#imStateImg").removeClass("im-leave-img").addClass("im-online-img");
		//$("#imStateTitle").removeClass("im-leave-title").addClass("im-online-title");
		//$("#imStateTitle").text(_("MainLang.im_online"));
	}
	
	$.ajax({
		async: false,
		type: "POST",
		url: "/seeyon/getAJAXMessageLongPollingServlet",
		data: {"callType": "sendMessage", "messageType": type, "referenceId": referenceId, "receiverIds": tIDs, "content": thisContentText, "creationDate": saveDate, "showDate": showDate}
	});
}