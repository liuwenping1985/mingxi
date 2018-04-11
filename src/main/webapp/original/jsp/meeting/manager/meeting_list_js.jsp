<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set value="${param.listType }" var="listType" />
<c:set value="${param.listMethod }" var="listMethod" />
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />

<span style="display:none">
	<fmt:message key='mt.mtMeeting.state.sendWait' var='waitSendPanelLabel' />
	<fmt:message key='mt.mtMeeting.state.send' var='sendPanelLabel' />
	<fmt:message key='' var='pendingPanelLabel' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<fmt:message key='meeting.summary.record.publish' var='summaryPanelLabel'/>
	<fmt:message key='oper.newMeeting' var='createLabel' />
	<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' var='editLabel' />
	<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}' var='cancelLabel' />
	<fmt:message key='mt.list.toolbar.delete.label' var='deleteLabel' />
	<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' var='pigeonholeLabel' />
	<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' var='summaryToColLabel' />
	<fmt:message key='mtSummary.toolbar.transmit.edoc.label' var='summaryToEdocLabel' />
	<fmt:message key='meeting.room.used.status.3' var="finishLabel" />
	<fmt:message key='mt.task.create.button' var="newTaskButton" />
</span>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var listType = '${listType}';

baseUrl = '${meetingURL}?method=';

var ht = new Hashtable();
var createUserIdTable = new Hashtable();
var recorderUserIdTable = new Hashtable();
var emceeUserIdTable = new Hashtable();
var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";

/******************************** 会议列表页面加载 start **********************************/

$(function() {
	
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", v3x.getMessage("meetingLang.meeting_choose_all"));
		}
	}, 100);
	
	initList();
});


/** 列表页面加载 **/
function initList() {
	setCurrentPanel();
	showMeetingLocation();
	initListDetail();
}

/** 当前位置 **/
function showMeetingLocation() {
	var currentPanel = document.getElementById("currentPanel");
	showCtpLocation(currentPanel.getAttribute('resCodeParent'));
}

/** 高亮显示当前选中会议状态所对应的菜单按钮 **/
function setCurrentPanel() {
	//会议安排
	if(listType=='listWaitSendMeeting' || listType=='listSendMeeting') {
		document.getElementById('sendPanel').className = 'webfx-menu--button';
		document.getElementById('waitSendPanel').className = 'webfx-menu--button';
		document.getElementById('sendPanel').firstChild.className = 'webfx-menu--button-content';
		document.getElementById('waitSendPanel').firstChild.className = 'webfx-menu--button-content';
	}
	//历史会议
	else if(listType == 'listDoneMeeting' || listType=='listMeetingSummary') {
		document.getElementById('donePanel').className = 'webfx-menu--button';
		document.getElementById('summaryPanel').className = 'webfx-menu--button';
		document.getElementById('donePanel').firstChild.className = 'webfx-menu--button-content';
		document.getElementById('summaryPanel').firstChild.className = 'webfx-menu--button-content';
	}
	var menuId = null;
	switch(listType) {
		case 'listWaitSendMeeting':
			menuId = "waitSendPanel";
			break;
		case 'listSendMeeting':
			menuId = "sendPanel";
			break;
		case 'listPendingMeeting':
			menuId = "pendingPanel";
			break;
		case 'listDoneMeeting':
			menuId = "donePanel";
			break;
		case 'listMeetingSummary':
			menuId = "summaryPanel";
			break;
	}
	var menuDiv = document.getElementById(menuId);
	if(menuDiv != null) {
		menuDiv.className = 'webfx-menu-button-sel';
	    menuDiv.firstChild.className = "webfx-menu-button-content-sel";
	    menuDiv.onmouseover = '';
	    menuDiv.onmouseout = '';
	}
}

