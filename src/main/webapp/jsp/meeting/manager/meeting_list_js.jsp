<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<c:set value="${param.listType }" var="listType" />
<c:set value="${param.listMethod }" var="listMethod" />
<c:set value="全选" var="selectAllLabel" />
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />

<span style="display:none">
	<fmt:message key='mt.mtMeeting.state.sendWait' var='waitSendPanelLabel' />
	<fmt:message key='mt.mtMeeting.state.send' var='sendPanelLabel' />
	<fmt:message key='' var='pendingPanelLabel' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<fmt:message key='meeting.summary.record.publish' bundle='${v3xMeetingSummaryI18N}' var='summaryPanelLabel'/>
	<fmt:message key='oper.newMeeting' var='createLabel' />
	<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' var='editLabel' />
	<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}' var='cancelLabel' />
	<fmt:message key='mt.list.toolbar.delete.label' var='deleteLabel' />
	<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' var='pigeonholeLabel' />
	<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' var='summaryToColLabel' />
	<fmt:message key='mtSummary.toolbar.transmit.edoc.label' bundle='${v3xMeetingSummaryI18N}' var='summaryToEdocLabel' />
</span>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var listType = '${listType}';

baseUrl = '${meetingURL}?method=';

var ht = new Hashtable();
var createUserIdTable = new Hashtable();
var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";

/******************************** 会议列表页面加载 start **********************************/
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

$(function() {
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
		}
	}, 100);
});

/******************************** 会议列表页面加载 end **************************************/


/******************************** 会议列表操作 start **************************************/
/** 会议列表操作：新建会议  **/
function createMeeting() {
	var url = baseUrl+"create&listMethod=listMyMeeting&listType="+listType;
	meetingOpenNewWin({"url":url, id:"100"});
}

