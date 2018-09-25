var ContantsOutNumberMinute = 30;//超时时间(分钟)
var ContantsOutNumber = 10;//请求失败次数

var messageTask = null;
var isFirstTask = true;


/**
 * 开始读取消息
 */
function initMessage(messageIntervalSecond){
	if(!messageIntervalSecond || messageIntervalSecond < 30){
		messageIntervalSecond = 30;
	}
	
	ContantsOutNumber = ContantsOutNumberMinute * 60 / messageIntervalSecond;
	
	messageTask = new Task(messageIntervalSecond);
	setTimeout("getMessage()", 5 * 1000);
}

/**
 * 任务
 */
function Task(messageIntervalSecond){
	this.intervalSecond = messageIntervalSecond * 1000;
	this.iTimeoutID = null;
	this.outNumber = 0;
}

/**
 * 启动任务
 */
Task.prototype.start = function(){
	this.iTimeoutID = window.setTimeout("getMessage()", this.intervalSecond + parseInt(Math.random() * 5) * 1000);
	isFirstTask = false;
}

/**
 * 终止任务
 */
Task.prototype.clear = function(){
	if(this.iTimeoutID){
		window.clearTimeout(this.iTimeoutID);
		this.iTimeoutID = null;
	}
}

/**
 * 退出
 */
Task.prototype.showOut = function(){
	showOnlineNum("X");
	this.clear();
}

/**
 * 提示退出
 */
Task.prototype.out = function(_status){
	this.outNumber++;
	
	showOnlineNum("X");
	
	if(!isA8geniusMsg){
		//getCtpTop().isOpenCloseWindow = false;
	}
	
	if(this.outNumber > ContantsOutNumber){
		_status = _status || "";
		if(window.confirm($.i18n("onlineMessage_alert_serverOver", _status))){
			if(!isA8geniusMsg){
				getCtpTop().logout(true);
			}else{
				window.external.js_OnLogOut("");
			}
		}
	}else{
		this.start();
	}
}

function getMessage(){
	showOnlineNum("...");
	new GetMessage().run();
}

function GetMessage(){
	this.name = "doGetMessage"
}

GetMessage.prototype.run = function(){
  	try{
		var requestCaller = new XMLHttpRequestCaller(this, null, null, true, "GET", true, "/getAJAXMessageServlet");
		requestCaller.filterLogoutMessage = false;
		requestCaller.closeConnection = true;
		requestCaller.serviceRequest();
		if(!isA8geniusMsg){
			//批量下载
		  /**
		   * TODO:批量下载
		   */
  		//	getCtpTop().contentFrame.topFrame.showDowloadPicture("quartz");
		}
	}catch(e){
		messageTask.out();
	}
}

GetMessage.prototype.showAjaxError = function(_status){
	messageTask.out(_status);
};

GetMessage.prototype.invoke = function(result){
	if(result){
		var resultVar = null;
		try {
			eval("resultVar = " + result);
		}catch(e){
			
		}
		
		if(!resultVar){
			if(result.indexOf("[LOGOUT]") == 0){//系统通知下线
				messageTask.clear();
				if(!isA8geniusMsg){
					getCtpTop().showLogoutMsg(result.substring(8));
				}else{
					window.external.js_OnLogOut(result.substring(8));
				}
				return;
			}else if(result.indexOf("[LOGWARN]") == 0){//系统下线前,通知用户保存当前数据
				alert(result.substring(9));
			}else{//未知情况
				//alert(result);
			}
		}else{
			var onlineNumber = resultVar["N"] || "0";
			var processNewUserMessages = resultVar["M"];
			
			var C = resultVar["C"] || "0";
			var messagesCounter = parseInt(C, 10);
			
			//性能优化:去掉右下角系统消息的未读数量
			//var R = resultVar["R"] || "0";
			//getCtpTop().notReadSystemMessageCount = parseInt(R, 10);
			
			showOnlineNum("" + onlineNumber);
			showOnlineInfo(processNewUserMessages, messagesCounter);
		}
	}
	
	messageTask.outNumber = 0;//成功返回数据，超时计数器清零
	messageTask.start();//开始新的一次轮询
};

/**
 * 显示在线人数
 */
function showOnlineNum(text){
	try{
		if(text){
			if(!isA8geniusMsg){
				$("#onlineNum").text(text);
				$("#onlineNum_adm").text(text);
			}else{
				window.external.js_OnlineCount(text);
			}
		}
	}catch(e){}
}