function initListDetail() {
	if(parent.detailFrame && parent.detailFrame.document.getElementById("pagebreakspare")) {
		parent.detailFrame.document.getElementById("pagebreakspare").style.display = "";
		parent.detailFrame.document.getElementById("pagebreakspare").style.height = "9px";
	}
	previewFrame('Down');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));
	showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv", 550, 870);
}

/** 会议列表操作：按钮页签链接  **/
function setPanelURL(currentListType) {
	var url = '${meetingNavigationURL}?method=list&listType='+currentListType;
	location.href = url;
}

/******************************** 会议列表页面加载 end **************************************/


/******************************** 会议列表操作 start **************************************/
/** 会议列表操作：新建会议  **/
function createMeeting() {
	var url = baseUrl+"create&listMethod=listMyMeeting&listType="+listType;
	meetingOpenNewWin({"url":url, id:"100"});
}

/** 会议列表操作：编辑  **/
function editMeeting(meetingId) {
	
	var num = 0;
	var checkedBox;
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++){
		if(ids[i].checked){
			checkedBox = ids[i];
			num++;
			if(num > 1) {
				break;	
			}
		}
	}
    
	if(!checkedBox) {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	} else if(num > 1) {
		alert(v3x.getMessage("meetingLang.meeting_list_toolbar_only_choose_one_toEdit"));
		return;
	}
	
	var meetingId = checkedBox.value;
	var category = checkedBox.getAttribute("category");
	var periodicityId = checkedBox.getAttribute("periodicityId");

	//已经开始的会议不允许修改，其他均允许修改
	if(userInternalID==createUserIdTable.items(meetingId)){
		var state = checkedBox.getAttribute("state");
		if(state != 0 && state != 10 && state != 20) {
			alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
			return;
		}		
		
		if(state!=0 && category == "1") {
			var url = "meeting.do?method=openPeriodicityBatchDialog&type=edit";
			var title = "<fmt:message key='meeting.alert.edit'></fmt:message>";
			openMeetingDialog(url, title, 308, 120, function(isBatch) {
				gotoEditUrl(isBatch);
				commonDialogClose('win123');
			});
		} else {//周期会议
			gotoEditUrl(true);
		}
	} else {
		alert(v3x.getMessage("meetingLang.you_not_creater"));
		return;
	}
}

function gotoEditUrl(isBatch) {
	var meetingId = getCheckedBox().value;
	var url = "meeting.do?method=edit&id=" + meetingId + "&listType=" + listType;
	if(isBatch) {
		url += "&isBatch="+isBatch;
	} else {
		url += "&isBatch=false";
	}
    meetingOpenNewWin({'url':url,'id':meetingId});
}

/** 会议列表操作：撤销  **/
function cancelMeeting() {
    var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }
    
	var num = 0;
	var checkedBox;
	
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++) {
		if(ids[i].checked) {
			checkedBox = ids[i];
			num++;
			if(num > 1) {
				break;	
			}
		}
	}
	
	if(!checkedBox) {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	} else if(num > 1) {
		alert(v3x.getMessage("meetingLang.not_choose_more_item_from_list"));
		return;
	}
	
	var meetingId = checkedBox.value;
	var category = checkedBox.getAttribute("category");
	var periodicityId = checkedBox.getAttribute("periodicityId");
	
	if(userInternalID==createUserIdTable.items(meetingId)) {
		var state = checkedBox.getAttribute("state");
		var recordState = checkedBox.getAttribute("recordState");

		if(state!=10 && state!=20) {//已召开
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_6"));
			return;
		}
		if(recordState==2 && state==20) {//已做会议纪要
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_5"));
			return;
		}
		if(state==-10) {//已归档
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_3"));
			return;
		}
		
	}
	
	if(category == 0) {
		gotoCancelUrl();
	} else {
		var url = "meeting.do?method=openPeriodicityBatchDialog";
		var title = "<fmt:message key='meeting.alert.cancle'></fmt:message>";
		
		/* openMeetingDialog(url, title, 308, 120, function(isBatch) {
			gotoCancelUrl(isBatch);
		});//此处回调方法
		 */
		 getA8Top().win123 = getA8Top().$.dialog({
			title: title,
			transParams:{'parentWin':window, "callback":function(isBatch) {
				gotoCancelUrl(isBatch);
			}},
			url: url,
			width: 308,
			height: 120,
			isDrag:false
		});
	}
	
}

