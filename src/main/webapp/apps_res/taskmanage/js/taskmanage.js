try {
	getA8Top().endProc();
} catch (e) {
	// -> Ignore
}
function switchDateSelect(checkBoxObj) {
	var fullday = checkBoxObj.checked == true;
	var datetype = fullday ? 'date' : 'datetime';
	var ps = $('#plannedStartTime').val();
	var pe = $('#plannedEndTime').val();
	var psv = ps != '' ? (fullday ? ps.substring(0, 10) : (ps + " 00:00")) : '';
	var pev = pe != '' ? (fullday ? pe.substring(0, 10) : (pe + " 00:00")) : '';
	$("#plannedStartTime_td").html("<input type='text' name='plannedStartTime' id='plannedStartTime'" + 
						" class='input-80per cursor-hand' onclick=\"whenstart('" + v3x.baseURL + "', this, 575, 140, '" + datetype + "', false);\" readonly='true' " +
						" inputName='" + input_begindate + "' validate='notNull' value='" + psv + "' />");

	$("#plannedEndTime_td").html("<input type='text' name='plannedEndTime' id='plannedEndTime'" + 
			" class='input-80per cursor-hand' onclick=\"whenstart('" + v3x.baseURL + "', this, 575, 140, '" + datetype + "', false);\" readonly='true' " +
			" inputName='" + input_enddate + "' validate='notNull' value='" + pev + "' />");
	if(showActualTime == true) {
		var as = $('#actualStartTime').val();
		var ae = $('#actualEndTime').val();
		var asv = as != '' ? (fullday ? as.substring(0, 10) : (as + " 00:00")) : '';
		var aev = ae != '' ? (fullday ? ae.substring(0, 10) : (ae + " 00:00")) : '';
		$("#actualStartTime_td").html("<input type='text' name='actualStartTime' id='actualStartTime'" + 
						" class='input-80per cursor-hand' onclick=\"whenstart('" + v3x.baseURL + "', this, 575, 140, '" + datetype + "', false);\" readonly='true' " +
						" inputName='" + input_begindate + "' value='" + asv + "' />");

		$("#actualEndTime_td").html("<input type='text' name='actualEndTime' id='actualEndTime'" + 
				" class='input-80per cursor-hand' onclick=\"whenstart('" + v3x.baseURL + "', this, 575, 140, '" + datetype + "', false);\" readonly='true' " +
				" inputName='" + input_enddate + "' value='" + aev + "' />");
	}
}
function parse2Date(s) {
	return Date.parse(s.replace(/\-/g, '/'));
}
function checkAddTask(taskInfoForm) {
	if(compareDate(document.getElementById('plannedStartTime').value, document.getElementById('plannedEndTime').value) > 0) {
		alert(v3x.getMessage('TaskManage.planned_start_later_than_end'));
		return false;
	}
	if(document.getElementById('parentTaskId').value!="" && addTask=="true"){
		var len = document.getElementById('plannedStartTime').value.length;
		if(compareDate(projectStartDataTime.substring(0,len),document.getElementById('plannedStartTime').value) > 0) {
			alert(v3x.getMessage('TaskManage.child_planned_start_earlier_than_parent'));
			return false;
		}	
		if(compareDate(document.getElementById('plannedEndTime').value,projectEndDataTime.substring(0,len)) > 0) {
			alert(v3x.getMessage('TaskManage.child_planned_end_later_than_parent'));
			return false;
		}
	}
	var duration = (parse2Date($('#plannedEndTime').val()) - parse2Date($('#plannedStartTime').val())) / (1000 * 60);
	var endRemindTime = $('#remindEndTime').val();
	if(endRemindTime >= duration) {
		alert(v3x.getMessage('TaskManage.invalid_end_remind', duration, endRemindTime));
		return false;
	}
	
	if(showActualTime == true) {
		if(compareDate(document.getElementById('actualStartTime').value, document.getElementById('actualEndTime').value) > 0) {
			alert(v3x.getMessage('TaskManage.actual_start_later_than_end'));
			advancedSetting($('#taskId').val(), $('#flag').val());
			return false;
		}
	}
	
	if(!checkForm(taskInfoForm)) {
		return false;
	}
	
	// 负责人修改负责人时，只允许增加，不允许减少
	if(isManager) {
		var oldManagers = document.getElementById('oldManagers').value;
		var newManagers = document.getElementById('managers').value;
		var oldManagerIdArr = oldManagers.split(',');
		if(oldManagerIdArr && oldManagerIdArr.length > 0) {
			for(var i = 0; i < oldManagerIdArr.length; i++) {
				if(newManagers.indexOf(oldManagerIdArr[i]) == -1) {
					alert(v3x.getMessage('TaskManage.no_auth_reduce_managers'));
					return false;
				}
			}
		}
	}
	
	if($('#plannedTaskTime').val().trim() == '') {
		$('#plannedTaskTime').val(0);
	}
	
	if(document.getElementById('actualTaskTime')) {
		if($('#actualTaskTime').val().trim() == '') {
			$('#actualTaskTime').val(0);
		}
	}
	
	if($('#finishRate').val().trim() == '') {
		$('#finishRate').val(0);
	}
	
	saveAttachment();
	
	document.getElementById("submitBtn").disabled = true;
	document.getElementById("cancelBtn").disabled = true;
	startProcManual(v3x.getMessage("TaskManage.submit_info"));
    return true;
}
function endModifyTask() {
	if(parent.$('#msgFlag').val() != 'true') {
		parent.getA8Top().returnValue = true;
		parent.getA8Top().close();
	}
}
function decomposeTask(parentTaskId) {
	var url = taskManageUrl + '?method=addTaskPageFrame&from=Decompose&parentTaskId=' + parentTaskId;
	var ret = v3x.openWindow({
		url : url,
		width	: 600,
		height	: 550,
		resizable	: "false"
	});
	if(ret == true || ret == 'true') {
		taskAddCount += 1;
	}
}
function resetProps() {
	if(!window.confirm(v3x.getMessage('TaskManage.reset_properties'))) {
		return false;
	}
	defaultProps();
}
function defaultProps() {
	document.getElementById('subject').value = '';
	document.getElementById('plannedEndTime').value = '';
	var now = new Date();
	document.getElementById('plannedStartTime').value = now.format('yyyy-MM-dd');
	document.getElementById('fullTime').click();
	document.getElementById('remindStartTime').value = -1;
	document.getElementById('remindEndTime').value = -1;
	document.getElementById('managersName').value = '';
	document.getElementById('managers').value = '';
	document.getElementById('participatorsName').value = '';
	document.getElementById('participators').value = '';
	
	// 避免重置之后，选人界面仍保留了原先记录
	showOriginalElement_managersSP = false;
	showOriginalElement_participatorsSP = false;
	
	document.getElementById('content').value = '';
	document.getElementById('importantLevel').value = 1;
	document.getElementById('status').value = 1;
	document.getElementById('plannedTaskTime').value = '';
	document.getElementById('riskLevel').value = 0;
	document.getElementById('finishRate').value = '';
}
function defaultFullTime() {
	if(document.getElementById('from').value == 'Project') {
		document.getElementById('plannedStartTime').value = document.getElementById('projectBeginTime').value;
		document.getElementById('plannedEndTime').value = document.getElementById('projectEndTime').value;
	}else if(document.getElementById('from').value == 'timing' && document.getElementById('timing').value != "") {
		document.getElementById('plannedStartTime').value = document.getElementById('timing').value;
	}else {
		var now = new Date();
		document.getElementById('plannedStartTime').value = now.format('yyyy-MM-dd');
	}
	document.getElementById('fullTime').click();
	document.getElementById('managersName').value = currentUserName;
	document.getElementById('managers').value = currentUserId;
}
function checkAddTaskFeedback(taskFeedbackForm) {
	if(!checkForm(taskFeedbackForm)) {
		return false;
	}
	saveAttachment();
	document.getElementById("submitBtn").disabled = true;
	document.getElementById("cancelBtn").disabled = true;
	startProcManual(v3x.getMessage("TaskManage.submit_info_feedback"));
	return true;
}
function setSearchPeopleFields(elements, namesId, valueId) {
	document.getElementById(valueId).value = getIdsString(elements, false);
	document.getElementById(namesId).value = getNamesString(elements);
	document.getElementById(namesId).title = getNamesString(elements);
}
function deleteTasks() {
	var result = getSelectId(v3x.getMessage("TaskManage.pls_select_records"));
	if(result == false) {
		return false;
	}
	
	var requestCaller = new XMLHttpRequestCaller(this, "taskInfoManager", "checkIfChildExist", false);
		requestCaller.addParameter(1, "String", result);
	var ret = requestCaller.serviceRequest();
	var key = ret == true || ret == "true" ? 'confirm_delete_contain_childs' : 'confirm_delete';
	
	if(confirm(v3x.getMessage("TaskManage." + key))) {
		window.location.href = taskManageUrl + '?method=deleteTasks&ids=' + result;
	}
}
function viewTaskInfoInTree(id) {
	var manageMode = window.dialogArguments.manageMode;
	var url = taskManageUrl + '?method=viewTaskDetail&id=' + id + '&random=' + new Date().getTime() + '&manageMode=' + manageMode + '&fromTree=true';
	var ret = v3x.openWindow({
		url : url,
		width	: 700,
		height	: 650,
		resizable	: "true"
	});
}
function viewTaskInfo(id) {
	var manageMode = arguments && arguments.length == 2 && (arguments[1] == 'ProjectAll' || arguments[1] == 'Manage');
	var fromWorkManage = arguments && arguments.length == 3 && arguments[2] == 'true';
	var titleVal = v3x.getMessage("ProjectLang.task_content");
	var closeBtnTxt = v3x.getMessage("ProjectLang.task_close");
	if(titleVal.length == 0) {
		titleVal = v3x.getMessage("TaskManage.task_content");
	}
	if(closeBtnTxt.length == 0) {
        closeBtnTxt = v3x.getMessage("TaskManage.task_close");
    }
	var url = taskManageUrl + '?method=taskDetailIndex&id=' + id + "&from=Project";
	var taskInfoDialog = v3x.openDialog({
		id:"taskInfoDialog",
		title : titleVal,
		url : url,
		//resizable : "true",
		//targetWindow:window.top,
		targetWindow : getA8Top(),
		width : getA8Top().document.body.clientWidth  - 100,
		height : getA8Top().document.body.clientHeight - 37,
		closeParam : {
			handler : function() {
				taskInfoDialog.close();
				try {
                    if(manageMode || fromWorkManage){
                        window.location.href = window.location;
                        if(fromWorkManage){
                            parent.statFrame.location.href = parent.statFrame.location.href;
                        }
                    }else{
                        window.location.href = window.location.href;
                    }
                } catch(e) {
                }
			}
		},
		buttons : [{
			id:"close",
            text: closeBtnTxt, 
            handler: function () {
				taskInfoDialog.close();
				try {
					if(manageMode || fromWorkManage){
						window.location.href = window.location;
						if(fromWorkManage){
							parent.statFrame.location.href = parent.statFrame.location.href;
						}
					}else{
						window.location.href = window.location.href;
					}
				} catch(e) {
				}
            } 
         }]
	});
	
}
function toEditTask(id) {
	taskInfoFrame.location.href = taskManageUrl + '?method=taskInfo&id=' + id + '&flag=Edit';
}
function handleInvalid4Feedback(taskIsNull) {
	alert(v3x.getMessage('TaskManage.' + (taskIsNull ? 'task_deleted' : 'no_auth_feedback')));
	if(taskIsNull && parent.$('#msgFlag').val() != 'true') {
		parent.getA8Top().dialogArguments.getA8Top().reFlesh();
	}
	parent.getA8Top().close();
}
function handleInvalid4Modify(taskIsNull) {
	alert(v3x.getMessage('TaskManage.' + (taskIsNull ? 'task_deleted' : 'no_auth_edit')));
	if(taskIsNull) {
		if(parent.$('#msgFlag').val() != 'true') {
			parent.getA8Top().dialogArguments.getA8Top().reFlesh();
		}
		window.close();
	}
	else {
		parent.location.href = parent.location;
	}
}
function handleInvalid4Replys(taskIsNull) {
	alert(v3x.getMessage('TaskManage.' + (taskIsNull ? 'task_deleted' : 'no_auth_view_replys')));
	window.close();
}
function handleInvalidNoAuth(taskIsNull, notFromList) {
	alert(v3x.getMessage('TaskManage.' + (taskIsNull ? 'task_deleted' : 'no_auth')));
	window.getA8Top().returnValue = notFromList == false;
	window.getA8Top().close();
}
function viewFeedback(feedbackId, taskId, manageMode) {
	parent.detailFrame.location = taskManageUrl + '?method=viewOrModifyTaskFeedbackPage&id=' + feedbackId + '&taskId=' + taskId + '&flag=View' + '&manageMode=' + manageMode;
}
function toEditFeedback(taskId, feedbackId, disabled) {
	var id;
	if(arguments.length == 1) {
		id = getSelectId(v3x.getMessage("TaskManage.pls_select_feedback_edit"), v3x.getMessage("TaskManage.can_not_edit_more"));
		if(id == false) {
			return false;
		}
	}
	else if(arguments.length == 3) {
		id = arguments[1];
	}
	
	if(disabled == 'disabled') {
		alert(v3x.getMessage("TaskManage.can_not_edit_other_feedback"));
		return false;
	}
	parent.detailFrame.location = taskManageUrl + '?method=viewOrModifyTaskFeedbackPage&id=' + id + '&taskId=' + taskId + '&flag=Edit';
}
function deleteTaskFeedbacks(taskId) {
	var ids = getSelectId(v3x.getMessage("TaskManage.pls_select_records"));
	if(ids == false) {
		return false;
	}
	
	if(confirm(v3x.getMessage("TaskManage.confirm_delete_feedbacks"))) {
		window.location.href = taskManageUrl + '?method=deleteTaskFeedbacks&taskId=' + taskId + '&ids=' + ids;
	}
}
function showAllReply(taskId) {
	var url = taskManageUrl + '?method=viewAllReplys&taskId=' + taskId;
	v3x.openWindow({
		url : url,
		width	: 500,
		height	: 500,
		resizable	: "true"
	});
}
function addReply(referenceReplyId, referenceReplyerId) {
	var oReplyDiv = document.getElementById('replyDiv');
	oReplyDiv.className= "replyDiv";
	if(arguments && arguments.length == 2) {
		document.getElementById('referenceReplyId').value = arguments[0];
		document.getElementById('referenceReplyerId').value = arguments[1];
	}
	document.getElementById('contentReplyArea').focus();
	document.getElementById('sendActionButton').disabled = false;
}
function hideReplyDiv() {
	var oReplyDiv = document.getElementById('replyDiv');
	oReplyDiv.className= "replyDivHidden";
	document.getElementById('referenceReplyId').value = '-1';
	document.getElementById('referenceReplyerId').value = '-1';
	document.getElementById('contentReplyArea').value = '';
}
function saveReply(taskId, replyerId, currentUserName) {
	try {
		var sab = document.getElementById('sendActionButton');
		sab.disabled = true;
		var sendMessage = 'true';
		var contentReplyMessage = '';
		var oSendMessage = document.getElementById('sendMessage');
		var oContentReplyArea = document.getElementById('contentReplyArea');
		if(oSendMessage){
			if(!oSendMessage.checked){
				sendMessage = 'false';
			}
		}
		
		if(!oContentReplyArea)
			return;
		
		if(oContentReplyArea) {
			if(oContentReplyArea.value.trim() != '') {
				if(oContentReplyArea.value.length > 1200) {
					alert(v3x.getMessage("TaskManage.reply_too_long", 1200, oContentReplyArea.value.length));
					sab.disabled = false;
					return;
				}
				contentReplyMessage = encodeURIComponent(oContentReplyArea.value);
			}
			else {
				alert(v3x.getMessage("TaskManage.reply_blank"));
				sab.disabled = false;
				return;
			}
		} 
		
		var referenceReplyId = document.getElementById('referenceReplyId').value;
		var referenceReplyerId = document.getElementById('referenceReplyerId').value;
		
		var requestCaller = new XMLHttpRequestCaller(this, "taskInfoManager", "saveTaskReply", false);
			requestCaller.addParameter(1, "Long", replyerId);
	    	requestCaller.addParameter(2, "Long", taskId);
	    	requestCaller.addParameter(3, "Long", referenceReplyId);
	    	requestCaller.addParameter(4, "Long", referenceReplyerId);
	    	requestCaller.addParameter(5, "String", contentReplyMessage);
	    	requestCaller.addParameter(6, "boolean", sendMessage);
	    
	    var array = requestCaller.serviceRequest();
	    var ret =  parseInt(array[0]);
    	switch(ret) {
    		case TaskDeleted :
    			alert(v3x.getMessage("TaskManage.task_deleted"));
    			hideReplyDiv();
    			break;
    		case NoReplyAuth :
    			alert(v3x.getMessage("TaskManage.no_reply_auth"));
    			hideReplyDiv();
    			break;
    		case SaveReplyFail :
    			alert(v3x.getMessage("TaskManage.reply_again"));
    			break;
    		case OtherException :
    			alert(v3x.getMessage("TaskManage.other_exception"));
    			hideReplyDiv();
    			break;
   			case SendMsgFail :
   				alert(v3x.getMessage("TaskManage.reply_send_msg_exception"));
   				try {
   					addReply2Table(replyerId, currentUserName, oContentReplyArea.value, referenceReplyId, array[1]);
   				} 
   				catch(e) {
   					alert("An Error Occurred:" + e);
   				}
				hideReplyDiv();
   				break;
   			case None :
   				try {
   					addReply2Table(replyerId, currentUserName, oContentReplyArea.value, referenceReplyId, array[1]);
   				} 
   				catch(e) {
   					alert("An Error Occurred:" + e);
   				}
				hideReplyDiv();
   				break;
   			default:
   				alert("type error");
    	}
	}
	catch(e) {
		alert("An Exception occurred:" + e);
	}
}
function addReply2Table(replyerId, currentUserName, replyContent, referenceReplyId, savedReplyId) {
	var replyTr = document.getElementById('allreplys_tr');
	var tableDom = document.getElementById('allreplys_table');
	// 一级回复
	if(referenceReplyId == '-1') {
		var oTr = tableDom.insertRow(0);
		oTr.id = 'header' + savedReplyId;
		
		var oTd = oTr.insertCell(0); 
		var htmlStr = new StringBuffer();
		htmlStr.append("<span class='cursor-hand' style='color:#335186;padding-left:20px;' onclick=\"showV3XMemberCard('" + replyerId + "')\">");
		htmlStr.append("<b>" + currentUserName + "</b>");
		htmlStr.append("</span>&nbsp;&nbsp;&nbsp;&nbsp;(" + new Date().format('MM-dd HH:mm') + ")");
		oTd.innerHTML = htmlStr.toString();	
		oTd.style.cssText = 'padding-top:2px;padding-bottom:2px;';	
		oTd.vAlign = 'top';
		oTd.bgColor  = '#D2D8E2';
		
		var oTr2 = tableDom.insertRow(1);
		oTr2.id = 'content' + savedReplyId;
				
		var oTd2 = oTr2.insertCell(0);
		oTd2.innerHTML = escapeStringToHTML(replyContent);
		oTd2.valign = 'top';
		oTd2.style.cssText = 'padding-left:45px;padding-top:4px;';
		
		if(replyTr.style.display == 'none') {
			replyTr.style.display = '';
		}
	}
	// 引用回复
	else {
		// 在已有引用回复基础上添加
		if(document.getElementById('referenceReplys' + referenceReplyId)) {
			var referTable = document.getElementById('referenceReplys' + referenceReplyId);
			var oTr = referTable.insertRow();
			var oTd = oTr.insertCell();
			oTd.innerHTML = "<span class='cursor-hand' style='padding-left:20px;color:#335186;' onclick=\"showV3XMemberCard('" + replyerId + "')\">" +
							currentUserName + ":</span>&nbsp;&nbsp;&nbsp;&nbsp;" + new Date().format('yyyy-MM-dd HH:mm');
			
			var oTr2 = referTable.insertRow();
			var oTd2 = oTr2.insertCell();
			oTd2.innerHTML = "<div style='padding-left:50px;padding-top:4px;'>" + replyContent + "</div>";
		}
		// 当前新增的引用回复是第一个
		else {
			var index = document.getElementById('content' + referenceReplyId).rowIndex + 1;
			var oTr = tableDom.insertRow(index);
			var oTd = oTr.insertCell();
			
			var htmlStr = new StringBuffer();
			htmlStr.append("<table id=\"referenceReplys" + referenceReplyId + "\" width=\"100%\" align=\"center\" border='0' class='border-top border-left border-right border-bottom' cellspacing='0' cellpadding='0'>");
			htmlStr.append("	<tr>")
			htmlStr.append("		<td width='100%' height='24' bgcolor='#f2f9ff' class='bbs-tb-padding border-bottom' colspan='2'>");
			htmlStr.append("			<span style=\"padding-left:20px;\">" + v3x.getMessage('TaskManage.task_reply_opinions') + ":</span>");
			htmlStr.append("		</td>");
			htmlStr.append("	</tr>");
			htmlStr.append("	<tr>");
			htmlStr.append("		<td>");
			htmlStr.append("			<span class=\"cursor-hand\" style=\"padding-left:20px;color:#335186;\" onclick=\"showV3XMemberCard('" + replyerId + "')\">");
			htmlStr.append(					currentUserName + ":");
			htmlStr.append("			</span>");
			htmlStr.append("			&nbsp;&nbsp;&nbsp;&nbsp;" + new Date().format('yyyy-MM-dd HH:mm'));
			htmlStr.append("		</td>")
			htmlStr.append("	</tr>");
			htmlStr.append("	<tr>");
			htmlStr.append("		<td>");
			htmlStr.append("			<div style=\"padding-left:50px;padding-top:4px;\">" + escapeStringToHTML(replyContent) + "</div>");
			htmlStr.append("		</td>");
			htmlStr.append("	</tr>");
			htmlStr.append("</table>");
			oTd.innerHTML = htmlStr.toString();
			
			oTd.style.cssText = 'padding-left:45px;padding-right:45px;padding-top:4px;padding-bottom:8px;';
		}
	}
}
function replyKeyAction(ev) {
	ev  =  ev  ||  window.event; 
 	var oReplyDiv = document.getElementById('replyDiv');
 	if(!oReplyDiv)
		return;
	
	if(ev.keyCode==13) {
		if(oReplyDiv.style.display =="none" || oReplyDiv.className=="replyDivHidden") {
 			oReplyDiv.className= "replyDiv";
 			document.getElementById('contentReplyArea').focus();
	 	}
 	}	
 
 	if(ev.keyCode==13 && ev.ctrlKey) {
		if(oReplyDiv.style.display =="block" || oReplyDiv.style.display == '') {
		document.getElementById('contentReplyArea').blur();
 		var o = document.getElementById('sendActionButton');
			 o.click();
		}	 
	}	
}
/* 
修改权限
1、创建人：除上级任务剩余字段都可以修改  
2、负责人：开始前提醒、结束前提醒、实际工时、状态、完成率、风险、参与人、只可增加负责人、实际开始时间、实际结束时间
3、参与人：完成率、实际工时
*/
var Disabled_Props_Manager = ['subject', 'fulltime', 'plannedStartTime', 'plannedEndTime', 
					'content', 'importantLevel', 'plannedTaskTime', 'importToCalendar'];
