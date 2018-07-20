<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp" %>
<c:set value="${ctp:getSystemProperty('meeting.type') }" var="hasMeetingType" />
<script>
var baseUrl = "mtMeeting.do?method=";
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
.detail-subject {
	height: 22px;
	padding-top: 2px;
}
</style>
<script>
function loadUE() {
	var parentWindow = window.dialogArguments;
	if(parentWindow == undefined) {
		parentWindow = parent.window.dialogArguments;
	}
	if(parentWindow == undefined) {
		parentWindow = parent.parent.window.dialogArguments;
	}
	if(parentWindow != null && parent.document.getElementById("df")) {
		parent.document.getElementById("df").rows = "0,*";
	}
}
window.onload = function() {
	loadUE();
}
var listType = "${listType}";
</script>
</head>
<body style="overflow: hidden" class="border-left border-top border-right">
<c:if test="${bean.accountName!=null }">
	<c:set value="(${bean.accountName})" var="createAccountName"/>
</c:if>
<v3x:attachmentDefine attachments="${attachments}" />


<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">

<c:if test="${listType == 'listMeetingSummary'}">
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
			<tr height="5"><td colspan="4"></td></tr>
			<TR id="tr1">
				<!-- 会议名称 -->
     			<TD width="10%" nowrap align="right">
     				<div class="bg-gray detail-subject">
     					<fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" />
     				</div>
     			</TD>
				<TD>
					<div>
						<a href="javascript:void(0)" id="printsubject" style="color:#000000;" onclick="displayMyDetail('${mtSummary.meetingId}', 0, 0, 1)">${v3x:toHTML(mtSummary.mtName)}</a>${createAccountName}
                        <c:if test="${mtSummary.meetingType eq  '2' }">
                            <span class="bodyType_videoConf inline-block"></span>
                        </c:if>
					</div>
				</TD>

				<!-- 会议时间 -->
				<TD id="timeLabel" width="10%" nowrap align="right">
					<div class="bg-gray detail-subject">
						<fmt:message key="mt.searchdate" /><fmt:message key="label.colon" />
					</div>
				</TD>
				<TD id="printTimeInfo">
					<div class="detail-subject">
						<fmt:formatDate pattern="${datePattern}" value="${mtSummary.mtBeginDate}" />&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatDate pattern="${mtHoldTimeInSameDay ? timePattern : datePattern}" value="${mtSummary.mtEndDate}" />
					</div>
				</TD>
			</TR>

			<TR>
				<!-- 发起人 -->
		      	<TD width="10%" nowrap align="right">
		      		<div class="bg-gray detail-subject">
		      			<fmt:message key="mt.mtMeeting.createUser" /><fmt:message key="label.colon" />
		      		</div>
		      	</TD>
		      	<TD id="printSenderInfo" width="40%">
		      		<div class="detail-subject">
		      			${v3x:showOrgEntitiesOfIds(mtSummary.createUser, 'Member', pageContext)}&nbsp;&nbsp;(<fmt:formatDate value="${mtSummary.createDate}" pattern="yyyy-MM-dd HH:mm"/>)
		      		</div>
		      	</TD>

		      	<!-- 会议地点 -->
		      	<TD width="10%" nowrap align="right">
		      		<div class="bg-gray detail-subject">
		      			<fmt:message key="mt.mtMeeting.address" /><fmt:message key="label.colon" />
		      		</div>
		      	</TD>
			    <TD id="printAddressInfo" width="40%">
			    	<div class="detail-subject">${mtSummary.mtRoomName}</div>
			    </TD>

		      	<!--
		      	<TD width="10%" nowrap class="bg-gray detail-subject" align="right"><c:if test="${param.listType != 'listMyJoinOpenedMeeting'}"><fmt:message key="mt.mtMeeting.approve" /><fmt:message key="label.colon" /></c:if></TD>
			  	<TD id="printAuditerInfo" class="detail-subject"><c:if test="${param.listType != 'listMyJoinOpenedMeeting'}">${auditorNames}</c:if></TD>
			   	-->
		    </TR>
			<!-- <TR>
			     <TD nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.address" /><fmt:message key="label.colon" />&nbsp;&nbsp;</TD>
			     <TD id="printAddressInfo" class="detail-subject" colspan="3" width="40%">${mtSummary.mtRoomName}</TD>
			      <%--
			      <c:if test="${mtTitle == 1}">
			      <TD width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" /></TD>
				  <TD id="" class="detail-subject">${v3x:toHTML(mtSummary.mtTitle)} ${createAccountName} </TD>
				  </c:if>
				   --%>
				   <TD style="display: none;" id="timeLabelCopy" width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.searchdate" /><fmt:message key="label.colon" /></TD>
				   <TD style="display: none;" id="printTimeInfoCopy" class="detail-subject"><fmt:formatDate pattern="${datePattern}" value="${mtSummary.mtBeginDate}" />&nbsp;&nbsp;-&nbsp;&nbsp;<fmt:formatDate pattern="${mtHoldTimeInSameDay ? timePattern : datePattern}" value="${mtSummary.mtEndDate}" /></TD>
			</TR> -->
			<%-- <TR>
					<TD width="10%" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.address" /><fmt:message key="label.colon" /></TD>
					<TD id="printAddressInfo" class="detail-subject">${mtSummary.mtRoomName}</TD>

					<c:if test="${mtTitle == 1}">
      				<TD width="10%" height="22" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;</TD>
					<TD class="detail-subject" colspan="3">${v3x:toHTML(mtSummary.mtTitle)} ${createAccountName} </TD>
					</c:if>
			</TR> --%>
			<c:if test="${hasMeetingType}">
				<tr>
					<TD width="10%" nowrap align="right">
						<div class="bg-gray detail-subject" style="padding-right:5px;">
							<fmt:message key="mt.mtMeeting.title" /><fmt:message key="label.colon" />
						</div>
					</TD>
					<TD colspan="3">
						<div class="detail-subject">
							${v3x:toHTML(mtSummary.mtTitle)} ${createAccountName}
						</div>
					</TD>
				</tr>
			</c:if>
			<tr id="attachment2Tr" style="display: none">
				<td nowrap valign="top" align="right" class="bg-gray detail-subject"><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
				<td valign="bottom" colspan="3">
					<div class="detail-subject" onmouseover="">
						<div class="div-float font-12px" style="margin-top: 4px;">(<span id="attachment2NumberDiv" class="font-12px"></span>)</div>
						<script type="text/javascript">
						<!--
						showAttachment('${mtSummary.id}', 2, 'attachment2Tr', 'attachment2NumberDiv');
						//-->
						</script>
					</div>
				</td>
			</tr>

			<tr id="attachmentTr" style="display: none" class="padding_t_10">
				<td nowrap valign="top" align="right" class="bg-gray detail-subject">
						<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" />
				</td>
				<td valign="bottom" colspan="3">
					<div class="detail-subject" onmouseover="">
						<div class="div-float font-12px" style="margin-top: 4px;">(<span id="attachmentNumberDiv" class="font-12px"></span>)</div>
						<script type="text/javascript">
						<!--
						showAttachment('${mtSummary.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
						//-->
						</script>
					</div>
				</td>
			</tr>

			<TR>
				<TD nowrap class="bg-gray detail-subject" align="right">&nbsp;&nbsp;</TD>
			    <TD class="detail-subject" colspan="2" width="40%">&nbsp;&nbsp;</TD>
				<TD class="detail-subject" align="right">
					<c:if test="${(mtSummary.dataFormat eq 'OfficeWord' || mtSummary.dataFormat eq 'OfficeExcel' || mtSummary.dataFormat eq 'WpsWord' || mtSummary.dataFormat eq 'WpsExcel')  && v3x:isOfficeTran()}">
                        <a id="viewOrgSrc" href="javascript:_loadOfficeControll();"><font class="like-a seeoriginal"><fmt:message key='meeting.content.viewOriginalContent'/></font></a>
                    </c:if>
				  	<span id="print" title="打印" class="margin_r_10" onclick="printResult('mtSummary', '${mtSummary.dataFormat eq 'HTML'}')">
						<span class="ico16 print_16 margin_lr_5" title="打印"></span><span class="cursor-hand">打印</span>
					</span>
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
      		<iframe src="${mtSummaryURL}?method=detail&recordId=${mtSummary.id }&oper=showContent&hiddenAuditOpinion=${hiddenAuditOpinion}" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>

</table>

</body>
</html>