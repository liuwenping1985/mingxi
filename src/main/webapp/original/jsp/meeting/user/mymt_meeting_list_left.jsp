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
			//function showToReceiveList(listType){
			//	parent.listFrame.location.href = "exchangeEdoc.do?method=listRecieve&edocType=${edocType}&listType="+listType;
			//}
			
		</script>
	</head>
	<body>
		<div>
			<script type="text/javascript">
				var from = "${param.from==null||param.from eq ''?'publish':(param.from)}";
				var stateStr="${param.stateStr}";
				//我发起的会议
				if(from=="publish"){
					var meeting1 = new WebFXTree("meeting1", v3x.getMessage("meetingLang.meeting_status_not"), "");
					var meeting2 = new WebFXTree("meeting2", v3x.getMessage("meetingLang.meeting_status_already"), "");

					document.write(meeting1);
					document.write(meeting2);

					webFXTreeHandler.select(meeting1);
			
				//我参加的会议
				} else if(from == "join") {
					var meeting1 = new WebFXTree("meeting1", v3x.getMessage("meetingLang.meeting_status_not"), "");
					var meeting2 = new WebFXTree("meeting2", v3x.getMessage("meetingLang.meeting_status_already"), "");

					document.write(meeting1);
					document.write(meeting2);

					webFXTreeHandler.select(meeting1);

				} 
			</script>
	  	</div>
	</body>
</html>