function gotoCancelUrl(isBatch) {
	var url = "meeting.do?method=openCancelDialog";
	if(isBatch) {
		getCheckedBox().setAttribute("isBatch", isBatch);
	}
	var title = "<fmt:message key='meeting.alert.cancle'></fmt:message>";
	/* openMeetingDialog(url, title, 450, 260, function(rv, canSendSMS) {
		cancelMeetingCallback(rv, canSendSMS);
	});
	 */
	getA8Top().winIsBatch = getA8Top().$.dialog({
		title: title,
		transParams:{'parentWin':window, "callback":function(rv, canSendSMS) {
			cancelMeetingCallback(rv, canSendSMS);
		}},
		url: url,
		width: 450,
		height: 260,
		isDrag:false,
		closeParam:{
	        'show':true,
	        autoClose:false,
	        handler:function(){
				try{
					if(getA8Top().winIsBatch != undefined){
						getA8Top().winIsBatch.close();
						commonDialogClose('winIsBatch');
					} else {
						commonDialogClose('winIsBatch');
					}
				} catch (e) {}
	        }
	    }
	});
}

/** 撤销意见填写回调函数 */
function cancelMeetingCallback(rv, canSendSMS) {
	if(rv) {
		var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return false;
	    }
	    
	    var checkedBox = getCheckedBox();	    
	    var meetingId = checkedBox.value;
	    
	    var hiddenObj = document.getElementById("canSendSMS");
		if(hiddenObj) {
			hiddenObj.value = canSendSMS;
			
			if(hiddenObj.value == "true") {
				var requestCaller = new XMLHttpRequestCaller(this, "meetingValidationManager", "checkMemberPhoneNumber", false);
				requestCaller.addParameter(1, "String", meetingId);
				var ds = requestCaller.serviceRequest();
				if(ds != "<V><![CDATA[]]></V>"){
					alert(v3x.getMessage("meetingLang.calcel_meeting_send_sms_alert_info")+ds);
				}
				var elementSMS = document.createElement("input");
				elementSMS.setAttribute('type', 'hidden');
				elementSMS.setAttribute('name', 'canSendSMS');
				elementSMS.setAttribute('value', hiddenObj.value);
				theForm.appendChild(elementSMS);
			}
		}
		
        var element = document.createElement("input");
		element.setAttribute('type', 'hidden');
		element.setAttribute('name', 'cancelComment');
		element.setAttribute('value', rv);
		theForm.appendChild(element);
		
		var element = document.createElement("input");
		element.setAttribute('type', 'hidden');
		element.setAttribute('name', 'isBatch');
		element.setAttribute('value', checkedBox.getAttribute("isBatch"));
		theForm.appendChild(element);

		var url = "meeting.do?method=cancelMeeting&id=" + meetingId + "&listType=" + listType;
		theForm.action = url;
        theForm.method = "POST";
        theForm.submit();
	}
}


