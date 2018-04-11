<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<%@ include file="header.jsp" %>
<script type="text/javascript">	
showCtpLocation("F09_meetingRoom");	
function setDefaultTab_MeetingRoom(pos) {
	if(${param.flag=="yesApp"||param.flag=="all"}) {
		pos = 1;
	}
	var menuDiv = document.getElementById("menuTabDiv");
	
	var index = 0;
	var spans = menuDiv.getElementsByTagName("span");
	if(spans.length > 2) {//会议室管理员
		if(spans[pos] && spans[pos].className) {
			index = pos;
		}
	} else {//非会议室管理员
		index = spans.length - 1;
	}
	
	if(spans[index].className) {
		spans[index].getElementsByTagName("div")[1].className = spans[index].getElementsByTagName("div")[1].className + "-sel";
	}
	
	var detailIframe = document.getElementById('detailIframe').contentWindow;
	detailIframe.location.href = spans[index].getElementsByTagName("div")[1].getAttribute("url");
	
}
</script>
</head>

<body onload="setDefaultTab_MeetingRoom('${top}');onLoadLeft()" onunload="unLoadLeft()" class="tab-body" scroll="no">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
	<td valign="bottom" height="30" style="padding-bottom:0px;" class="tab-tag">
					
		<div id="menuTabDiv" class="div-float" style="margin-bottom: -2px;">
					
			<c:set value="waitReview" var="flag" />
					
			<div class="tab-separator"></div>

			<%-- 申请会议室 resCode="F09_meetingRoomApp" --%>
			<c:if test="${ctp:hasResourceCode('F09_meetingRoomApp') == true}">
				<span class="resCode">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" style="border-bottom:0px;" onclick="javascript:changeMenuTab(this);" url="${mrUrl }?method=app&flag=createApp"><fmt:message key='mr.button.appMeetingRoom'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</span>
			</c:if>
			
			<%-- 已申请会议室 resCode="F09_meetingRoomRevoke" --%>
			<c:if test="${ctp:hasResourceCode('F09_meetingRoomRevoke') == true}">
				<span class="resCode">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" style="border-bottom:0px;" onclick="javascript:changeMenuTab(this);" url="${mrUrl }?method=cancel&flag=${flag}"><fmt:message key='meeting.room.apped.cancel'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</span>
			</c:if>
		
			<%-- 会议室申审核  resCode="F09_meetingRoomPerm" --%>
			<c:set value="" var="permFlag"></c:set>
			<c:if test="${ctp:hasRoleName('MeetingRoomAdmin') == true}">
				<span class="resCode">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" style="border-bottom:0px;" onclick="javascript:changeMenuTab(this);" url="${mrUrl }?method=perm&flag=${permFlag}"><fmt:message key='mr.tab.review'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</span>
			</c:if>
			
			<%-- 会议室登记 resCode="F09_meetingRoomAdd" --%>
			<c:if test="${ctp:hasRoleName('MeetingRoomAdmin') == true}">
				<span class="resCode">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" style="border-bottom:0px;" onclick="javascript:changeMenuTab(this);" url="${mrUrl }?method=add"><fmt:message key="mr.tab.add"/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</span>
			</c:if>
								
			<%-- 使用统计 resCode="F09_meetingRoomStat" --%>
			<c:if test="${ctp:hasRoleName('MeetingRoomAdmin') == true}">
				<span class="resCode">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" style="border-bottom:0px;" onclick="javascript:changeMenuTab(this);" url="${mrUrl }?method=total"><fmt:message key="mr.tab.total"/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</span>
			</c:if>

		</div>
					
		<%@ include file="/WEB-INF/jsp/migrate/checkResource.jsp" %>
					
	</td>
</tr>

<tr>
	<td colspan="2" class="tab-body-bg border-top" style="margin: 0px; padding:0px; border-left:0px;">
		<iframe id="detailIframe" name="detailIframe" width="100%" scrolling="no" height="100%" border="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
	</td>
</tr>
</table>

</body>
</html>




