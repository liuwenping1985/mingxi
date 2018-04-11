<%--<%@ page import="com.seeyon.v3x.workflow.event.WorkflowEventListener"%> --%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html>
<html style="height:100%;">
<head>
<c:set var="path" value="${pageContext.request.contextPath}" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style type="text/css">
.margin_t_10 {
    margin-top : 10px;
}
.margin_t_5 {
    margin-top : 5px;
}
</style>

<script type="text/javascript" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<c:set value="${(bean.state==10 || bean.state==20) && replyFlag=='true' && param.eventId == '' }" var="replyShowFlag" />

<script type="text/javascript">
var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

var panels = new ArrayList();
//查看
panels.add(new Panel("showReply", '<fmt:message key="oper.view" />', "showBindOnresize();showPrecessArea(165)"));
//回执
<c:if test="${replyShowFlag }">
	panels.add(new Panel("reply", '<fmt:message key="mt.reply" />', "replyBindOnresize();showPrecessArea(320)"));
</c:if>

<c:if test="${bean.state > 20 && bean.recorderId==CurrentUser.id}">
//总结就不需要了
//panels.add(new Panel("summary", '<fmt:message key="mt.summary" />', "summary()"));
</c:if>

//点击总结的响应方法
function summary() {
	if(${param.fromdoc==1}) {
		parent.detailMainFrame.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id=${bean.id}'+'&fromdoc='+"${param.fromdoc}";
	} else {
		var parentObj = getA8Top().window.dialogArguments;
		if(parentObj) {
			urls='${mtSummaryTemplateURL}?method='+'edit'+'&fisearch=${fisearch}&id=${bean.id}';
			var windowWidth =  screen.width-155;
			var windowHeight =  screen.height-160;
			//mark by xuqiangwei Chrome37修改，这里应该被废弃了
			v3x.openWindow({
				url : urls,
				width : windowWidth,
				height : windowHeight,
				top : 130,
				left : 145,
				resizable: "yes"
			});
		} else {
			parent.parent.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id=${bean.id}';
		}
	}
}

//回执提交
function parentClose() {
	var replyLength = document.getElementById("feedback").value.length;
	if(replyLength > 1200) {
		alert(_("meetingLang.reply_too_long", 1200, replyLength));
		return false;
	}

    saveAttachment();
	mtForm.submit();
}

/**
 * @deprecated
 */
function openThisWindow() {
  //mark by xuqiangwei Chrome37修改，这里应该被废弃了
  	var sendResult = v3x.openWindow({
		url : "${mtMeetingURL}?method=openCalEventWindow"+"&id=${bean.id}",
	   	width : "600",
	   	height : "500",
	   	resizable : "false",
	   	scrollbars:"yes"
	});
	if(!sendResult) {
		return;
	} else {

		if(sendResult.indexOf('close')!=-1) {
	  		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtMeetingController", "deleteCalEvent",false);
	      	requestCaller.addParameter(1, "String", "${bean.id}");
		  	var ds1 = requestCaller.serviceRequest();
		 	if(ds1 != null && (typeof ds1 == 'string')) {
		   		alert(v3x.getMessage("meetingLang.meeting_calEvent_cancel"));
		  	}
		} else {
	 		alert(v3x.getMessage("meetingLang.meeting_calEvent_successful"));
		}
	}
}

//会议已有人员
<c:set value="${v3x:parseElements(excludeReplyExList, 'replyUserId', 'entityType')}" var="members"/>

var excludeElements_inviting = parseElements('${v3x:toHTML(members)}');
//不受职务级别控制
var isNeedCheckLevelScope_inviting = false;

//会议邀请
function invitePeople() {
	var state = '${bean.state}';
	if(state != 0 && state != 10 && state!=20) {
		alert(v3x.getMessage("meetingLang.meeting_no_invite2"));
		return;
	}
	selectPeopleFun_inviting();
}

/**
 * 发送请求邀请用户
 */
function _invitePersonAjax(id, conferee, curUser) {
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "meetingManager", "transInviteConferees", false);
        requestCaller.addParameter(1, "Long", id);
        requestCaller.addParameter(2, "String", conferee);
        ds = requestCaller.serviceRequest();
        if(ds==true || ds=='true') {
            //不刷新页面，js动态交互
            for(var i = 0; i < elements_invitingArr.length; i++){
                
                var ele = elements_invitingArr[i];
                
                var ele_id = ele.id;
                var ele_name = escapeStringToHTML(ele.name);
                
                //与会人员
                var appendHTML = '<div class="margin_t_5">' + 
                    '<span title="<fmt:message key="mt.mtReply.feedback_flag.0" />" class="ico16 unviewed_16" style="cursor: default;"></span>' +
                    '<span style="cursor: pointer;" onclick="showPeopleCard(\''+ele_id+'\')">'+ele_name+'</span>'
                '</div>';
                $("#confereesShowDiv").append($(appendHTML));
                
                //未回执人员
                $("#flag4").html($("#flag4").html() + ele_name + "<br/>");
            }
            
            //未回执字符串
            var f4_text = $("#f4Num").text();
            var regex = /\d+/;
            var numList = f4_text.match(regex);
            if(numList != null){
                var newNum = parseInt(numList[0], 10) + elements_invitingArr.length;
                f4_text = f4_text.replace(/\d+/, newNum);
                $("#f4Num").text(f4_text);
            }
            
            //添加排除数据
            excludeElements_inviting = excludeElements_inviting.concat(elements_invitingArr);
            setTimeout(function(){
                elements_inviting = [];//清空已选数据
            }, 500);
        } else if(ds=="null") {
        	alert(v3x.getMessage("meetingLang.meeting_has_delete"));
        	closeWindow();
            return;
        } else if(ds=="finish") {
        	alert(v3x.getMessage("meetingLang.meeting_no_invite2"));
        	closeWindow();
            return;
        } else {
        	alert(v3x.getMessage("meetingLang.meeting_no_invite1"));
            return;
        }
    } catch(e) {
        alert(v3x.getMessage("meetingLang.meeting_invite_failer"));
    }
}