/** 会议列表操作：提前结束  **/
function finishMeeting() {
    var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }
    
	var num = 0;
	var checkedBox;
	
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++) {
		if(ids[i].checked) {
			checkedBox = ids[i];
			num++;
			if(num > 1) {
				break;	
			}
		}
	}
	
	if(num == 0) {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	} else if(num > 1) {
		alert(v3x.getMessage("meetingLang.not_choose_more_item_from_list_to_finish"));
		return;
	}
	
	var meetingId = checkedBox.value;
	var category = checkedBox.getAttribute("category");
	var periodicityId = checkedBox.getAttribute("periodicityId");
	
	if(userInternalID==createUserIdTable.items(meetingId)) {
		var state = checkedBox.getAttribute("state");
		var recordState = checkedBox.getAttribute("recordState");
		var roomState = checkedBox.getAttribute("roomState");
		
		//会议室审核不通过
		if(roomState != 1) {
			alert("${ctp:i18n('meeting.alert.notStartToEarlyEnd')}"); //该会议未开始，不允许提前结束！
			return;
		}
		if(state == 10) {//未召开
			alert("${ctp:i18n('meeting.alert.notStartToEarlyEnd')}");  //该会议未开始，不允许提前结束！
			return;
		}
		if(state == 30 || state == 31) {//已召开
			alert("${ctp:i18n('meeting.alert.isEndToEarlyEnd')}");  //该会议已结束，不允许提前结束！
			return;
		}
		if(state==-10) {//已归档
			alert("${ctp:i18n('meeting.alert.isArchivedToEarlyEnd')}");  //该会议已做过归档，不允许提前结束！
			return;
		}
	}
	
	var cancelMsg = "${ctp:i18n('meeting.alert.sureToEnd')}";  //您确定提前结束该会议吗？
	var meetingroomId = checkedBox.getAttribute("room");
	if(meetingroomId!="" && meetingroomId!="-1") {
		cancelMsg = "${ctp:i18n('meeting.alert.hasMeetingRoomToEarlyEnd')}";  //提前结束会议会同步释放会议室，您确定要提前结束该会议吗？
	}
	if(confirm(cancelMsg)) {
		var url = "meeting.do?method=finishMeeting&id=" + meetingId + "&listType=" + listType;
		theForm.action = url;
	    theForm.method = "POST";
	    theForm.submit();
	}
}

/**
 * 新建任务按钮
 */
function newTaskInfoBtn(){
	var checkedDom;
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++) {
		if(ids[i].checked) {
			if(checkedDom){
				alert("<fmt:message key='mt.task.create.alert.onlyone'/>");
				return;
			}else{
				checkedDom = ids[i];
			}
		}
	}
	
	if(checkedDom == undefined){
		alert("<fmt:message key='mt.task.create.alert.selectone'/>");
		return;
	}
	
	var canRecord = checkedDom.getAttribute("canRecord");
	if(canRecord == "true"){
		newTaskInfo(checkedDom.value);
	}else{
		alert("<fmt:message key='mt.task.create.alert.isnotrecorder'/>");
		return;
	}
}

/** 会议任务 新建任务*/
function newTaskInfo(meetingId){
	var url = "${pageContext.request.contextPath}/taskmanage/taskinfo.do?method=newTaskInfo&optType=Add&sourceId="+meetingId+"&sourceType=6";
	var bottomHTML = "<div class='common_checkbox_box margin_l_10 clearfix'><label class='hand' for='continueAdd'><input id='continueAdd' class='radio_com' name='continuous' value='0' type='checkbox'><fmt:message key='mt.task.create.dialog.continue'/></label></div>";
	var isContinus = false;
	var ids = [];
	var dialog = getA8Top().$.dialog({
		id : 'new_task',
		url : url,
		width : 554,
		height : 420,
		top : 40,
		title : "<fmt:message key='mt.task.create.dialog.title'/>",
		targetWindow : getA8Top(),
		bottomHTML : bottomHTML,
		closeParam : {
			show : true,
			handler : function() {
				/* if(isContinus == true){
					refreshPage();
				} */
				if (ids.length != 0){
					refreshPage();
				}
			}
		},
		buttons : [ {
			text : "<fmt:message key='mt.task.create.dialog.ok'/>",
			isEmphasize : true,
			id : 'ok',
			handler : function() {
					var isChecked = dialog.getObjectById("continueAdd").is(":checked");
					var ret = dialog.getReturnValue({
							isChecked: isChecked, 
							ids: ids, 
							dialog: dialog, 
							callback: function(){
							refreshPage();
						}
					});
					
					isContinus = isContinus == true ? isContinus : isChecked;
				}
		}, {
			text : "<fmt:message key='mt.task.create.dialog.cancel'/>",
			handler : function() {
				if (ids.length != 0){
					refreshPage();
				}
				dialog.close();
			}
		}]
	});
}
//会议任务
function openMeetingTaskDetail(meetingId, canRecord) {
	var url = "taskmanage/taskinfo.do?method=meetingTaskList&meetingId="+meetingId+"&canRecord="+canRecord;
	v3x.openWindow({
		  workSpace:true,
		  url : url,
		  dialogType : "open",
		  resizable:"yes"
	  });
}
function refreshPage(){
	window.location.href = window.location.href;
}

