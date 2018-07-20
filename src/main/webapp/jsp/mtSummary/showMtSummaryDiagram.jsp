<%--<%@ page import="com.seeyon.v3x.workflow.event.WorkflowEventListener"%> --%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../meeting/include/taglib.jsp"%>
<%@ include file="../meeting/include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="v3xMtRoom"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"
	src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"
	src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

var panels = new ArrayList();

panels.add(new Panel("showReply", '<fmt:message key="oper.view" />', "showPrecessArea(165)"));


//点击总结的响应方法
function summary() {
	if(${param.fromdoc==1}) {
		parent.detailMainFrame.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id=${bean.id}'+'&fromdoc='+"${param.fromdoc}";
	} else {
		var parentObj = getA8Top().window.dialogArguments;
		if(parentObj){
			urls='${mtSummaryTemplateURL}?method='+'edit'+'&fisearch=${fisearch}&id=${bean.id}';
			var windowWidth =  screen.width-155;
			var windowHeight =  screen.height-160;
			v3x.openWindow({
				url : urls,
				width : windowWidth,
				height : windowHeight,
				top : 130,
				left : 145,
				resizable: "yes"
			});
		}else{
			parent.parent.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id=${bean.id}';
		}
	}
}

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
//var excludeElements_inviting = parseElements('${members}');

//会议邀请
function invitePeople(){
	var state = '${bean.state}';
	if(state != 0 && state != 10){
		alert(v3x.getMessage("meetingLang.meeting_meetingAlreadyOver"));
		return;
	}
	selectPeopleFun_inviting();
}

//会议邀请选人界面 jsFunction
function addPeople(e){
	// 判断会议是否存在   做防护
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtMeetingController", "isMeetingExist", false);
	requestCaller.addParameter(1, "Long", '${bean.id}');
	var ds = requestCaller.serviceRequest();
	if(ds=='false'){
		alert(v3x.getMessage("meetingLang.meeting_has_delete"));
		return;
	}
	
	var conferee = getIdsString(e);
	var id = '${bean.id}';
	var curUser = "${sessionScope['com.seeyon.current_user'].id}";
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtMeetingController", "checkInvite", false);
		requestCaller.addParameter(1, "Long", id);
		requestCaller.addParameter(2, "String", conferee);
		requestCaller.addParameter(3, "Long", curUser);
		requestCaller.serviceRequest();
	}catch(e){
		alert(v3x.getMessage("meetingLang.meeting_invite_failer"));
	}
	location.href = location.href;
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
		var postionX = v3x.getEvent().clientX ;
		var postionY = v3x.getEvent().clientY ; 
		
	   	
		document.getElementById(divId).style.top = postionY - 10;
		document.getElementById(divId).style.left = postionX;
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
	setTimeout(leaveDiv,1000,obj);
	flag = false;
}
function showDiv(obj){
	obj.style.display="block";
	flag = true;
}
//打开注意事项窗口
function openNotice(){
	var winWidth = 500;
	var winHeight = 350;
	var fmt_message = " ";
	var url = "mtAppMeetingController.do?method=openNotice&type=view&readonly=readonly&id=${meetId}&mtType=meeting&ndate="+new Date();//xiangfan 进行了修改，主要是修复，会议的注意事项和议程内容中有回车符而导致的js错误
	if(${param.readonly eq 'readonly'}==false){
        fmt_message = "<fmt:message key='admin.label.zysx1'/>";
    }else{
        fmt_message = "<fmt:message key='admin.label.zysx'/>";
    }
	getA8Top().win123 = getA8Top().v3x.openDialog({
        title:fmt_message,
        transParams:{'parentWin':window},
        url:url,
        width:winWidth,
        height:winHeight
    });
}

//打开注意议程窗口
function openPlan(){
	var winWidth = 500;
	var winHeight = 350;
	var url = "mtAppMeetingController.do?method=openPlan&type=view&readonly=readonly&id=${meetId}&mtType=meeting&ndate="+new Date();//xiangfan 进行了修改，主要是修复，会议的注意事项和议程内容中有回车符而导致的js错误
	var fmt_message = "";
    if(${param.readonly eq 'readonly'}==false){
        fmt_message = "<fmt:message key='admin.label.yc1'/>";
    }else{
        fmt_message = "<fmt:message key='admin.label.yc'/>";
    }
    getA8Top().win123 = getA8Top().v3x.openDialog({
        title:fmt_message,
        transParams:{'parentWin':window},
        url:url,
        width:winWidth,
        height:winHeight
    });
}

function loadUE() {
	bindOnresize('scrollListDiv',20,50);
}
-->
</script>

</head>
<body scroll="no" class="precss-scroll-bg border-right border-top" onload="loadUE()">

<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel" />

<div oncontextmenu="return false" style="position:absolute; right:20px; top:100px; width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;" id="divPhrase" onMouseOver="" onMouseOut="">
	<IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" src="" align="middle" scrolling="no" marginheight="0" marginwidth="0"></IFRAME>
</div>

<div id="signMinDiv" style="height: 100%" class="sign-min-bg">

<div class="sign-min-label" onClick="changeLocation('showReply');showPrecessArea(165)" title="<fmt:message key="oper.view" />"><fmt:message key="oper.view" /></div>
<div class="separatorDIV"></div>

<c:if test="${(myReply.state==1) && (bean.createUser!=sessionScope['com.seeyon.current_user'].id ||(bean.createUser==sessionScope['com.seeyon.current_user'].id && proxy=='1')||replyFlag=='true') && param.eventId == ''}">
	<div class="sign-min-label" onClick="changeLocation('reply');showPrecessArea(300)" title="<fmt:message key="mt.summary.audit.lable" />"><fmt:message key="mt.summary.audit.lable" /></div>
	<div class="separatorDIV"></div>