/** 会议列表操作：编辑  **/
var editMeetingGetActionParamParams = {};
function editMeeting(meetingId) {
    
    var periodicityInfoId;
    
	if(!meetingId) {
		meetingId = getSelectId();
		if(meetingId == '') {
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		if(validateCheckbox("id") > 1) {
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_only_choose_one_toEdit"));
			return;
		}
		periodicityInfoId = getSelectPeriodicityInfoId();
	}else{
		periodicityInfoId = getSelectPeriodicityInfoId();
	}
	if(userInternalID==createUserIdTable.items(meetingId)){
		<%-- 已经开始的会议不允许修改，其他均允许修改 --%>
		if(!validateMeetingCanEdit(meetingId)) {
			alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
			return;
		}
		editMeetingGetActionParamParams = {};
		editMeetingGetActionParamParams.meetingId = meetingId;
		
		//周期性判断
		getActionParam(meetingId, periodicityInfoId, "edit", editMeetingGetActionParamCallbackFn);
		
	} else {
		alert(v3x.getMessage("meetingLang.you_not_creater"));
		return;
	}
}

/**
 * 修改进行周期性会议回调
 */
function editMeetingGetActionParamCallbackFn(param){
    
    var meetingId = editMeetingGetActionParamParams.meetingId;
    
    if(param == "return"){
        return;
    }
    
    var url = baseUrl + 'edit' + '&id=' + meetingId + '&flag=editMeeting&listType=' + listType + param;
    meetingOpenNewWin({'url':url,'id':meetingId});
}

/**
 * 周期会议操作回调方法
 */
function getActionParamCallback(type){
    
    var callbackFn = getActionParamParams.callbackFn || function(v){};
    var periodicityInfoId = getActionParamParams.periodicityInfoId
    var param = "";
    
	document.getElementById("editType").value = type
	var editType = document.getElementById("editType").value;
	
	//编辑选取消
	if(editType == 3 || editType == ""){
	    param = "return";
	}
	//批量修改
	if(editType == 2){
		param = "&periodicityInfoId="+periodicityInfoId;
	}
	
	if(periodicityInfoId != "" && '${param.listType}' == 'listWaitSendMeeting'){
		param = "&periodicityInfoId="+periodicityInfoId;
	}

	callbackFn(param);
	commonDialogClose('win123');
}

/**
 * 周期会议抄作选择界面，撤销和修改公共页面
 * @param meetingId 会议ID
 * @param periodicityInfoId 周期ID
 * @param type cancel or edit
 * @callbackFn 回调函数  验证不通过返回return
 */
 var getActionParamParams = {};
function getActionParam(meetingId,periodicityInfoId,type,callbackFn){
    
    callbackFn = callbackFn || function(v){};
    
    getActionParamParams = {};//清空参数
    
    getActionParamParams.meetingId = meetingId;
    getActionParamParams.periodicityInfoId = periodicityInfoId;
    getActionParamParams.callbackFn = callbackFn;
    
	if(periodicityInfoId != "" && ('${param.listType}' == 'listSendMeeting' || '${param.listType}' == 'listPendingMeeting')){
	    
	    //周期会议的逻辑
		getA8Top().win123 = getA8Top().$.dialog({
			title:'周期性选择',
			transParams:{'parentWin':window},
		    url:baseUrl+"selectSimpleOrAll&type="+type+"&id="+meetingId+"&periodicityInfoId="+periodicityInfoId,
		    width:300,
		    height:120
	  	});
	    
    }else{
        callbackFn("");//
    }
}


/** 会议列表操作：撤销  **/
var cancelMeetingGetActionParamParams = {};
function cancelMeeting() {
    
    var periodicityInfoId;
    var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }
    var meetingId = '';
	var ids = document.getElementsByName('id');
	var num = 0;
	for(var i=0; i<ids.length; i++) {
		var idCheckBox = ids[i];
		if(idCheckBox.checked) {
			//只有创建者可以删除会议
			/*if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
				alert(v3x.getMessage("meetingLang.you_not_creater"));
				return;
			}*/
			if(idCheckBox.getAttribute("state")!=10 && idCheckBox.getAttribute("state")!=20) {//已召开
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_6"));
				return;
			}
			if(idCheckBox.getAttribute("recordState")==2 && idCheckBox.getAttribute("state")==20) {//已做会议纪要
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_5"));
				return;
			}
			if(idCheckBox.getAttribute("state")==-10) {//已归档
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_3"));
				return;
			}
			meetingId = meetingId+idCheckBox.value+',';
			periodicityInfoId = idCheckBox.getAttribute("periodicityInfoId");
			num++;
		}
	}
	if(meetingId == ''){
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}
	if(num > 1){
		alert(v3x.getMessage("meetingLang.not_choose_more_item_from_list"));
		return;
	}

	cancelMeetingGetActionParamParams = {};
	cancelMeetingGetActionParamParams.periodicityInfoId = periodicityInfoId;
	cancelMeetingGetActionParamParams.meetingId = meetingId;
	
	getActionParam(meetingId,periodicityInfoId,"cancel", cancelMeetingGetActionParamCallbackFn);//判断周期性情况
}

/**
 * 撤销时选择周期性回调函数
 */
 var cancelMeetingMsgWinParams = {};
function cancelMeetingGetActionParamCallbackFn(param){
    
    var periodicityInfoId = cancelMeetingGetActionParamParams.periodicityInfoId;
    var meetingId = cancelMeetingGetActionParamParams.meetingId;
    
    cancelMeetingMsgWinParams = {};
    cancelMeetingMsgWinParams.meetingId = meetingId;
    cancelMeetingMsgWinParams.param = param;
    
    if(param == "return"){
        return
    }

    /** 填写撤销意见 **/
    window.win123 = getA8Top().$.dialog({
        title:'<fmt:message key="meeting.alert.cancle"></fmt:message>',
        transParams:{'parentWin':window,"popWinName":"win123"},
        url: baseUrl + "cancelMeetingDialog",
        width: 450,
        height: 260,
        resizable: true
    }); 
}

/**
 * 撤销意见填写回调函数
 */
function cancelMeetingCallback(rv){
    
	if(rv){
		
	    var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return false;
	    }
	    
	    var meetingId = cancelMeetingMsgWinParams.meetingId;
	    var param = cancelMeetingMsgWinParams.param;
	    
	    var hiddenObj = document.getElementById("canSendSMS");
		
		if(hiddenObj && hiddenObj.value == "true"){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxmtMeetingManager", "checkNoPhoneNumber", false);
			requestCaller.addParameter(1, "String", meetingId);
			var ds = requestCaller.serviceRequest();
			if(ds != "<V><![CDATA[]]></V>"){
				alert(v3x.getMessage("meetingLang.calcel_meeting_send_sms_alert_info")+ds);
			}else{
				alert(v3x.getMessage("meetingLang.calcel_meeting_send_sms_all"));
			}
		}
        var element = document.createElement("input");
		element.setAttribute('type', 'hidden');
		element.setAttribute('name', 'cancelComment');
		element.setAttribute('value', rv);
		theForm.appendChild(element);

		var url = baseUrl + 'cancelMeeting&id=' + meetingId + "&listType=" + listType + param;
		theForm.action = url;
        theForm.method = "POST";
        theForm.submit();
	}
}

