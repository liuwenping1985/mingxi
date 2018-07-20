<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function changeMenuTab(clickDiv)
{
  var menuDiv=document.getElementById("menuTabDiv");
  var clickDivStyle=clickDiv.className;
  var divs=menuDiv.getElementsByTagName("div");
  var i;
  for(i=0;i<divs.length;i++)
  {    
    clickDivStyle=divs[i].className;    
    if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
    {       
        divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
    }       
  }
  for(i=0;i<divs.length;i++)
  {
        if(clickDiv==divs[i])
        {
          divs[i-1].className=divs[i-1].className+"-sel";
          divs[i].className=divs[i].className+"-sel";
          divs[i+1].className=divs[i+1].className+"-sel";
        }    
  }
  var detailIframe=document.getElementById('detailIframe').contentWindow;
  detailIframe.location.href=clickDiv.getAttribute('url');
}
</script>
</head>
<body scroll="no" class="padding5"  onload="onLoadLeft()" onunload="unLoadLeft()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" height="30" style="padding-bottom:2px;" class="tab-tag  ">
			<div id="menuTabDiv" class="div-float">
			
			<c:set value="${param.from }" var="from" />
			
			<%-- 权限设置--%>
			<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
				<span class="resCode" resCode="F03_meetingRight">
					<div class="${param.from=='Permissions'?'tab-tag-left-sel':'tab-tag-left'}"></div>
					<div class="${param.from=='Permissions'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listBasedataMain&from=Permissions"><fmt:message key="mt.mtMeeting.Permissions.label" /></div>
					<div class="${param.from=='Permissions'?'tab-tag-right-sel':'tab-tag-right'}"></div>
				</span>
			<% } %>
			
			<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
				<c:set value="listBasedataMain" var="listMethod" />
				
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_APP || com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEADER) { %>
					<span class="resCode" resCode="F03_meetingRightSet">
						<div class="${param.from=='Permissions'||param.from==null?'tab-tag-left-sel':'tab-tag-left'}"></div>
						<div class="${param.from=='Permissions'||param.from==null?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listBasedataMain&from=Permissions"><fmt:message key="mt.mtMeeting.right.set" /></div>
						<div class="${param.from=='Permissions'||param.from==null?'tab-tag-right-sel':'tab-tag-right'}"></div>
					</span>
				<% } else { %>
					<c:set value="listMeetingResource" var="from" />
				<% } %>
                <span class="resCode" resCode="F03_meetingRoomAdmin">
                <!-- suyu add -->
                    <div class="tab-separator"></div>
                    <div class="${from=='listMeetingResource'?'tab-tag-left-sel':'tab-tag-left'}"></div>
                    <div class="${from=='listMeetingResource'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listBasedataMain&from=listMeetingResource"><fmt:message key="mt.mtMeeting.Meeting.Resource.label" /></div>
                    <div class="${from=='listMeetingResource'?'tab-tag-right-sel':'tab-tag-right'}"></div>
                    <div class="tab-separator"></div>
                </span>
                
                <%-- 分类维护 --%>
            <% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
                <c:set value="${param.from=='auditing' }" var="meetingTypeSelected" />
                <% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
                    <c:set value="${param.from=='auditing'||param.from==null }" var="meetingTypeSelected" />
                <% } %>
                <span class="resCode" resCode="F03_meetingType">
                    <div class="tab-separator"></div>
                    <div class="${meetingTypeSelected? 'tab-tag-left-sel':'tab-tag-left'}"></div>
                    <div class="${meetingTypeSelected? 'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listMeetingTypeMain&from=meetingtype"><fmt:message key="mt.mtMeeting.classification.label" /></div>
                    <div class="${meetingTypeSelected? 'tab-tag-right-sel':'tab-tag-right'}"></div>
                    <div class="tab-separator"></div>
                </span>
            <% } %>
                
                <c:if test="${isA6s eq 'false'}">
					<span class="resCode" resCode="F03_meetingRoomAdmin">
						<div class="tab-separator"></div>
						<div class="${from=='listMeetingRoomAdmin'?'tab-tag-left-sel':'tab-tag-left'}"></div>
						<div class="${from=='listMeetingRoomAdmin'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listBasedataMain&from=listMeetingRoomAdmin"><fmt:message key="mt.mtMeeting.Meeting.Room.label" /></div>
						<div class="${from=='listMeetingRoomAdmin'?'tab-tag-right-sel':'tab-tag-right'}"></div>
						<div class="tab-separator"></div>
					</span>
				</c:if>
			<% } %>

			
			<%-- 根据需求，先屏蔽会议纪要模板
			<div class="tab-separator"></div>
			<div class="${param.from=='notice'?'tab-tag-left-sel':'tab-tag-left'}"></div>
			<div class="${param.from=='notice'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="${mtAdminController}?method=listMain&from=notice"><fmt:message key="mt.mtMeeting.Meeting.Minutes.label" /></div>
			<div class="${param.from=='notice'?'tab-tag-right-sel':'tab-tag-right'}"></div>
			<div class="tab-separator"></div>--%>
			</div>
			
			<%-- <%@ include file="/WEB-INF/jsp/migrate/checkResource.jsp" %> --%>
			
		</td>
	</tr>

	<tr>
		<td class="">
			<iframe src="${mtAdminController}?method=${listMethod==null?'listMeetingTypeMain':listMethod }&from=${from}&stateStr=${param.stateStr}" noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>		
			<%-- <script type="text/javascript">
				if($("span.resCode")!=null) {
					var showCount = 0;
					for(var i=0; i<$("span.resCode").length; i++) {
						var span = $("span.resCode").eq(i);
						if(span[0].style.display!='none') {
							showCount++;
						}
					}
					if(showCount == 0) {
						$("#detailIframe").attr("src", "");
					}
				}
			</script> --%>
		</td>
	</tr>
</table>

</body>
</html>
