<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
	<%@ include file="../include/header.jsp" %>
	<% if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
		<%@ include file="../../videoconference/videoconference_pub.js.jsp" %>
	<% } %>
<title>${v3x:toHTML(bean.title)}</title>

<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style type="text/css">
.detail-subject {
    height: 22px;
    padding-top: 2px;
    line-height: 20px;
}
</style>

<script type="text/javascript">

/******************************视频会议 start***********************************/
var meetingType = "${bean.meetingType}";
var meetingState = "${bean.state}";
var statType = "${statType}";
var id = "${bean.id}";
var isImpart = "${isImpart}";
//控制button是否可用
function _butControl(){
	var joinBtn = document.getElementById("joinBtn");
	//普通会议 button不显示
	if(joinBtn!=null){
		if(meetingType == "1" && isImpart){
	        joinBtn.style.display="none";
		} else if(meetingType == "2" && meetingState == "30" ){
	        //会议结束button不显示
	        joinBtn.style.display="none";
		}
	}
}

function join_meeting(joinType){
    if(meetingState == "-10"){
           alert(v3x.getMessage("meetingLang.meetingArchivedState"));
           return;
    }else if(meetingState == "40"){
          alert(v3x.getMessage("meetingLang.meetingSummedUpState"));
           return;
    }else if(meetingState == "100"){
           alert(v3x.getMessage("meetingLang.meetingArchivedState2"));
           return;
    }else if(meetingState == "30"){
           alert(v3x.getMessage("meetingLang.meetingFinishState"));
           return;
    }
	try{
	    joinVideoconference(joinType, "${bean.confKey}", "${bean.meetingPassword}", "/mtMeeting.do?method=listMain&stateStr=10");
	}catch(e){
		alert("视频会议配置有误，无法打开视频会议！");
	}
}

function meetingSummaryCreate(meetingId, summaryId, frameObj, closeWin) {
    
	var defaultListType = "${bean.state==20?'listPendingMeeting':'listDoneMeeting'}";
	var defaultEntry = "${bean.state==20?'meetingPending':'meetingDone'}";
	var listType = "${(param.listType==null||param.listType=='')?'"+defaultListType+"':param.listType}";

	var url = "meetingSummary.do?method=createMeetingSummary&meetingId="+meetingId+"&summaryId="+summaryId+"&listType="+listType;
	var parentWindow = window.dialogArguments;
	var parentObj;
	var isModel = true;
	if(parentWindow == undefined) {
		parentWindow = parent.window.dialogArguments;
		isModel = false;
	}
	if(parentWindow == undefined) {
		parentWindow = parent.parent.window.dialogArguments;
		isModel = false;
	}
	
	url = "meetingNavigation.do?method=entryManager&entry="+defaultEntry+"&listMethod=createMeetingSummary&meetingId="+meetingId+"&summaryId="+summaryId;
	if(typeof(parent) != 'undefined'
		&& typeof(parent.parent) != 'undefined'
		&&typeof(parent.parent.meeting_report_main_frame_flag ) != 'undefined'
		&&parent.parent.meeting_report_main_frame_flag === "true"){//绩效这块写死，组件dialog无法传值过来，OA-80459
	    	
	    parent.parent.parent.getA8Top().main.location.href = url;
        return;
	}
	
	if(parentWindow) {
		if(parentWindow.window != null && parentWindow.window.dialogDealColl) {
		    parentWindow.window.getA8Top().main.location.href = url;
			parentWindow.window.dialogDealColl.close();
			parentObj = parentWindow.window;
			return;
		} else if(parentWindow.pwindow != null && parentWindow.pwindow.dialogDealColl) {
		    parentWindow.pwindow.getA8Top().main.location.href = url;
			parentWindow.pwindow.dialogDealColl.close();
			parentObj = parentWindow.pwindow;
			return;
		} else if(parentWindow.parent && parentWindow.parent.listFrame) {
			parentObj = parentWindow.parent.listFrame;
			parentWindow.parent.location.href = url;
			parent.window.close();
			return;
		} else {
			if(isModel) {
				parentObj = parentWindow;
				if(parentObj.getA8Top().main){
			      parentObj.getA8Top().main.location.href = url;
				}
				window.returnValue = "true";
				getA8Top().close();
				return;
			}
		}
		if(!isModel && parentWindow.pwindow) {//从首页栏目点击会议【纪要】 + 绩效穿透列表点击会议【纪要】
		   if(parentWindow.callback){//绩效穿透列表入口做非空判断
              parentWindow.callback();
           }
		   parentWindow.pwindow.getA8Top().main.location.href = url;
           return;
		}
		getA8Top().close();
	} else if(window.opener){
		if(window.opener.parent.main){//个人知识中心 跳转 OA-48218
			window.opener.parent.main.location.href = url;
		}else {//文档中心 跳转
			window.opener.parent.location.href = url;
		}
		window.close();
	} else {
	    
		if(parent.parent.listFrame!=null) {
			url = "meetingSummary.do?method=createMeetingSummary&meetingId="+meetingId+"&summaryId="+summaryId+"&listType="+listType;
			if(parent.parent.document.getElementById("sx")) {
				parent.parent.document.getElementById("sx").rows = "100%,0";
			}
			parent.parent.listFrame.location.href = url;
		} else {
		    var winowId = meetingId + "-summary";//会议纪要页面ID
		    meetingOpenNewWin({"url":url,"id":winowId});
		}
	}
}

