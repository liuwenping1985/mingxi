<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<html:link renderURL="/project.do" var="basicURL" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/memberMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
<c:if test="${!project && !isSpaceManager && param.isManager=='true'}">
	alert(_("MainLang.no_acl_department_leavework_manage"));
</c:if>
var genericURL = "${guestbookURL}";	
var fromModel = "${fromModel}";
	if(${!project}){
	   var theHtml=toHtml("${preFix}",'<fmt:message key="guestbook.manage.label"/>');
    	showCtpLocation("",{html:theHtml});
	}

function fastLeaveMessageAction(){

	document.getElementById("fastLeaveMessageAction").disabled = true;
		var sendMessage = 'true';
		var oSendMessage = document.getElementById('sendMessage');
		if(oSendMessage){
			if(!oSendMessage.checked){
				sendMessage = 'false';
			}
		}
		var contentReplyMessage = '';
        var oContentReplyArea = document.getElementById('fastLeaveMessage');
        if(oContentReplyArea){
            if(!checkSendMessages(oContentReplyArea.value.trim())){
                document.getElementById("fastLeaveMessageAction").disabled = false;
                return;
            }
            
            var temp = oContentReplyArea.value.trim();
            temp = temp.escapeHTML();
            temp = temp.replace(/\[5_1\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_1.gif'  />");
            temp = temp.replace(/\[5_2\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_2.gif'  />");
            temp = temp.replace(/\[5_3\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_3.gif'  />");
            temp = temp.replace(/\[5_4\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_4.gif'  />");
            temp = temp.replace(/\[5_5\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_5.gif'  />");
            temp = temp.replace(/\[5_6\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_6.gif'  />");
            temp = temp.replace(/\[5_7\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_7.gif'  />");
            temp = temp.replace(/\[5_8\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_8.gif'  />");
            temp = temp.replace(/\[5_9\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_9.gif'  />");
            temp = temp.replace(/\[5_10\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_10.gif'  />");
            temp = temp.replace(/\[5_11\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_11.gif'  />");
            temp = temp.replace(/\[5_12\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_12.gif'  />");
            temp = temp.replace(/\[5_13\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_13.gif'  />");
            temp = temp.replace(/\[5_14\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_14.gif'  />");
            temp = temp.replace(/\[5_15\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_15.gif'  />");
            temp = temp.replace(/\[5_16\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_16.gif'  />");
            temp = temp.replace(/\[5_17\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_17.gif'  />");
            temp = temp.replace(/\[5_18\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_18.gif'  />");
            temp = temp.replace(/\[5_19\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_19.gif'  />");
            temp = temp.replace(/\[5_20\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_20.gif'  />");
            temp = temp.replace(/\[5_21\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_21.gif'  />");
            temp = temp.replace(/\[5_22\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_22.gif'  />");
            temp = temp.replace(/\[5_23\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_23.gif'  />");
            temp = temp.replace(/\[5_24\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_24.gif'  />");
            temp = temp.replace(/\[5_25\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_25.gif'  />");
            temp = temp.replace(/\[5_26\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_26.gif'  />");
            temp = temp.replace(/\[5_27\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_27.gif'  />");
            temp = temp.replace(/\[5_28\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_28.gif'  />");
            temp = temp.replace(/\[5_29\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_29.gif'  />");
            temp = temp.replace(/\[5_30\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_30.gif'  />");
            temp = temp.replace(/\[5_31\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_31.gif'  />");
            temp = temp.replace(/\[5_32\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_32.gif'  />");

            contentReplyMessage = temp;
        }else{
            document.getElementById("fastLeaveMessageAction").disabled = false;
            return;
        } 
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "saveAjaxLeaveWord", false);
        requestCaller.addParameter(1, "String", "${departmentId}");
        requestCaller.addParameter(2, "String", sendMessage);
        requestCaller.addParameter(3, "String", contentReplyMessage);
        requestCaller.addParameter(4, "String", "no");
        requestCaller.addParameter(5, "String", "no");
        if("${custom}"=="true"){
            requestCaller.addParameter(6, "String", "custom");
        }else{
            requestCaller.addParameter(6, "String", "${project ? 'project' : 'no'}");
            requestCaller.addParameter(7, "Long", "${phaseId}");
            requestCaller.addParameter(8, "Long", "${spaceIds}");
        }
        var resultStr = requestCaller.serviceRequest();
        if(resultStr == 'true'){
            window.location.href = window.location;
        }
	
}
function replyAction(replyId,indexId,replyerId){
	var oReplyDiv = document.getElementById(indexId+'_reply');
	var className = oReplyDiv.previousSibling.className;
	if(className=='listReplyDiv'){return;}
	var oParent = oReplyDiv.parentNode;
	var oDiv = document.createElement('div');
	oDiv.className="listReplyDiv";
	oDiv.id=indexId+"_replyDiv";
	oDiv.innerHTML="<div class='header'><div class='title'>"+_('MainLang.leaveMessageRange')+"</div></div><div class='content'><textarea id='"+indexId+"_contentReplyArea' class='contentArea'></textarea></div><div class='footer'><div class='sentMessage'><label for='sendMessage'><input id='"+indexId+"_sendMessage' checked type='checkbox'/>"+_("MainLang.sendMessage")+"</label></div><div class='sentButton'><input id='sendReply' type='button' class='sendAction' onclick=\"sendListReplyMessage('"+"${departmentId}"+"','"+replyId+"','"+indexId+"','"+replyerId+"')\" value='"+_("MainLang.sendAction")+"'/><input type='button' class='sendAction' onclick=\"sendListReplyMessageHidden('"+indexId+"')\" value='"+_('MainLang.close')+"'/></div></div>";
	oParent.insertBefore(oDiv,oReplyDiv);
}
function sendListReplyMessageHidden(indexId){
	var oReplyDiv = document.getElementById(indexId+'_replyDiv');
	if(oReplyDiv){
		oReplyDiv.parentNode.removeChild(oReplyDiv);
	}
}
function sendListReplyMessage(departmentId,replyId,indexId,replyerId){

		var sendMessage = 'true';
		var contentReplyMessage = '';
		var oSendMessage = document.getElementById(indexId+'_sendMessage');
		var oContentReplyArea = document.getElementById(indexId+'_contentReplyArea');
		if(oSendMessage){
			if(!oSendMessage.checked){
				sendMessage = 'false';
			}
		}
		if(oContentReplyArea){
				//contentReplyMessage = encodeURIComponent(encodeURIComponent(oContentReplyArea.value));
				contentReplyMessage = oContentReplyArea.value;
				if(!checkSendMessage(contentReplyMessage)){return;}
		}else{return;}
		if(replyId!=null && replyId!='' && replyId !='undefined'){
            replyIdTemp = replyId;
        }
		var replyerIdTemp = 'no';
        if(replyerId!=null && replyerId!='' && replyerId!='undefined'){
            replyerIdTemp = replyerId;
        }
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "saveAjaxLeaveWord", false);
        requestCaller.addParameter(1, "String", departmentId);
        requestCaller.addParameter(2, "String", sendMessage);
        requestCaller.addParameter(3, "String", contentReplyMessage.escapeHTML());
        requestCaller.addParameter(4, "String", replyIdTemp);
        requestCaller.addParameter(5, "String", replyerIdTemp);
        if("${custom}"=="true"){
            requestCaller.addParameter(6, "String", "custom");
        }else{
            requestCaller.addParameter(6, "String", "${project ? 'project' : 'no'}");
            requestCaller.addParameter(7, "Long", "${phaseId}");
            requestCaller.addParameter(8, "Long", "${spaceIds}");
        }
        var resultStr = requestCaller.serviceRequest();
        if(resultStr == 'true'){
            window.location.href = window.location;
        } else {
        	//返回false表示留言已经被删除
        	alert(_("MainLang.guestbook_rep_not_select"));
        	window.location.href = window.location;
        }
 		document.getElementById("sendReply").disabled=true; 
		
}
function deleteReplyMessage(id,type){

	var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "deleteAjaxLeaveWord", false);
	requestCaller.addParameter(1, "String", id);
	var resultStr = requestCaller.serviceRequest();
	if(resultStr == 'true'){
		window.location.href = window.location;
	}

}
function banchDelete(){
	window.location.replace("${guestbookURL}?method=banchDeleteList&departmentId=${departmentId}&project=${project}&fromModel=${fromModel}&custom=${custom}&spaceId=${spaceIds}&phaseId=${phaseId}");
}

function showFasesDiv(){
	var o = document.getElementById('fasesDiv');
	o.style.display='block';
}
function addFase(){

	
}
function hiddenFasesDiv(){
	try{
	 ev = arguments.callee.caller.arguments[0] || window.event; 
	 var  e    =  ev.target  ||  ev.srcElement;
	 var oo = document.getElementById('fasesDiv');
	 if(e.tagName == 'IMG' || e.tagName == 'img' || e==oo){return;}
	 var o = document.getElementById('fasesDiv');
		 o.style.display='none';
	}catch(e){
	}
}
function initLeaveMessageContent(){
	if(document.all){return;}
	var array = document.getElementsByName('leaveMessageContent');
	for(var i = 0; i<array.length ;i++){
		array[i].style.width = (window.document.body.clientWidth-140)+"px";
	}
	var array2 = document.getElementsByName('subLeaveMessageContent');
	for(var i = 0; i<array2.length ;i++){
		array2[i].style.width = (window.document.body.clientWidth-225)+"px";
	}
}
function checkSendMessages(str){

	str = str.trim();
	
	if(str.length == 0||str==''||str=='\n'){
		alert(_("MainLang.leaveMessageIsNull"));
		return false;
	}
	
	if(/^[^\\"'<>]*$/.test(str)){
		if(str.length > 1200){
			alert(_("MainLang.leaveMessageNowLength") + str.length +_("MainLang.leaveMessageChange"));
			return false;
		}else{
			return true;
		}
	}else{
		alert(_("MainLang.leaveMessageIsSpecial"));
		return false;
	}
}
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<c:if test="${!project}">
	<fmt:message key="guestbook.title">			        	 	
		<fmt:param value="${preFix}"/>
	</fmt:message>
</c:if>
<c:if test="${project}">
${v3x:toHTML(v3x:getLimitLengthString(dispProjectName,20,"..."))}<fmt:message key="guestbook.title.message"/>
</c:if>
</title>
</head>
<body onclick="hiddenFasesDiv()" onLoad="focusArea('fastLeaveMessage');initLeaveMessageContent()" class="">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
<%---title---%>
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
			        <td width="45" class="page2-header-img"><div class="template"></div></td>		       
			        <td class="page2-header-bg">
			        	<c:if test="${!project}">
				        	<fmt:message key="guestbook.title"><fmt:param value="${preFix}"/></fmt:message>
	        			</c:if>
	        			<c:if test="${project}">
	        				<span title="${v3x:toHTML(dispProjectName)}">${v3x:toHTML(v3x:getLimitLengthString(dispProjectName,20,"..."))}</span><fmt:message key="guestbook.title.message"/>
	        			</c:if>
	        		</td>
				</tr>
			</table>
		</td>
	</tr>
	<%---title---%>
	<%---fastleave---%>
	<tr>
		<td align="center" height="120" class="page-list-border-LRD padding-T">
			<div class="fastLeaveMessageDiv" onkeydown="keyDownSubmit(event,'fastLeaveMessageAction')">
				<textarea id="fastLeaveMessage" class="fastLeaveMessage"></textarea>
				<div class="fastLeaveMessageBtnDiv">
					<img onClick="showFasesDiv()" id="modelFase" class="faseLeader" src="<c:url value="/common/images/face/face.png" />" /><span class="fastLeaveMessageRange"><fmt:message key="guestbook.leaveword.range"></fmt:message></span>
					<div class="fastLeaveMessageRange"><label for='sendMessage'><input id='sendMessage' checked type='checkbox' /><fmt:message key="guestbook.leaveword.sent.message"></fmt:message></label></div>
					<input class="fastLeaveMessageBtn" id="fastLeaveMessageAction" onClick="fastLeaveMessageAction()" type="button" value="<fmt:message key="guestbook.leaveword.send"></fmt:message>"/><span class="fastLeaveMessageBtnFast">(Ctrl+Enter)</span>
				</div>
				<div class="fasesDiv" id="fasesDiv">
                <img title="微笑" src="<c:url value="/common/images/face/5_1.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_1]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="呲牙" src="<c:url value="/common/images/face/5_2.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_2]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="坏笑" src="<c:url value="/common/images/face/5_3.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_3]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="偷笑" src="<c:url value="/common/images/face/5_4.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_4]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="可爱" src="<c:url value="/common/images/face/5_5.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_5]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="调皮" src="<c:url value="/common/images/face/5_6.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_6]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="爱心" src="<c:url value="/common/images/face/5_7.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_7]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="鼓掌" src="<c:url value="/common/images/face/5_8.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_8]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="疑问" src="<c:url value="/common/images/face/5_9.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_9]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="晕" src="<c:url value="/common/images/face/5_10.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_10]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="再见" src="<c:url value="/common/images/face/5_11.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_11]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="抓狂" src="<c:url value="/common/images/face/5_12.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_12]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="难过" src="<c:url value="/common/images/face/5_13.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_13]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="流汗" src="<c:url value="/common/images/face/5_14.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_14]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="流泪" src="<c:url value="/common/images/face/5_15.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_15]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="得意" src="<c:url value="/common/images/face/5_16.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_16]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="发怒" src="<c:url value="/common/images/face/5_17.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_17]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="嘘" src="<c:url value="/common/images/face/5_18.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_18]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="惊恐" src="<c:url value="/common/images/face/5_19.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_19]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="鸭梨" src="<c:url value="/common/images/face/5_20.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_20]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="赞" src="<c:url value="/common/images/face/5_21.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_21]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="奖状" src="<c:url value="/common/images/face/5_22.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_22]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="握手" src="<c:url value="/common/images/face/5_23.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_23]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="胜利" src="<c:url value="/common/images/face/5_24.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_24]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="祈祷" src="<c:url value="/common/images/face/5_25.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_25]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="强" src="<c:url value="/common/images/face/5_26.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_26]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="蛋糕" src="<c:url value="/common/images/face/5_27.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_27]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="礼物" src="<c:url value="/common/images/face/5_28.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_28]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="OK" src="<c:url value="/common/images/face/5_29.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_29]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="饭" src="<c:url value="/common/images/face/5_30.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_30]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="咖啡" src="<c:url value="/common/images/face/5_31.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_31]';document.getElementById('fastLeaveMessage').focus()" />
                <img title="玫瑰" src="<c:url value="/common/images/face/5_32.gif" />" onclick="document.getElementById('fastLeaveMessage').value+='[5_32]';document.getElementById('fastLeaveMessage').focus()" />
				</div>
			</div>
		</td>
	</tr>
	<%---fastleave---%>
	<tr>
		<td height="25" class="page-list-border-LRD">
			<div style="padding: 5px;">
				<span class="leaveMessageCount"><fmt:message key="guestbook.leaveword.count"><fmt:param value="${size}"></fmt:param></fmt:message></span>
				<c:if test="${isProjectManager || isSpaceManager}"><a href="javascript:banchDelete()"><fmt:message key="guestbook.leaveword.banch.manager"></fmt:message></a></c:if>
			</div>
		</td>
	</tr>
	<tr>
		<td class="page-list-border-LRD">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
						<table width="100%" cellpadding="0" cellspacing="0">
							<%---list---%>
							<tr>
								<td valign="top" class="padding5">
									<div class="leaveMessageListMain">
										<div class="leaveMessageListDiv">
										<c:forEach items="${leaveWordList}" var="team">
											<div class="leaveMessageRow" onMouseOver="javascript:this.style.backgroundColor = '#EEECEC';" onMouseOut="javascript:this.style.backgroundColor = '#ffffff';" onkeydown="keyDownSubmit(event,'sendReply')">
												<table cellpadding="0" cellspacing="0" width="100%">
													<tr>
														<td width="65" valign="top" class="potoDiv">
															<img class="radius" id="image1" src="${team.leaveWord.urlImage}" width="54" height="54" />
														</td>
														<td>
															<div class="leaveMessageContent" name="leaveMessageContent" >
															<table cellpadding="0" cellspacing="0" width="96%">
																<tr>
																	<td width="90" valign="top"  nowrap="nowrap">
																		<span class="memberName">${v3x:showMemberName(team.leaveWord.creatorId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.speak"></fmt:message>:</span></span>
																	</td>
																	<td>
																		${team.leaveWord.content}
																	</td>
																</tr>
															</table>
															</div>
															<div class="leaveMessageAction" id="${team.leaveWord.id}_reply">
																<span class="leaveMessageTime"><fmt:formatDate value="${team.leaveWord.createTime}" pattern="${datetimePattern}"/></span> - <a href="javascript:replyAction('${team.leaveWord.id}','${team.leaveWord.id}','${team.leaveWord.creatorId}')" class="replyAction"><fmt:message key="guestbook.leaveword.reply"></fmt:message></a><c:if test="${isProjectManager || isSpaceManager}"> - <a href="javascript:deleteReplyMessage('${team.leaveWord.id}')" class="replyDelete"><fmt:message key="guestbook.leaveword.delete"></fmt:message></a></c:if>
															</div>
															<%---sublist---%>
															<c:if test="${team.hasNodes == true}">
																<c:set value="${team.subLeaveWord}" var="subList"></c:set>
																<div class="replyMessgeDiv">
																	<c:forEach items="${subList}" var="sub">
																		<div class="subLeaveMessageRow">
																			<table cellpadding="0" cellspacing="0" width="100%">
																				<tr>
																					<td width="65" valign="top" class="potoDiv">
																						<img class="radius" id="image1" src="${sub.urlImage}" width="54" height="54" />
																					</td>
																					<td>
																						<div class="leaveMessageContent" name="subLeaveMessageContent">
																							<span class="memberName">${v3x:showMemberName(sub.creatorId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.reply"></fmt:message></span>${v3x:showMemberName(sub.replyerId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.speak"></fmt:message>:</span></span>
																							<div class="clearFloat border-padding">${sub.content}</div>
																						</div>
																						<div class="leaveMessageAction" id="${sub.id}_reply">
																							<span class="leaveMessageTime"><fmt:formatDate value="${sub.createTime}" pattern="${datetimePattern}"/></span> 
																							<%-- <a href="javascript:replyAction('${team.leaveWord.id}','${sub.id}','${sub.creatorId}')" class="replyAction"><fmt:message key="guestbook.leaveword.reply"></fmt:message></a><c:if test="${isProjectManager || isSpaceManager}"> - <a href="javascript:deleteReplyMessage('${sub.id}')" class="replyDelete"><fmt:message key="guestbook.leaveword.delete"></fmt:message></a></c:if>--%>
																						</div>
																					</td>
																				</tr>
																			</table>
																		</div>
																	</c:forEach>
																</div>
															</c:if>
															<%---sublist---%>
														</td>
													</tr>
												</table>
											</div>
										</c:forEach>
										</div>
									</div>
								</td>
							</tr>
							<%---list---%>
							<tr>
								<td class="table_footer" nowrap="nowrap" align="right">
								<form id="form1" name="form1" action="" method="post">
									<script type="text/javascript">
									<!--
										var pageFormMethod = "get";
										var pageQueryMap = new Properties();
										pageQueryMap.put('method', "moreLeaveWordNew");
										pageQueryMap.put('project', "${param.project}");
										pageQueryMap.put('phaseId', "${param.phaseId}");
										pageQueryMap.put('_spage', '');
										pageQueryMap.put('page', '${page}');
										pageQueryMap.put('count', "${size}");
										pageQueryMap.put('pageSize', "${pageSize}");
										pageQueryMap.put('departmentId', "${param.departmentId}");
										pageQueryMap.put('custom', "${param.custom}");
										pageQueryMap.put('fromModel', "${param.fromModel}");
									//-->
									</script>
					<div class="common_over_page align_right">
                        <fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
                            <fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize }" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, '${pageSize}')"></fmt:param>
                            <fmt:param>${pages}</fmt:param>
                            <fmt:param>${size}</fmt:param>
                            <fmt:param>
                            	<c:choose>
									<c:when test="${page == 1 && size > pageSize}">
										<a href="javascript:void(0);" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle='${v3xCommonI18N}'/>"><em class="pageFirst"></em></a>
										<a href="javascript:void(0);" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle='${v3xCommonI18N}'/>"><em class="pagePrev"></em></a>
										<a href="javascript:next(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle='${v3xCommonI18N}'/>"><em class="pageNext"></em></a>
										<a href="javascript:last(this, '${pages }')" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle='${v3xCommonI18N}'/>"><em class="pageLast"></em></a>
									</c:when>
									<c:when test="${page == pages && size > pageSize}">
										<a href="javascript:first(this)" class="common_over_page_btn"  title="<fmt:message key='taglib.list.table.page.first.label' bundle='${v3xCommonI18N}'/>"><em class=pageFirst></em></a>
										<a href="javascript:prev(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle='${v3xCommonI18N}'/>"><em class="pagePrev"></em></a>
										<a href="javascript:void(0);" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle='${v3xCommonI18N}'/>"><em class="pageNext"></em></a>
										<a href="javascript:void(0);" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle='${v3xCommonI18N}'/>"><em class="pageLast"></em></a>
									</c:when>
									<c:when test="${page != pages && page != 1 && size > pageSize}">
										<a href="javascript:first(this)" class="common_over_page_btn"  title="<fmt:message key='taglib.list.table.page.first.label' bundle='${v3xCommonI18N}'/>"><em class=pageFirst></em></a>
										<a href="javascript:prev(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle='${v3xCommonI18N}'/>"><em class="pagePrev"></em></a>
										<a href="javascript:next(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle='${v3xCommonI18N}'/>"><em class="pageNext"></em></a>
										<a href="javascript:last(this, '${pages }')" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle='${v3xCommonI18N}'/>"><em class="pageLast"></em></a>
									</c:when>
									<c:otherwise>
										<a href="javascript:void(0);" title="<fmt:message key='taglib.list.table.page.first.label' bundle='${v3xCommonI18N}'/>"><em class=pageFirst></em></a>
										<a href="javascript:void(0);" title="<fmt:message key='taglib.list.table.page.prev.label' bundle='${v3xCommonI18N}'/>"><em class="pagePrev"></em></a>
										<a href="javascript:void(0);" title="<fmt:message key='taglib.list.table.page.next.label' bundle='${v3xCommonI18N}'/>"><em class="pageNext"></em></a>
										<a href="javascript:void(0);" title="<fmt:message key='taglib.list.table.page.last.label' bundle='${v3xCommonI18N}'/>"><em class="pageLast"></em></a>
									</c:otherwise>
								</c:choose>
                             </fmt:param>
                            <fmt:param>
                                <input type="text" maxlength="10" class="pager-input-25-undrag" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
                            </fmt:param>
                        </fmt:message>
                         		<a id=grid_go class=common_over_page_btn href="javascript:pageGo(this);">go</a>&nbsp;&nbsp;&nbsp;&nbsp;
                        </div>
								</form>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	

</table>
<div id="memberMenuDIV" onMouseOver="divOver()" onMouseOut="divLeave()" style="width:82px; height:80px; padding-left:5px; border:#ccc 1px solid; background-color:#fff; display:none; position:absolute; line-height:20px;"></div>
</body>
</html>