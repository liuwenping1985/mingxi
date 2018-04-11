<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
function meetingListDetail(url) {
	location.href = url;
}
</script>
</head>

<body scroll='no' onload="">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	
	
<tr style="${param.menuId=='2107'?'display:none':'display:'}">
	<td valign="bottom" height="26" class="tab-tag" id="meetingToolbar">
		<div id="menuTabDiv" class="div-float"> 
			<c:choose>
			
			<%-------------------- G6<会议通知> | A6/A8<会议安排 >---------------------%>
			<c:when test="${param.menuId=='2101'}">
				<c:choose>
				<c:when test="${param.listType==null || param.listType==''}">
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_APP) { %>
						<c:if test="${hasMeetingReviewRight }">
							<c:set value="listAppAuditingMeeting" var="listType" />
							<c:set value="listAudit" var="listMethod" />
							<c:set value="auditing" var="from" />
						</c:if>
						<c:if test="${!hasMeetingReviewRight }">
							<c:set value="listNoticeMeeting" var="listType" /><%--xiangfan 修复GOV-3078.会议工作-会议管理中，当没有会议审核的页签时，登陆进这个页面应该默认显示会议通知页签 --%>
							<c:set value="listMyMeeting" var="listMethod" />
							<c:set value="${param.from }" var="from" />
						</c:if>
					<% } else { %>
						<c:set value="listNoticeMeeting" var="listType" /><%--xiangfan 修复GOV-3078.会议工作-会议管理中，当没有会议审核的页签时，登陆进这个页面应该默认显示会议通知页签 --%>
						<c:set value="listMyMeeting" var="listMethod" />
						<c:set value="${param.from }" var="from" />
						
						<c:if test="${!hasMeetingReviewRight }">
							<c:set value="listNoticeMeeting" var="listType" /><%--如果是A6/A8，就默认跳转到会议通知的已发会议里面 --%>
							<c:set value="listMyMeeting" var="listMethod" />
							<c:set value="${param.from }" var="from" />
						</c:if>
					<% } %>

				</c:when>
				<c:otherwise>
					<c:set value="${param.listType}" var="listType" />
					<c:set value="${param.listMethod }" var="listMethod" />
					<c:set value="${param.from }" var="from" />
				</c:otherwise>
				</c:choose>

				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_APP) { %>
					<!-- G6 会议申请 resCode="F09_meetingApp" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingApp') == true}">
						<span class="resCode" resCodeMt="F09_meetingApp" resCodeParent="F09_meetingArrange" current="${listType=='listMyAppMeetingWaitVarificate'||listType=='listMyAppMeeting'?true:false }">
							<div class="${listType=='listMyAppMeetingWaitVarificate'||listType=='listMyAppMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listMyAppMeetingWaitVarificate'||listType=='listMyAppMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=list&listType=listMyAppMeetingWaitVarificate')"><fmt:message key="mt.mtMeeting.application.label" /></div>
							<div class="${listType=='listMyAppMeetingWaitVarificate'||listType=='listMyAppMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
					<!-- G6 会议审核 resCode="F09_meetingPerm"  -->
					<c:if test="${hasMeetingReviewRight and ctp:hasResourceCode('F09_meetingPerm') == true}">
						<span class="resCode" resCodeMt="F09_meetingPerm" resCodeParent="F09_meetingArrange" current="${listType=='listAppAuditingMeeting' || listType=='listAppAuditingMeetingAudited'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listAppAuditingMeeting' || listType=='listAppAuditingMeetingAudited'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listAppAuditingMeeting' || listType=='listAppAuditingMeetingAudited'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listAudit&listType=listAppAuditingMeeting');"><fmt:message key="mt.mtMeeting.auditing.label" /></div>
							<div class="${listType=='listAppAuditingMeeting' || listType=='listAppAuditingMeetingAudited'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				<% } %>
				
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
					<!-- G6 会议通知  resCode="F09_meetingNotice" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingNotice') == true}">
						<span class="resCode" resCodeMt="F09_meetingNotice" resCodeParent="F09_meetingArrange" current="${listType=='listNoticeMeeting'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listMyMeeting&listType=listNoticeMeeting');"><fmt:message key="mt.mtMeeting.notice.label" /></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				<% } %>
				
				<%--A6/A8左侧列表变为页签 --%>
				<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
					<c:if test="${listType=='listNoticeMeetingCreate' }">
						<c:set value="create" var="listMethod"></c:set>
					</c:if>
					<!-- A6 A8 会议新建  resCode="F09_meetingCreate"-->
					<c:if test="${ctp:hasResourceCode('F09_meetingCreate') == true}">
						<span class="resCode" resCodeMt="F09_meetingCreate" resCodeParent="F09_meetingArrange" current="${listType=='listNoticeMeetingCreate'?true:false }">
							<div class="${listType=='listNoticeMeetingCreate'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listNoticeMeetingCreate'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=create&listType=listNoticeMeetingCreate');"><fmt:message key="oper.newMeeting" /></div>
							<div class="${listType=='listNoticeMeetingCreate'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				
					<!-- A6 A8待发  resCode="F09_meetingWaitSend" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingWaitSend') == true}">
						<span class="resCode" resCodeMt="F09_meetingWaitSend" resCodeParent="F09_meetingArrange" current="${listType=='listDraftNoticeMeeting'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listDraftNoticeMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listDraftNoticeMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listMyMeeting&listType=listDraftNoticeMeeting');"><fmt:message key="mt.mtMeeting.state.sendWait" /></div>
							<div class="${listType=='listDraftNoticeMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				
					<!-- A6 A8 已发 resCode="F09_meetingSend" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingSend') == true}">
						<span class="resCode" resCodeMt="F09_meetingSend" resCodeParent="F09_meetingArrange" current="${listType=='listNoticeMeeting'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listMyMeeting&listType=listNoticeMeeting');"><fmt:message key="mt.mtMeeting.state.send" /></div>
							<div class="${listType=='listNoticeMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				
				<% } %>
			</c:when>
			
			<%--------------------- G6<我的会议> | A6/A8<会议查看>  ---------------------%>
			<c:when test="${param.menuId=='2102'}">			
				<c:set value="${(param.listType==null||param.listType=='')?'listMyJoinMeeting':param.listType }" var="listType" />
				<c:set value="${param.listMethod}" var="listMethod" />
			
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
					<!-- G6 我发布的会议  resCode="F09_meetingPublish"-->
					<c:if test="${ctp:hasResourceCode('F09_meetingPublish') == true}">
						<span class="resCode" resCodeMt="F09_meetingPublish" resCodeParent="F09_meetingView" current="${listType=='listMyPublishMeeting'?true:false }">
							<div class="${param.listType=='listMyPublishMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${param.listType=='listMyPublishMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&listMethod=listMyMeeting&menuId=${param.menuId}&listType=listMyPublishMeeting');"><fmt:message key="mt.mtMeeting.publish.label" /></div>
							<div class="${param.listType=='listMyPublishMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
					
					<!-- G6 我参加的会议  resCode="F09_meetingJoin" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingJoin') == true}">
						<span class="resCode" resCodeMt="F09_meetingJoin" resCodeParent="F09_meetingView" current="${listType=='listMyJoinMeeting'||param.listType==null?true:false }">
							<div class="tab-separator"></div>
							<div class="${param.listType=='listMyJoinMeeting'||param.listType==null?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${param.listType=='listMyJoinMeeting'||param.listType==null?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&listMethod=listMyMeeting&menuId=${param.menuId}&listType=listMyJoinMeeting');"><fmt:message key="mt.mtMeeting.attend.label" /></div>
							<div class="${param.listType=='listMyJoinMeeting'||param.listType==null?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				<% } %>
			
				<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
					<!-- A6 A8 未召开 resCode="F09_meetingToOpen" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingToOpen') == true}">
						<span class="resCode" resCodeMt="F09_meetingToOpen" resCodeParent="F09_meetingView" current="${listType=='listToOpenMeeting'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listToOpenMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listToOpenMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listMyMeeting&listType=listToOpenMeeting');"><fmt:message key="mt.mtMeeting.state.10" /></div>
							<div class="${listType=='listToOpenMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>
				
					<!--A6 A8 已召开 resCode="F09_meetingOpened" -->
					<c:if test="${ctp:hasResourceCode('F09_meetingOpened') == true}">
						<span class="resCode" resCodeMt="F09_meetingOpened" resCodeParent="F09_meetingView" current="${listType=='listOpenedMeeting'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listOpenedMeeting'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listOpenedMeeting'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listMethod=listMyMeeting&listType=listOpenedMeeting');"><fmt:message key="mt.mtMeeting.state.convoked" /></div>
							<div class="${listType=='listOpenedMeeting'?'tab-tag-right-sel':'tab-tag-right'}"></div>
							<div class="tab-separator"></div>
						</span>
					</c:if>
					
					<%-- 会议纪要  resCode="F09_meetingSummaryPublish" --%>
					<c:if test="${ctp:hasResourceCode('F09_meetingSummaryPublish') == true}">
						<span class="resCode" resCodeMt="F09_meetingSummaryPublish" resCodeParent="F09_meetingView" current="${listType=='listMeetingSummaryPublishPassed'?true:false }">
							<div class="tab-separator"></div>
							<div class="${listType=='listMeetingSummaryPublishPassed'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${listType=='listMeetingSummaryPublishPassed'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listType=listMeetingSummaryPublishPassed&listMethod=listMeetingSummary')"><fmt:message key="meeting.summary.record.publish"  bundle="${v3xMeetingSummaryI18N}"/></div>
							<div class="${listType=='listMeetingSummaryPublishPassed'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						</span>
					</c:if>

				<% } %>
			</c:when>
			
			<%--------------------- G6<领导查阅>  ---------------------%>
			<c:when test="${param.menuId=='2107'}">
				<c:set value="${(param.listType==null||param.listType=='')?'listLeaderToOpenMeeting':param.listType }" var="listType" />
				<c:set value="${param.listMethod}" var="listMethod" />
			</c:when>
			
			<%--------------------- <会议统计>  ---------------------%>
			<c:when test="${param.menuId=='2108'}">
				<c:set value="${(param.listType==null||param.listType=='')?'meetingReplyStat':param.listType }" var="listType" />
				<c:set value="${param.listMethod}" var="listMethod" />

				<%-- 统计内容 resCode="F09_meetingContentStat" --%>
				<c:if test="${ctp:hasResourceCode('F09_meetingSituationStat') == true}">
					<span class="resCode" resCodeMt="F09_meetingSituationStat" resCodeParent="F09_meetingStat" current="${listType=='meetingReplyStat'?true:false }">
						<div class="tab-separator"></div>
						<div class="${listType=='meetingReplyStat'?'tab-tag-left-sel':'tab-tag-left'}"></div>
						<div class="${listType=='meetingReplyStat'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listType=meetingReplyStat&listMethod=meetingStat')">会议参会情况</div>
						<div class="${listType=='meetingReplyStat'?'tab-tag-right-sel':'tab-tag-right'}"></div>
					</span>
				</c:if>
				
				<%-- 统计时间 resCode="F09_meetingTimeStat" --%>
				<c:if test="${ctp:hasResourceCode('F09_meetingRoleStat') == true}">
					<span class="resCode" resCodeMt="F09_meetingRoleStat" resCodeParent="F09_meetingStat" current="${listType=='meetingRoleStat'?true:false }">
						<div class="tab-separator"></div>
						<div class="${listType=='meetingRoleStat'?'tab-tag-left-sel':'tab-tag-left'}"></div>
						<div class="${listType=='meetingRoleStat'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:meetingListDetail('mtMeeting.do?method=listHome&menuId=${param.menuId}&listType=meetingRoleStat&listMethod=meetingStat')">会议参与角色</div>
						<div class="${listType=='meetingRoleStat'?'tab-tag-right-sel':'tab-tag-right'}"></div>
					</span>
				</c:if>
			</c:when>
			
			</c:choose>
		</div>
		
		<%@ include file="/WEB-INF/jsp/migrate/checkResource.jsp" %>

		<%@ include file="../include/currentLocation.jsp" %>
	</td>
</tr>

<tr>
	<td class=page-list-border-LRD>
		<iframe src="mtMeeting.do?method=listMain&listMethod=${listMethod}&menuId=${param.menuId}&listType=${listType}&from=${from}&stateStr=${param.stateStr}&sendType=${sendType}&mtAppId=${mtAppId}&summaryId=${param.summaryId}&affairId=${param.affairId}&collaborationFrom=${param.collaborationFrom}&formOper=${param.formOper}&portalRoomAppId=${param.portalRoomAppId}&projectId=${param.projectId}" noresize="noresize" frameborder="no" id="mainIframe" name="mainIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		<script type="text/javascript">
			if($("span.resCode")!=null) {
				var showCount = 0;
				for(var i=0; i<$("span.resCode").length; i++) {
					var span = $("span.resCode").eq(i);
					if(span[0].style.display!='none') {
						showCount++;
					}
				}
				if(showCount == 0) {
					$("#mainIframe").attr("src", "");
				}
			}
		</script>
	</td>
</tr>
</table>
	
</body>

</html>
