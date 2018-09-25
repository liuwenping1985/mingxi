/**************************************** 精灵消息 ****************************************/

/**
 * 精灵打开系统消息
 */
function openSysMessage(link){
	window.external.js_ClickSysMessge(link);
}

/**
 * 精灵打开在线消息
 */
function openPerMessage(key){
	var msg = msgProperties.get(key);
	window.external.js_ClickUserMessge(msg.instance);
	msgProperties.remove(key);
}

/**
 * 改变精灵消息窗口高度
 */
function resizeMessageWindow(height){
	window.external.js_SetWindowWidthHeight("280", height);
}

/**
 * 判断精灵IM窗口是否打开
 */
function isGeniusIMExist(){
	var geniusIM = window.external.js_CheckTalkingShow();
	return geniusIM == "true";
}

/**
 * 精灵IM窗口已打开, 轮询到的消息直接显示到窗口
 */
function showGeniusMessageForIM(messages){
	window.external.js_PushJsonStr(messages);
}
