<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<html:link renderURL="/project.do" var="basicURL" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/memberMenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<c:if test="${!project && !isSpaceManager && param.isManager=='true'}">
	alert(_("MainLang.no_acl_department_leavework_manage"));
</c:if>

	var genericURL = "${guestbookURL}";	

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
            temp = temp.replace(/\[5_1\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_1.gif' />&nbsp;");
            temp = temp.replace(/\[5_2\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_2.gif' />&nbsp;");
            temp = temp.replace(/\[5_3\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_3.gif' />&nbsp;");
            temp = temp.replace(/\[5_4\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_4.gif' />&nbsp;");
            temp = temp.replace(/\[5_5\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_5.gif' />&nbsp;");
            temp = temp.replace(/\[5_6\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_6.gif' />&nbsp;");
            temp = temp.replace(/\[5_7\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_7.gif' />&nbsp;");
            temp = temp.replace(/\[5_8\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_8.gif' />&nbsp;");
            temp = temp.replace(/\[5_9\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_9.gif' />&nbsp;");
            temp = temp.replace(/\[5_10\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_10.gif' />&nbsp;");
            temp = temp.replace(/\[5_11\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_11.gif' />&nbsp;");
            temp = temp.replace(/\[5_12\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_12.gif' />&nbsp;");
            temp = temp.replace(/\[5_13\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_13.gif' />&nbsp;");
            temp = temp.replace(/\[5_14\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_14.gif' />&nbsp;");
            temp = temp.replace(/\[5_15\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_15.gif' />&nbsp;");
            temp = temp.replace(/\[5_16\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_16.gif' />&nbsp;");
            temp = temp.replace(/\[5_17\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_17.gif' />&nbsp;");
            temp = temp.replace(/\[5_18\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_18.gif' />&nbsp;");
            temp = temp.replace(/\[5_19\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_19.gif' />&nbsp;");
            temp = temp.replace(/\[5_20\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_20.gif' />&nbsp;");
            temp = temp.replace(/\[5_21\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_21.gif' />&nbsp;");
            temp = temp.replace(/\[5_22\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_22.gif' />&nbsp;");
            temp = temp.replace(/\[5_23\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_23.gif' />&nbsp;");
            temp = temp.replace(/\[5_24\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_24.gif' />&nbsp;");
            temp = temp.replace(/\[5_25\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_25.gif' />&nbsp;");
            temp = temp.replace(/\[5_26\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_26.gif' />&nbsp;");
            temp = temp.replace(/\[5_27\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_27.gif' />&nbsp;");
            temp = temp.replace(/\[5_28\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_28.gif' />&nbsp;");
            temp = temp.replace(/\[5_29\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_29.gif' />&nbsp;");
            temp = temp.replace(/\[5_30\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_30.gif' />&nbsp;");
            temp = temp.replace(/\[5_31\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_31.gif' />&nbsp;");
            temp = temp.replace(/\[5_32\]/g,"<img src='${pageContext.request.contextPath}/common/images/face/5_32.gif' />&nbsp;");

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
            requestCaller.addParameter(7, "Long", "${project ? projectCompose.projectSummary.phaseId : 1}");
            requestCaller.addParameter(8, "Long", "${spaceIds}");
        }
        var resultStr = requestCaller.serviceRequest();
        if(resultStr == 'true'){
            window.location.href = window.location;
        }
    
}
	
	function selectAll(){
		var obj = document.getElementById('allSelect');
		var oArray = document.getElementsByName('selectMessage');
		if(obj.checked){
			for(var i = 0;i<oArray.length;i++){
				oArray[i].checked=true;
			}
		}else{
			for(var i = 0;i<oArray.length;i++){
				oArray[i].checked=false;
			}
		}
	}
	function deleteAllLeaveMessage(){
	    var oArray = document.getElementsByName('selectMessage');
		var isStr = '';
        for(var i = 0; i < oArray.length; i ++){
            if(!oArray[i].checked){continue;}
            if(i < oArray.length - 1){
                isStr += oArray[i].id + ',';
            }else{
                isStr += oArray[i].id;
            }
        }
        if(isStr == '' || isStr == ','){
            alert(v3x.getMessage('MainLang.guestbook_del_not_select'));
            return;
        }
       
        if(window.confirm(v3x.getMessage('MainLang.guestbook_del_confirm'))){
            var requestCaller = new XMLHttpRequestCaller(this, "ajaxGuestbookManager", "deleteAjaxBanchLeaveWords", false);
            requestCaller.addParameter(1, "String", isStr);
            var resultStr = requestCaller.serviceRequest();
            if(resultStr == 'true'){
                window.location.href = window.location;
            }
        }
   
	}
	function outBanchDelete(){
		window.location.replace("${guestbookURL}?method=moreLeaveWordNew&departmentId=${departmentId}&project=${project}&fromModel=${param.fromModel}&custom=${custom}&spaceId=${spaceIds}&phaseId=${phaseId}");
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
			array[i].style.width = (window.document.body.clientWidth-110)+"px";
		}
		var array2 = document.getElementsByName('subLeaveMessageContent');
		for(var i = 0; i<array2.length ;i++){
			array2[i].style.width = (window.document.body.clientWidth-110)+"px";
		}
	}
	function checkSendMessage(str){
		str = str.trim();
		if(str.length == 0){
		alert('文本内容不能为空');
		return false;
		}

		if(/^[^\\"'<>]*$/.test(str)){
		if(str.length > 1200){
		alert('字数不能超过1200');
		return false;
		}else{
		return true;
		}
		}else{
		alert('发送内容中含有非法字符');
		return false;
		}
		}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body onclick="hiddenFasesDiv()" onload="initLeaveMessageContent()" onkeydown="keyDownSubmit(event,'fastLeaveMessageAction')" class="border-left border-right">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
<%---title---%>
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
			        <td class="page2-header-bg">
			        	<c:if test="${!project}">
				        	<fmt:message key="guestbook.title">			        	 	
		        				<fmt:param value="${preFix}"/>
		        			</fmt:message>
	        			</c:if>
	        			<c:if test="${project}">
	        			  <span title="${v3x:toHTML(dispProjectName)}"> ${v3x:toHTML(v3x:getLimitLengthString(dispProjectName,20,"..."))}</span> <br/><fmt:message key="guestbook.title.message"/> <br/>
	        			</c:if>
	        		</td>
		        <td class="page2-header-line page2-header-link" align="right">
					&nbsp;
		        </td>
			</tr>
			</table>
		</td>
	</tr>
	<%---title---%>
	<%---fastleave---%>
	<tr>
		<td align="center" height="120">
			<div class="fastLeaveMessageDiv">
				<textarea disabled="disabled" id="fastLeaveMessage" class="fastLeaveMessage"></textarea>
				<div class="fastLeaveMessageBtnDiv">
					<img disabled="disabled" onclick="showFasesDiv()" id="modelFase" class="faseLeader" src="<c:url value="/common/images/face/face.png" />" /><span class="fastLeaveMessageRange"><fmt:message key="guestbook.leaveword.range"></fmt:message></span>
					<input disabled="disabled" class="fastLeaveMessageBtn" id="fastLeaveMessageAction" onclick="fastLeaveMessageAction()" type="button" value="<fmt:message key="guestbook.leaveword.send"></fmt:message>"/><span class="fastLeaveMessageBtnFast">(Ctrl+Enter)</span>
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
		<td class="padding5" height="21">
			<div class="leaveMessageListToolbar">
				<span class="leaveMessageCount"><fmt:message key="guestbook.leaveword.count"><fmt:param value="${size}"></fmt:param></fmt:message></span>
				<a href="javascript:outBanchDelete()"><fmt:message key="guestbook.leaveword.banch.manager.exit"></fmt:message></a>
			</div>
			<hr class="spreateLine"/>
		</td>
	</tr>
	<tr>
		<td class="padding5" height="21">
			<div class="leaveMessageListToolbar">
				<span class="leaveMessageCount"><label for="allSelect"><input id="allSelect" onclick="selectAll()" type="checkbox"/><fmt:message key="guestbook.leaveword.banch.select.all"></fmt:message></label></span>
				<a href="javascript:deleteAllLeaveMessage()"><fmt:message key="guestbook.leaveword.delete"></fmt:message></a>
			</div>
		</td>
	</tr>
	
	<tr>
		<td valign="top">
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
											<div class="leaveMessageRow" onmouseover="javascript:this.style.backgroundColor = '#EEECEC';" onmouseout="javascript:this.style.backgroundColor = '#ffffff';">
												<table cellpadding="0" cellspacing="0" width="100%">
													<tr>
														<td width="30" valign="top" class="potoDiv">
															<input id="${team.leaveWord.id}" name="selectMessage" type="checkbox"/>
														</td>
														<td>
															<div class="leaveMessageContent" name="leaveMessageContent">
																<table cellpadding="0" cellspacing="0" width="96%">
																	<tr>
																		<td width="90" valign="top">
																			<span class="memberName">${v3x:showMemberName(team.leaveWord.creatorId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.speak"></fmt:message>:</span></span>
																		</td>
																		<td>
																			${team.leaveWord.content}
																		</td>
																	</tr>
																</table>
															</div>
															<div class="leaveMessageAction" id="${team.leaveWord.id}_reply">
																<span class="leaveMessageTime"><fmt:formatDate value="${team.leaveWord.createTime}" pattern="${datetimePattern}"/></span>
															</div>
															<%---sublist---%>
															<c:if test="${team.hasNodes == true}">
																<c:set value="${team.subLeaveWord}" var="subList"></c:set>
																<div class="replyMessgeDiv">
																	<c:forEach items="${subList}" var="sub">
																		<div class="subLeaveMessageRow">
																			<table cellpadding="0" cellspacing="0" width="100%">
																				<tr>
																					<td>
																						<div class="leaveMessageContent" name="subLeaveMessageContent">
																							<span class="memberName">${v3x:showMemberName(sub.creatorId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.reply"></fmt:message></span>${v3x:showMemberName(sub.replyerId)}<span class="memberSay"><fmt:message key="guestbook.leaveword.speak"></fmt:message>:</span></span>
																							<div class="clearFloat border-padding">${sub.content}</div>
																						</div>
																						<div class="leaveMessageAction">
																							<span class="leaveMessageTime"><fmt:formatDate value="${sub.createTime}" pattern="${datetimePattern}"/></span>
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
										pageQueryMap.put('method', "banchDeleteList");
										pageQueryMap.put('_spage', '');
										pageQueryMap.put('page', '${page}');
										pageQueryMap.put('count', "${size}");
										pageQueryMap.put('pageSize', "${pageSize}");
										pageQueryMap.put('departmentId', "${param.departmentId}");
										pageQueryMap.put('custom', "${param.custom}");
										pageQueryMap.put('project', "${param.project}");
										pageQueryMap.put('phaseId', "${phaseId}");
									//-->
									</script>
									<fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
										<fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize}" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, 'pageSize')"></fmt:param>
										<fmt:param>${pages}</fmt:param>
										<fmt:param>${size}</fmt:param>
										<fmt:param>
											<c:choose>
												<c:when test="${page == 1 && size > pageSize}">
													<!a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></!a>
													<!a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></!a>
													<a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></a>
													<a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></a>
												</c:when>
												<c:when test="${page == pages && size > pageSize}">
													<a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></a>
													<a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></a>
													<!a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></!a>
													<!a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></!a>
												</c:when>
												<c:when test="${page != pages && page != 1 && size > pageSize}">
													<a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></a>
													<a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></a>
													<a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></a>
													<a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></a>
												</c:when>
												<c:otherwise>
													<!a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></!a>
													<!a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></!a>
													<!a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></!a>
													<!a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></!a>
												</c:otherwise>
											</c:choose>
										</fmt:param>
										<fmt:param>
											<input type="text" maxlength="10" class="pager-input-25-undrag" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
										</fmt:param>
									</fmt:message>
									<input type="button" value="go" class="go_undrag" onclick="pageGo(this)">
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