/** 会议列表操作：删除  **/
function deleteMeeting() {
	var meetingIds = "";
	
	var checkedBox;
	var num = 0;
	
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++) {
		if(ids[i].checked) {
			checkedBox = ids[i];
			
			var state = checkedBox.getAttribute("state");
			var recordState = checkedBox.getAttribute("recordState");

			//当会议室审核状态不通过的时候允许删除
			var roomState = checkedBox.getAttribute("roomState");
            if((state==10 || state==20) && roomState != 2) {//未召开||召开中
			    alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_4"));//会议还未结束，不能进行删除操作！
                return;
			}
			//by wuxiaoju 该逻辑存在问题，永远不可能执行该if。与测试确认已发列表删除不需要根据是否已做会议纪要判断，因此注释该部分。
			/* if(recordState==2 && state==20) {//已做会议纪要
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_5"));//该会议已做过会议纪要，不允许撤销！
				return;
			} */
			
			if(meetingIds != "") {
				meetingIds += ",";
			}
			
			meetingIds += checkedBox.value;
			
			num++;
		}
	}
	
	if(num == 0) {
		alert(v3x.getMessage("meetingLang.choose_item_to_delete"));
		return;
	}
	
	if(confirm(v3x.getMessage("meetingLang.sure_to_delete"))) {
		window.location.href = 'meeting.do?method=deleteMeeting&id='+meetingIds+"&listType="+listType;
	}
}

