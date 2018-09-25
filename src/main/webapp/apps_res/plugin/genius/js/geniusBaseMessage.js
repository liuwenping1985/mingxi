/**************************************** 消息通用(A8/精灵/IM) ****************************************/

/**
 * 消息定义
 */
function CLASS_MESSAGE(id, title, referenceId, userHistoryMessageId, content, messageType, senderId, senderName, receiverId, receiverName, creationDateTime, messageLink, linkOpenType, atts, importantLevel){
    this.id = id;
    this.title = title;
    this.referenceId = referenceId;
    this.userHistoryMessageId = userHistoryMessageId;
    this.content = content;
    this.messageType = messageType;
    this.senderId = senderId;
    this.senderName = senderName;
    this.receiverId = receiverId;
    this.receiverName = receiverName;
    this.creationDateTime = creationDateTime;
    this.messageLink = messageLink;
    this.linkOpenType = linkOpenType;
    this.atts = atts;
    this.importantLevel = importantLevel;
}

/**
 * 显示消息
 */
function showMessage(messagePer, messageSysList, allMsgCountStr, fromType){
	var handleWin = getHandleWin(fromType);
	//系统消息
	if(messageSysList != null && messageSysList.length > 0){
		var allLength = messageSysList.length;
		var _projectleaveProperties = new Properties();
		var _deptleaveProperties = new Properties();
		var _spaceleaveProperties = new Properties();
		var _calleaveProperties = new Properties();
		var _sysList  = new Array();
		//message.link.department.leaveWord
		//message.link.project.leaveWord 
		//message.link.cal.reply
		for(var i = 0;i<messageSysList.length;i++){
			var _msg = messageSysList[i];
			var _link = _msg.messageLink;
			if(_link!=null && _link!=''){
				var strs = _link.split("|");
				if(strs[0]=='message.link.department.leaveWord'){
		        	if(_deptleaveProperties.containsKey(strs[1])){
		        		_deptleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_deptleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.space.leaveWord'){
					if(_spaceleaveProperties.containsKey(strs[1])){
		        		_spaceleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_spaceleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.project.leaveWord'){
					if(_projectleaveProperties.containsKey(strs[1])){
						_projectleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_projectleaveProperties.put(strs[1], _list);
		        	}
				}else if(strs[0]=='message.link.cal.reply'){
					if(_calleaveProperties.containsKey(strs[1])){
						_calleaveProperties.get(strs[1]).add(_msg);
		        	}else{
		        		var _list = new ArrayList();
		        		_list.add(_msg);
		        		_calleaveProperties.put(strs[1], _list);
		        	}
				}else{
					_sysList[_sysList.length]=_msg;
				}
			}else{
				_sysList[_sysList.length]=_msg;
			}

		}
		//alert(_deptleaveProperties.size()+'--'+_projectleaveProperties.size()+'--'+_calleaveProperties.size()+'--'+_sysList.length)
		if((_sysList != null && _sysList.length > 0) || _projectleaveProperties.size()>0 || _deptleaveProperties.size()>0 || _spaceleaveProperties.size()>0 || _calleaveProperties.size()>0){
			if(handleWin.isSysMessageWindowEyeable){
				var sysMessageDIVObj = handleWin.$("#sysMsgContentDiv");
				var countSpanObj = handleWin.$("#sysMsgCountSpan");
				if(sysMessageDIVObj.length > 0){
					var countMessages1 = handleWin.document.getElementsByName('countMessages');
					var countSysMessages1 = handleWin.document.getElementsByName('countSysMessages');
					var _length1 = countMessages1.length + countSysMessages1.length;
					
					var systemMsgContent = sysMessageListToHTML(_sysList, true, fromType,1);
					var _projectContent = leaveWordMessageListToHTML(_projectleaveProperties, true, fromType,1);
					var _deptContent = leaveWordMessageListToHTML(_deptleaveProperties, true, fromType,2);
					var _spaceContent = leaveWordMessageListToHTML(_spaceleaveProperties, true, fromType,4);
					var _calContent = leaveWordMessageListToHTML(_calleaveProperties, true, fromType,3);
//					sysMessageDIVObj.html(systemMsgContent+_projectContent+_deptContent+_spaceContent+_calContent+sysMessageDIVObj.html());
					sysMessageDIVObj.prepend(systemMsgContent+_projectContent+_deptContent+_spaceContent+_calContent);
					try{
						var countMessages = handleWin.document.getElementsByName('countMessages');
						var countSysMessages = handleWin.document.getElementsByName('countSysMessages');
						var _length = countMessages.length + countSysMessages.length;
						var originalCount = parseInt(countSpanObj.text(), 10);
						var allCount = allLength+originalCount;
						countSpanObj.text(allCount);
						//var originalNewCount = _projectleaveProperties.size()+_deptleaveProperties.size()+_calleaveProperties.size()+_sysList.length + originalCount;
						if(_length1 < 5){
							sysMessageDIVObj.height(getHeight(_length));
						}
						DivSetVisible(true, fromType);
					}catch(e){
						
					}
				}
			}else{
				var msgObj = showSysMessage(_sysList, allLength, fromType,_projectleaveProperties,_deptleaveProperties,_spaceleaveProperties,_calleaveProperties);
				ShowMessageWindow(msgObj, fromType);
				handleWin.isSysMessageWindowEyeable = true;
			}
			handleWin.playMessageRadio();
			if(fromType == "a8"){
				getCtpTop().startActionTitle();
			}
		}
	}
	
	//在线消息－按发送顺序读出
	if(messagePer){
		var key = messagePer.jid.substring(0, messagePer.jid.indexOf('@'));
	  	if(msgProperties.containsKey(key)){
			msgProperties.get(key).add(messagePer);
	  	}else{
			var thisArrayList = new ArrayList();
			thisArrayList.add(messagePer);
			msgProperties.put(key, thisArrayList);
	  	}
	  	
	  	if(msgProperties.size() > 0){
			if(handleWin.isPerMessageWindowEyeable){
				var perMessageDIVObj = handleWin.$("#personMsgContentDiv");
				if(perMessageDIVObj.length > 0){
					var personMsgContent = perMessageListToHTML(true, fromType);
//					perMessageDIVObj.html(personMsgContent + perMessageDIVObj.html());
					perMessageDIVObj.prepend(personMsgContent);
					try{
						var height = getPerMessageHeight();
						perMessageDIVObj.height(height);
						DivSetVisible(true, fromType);
					}catch(e){}
				}
			}else{
				var msgObj = showPerMessage(fromType, false);
				ShowMessageWindow(msgObj, fromType);
				handleWin.isPerMessageWindowEyeable = true;
			}
			
			handleWin.playMessageRadio();
			if(fromType == "a8"){
				getCtpTop().startActionTitle();
			}
	  	}
	}
}

/**
 * 消息显示
 */
function ShowMessageWindow(ClassMessageObj, fromType){
	var handleWin = getHandleWin(fromType);
	switch(ClassMessageObj.messageType){
		case 1:
				handleWin.$("#SysMsgContainerTR").show();
				handleWin.$("#SysMsgContainer").html(ClassMessageObj.content);
				break;
		case 3:
				handleWin.$("#PerMsgContainerTR").show();
				handleWin.$("#PerMsgContainer").html(ClassMessageObj.content);
				break;
	}
 	DivSetVisible(true, fromType);
}

/**
 * 显示系统消息
 */
function showSysMessage(msgList, allMsgCountStr, fromType,_projectleaveProperties,_deptleaveProperties,_spaceleaveProperties,_calleaveProperties){
	if((msgList == null || msgList.length < 1) && (_projectleaveProperties == null || _projectleaveProperties.size < 1) && (_deptleaveProperties == null || _deptleaveProperties.size < 1) && (_spaceleaveProperties == null || _spaceleaveProperties.size < 1) && (_calleaveProperties == null || _calleaveProperties.size() < 1)){
		return;
	}
	var _pdc = _projectleaveProperties.size()+_deptleaveProperties.size()+_spaceleaveProperties.size()+_calleaveProperties.size();
	var count = msgList.length+_pdc;
	var height = getHeight(count);
	var systemMsgContent = sysMessageListToHTML(msgList, false, fromType,_pdc);
	var _projectContent = leaveWordMessageListToHTML(_projectleaveProperties, false, fromType,1);
	var _deptleaveContent = leaveWordMessageListToHTML(_deptleaveProperties, false, fromType,2);
	var _spaceleaveContent = leaveWordMessageListToHTML(_spaceleaveProperties, false, fromType,4);
	var _calleaveContent = leaveWordMessageListToHTML(_calleaveProperties, false, fromType,3);
	
	var strBuffer = new StringBuffer();
	strBuffer.append("<table width='280' id='sysTable' border='0' class='msgborder' cellspacing='0' cellpadding='0'>");
	strBuffer.append("<tr>");
	strBuffer.append("<td height='100%' class='msgContentSys'>");
	strBuffer.append("<div class='msgContentDivHeader'>");
  	strBuffer.append(message_header_system_label).append("(<span id='sysMsgCountSpan'>").append(allMsgCountStr).append("</span>").append(message_header_unit_label).append(")");
  	strBuffer.append("</div>");
	strBuffer.append("<div id='sysMsgContentDiv' style='width:100%;height:").append(height).append(";overflow-x:hidden;overflow-y:auto;'>");
	strBuffer.append(systemMsgContent+_projectContent+_deptleaveContent+_spaceleaveContent+_calleaveContent);
	strBuffer.append("</div>");
	strBuffer.append("</td>");
	strBuffer.append("</tr>");
	strBuffer.append("</table>");
	var MSG = new CLASS_MESSAGE("", "", "", "", strBuffer.toString(), 1);
	strBuffer.clear();
	return MSG;
}
/**
 * 将留言板/日程事件消息转换为HTML type:(1项目 2部门 3日程 4空间)
 */
function leaveWordMessageListToHTML(leaveProperties, printHRFlag, fromType,type){
	var sysMsgStrBuffer = new StringBuffer();
	var handleWin = getHandleWin(fromType);
	var _keys = leaveProperties.keys();
	var _length = _keys.size();
	for(var j = 0; j < _length; j ++){
		var key = _keys.get(j);
		var msgList = leaveProperties.get(key);
		var _msg = msgList.get(0);
		var referenceId = _msg.referenceId;
		var userHistoryMessageId = _msg.userHistoryMessageId;
		var datetime = new Date(parseInt(_msg.creationDateTime, 10)).format("MM-dd HH:mm");
		var countStr = "count" + _msg.userHistoryMessageId;
		var tdStr = "td" + _msg.referenceId;
		var timeStr = "time" + _msg.referenceId;
		var deptNameSpan = "deptNameSpan"+_msg.referenceId;
		var countSpan = getCtpTop().document.getElementById(countStr);
		var content = _msg.content;
		var deptName ='';
		var label = handleWin.v3x.getMessage("V3XLang.leaveword");
		if(type == 1){
			deptName = getProjectName(referenceId);
		}
		if(type == 2){
			deptName = getDepartmentName(referenceId);	
		}
		if(type == 3){
			var deptNameTemp = getEventName(referenceId);
			label = handleWin.v3x.getMessage("V3XLang.reply");
			deptName  = "&lt;"+deptNameTemp+"&gt;";
		}
		if(type == 4){
			deptName = getSpaceName(referenceId);	
		}
		if(countSpan){
			var tdObj = getCtpTop().document.getElementById(tdStr);
			var timeObj = getCtpTop().document.getElementById(timeStr);
			var deptNameObj = getCtpTop().document.getElementById(deptNameSpan);
			var tt = parseInt(countSpan.getAttribute('title'))+msgList.size();
			countSpan.innerHTML = tt;
			countSpan.setAttribute('title',tt);
			tdObj.innerHTML = "<div class='default-a' style='text-decoration: none;width:240px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>"+content+"</div>";
			timeObj.innerHTML = datetime;
			deptNameObj.setAttribute('title',deptName);
			deptNameObj.innerHTML = deptName;
			
		}else{
			sysMsgStrBuffer.append("<table width='100%' id='sysMsgTable" + userHistoryMessageId+"'");
			if(_msg.messageLink){
				if(fromType == "a8"){
					sysMsgStrBuffer.append(" class='hand' typeAttr='leaveWord' countAttrId='"+referenceId+"'  onclick='getCtpTop().openDocument(\"").append(_msg.messageLink).append("\", \"").append(_msg.linkOpenType).append("\");getCtpTop().updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
				}else{
					var link = _msg.messageLink;
					var strs = link.split("|");
					var linkType = messageLinkConstants.get(strs[0]);
					linkType = linkType.substring(7, linkType.length);
			    	if(linkType){
			       		var l = 1;
						while(true){
							var param = strs[l];
							if(!param){
								break;
							}
							var regEx = eval("messageRegEx_" + (l - 1));
							linkType = linkType.replace(regEx, param);
							l ++;
						}
						//取参数vc的值：填充到参数v上去，加密规则
						var indexVc = link.indexOf("vc:"),verifyCode;
						if (indexVc != -1) {
							if (link.substr(indexVc)
									&& link.substr(indexVc).split("|").length > 0
									&& link.substr(indexVc).split("|")[0].split(":").length > 0) {
								verifyCode = link.substr(indexVc).split("|")[0].split(":")[1];
							}
						}
						linkType = setURLParam("v",verifyCode,linkType);
						sysMsgStrBuffer.append(" class='hand' onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
					}
				}
			}
			sysMsgStrBuffer.append("><input type='hidden' name='countMessages'/>");
			sysMsgStrBuffer.append("<tr>");
				sysMsgStrBuffer.append("<td class='default-a' style='text-decoration: none;font-weight: bold;'>");
//				sysMsgStrBuffer.append("<span title='"+deptName+"' id='"+deptNameSpan+"'>"+deptName.getLimitLength(20,'...')+"</span>");
				sysMsgStrBuffer.append("<span title='"+deptName+"' id='"+deptNameSpan+"'>"+deptName+"</span>");
				sysMsgStrBuffer.append(label+"(<span name='leavewordCount' id='"+countStr+"' title='"+msgList.size()+"'>"+msgList.size()+"</span>)");
				sysMsgStrBuffer.append("</td>");
				sysMsgStrBuffer.append("<td id='"+timeStr+"' align='right' nowrap='nowrap' class='default-a' style='text-decoration: none;'>");
				sysMsgStrBuffer.append(datetime);
				sysMsgStrBuffer.append("</td>");
			sysMsgStrBuffer.append("</tr>");
			sysMsgStrBuffer.append("<tr>");
			sysMsgStrBuffer.append("<td id='"+tdStr+"' colspan='2'><div class='default-a' style='text-decoration: none;width:240px;overflow:hidden;text-overflow:ellipsis;'>");
			sysMsgStrBuffer.append(content);
			sysMsgStrBuffer.append("</div></td>");
			sysMsgStrBuffer.append("</tr>");
			sysMsgStrBuffer.append("</table>");
			if(j < _length - 1 || printHRFlag){
				sysMsgStrBuffer.append("<hr size='1' class='border-top' style='padding-top:8px; border-left:0;border-right:0;' />");
			}
		}
	}
	
	var resultStr = sysMsgStrBuffer.toString();
	sysMsgStrBuffer.clear();
	return resultStr;
}
/**
 * 显示在线消息
 */
function showPerMessage(fromType, isNotice){
	var count = 1;
	var personMsgContent = "";
	var height = "30";
	if(!isNotice){
		count = msgProperties.size();
		if(count < 1){
			return;
		}
		height = getPerMessageHeight();
		personMsgContent = perMessageListToHTML(false, fromType);
	}
  	var strBuffer = new StringBuffer();
  	strBuffer.append("<table id='perTable' width='280' border='0' cellspacing='0' cellpadding='0' class='msgborder'>");
  	strBuffer.append("<tr>");
  	strBuffer.append("<td height='100%' class='msgContentPerson'>");
  	strBuffer.append("<div class='msgContentDivHeader'>");
  	strBuffer.append(message_header_person_label).append("(<span id='perMsgCountSpan'>" + count + "</span>").append(message_header_unit_label).append(")");
  	strBuffer.append("</div>");
  	strBuffer.append("<div id='personMsgContentDiv' style='width:100%;height:").append(height).append("px;overflow:auto;overflow-x:hidden;'>");
  	strBuffer.append(personMsgContent);
  	strBuffer.append("</div>");
  	strBuffer.append("</td>");
  	strBuffer.append("</tr>");
  	strBuffer.append("</table>");
  	var MSG = new CLASS_MESSAGE("", "", "", "", strBuffer.toString(), 3);
  	strBuffer.clear();
  	return MSG;
}

function showPerNotice(random, content, fromType){
	try{
	    var msgStrBuffer = new StringBuffer();
		msgStrBuffer.append("<table width='100%' border='0' cellspacing='0' cellpadding='0' id='" + random + "'>");
		msgStrBuffer.append("<tr valign='middle' class='hand' onclick='removeMsgFromBox(\"person\", \"" + random + "\", \"\", \"" + fromType + "\");'>");
		msgStrBuffer.append("<td align='left' class='messageHeaderContent' colspan='3' title='" + content + "'>" + content.getLimitLength(25, "...") + "</td>");
		msgStrBuffer.append("</tr>");
		msgStrBuffer.append("</table>");
		
		var handleWin = getHandleWin(fromType);
		if(handleWin.isPerMessageWindowEyeable){
			msgStrBuffer.append("<hr size='1' class='border-top margin_tb_5' style='border-left:0;border-right:0;' />");
			handleWin.$("#personMsgContentDiv").prepend(msgStrBuffer.toString());
			var height = getPerMessageHeight();
			handleWin.$("#personMsgContentDiv").height(height);
			var count = msgProperties.size() + noticeProperties.size();
			handleWin.$("#perMsgCountSpan").text(count);
			DivSetVisible(true, fromType);
		}else{
			var msgObj = showPerMessage(fromType, true);
			ShowMessageWindow(msgObj, fromType);
			handleWin.$("#personMsgContentDiv").prepend(msgStrBuffer.toString());
			handleWin.isPerMessageWindowEyeable = true;
		}
		
		msgStrBuffer.clear();
		
		handleWin.playMessageRadio();
		if(fromType == "a8"){
			getCtpTop().startActionTitle();
		}
	}catch(e){}
}

/**
 * 将系统消息转换为HTML
 */
function sysMessageListToHTML(msgList, printHRFlag, fromType,_pdc){
	var sysMsgStrBuffer = new StringBuffer();
	for (var i = 0; i < msgList.length; i++) {
		var userHistoryMessageId = msgList[i].userHistoryMessageId;
		var datetime = new Date(parseInt(msgList[i].creationDateTime, 10)).format("MM-dd HH:mm");
		sysMsgStrBuffer.append("<table width='100%' style='*width:250px;' id='sysMsgTable" + userHistoryMessageId + "'><input type='hidden' name='countSysMessages'/>");
		sysMsgStrBuffer.append("<tr valign='top'");
		if(msgList[i].messageLink){
			if(fromType == "a8"){
				sysMsgStrBuffer.append(" class='hand' onclick='getCtpTop().openDocument(\"").append(msgList[i].messageLink).append("\", \"").append(msgList[i].linkOpenType).append("\");getCtpTop().updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");getCtpTop().afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
			}else{
				var link = msgList[i].messageLink;
				var strs = link.split("|");
				var linkType = messageLinkConstants.get(strs[0]);
				linkType = linkType.substring(7, linkType.length);
		    	if(linkType){
		       		var l = 1;
					while(true){
						var param = strs[l];
						if(!param){
							break;
						}
						var regEx = eval("messageRegEx_" + (l - 1));
						linkType = linkType.replace(regEx, param);
						l ++;
					}
					//取参数vc的值：填充到参数v上去，加密规则
					var indexVc = link.indexOf("vc:"),verifyCode;
					if (indexVc != -1) {
						if (link.substr(indexVc)
								&& link.substr(indexVc).split("|").length > 0
								&& link.substr(indexVc).split("|")[0].split(":").length > 0) {
							verifyCode = link.substr(indexVc).split("|")[0].split(":")[1];
						}
					}
					linkType = setURLParam("v",verifyCode,linkType);
					sysMsgStrBuffer.append(" class='hand' onclick='openSysMessage(\"").append(linkType).append("\");updateMessageState(\"").append(userHistoryMessageId).append("\", this, \"" + fromType + "\");afterClickMessage(\"").append(userHistoryMessageId).append("\", \"" + fromType + "\")'");
				}
			}
		}
		sysMsgStrBuffer.append(">");
		sysMsgStrBuffer.append("<td id='LeftTD").append(userHistoryMessageId).append("' width='70%' class='default-a' style='text-decoration: none; word-wrap: break-word;'>");
		sysMsgStrBuffer.append("<div>");
		if(msgList[i].importantLevel == '2' || msgList[i].importantLevel == '3'){
			sysMsgStrBuffer.append("<span class='ico16  important" + msgList[i].importantLevel + "_16'></span>");
		}
		sysMsgStrBuffer.append(msgList[i].content);
		sysMsgStrBuffer.append("</div>");
		sysMsgStrBuffer.append("</td>");
		var senderName = "";
		if (msgList[i].senderId != '-1') {
			senderName = msgList[i].senderName + msgList[i].accountShortName;
		} else {
			senderName = msgList[i].senderName;
		}
		sysMsgStrBuffer.append("<td nowrap id='RightTD").append(userHistoryMessageId).append("' width='30%' align='right' style='color: #000000; text-decoration: none;' title='" + senderName + "'>").append(senderName.getLimitLength(12, "...")).append("<br>").append(datetime);
		sysMsgStrBuffer.append("</td>");
		sysMsgStrBuffer.append("</tr>");
		sysMsgStrBuffer.append("</table>");
		if(i < msgList.length - 1 || printHRFlag || (_pdc!=null && _pdc>0)){
			sysMsgStrBuffer.append("<hr size='1' class='border-top' style='padding-top:12px; border-left:0;border-right:0;' />");
		}
	}
	var resultStr = sysMsgStrBuffer.toString();
	sysMsgStrBuffer.clear();
	return resultStr;
}

function setURLParam(name, value, url) {
	var newUrl = new String();
	var _url = url;
	if (_url.indexOf("?") != -1) {
		_url = _url.substr(_url.indexOf("?") + 1);
		if (_url.toLowerCase().indexOf(name.toLowerCase()) == -1) {
			newUrl = url + "&" + name + "=" + value;
			return newUrl;
		} else {
			var aParam = _url.split("&");
			for ( var i = 0; i < aParam.length; i++) {
				if (aParam[i].substr(0, aParam[i].indexOf("=")).toLowerCase() == name
						.toLowerCase()) {
					aParam[i] = aParam[i].substr(0, aParam[i].indexOf("=")) + "=" + value;
				}
			}
			newUrl = url.substr(0, url.indexOf("?") + 1) + aParam.join("&");
			return newUrl;
		}
	} else {
		_url += "?" + name + "=" + value;
		return _url
	}
}

/**
 * 将在线消息转换为HTML
 */
function perMessageListToHTML(printHRFlag, fromType){
	var handleWin = getHandleWin(fromType);
	var msgStrBuffer = new StringBuffer();
	var msgInstanceKeys = msgProperties.keys();
	var msgFromCount = msgInstanceKeys.size();//聊天对象个数
	for(var i = 0; i < msgFromCount; i++){
		var key = msgInstanceKeys.get(i);
		var msg = msgProperties.get(key);
		var msgCount = msg.size();//当前聊天对象的消息个数
		var latestMsg = msg.getLast();
		var tID  = key;
		var tableId = tID + "_Table";
		var tName = latestMsg.name.escapeHTML();
		var senderName = "";
		if (latestMsg.type != 1) {
			senderName = latestMsg.username.escapeHTML() + ":";
		}
		
		var msgContent = "";
		if (latestMsg.atts.size() > 0) {
			msgContent = senderName + "给您发送了文件";
		} else if (latestMsg.microtalk != null) {
			msgContent = senderName + "给您发送了语音";
		} else if (latestMsg.vcard != null){
            msgContent = senderName + "给您发送了名片";
        } else {
			msgContent = getMsgLimitLength(senderName + latestMsg.content, 80);
			msgContent = msgContent.escapeHTML();
			for(var j = 0; j < face_texts_replace.length; j++){
				msgContent = msgContent.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
			}
		}
		
		if(handleWin.$("#" + tableId).length > 0){
			handleWin.$("#" + tableId + "CountSpan").text(msgCount);
			handleWin.$("#" + tableId + "DateSpan").text(latestMsg.time);
			handleWin.$("#" + tableId + "ContentSpan").html(msgContent);
		}else{
			msgStrBuffer.append("<table width='100%' style='*width:250px;' class='hand' height='50' border='0' cellspacing='0' cellpadding='0' id='" + tableId + "' onclick='removeMsgFromBox(\"person\", \"" + tableId + "\", \"" + tID + "\", \"" + fromType + "\");openWinIM(\"" + tName + "\", \"" + latestMsg.jid + "\")'>");
			msgStrBuffer.append("<tr valign='top'>");
			msgStrBuffer.append("<td width='40%' align='left' class='messageHeaderContent default-a'><b><a>" + tName + "(<span id='" + tableId + "CountSpan'>" + msgCount + "</span>" + message_header_unit_label + ")</a></b></td>");
			msgStrBuffer.append("<td width='50%' align='right' class='messageHeaderContent'><span id='" + tableId + "DateSpan'>" + latestMsg.time + "</span></td>");
			msgStrBuffer.append("</tr>");
			msgStrBuffer.append("<tr valign='top'>");
			msgStrBuffer.append("<td colspan='3' align='left' class='messageBodyContent default-a'><div id='" + tableId + "ContentSpan'><a>" + msgContent + "</a></div></td>");
			msgStrBuffer.append("</tr>");
			msgStrBuffer.append("</table>");
			
			if(i < msgFromCount - 1 || printHRFlag){
				msgStrBuffer.append("<hr size='1' class='border-top' style='border-left:0;border-right:0;' />");
			}
			
			var count = msgProperties.size() + noticeProperties.size();
			handleWin.$("#perMsgCountSpan").text(count);
		}
	}
	
	var resultStr = msgStrBuffer.toString();
	msgStrBuffer.clear();
	return resultStr;
}

/**
 * 最小化消息窗口
 */
function changeMessageWindow(fromType){
	if(fromType == "a8"){
		var msgDiv = getCtpTop().$("#msgWindowDIV");
		var msgMaxDiv = getCtpTop().$("#msgWindowMaxDIV");
		var DivShim4MsgWindow = getCtpTop().$("#DivShim4MsgWindow");
		if(msgDiv.is(":hidden")){
			msgDiv.show();
			msgMaxDiv.hide();
			DivShim4MsgWindow.show();
		}else{
			msgDiv.hide();
			msgMaxDiv.show();
			DivShim4MsgWindow.hide();
		}
	}else{
		window.external.js_btnClickMinx();
	}
}

/**
 * 关闭消息窗口
 */
function destroyMessageWindow(isClear, fromType){
	if(isClear == "true"){
		msgProperties.clear();//清空页面存储的在线消息
	}
	
	var handleWin = getHandleWin(fromType);
	
	handleWin.$("#PerMsgContainer").html("");
	handleWin.isPerMessageWindowEyeable = false;
	
	handleWin.$("#SysMsgContainer").html("");
	handleWin.isSysMessageWindowEyeable = false;
	
	//性能优化:去掉右下角系统消息的未读数量
	/*if(fromType == "a8"){
		getCtpTop().$("#notReadSysCountSpan").hide();
	}*/
	
	handleWin.$("#msgWindowDIV").hide();
	var DivRefIframe = handleWin.$("#DivShim4MsgWindow");
	DivRefIframe.hide();
	if(fromType == "a8"){
		getCtpTop().standardTitleFun();
	}else{
		window.external.js_btnClickClose();
	}
}

/**
 * 如果个人设置"消息查看后从消息框中移出",则系统消息点击后从消息框中移出,否则只改变消息颜色
 */
function afterClickMessage(index, fromType){
	var handleWin = getHandleWin(fromType);
	if(handleWin.msgClosedEnable){
		removeMsgFromBox("system", index, "", fromType);
	}else{
		changeTRColor(index, fromType);
	}
}

/**
 * 消息点击后从消息框中移除,消息总数做相应减少
 */
function removeMsgFromBox(type, index, tID, fromType){
	var handleWin = getHandleWin(fromType);
	var divId = "sysMsgContentDiv";
	var tableId = "sysMsgTable" + index;
	var spanId = "sysMsgCountSpan";
	var removeCount = 1;
	if(type == "person"){
		divId = "personMsgContentDiv";
		tableId = index;
		spanId = "perMsgCountSpan";
		if(tID){
			msgProperties.remove(tID);
		}else{
			noticeProperties.remove(tableId);
		}
	}
	
	//移除消息
	var msgContentDiv = handleWin.document.getElementById(divId);
	var msgTable = handleWin.document.getElementById(tableId);
	//留言板合并条数
	var spanCount = handleWin.document.getElementById('count'+index);
	if(spanCount){
		removeCount = parseInt(spanCount.getAttribute('title'));
	}
	var msgChildren = msgContentDiv.children;
	var currentMsgCount = -1;
	for(var i = 0; i < msgChildren.length; i += 2){
		if(msgTable == msgChildren[i]){
			currentMsgCount = i;
			break;
		}
	}
	if(currentMsgCount != -1 && msgChildren.length != 1){
		if(currentMsgCount != msgChildren.length - 1){
			msgContentDiv.removeChild(msgChildren[currentMsgCount + 1]);
		}else{
			msgContentDiv.removeChild(msgChildren[currentMsgCount - 1]);
		}
		msgContentDiv.removeChild(msgTable);
	}else{
		msgContentDiv.removeChild(msgTable);
	}
	
	//更改消息总数
	var countSpanObj = handleWin.$("#" + spanId);
	var originalCount = parseInt(countSpanObj.text()) - removeCount;
	if(originalCount == 0 || msgContentDiv.children.length <= 0){
		colseMessageWindow(type, fromType);
		return;
	}
	countSpanObj.text(originalCount);
	
	//更改消息高度
	var height = getHeight(originalCount);
	if(type == "person"){
		height = getPerMessageHeight();
	}
	handleWin.$("#" + divId).height(height);
	
	DivSetVisible(false, fromType);
}

/**
 * 系统消息点击后改变颜色
 */
function changeTRColor(index, fromType){
	var handleWin = getHandleWin(fromType);
	handleWin.$("#LeftTD" + index).css("color", "#666666");
	handleWin.$("#RightTD" + index).css("color", "#666666");
}

/**
 * 关闭消息
 */
function colseMessageWindow(type, fromType){
	var handleWin = getHandleWin(fromType);
	if(type == "system"){
		handleWin.$("#SysMsgContainer").html("");
		handleWin.$("#SysMsgContainerTR").hide();
		handleWin.isSysMessageWindowEyeable = false;
	}else if(type == "person"){
		handleWin.$("#PerMsgContainer").html("");
		handleWin.$("#PerMsgContainerTR").hide();
		handleWin.isPerMessageWindowEyeable = false;
	}
	DivSetVisible(false, fromType);
}

/**
 * 消息框显示/隐藏
 */
function DivSetVisible(state, fromType){
	var handleWin = getHandleWin(fromType);
	var DivRef = handleWin.$("#msgWindowDIV");
	var DivRefIframe = handleWin.$("#DivShim4MsgWindow");
	var helperTObj = handleWin.$("#helperTable");
	if(state){
		if(fromType == "a8"){
			getCtpTop().$("#msgWindowMaxDIV").hide();
		}
		DivRef.show();
		DivRef.height(helperTObj.height());
		DivRefIframe.height(helperTObj.height()).show();
		if(fromType == "genius"){
			resizeMessageWindow(DivRef.height());
		}
	}else{
		if(handleWin.isSysMessageWindowEyeable == false && handleWin.isPerMessageWindowEyeable == false){//系统消息和在线消息都关闭
			destroyMessageWindow("false", fromType);
		}else{//关闭一个
			DivRef.height(helperTObj.height());
			DivRefIframe.height(helperTObj.height()).show();
			if(fromType == "genius"){
				resizeMessageWindow(DivRef.height());
			}
		}
	}
}

/**
 * 计算系统消息框高度
 */
function getHeight(count){
	return (count > 4) ? "188px" : (count * 60) + "px";
}

/**
 * 计算在线消息框高度
 */
function getPerMessageHeight(){
	var height = msgProperties.size() * 60 + noticeProperties.size() * 35;
	if (height > 188) {
		height = 188;
	}
	return height;
}

/**
 * 如果是当日则显示HH:mm,如果非当日则显示yyyy-MM-dd HH:mm
 */
function showDatetime(datetime){
	var date1 = new Date(parseInt(datetime, 10)).format("yyyy-MM-dd");
	var date2 = new Date().format("yyyy-MM-dd");
	var dateStyle = "HH:mm:ss";
	if(date1 != date2){
		dateStyle = "yyyy-MM-dd HH:mm:ss";
	}
	return new Date(parseInt(datetime, 10)).format(dateStyle);
}

function getHandleWin(fromType){
	return fromType == "a8" ? getCtpTop() : window;
}

/**
 * 获取部门名称
 */
function getDepartmentName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "ajaxGetDepartmentName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取空间名称
 */
function getSpaceName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "ajaxGetSpaceName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取项目名称
 */
function getProjectName(id){
	var requestCaller = new XMLHttpRequestCaller(this, "projectManager", "ajaxGetProjectName", false);
	requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 获取事件名称
 */
function getEventName(id){
  var requestCaller = new XMLHttpRequestCaller(this, "ajaxCalEventManager", "ajaxGetEventName", false);
  requestCaller.addParameter(1, "long", id);
	return requestCaller.serviceRequest();
}
/**
 * 点击系统消息时更新未读状态
 */
function updateMessageState(id, obj, fromType){
	if(typeof(id) == "undefined" || id == null || id  == ""){
		return;
	}
	var handleWin = getHandleWin(fromType);
	//只第一次点击更新数据库
	if(handleWin.$(obj).attr("hasClicked") != "true"){
		updateSystemMessageState(id);
		handleWin.$(obj).attr("hasClicked", "true");
	}
}

/**
 * 更新系统消息已读状态
 */
function updateSystemMessageState(id){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageManager", "updateSystemMessageState", false);
	requestCaller.addParameter(1, "long", id);
	requestCaller.serviceRequest();
}

/**************************************** 在线消息页面闪烁start ****************************************/
var myIntervalTitle = null;
var standardTitle = null;
$(document).ready(function(){
    try {
    standardTitle = document.title;
  } catch (e) {
    standardTitle = '';
  }
});

var step = 0;
function flash_title(){
	step++
	if (step == 3) {step = 1}
	if (step == 1) {
		if(productVersion == "A8"){
			document.title = 'A8-V5';
		}else if(productVersion == 'A6'){
			document.title = 'A6-V5';
		}else if(productVersion == 'A6s'){
			document.title = 'A6-S';
		}else{
			document.title = 'A8-V5';
		}
	}
	if (step == 2) {document.title = standardTitle}
}

function startActionTitle(){
	if(!myIntervalTitle){
		myIntervalTitle = window.setInterval("flash_title()", 1000);
	}
}

function standardTitleFun(){
	if(!standardTitle){
		standardTitle = document.title
	}
	
	document.title = standardTitle;
	
	if(myIntervalTitle != null){
		window.clearInterval(myIntervalTitle);
		document.title = standardTitle;
		myIntervalTitle = null;
	}
}
/**************************************** 在线消息页面闪烁end ****************************************/

/**************************************** 播放声音start ****************************************/
function playMessageRadio(){
	if(isEnableMsgSound){
		$("#playSoundHelper").attr("src", v3x.baseURL + "/playSound.htm");
		try{
			//解决IE6恢复窗口重复播放声音的问题
			window.setTimeout("clearMessageRadio()", 2000);
		}catch(e){
			
		}
	}else{
		clearMessageRadio();
	}
}

function clearMessageRadio(){
	$("#playSoundHelper").attr("src", "");
}
/**************************************** 播放声音end ****************************************/

/**
 * 在线交流页面
 */
var onlineWin = null;
function onlineMember(){
	if (onlineWin && !onlineWin.closed) {
		onlineWin.focus();
    } else {
    	var left = 140;
    	var top = (window.screen.availHeight - 600) / 2 - 10;
        onlineWin = window.open(_ctxPath + "/online.do?method=showOnlineUser", "", "left=" + left + ",top=" + top + ",width=600,height=600,location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
    }
}
function getMsgLimitLength(text, maxLength) {
	var len = text.getBytesLength();
	if (len <= maxLength) {
		return text;
	}

	var symbol = "...";
	maxLength = maxLength - symbol.length;

	var a = 0;
	var temp = '';
	for ( var i = 0; i < text.length; i++) {
		if (text.charCodeAt(i) > 255) {
			a += 2;
		} else {
			a++;
		}

		temp += text.charAt(i);

		if (a >= maxLength) {
			break;
		}
	}

	var start = temp.substring(0, temp.length - 7);
	var end = temp.substring(temp.length - 7, temp.length);
	if (end.indexOf("[") != -1 && (end.indexOf("]") == -1 || end.indexOf("]") < end.indexOf("["))) {
		start += end.substring(0, end.indexOf("["));
	} else {
		start += end;
	}

	start += symbol;

	return start;
}