var elements_invitingArr = "";//临时保存选择的用户和组件的elements_inviting值差不多

//会议邀请选人界面 jsFunction
var mtInvideParams = {};
function addPeople(e){
    
	// 判断会议是否存在   做防护
	var requestCaller = new XMLHttpRequestCaller(this, "meetingValidationManager", "checkMeeting", false);
	requestCaller.addParameter(1, "String", '${bean.id}');
	var ds = requestCaller.serviceRequest();
	if(ds == "null") {
		alert(v3x.getMessage("meetingLang.meeting_has_delete"));
		closeWindow();
		return;
	}

	var conferee = getIdsString(e);
	elements_invitingArr = e;
	var id = '${bean.id}';
	var curUser = "${CurrentUser.id}";
	
	mtInvideParams.id = id;
	mtInvideParams.conferee  = conferee;
	mtInvideParams.curUser = curUser;
	
	//会议邀请的人员冲突 不需要判断主持人和记录人，只需要判断与会人(conferee)
	if(!checkConfereesConflict(conferee, id)) {
		return false;
	}
	_invitePersonAjax(id, conferee, curUser);
}


function checkConfereesConflict(conferees, meetingId) {
	var beginDate = document.getElementById("beginDate").value;
	var endDate = document.getElementById("endDate").value;
	var beginDatetime = Date.parse(beginDate.replace(/\-/g,"/"));
	var endDatetime = Date.parse(endDate.replace(/\-/g,"/"));
	if(beginDate == "" || beginDate == "") {
	    return false;
	}
	var emceeId = "-1";
	var recorderId = "-1";
	var requestCaller = new XMLHttpRequestCaller(this,"meetingValidationManager","checkConfereesConflict",false);
	var i = 1;
	requestCaller.addParameter(i++,"String",meetingId);
	requestCaller.addParameter(i++,"Long",beginDatetime);
  	requestCaller.addParameter(i++,"Long",endDatetime);
  	requestCaller.addParameter(i++,"String",emceeId);
  	requestCaller.addParameter(i++,"String",recorderId);
  	requestCaller.addParameter(i++,"String",conferees);
  	document.getElementById("conferees").value = conferees;
  	var ds = requestCaller.serviceRequest();
  	if(ds=="true" || ds==true) {
  		var url = "meeting.do?method=openMeetingConfereesRepeatDialog&meetingId="+meetingId+"&beginDatetime="+beginDatetime+"&endDatetime="+endDatetime+"&emceeId="+emceeId+"&recorderId="+recorderId;
  		openMeetingDialog(url, "会议冲突提醒", 600, 560, function() {
  			_invitePersonAjax(meetingId, conferees, "${CurrentUser.id}");
  		});
  	} else {
  		return true;
  	}
}

//重写setTimeout,使其支持参数传递
var _st = window.setTimeout;

window.setTimeout = function(fRef, mDelay) {
	if(typeof fRef == 'function'){
	 	var argu = Array.prototype.slice.call(arguments,2);
	 	var f = (function(){ fRef.apply(null, argu); });
	 	return _st(f, mDelay);
	}
	return _st(fRef,mDelay);
}

//记录当前是哪个div的id
var divObjId;
function mouseOver(obj,divId,count){
	if(divObjId != null && divObjId != divId){
		document.getElementById(divObjId).style.display='none';
	}
	if(count !=0 && count != null){
		//var postionX = v3x.getEvent().clientX ;
		//var postionY = v3x.getEvent().clientY ;
		//var postionX = parseInt(obj.getBoundingClientRect().left);
		//var postionY =  parseInt(obj.getBoundingClientRect().top);

		//document.getElementById(divId).style.top = postionY - 10;
		//document.getElementById(divId).style.left = postionX;
	    //document.getElementById(divId).style.display='block';
	    //document.getElementById(divId).style.top = obj.offsetTop - 10 +"px";
		//document.getElementById(divId).style.left = postionX +"px";
	    document.getElementById(divId).style.display='block';
	    divObjId = divId;
    }
}

var flag = false;
function mouseOut(divId){
	if(!flag){
    	document.getElementById(divId).style.display = "none";
    }
}

function leaveDiv(obj){
	obj.style.display="none";
}

function hideDiv(obj){
	setTimeout(leaveDiv,100,obj);
	flag = false;
}

function showDiv(obj){
	obj.style.display="block";
	flag = true;
}