function loadUE() {
	var parentWindow = window.dialogArguments;
	if(parentWindow == undefined) {
		parentWindow = parent.window.dialogArguments;
	}
	if(parentWindow == undefined) {
		parentWindow = parent.parent.window.dialogArguments;
	}
	var  _ismultaskWindow = (getA8Top().isCtpTop == undefined || getA8Top().isCtpTop == "undefined");
	var _isColl360 = '${param.isColl360}';
	var _isCollCube = '${param.isCollCube}';
	if((parentWindow != null || _ismultaskWindow || _isColl360=='1' ||_isCollCube =='1') && parent.document.getElementById("df")) {
		parent.document.getElementById("df").rows = "0,*";
	}
	
}
function showPeopleCard(memberId){
	var windowObj = parent.window.detailMainFrame;
	if(typeof windowObj == 'undefined') {
        parentWindow = parent.parent.window.detailMainFrame;
    }
	showV3XMemberCardWithOutButton(memberId, windowObj);
}

function exportParticipants(){
	 window.location.href  = "${mtMeetingURL}?method=transExportExcelMeeting&id="+id;
}

</script>
</head>

<body style="overflow: hidden" onLoad="loadUE();" class="border-left border-top border-right">

<v3x:attachmentDefine attachments="${attachments}" />

<c:if test="${bean.accountName!=null }">
	<c:set value="(${bean.accountName})" var="createAccountName"/>
</c:if>

<form action="" method="post" id="dataForm" target="_self">

<iframe src="" name="tarFram" id="tarFram" style="display: none"></iframe>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">

<c:if test="${statType=='workStat' || statType=='mtReply' || statType=='mtRole'}">
<tr align="center">
	<td height="8" class="detail-top">
		<script type="text/javascript">
			getDetailPageBreak();
		</script>
	</td>
</tr>
</c:if>



