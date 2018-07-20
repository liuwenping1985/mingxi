<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
var meetingTitle = "${ctp:i18n('meeting.cmp.title')}";
var dialogDealColl;
function openMeeting(meetingId, sectionId){
  	var _url = _ctxPath+"/mtMeeting.do?method=myDetailFrame&id=" + meetingId;
	dialogDealColl = getA8Top().v3x.openWindow({
        url: _url,
        FullScrean: 'yes',
        dialogType: 'open',
        title: meetingTitle
    });
}

function closeAndFresh(sectionId){
    dialogDealColl.close();
    parent.parent.sectionHandler.reload("pendingSection",true);
}

</script>
</head>
<c:set var="width" value="240"></c:set>
<%-- <c:if test="${fn:length(joinList)>6 or fn:length(waitJoinList)>6}">
	<c:set var="width" value="224"></c:set>
</c:if> --%>
<body class="h100b cardmini" scroll="no" style="background-color:#ffffbb">
	<div id="replayPersonsdetail" class="font_size12 adapt_w font_size12 form_area people_msg"  style="height:200px;overflow-x:visible;overflow:auto;">
		<table height="100%" width="${width}" cellpadding="0" cellspacing="0">
			<tr height="20" align="center" ><td colspan="2"><font color="black">${ctp:i18n('meeting.replycard.count.all')}:${fn:length(allList) } ${ctp:i18n('meeting.replycard.count.notJoin')}:${fn:length(notJoinList) } </font></td></tr>
			<tr height="20" align="center" >
				<td width="110" class="border_tb border_r"><font color="black">${ctp:i18n('meeting.replycard.people.join')}:${fn:length(joinList) } ${ctp:i18n('meeting.replycard.people.label')}</font></td>
				<td width="110" class="border_tb"><font color="black">${ctp:i18n('meeting.replycard.people.waitJoin')}:${fn:length(waitJoinList) } ${ctp:i18n('meeting.replycard.people.label')}</font></td>
			</tr>
			
			<tr height="150">
				<td valign="top" class="border_r" style="padding-left:25px;" width="${width/2}">
					<c:if test="${empty joinList}">
						<li class="margin_t_5" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">&nbsp;</li>
					</c:if>
					<c:set value="false" var="isShowDetail" />
					<c:forEach var="user1" items="${joinList}" varStatus="status1">
						<c:choose>
                          	<c:when test="${status1.count>6 }">
                            	<c:if test="${status1.last}"><c:set value="true" var="isShowDetail" /><font color="black">……</font></c:if>
                          	</c:when>
                          	<c:otherwise><li class="margin_t_5" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis; margin-left:-20px;"><span class="ico16 margin_l_5 participate_16"></span><font title="${v3x:showMemberName(user1.memberId)}" color="black">${v3x:showMemberName(user1.memberId)}</font></li>
                          	</c:otherwise>
                        </c:choose>
					</c:forEach>
				</td>
				
				<td valign="top" style="padding-left:25px;" width="${width/2}">
					<c:if test="${empty waitJoinList}">
						<li class="margin_t_5" style="text-align:left;width: 90px; height:130px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">&nbsp;</li>
					</c:if>
					<c:forEach  var="user2" items="${waitJoinList}" varStatus="status2">
						<c:choose>
                          	<c:when test="${user2.subState=='32' }">
                          		<c:set value="ico16 unparticipate_16" var="viewClass" />	
                          	</c:when>
                          	<c:when test="${user2.subState=='33' }">
                          		<c:set value="ico16 determined_16" var="viewClass" />
                          	</c:when>
                          	<c:when test="${user2.subState=='12' }">
                          		<c:set value="ico16 viewed_16" var="viewClass" />
                          	</c:when>
                          	<c:otherwise>
                          		<c:set value="ico16 unviewed_16" var="viewClass" />
                          	</c:otherwise>
                        </c:choose>
                        <c:choose>
                          	<c:when test="${status2.count>6 }">
                            	<c:if test="${status2.last}"><c:set value="true" var="isShowDetail" /><font color="black">……</font></c:if>
                          	</c:when>
                         	<c:otherwise>
                         		<li class="margin_t_5" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis; margin-left:-15px;"><span class="${viewClass }"></span><font title="${v3x:showMemberName(user2.memberId)}" color="black">${v3x:showMemberName(user2.memberId)}</font></li>
                          	</c:otherwise>
                        </c:choose>
					</c:forEach>
					<c:if test="${!(empty waitJoinList)}">
						<c:set value="${6-(fn:length(waitJoinList))}" var="len" />
						<c:if test="${len > 0}">
							<c:forEach begin="1" end="${len }">
								<li class="margin_t_5" style="text-align:left;width: 90px; height:16px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;"></li>	
							</c:forEach>
						</c:if>
					</c:if>
					<c:if test="${isShowDetail }">
                        <a class="right" style="padding-right:10px;" href="javascript:openMeeting('${param.meetingId }','${param.entityId }')"><font color="black">${ctp:i18n('meeting.replycard.detail')}</font></a>
                   </c:if>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>