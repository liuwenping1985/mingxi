<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<!DOCTYPE html>
<html style="height: 100%;width: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="../include/meeting_header.jsp" %>
<script type="text/javascript">
function meetingListDetail(url) {
	location.href = url;
}
</script>

</head>

<body scroll='no' onload="" style="height: 100%;width: 100%;">
	<iframe src="meetingNavigation.do?method=main&listMethod=${v3x:toHTML(param.listMethod)}&listType=${v3x:toHTML(param.listType)}&meetingNature=${v3x:toHTML(param.meetingNature )}&sendType=${v3x:toHTML(sendType)}&mtAppId=${v3x:toHTML(mtAppId)}&meetingId=${v3x:toHTML(param.meetingId )}&summaryId=${v3x:toHTML(param.summaryId)}&affairId=${v3x:toHTML(param.affairId)}&collaborationFrom=${v3x:toHTML(param.collaborationFrom)}&formOper=${v3x:toHTML(param.formOper)}&moduleTypeFlag=${v3x:toHTML(param.moduleTypeFlag)}&portalRoomAppId=${v3x:toHTML(param.portalRoomAppId)}&projectId=${v3x:toHTML(param.projectId)}&time=${fn:escapeXml(param.time)}" noresize="noresize" frameborder="no" id="mainIframe" name="mainIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
</body>

</html>
