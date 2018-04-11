<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Insert title here</title>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
		<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
		<script>
			/**
			 * 显示列表
			 */
			function showToReceiveList(listType){
				parent.listFrame.location.href = "exchangeEdoc.do?method=listRecieve&edocType=${edocType}&listType="+listType;
			}
			/**
			* 显示会议权限
			*/
			function showMeetingList(){
				parent.listFrame.location.href = "${mtAdminController}?method=showEdocSendSet";
			}
			/**
			* 显示会议管理员
			*/
			function showMeetingRoom(){
				parent.listFrame.location.href = "${mtAdminController}?method=listMeetingRoom";
			}
		</script>
	</head>
	<body>
		<div>
			<script type="text/javascript">
				var from = "${param.from==null||param.from eq ''?'Permissions':(param.from)}";//（默认先跳转到会议通知，申请功能完成后改到会议申请）
				var stateStr="${param.stateStr}";

				if(from=='Permissions'){  //权限设置
					var listAuditing1 = new WebFXTree("listApp1", "<fmt:message key='mt.mtMeeting.right.set'/>", "javascript:showMeetingList()");
					var listAuditing2 = new WebFXTree("listApp2", "<fmt:message key='mt.mtMeeting.Meeting.Room.label'/>", "javascript:showMeetingRoom()");
					document.write(listAuditing1);
					document.write(listAuditing2);
					webFXTreeHandler.select(listAuditing1);
				}

			</script>
	  	</div>
	</body>
</html>