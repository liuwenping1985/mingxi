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
<script type="text/javascript" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">

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

//重写setTimeout,使其支持参数传递
var _st = window.setTimeout;    
window.setTimeout = function(fRef, mDelay) {    
	if(typeof fRef == 'function') {    
 		var argu = Array.prototype.slice.call(arguments,2);    
		var f = (function() { 
			fRef.apply(null, argu); 
		});    
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

//打开会议计划
function openPlanDialog(isReadOnly) {
	var value = document.getElementById("plan").value;
	var url = "meeting.do?method=openPlanDialog&isView=1&content="+encodeURIComponent(value)+"&ndate="+new Date().getTime();
	if(isReadOnly) {
		url += "&isReadOnly="+isReadOnly;
	}
	openMeetingDialog(url, "会议议程", 500, 350,null,true);
}
function openNoticeDialog(isReadOnly) {
	var value = document.getElementById("notice").value; 
	var url = "meeting.do?method=openNoticeDialog&isView=1&content="+encodeURIComponent(value)+"&ndate="+new Date().getTime();
	if(isReadOnly) {
		url += "&isReadOnly="+isReadOnly;
	}
	openMeetingDialog(url, "注意事项", 500, 350,null,true);
	//parent.frames["detailMainFrame"].openNoticeDialog(value);
}

function loadUE() {
	bindOnresize('scrollListDiv',20,50);
}
-->
</script>

</head>

<body scroll="no" class="precss-scroll-bg border-right border-top" onload="loadUE()">

<input type="hidden" name="plan" id="plan" value="${meeting.plan }" />
<input type="hidden" name="notice" id="notice" value="${meeting.notice }" />

<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel" />

<div id="signMinDiv" style="height: 100%" class="sign-min-bg">
	<div class="sign-min-label" onClick="changeLocation('showReply');showPrecessArea(165)" title="<fmt:message key="oper.view" />"><fmt:message key="oper.view" /></div>
	<div class="separatorDIV"></div>
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
			<c:if test="${fn:length(leaderList)>0 }">
				<b><fmt:message key="mt.mtMeeting.leader" />:</b>
				<br>
				
				<c:forEach items="${leaderList }" var="leader">
					${v3x:toHTML(leader.name) }<br>
				</c:forEach>
				<br>
			</c:if>
	
			<!-- 嘉宾 -->
			<c:if test="${meeting.attender!=null && meeting.attender != '' }">
				<b><fmt:message key="mt.mtMeeting.attender.simplelabel" />:</b>
				<br>
					${v3x:toHTML(meeting.attender)}
				<br>
			</c:if>
	
			<!-- 参与人员 -->
			<div>
				<div>
					<b><fmt:message key="mt.mtMeeting.join.actual" />:</b>
				</div>
				<c:forEach items="${scopesList}" var="scope">
					<c:if test="${ scope.id != bean.createUser }">
						<div class="margin_t_5">
			    			${v3x:toHTML(scope.name)}
						</div>
					</c:if>
				</c:forEach>
			</div>
			
			<!-- 主持人 -->
			<div>
				<div class="margin_t_10">
					<b class="margin_r_5"><fmt:message key="mt.mtMeeting.emceeId" />:</b> ${v3x:toHTML(v3x:showMemberName(meeting.emceeId)) }
				</div>
			</div>
			
			<!-- 记录人 -->
			<div>
				<div class="margin_t_10">
					<b class="margin_r_5"><fmt:message key="mt.mtMeeting.recorderId" />:</b>${v3x:toHTML(v3x:showMemberName(meeting.recorderId)) }
				</div>
			</div>
			
			<!-- 与会设备 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.resource" />:</b>${meeting.resourcesName }
				</div>
			</div>
			
			<!-- 所属项目 -->
			<div class="margin_t_10">
				<div>
					<b><fmt:message key="mt.mtMeeting.projectId" />:</b>${v3x:toHTML(projectName)}
				</div>
			</div>
			
			<!-- 电话号码 -->
			<c:if test="${meeting.tel != null && meeting.tel != ''}">
				<b style="word-break:break-all;"><fmt:message key="mt.mtMeeting.tel" />:</b>${meeting.tel }<br>
				<br>
			</c:if>
			
			<!-- 注意事项 -->
			<c:if test="${meeting.notice != null && meeting.notice != '' }">
				<a href="javascript:openNoticeDialog(true);">
					<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.note" /></b></font>
				</a>
				<br>
				<br>
			</c:if>
			
			<!-- 议程 -->
			<c:if test="${meeting.plan != null && meeting.plan != '' }">
				<a href="javascript:openPlanDialog(true);">
				<font color="#0278A9"><b><fmt:message key="mt.mtMeeting.plan" /></b></font>
				</a>
				<br>
			</c:if>
	
		</div>
	</td>
</tr>

<script type="text/javascript">
	changeLocation('showReply');
	showPrecessArea(165);
</script>
</body>
</html>
