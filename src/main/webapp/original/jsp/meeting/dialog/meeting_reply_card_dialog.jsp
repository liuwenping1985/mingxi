<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	
	function showMeetingReplyCard() {
		$("div.replyCard").each(function() {
			var meetingId = $(this).attr("objectId");
			$(this).mouseover(function() {
				showMeetingCardDetail(meetingId, "pendingSection", $(this).attr("id"));
			});
			$(this).mouseleave(function() {
				mouseOutOfReply();
			});
		});
	}
	
	var replyCard, meetingReplyObj;
	function showMeetingCardDetail(meetingId, entityId, objectId) {
		var url = _ctxPath+"/meeting.do?method=showReplyCardDetail&entityId="+entityId+"&meetingId="+meetingId;
		if (replyCard) { replyCard.close(); }
		meetingReplyObj = $('#' + objectId);
		replyCard = $.dialog({
			id:'replyDetailDialog',
	        width: 260,
	        height: 180,
		    type: 'panel',
		    targetId: 'replyCard' + meetingId,
		    url: url,
			shadow:false,
			checkMax:false,
			transParams:{sectionId:'pendingSection', callbackOfPendingSection:closeAndFresh, pwindow:window},
			panelParam:{
				'show':false,
				'margins': false,
				'inside':true
			}
		});
	}
	
	function mouseOutOfReply(){
		if (replyCard) {
			var dialog = $("#" + replyCard.id+"_main").parent();
			var newid = $("#replyDetailDialog_main").find('iframe').attr("id");
			mouseBind(dialog, meetingReplyObj, replyCard, newid);
		}
	}
	
</script>
