<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meetingsummary/js/meetingsummary.js${v3x:resSuffix()}" />"></script>
</head>
<body scroll="no" class="padding5"  onload="onLoadLeft()" onunload="unLoadLeft()">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div id="menuTabDiv" class="div-float">
			
				<%-- 待记录的会议纪要 --%>
				<c:if test="${ctp:hasResourceCode('F09_mtSummaryCreate') == true}">
					<span class="resCode">
					<div class="${param.from=='create'||param.from==null?'tab-tag-left-sel':'tab-tag-left'}"></div>
					<div class="${param.from=='create'||param.from==null?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:mtsummary_changeMenuTab(this);" url="${mtSummaryURL}?method=listHome&from=create&listType=waitRecord"><fmt:message key="meeting.summary.record.wait"  bundle="${v3xMeetingSummaryI18N}"/></div>
					<div class="${param.from=='create'||param.from==null?'tab-tag-right-sel':'tab-tag-right'}"></div>
					</span>
				</c:if>
				
				<%-- 草稿箱 --%>
				<c:if test="${ctp:hasResourceCode('F09_mtSummaryWatiSend') == true}">
					<span class="resCode">
						<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
							<div class="tab-separator"></div>
							<div class="${param.from=='draft'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${param.from=='draft'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:mtsummary_changeMenuTab(this);" url="${mtSummaryURL}?method=listHome&from=draft&listType=draft"><fmt:message key="mtSummary.tree.draftbox.lable"  bundle="${v3xMeetingSummaryI18N}"/></div>
							<div class="${param.from=='draft'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						<% } %>
					</span>
				</c:if>
				
				<%-- 会议纪要 --%>
				<c:if test="${ctp:hasResourceCode('F09_mtSummaryPublish') == true}">
					<span class="resCode">
						<c:set var="listType" value="waitAudit"/>
						<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
							<c:set var="listType" value="passed"/>
						<% } %>
						<div class="tab-separator"></div>
						<div class="${param.from=='publish'?'tab-tag-left-sel':'tab-tag-left'}"></div>
						<div class="${param.from=='publish'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:mtsummary_changeMenuTab(this);" url="${mtSummaryURL}?method=listHome&from=publish&listType=${listType}"><fmt:message key="meeting.summary.record.publish"  bundle="${v3xMeetingSummaryI18N}"/></div>
						<div class="${param.from=='publish'?'tab-tag-right-sel':'tab-tag-right'}"></div>
					</span>
				</c:if>
				
				<%-- 我审核的会议纪要 --%>
				<c:if test="${ctp:hasResourceCode('F09_mtSummaryPerm') == true}">
					<span class="resCode">
						<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
							<div class="tab-separator"></div>
							<div class="${param.from=='audit'?'tab-tag-left-sel':'tab-tag-left'}"></div>
							<div class="${param.from=='audit'?'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:mtsummary_changeMenuTab(this);" url="${mtSummaryURL}?method=listHome&from=audit&listType=waitAudit"><fmt:message key="mtSummary.audit.lable"  bundle="${v3xMeetingSummaryI18N}"/></div>
							<div class="${param.from=='audit'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						<% } %>
					</span>
				</c:if>
			</div>
		</td>
	</tr>
	<tr>
	<%--xiangfan 修改 2012-04-17 添加 editSummaryId，editFrom，editListType参数 解决GOV-447 和GOV-451 页面跳转错误--%>
		<td class="page-list-border"><iframe src="${mtSummaryURL}?method=listMain&from=${param.from}&listType=${param.listType}&editSummaryId=${param.editSummaryId}&editFrom=${param.editFrom}&editListType=${param.editListType}" noresize="noresize" frameborder="no" id="mainIframe" name="mainIframe" style="width: 100%; height: 100%;" border="0px"></iframe></td>
	</tr>
</table>

</body>
</html>
