<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
		<script>

		/** 审核列表 */
		function showList(url) {
			parent.listFrame.location.href = url;
		}
		
		</script>
</head>
<body style="border-right:1px solid #c7c7c7;">
	<div>
		<script type="text/javascript">
		function setIcon(obj){
			obj.icon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
			obj.openIcon = "<c:url value='/apps_res/meetingroom/images/openfoldericon.png'/>";
		}
			var from = "${v3x:escapeJavascript(param.from)}";
			var select = "${v3x:escapeJavascript(param.select)}";

				if(from == "add") {
					var add = new WebFXTree("add", "<fmt:message key='mr.tab.add' />", "");
					document.write(add);
					if(from=="add"){webFXTreeHandler.select(add);}
				}else if(from=="app"){//会议室登记
					var appMeetingRoom = new WebFXTree("appMeetingRoom", "<fmt:message key='mr.button.appMeetingRoom' />", "javascript:showList('meetingroom.do?method=createApp')");
					appMeetingRoom.icon = "<c:url value='/apps_res/meetingroom/images/app_meeting_room.png'/>";
					appMeetingRoom.openIcon = "<c:url value='/apps_res/meetingroom/images/app_meeting_room.png'/>";
					var yesApp = new WebFXTree("yesApp", "<fmt:message key='mr.tab.yesApp' />","javascript:showList('meetingroom.do?method=listMyApplication&flag=yesApp')");
					var waitReview = new WebFXTreeItem("waitReview", "<fmt:message key='mr.label.status.waitReview' />","javascript:showList('meetingroom.do?method=listMyApplication&flag=waitReview')");
					setIcon(waitReview);
					yesApp.add(waitReview);
					var passperm = new WebFXTreeItem("passperm", "<fmt:message key='mr.label.status.passperm' />", "javascript:showList('meetingroom.do?method=listMyApplication&flag=passperm')");
					setIcon(passperm);
					yesApp.add(passperm);
					var noReview = new WebFXTreeItem("noReview", "<fmt:message key='mr.label.status.noReview' />", "javascript:showList('meetingroom.do?method=listMyApplication&flag=noReview')");
					setIcon(noReview);
					yesApp.add(noReview);
					document.write(appMeetingRoom);
					document.write(yesApp);
					if(from=="app"){webFXTreeHandler.select(yesApp);}
				}else if(from=="perm"){//会议室审核
					var waitReview = new WebFXTree("waitReview", "<fmt:message key='mr.label.status.waitReview' />","javascript:showList('meetingroom.do?method=listPerm&flag=waitReview')");
					var passperm = new WebFXTree("passperm", "<fmt:message key='mr.label.status.passperm' />","javascript:showList('meetingroom.do?method=listPerm&flag=passperm')");
					var noReview = new WebFXTree("noReview", "<fmt:message key='mr.label.status.noReview' />","javascript:showList('meetingroom.do?method=listPerm&flag=noReview')");
					document.write(waitReview);
					document.write(passperm);
					document.write(noReview);
					if(from=="perm"){webFXTreeHandler.select(waitReview);}
				}else if(from=="myApp"){//会议室申请
					var appMeetingRoom = new WebFXTree("appMeetingRoom", "<fmt:message key='mr.button.appMeetingRoom' />", "javascript:showList('meetingroom.do?method=createApp')");
					appMeetingRoom.icon = "<c:url value='/apps_res/meetingroom/images/app_meeting_room.png'/>";
					appMeetingRoom.openIcon = "<c:url value='/apps_res/meetingroom/images/app_meeting_room.png'/>";
					var yesApp = new WebFXTree("yesApp", "<fmt:message key='mr.tab.yesApp' />", "javascript:showList('meetingroom.do?method=listMyApp&flag=yesApp')");
					var wait = new WebFXTreeItem("waitReview", "<fmt:message key='mr.label.status.waitReview' />","javascript:showList('meetingroom.do?method=listMyApp&flag=waitReview')");
					setIcon(wait);
					yesApp.add(wait);
					var pass = new WebFXTreeItem("passperm", "<fmt:message key='mr.label.status.passperm' />", "javascript:showList('meetingroom.do?method=listMyApp&flag=passperm')");
					setIcon(pass);
					yesApp.add(pass);
					var noReview = new WebFXTreeItem("noReview", "<fmt:message key='mr.label.status.noReview' />", "javascript:showList('meetingroom.do?method=listMyApp&flag=noReview')");
					setIcon(noReview);
					yesApp.add(noReview);
					document.write(appMeetingRoom);
					document.write(yesApp);
					if(select==null || select==undefined || select=="" ){
						select = "wait";
					} 
					if(select=='passperm'){
						pass.select();
					}else if(select=='wait'){
						wait.select();
					}else if(from=="myApp"){webFXTreeHandler.select(yesApp);}
				}
		</script>
	</div>
</body>
</noframes>
</html>