/** 会议列表操作：删除  **/
function deleteMeeting() {
	var ids = document.getElementsByName('id');
	var meetingId = '';
	var num = 0;
	for(var i=0; i<ids.length; i++) {
		var idCheckBox = ids[i];
		if(idCheckBox.checked) {
			//只有创建者可以删除会议
			/*if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
				alert(v3x.getMessage("meetingLang.you_not_creater"));
				return;
			}*/
			if(idCheckBox.getAttribute("state")==10 || idCheckBox.getAttribute("state")==20) {//未结束
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_4"));
				return;
			}
			if(idCheckBox.getAttribute("recordState")==1 && idCheckBox.getAttribute("state")==20) {//已做会议纪要
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert_5"));
				return;
			}
			meetingId = meetingId+idCheckBox.value+',';
			num++;
		}
	}
	if(meetingId == '') {
		alert(v3x.getMessage("meetingLang.choose_item_to_delete"));
		return;
	}
	var confirmMsg = v3x.getMessage("meetingLang.sure_to_delete");
	if(confirm(confirmMsg)) {
		window.location.href = baseUrl+'deleteMeeting&id='+meetingId+"&listType="+listType;
	}
}
/** 会议列表操作：归档 * */
var meetingPigeonholeCallbackIds = "";
function meetingPigeonhole() {
    var appName = '${AppKey_Meeting}';
    meetingPigeonholeCallbackIds = getSelectId(true);
    if (meetingPigeonholeCallbackIds != "") {
        meetingPigeonholeCallbackIds = meetingPigeonholeCallbackIds.substring(0, meetingPigeonholeCallbackIds.length - 1);
    }
    var idA = meetingPigeonholeCallbackIds.split(',');
    var atts = getSelectAtts();
    if (atts != "") {
        atts = atts.substring(0, atts.length - 1);
    }
    var result = "";
    if (meetingPigeonholeCallbackIds == '') {
        alert(v3x.getMessage("meetingLang.choose_item_from_list"));
        return;
    }

    if (validateSelectedItem(userInternalID, createUserIdTable, idA, ht)) {
        result = pigeonhole(appName, meetingPigeonholeCallbackIds, atts, "", "",
                "meetingPigeonholeCallback");
    }
}

/**
 * meetingPigeonhole归档回调函数
 */
function meetingPigeonholeCallback(result) {
    if (result == 'failure') {
        alert(v3x.getMessage("meetingLang.pigeonhole_failure"));
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
        parent.location.href = baseUrl + "pigeonhole" + '&id=' + meetingPigeonholeCallbackIds
                + "&folders=" + result + "&listType=" + listType
                + "&listMethod=${listMethod}&menuId=" + menuId;
    }
    return;
}
	