/** 会议列表操作：归档 * */
var pigeonholeCallbackIds = "";
function meetingPigeonhole() {
    
	var appName = '${AppKey_Meeting}';
    
	var checkedBoxs = getCheckedBoxs();
	if(!checkedBoxs || checkedBoxs.length==0) {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return false;
	}
	
	var meetingIds = "";
	var attFlags = "";
	for(var i=0; i<checkedBoxs.length; i++) {
		var checkedBox = checkedBoxs[i];
		var meetingId = checkedBox.value;
		var state = ht.items(createUserIdTable[i]);
		

	if (userInternalID != createUserIdTable.items(meetingId)
					&& userInternalID != recorderUserIdTable.items(meetingId)
					&& userInternalID != emceeUserIdTable.items(meetingId)) {
				alert(v3x.getMessage("meetingLang.you_can_not_pigeonhole"));
				return false;
			} else if (state == 0 || state == 10 || state == 20) {
				alert(v3x.getMessage("meetingLang.meeting_no_pigeonhole"));
				return false;
			} else if (state == -10) {
				alert(v3x
						.getMessage("meetingLang.meeting_list_toolbar_not_cancel_pigeonhole"));
				return false;
			}

			if (meetingIds != "") {
				meetingIds += ",";
				attFlags += ",";
			}
			meetingIds += meetingId;
			attFlags += checkedBox.getAttribute("attFlag");
		}
		pigeonhole(appName, meetingIds, attFlags, "", "", "pigeonholeCallback");
	}
	//归档回调函数
	function pigeonholeCallback(result) {
		if (result == 'failure') {
			//alert(v3x.getMessage("meetingLang.pigeonhole_failure"));
		} else if (result == 'cancel') {

		} else {
			var menuId = null;
			switch ("${listType}") {
			case 'listWaitSendMeeting':
				menuId = "waitSendPanel";
				break;
			case 'listSendMeeting':
				menuId = "sendPanel";
				break;
			case 'listPendingMeeting':
				menuId = "pendingPanel";
				break;
			case 'listDoneMeeting':
				menuId = "donePanel";
				break;
			case 'listMeetingSummary':
				menuId = "summaryPanel";
				break;
			}

			var refURL = "meeting.do?method=pigeonhole&id="
					+ getCheckedboxIds() + "&folders=" + result + "&listType="
					+ listType + "&listMethod=${listMethod}&menuId=" + menuId;
			setTimeout(function() {

				parent.location.href = refURL;
			}, 10);
		}
		return;
	}

	function getCheckedBox() {
		var checkedBox;
		var inputIds = document.getElementsByName('id');
		for (var i = 0; i < inputIds.length; i++) {
			if (inputIds[i].checked) {
				checkedBox = inputIds[i];
				break;
			}
		}
		return checkedBox;
	}
	function getCheckedBoxs() {
		var inputIds = document.getElementsByName('id');
		var ids = [];
		var j = 0;
		for (var i = 0; i < inputIds.length; i++) {
			if (inputIds[i].type == "checkbox" && inputIds[i].name == "id"
					&& inputIds[i].checked) {
				ids[j++] = inputIds[i];
			}
		}
		return ids;
	}
	function getCheckedboxIds() {
		var inputIds = document.getElementsByName('id');
		var ids = "";
		for (var i = 0; i < inputIds.length; i++) {
			if (inputIds[i].checked) {
				if (ids != "") {
					ids += ",";
				}
				ids += inputIds[i].value;
			}
		}
		return ids;
	}

	function validateSelectedItem(currentUser, createUserIdTable,
			selectedUsers, ht) {
		for (var i = 0; i < selectedUsers.length; i++) {
			if (ht.items(selectedUsers[i]) == 0
					|| ht.items(selectedUsers[i]) == 10
					|| ht.items(selectedUsers[i]) == 20) {
				alert(v3x.getMessage("meetingLang.meeting_no_pigeonhole"));
				return false;
			} else if (ht.items(selectedUsers[i]) == -10) {
				alert(v3x
						.getMessage("meetingLang.meeting_list_toolbar_not_cancel_pigeonhole"));
				return false;
			} else if (currentUser != createUserIdTable.items(selectedUsers[i])
					&& currentUser != recorderUserIdTable.items(selectedUsers[i])
					&& currentUser != emceeUserIdTable.items(selectedUsers[i])) {
				alert(v3x.getMessage("meetingLang.you_can_not_pigeonhole"));
				return false;
			}
		}
		return true;
	}
	/** 会议列表操作：会议转发协同  **/
	function meetingToCol() {
		var meetingId = getSelectId();
		if (meetingId == '') {
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		} else if (validateCheckbox("id") > 1) {
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		parent.parent.location.href = baseUrl + 'meetingToCol' + '&id='
				+ meetingId;
	}
	/** 会议列表操作：会议纪要转发协同  **/
	function summaryToCol() {
		var meetingId = getSelectId();
		if (meetingId == '') {
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		} else if (validateCheckbox("id") > 1) {
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		if (ht.items(meetingId) == 40) {
			parent.parent.location.href = baseUrl + 'summaryToCol' + '&id='
					+ meetingId;
		} else {
			alert(v3x.getMessage("meetingLang.meeting_no_summary"));
			return;
		}
	}
	/******************************** 会议列表操作 end **************************************/

	/******************************** 会议列表小查询 start **************************************/
	function ChangedEvent(obj) {
		var beginDate = document.getElementById("fromDate");
		var endDate = document.getElementById("toDate");
		if (beginDate != null && endDate != null) {
			beginDate.value = "";
			endDate.value = "";
		}
		showNextCondition(obj);
	}
	function search_result() {
		var beginDate = document.getElementById("fromDate").value;
		var endDate = document.getElementById("toDate").value;
		if (compareDate(beginDate, endDate) > 0) {
			alert(v3x.getMessage("meetingLang.meeting_time_alert"));
			return;
		}
		doSearch();
	}
	/******************************** 会议列表小查询 end **************************************/

	/******************************** 会议详细页面 end **************************************/
	//会议列表单击
	function displayMeetingDetail(meetingId, proxyId) {
		// 取消上次延时未执行的方法
		//执行延时
		var url = '${mtMeetingURL}?method=mydetail&id=' + meetingId
				+ '&proxyId=' + proxyId;
		var id = meetingId;
		meetingOpenNewWin({
			"url" : url,
			"id" : id
		});
	}

	//会议列表查看会议纪要
	function openMeetingSummaryDetail(summaryId, meetingId, isYes) {
		var url = 'meetingSummary.do?method=myDetailFrame&recordId='
				+ summaryId + "&mId=" + meetingId + "&listType=${listType}";
		meetingOpenNewWin({
			"url" : url,
			"id" : summaryId
		});
	}

	function meetingSummaryCreate(meetingId, summaryId) {
		var url = "meetingSummary.do?method=createSummary&meetingId="
				+ meetingId + "&summaryId=" + summaryId + "&listType="
				+ listType;
		meetingOpenNewWin({
			"url" : url,
			"id" : summaryId
		});
	}

	//会议处理后关闭
	function closeMeetingWindow() {
	}
	/******************************** 会议详细页面 end **************************************/

	/******************************** 数据校验 start **************************************/

	/******************************** 数据校验 end **************************************/

	/******************************** 工具方法 start **************************************/
	function selectDateTime(whoClick) {
		var date = whenstart('${path}', whoClick, 575, 140);
		var newDate = new Date();
		var strDate = newDate.getYear() + "-" + (newDate.getMonth() + 1) + "-"
				+ newDate.getDate();
		strDate = formatDate(strDate);
		if (whoClick.id == 'fromDate') {
			if (document.getElementById('toDate').value != ""
					&& date > document.getElementById('toDate').value) {
				alert(v3x
						.getMessage("meetingLang.checkdate_startdoesnotlateend"));
			} else if (null != date) {
				whoClick.value = date;
			}
		}
		if (whoClick.id == 'toDate') {
			if (document.getElementById('fromDate').value != ""
					&& date < document.getElementById('fromDate').value) {
				alert(v3x.getMessage("meetingLang.checkdate_enddoeslatestart"));
			} else if (null != date && date != "") {
				whoClick.value = date;
			}
		}
	}
	/******************************** 工具方法 end **************************************/

	/******************************** 会议查看页面 start **************************************/
	//文章页面弹出窗口
	function openWin(url) {
		var rv = v3x.openWindow({
			url : url,
			dialogType : "open"
		});
	}
	/******************************** 会议查看页面 end **************************************/
</script>
<c:choose>
	<c:when test="${listType=='listSendMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingArrange" panelId="sendPanel" locationText="${sendPanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listWaitSendMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingArrange" panelId="waiSendPanel" locationText="${waitSendPanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listPendingMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingPending" panelId="pendingPanel" locationText="${pendingPanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listDoneMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingDone" panelId="donePanel" locationText="${donePanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listMeetingSummary' }">
		<span id="currentPanel" resCodeParent="F09_meetingDone" panelId="summaryPanel" locationText="${summaryPanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listMethod=='create' }">
		<span id="currentPanel" resCodeParent="F09_meetingArrange" panelId="createBtn" locationText="${createLabel}" style="display:none"></span>
	</c:when>
</c:choose>

<jsp:include page="../include/deal_exception.jsp" />
