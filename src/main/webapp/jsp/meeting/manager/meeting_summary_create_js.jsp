<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<c:set value="${param.listType }" var="listType" />
<c:set value="${param.listMethod }" var="listMethod" />

<span style="display:none">

	<fmt:message key='' var='pendingPanelLabel' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<fmt:message key='meeting.summary.record.publish' bundle='${v3xMeetingSummaryI18N}' var='summaryPanelLabel'/>

	<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' var='sendBtn' />
	<fmt:message key='meeting.list.button.waitsend' var='saveBtn' />
	<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}' var='openTemplateBtn' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<!-- 
	<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' var='saveBtn'/>
	 -->
	<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' var='insertBtn' />
	<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' var='insertAttsBtn' />
	<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' var='insertDocBtn' />
	<fmt:message key='mt.templet.saveAs' var='saveAsBtn' />
	<fmt:message key="mt.list.column.mt_name" var="subjectLabel" />
	<fmt:message key="mt.mtMeeting.beginDate" var="beginDateLabel" />
	<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" var="endDateLabel" />
	<fmt:message key="mt.mtMeeting.createUser" var="createUserLabel" />
	<fmt:message key="mt.mtMeeting.emceeId" var="emceeIdLabel" />
	<fmt:message key="mt.mtMeeting.recorderId" var="recorderIdLabel" />
	<fmt:message key="mt.mtMeeting.place" var="placeLabel" />
	<fmt:message key="mt.mtMeeting.meetingType" var="meetingTypeLabel" />
	<fmt:message key="mt.mtMeeting.meetingCategory" var="meetingCategory" />
	<fmt:message key="mr.button.appMeetingRoom" bundle="${v3xMeetingRoomI18N}" var="roomAppLabel" />
	<fmt:message key="mt.mtMeeting.join" var="joinLabel" />
	<fmt:message key="mt.mtMeeting.join.actual" var="joinActualLabel" />
	<fmt:message key="mt.mtMeeting.projectId" var="projectIdLabel" />
	<fmt:message key="mt.mtMeeting.meetingNature" var="meetingNatureLabel" />
	<fmt:message key="mt.mtMeeting.password" var="passwordLabel" />
	<fmt:message key="mt.mtMeeting.letter.or.num" var="letterLabel" />
	<fmt:message key="mt.mtMeeting.password.confirm" var="passwordConfirmLabel" />
	<fmt:message key="mt.mtMeeting.character" var="characterLabel" />
	<fmt:message key="mt.mtMeeting.label.video" var="videoLabel" />
	<fmt:message key="mt.mtMeeting.label.ordinary" var="ordinaryLabel" />
	<fmt:message key="mt.resource" var="resourceLabel" />
	<fmt:message key="mt.mtMeeting.remindFlag" var="remindFlagLabel" />
	<fmt:message key="mt.mtMeeting.templateId" var="templateIdLabel" />
	<fmt:message key="mt.mtMeeting.beforeTime" var="beforeTimeLabel" />
	
	<fmt:message key="meeting.create.more" var="moreLabel" />
	<fmt:message key="oper.please.select" var="selectLabel" />
	<fmt:message key="oper.load" var="loadLabel" />
	<fmt:message key="label.colon" var="colonLabel" />
	
	<fmt:message key='mtSummary.create.lable' bundle='${v3xMeetingSummaryI18N}' var="titleLabel" />
	<c:if test="${bean.id!=null && bean.state!=1}">
		<fmt:message key='mtSummary.edit.lable' bundle='${v3xMeetingSummaryI18N}' var="titleLabel" />
	</c:if>
	<c:set value="${titleLabel }" var="titleLabel"></c:set>
		
</span>

<c:set value="${v3x:parseElements(meetingEmceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(meetingRecorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(meetingConfereeList, 'id', 'entityType')}" var="confereesList"/>
<c:set value="${v3x:parseElements(scopeList, 'id', 'entityType')}" var="scopesList"/>
<c:set value="${v3x:parseElements(auditorList, 'id', 'entityType')}" var="auditorsList"/>