function validateSelectedItem(currentUser, createUserIdTable, selectedUsers, ht){
  for(var i = 0;i<selectedUsers.length;i++) {
  	if(ht.items(selectedUsers[i])==0||ht.items(selectedUsers[i])==10||ht.items(selectedUsers[i])==20){
  		alert(v3x.getMessage("meetingLang.meeting_no_pigeonhole"));
		return false;
  	}else if(ht.items(selectedUsers[i])==-10) {
		alert(v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_pigeonhole"));
		return false;
	}else if(currentUser != createUserIdTable.items(selectedUsers[i])){
		alert(v3x.getMessage("meetingLang.you_can_not_pigeonhole"));
      	return false;
    }
  }
  return true;
}
/** 会议列表操作：会议转发协同  **/
function meetingToCol() {
	var meetingId = getSelectId();
	if(meetingId == '') {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	} else if(validateCheckbox("id")>1) {
		alert(v3x.getMessage("meetingLang.please_choose_one_date"));
		return;
	}
	parent.parent.location.href = baseUrl+'meetingToCol'+'&id='+meetingId;
}
/** 会议列表操作：会议纪要转发协同  **/
function summaryToCol() {
	var meetingId = getSelectId();
	if(meetingId == '') {
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}else if(validateCheckbox("id")>1){
		alert(v3x.getMessage("meetingLang.please_choose_one_date"));
		return;
	}
	if(ht.items(meetingId) == 40) {
		parent.parent.location.href = baseUrl+'summaryToCol'+'&id='+meetingId;
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
	if(beginDate != null && endDate != null){
		beginDate.value = "";
		endDate.value = "";
	}
	showNextCondition(obj);
}
function search_result() {
	var beginDate = document.getElementById("fromDate").value;
	var endDate = document.getElementById("toDate").value;
	if(compareDate(beginDate,endDate)>0){
		alert(v3x.getMessage("meetingLang.meeting_time_alert"));
		return ;
	}
	doSearch();
}
/******************************** 会议列表小查询 end **************************************/


/******************************** 会议详细页面 end **************************************/
//会议列表单击
function displayMeetingDetail(meetingId,proxy,proxyId) {
	// 取消上次延时未执行的方法
	//执行延时
   	var url = '${mtMeetingURL}?method=mydetail&id='+meetingId+'&proxy='+proxy+'&proxyId='+proxyId;
   	var id = meetingId;
   	meetingOpenNewWin({"url":url, "id":id});
}

//会议列表查看会议纪要
function openMeetingSummaryDetail(summaryId,meetingId,isYes) {
	var width = $(getA8Top().document.body).width() - 100;
	var height = $(getA8Top().document.body).height() - 50;
	var rv = v3x.openWindow({
        url: '${mtSummaryURL}?method=myDetailFrame&recordId='+summaryId+"&mId="+meetingId+"&openType=1&hiddenAuditOpinion="+isYes+"&listType=${listType}",
		dialogType : 'open',
		workSpace : 'yes',
      	width: width,
        height: height
    });
    //if(rv != null) {
    //  	window.location.reload();
    //}
    
}

function meetingSummaryCreate(meetingId, summaryId) {
	location.href = "${meetingSummaryURL}?method=createMeetingSummary&meetingId="+meetingId+"&summaryId="+summaryId+"&listType="+listType;
}

//会议处理后关闭
function closeMeetingWindow() {
}
/******************************** 会议详细页面 end **************************************/

/******************************** 数据校验 start **************************************/
//校验当前会议是否允许进行修改
function validateMeetingCanEdit(meetingId) {
	var requestCaller = new XMLHttpRequestCaller(this, "${meetingAjaxUrl}", "canEditMeeting", false);
	requestCaller.addParameter(1, "Long", meetingId);
	var result4Edit = requestCaller.serviceRequest();
	return result4Edit=='true' || result4Edit==true;
}
/******************************** 数据校验 end **************************************/


/******************************** 工具方法 start **************************************/
function selectDateTime(whoClick) {
    var date = whenstart('${path}', whoClick, 575,140);
    var newDate = new Date();
    var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
    strDate = formatDate(strDate);
	if(whoClick.id=='fromDate') {
      	if(document.getElementById('toDate').value!="" && date>document.getElementById('toDate').value) {
        	alert(v3x.getMessage("meetingLang.checkdate_startdoesnotlateend"));
      	}
      	else if(null!=date) {
         	whoClick.value = date;
      	}
    }
    if(whoClick.id=='toDate') {
      	if(document.getElementById('fromDate').value!="" && date<document.getElementById('fromDate').value) {
        	alert(v3x.getMessage("meetingLang.checkdate_enddoeslatestart"));
      	}
      	else if(null!=date&&date!="") {
         	whoClick.value = date;
      	}
    }
}
/******************************** 工具方法 end **************************************/


/******************************** 会议查看页面 start **************************************/
//文章页面弹出窗口
function openWin(url) {
	var rv = v3x.openWindow({
        url: url,
        dialogType: "open"
    });
}
/******************************** 会议查看页面 end **************************************/

</script>
<style type="text/css">
	.webfx-menu-button-content-sel .toolbar-button-icon{
		margin-top: 0px;
	}
</style>
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
