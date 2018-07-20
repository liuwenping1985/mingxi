<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<script type="text/javascript">

//这个参数只是一个标记，用于子页面调用
window.meeting_report_main_frame_flag = "true";

var _url = "${meetingURL }?method=listMeetingByReportIframe&status=${param.status}&statType=${param.statType}&fieldType=${param.fieldType}&time=${param.time}&end_time=${param.end_time }&userid=${param.userid }&start_time=${param.start_time }&user_id=${param.user_id }&enddate=${param.enddate }&begindate=${param.begindate }&reportId=${param.reportId }&reportName=";

_url+= encodeURIComponent("${param.reportName}");
window.onload = function(){
	document.getElementById("listFrame").src = _url;
}
</script>
</head>

<frameset  rows="*" cols="100%" frameBorder="1"  frameSpacing="5" bordercolor="#ececec">
	
	<!-- 列表 -->
	<frameset rows="30%,70%" id='sx' cols="*" framespacing="3" frameborder="no" border="0" >
		<frame frameborder="no" src="" name="listFrame" scrolling="no" id="listFrame" />
        <c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
        </c:if>
	</frameset>
</frameset>

</html>