/**
 * 显示消息
 */
function showOnlineInfo(messages, messagesCounter){
	try {
	  	if(messages && messages.length > 0){
	   		var messagePerList = new Array();
	    	var messageSysList = new Array();
	    	if(!isA8geniusMsg){
	    		var linkTypes = new Set();
	    	}
	   		var k = 0;
	  		var m = 0;
	  		var isTimeLineObjReset = false;
	  		
	   		for (var i = 0; i < messages.length; i++) {
	   			var message = messages[i];
	   			var referenceId = message["R"];
	   			var userHistoryMessageId = message["H"];
	   			var content = message["C"] || "";
	   			var messageType = message["T"];
		        var senderId = message["S"];
		        var senderName = message["N"];
		        var accountShortName = message["SN"];
		        var verifyCode = message["VC"];
		        //发起者ID为-1标示"匿名"
		       	if(senderId == -1 || senderId == "-1"){
		        	senderName = ANNONYMOUS_NAME;
		       	}
		        var receiverId = "";
		        var receiverName = "";
		        var creationDateTime = message["D"];
		        
		        var linkType = message["L"];
		        
		        if(!isA8geniusMsg){
			        // 时间轴刷新
					if (linkType == "message.link.cal.view"
							|| linkType == "message.link.plan.send"
							|| linkType == "message.link.taskmanage.view"
							|| linkType == "message.link.edoc.sended"
							|| linkType == "message.link.col.pending"
							|| linkType == "message.link.mt.send") {
						isTimeLineObjReset = true;
					}
		        }
		        
		        //精灵NC消息、接口消息过滤链接（无法打开）
		        //任务是新做的，有新特性，暂不支持打开
		        if (isA8geniusMsg && 
		                (linkType == "message.link.NC.message" || 
		                 linkType == "message.link.webservice.message" || 
		                 linkType == "message.link.taskmanage.view" || 
		                 linkType == "message.link.taskmanage.viewfeedback" || 
		                 linkType == "message.link.taskmanage.viewfromreply")) {
		        	linkType = null;
		        }
		        
		        var link = linkType;
		        if(messageType == 0 && linkType){//有链接
			        if(!isA8geniusMsg){
			        	linkTypes.add(linkType);
			        }
		        	var l = 0;
					while(true){
						var param = message['P' + l];
						
						if(!param){
							break;
						}
						
						link += "|" + param;
						
						l ++;
					}
		        }
		        
		        var openType = parseInt(message["O"], 10);
		        var atts = message["A"];
		        var importantLevel = message["I"];
		        
		        if(messageType == 0){
		        	if(!(link && link.indexOf("leaveWord") != -1)){
		        		content = content.escapeHTML();
		        	}
		        }else{
		        	creationDateTime = showDatetime(creationDateTime);
		        }
		        
		        if(verifyCode != null && verifyCode != ""){
			          link = link + "|vc:" + verifyCode;
			    }
		        
		        var msg = new CLASS_MESSAGE("", "", referenceId, userHistoryMessageId, content, messageType, senderId, senderName, receiverId, receiverName, creationDateTime, link, openType, atts, importantLevel);
		        msg.accountShortName = accountShortName;
		        if(messageType == 1 || messageType == 2 || messageType == 3 || messageType == 4 || messageType == 5){
		        	messagePerList[k ++] = msg;
		        }
		        else if(messageType == 0){
		        	messageSysList[m ++] = msg;
		        }
		    }
	   		
	   		if(isTimeLineObjReset == true && isFirstTask == false){
	   			setTimeout("getCtpTop().timeLineObjReset(getCtpTop().timeLineObj)", 0);
	   		}
	   		
		    if((k + m) > 0){
				var allMsgCountStr = (messagesCounter > (k + m) && messagesCounter > 50) ? "/" + messagesCounter : "";
				if(!isA8geniusMsg){
			    	showMessage(null, messageSysList, allMsgCountStr, "a8");
			    	
			    	if(isFirstTask == false){ //第一次，不用刷新首页栏目
				     	try{
				     		getCtpTop().refreshSection(linkTypes.toArray());
				     	}catch(e1){
				     		
				     	}
		     		}
				}else{
					showMessage(null, messageSysList, allMsgCountStr, "genius");
				}
		    }
		}
	}catch(e){
		messageTask.clear();
	}
}