<%--<%@ page import="com.seeyon.v3x.workflow.event.WorkflowEventListener"%> --%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="v3xMtRoom"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");

var panels = new ArrayList();
//查看
panels.add(new Panel("showReply", '<fmt:message key="oper.view" />', "showPrecessArea(165)"));
//审核
<c:if test="${notApprove != 2 &&(bean.approveState==10 || bean.approveState==50)&& !empty myReply.agreeFlag && myReply.agreeFlag == 0 && (bean.createUser!=sessionScope['com.seeyon.current_user'].id ||(bean.createUser==sessionScope['com.seeyon.current_user'].id && proxy=='1')||replyFlag=='true') && param.eventId == ''}">
	panels.add(new Panel("reply", '<fmt:message key="oper.audit" />', "showPrecessArea(300)"));
</c:if>
//总结
<%--
<c:if test="${bean.approveState > 20 && bean.recorderId==sessionScope['com.seeyon.current_user'].id}">
	panels.add(new Panel("summary", '<fmt:message key="mt.summary" />', "summary()"));
</c:if>
--%>
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

//审核提交
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
	if(!sendResult){
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
var excludeElements_inviting = parseElements('${members}');

//会议邀请
function invitePeople(){
	var state = '${bean.approveState}';
	if(state != 0 && state != 10){
		alert(v3x.getMessage("meetingLang.meeting_meetingAlreadyOver"));
		return;
	}
	selectPeopleFun_inviting();
}

//会议邀请选人界面 jsFunction
function addPeople(e) {
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
	} catch(e) {
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
function openNotice() {
	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openNotice&type=view&readonly=readonly&id=${bean.id}&mtType=meeting_app&ndate="+new Date().getTime();//xiangfan 修改了参数，修复GOV-3025
	var retObj = window.showModalDialog(url,window ,feacture);
}

//打开注意议程窗口
function openPlan(){
	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openPlan&type=view&readonly=readonly&id=${bean.id}&mtType=meeting_app&ndate="+new Date().getTime();//xiangfan 修改了参数，修复GOV-3025
	var retObj = window.showModalDialog(url,window ,feacture);
}


-->
</script>

</head>
<body scroll="no" class="precss-scroll-bg">

<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel" />

<div oncontextmenu="return false" style="position:absolute; right:20px; top:100px; width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;" id="divPhrase" onMouseOver="" onMouseOut="">
	<IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" src="" align="middle" scrolling="no" marginheight="0" marginwidth="0"></IFRAME>
</div>

<div id="signMinDiv" style="height: 100%" class="sign-min-bg">

<div class="sign-min-label" onClick="changeLocation('showReply');showPrecessArea(165)" title="<fmt:message key="oper.view" />"><fmt:message key="oper.view" /></div>

<div class="separatorDIV"></div>

<c:if test="${notApprove != 2 &&(bean.approveState==10 || bean.approveState==50)&& !empty myReply.agreeFlag && myReply.agreeFlag == 0 && (bean.createUser!=sessionScope['com.seeyon.current_user'].id ||(bean.createUser==sessionScope['com.seeyon.current_user'].id && proxy=='1')||replyFlag=='true') && param.eventId == ''}">
	<div class="sign-min-label" onClick="changeLocation('reply');showPrecessArea(300)" title="<fmt:message key="oper.audit" />"><fmt:message key="oper.audit" /></div>
	<div class="separatorDIV"></div>
</c:if> 

</div>

<table width="100%" id="signAreaTable" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
	<td height="25" valign="top" nowrap="nowrap" class="sign-button-bg">
	<script type="text/javascript">showPanels();</script></td>
</tr>

<tr id="showReplyTR" style="display: none" valign="top">
	<td style="padding: 0px 0px 0px 10px">
		<c:if test="${bean.createUser!=bean.emceeId}">
			<c:set value="-100" var="emceeState" />
		</c:if> 
			
		<div id="scrollListDiv" style="width:100%; height:100%; overflow-y: scroll">
			
			<c:if test="${!empty leaders }">
				<b><fmt:message key="mt.mtMeeting.leader" />:</b>
				<br>
				<c:forEach items="${leaders }" var="lname">
					${lname }<br>
				</c:forEach>
				<br>
			</c:if>
		
		
			<c:if test="${content_attender == 'true' }">
				<b><fmt:message key="mt.mtMeeting.attender.simplelabel" />:</b>
				<br>
				<c:if test="${bean.attender!=null && bean.attender!=''}">
					<div style="word-break:break-all;">${bean.attender}</div><br>
				</c:if>
				<br>
			</c:if>
			
			<b><fmt:message key="mt.mtMeeting.join" />:&nbsp;&nbsp;&nbsp;</b>
			<br>
			<c:forEach items="${replyExList}" var="rl">
				<c:if test="${ rl.replyUserId != bean.emceeId }">
		    			${rl.replyUserName}
		    			<c:if test="${rl.mtReply.userAccountName!=null }">
							<c:out value="(${rl.mtReply.userAccountName})" />
						</c:if>
					<br>
				</c:if>
				<c:choose>
					<c:when
						test="${rl.replyUserId == bean.emceeId}">
						<c:set value="${rl.feedbackFlag}" var="emceeState" />
					</c:when>
	
					<c:when test="${rl.replyUserId == bean.emceeId}">
						<c:set value="${rl.feedbackFlag}" var="emceeState" />
					</c:when>
					
				</c:choose>

			</c:forEach>
			<br><br>
		
			<b><fmt:message key="mt.mtMeeting.emceeId" />:</b>
			<br>
			${v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext)} 
			<c:if test="${bean.createUser!=bean.emceeId}">
				(<fmt:message key="mt.mtReply.feedback_flag.${emceeState}" />)
			</c:if> 
			<br><br>
		
		
			<b><fmt:message key="mt.mtMeeting.meetingType" />:</b>
			<br>
			${meetingTypeName }
			<br><br>
		
			<c:if test="${content_tel == 'true' }">
				<b><fmt:message key="mt.mtMeeting.tel" />:</b>
				<br>
				<div style="word-break:break-all;">${bean.tel }</div><br>
				<br><br>
			</c:if>
		
			<c:if test="${content_notice == 'true' }">
				<a href="javascript:openNotice();">
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.note" /></b></font>
				</a>
				<br>
				<br>
			</c:if>
		
			<c:if test="${content_plan == 'true' }">
				<a href="javascript:openPlan();">
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.plan" /></b></font>
				</a>
				<br>
				<br>
			</c:if>
		</div>
	</td>
</tr>

<tr id="replyTR" style="display: none" valign="top">
	<td>
		<form name="mtForm" method="post" action="mtAppMeetingController.do" onsubmit="return false">
			<input type="hidden" name="method" value="mydetail" />
			<input type="hidden" name="id" value="${bean.id}" />
			<input type="hidden" name="fagent" value="${fagent}" />
			<input type="hidden" name="replyId" value="${myReply.id}" />
			<input type="hidden" name="proxy" value="${proxy}" />
			<input type="hidden" name="proxyId" value="${proxyId}" />
			<table width="100%" cellpadding="0" cellspacing="0" style="padding: 10px 10px 10px 10px;">
				<tr>
					<td></td>
				</tr>
				
				<tr>
					<td>
						<input type="radio" id="radio1" name="feedbackFlag" value="1" checked/>
						<label for="radio1">	
							<fmt:message key="mt.notice.state.auditing1"/> 
						</label> 
						 
						<input type="radio" id="radio2" name="feedbackFlag" value="2"/> 
						<label for="radio2">	
							<fmt:message key="mt.notice.state.auditing2"/> 
						</label> 
					</td>
				</tr>
				
				<tr>
					<td valign="top">
						<textarea class="input-100per" id="feedback" name="feedback" rows="5" cols="80" style="word-break:break-all;word-wrap:break-word"></textarea>
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
						<img id="showimg" src="/seeyon/common/images/attachment.gif">
						<a href="javascript:insertAttachment()">
							<fmt:message key="common.toolbar.insert.label" bundle="${v3xCommonI18N}" /><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />
						</a>
						(<span id="attachmentNumberDiv">0</span>) 
						<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
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
	</td>
</tr>
</table>

<script type="text/javascript">

	var oHeight = parseInt(document.body.clientHeight)-35;
	initFFScroll('scrollListDiv',oHeight,140);
	<c:choose>
	<c:when test="${notApprove != 2 &&(bean.approveState==10 || bean.approveState==50)&& !empty myReply.agreeFlag && myReply.agreeFlag == 0 && (bean.createUser!=sessionScope['com.seeyon.current_user'].id ||(bean.createUser==sessionScope['com.seeyon.current_user'].id && proxy=='1')||replyFlag=='true') && param.eventId == ''}">
		changeLocation('reply');
		showPrecessArea(300);
	</c:when>
	<c:otherwise>
		changeLocation('showReply');
		showPrecessArea(165);
	</c:otherwise>
	</c:choose>

</script>
</body>
</html>