<tr>
	<td height="10" class="detail-summary" id="paddId">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
			<tr height="5"><td colspan="5"></td></tr>
	    	<TR id="tr1">
				<!-- 会议名称 -->
				<TD width="10%" nowrap align="right">
					<div class="bg-gray detail-subject" style="font-size:12px;">
						<fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" />
					</div>
				</TD>
				<TD>
					<div id="printsubject" style="color:#000000;font-size:12px;">
						${v3x:toHTML(bean.title)}
						<c:if test="${bean.meetingType eq  '2' }">
		                   <span class="bodyType_videoConf inline-block"></span>
			        	</c:if>
			        	<%-- 列表和详细页面，会议名称后就不显示单位名称了(兼职的情况，在本单位登录时)
						${createAccountName}
						--%>
					</div>
				</TD>

				<!-- 会议时间 -->
				<TD id="timeLabel" width="10%" nowrap align="right">
					<div class="bg-gray detail-subject" style="font-size:12px;">
						<fmt:message key="mt.searchdate" /><fmt:message key="label.colon" />
					</div>
				</TD>
				<TD width="35%">
					<div id="printTimeInfo" class="detail-subject" style="color:#000000;font-size:12px;">
						<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatDate pattern="${mtHoldTimeInSameDay ? timePattern : datePattern}" value="${bean.endDate}" />
					</div>
				</TD>

				<!-- 会议方式 -->
				<TD class="detail-subject" style="font-size:12px;">
					<c:if test="${'2' eq bean.meetingType && ((bean.state==10||bean.state==20) && (bean.roomState!=0 && bean.roomState!=2 && showJoinButtom)) && isImpart ==false}">
						<c:set value="(${bean.accountName})" var="createAccountName" />
						<c:set var="curUser" value="${v3x:currentUser()}" />
						<input type="button" onmouseover="this.style.cursor='hand'"
							onmouseout="this.style.cursor='point'" id="joinBtn"
							onClick="join_meeting('${( curUser.id==bean.emceeId || curUser.id==bean.createUser)?'1':'2' }')" class="setmeeting"
							value="<fmt:message key="oper.join"/>" />
					</c:if>
				</TD>
			</TR>

			<TR>
				<!-- 发起者 -->
		      	<TD nowrap align="right">
		      		<div class="bg-gray detail-subject" style="font-size:12px;">
		      			<fmt:message key="mt.mtMeeting.createUser" /><fmt:message key="label.colon" />
		      		</div>
		      	</TD>
		      	<TD id="printSenderInfo" width="40%">
		      		<div class="detail-subject" onClick="showPeopleCard('${bean.createUser}');" style="color:#000000;cursor:pointer;font-size:12px;">
		      			${v3x:showOrgEntitiesOfIds(bean.createUser, 'Member', pageContext)}&nbsp;&nbsp;(<fmt:formatDate value="${bean.createDate}" pattern="yyyy-MM-dd HH:mm"/>)
		      		</div>
		      	</TD>

		      	<!-- 会议地点 -->
		      	<TD width="10%" nowrap align="right">
		      		<div class="bg-gray detail-subject" style="font-size:12px;">
		      			<fmt:message key="mt.mtMeeting.place" /><fmt:message key="label.colon" />
		      		</div>
		      	</TD>
			  	<TD id="printAddressInfo">
			  		<div class="detail-subject" style="color:#000000; display: inline;font-size:12px;">${v3x:toHTML(meetingroomName)}</div>
			  	</TD>

			  	<td></td>
		    </TR>
			<c:if test="${fn:contains(mtch.typeContent,'1')}">
			<TR>
		      	 <TD height="22" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></TD>
		      	<TD class="detail-subject" colspan="3" width="40%">${v3x:toHTML(bean.mtTitle)}</TD>
		      	<TD style="display: none;" id="timeLabelCopy" width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.searchdate" /><fmt:message key="label.colon" /></TD>
				<TD style="display: none;" id="printTimeInfoCopy" class="detail-subject"><fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatDate pattern="${mtHoldTimeInSameDay ? timePattern : datePattern}" value="${bean.endDate}" /></TD>
		   	</TR>
		   	</c:if>

			<tr id="attachment2Tr" style="display: none" height="20">
				<td nowrap valign="top" align="right">
					<div class="bg-gray detail-subject" style="font-size:12px;">
						<fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" />
					</div>
				</td>
				<td valign="bottom" colspan="4">
					<div id="attachment2ExportAttachment" class="attachment-single div-float detail-subject" onmouseover="exportAttachment(this)">
						<div class="div-float font-12px">(<span id="attachment2NumberDiv" class="font-12px"></span>)</div>
						<script type="text/javascript">
						<!--
						showAttachment('${bean.id}', 2, 'attachment2Tr', 'attachment2NumberDiv');
						//-->
						</script>
					</div>
				</td>
			</tr>

			<tr id="attachmentTr" style="display: none" height="20">
				<td nowrap valign="top" align="right">
					<div class="bg-gray detail-subject" style="font-size:12px;">
						<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" />
					</div>
				</td>
				<td colspan="4" nowrap valign="bottom">
					<div id="attachmentTrExportAttachment" class="attachment-single div-float" onmouseover="exportAttachment(this)">
						<div class="div-float font-12px">(<span id="attachmentNumberDiv" class="font-12px"></span>)</div>
						<script type="text/javascript">
						<!--

						showAttachment('${bean.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
						//-->
						</script>
					</div>
				</td>
			</tr>

			<TR height="20">
				<TD nowrap class="bg-gray detail-subject" align="right">&nbsp;&nbsp;</TD>
		      	<TD class="detail-subject" width="40%" colspan="2">&nbsp;&nbsp;</TD>
			  	<TD class="detail-subject" align="right" colspan="2" >
			  	 <div id="print">
			  		<c:if test="${(bean.dataFormat eq 'OfficeWord' || bean.dataFormat eq 'OfficeExcel' || bean.dataFormat eq 'WpsWord' || bean.dataFormat eq 'WpsExcel') &&  v3x:isOfficeTran()}">
                        <a id="viewOrgSrc" href="javascript:_loadOfficeControll();"><font class="like-a seeoriginal"><fmt:message key='meeting.content.viewOriginalContent'/></font></a>
                    </c:if>
                    <c:choose>
				  		<c:when test="${((bean.state==20 || bean.state==30 || bean.state==40 || bean.state==-10) && (bean.recorderId==CurrentUser.id || (bean.recorderId=='-1' && bean.emceeId==CurrentUser.id)) && (bean.roomState!=0 && bean.roomState!=2)) && param.isQuote!='true' && fromPigeonhole!='true'}">
				  			<span class="hand" id="print" <c:if test="${param.isColl360 == '1' || param.isCollCube =='1' || param.openfrom=='meetingsummary'}">style="display:none;"</c:if> onclick="meetingSummaryCreate('${bean.id}', '${bean.recordId }', getA8Top().main, false)">
					  			<span class="ico16 signing_16 margin_lr_5" title="<fmt:message key='meeting.summary'/>"></span><fmt:message key='meeting.summary'/>
					  		</span>
				  		</c:when>
                    </c:choose>
                    <c:if test="${param.isQuote!='true'&& param.openFrom != 'glwd'}">
			  		<span class="hand margin_r_10" onclick="printResult('meeting', '${bean.dataFormat eq 'HTML'}')">
			  			<span class="ico16 print_16 margin_lr_5" title="<fmt:message key='meeting.print'/>"></span><fmt:message key='meeting.print'/>
			  		</span>
			  		</c:if>
					<span class="hand margin_r_10" onclick="exportParticipants()">
			  			<span class="ico16 export_excel_16" title="<fmt:message key='meeting.export'/>"></span><fmt:message key='meeting.export'/>
			  		</span>
			  	 </div>	
			  	</TD>
			</TR>
		</table>
	</td>
</tr>

<tr>
	<td height="5" class="detail-summary-separator"></td>
</tr>

<tr id="contentTR">
	<td valign="top">
     	<iframe src="${mtMeetingURL}?method=detail&id=${bean.id}&oper=showContent&proxyId=${proxyId}&isQuote=${param.isQuote}&baseObjectId=${param.baseObjectId}&baseApp=${param.baseApp}&fromPigeonhole=${fromPigeonhole}&isImpart=${isImpart}" width="100%" height="100%" name="contentIframe" frameborder="0" marginheight="0" marginwidth="0"></iframe>
	</td>
</tr>

</table>
</form>
<script type="text/javascript">
function exportFunction(){
	exportAttachment(document.getElementById("attachmentTrExportAttachment"));
}
function exportFunction2(){
	exportAttachment(document.getElementById("attachment2ExportAttachment"));
}
setTimeout(exportFunction,100);
setTimeout(exportFunction2,100);
</script>
</body>
</html>