var Disabled_Props_Participator = ['subject', 'fulltime', 'plannedStartTime', 'plannedEndTime',
			        'remindStartTime', 'remindEndTime', 'createUserName', 'managersName', 'participatorsName',
			        'content', 'importantLevel', 'status', 'plannedTaskTime', 'actualStartTime', 'actualEndTime', 'riskLevel', 'importToCalendar'];
function disableNoAclProps(isCreator, isManager, isParticipator) {
	var disabledDoms;
	if(!isCreator && isManager) {
		disabledDoms = Disabled_Props_Manager;
	} else if(!isCreator && !isManager && isParticipator) {
		disabledDoms = Disabled_Props_Participator;
	}
	if(disabledDoms && disabledDoms.length > 0) {
		for(var i = 0; i < disabledDoms.length; i++) {
			if(document.getElementById(disabledDoms[i])) {
				document.getElementById(disabledDoms[i]).disabled = true;
			}
		}
	}
}
function cancelAction(flag, id) {
	if(flag == 'Edit') {
		window.location.href = taskManageUrl + '?method=taskInfo&flag=View&id=' + id;
	}
	else {
		var rv = false;
		if($('#from').val() != 'Decompose') {
			if(window.top.dialogArguments.getA8Top().contentFrame.topFrame.taskAddCount > 0) {
				rv = true;
				window.top.dialogArguments.getA8Top().contentFrame.topFrame.taskAddCount = 0;
			}
		}
		else {
			rv = true;
		}
		window.top.returnValue = rv;
		window.top.close();
	}
}
function unloadTaskInfo(from) {
	if(from == 'Decompose')
		return;
	
	try {
		if(window.dialogArguments) {
			if(window.dialogArguments.getA8Top().contentFrame.topFrame.taskAddCount > 0) {
				window.dialogArguments.getA8Top().reFlesh();
				window.dialogArguments.getA8Top().contentFrame.topFrame.taskAddCount = 0;
			}
		}
	} catch(e) {};
}
function lock(userId, taskId) {
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "taskInfoManager", "lockWhenEdit", false);
			requestCaller.addParameter(1, "Long", userId);
	    	requestCaller.addParameter(2, "Long", taskId);
	    	requestCaller.needCheckLogin = false;
		var ds = requestCaller.serviceRequest();
	}
	catch(e) {
		logger.debug(e);
	}
}
function unlock(actionFlag, taskId) {
	if(actionFlag != 'Edit' || taskId == '') {
		return false;
	}
	
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "taskInfoManager", "unLockAfterEdit", false);
	    	requestCaller.addParameter(1, "Long", taskId);
	    	requestCaller.needCheckLogin = false;
		var ds = requestCaller.serviceRequest();
	}
	catch(e) {
		logger.debug(e);
	}
}
function showTaskTree(taskId, manageMode) {
	var url = taskManageUrl + '?method=taskTree&taskId=' + taskId + '&random=' + new Date().getTime() + '&manageMode=' + manageMode;
	var ret = v3x.openWindow( {
		url : url,
		width : 900,
		height : 500,
		resizable : false, 
		dialogType : 'modal'
	}
	);
}
function advancedSetting(taskId, flag) {
	var url = taskManageUrl +'?method=advancedSettings&id=' + taskId +'&flag=' + flag + '&random=' + new Date().getTime();
	var ret = v3x.openWindow({
		url : url,
		width : 500,
		height : flag == 'View' ? 200 : 240,
		resizable : false, 
		dialogType : 'modal'
	}
	);
	if(ret && ret.length > 0) {
		$("#advancedSettingsHiddenDiv").html(ret[0]);
	}
}
function initAdvanceSettingsContent() {
	$('#advancedSettingsEditDiv').html(window.dialogArguments.$('#advancedSettingsHiddenDiv').html());
}
function deliverASBack() {
	if($('#plannedTaskTime').val().trim() != '') {
		var time = parseFloat($('#plannedTaskTime').val().trim());
		if(time < 0) {
			alert(v3x.getMessage('TaskManage.time_less_than_zero'));
			if($('#plannedTaskTime')[0].disabled == false) {
				$('#plannedTaskTime')[0].focus();
			}
			return false;
		}
	}
	
	if(document.getElementById('actualTaskTime')) {
		if($('#actualTaskTime').val().trim() != '') {
			var time = parseFloat($('#actualTaskTime').val().trim());
			if(time < 0) {
				alert(v3x.getMessage('TaskManage.time_less_than_zero'));
				if($('#actualTaskTime')[0].disabled == false) {
					$('#actualTaskTime')[0].focus();
				}
				return false;
			}
		}
	}
	
	window.returnValue = [$('#advancedSettingsEditDiv').html()];
	window.close();
}
function init4Decompose() {
	endProcManual();
	window.location.href = window.location;
}
function endDecompose() {
	endProcManual();
	window.close();
}
function showParentTasks(from, flag) {
	if(from == 'Decompose' || flag == 'View' || flag == 'Edit')
		return;
	var parentTaskId = $('#parentTaskId').val();
	var projectId = $('#projectId').val();
	var projectPhaseId = $('#projectPhaseId').val();
		
	var url = taskManageUrl + '?method=showParentTasksFrame&parentTaskId=' + parentTaskId + '&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId;
	var ret = v3x.openWindow({
		url : url,
		width : 800,
		height : 600,
		dialogType : 'modal'
	});
	
	if(ret && ret.length > 0) {
		$('#parentTaskId').val(ret[0]);
		$('#parentLogicalPath').val(ret[1]);
		$('#parentTaskSubject').val(ret[2]);
	}	
}
function handleNoParentTasks() {
	alert(v3x.getMessage('TaskManage.no_parent_tasks_to_select'));
	window.close();
}
function selectParentTask(id) {
	var selectedId;
	if(id) {
		selectedId = id;
	} else {
		var checked = parentTasksFrame.$("input[name='id']:checked");
		if(checked && checked.length > 0) {
			selectedId = checked[0].value;
		}
	}
	if(selectedId && selectedId.length > 0) {
		var ret = [];
		ret[ret.length] = selectedId;
		ret[ret.length] = parentTasksFrame.$('#logicalPath' + selectedId).val();
		ret[ret.length] = parentTasksFrame.$('#title' + selectedId).val();
		
		window.returnValue = ret;
		window.close();
	} else {
		alert(v3x.getMessage('TaskManage.pls_select_parent_task'));
		return false;
	}
}
function reNavigation(type) {
	window.location.href = taskManageUrl + '?method=navigation&type=' + type;
}
function showTaskList(userId) {
	parent.rightFrame.location.href = taskManageUrl + '?method=listManageTasks&from=Manage&userId=' + userId;
}
function showProjectTasks(projectId) {
	parent.rightFrame.location.href = taskManageUrl + '?method=listManageTasks&from=Manage&projectId=' + projectId;
}
function viewAsList(projectId, projectPhaseId, listTypeName) {
	window.location.href = taskManageUrl + '?method=listProjectTasks&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&listTypeName=' + listTypeName;
}
function viewAsGantt(projectId, projectPhaseId, listTypeName) {
	window.location.href = taskManageUrl + '?method=ganttChartTasks&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&listTypeName=' + listTypeName;
}
/**
 * 横向和纵向的求和合计，通过js操作来展现，避免后台进行数据库操作抽取相关数据
 */
