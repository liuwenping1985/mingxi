/**
 * 发送短信
 */
function sendSMS(ids) {
	var url = _ctxPath + "/message.do?method=showSendSMSDlg";
	if (ids) {
		url += "&receiverIds=" + ids;
	}
	/**人员卡片中发短信，卡死！通讯录中发送正常！原因是弹层的问题
	if (getA8Top().isCtpTop) {*/
		getA8Top().senSmsWin = getA8Top().$.dialog({
	        title:" ",
	        transParams:{'parentWin':window},
	        url: url,
	        width: 420,
	        height: 240,
	        isDrag:false
	    });
	/*} else {
		getA8Top().senSmsWin = getA8Top().v3x.openDialog({
	        title:" ",
	        transParams:{'parentWin':window},
	        url: url,
	        width: 420,
	        height: 240,
	        isDrag:false
	    });
	}*/
}

function sendSmsCollBack (sendResult) {
	getA8Top().senSmsWin.close();
	if(!sendResult){
		return;
	}
	alert(sendResult);
}