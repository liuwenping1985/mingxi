<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/WebContent/common/js/src/ArrayList.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=replyManager"></script>
<script type="text/javascript">

	function showMeetingReplyCard() {
		$("div.replyCard").each(function() {
			
			var objectId = $(this).attr("objectId"); 
			
			$(this).mouseover(function() {
		        var replyAjax = new replyManager();
		        replyAjax.getJoinMeetingAffair(objectId, {
		            success: function(jsonObj) {
					
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
		            	var key0 = v3x.getMessage("meetingLang.meeting_attend_state1");
		            	$("#joinTable").append('<tr><td valign="top">'+key0+':<span id="joinCount"></span></td></tr>');
		            	var key1 = v3x.getMessage("meetingLang.meeting_attend_state5");
		            	$("#waitJoinTable").append('<tr><td valign="top">'+key1+':<span id="waitJoinCount"></span></td></tr>');
		            	
		            	$("#allCount").html(allList.size());
		            	$("#joinCount").html(joinList.size());
		            	$("#notJoinCount").html(notJoinList.size());
		            	$("#waitJoinCount").html(waitJoinList.size());
		            	
		            	var maxLen = 4;
		            	for(var i=0; i<joinList.size(); i++) {
		            		var replyClass = "ico16 margin_l_5 left handled_16 meeting_replay_1 ";
		            		$("#joinTable").append("<tr isMore='"+(i>maxLen)+"'><td width='100%' valign='middle'><span class='"+replyClass+"'></span>"+joinList.get(i).userName+"</td></tr>");
						}
		            	
		            	for(var i=0; i<waitJoinList.size(); i++) {
		            		
		            		var replyClass = "ico16 margin_l_5 left handling_of_16";//未读
							if(waitJoinList.get(i).replyState==10) {//不参加
								replyClass = "ico16 margin_l_5 left termination_16";
							} else {
								if(waitJoinList.get(i).replySubState == 32) {//不参加
									replyClass = "ico16 margin_l_5 left termination_16";
								} else if(waitJoinList.get(i).replySubState == 33) {//待定
									replyClass = "ico16 margin_l_5 left temporary_to_do_16 pending13_16 meeting_replay_-1";
								} else if(waitJoinList.get(i).replySubState == 12) {//已读
									replyClass = "view_unhandled_16 meeting_look_1";
								}
							}
		            		$("#waitJoinTable").append("<tr isMore='"+(i>maxLen)+"'><td width='100%' valign='middle'><span class='"+replyClass+"'></span>"+waitJoinList.get(i).userName+"</td></tr>");
					    }
		            	
						$("tr[isMore='true']").each(function(i) {
							$(this).hide();
						});
		            	
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
		});
		
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
		});
	}

	
	
</script>
</head>
<body scroll="auto">

	<div id="meetingReplyCard" class="h100b" style="display:none">
	<div class="h100b over_auto">
		<table border="1" width="100%" height="100%">
		<thead>
			<tr>
				<td height="30" colspan="2" >
					<fmt:message key='meeting.count.all'/>:<span id="allCount"></span>
					<fmt:message key='meeting.count.notAttend'/>:<span id="notJoinCount"></span>
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
			<tr>
				<td height="30" colspan="2" align="right"><fmt:message key='meeting.create.more'/><a id="moreReply" showAll="false" href="javascript:void">>></a></td>
			</tr>
		</tbody>
	</table>
	</div>
</div>

</body>
</html>