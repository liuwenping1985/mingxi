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
</span>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var listType = '${listType}';

baseUrl = '${meetingSummaryURL}?method=';

var ht = new Hashtable();
var createUserIdTable = new Hashtable();
var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";

/******************************** 会议纪要列表页面加载 start **********************************/
window.onload = function() {
	initList();
}
/** 列表页面加载 **/
function initList() {
	setCurrentPanel();
	showMeetingLocation();
	initListDetail();
}
/** 当前位置 **/
function showMeetingLocation() {
	var currentPanel = document.getElementById("currentPanel");
	if(currentPanel != null) {
		showCtpLocation(currentPanel.getAttribute('resCodeParent'));
	}
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
	previewFrame('Down');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.meetingrecord' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_2"));
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv", 550, 870);
}
/** 会议列表操作：按钮页签链接  **/
function setPanelURL(currentListType) {
	var url = '${meetingNavigationURL}?method=list&listType='+currentListType;
	location.href = url;
}

$(function() {
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", v3x.getMessage("meetingLang.meeting_choose_all"));
		}
	}, 100);
});
/******************************** 会议纪要列表页面加载 end **************************************/

/******************************** 会议纪要列表操作 start **************************************/
/** 会议纪要列表操作：编辑  **/
function editMeetingSummary() {
	
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
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_edit_item"));
		return;
	} else if(num > 1) {
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_only_choose_one_toEdit"));
		return;
	}	
	var summaryId = checkedBox.value;
	var createUser = checkedBox.getAttribute("createUser");
	var state = checkedBox.getAttribute("state");
	if(state == "4") {
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_edit_pass_alert"));
		return;
	} else if(state == "3") {
		alert(v3x.getMessage("meetingLang.summary_auditing_notallow_edit"));
	}
	if(userInternalID == createUser) {
		var url = "meetingSummary.do?method=createSummary&summaryId="+summaryId+"&listType=${listType}";
		meetingOpenNewWin({'url':url, 'id':summaryId});
	} else {
		alert(v3x.getMessage("meetingLang.you_not_creater"));
		return;
	}
}

/** 会议纪要列表操作：撤销（待审核、审核通过）  **/
 var summaryId = '';
function cancelMeetingSummary() {
	var ids = document.getElementsByName('id');
	for(var i=0; i<ids.length; i++) {
		var idCheckBox = ids[i];
		if(idCheckBox.checked) {
			//只有创建者可以删除会议
			if(userInternalID != idCheckBox.getAttribute("createUser")){
				alert(v3x.getMessage("meetingLang.you_not_creater"));
				return;
			}
			summaryId = summaryId + idCheckBox.value+'&';
		}
	}
	if(summaryId == '') {
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_cancel_item"));
		return;
	}
	
	var url = "meeting.do?method=openCancelDialog";
	openMeetingDialog(url, v3x.getMessage("meetingLang.meeting_action_cancel_summary"), 400, 260, function(returnValue, canSendSMS) {
		cancelMeetingCallback(returnValue, canSendSMS);
	});
}
function cancelMeetingCallback(returnValue, canSendSMS) {
	if(returnValue!=null) {
	    if(summaryId != ''){
	      summaryId = summaryId.substring(0,summaryId.length-1);
	    }
		document.getElementById("content").value = returnValue;
		var myform = document.getElementsByName("listForm")[0];
		myform['id'].value = summaryId;
    	myform.action =  "meetingSummary.do?method=cancelMeetingSummary&listType=${listType}";
    	myform.method =  "post";
    	myform.submit();
	}
}
/** 会议纪要列表操作：删除（逻辑删除我发布的会议纪要（审核未通过））  **/
function deleteMeetingSummary(listType){
	var ids = document.getElementsByName('id');
	var summaryId = '';
	var summaryState = null;
	for(var i=0; i<ids.length; i++) {
		var idCheckBox = ids[i];
		if(idCheckBox.checked) {
			summaryState = idCheckBox.getAttribute("state");
			if(summaryState != 5){//lijl修改提示信息
				alert(v3x.getMessage("meetingLang.summary_list_tollbar_no_delete"));
				return;
			}
			summaryId = summaryId + idCheckBox.value + ',';
		}
	}
	if(summaryId == '') {
		alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_delete_item_1"));
		return;
	}

	if(confirm(v3x.getMessage("meetingLang.summary_list_toolbar_only_delete_confirm"))) {
  		var myform = document.getElementsByName("listForm")[0];
  		myform['id'].value = summaryId;
  		myform.action =  "${meetingSummaryURL}?method=deleteMeetingSummary&listType="+listType;
  		myform.method =  "post";
  		myform.submit();
	}
}
 /** 会议纪要列表操作：转发 1、协同   2、公文  **/
