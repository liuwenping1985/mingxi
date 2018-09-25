/**
 * 显示消息
 */
function showMessage(){
	var roster = connWin.roster;
    if (roster.chatusers.length < 1) {
        return;
    }
    
    var msgStrBuffer = new StringBuffer();
    for (var j = roster.chatusers.length - 1; j >= 0; j--) {
        var user = roster.chatusers[j];
        var msgCount = user.chatmsgs.size();
        if (msgCount > 0) {
            var tableId = user.jid.substring(0, user.jid.indexOf('@')) + "_Table";
            if ($("#" + tableId).length > 0) {
                $("#" + tableId + "CountSpan").text(msgCount);
            } else {
            	var photo = connWin._PhotoMap.get(user.jid);
            	if (user.jid.indexOf('@group') >= 0) {
            		photo = v3x.baseURL + "/apps_res/uc/chat/image/Group1.jpg";
            	}
                msgStrBuffer.append("<div class='border_b font_size12 item clearfix hand' id='" + tableId + "' onclick='removeMessage(\"" + tableId + "\");openWinIM(\"" + user.name + "\", \"" + user.jid + "\")'>");
                msgStrBuffer.append("<span class='margin_r_10 margin_l_5 left'><img src='" + photo + "' width='20' height='20'/></span>");
                msgStrBuffer.append("<span title='" + user.name + "' class='left name_span'>" + user.name + "</span>");
                msgStrBuffer.append("<span class='margin_l_5 left number_span'>(<span id='" + tableId + "CountSpan'>" + msgCount + "</span>)</span>");
                msgStrBuffer.append("</div>");
                
                $("#msgWindowMaxCount").attr("count", (parseInt($("#msgWindowMaxCount").attr("count"), 10) + 1));
                $("#msgWindowMaxCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
                $("#msgWindowCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
            }
        }
    }
    if (!msgStrBuffer.isBlank()) {
    	$("#uc_online_messages_items").prepend(msgStrBuffer.toString());
    	$("#uc_online_messages").show();
    	msgStrBuffer.clear();
    }
}

/**
 * 显示通知
 */
function showNotice(random, content){
    var msgStrBuffer = new StringBuffer();
    msgStrBuffer.append("<div class='border_b font_size12 item clearfix hand' id='" + random + "' onclick='removeMessage(\"" + random + "\");'>");
    msgStrBuffer.append("<span class='margin_r_10 margin_l_10 margin_t_5 left' title='" + content + "'>" + content.getLimitLength(25, "...") + "</span>");
    msgStrBuffer.append("</div>");
    
    $("#msgWindowMaxCount").attr("count", (parseInt($("#msgWindowMaxCount").attr("count"), 10) + 1));
    $("#msgWindowMaxCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
    $("#msgWindowCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
    
    $("#uc_online_messages_items").prepend(msgStrBuffer.toString());
    $("#uc_online_messages").show();
    msgStrBuffer.clear();
}

/**
 * 移除消息
 */
function removeMessage(index){
    $("#" + index).remove();
    $("#msgWindowMaxCount").attr("count", (parseInt($("#msgWindowMaxCount").attr("count"), 10) - 1));
    
    if ($("#uc_online_messages_items .item").length == 0) {
        $("#msgWindowMaxCount").text("");
        $("#msgWindowCount").text("");
        $('#uc_online_messages').hide();
    } else {
        $("#msgWindowMaxCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
        $("#msgWindowCount").text("(" + $("#msgWindowMaxCount").attr("count") + ")");
    }
}

function openWinIM(name, jid){
	if (connWin.roster.DisabledChatUser.get(jid)) {
		alert($.i18n('uc.group.notinfo.js'));
		return;
	}
	connWin.openWinIM(name, jid);
}