function mydocumentDelete(){
	if(!theToShowAttachments){
		return;
	}
	for(var i = 0; i < theToShowAttachments.size(); i++) {
		var att  = theToShowAttachments.get(i);
		if(att.type == 2){
			var delete_str="<img src='/seeyon/common/images/attachmentICON/delete.gif' onclick='deleteAttachment(\""+att.fileUrl+"\")' class='cursor-hand' title='删除' height='16' align='absmiddle'>";
			$("#attachmentDiv_"+att.fileUrl+" a").after(delete_str);
		}
	}
}

var add_height = 50
function loadUE() {
	if(v3x.isMSIE11 || v3x.isMSIE10){
		if(parent.parent.mtFrame){
			add_height = 50;
		}
		bindOnresize('scrollListDiv1',35,add_height);
	}else {
		bindOnresize('scrollListDiv1',20,add_height);
	}
	//<c:if test="${replyShowFlag }">
		//bindOnresize('scrollListDiv2',20,50);
	//</c:if>
}
function replyBindOnresize(){
	try{
		if(v3x.isMSIE11 || v3x.isMSIE10){
			bindOnresize('scrollListDiv2',35,add_height);
		}else {
			bindOnresize('scrollListDiv2',20,add_height);
		}
	}catch(e){}
}
function showBindOnresize(){
	try{
		if(v3x.isMSIE11 || v3x.isMSIE10){
			bindOnresize('scrollListDiv1',35,current_height);
		}else {
			bindOnresize('scrollListDiv1',20,current_height);
		}
	}catch(e){}
}
function showPeopleCard(memberId){
	var windowObj = parent.window.detailMainFrame;//上下结构打开的方式赋null，通过getA8Top()来获得窗口句柄
	if(typeof windowObj == 'undefined') {
	    windowObj = parent.parent.window.detailMainFrame;
    }
	showV3XMemberCardWithOutButton(memberId, windowObj);
}

function _onloadPage(){
    
    showPrecessArea(165);
    changeLocation('showReply');
    loadUE();
}

function closeWindow() {
	refreshSection();
	if(window.dialogArguments && window.dialogArguments.callback) {
    	window.dialogArguments.callback();
    } else if(parent.window.dialogArguments && parent.window.dialogArguments.callback) {
    	parent.window.dialogArguments.callback();
    } else if(parent.window.listFrame) {
    	parent.window.listFrame.location.reload();
    } else {
    	parent.window.getA8Top().close(); 
    }	
}

//如果是项目会议 就需要刷新 项目计划/会议/事件  栏目
function refreshSection() {
	try {
		var _win = getA8Top().opener.getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow;
		if (_win != undefined) {
  		if (_win.sectionHandler != undefined) {
  		  	//刷新 项目计划/会议/事件  栏目
             // _win.sectionHandler.reload("projectPlanAndMtAndEvent",true);
  			_win.sectionHandler.reload("meetingProjectSection",true);
          }
		}
	} catch(e){}
}

/**
 * 催办
 */
function reminders(meetingId,type){
	var parameter={};
	var url="meeting.do?method=openRemindersDialog&meetingid="+meetingId+"&type="+type;
	var loginAccount='${CurrentUser.loginAccount}';
	var remoteAddr='${CurrentUser.remoteAddr}';
	var buttons=[
	     {   	 
			 text : "<fmt:message key='common.button.ok.label'/>",
			 emphasize : true, //蓝色按钮
			 handler :  function(){
				 var result=getA8Top().winRA.getReturnValue(); // 页面上的信息
				 var obj=getA8Top().JSON.parse(result);
				 if(obj==null){
					 return;
				 }
				 if(obj.success==true){
					 //parameter.createUser = '${bean.createUser}'// 会议发起人
					 parameter.senderId='${CurrentUser.id}'; //当前用户ID(也是催办人ID)
					 parameter.meetingId='${bean.id}'; //会议的ID
					 parameter.memberIds=obj.memberIdArray; // 要催办的人员的数组
					 parameter.content=obj.content; // 催办的附言
					 parameter.sendPhoneMessage=obj.sendPhoneMessage; // 催办是否可以发送短信
					 //parameter.type=type;// 催办的类型
					 parameter.loginAccount=loginAccount;// 登录单位ID
					 parameter.remoteAddr=remoteAddr;// 登录IP
				 	 submitokAjax(parameter);
				 }
			 }
		 },
         {
			 text : "<fmt:message key='common.button.cancel.label'/>",
			 handler : function(){
				 getA8Top().winRA.close();
			 }
		 }
		]
	openRemindersDialog(url,"<fmt:message key='remindersPeople.label'/>","400","550",buttons,function(){});
}

function submitokAjax(parameter){
	var msg="";
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "meetingManager", "execMeetingReminders", false);
		requestCaller.addParameter(1,"String",parameter.senderId);
		requestCaller.addParameter(2,"String",parameter.meetingId);
		var mids="";
		for(var i=0;i<parameter.memberIds.length;i++){
			mids+=parameter.memberIds[i]+",";
		}
		mids=mids.substring(0,mids.length-1);
		requestCaller.addParameter(3,"String",mids);
		requestCaller.addParameter(4,"String",parameter.content);
		requestCaller.addParameter(5,"String",parameter.sendPhoneMessage);
		requestCaller.addParameter(6,"String",parameter.loginAccount);
		requestCaller.addParameter(7,"String",parameter.remoteAddr);
		var ds=requestCaller.serviceRequest();
		if(ds==""){
			msg="meetingLang.meeting_reminders_successful";
		}else{
			msg="meetingLang.meeting_reminders_failer";
		}
	}catch(e){
		msg="meetingLang.meeting_reminders_failer";
	}
	alert(v3x.getMessage(msg));
	getA8Top().winRA.close();
}