</c:if> 

<c:if test="${bean.state > 20 && bean.mtCreateUser==sessionScope['com.seeyon.current_user'].id}">
	<div class="sign-min-label" onClick="summary()" title="<fmt:message key="mt.summary" />"><fmt:message key="mt.summary" /></div>
	<div class="separatorDIV"></div>
</c:if>

</div>

<table width="100%" id="signAreaTable" class="border-left" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
	<td height="25" valign="top" nowrap="nowrap" class="sign-button-bg">
	<script type="text/javascript">showPanels();</script></td>
</tr>

<tr id="showReplyTR" style="display: none" valign="top">
	<td>	
		<div id="scrollListDiv" style="width:100%;height:98%; padding-left:10px" class="margin_t_10">
	
			<!-- 参会领导 -->
			<c:if test="${!empty leaders }">
				<b><fmt:message key="mt.mtMeeting.leader" />:</b>
				<br>
				
				<c:forEach items="${leaders }" var="lname">
					${lname }<br>
				</c:forEach>
				<br>
			</c:if>
	
			<!-- 嘉宾 -->
			<c:if test="${content_attender == 'true' }">
				<b><fmt:message key="mt.mtMeeting.attender.simplelabel" />:</b>
				<br>
					${meet.attender}
				<br>
			</c:if>
	
			<!-- 参与人员 -->
			<div>
				<div>
					<b><fmt:message key="mt.mtMeeting.join.actual" />:</b>
				</div>
				<c:forEach items="${replyExList}" var="rl">
					<c:if test="${ rl.replyUserId != bean.createUser }">
						<div class="margin_t_5">
			    			${rl.replyUserName}
						</div>
					</c:if>
				</c:forEach>
			</div>
			
			<!-- 主持人 -->
			<div>
				<div class="margin_t_10">
					<b class="margin_r_5"><fmt:message key="mt.mtMeeting.emceeId" />:</b> ${meet.emceeName }
				</div>
			</div>
			
			<!-- 记录人 -->
			<div>
				<div class="margin_t_10">
					<b class="margin_r_5"><fmt:message key="mt.mtMeeting.recorderId" />:</b>${meet.recorderName }
				</div>
			</div>
			
			<!-- 与会设备 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.resource" />:</b>${meet.resourcesName }
				</div>
			</div>
			
			<!-- 所属项目 -->
			<div class="margin_t_10 <c:if test ="${(v3x:getSysFlagByName('meeting_showRelatedProject') == false)}">hidden</c:if>">
				<div>
					<b><fmt:message key="mt.mtMeeting.projectId" />:</b>${v3x:toHTML(projectName)}
				</div>
			</div>
			
			<%-- <b><fmt:message key="mt.mtMeeting.meetingType" />:${meetingTypeName }</b><br>
			<br> --%>		
			
			<!-- 电话号码 -->
			<c:if test="${content_tel == 'true' }">
				<b style="word-break:break-all;"><fmt:message key="mt.mtMeeting.tel" />:</b>${meet.tel }<br>
				<br>
			</c:if>
			
			<!-- 注意事项 -->
			<c:if test="${content_notice == 'true' }">
				<a href="javascript:openNotice();">
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.note" /></b></font>
				</a>
				<br>
				<br>
			</c:if>
			
			<!-- 计划事项 -->
			<c:if test="${content_plan == 'true' }">
				<a href="javascript:openPlan();">
				<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.plan" /></b></font>
				</a>
				<br>
			</c:if>
	
		</div>
	</td>
</tr>
	
<tr id="replyTR" style="display: none" valign="top">
	<td>
		<form name="mtForm" method="post" action="mtSummary.do" onsubmit="return false">
			<input type="hidden" name="method" value="mydetail" />
			<input type="hidden" name="recordId" value="${bean.id}" />
			<input type="hidden" name="mId" value="${mId}" />
			<input type="hidden" name="fagent" value="${fagent}" />
			<input type="hidden" name="replyId" value="${myReply.id}" />
			<input type="hidden" name="proxy" value="${proxy}" />
			<input type="hidden" name="proxyId" value="${proxyId}" />
			<input type="hidden" name="openType" value="${param.openType}" />
			<table width="100%" cellpadding="0" cellspacing="0" style="padding: 10px 10px 10px 10px;">
				<tr>
					<td>
						 
						<input type="radio" id="radio1" name="feedbackFlag" value="yes" checked/>
						<label for="radio1">	
							<fmt:message key="mt.summary.audit.2"/> 
						</label> 
						 
						<input type="radio" id="radio2" name="feedbackFlag" value="no"/> 
						<label for="radio2">	
							<fmt:message key="mt.summary.audit.3"/> 
						</label> 
					</td>
				</tr>
				<tr>
					<td valign="top">
					<textarea class="input-100per" id="feedback"
						name="feedback" rows="5" cols="80"
						style="word-break:break-all;word-wrap:break-word"></textarea><br />
					<div style="color: green">
		              	<fmt:message key="guestbook.content.help" bundle="${v3xMainI18N}">
							<fmt:param value="1200" />
						</fmt:message>
					</div>
					</td>
				</tr>
				<tr>
					<td>
						<div align="right">
							<input onclick="parentClose();" type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default-2"/>
						</div>
					</td>
				</tr>
				
			</table>
		</form>
	</td>
</tr>
</table>

<script type="text/javascript">
changeLocation('showReply');
showPrecessArea(165);
</script>
</body>
</html>
