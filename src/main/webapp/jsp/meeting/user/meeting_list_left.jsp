<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="mtRoom" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
<script>
	/**
	* 显示会议列表页面
	*/			
	function showMeetingList(url) {
		parent.listFrame.location.href = url;	
	}
</script>
</head>
<body>
<div style="margin:5px 0 0 5px;">
<script type="text/javascript">
function setIcon(obj){
	obj.icon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
	obj.openIcon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
}

var properties = new Properties(0);

function changeHandler(myListType) {
	webFXTreeHandler.select(properties.get(myListType)); 
}

<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:choose>
		<c:when test="${param.menuId==null || param.menuId=='2101'}">//会议管理
			<c:choose>
				<c:when test="${param.listType=='listMyAppMeeting' || param.listType=='listMyAppMeetingWaitVarificate' || param.listType=='listMyAppMeetingVarificated' || param.listType=='listMyAppMeetingNotVarificate' || param.listType=='listApp'}">//会议申请
					//xiangfan 添加 再包一层，打到默认时为收缩的效果
					var newAppMeetingRoot = new WebFXTree("newAppMeetingRoot", "<fmt:message key='admin.label.appMeeting'/>", "");
					var newAppMeeting = new WebFXTreeItem("newAppMeeting", "<fmt:message key='mt.mtMeeting.application.label'/>", "javascript:showMeetingList('mtAppMeetingController.do?method=create&menuId=${param.menuId}&listType=listMyAppMeeting&formOper=new')");
					newAppMeeting.icon = "<c:url value='/apps_res/meetingroom/images/applicate_meeting.png'/>";
					newAppMeeting.openIcon = "<c:url value='/apps_res/meetingroom/images/applicate_meeting.png'/>";
					var listMyAppMeetingRoot = new WebFXTree("listMyAppMeetingRoot", "<fmt:message key='admin.label.myMtRequest'/>", "");
					var listMyAppMeeting = new WebFXTreeItem("listMyAppMeeting", "<fmt:message key='mr.tab.yesApp' bundle='${mtRoom}'/>", "javascript:showMeetingList('mtAppMeetingController.do?method=list&menuId=${param.menuId}&listType=listMyAppMeeting')");
					var listMyAppMeetingWaitVarificate = new WebFXTreeItem("listMyAppMeetingWaitVarificate", "<fmt:message key='mt.list.column.type.10' />", "javascript:showMeetingList('mtAppMeetingController.do?method=list&menuId=${param.menuId}&listType=listMyAppMeetingWaitVarificate')");
					setIcon(listMyAppMeetingWaitVarificate);
					var listMyAppMeetingVarificated = new WebFXTreeItem("listMyAppMeetingVarificated", "<fmt:message key='mt.list.column.type.20' />", "javascript:showMeetingList('mtAppMeetingController.do?method=list&menuId=${param.menuId}&listType=listMyAppMeetingVarificated')");
					setIcon(listMyAppMeetingVarificated);
					var listMyAppMeetingNotVarificate = new WebFXTreeItem("listMyAppMeetingNotVarificate", "<fmt:message key='mt.list.column.type.30' />", "javascript:showMeetingList('mtAppMeetingController.do?method=list&menuId=${param.menuId}&listType=listMyAppMeetingNotVarificate')");
					setIcon(listMyAppMeetingNotVarificate);
					newAppMeetingRoot.add(newAppMeeting);
					listMyAppMeetingRoot.add(listMyAppMeeting);
					listMyAppMeeting.add(listMyAppMeetingWaitVarificate);
					listMyAppMeeting.add(listMyAppMeetingVarificated);
					listMyAppMeeting.add(listMyAppMeetingNotVarificate);
					var listMyAppMeetingDraftRoot = new WebFXTree("listMyAppMeetingDraftRoot", "<fmt:message key='mt.list.column.type.0' />", "");
					var listMyAppMeetingDraft = new WebFXTreeItem("listMyAppMeetingDraft", "<fmt:message key='admin.label.drafts' />", "javascript:showMeetingList('mtAppMeetingController.do?method=list&menuId=${param.menuId}&listType=listMyAppMeetingDraft')");
					listMyAppMeetingDraft.icon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
					listMyAppMeetingDraft.openIcon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
					listMyAppMeetingDraftRoot.add(listMyAppMeetingDraft);
					document.write(newAppMeeting);
					document.write(listMyAppMeeting);
					document.write(listMyAppMeetingDraft);
					listMyAppMeeting.expand();
					properties.put("listMyAppMeeting", listMyAppMeeting);
					properties.put("listMyAppMeetingDraft", listMyAppMeetingDraft);
					properties.put("listMyAppMeetingWaitVarificate", listMyAppMeetingWaitVarificate);
					properties.put("listMyAppMeetingVarificated", listMyAppMeetingVarificated);
					properties.put("listMyAppMeetingNotVarificate", listMyAppMeetingNotVarificate);
				</c:when>
				<c:when test="${param.listType=='listAppAuditingMeeting' || param.listType=='listAppAuditingMeetingAudited'}">//会议审核
					var listAppAuditingMeetingToAuditing = new WebFXTree("listAppAuditingMeetingToAuditing", "<fmt:message key='mt.list.column.type.10'/>", "javascript:showMeetingList('mtAppMeetingController.do?method=listAudit&menuId=${param.menuId}&listType=listAppAuditingMeeting&status=0')");
					var listAppAuditingMeetingAudited = new WebFXTree("listAppAuditingMeetingAudited","<fmt:message key='admin.label.audited'/>", "javascript:showMeetingList('mtAppMeetingController.do?method=listAudit&menuId=${param.menuId}&listType=listAppAuditingMeetingAudited&status=1')");
					document.write(listAppAuditingMeetingToAuditing);
					document.write(listAppAuditingMeetingAudited);
					properties.put("listAppAuditingMeeting", listAppAuditingMeetingToAuditing);
					properties.put("listAppAuditingMeetingAudited", listAppAuditingMeetingAudited);
				</c:when>
				<c:when test="${param.listType=='listNoticeMeeting'}">//会议通知
					var listNoticeCreate = new WebFXTree("listNoticeCreate", "<fmt:message key='mt.meeting.create.notice'/>", "javascript:showMeetingList('mtMeeting.do?method=create&menuId=${param.menuId}&listType=listNoticeCreate&formOper=new')");
					listNoticeCreate.icon = "<c:url value='/apps_res/meetingroom/images/notice_meeting.png'/>";
					listNoticeCreate.openIcon = "<c:url value='/apps_res/meetingroom/images/notice_meeting.png'/>";
					var listNoticeMeeting = new WebFXTree("listNoticeMeeting", "<fmt:message key='mt.meeting.my.notice'/>", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listNoticeMeeting')");
					var listDraftNoticeMeeting = new WebFXTree("listDraftNoticeMeeting", "<fmt:message key='admin.label.drafts'/>", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listDraftNoticeMeeting')");
					document.write(listNoticeCreate);		
					document.write(listNoticeMeeting);
					document.write(listDraftNoticeMeeting);
					properties.put("listNoticeCreate", listNoticeCreate);
					properties.put("listNoticeMeeting", listNoticeMeeting);
					properties.put("listDraftNoticeMeeting", listDraftNoticeMeeting);
				</c:when>
			</c:choose>
		</c:when>
		<c:when test="${param.menuId=='2102'}">//我的会议
			<c:choose>
				<c:when test="${param.listType=='listMyPublishMeeting' || param.listType=='listMyPublishToOpenMeeting' || param.listType=='listMyPublishOpenedMeeting'}">//我发起的会议
					var listMyPublishToOpenMeeting = new WebFXTree("listMyPublishToOpenMeeting", "<fmt:message key='mt.mtMeeting.state.10' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listMyPublishToOpenMeeting')");
					var listMyPublishOpenedMeeting = new WebFXTree("listMyPublishOpenedMeeting", "<fmt:message key='mt.mtMeeting.state.convoked' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listMyPublishOpenedMeeting')");
					document.write(listMyPublishToOpenMeeting);
					document.write(listMyPublishOpenedMeeting);	
					properties.put("listMyPublishMeeting", listMyPublishToOpenMeeting);
					properties.put("listMyPublishToOpenMeeting", listMyPublishToOpenMeeting);
					properties.put("listMyPublishOpenedMeeting", listMyPublishOpenedMeeting);
				</c:when>
				<c:when test="${param.listType=='listMyJoinMeeting'}">//我参加的会议
					var listMyJoinToOpenMeeting = new WebFXTree("listMyJoinToOpenMeeting", "<fmt:message key='mt.mtMeeting.state.10' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listMyJoinToOpenMeeting')");
					var listMyJoinOpenedMeeting = new WebFXTree("listMyJoinOpenedMeeting", "<fmt:message key='mt.mtMeeting.state.convoked' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&menuId=${param.menuId}&listType=listMyJoinOpenedMeeting')");
					document.write(listMyJoinToOpenMeeting);
					document.write(listMyJoinOpenedMeeting);
					properties.put("listMyJoinMeeting", listMyJoinToOpenMeeting);
					properties.put("listMyJoinToOpenMeeting", listMyJoinToOpenMeeting);
					properties.put("listMyJoinOpenedMeeting", listMyJoinOpenedMeeting);
				</c:when>
			</c:choose>
		</c:when>
		<c:when test="${param.menuId=='2107'}">//领导查看会议
			<%//wangjingjing 恢复到11069 begin%>
			var listLeaderToOpenMeeting = new WebFXTree("listLeaderToOpenMeeting", "<fmt:message key='mt.mtMeeting.state.10' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&listType=listLeaderToOpenMeeting')");
			var listLeaderOpenedMeeting = new WebFXTree("listLeaderOpenedMeeting", "<fmt:message key='mt.mtMeeting.state.convoked' />", "javascript:showMeetingList('mtMeeting.do?method=listMyMeeting&listType=listLeaderOpenedMeeting')");
			document.write(listLeaderToOpenMeeting);
			document.write(listLeaderOpenedMeeting);
			properties.put("listLeaderMeeting", listLeaderToOpenMeeting);
			properties.put("listLeaderToOpenMeeting", listLeaderToOpenMeeting);
			properties.put("listLeaderOpenedMeeting", listLeaderOpenedMeeting);
			<%//wangjingjing 恢复到11069 begin%>
		</c:when>
	</c:choose>
	if("${param.collaborationFrom}" != null && "${param.collaborationFrom}" != ""){
		webFXTreeHandler.select(properties.get("listNoticeCreate"));
	}else if("${param.from}" == "listNoticeCreate"){
		webFXTreeHandler.select(properties.get("listNoticeCreate"));
	}else {
		webFXTreeHandler.select(properties.get("${param.listType}"));
	}
<% } %>
	
</script>
</div>
</body>
</html>