function showSumValues(memberIdsStr, selectAllStatus) {
	var memberIds = memberIdsStr.split(',');
	if(memberIds.length > 1) {
		memberIds[memberIds.length] = '-1';
	}
	var reduceLen = selectAllStatus == 'false' ? 1 : 2;
	
	for(var i = 0 ; i < memberIds.length; i++) {
		var mId = memberIds[i];
		var tr_mId = document.getElementById('TR_' + mId);
		var tds_mId = tr_mId.cells;
		var sumCount = 0, sumTime = 0.0;
		for(var j = 1; j < tds_mId.length - reduceLen; j++) {
			sumCount += parseInt(tds_mId[j].innerText);
			j++;
			sumTime += parseFloat(tds_mId[j].innerText);
		}
		
		logger.debug('横向任务总数:' + sumCount + ' - 横向耗时总数:' + sumTime);
		
		if(selectAllStatus == 'true') {
			tds_mId[11].innerText = sumCount;
			tds_mId[12].innerText = handleFloat(sumTime.toFixed(1));
		}
	}
}
function handleFloat(fl) {
	if((fl + '').indexOf('.') == -1) {
		return fl + '.0';
	}
	return fl;
}
function openProjectStatList(memberId, status, index) {
	var TDId = "TD" + index + "_" + memberId;
	if(!validateCount(TDId, index)) {
		return;
	}
	
	var memberUrl = '&memberIds=' + memberId;
	openStatTaskList(memberUrl, status);
}
var STATUS_INDEX = [1, 1, 2, 2, 4, 4, 3, 3, 5, 5, -1, -1];
function openProjectStatSumList(index, status) {
	var TDId = 'TD' + index + '_-1';
	if(!validateCount(TDId, index)) {
		return;
	}
	
	var memberUrl = '&memberIds=' + document.getElementById('memberIdsStr').value;
	var status_Url = status == -1 ? STATUS_INDEX[index - 1] : status;
	openStatTaskList(memberUrl, status_Url);
}
function validateCount(TDId, index) {
	var obj = document.getElementById(TDId);
	var text = obj.innerText;
	if(index % 2 == 0) {
		text = obj.previousSibling.innerText;
	}
	
	if(text == "0") {
		return false;
	}
	if(currentTD != null){
		document.getElementById(currentTD).className = "manageTD";
	}
	currentTD = TDId;
	obj.className = "manageTD-sel";
	return true;
}
function openStatTaskList(memberUrl, status) {
	var timeRange = 1;
	var timeRadios = parent.document.getElementsByName('timeRange');
	for(var i=0; i<timeRadios.length; i++) {
		if(timeRadios[i].checked == true) {
			timeRange = timeRadios[i].value;
		}
	}
	
	var url = taskManageUrl + '?method=showProjectStatList&timeRange=' + timeRange + '&beginDate=' + parent.document.getElementById('beginDate').value + 
			  '&endDate=' + parent.document.getElementById('endDate').value + '&projectId=' + parent.document.getElementById('projectId').value + 
			  '&projectPhaseId=' + parent.document.getElementById('projectPhaseId').value + '&status=' + status + memberUrl + '&from=Project';
	var title = status == -1 ? '' : TITLE[status -1];
	url += '&title=' + encodeURI(title);
	//var ret = v3x.openWindow({url : url, workSpaceRight : 'yes'});
	var taskListDialog = v3x.openDialog({
		title : v3x.getMessage("TaskManage.task_list_view"),
		url:url,
		targetWindow : getA8Top(),
		width : getA8Top().document.body.clientWidth  - 100,
		height : getA8Top().document.body.clientHeight - 37,
		buttons: [{
            text: v3x.getMessage("TaskManage.task_close"), 
            handler: function () {
				taskListDialog.close();
				try {
					if(manageMode || fromWorkManage){
						//window.location.href = window.location;
						if(fromWorkManage){
							//parent.statFrame.location.href = parent.statFrame.location.href;
						}
					}else{
						//window.location.href = window.location;
					}
				} catch(e) {
				}
            } 
         }]
	});
}
function addTaskPage(from) {
	var url = taskManageUrl + '?method=addTaskPageFrame';
	if(from == 'Project') {
		var projectId = parent.parent.$('#projectId').val();
		var projectPhaseId = parent.parent.$('#currentPhaseId').val();
		var projectBeginTime = parent.parent.$('#projectBeginTime').val();
		var projectEndTime = parent.parent.$('#projectEndTime').val();
		url += '&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&projectBeginTime=' + projectBeginTime + '&projectEndTime=' + projectEndTime;
	}
	var ret = v3x.openWindow({
		url : url,
		width	: 600,
		height	: 500,
		resizable	: "false"
	});
	if(ret == true || ret == 'true') {
		window.location.href = window.location;
	}
}
function checkDecomposeAdd() {
	if(detailIframe.taskAddCount > 0) {
		window.returnValue = true;
		window.close();
	}
}
function afterSave(fromDecompose, continuation, justCreator, from) {
	if(fromDecompose) {
		if(continuation) {
			init4Decompose();
		}
		else {
			endDecompose();
		}
		if(parent.window.dialogArguments.fromMsg != true) {
			parent.window.dialogArguments.taskAddCount += 1;
		}
	}
	else {
		if(continuation) {
			window.location.href = window.location+"&mathrandom="+Math.random();
			parent.window.dialogArguments.getA8Top().contentFrame.topFrame.taskAddCount += 1;
		}
		else {
			if(from == 'Project' || from == 'timing') {
				parent.returnValue = true;
				parent.close();
			}
			else {
				var type = justCreator ? 'Sent' : 'Personal';
				parent.dialogArguments.getA8Top().contentFrame.mainFrame.location.href = taskManageUrl + '?method=listTasksIndex&from=' + type;
				parent.close();
			}
		}
	}
}
function setMenuState(type) {
	var id = type == 'Personal' ? 'personalBtn' : 'sentBtn';
	var otherId = type == 'Personal' ? 'sentBtn' : 'personalBtn';
	var menuDiv = document.getElementById(id);
	var otherMenuDiv = document.getElementById(otherId);
	if(menuDiv.className == 'webfx-menu--button-sel' && otherMenuDiv.className == 'webfx-menu--button') {
		return false;
	}
	
	menuDiv.className = 'webfx-menu--button-sel';
	menuDiv.firstChild.className="webfx-menu--button-content-sel";
    menuDiv.onmouseover = '';
    menuDiv.onmouseout = '';
    
    otherMenuDiv.className = 'webfx-menu--button';
    otherMenuDiv.firstChild.className="webfx-menu--button-content";
    return true;
}
function switchMyTasks(type) {
	if(setMenuState(type))
		parent.parent.location.href = taskManageUrl + '?method=listTasksIndex&from=' + type;
}
function printGanttChart() {
	var p = $("#GanttChartDIV").html();
	if(count == 0) {
		if(window.confirm(v3x.getMessage('TaskManage.no_record_print_gantt'))) {
			p = "";
		}
		else {
			return false;
		}
	}
	var mm = "<div style='width: 100%;height:auto !important;min-height:500px;'>" + p + "</div>";
	var list1 = new PrintFragment("", mm);
	var tlist = new ArrayList();
	tlist.add(list1);
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea5Show.css");
	cssList.add(v3x.baseURL + "/apps_res/taskmanage/css/jsgantt.css");   			   	
	printList(tlist,cssList);
}
/**
 * @deprecated	取消选中的上级任务，此功能目前暂时屏蔽，待日后根据应用调整确认是否启用
 */