<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="confereesSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker" selectType="Member,Department,Team,Post" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="scopes" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${scopesList}" panels="Department,Team,Outworker,Level" selectType="Member,Department,Team,Level" jsFunction="setMtPeopleFields(elements,'scopes','scopesNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" minSize="0" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<v3x:selectPeople id="auditors" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${auditorsList}" panels="Department,Team" selectType="Member" jsFunction="selectAuditors(elements)" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

<script type="text/javascript">
var elements_emceeArr = elements_emcee;
var elements_confereesSelectArr = elements_confereesSelect;
var elements_scopesArr = elements_scopes;
var elements_recorderArr = elements_recorder;
var elements_impartSelectArr = elements_impartSelectArr;
var hiddenPostOfDepartment_conferees = true;
//不受职务级别控制
var isNeedCheckLevelScope_scopes = false;
window.onload = function() {	
	showMeetingLocation();
	
	loadUE();
}

/** 当前位置 **/
function showMeetingLocation() {
	var currentPanel = document.getElementById("currentPanel");
	if(currentPanel != null) {
		showCtpLocation(currentPanel.getAttribute('resCodeParent'));	
	}
}
function loadUE() {
	//TODO
	//window.onbeforeunload = null;
	
	//界面高度调整
	var headHeight = $("#contentTable").height();
	initIe10AutoScroll('scrollListDiv', headHeight);
	
	//detailFrame屏蔽
	if(parent.document.getElementById("sx")) {
		parent.document.getElementById("sx").rows = "100%,0";
	}
}


//调用send方法
function toSend(type) {
	document.getElementById('formOper').value = type;
	if(document.getElementById("isAudit") !=null && document.getElementById("auditors") != null) {
		if( type == 'send' && document.getElementById("isAudit").checked && document.getElementById("auditors").value == ""){
			alert("审核人员不能为空!");
			return false;
		}
	}
	
	//实际与会人员判断
	var scopesValue = document.getElementById("scopes").value;
	if(type == 'send' && !scopesValue){
	    //"请填写实际与会人员！"
	    alert(v3x.getMessage("meetingLang.meeting_summary_input_scopes"));
	    return false;
	}
	
	saveAttachment();
	cloneAllAttachments();
	isHasAtts();
	if(!saveOffice()) {
		return ;
	}
	disableButtons();
	if (getA8Top().isCtpTop == undefined || getA8Top().isCtpTop == "undefined") {
		document.getElementById('isOpenWindow').value = "true";
    }
	document.getElementById('dataForm').target="";
	document.getElementById('dataForm').submit();
}

function isHasAtts() {
	if(fileUploadAttachments.size()>0) {
		document.getElementById("isHasAtt").value = "true";
	} else {
	    document.getElementById("isHasAtt").value = "false";
	}
}

function chanageBodyTypeExt(type) {
	if(chanageBodyType(type)) {
		document.getElementById('dataFormat').value=type;
	}
}

//xiangfan 添加	
function saveAsDraft(checkFlag){
	toSend("save");
}
	
function disableButtons() {
    disableButton("send");
    disableButton("save");
    disableButton("saveAs");
    disableButton("insert");
    disableButton("cancel");
    disableButton("bodyTypeSelectorspan");
    disableButton("bodyTypeSelector");
    
    isFormSumit = true;
    var title = document.getElementById('title').value;
    document.getElementById('title').value = title.trim();
}

function checkSelectConferees(element) {
	if(!isDefaultValue(element)){
		selectMtPeople('confereesSelect','conferees');
		return false;
	}
	return true;
}

function selectAuditors(elements){
	var elementsIds = getIdsString(elements,true);
	var memberNames = getNamesString(elements);	
	document.getElementById("auditors").value=elementsIds;
	document.getElementById("auditorNames").value=memberNames;	
}

function openLeader() {
	var winWidth = 500;
	var winHeight = 370;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var approves = document.getElementById("auditors").value;
	var url = "mtAppMeetingController.do?method=openLeader&approves="+approves+"&fromType=3&ndate="+new Date();
	var retObj = window.showModalDialog(url,window ,feacture);
}
</script>

<jsp:include page="../include/deal_exception.jsp" />

<c:choose>
	<c:when test="${listType=='listPendingMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingPending" panelId="pendingPanel" locationText="${pendingPanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listDoneMeeting' }">
		<span id="currentPanel" resCodeParent="F09_meetingDone" panelId="donePanel" locationText="${donePanelLabel}" style="display:none"></span>
	</c:when>
	<c:when test="${listType=='listMeetingSummary' }">
		<span id="currentPanel" resCodeParent="F09_meetingDone" panelId="summaryPanel" locationText="${summaryPanelLabel}" style="display:none"></span>
	</c:when>
</c:choose>
