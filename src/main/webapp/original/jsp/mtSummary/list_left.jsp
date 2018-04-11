<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Insert title here</title>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />" />
		<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
	</head>
	<body>
		<div>
			<script type="text/javascript">
				function showSummaryList(form,listType){
					parent.listFrame.location.href = "${mtSummaryURL}?method=list&from="+form+"&listType="+listType;
				}
				function setIcon(obj){
					obj.icon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
					obj.openIcon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
				}
				var from = "${param.from == null || param.from eq '' ? 'create' : (param.from)}";
				var listType = "${param.listType}";
				var stateStr="${param.stateStr}";
				
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
				//我发起的会议
				if(from=="create"){
					var waitRecord = new WebFXTree("waitRecord", "<fmt:message key='mtSummary.tree.waitRecodeMt.lable'  bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('create','waitRecord');");
					var draftBox = new WebFXTree("draftBox", "<fmt:message key='mtSummary.tree.draftbox.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('create','draft');");
					document.write(waitRecord);
					document.write(draftBox);
					if(listType == "draft"){
						webFXTreeHandler.select(draftBox);
					}else{
						webFXTreeHandler.select(waitRecord);
					}
			
				//我参加的会议
				} else if(from == "publish") {
					//会议纪要审核功能
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
						var all = new WebFXTree("all", "<fmt:message key='mtSummary.tree.all.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('publish','all');");
						var waitAudit = new WebFXTreeItem("waitAudit", "<fmt:message key='mtSummary.tree.waitAudit.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('publish','waitAudit');");
						setIcon(waitAudit);
						var passed = new WebFXTreeItem("passed", "<fmt:message key='mtSummary.tree.passed.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('publish','passed');");
						setIcon(passed);
						var notPassed = new WebFXTreeItem(" notPassed", "<fmt:message key='mtSummary.tree.notpassed.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('publish','notPassed');");
						setIcon(notPassed);
						all.add(waitAudit);
						all.add(passed);
						all.add(notPassed);
						document.write(all);
						if(listType == "all"){
							webFXTreeHandler.select(all);
						}else if(listType =="waitAudit"){
							webFXTreeHandler.select(waitAudit);
						}else if(listType =="passed"){
							webFXTreeHandler.select(passed);
						}else{
							webFXTreeHandler.select(notPassed);
						}
					<% } %>
				} else{
					//会议纪要审核功能
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
						var all = new WebFXTree("all", "<fmt:message key='mtSummary.tree.all.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('audit','all');");
						var waitAudit = new WebFXTreeItem("waitAudit", "<fmt:message key='mtSummary.tree.waitAudit.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('audit','waitAudit');");
						setIcon(waitAudit);
						var passed = new WebFXTreeItem("audited", "<fmt:message key='mtSummary.tree.audited.lable' bundle='${v3xMeetingSummaryI18N}'/>", "javascript:showSummaryList('audit','audited');");
						setIcon(passed);
						all.add(waitAudit);
						all.add(passed);
						document.write(all);
						if(listType == "all"){
							webFXTreeHandler.select(all);
						}else if(listType == "waitAudit"){
							webFXTreeHandler.select(waitAudit);
						}else{
							webFXTreeHandler.select(passed);
						}
					<% } %>
				}
				<% } %>
			</script>
	  	</div>
	</body>
</html>