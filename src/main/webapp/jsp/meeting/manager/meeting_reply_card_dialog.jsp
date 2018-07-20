<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">

	function showMeetingReplyCard2() {
		$("div.replyCard").each(function() {
			
			var objectId = $(this).attr("objectId"); 
			
			$(this).mouseover(function() {
		        var requestCaller = new XMLHttpRequestCaller(this, "replyManager", "getJoinMeetingAffair", false);
				requestCaller.addParameter(1, "String", objectId);
				var jsonObj = requestCaller.serviceRequest();
				if(jsonObj != null ) {
					var list = $.parseJSON(jsonObj);
	            	var allList = new ArrayList();
	            	var joinList = new ArrayList();
	            	var notJoinList = new ArrayList();
	            	var waitJoinList = new ArrayList();
	            	
	            	for(var i=0; i<list.length; i++) {
	            		if(list[i].replyState==10) {//不参加
	            			notJoinList.add(list[i]);
							waitJoinList.add(list[i]);
	            		} else {
							if(list[i].replySubState==31) {
								joinList.add(list[i]);
							} else if(list[i].replySubState==32) {//不参加
								waitJoinList.add(list[i]);
							} else if(list[i].replySubState==33) {//待定
								waitJoinList.add(list[i]);
							} else {
								waitJoinList.add(list[i]);//未查看+已查看
							}
						}		            		
	            		allList.add(list[i]);
	            	}
	            	
	            	$("#joinTable").html('');
	            	$("#waitJoinTable").html('');
	            	$("#joinTable").append('<tr><td valign="top">参加:<span id="joinCount"></span></td></tr>');
	            	$("#waitJoinTable").append('<tr><td valign="top">待回执:<span id="waitJoinCount"></span></td></tr>');
	            	
	            	$("#allCount").html(allList.size());
	            	$("#joinCount").html(joinList.size());
	            	$("#notJoinCount").html(notJoinList.size());
	            	$("#waitJoinCount").html(waitJoinList.size());
	            	
	            	var maxLen = 4;
	            	for(var i=0; i<joinList.size(); i++) {
	            		var replyClass = "ico16 margin_l_5 left participate_16";
	            		//$("#joinTable").append("<tr isMore='"+(i>maxLen)+"'><td width='100%' valign='middle'><span class='"+replyClass+"'></span>"+joinList.get(i).userName+"</td></tr>");
	            		$("#joinTable").append("<tr><td width='100%' valign='middle'><span title='参加' class='"+replyClass+"'></span>"+joinList.get(i).userName+"</td></tr>");
					}
	            	
	            	for(var i=0; i<waitJoinList.size(); i++) {
	            		var replyClass = "ico16 unviewed_16";//未查看
	            		var replyTitle = "未查看"
						if(waitJoinList.get(i).replySubState == 32) {//不参加
							replyClass = "ico16 unparticipate_16";
							replyTitle = "不参加";
						} else if(waitJoinList.get(i).replySubState == 33) {//待定
							replyClass = "ico16 determined_16";
							replyTitle = "待定";
						} else if(waitJoinList.get(i).replySubState == 12) {//已读
							replyClass = "ico16 viewed_16";
							replyTitle = "未回执";
						}
	            		$("#waitJoinTable").append("<tr><td width='100%' valign='middle'><span title='"+replyTitle+"' class='"+replyClass+"'></span>"+waitJoinList.get(i).userName+"</td></tr>");
	            		//$("#waitJoinTable").append("<tr isMore='"+(i>maxLen)+"'><td width='100%' valign='middle'><span class='"+replyClass+"'></span>"+waitJoinList.get(i).userName+"</td></tr>");
				    }
	            	
	            	/** 屏蔽掉更多按钮
					$("tr[isMore='true']").each(function(i) {
						$(this).hide();
					});**/
	            	
	            	var panel = $.dialog({
	    				id:'replyPanel',
	    			    width: 300,
	    			    height: 150,
	    			    type: 'panel',
	    			    htmlId: 'meetingReplyCard',
	    			    targetId: 'replyCard'+objectId,
	    				shadow:false
	    			});
	    			$("#replyPanel").mouseleave(function() {
	    				panel.close();
	    			});
				}
			});
		});
		
		/** 屏蔽掉更多按钮
		$("#moreReply").click(function() {
			if($("#moreReply").attr("showAll")=="false") {
				$("#moreReply").attr("showAll", "true");
				$("#joinTable").find("tr[isMore='true']").each(function(i) {
					$(this).show();
				});
				$("#waitJoinTable").find("tr[isMore='true']").each(function(i) {
					$(this).show();
				});
			} else {
				$("#moreReply").attr("showAll", "false");
				$("#joinTable").find("tr[isMore='true']").each(function(i) {
					$(this).hide();
				});
				$("#waitJoinTable").find("tr[isMore='true']").each(function(i) {
					$(this).hide();
				});
			}
		});**/
	}

	
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
		meetingReplyObj = $('#replyCard' + objectId);
		replyCard = $.dialog({
			id:'replyDetailDialog',
	        width: 260,
	        height: 200,
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
			var dialog = $("#" + replyCard.id);
			mouseBind(dialog, meetingReplyObj, replyCard, "meetingReplyDetailDialog");
		}
	}
	
</script>
</head>

<body scroll="no">
<%--
	<div id="meetingReplyCard" class="h100b" style="display:none">
	<div class="h100b over_auto">
		<table border="1" width="100%" height="100%">
		<thead>
			<tr>
				<td height="30" colspan="2" >
					会议总人数:<span id="allCount"></span>
					不参加人数:<span id="notJoinCount"></span>
				</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td width="50%">
					<table border="0" id="joinTable">
					</table>
				</td>
				<td width="50%">
					<table border="0" id="waitJoinTable">
					</table>
				</td>
			</tr>
			<!-- 屏蔽掉更多按钮
			<tr>
				<td height="30" colspan="2" align="right">更多<a id="moreReply" showAll="false" href="javascript:void">>></a></td>
			</tr>
			 -->
		</tbody>
	</table>
	</div>
</div>
 --%>
</body>
</html>