function summaryTransmit(type) {
    var selectedCount = 0;
    var summaryId = null;
    var summaryState = null;
    var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return true;
    }
    var id_checkbox = document.getElementsByName("id");
    if (!id_checkbox) {
        return true;
    }
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            summaryId = id_checkbox[i].getAttribute("value");
            summaryState= id_checkbox[i].getAttribute("state");
            selectedCount++;
        }
    }
    if (selectedCount == 0) {
        alert(v3x.getMessage("meetingLang.meeting_selectOne"));
        return true;
    }
    if (selectedCount > 1) {
        alert(v3x.getMessage("meetingLang.meeting_only_selectOne"));
        return true;
    }
    if(summaryState!=4 && summaryState!=6){
        alert(v3x.getMessage("meetingLang.meeting_only_selectPassed"));
        return true;
    }
    if(type==1) { //转发协同
    	
    	if(!window.getCtpTop){
    		window.getCtpTop = function(){
    			return parent.parent.parent.parent.getA8Top();
    		}
    	}
    
    	collaborationApi.newColl({
            manual : "true",//后台进行数据设置
            from : 'meeting_summary',
            handlerName : 'meeting',
            sourceId : summaryId,
            ext : ''
        });
    	
    } else if(type==2) { //转发公文
    	$("#detailFrame", window.parent.document).remove();
    	window.location.href = 'meetingSummary.do?method=summaryToEdoc&id='+summaryId;
    }
    return true;
}
/******************************** 会议纪要列表操作 end **************************************/


/******************************** 会议纪要列表小查询 start **************************************/
function ChangedEvent(obj) {
	var beginDate = document.getElementById("fromDate");
	var endDate = document.getElementById("toDate");
	var summaryFromDate = document.getElementById("summaryFromDate");
	var summaryToDate = document.getElementById("summaryToDate");
	if(beginDate != null && endDate != null){
		beginDate.value = "";
		endDate.value = "";
	}
	if(summaryFromDate != null && summaryToDate != null){
		summaryFromDate.value = "";
		summaryToDate.value = "";
	}
	showNextCondition(obj);
}
function search_result() {
	var beginDate = document.getElementById("fromDate").value;
	var endDate = document.getElementById("toDate").value;
	var summaryFromDate = document.getElementById("summaryFromDate").value;
	var summaryToDate = document.getElementById("summaryToDate").value;
	if(compareDate(beginDate,endDate)>0){
		alert(v3x.getMessage("meetingLang.meeting_time_alert"));
		return ;
	}else if(compareDate(summaryFromDate,summaryToDate)>0){
		alert(v3x.getMessage("meetingLang.meeting_time_alert"));
		return ;
	}
	doSearch();
}
/******************************** 会议纪要列表小查询 end **************************************/


/******************************** 会议纪要详细页面 start **************************************/

//会议列表单击
function displayMeetingSummaryDetail(recordId,meetingId,proxy,proxyId) {
	var url = "meetingSummary.do?method=mydetail&recordId="+recordId+"&mId="+meetingId+"&proxy="+proxy+"&proxyId="+proxyId+"&listType="+listType;
	meetingOpenNewWin({"url":url, "id":recordId});
}
//会议列表双击
function openMeetingSummaryDetail(recordId,meetingId,proxy,proxyId) {
	var url = 'meetingSummary.do?method=myDetailFrame&recordId='+summaryId+"&mId="+meetingId+"&listType=${listType}";
	meetingOpenNewWin({"url":url, "id":recordId});
}
//会议处理后关闭
function closeMeetingWindow() {
}

/******************************** 会议详细页面 end **************************************/


/******************************** 工具方法 start **************************************/
function selectDateTime(whoClick) {
    var date = whenstart('${path}', whoClick, 575,140);
}
/******************************** 工具方法 end **************************************/

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