</script>

</head>
<body scroll="no" class="precss-scroll-bg border-right border-top" style="height:100%" onload="_onloadPage()">

<v3x:attachmentDefine attachments="${attachments}" />
<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel" />

<div oncontextmenu="return false" style="position:absolute; right:20px; top:100px; width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;" id="divPhrase" onMouseOver="" onMouseOut="">
	<IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" src="" align="middle" scrolling="no" marginheight="0" marginwidth="0">
	</IFRAME>
</div>
<input type="hidden" id="beginDate" name="beginDate" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.beginDate}" />"/>
<input type="hidden" id="endDate" name="endDate" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.endDate}" />"/>
<input type="hidden" id="conferees" name="conferees" value=""/>
<div id="signMinDiv" style="height: 100%" class="sign-min-bg">

	<div class="sign-min-label" onClick="changeLocation('showReply');showPrecessArea(165)" title="<fmt:message key="oper.view" />">
		<fmt:message key="oper.view" />
	</div>

	<div class="separatorDIV"></div>

	<%--xiangfan 修改条件  修复GOV-2748 --%>
	<c:if test="${replyShowFlag }">
		<div class="sign-min-label" onClick="changeLocation('reply');showPrecessArea(300)" title="<fmt:message key="mt.reply" />">
			<fmt:message key="mt.reply" /></div>
		<div class="separatorDIV"></div>
	</c:if>

	<!-- 总结不需要了  xiangfan 2012-4-01
	<c:if test="${bean.state > 20 && bean.recorderId==CurrentUser.id}">

		<div class="sign-min-label" onClick="summary()"
			title="<fmt:message key="mt.summary" />"><fmt:message
			key="mt.summary" /></div>

		<div class="separatorDIV"></div>
	</c:if>
	-->

</div><%-- signMinDiv结束 --%>

<c:if test="${bean.createUser!=bean.emceeId}">
	<c:set value="-100" var="emceeState" />
</c:if>
<c:if test="${bean.createUser!=bean.recorderId}">
	<c:set value="-100" var="recorderState" />
</c:if>

<table width="100%" id="signAreaTable" class="border-left" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="25" valign="top" nowrap="nowrap" class="sign-button-bg">
		<script type="text/javascript">showPanels();</script>
	</td>
</tr>