function cancelParentTask() {
	if(window.dialogArguments.$('#parentTaskSubject').val().trim() != '') {
		if(window.confirm(v3x.getMessage('TaskManage.cancel_parent'))) {
			window.dialogArguments.$('#parentTaskSubject').val('');
			window.dialogArguments.$('#parentTaskId').val('');
			window.dialogArguments.$('#parentLogicalPath').val('');
			window.close();
		}
	}
	else {
		window.close();
	}
}
function changeDateSelectState(enabled) {
	document.getElementById('beginDate').disabled = enabled == false;
	document.getElementById('endDate').disabled = enabled == false;
	if(enabled==false){
		document.getElementById('beginDate').style.background="rgb(235, 235, 228)";
		document.getElementById('endDate').style.background="rgb(235, 235, 228)";
	}else{
		document.getElementById('beginDate').style.background="white";
		document.getElementById('endDate').style.background="white";
	}
}
function resize4Navigation() { 
	if(navigator.userAgent.indexOf("MSIE") > 0){
		var maxWidth;
		var parentLayout = parent.document.getElementById("layout");
		if(window.screen.width <= 1024)
			maxWidth = 275;
		else
			maxWidth = 440;
		if(document.body.clientWidth > maxWidth)   
			parentLayout.cols = maxWidth + ",*";
		
		if(document.body.clientWidth < 140)  
			parentLayout.cols = "140,*";
	} else {
		// -> Ignore
	}  
}
function addReport(id){
  var src = v3x.baseURL+"/taskmanage/taskfeedback.do?method=newTaskFeedbackPage&isEidt=1&operaType=new&taskId="+id+"&isPortal=1";
  var feedbackDialog = v3x.openDialog({
		title : v3x.getMessage("ProjectLang.task_creat_report"),
		url:src,
		targetWindow : getA8Top(),
		width : 560,
		height : 380,
		buttons: [{
			id : "ok",
 			text: v3x.getMessage("ProjectLang.project_sure"), 
			handler : function() {
				var a = feedbackDialog.getReturnValue(); 	

				if(a == true){	
				setTimeout(function() {feedbackDialog.close();
    			refresh();}, 100);
    			}
            }
        },{
			id : "cancel",
			text: v3x.getMessage("ProjectLang.project_calcel"),  
			handler : function() {
				feedbackDialog.close();
            }
		}]
	});
}