<tr id="showReplyTR" style="display: none" valign="top">
	<td>
		<div id="scrollListDiv1" style="width:100%;height:98%;overflow-y:auto; padding-left:10px" class="margin_t_10">
		 	<!-- 参会领导 -->
		 	<c:if test="${fn:contains(mtch.typeContent,'2')}">
			<%-- <c:if test="${!empty leaders }"> --%>
				<b><fmt:message key="mt.mtMeeting.leader" />:</b>
				<br>

				<%-- xiangfan 注释，修改为下面的方式，修复GOV-2974
				<c:forEach items="${leaders }" var="lname">
					${lname }<br>
				</c:forEach>
				--%>
				<c:forEach items="${replyLeaderExList}" var="rl">
				
				<c:if test="${ rl.replyUserId != bean.emceeId && rl.replyUserId != bean.recorderId }">
					<c:choose>
								<c:when test="${rl.feedbackFlag!=-100}">
									 <c:choose>
									 	<c:when test="${rl.feedbackFlag==0 }">
									 		<!-- 不参加 -->
									 		<span title="<fmt:message key='mt.mtReply.feedback_flag.0' />" class="ico16 unparticipate_16" style="cursor:default;"></span>
									 	</c:when>
									 	<c:when test="${rl.feedbackFlag==1 }">
									 		<!-- 参加 -->
                                                <span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
									 	</c:when>
									 	<c:when test="${rl.feedbackFlag==-1 }">
									 		<!-- 待定 -->
                                                <span title="<fmt:message key='mt.mtReply.feedback_flag.-1' />" class="ico16 determined_16" style="cursor:default;"></span>
									 	</c:when>
									 </c:choose>
								</c:when>
								<c:otherwise>
										<c:choose>
											<c:when test="${rl.lookState==0}">
												 <!-- 未查看 -->
												 <span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
	                                             
											</c:when>
											<c:otherwise>
												<!-- 未回执 -->
												<span title="<fmt:message key='mt.mtReply.feedback_flag.-100' />" class="ico16 viewed_16" style="cursor:default;"></span>
											</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						<span onclick="showPeopleCard('${rl.replyUserId}')" style="cursor:pointer;">
		    			${ctp:toHTML(rl.replyUserName)}
		    			<c:if test="${rl.mtReply.userAccountName!=null }">
							<c:out value="(${ctp:toHTML(rl.mtReply.userAccountName)})" />
						</c:if>
						</span>
						<c:if test="${rl.feedbackFlag != -100 && rl.agentId != null}">
							(<fmt:message key="mt.agent.label2"><fmt:param>${ctp:toHTML(rl.agentName)}</fmt:param></fmt:message>)
						</c:if>
						<br>
					</c:if>
					<c:choose>
						<c:when
								test="${rl.replyUserId == bean.emceeId && rl.replyUserId == bean.recorderId}">
								<c:set value="${rl.feedbackFlag}" var="emceeState" />
								<c:set value="${rl.feedbackFlag}" var="recorderState" />
							</c:when>

							<c:when test="${rl.replyUserId == bean.emceeId}">
								<c:set value="${rl.feedbackFlag}" var="emceeState" />
							</c:when>
							<c:when test="${rl.replyUserId == bean.recorderId}">
								<c:set value="${rl.feedbackFlag}" var="recorderState" />
							</c:when>
					</c:choose>
			 	</c:forEach>
			<%-- </c:if> --%>
			</c:if>
			<!-- 嘉宾 -->
			<c:if test="${fn:contains(mtch.typeContent,'3')}">
			<%-- <c:if test="${content_attender == 'true' }"> --%>
				<b><fmt:message key="admin.meetingtype.attender.label" />:</b>
				<br>
				<div style="word-break:break-all;">${v3x:toHTML(bean.attender)}</div><br>
			<%-- </c:if> --%>
			</c:if>
			<!-- 参与人员 -->
			<div id="confereesShowDiv">
				<div>
					<b class="margin_r_5"><fmt:message key="mt.mtMeeting.join" />:</b>
					<!-- 邀请 -->
					<c:if test="${showInviting}">
						<b><span name="inviting" onclick="invitePeople();"><a href="#"><fmt:message key="invitePeople.label"/></a></span></b>
						<v3x:selectPeople id="inviting" departmentId="${CurrentUser.departmentId}" panels="Department,Team,Post,Outworker" selectType="Member" minSize="1" jsFunction="addPeople(elements)"/>
					</c:if>
				</div>
                <c:forEach items="${replyExList}" var="rl">
					<div class="margin_t_5">
						<c:if test="${ rl.replyUserId != bean.emceeId && rl.replyUserId != bean.recorderId }">
							<c:choose>
								<c:when test="${rl.feedbackFlag!=-100}">
									 <c:choose>
									 	<c:when test="${rl.feedbackFlag==0 }">
									 		<!-- 不参加 -->
									 		<span title="<fmt:message key='mt.mtReply.feedback_flag.0' />" class="ico16 unparticipate_16" style="cursor:default;"></span>
									 	</c:when>
									 	<c:otherwise>
                                            <c:if test="${rl.feedbackFlag eq '1'}">
                                            	<!-- 参加 -->
                                                <span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
                                            </c:if>
                                            <c:if test="${rl.feedbackFlag eq '-1'}">
                                            	<!-- 待定 -->
                                                <span title="<fmt:message key='mt.mtReply.feedback_flag.-1' />" class="ico16 determined_16" style="cursor:default;"></span>
                                            </c:if>
									 	</c:otherwise>
									 </c:choose>
								</c:when>
								<c:otherwise>
										<c:choose>
											<c:when test="${rl.lookState==1}">
												 <!-- 未回执 -->
	                                             <span title="<fmt:message key='mt.mtReply.feedback_flag.-100' />" class="ico16 viewed_16" style="cursor:default;"></span>
											</c:when>
											<c:otherwise>
												<!-- 未查看 -->
												<span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
											</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>

		    				<span onclick="showPeopleCard('${rl.replyUserId}')" style="cursor:pointer;">${v3x:toHTML(rl.replyUserName)}
			    			<c:if test="${rl.mtReply.userAccountName!=null }">
								<c:out value="(${rl.mtReply.userAccountName})" />
							</c:if>
							</span>
							<c:if test="${rl.feedbackFlag != -100 && rl.agentId != null}">
								(<fmt:message key="mt.agent.label2"><fmt:param>${rl.agentName}</fmt:param></fmt:message>)
							</c:if>
						</c:if>
						<c:choose>
							<c:when test="${rl.replyUserId == bean.emceeId && rl.replyUserId == bean.recorderId}">
								<c:set value="${rl.feedbackFlag}" var="emceeState" />
								<c:set value="${rl.feedbackFlag}" var="recorderState" />
							</c:when>

							<c:when test="${rl.replyUserId == bean.emceeId}">
								<c:set value="${rl.feedbackFlag}" var="emceeState" />
							</c:when>
							<c:when test="${rl.replyUserId == bean.recorderId}">
								<c:set value="${rl.feedbackFlag}" var="recorderState" />
							</c:when>
						</c:choose>
					</div>
				</c:forEach>
			</div>

			<div class="margin_t_10">
				<!-- 参加 -->
				<div id="f1" class="margin_r_5" onmouseover="mouseOver(this,'flag1','${itemCount[0]}')" onmouseout="mouseOut('flag1');">
					<fmt:message key="mt.mtReply.feedback_flag.1" />
					${itemCount[0]}<fmt:message key="mt.people" />
				</div>
                <div onMouseOut="hideDiv(this)" onmouseover="showDiv(this)" style="position:relative;display:none; width:85px; height:110px; z-index:3; background-color:#ffffff;border:1px solid #000000;overflow:auto;filter:progid:DXImageTransform.Microsoft.Shadow(color=#aaaa99,direction=155,strength=6)" id="flag1">
	                <c:forEach items="${feedbackUsers[0]}" var="f">
	                    <c:out value="${f}"/><br>
	                </c:forEach>
                </div>

				<!-- 不参加 -->
				<div id="f2" class="margin_t_5 margin_r_5" onmouseover="mouseOver(this,'flag2','${itemCount[1]}')" onmouseout="mouseOut('flag2');">
					<label style="color:#ff0000">
						<fmt:message key="mt.mtReply.feedback_flag.0" />
						${itemCount[1]}<fmt:message key="mt.people" />
					</label>
				</div>
                <div onMouseOut="hideDiv(this)"  onmouseover="showDiv(this)" style="position:relative;display:none; width:85px; height:110px; z-index:3; background-color:#ffffff;border:1px solid #000000;overflow:auto;filter:progid:DXImageTransform.Microsoft.Shadow(color=#aaaa99,direction=155,strength=6)" id="flag2">
                    <c:forEach items="${feedbackUsers[1]}" var="f">
                        <c:out value="${f}"/><br>
                    </c:forEach>
                </div>

				<!-- 待定 -->
				<div id="f3" class="margin_t_5 margin_r_5" onmouseover="mouseOver(this,'flag3','${itemCount[2]}')" onmouseout="mouseOut('flag3');">
					<fmt:message key="mt.mtReply.feedback_flag.-1" />
					${itemCount[2]}<fmt:message key="mt.people" />
					<c:if test="${itemCount[2]!=0 && bean.createUser eq CurrentUser.id && ((bean.state eq 10 && bean.roomState ne 0) || bean.state eq 20)}">
						<b>
							<span name="reminders2" onclick="reminders('${bean.id}','6');">
								<a href="#"><fmt:message key="remindersPeople.label"/></a>
							</span>
						</b>
					</c:if>
				</div>
                <div onMouseOut="hideDiv(this)"  onmouseover="showDiv(this)" style="position:relative;display:none; width:85px; height:110px; z-index:3; background-color:#ffffff;border:1px solid #000000;overflow:auto;filter:progid:DXImageTransform.Microsoft.Shadow(color=#aaaa99,direction=155,strength=6)" id="flag3">
                    <c:forEach items="${feedbackUsers[2]}" var="f">
                        <c:out value="${f}"/><br>
                    </c:forEach>
                </div>

				<!-- 未回执 -->
				<div id="f4" class="margin_t_5 margin_r_5" onmouseover="mouseOver(this,'flag4','${itemCount[3]}')" onmouseout="mouseOut('flag4');">
					<span id="f4Num">
						<fmt:message key="mt.mtReply.feedback_flag.-100" />
						${itemCount[3]}<fmt:message key="mt.people" />
					</span>
					<c:if test="${itemCount[3]!=0 && bean.createUser eq CurrentUser.id && ((bean.state eq 10 && bean.roomState ne 0) || bean.state eq 20)}">
						<b>
							<span name="reminders2" onclick="reminders('${bean.id}','7');">
								<a href="#"><fmt:message key="remindersPeople.label"/></a>
							</span>
						</b>
					</c:if>
				</div>
                <div onMouseOut="hideDiv(this)" onmouseover="showDiv(this)" style="position:relative;display:none; width:85px; height:110px; z-index:3; background-color:#ffffff;border:1px solid #000000;overflow:auto;filter:progid:DXImageTransform.Microsoft.Shadow(color=#aaaa99,direction=155,strength=6)" id="flag4">
                    <c:forEach items="${feedbackUsers[3]}" var="f">
                        <c:out value="${f}"/><br>
                    </c:forEach>
                </div>
			</div>

			<!-- 主持人 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.mtMeeting.emceeId" />:</b>
					<div class="margin_t_5">
					<c:if test="${bean.emceeId != bean.createUser}">
						<c:choose>
							<c:when test="${emceeAffair.state=='9'}">
								<!-- 参加  -->
								 <span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16"></span>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${emceeAffair.subState=='31' }">
										<!-- 参加 -->
		                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
		                          	</c:when>
		                          	<c:when test="${emceeAffair.subState=='32' }">
		                          		<!-- 不参加  -->
		                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.0' />" class="ico16 unparticipate_16" style="cursor:default;"></span>
		                          	</c:when>
		                          	<c:when test="${emceeAffair.subState=='33' }">
		                          		<!-- 待定 -->
		                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.-1' />" class="ico16 determined_16" style="cursor:default;"></span>
		                          	</c:when>
		                          	<c:when test="${emceeAffair.subState=='12' }">
		                          		<!-- 已查看 -->
		                          		<span title="<fmt:message key='mt.mtReply.viewed' />" class="ico16 viewed_16" style="cursor:default;"></span>
		                          	</c:when>
		                          	<c:otherwise>
		                          		<!-- 未查看 -->
		                          		<span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
		                          	</c:otherwise>
		                        </c:choose>
							</c:otherwise>
						</c:choose>
					</c:if>
					<c:if test="${bean.emceeId == bean.createUser}">
						<!-- 参加 -->
						<span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
					</c:if>
					<span style="cursor:pointer;"  onclick="showPeopleCard('${bean.emceeId}')">${ctp:toHTML(v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext))}</span>
					<!--
					<c:if test="${bean.createUser!=bean.emceeId}">
						(<fmt:message key="mt.mtReply.feedback_flag.${emceeState}" />)
					</c:if>
					 -->
					 </div>
				</div>
			</div>

			<!-- 记录人 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.mtMeeting.recorderId" />:</b>
					<c:if test="${bean.recorderId!=null && bean.recorderId!='' && bean.recorderId!=-1 && bean.recorderId!=0}">
						<div id="recorderDiv" class="margin_t_5">
						<c:if test="${bean.recorderId != bean.createUser}">
							<c:choose>
								<c:when test="${recorderAffair.state==9}">
									 <!-- 参加 -->
									 <span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16"></span>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${recorderAffair.subState=='31' }">
											<!-- 参加 -->
			                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
			                          	</c:when>
			                          	<c:when test="${recorderAffair.subState=='32' }">
			                          		<!-- 不参加 -->
			                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.0' />" class="ico16 unparticipate_16" style="cursor:default;"></span>
			                          	</c:when>
			                          	<c:when test="${recorderAffair.subState=='33' }">
			                          		<!-- 待定 -->
			                          		<span title="<fmt:message key='mt.mtReply.feedback_flag.-1' />" class="ico16 determined_16" style="cursor:default;"></span>
			                          	</c:when>
			                          	<c:when test="${recorderAffair.subState=='12' }">
			                          		<!-- 已查看 -->
			                          		<span title="<fmt:message key='mt.mtReply.viewed' />" class="ico16 viewed_16" style="cursor:default;"></span>
			                          	</c:when>
			                          	<c:otherwise>
			                          		<!-- 未查看 -->
			                          		<span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
			                          	</c:otherwise>
			                        </c:choose>
								</c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${bean.recorderId == bean.createUser}">
							<!-- 参加 -->
							<span title="<fmt:message key='mt.mtReply.feedback_flag.1' />" class="ico16 participate_16" style="cursor:default;"></span>
						</c:if>
						<span  onclick="showPeopleCard('${bean.recorderId}')" style="cursor:pointer;">${ctp:toHTML(v3x:showOrgEntitiesOfIds(bean.recorderId, 'Member', pageContext))}</span>
						<!--
						<c:if test="${bean.createUser!=bean.recorderId && bean.recorderId!=-1}">
							(<fmt:message key="mt.mtReply.feedback_flag.${recorderState}" />)
						</c:if>
						 -->
						</div>
					</c:if>
				</div>
			</div>
			<div class="margin_t_10">
			<div>
					<b><fmt:message key="mt.meeting.impart" />:</b>
					<!--state=0:会议保存待发  roomstate=1: 会议室审核通过-->
					<c:choose>
						<c:when test="${bean.state != 0 && bean.roomState == 1}">
							<c:forEach items="${affairImparts}" var="imparts">
								<div class="margin_t_5">
									<c:choose>
										<c:when test="${imparts.lookState==1}">
											<!-- 查看 -->
				                       		<span title="<fmt:message key='mt.mtReply.view' />" class="ico16 viewed_16" style="cursor:default;"></span>
				                       	</c:when>
				                       	<c:when test="${imparts.lookState==0}">
				                       		<!-- 未查看 -->
				                       		<span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
				                       	</c:when>
				                       	<c:otherwise>
				                       		<!-- 已处理 -->
				                       		<span title="<fmt:message key='mt.mtReply.dealed' />" class="ico16 participate_16" style="cursor:default;"></span>
				                       	</c:otherwise>
									</c:choose>
									<span style="cursor:pointer;"  onclick="showPeopleCard('${imparts.userId}')">${ctp:toHTML(v3x:showOrgEntitiesOfIds(imparts.userId, 'Member', pageContext))}</span>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<c:forEach items="${waitSendImparts}" var="imparts">
								<div class="margin_t_5">
									<!-- 未查看 -->
				                    <span title="<fmt:message key='mt.mtReply.lookState' />" class="ico16 unviewed_16" style="cursor:default;"></span>
									<span style="cursor:pointer;"  onclick="showPeopleCard('${imparts}')">${ctp:toHTML(v3x:showOrgEntitiesOfIds(imparts, 'Member', pageContext))}</span>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>

				</div>
			</div>

			<!-- 与会设备 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.resource" />:</b>${v3x:toHTML(bean.resourcesName)}
				</div>
			</div>

			<!-- 所属项目 -->
			<div class="margin_t_10 <c:if test ="${!v3x:hasPlugin('project')}">hidden</c:if>">
				<div>
					<b><fmt:message key="mt.mtMeeting.projectId" />:</b>${v3x:toHTML(projectName)}
				</div>
			</div>
			<div class="margin_t_10">
				<div>
			 		<b><span style="white-space:nowrap;"><fmt:message key="mt.mtMeeting.meetingCategory" />:</span></b>${v3x:toHTML(meetingTypeName)}
			 	</div>
			</div>

			<c:if test="${fn:contains(mtch.typeContent,'4')}">
			<%-- <c:if test="${content_tel == 'true' }"> --%>
				<b><fmt:message key="mt.mtMeeting.tel" />:</b>

				<c:if test="${fn:length(bean.tel) > 11}">
					<br>
				</c:if>
				<div style="word-break:break-all;">${v3x:toHTML(bean.tel) }</div><br>
				<br>
			<%-- </c:if> --%>
			</c:if>

			<c:if test="${fn:contains(mtch.typeContent,'5')}">
			<%-- <c:if test="${content_notice == 'true' }"> --%>
				<a href="javascript:openNoticeDialog(true);">
					<input type="hidden" id="notice" name="notice" value="${bean.notice }" />
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.note" /></b></font>
				</a>
				<br>
				<br>
			<%-- </c:if> --%>
			</c:if>

			<c:if test="${fn:contains(mtch.typeContent,'6')}">
			<%-- <c:if test="${content_plan == 'true' }"> --%>
				<a href="javascript:openPlanDialog(true);">
					<input type="hidden" id="plan" name="plan" value="${bean.plan }" />
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.plan" /></b></font>
				</a>
				<br>
			<%-- </c:if> --%>
			</c:if>

		</div>
	</td>
</tr>

<tr id="replyTR" style="display: none" valign="top">
	<td>
    <div id="scrollListDiv2" style="width:100%; overflow-y: auto; padding-left:10px" class="margin_t_10">
    	<c:if test="${replyShowFlag }">
			<form name="mtForm" method="post" action="${mtMeetingURL}" onsubmit="return false">
				<input type="hidden" name="method" value="mydetail" />
				<input type="hidden" name="id" value="${bean.id}" />
				<input type="hidden" name="fagent" value="${fagent}" />
				<input type="hidden" name="replyId" value="${myReply.id}" />
				<input type="hidden" name="proxy" value="${proxy}" />
				<input type="hidden" name="proxyId" value="${proxyId}" />
				<input type="hidden" name="isImpart" value="${isImpart }" />


				<table width="60%" cellpadding="0" cellspacing="0">
					<tr>
						<td><b><fmt:message key="mt.mtReply" />:</b></td>
					</tr>
					<c:if test="${isImpart }">
						<input type="hidden" name="feedbackFlag" value="3" />
					</c:if>
					<c:if test="${!isImpart }">
						<tr class="margin_t_5">
							<td>
								<label for="radio1">
									<input type="radio" id="radio1" name="feedbackFlag" value="1" <c:if test="${myReply==null||myReply.feedbackFlag==1||myReply.feedbackFlag==-100}">checked</c:if> />
									<fmt:message key="mt.mtReply.feedback_flag.1" />
								</label>

								<label for="radio2">
									<input type="radio" id="radio2" name="feedbackFlag" value="0" <c:if test="${myReply.feedbackFlag==0}">checked</c:if> />
									<fmt:message key="mt.mtReply.feedback_flag.0" />
								</label>

								<label for="radio3">
									<input type="radio" id="radio3" name="feedbackFlag" value="-1" <c:if test="${myReply.feedbackFlag==-1}">checked</c:if> />
									<fmt:message key="mt.mtReply.feedback_flag.-1" />
								</label>
								<br>
							</td>
						</tr>
					</c:if>
					<tr class="margin_t_5">
						<td valign="top">
							<textarea style="width:265px;height:180px;" id="feedback" name="feedback" rows="5" cols="80" style="word-break:break-all;word-wrap:break-word;">${myReply.feedback}</textarea>

							<br />

							<div style="color: green">
				              	<fmt:message key="guestbook.content.help" bundle="${v3xMainI18N}">
									<fmt:param value="1200" />
								</fmt:message>
							</div>
						</td>
					</tr>

					<!-- 可以插入附件 -->
					<tr>
						<td>
							<!-- <img id="showimg" src="/seeyon/common/images/attachment.gif"> -->
							<span class="ico16 affix_16  margin_r_5"></span>
							<span class="like-a font-12px" onclick="insertAttachment()" style="margin-left:-3px;"><fmt:message key="common.toolbar.insertAttachment.label" bundle="${v3xCommonI18N}" /></span>&nbsp;
							<span class="ico16 associated_document_16  margin_r_5"></span>
							<span class="like-a font-12px" id="myDocumentSpan" onclick="quoteDocument()" style="margin-left:-3px;"><fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' /></span>
							<!-- (<span id="attachmentNumberDiv">0</span>)  -->
							<div id="attachmentTR" style="display: none;width: 270px; ">
								<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />
								(<span id="attachmentNumberDiv">0</span>):
								<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
							</div>
							<div id="attachment2TR" style="display: none;width: 270px; ">
								<fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" />
								(<span class="font-12px" id="attachment2NumberDiv"></span>):
								<div id="attachment2Area" style="overflow: auto;">
									<script type="text/javascript">
											showAttachment('${myReply.id}',2,'attachment2TR','attachment2NumberDiv');
											mydocumentDelete();
									</script>
								</div>
							</div>
						</td>
					</tr>

					<tr>
						<td>
							<div align="right">
								<input onclick="parentClose();" type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize"/>
							</div>
						</td>
					</tr>
				</table>
			</form>
		</c:if>
        </div>
	</td>
</tr>

</table>

<script type="text/javascript">
	<c:choose>
	<c:when test="${replyShowFlag }">
		changeLocation('reply');
		showPrecessArea(320);
		replyBindOnresize();
	</c:when>
	<c:otherwise>
		changeLocation('showReply');
		showPrecessArea(165);
	</c:otherwise>
	</c:choose>
</script>

</body>
</html>
