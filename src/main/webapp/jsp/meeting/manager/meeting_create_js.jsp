<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 当前位置：国际化定义 -->
<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' var="titleLabel" />
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="chrometitleLabel" />
<c:if test="${bean.id!=null}">
	<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' var="titleLabel" />
</c:if>
<fmt:message key="mt.mtMeeting" var="meetingTitle" />
<c:set value="${titleLabel }${meetingTitle }" var="titleLabel"></c:set>

<c:choose>
	<c:when test="${bean.id==null || bean.id==-1}">
		<c:set value="" var="meetingId" />
	</c:when>
	<c:otherwise>
		<c:set value="${bean.id}" var="meetingId" />
	</c:otherwise>
</c:choose>

<span style="display:none">
	<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' var='sendBtn' />
	<fmt:message key='meeting.list.button.waitsend' var='saveBtn' />
	<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}' var='openTemplateBtn' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' var='saveBtn'/>
	<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' var='insertBtn' />
	<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' var='insertAttsBtn' />
	<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' var='insertDocBtn' />
	<fmt:message key='mt.templet.saveAs' var='saveAsBtn' />
	<fmt:message key="mt.list.column.mt_name" var="subjectLabel" />
	<fmt:message key="mt.mtMeeting.beginDate" var="beginDateLabel" />
	<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" var="endDateLabel" />
	<fmt:message key="mt.mtMeeting.emceeId" var="emceeIdLabel" />
	<fmt:message key="mt.mtMeeting.recorderId" var="recorderIdLabel" />
	<fmt:message key="mt.mtMeeting.place" var="placeLabel" />
	<fmt:message key="mr.button.appMeetingRoom" bundle="${v3xMeetingRoomI18N}" var="roomAppLabel" />
	<fmt:message key="mt.mtMeeting.join" var="joinLabel" />
	<fmt:message key="mt.meeting.impart" var="impartLabel" />
	<fmt:message key="mt.mtMeeting.projectId" var="projectIdLabel" />
	<fmt:message key="meeting.mtMeeting.meetingNature" var="meetingNatureLabel" />
	<fmt:message key="mt.mtMeeting.password" var="passwordLabel" />
	<fmt:message key="mt.mtMeeting.letter.or.num" var="letterLabel" />
	<fmt:message key="mt.mtMeeting.password.confirm" var="passwordConfirmLabel" />
	<fmt:message key="mt.mtMeeting.character" var="characterLabel" />
	<fmt:message key="meeting.mtMeeting.label.video" var="videoLabel" />
	<fmt:message key="meeting.mtMeeting.label.ordinary" var="ordinaryLabel" />
	<fmt:message key="mt.resource" var="resourceLabel" />
	<fmt:message key="mt.mtMeeting.remindFlag" var="remindFlagLabel" />
	<fmt:message key="mt.mtMeeting.templateId" var="templateIdLabel" />
	<fmt:message key="mt.mtMeeting.beforeTime" var="beforeTimeLabel" />
	<fmt:message key="mt.mtMeeting.Remind" var="mtMtMeetingRemind" />
	<fmt:message key="mt.mtMeeting.messages" var="mtMtMeetingMessages" />
	<fmt:message key="meeting.create.more" var="moreLabel" />
	<fmt:message key="oper.please.select" var="selectLabel" />
	<fmt:message key="mt.meMeeting.decription" var="roomDecription" />
	<fmt:message key="mt.meetingAddress.input.plea" var="roomInput" />
	<fmt:message key="oper.load" var="loadLabel" />
	<fmt:message key="label.colon" var="colonLabel" />

	<fmt:message key="mt.mtMeeting.meetingCategory" var="meetingCategory" />
	<fmt:formatDate pattern="${datetimePattern}" value="${bean.beginDate}" var="beginDateValue" />
	<fmt:formatDate pattern="${datetimePattern}" value="${bean.endDate}" var="endDateValue" />
	<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" var="nowDate"/>
</span>

<c:set value="${v3x:parseElements(emceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(recorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(confereeList, 'id', 'entityType')}" var="confereesList"/>
<c:set value="${v3x:parseElements(leaderList, 'id', 'entityType')}" var="leaderList"/>
<c:set value="${v3x:parseElements(impartList, 'id', 'entityType')}" var="impartsList"/>
<c:set value="${v3x:parseElements(createUserList, 'id','entityType')}" var="createUser"/>

<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="confereesSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker,Level" selectType="Account,Member,Department,Team,Post,Level" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="impartSelect"    departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${impartsList}"    panels="Department,Team,Post,Outworker,Level" minSize="0" selectType="Account,Member,Department,Team,Post,Level" jsFunction="setMtPeopleFields(elements,'impart','impartNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" minSize="0" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<v3x:selectPeople id="leaderSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${leaderList}" panels="Department,Team,Post,Outworker" minSize="0" selectType="Member" jsFunction="setMtPeopleFields(elements,'leader','leaderNames')" />
<v3x:selectPeople id="createUserSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${createUser}" panels="Department,Team,Post,Outworker" selectType="Member" jsFunction="setMtPeopleFields(elements,'createUser','createUserName')" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

<script type="text/javascript">
var isConfirmExcludeSubDepartment_confereesSelect = true;
var isConfirmExcludeSubDepartment_impartSelect = true;
var elements_emceeArr = elements_emcee;
var elements_confereesSelectArr = elements_confereesSelect;
var elements_recorderArr = elements_recorder;
var elements_leaderSelectArr = elements_leaderSelect;
var elements_impartSelectArr = elements_impartSelect;
var elements_createUserSelectArr = elements_createUserSelect;
var hiddenPostOfDepartment_confereesSelect = true;
var hiddenPostOfDepartment_impartSelect = true;
var leaderSelectArrType = 0;//等于0就是自己新建或者编辑自动加载的
<c:if test="${meetingTypeFieldJSONStr eq null || empty meetingTypeFieldJSONStr}">
    var meetingTypeFieldJSONStr = {};
</c:if>
<c:if test="${meetingTypeFieldJSONStr ne null && !empty meetingTypeFieldJSONStr}">
    var meetingTypeFieldJSONStr = ${meetingTypeFieldJSONStr};
</c:if>


var ht = new Hashtable();

var shh_st = 0;
var shh_h = 26;
var formOper = "${formOper}";

/**
 * 获取元素具体浏览器顶端的高度
 */
function getEleTop(e) {
    var offset = e.offsetTop;
    if (e.offsetParent != null){
    	offset += getTop(e.offsetParent);
    }
    return offset;
};

//重新计算正文内容的高度
var _contentHeight = 0;//正文区域高度
function resetContextHeight(){
	try{//设置正文区域TD高度
		var tempTop = getEleTop($("#scrollListMeetingDiv")[0]);
	
		var cHTML = document.documentElement;
        var cBody = document.body;
		var wClientHeight = Math.min(cBody.scrollHeight, cBody.offsetHeight, 
		        cHTML.clientHeight, cHTML.scrollHeight, cHTML.offsetHeight);
	
		_contentHeight = wClientHeight - tempTop;
        $("#scrollListMeetingDiv").height(_contentHeight);
        try{
            //正文组件初始化后高度就定了，这里进行重新设置
           $("#RTEEditorDiv,#officeFrameDiv").height(_contentHeight);
           _resizeCkeContent();
            
        }catch(e){
        }
    }catch(e){}
}

//HTML正文组件高度计算需要进行重新设置，有问题
function _resizeCkeContent(){
    
    var tempBodyType = document.getElementById('bodyType').value;
    if(tempBodyType == "HTML"){//HTML正文才有问题
        
        //下面是正文组件高度兼容， 这种代码很水，无赖无其他办法
        var ckeContentClass = $("#cke_content").attr("class");
        if(ckeContentClass && ckeContentClass.length > 0){
            var tempChecNumReg = /cke_(\d+)/ig;
            var d = tempChecNumReg.exec(ckeContentClass);
            if(d){
                var tempChecNum = d[1];//数值
                
                var $tempTop = $("#cke_"+tempChecNum+"_top");
                var $tempContent = $("#cke_"+tempChecNum+"_contents");
                if($tempTop && $tempContent && $tempTop.length > 0 && $tempContent.length > 0){
                    var ckeToolBarHeight = $tempTop[0].offsetHeight;
                    var contentAreaHeight = _contentHeight - ckeToolBarHeight;
                    $tempContent.css("height",contentAreaHeight);
                }else{
                    setTimeout(_resizeCkeContent, 300);
                }
            }
        }else{
            setTimeout(_resizeCkeContent, 300);
        }
    }
}

/**
 * 插入附件回调函数
 */
function _insertAttCallback(){
    resetContextHeight();
}

/**
 * 插入关联文档窗口回调函数
 */
function quoteDocumentCallback(atts) {
    if (atts) {
        deleteAllAttachment(2);
        for (var i = 0; i < atts.length; i++) {
            var att = atts[i]
            addAttachment(att.type, att.filename, att.mimeType, att.createDate,
                    att.size, att.fileUrl, true, false, att.description, null,
                    att.mimeType + ".gif", att.reference, att.category)
        }
    }
    resetContextHeight();
}
/******************************** 初始化数据 start **************************************/
   $(function(){
	 //计算正文区域的高度
	    $("html").addClass("h100b over_hidden");

	    initMeeting();
	    showMeetingLocation();
	    //remindFlagLoad();
	    loadUE();

	    resetContextHeight();//重新计算高度

	    //检查是否有错信息进行前台提示
	    if('${errorMsg}'){
	        alertErrorMsg('${errorMsg}');
	    }
   });

/**
 * 提示错误信息
 */
function alertErrorMsg(msg){//会被后台调用
	alert(msg);
}

function initMeeting() {
	//getCanUseMeetingrooms();
	initVideoConference();
	loadCollboration();
	if(document.getElementById("meetingTypeId").value!=-1){
		showMore();
	}
	firstMtTypeContentLoad();
}

function initVideoConference() {
	<c:if test="${hasVideoConferencePlugin}">
	    validatePasswordArea();//打开页面默认不显示密码区域
	    changeTextValue('meetingPassword');
	    changeTextValue('meetingPasswordConfirm');
	</c:if>
}

function showMeetingLocation() {
	//////////////////////////当前位置
	showCtpLocation("F09_meetingArrange");
}

function loadUE() {
	//TODO
	//window.onbeforeunload = null;

	//界面高度调整
	//var headHeight = $("#contentTable").height();
	//initIe10AutoScroll('scrollListDiv', headHeight);

	//detailFrame屏蔽
	if(parent.document.getElementById("sx")) {
		parent.document.getElementById("sx").rows="100%,0";
	}
}

function remindFlagLoad(){
	var beforeTime = '${bean.beforeTime}';
	var remindFlag = '${bean.remindFlag}';
	if(remindFlag || beforeTime >0) {
		document.getElementById("remindFlag").checked = true;
	}
}

function showMore() {
	var className = $(".newinfo_more").attr("class");
	//var headHeight = $("#contentTable").height();
    switch (shh_st) {
		case 0:
			if(className!=null && className.indexOf("hidden")) {
				$(".newinfo_more").removeClass("hidden");
				//headHeight = headHeight + shh_h;
				$("._moreField").show();
			}
	        break;
	    case 1:
			if(className!=null && className.indexOf("hidden")) {
				$(".newinfo_more").addClass("hidden");
				//headHeight = headHeight - shh_h;
				$("._moreField").hide();
			}
	        break;
	}
	//$("#contentTable").height(headHeight);
	//initIe10AutoScroll('scrollListDiv', headHeight);
	if(shh_st == 0){
		/* var content_obj = document.getElementById("scrollListDiv");
		if(content_obj){
			content_obj.style.overflow = "hidden";
		} */
	}
	//IE67compatible(true);
	shh_st == 0 ? shh_st = 1 : shh_st = 0;
	resetContextHeight();//重新计算高度
}

//协同转发附件
function loadCollboration() {
	var affairIdObj = document.getElementById("affairId");
	var titleObj = document.getElementById("title");
	if(affairIdObj.value==null||affairIdObj.value=='') {
   		return;
	} else {
	     var type = "2";
	     var filename = titleObj.value;
	     var mimeType = 'collaboration';
	     if(_edocFlag){
	    	 mimeType = 'edoc';
		 }
	     var createDate = "2000-01-01 00:00:00";
	     var fileUrl = affairIdObj.value;
	     var description = fileUrl;
	     var documentType = mimeType;
	     addAttachment(type, filename, mimeType, createDate, '0', fileUrl, true, null, description, documentType, documentType + ".gif");
	}
}

function firstMtTypeContentLoad() {
	<c:if test="${hasMeetingType}">
		changeMtType(document.getElementById("meetingTypeId"),"1");
	</c:if>
	changeRoomType(document.getElementById("selectRoomType"), true);
}

function changeMtType(obj,type) {
	var mtTypeId;
	for(var i=0; i<obj.options.length; i++){
		if(obj.options[i].selected){
			mtTypeId = obj.options[i].value;
			if(type != null && type != undefined){
				if(type == "2"){//手动选择了会议类型
					leaderSelectArrType = 1;
				}
			}
			break;
		}
	}
	var url = "mtAppMeetingController.do?method=getMtTypeContents&id=${bean.id}&mtTypeId="+mtTypeId+"&date="+new Date();
	var app = '${meetAppToMeet}';
	if(app == "true"){
		url += "&needApp=app";
	}
	if (window.XMLHttpRequest) {
		req = new XMLHttpRequest();
		if(req){
			req.open("GET",url, true);
			req.onreadystatechange = complete;
			req.send(null);
		}
	} else if (window.ActiveXObject) {
		req = new ActiveXObject("Microsoft.XMLHTTP");
	}
}

function inputRoomAddress() {
	var meetingPlace = document.getElementById("meetingPlace").value;
  	meetingAddressChange(meetingPlace);
}

function changeRoomType(obj, isOnLoad) {
	//A6s版本 直接跳过
	if(projectId && projectId == "7")
		return ;
	var selectedRoomType = "";//选中的会议室id
	var meetingPlace = "";
	var meetingroomId = "";
	var startDatetime = "";
	var endDatetime = "";
	var isNeedApp = "";
	var selectedRoomName = "";
	var periodicityType = document.getElementById("periodicityType").value;
	var chooseMeetingRoom = document.getElementById("chooseMeetingRoom");
	for(var i=0; i<obj.options.length; i++) {
		if(obj.options[i].selected) {

			selectedRoomType = obj.options[i].value;
			if(obj.options[i].text != "<fmt:message key='mt.meMeeting.input' />"){
				meetingPlace = obj.options[i].text;
			}

			meetingroomId = obj.options[i].getAttribute("meetingroomId");
			startDatetime = obj.options[i].getAttribute("startDatetime");
			endDatetime = obj.options[i].getAttribute("endDatetime");
			isNeedApp = obj.options[i].getAttribute("isNeedApp");
			selectedRoomName = obj.options[i].getAttribute("selectedRoomName");
		    if(i>0){//xiangfan 第0个是新建会议室申请 不存在 meetingRoomApp
		      	document.getElementById("roomAppId").value = obj.options[i].getAttribute("roomAppId");
		        
		        //会议申请开始结束时间
	            document.getElementById("roomAppBeginDate").value = startDatetime;
	            document.getElementById("roomAppEndDate").value = endDatetime;
		    }else {
		        document.getElementById("roomAppId").value = "";
		    }
		    if(obj.options[i].getAttribute("isFromPortal")=="true") {
				document.getElementById("isFromPortal").value = "true";
			}
		    var roomType = obj.options[i].getAttribute("roomType");
			if(periodicityType!= "" && roomType && meetingroomId != ""){
				alert("周期性设置后，不能选择提前审批好的会议室!");
				obj.options[0].selected = true;
				return;
			}
			if(chooseMeetingRoom){
				try{
					if(i != 0 ){
						if(obj.options[i].value != 'mtPlace'){
							chooseMeetingRoom.onclick = function(){};
							chooseMeetingRoom.disabled="disabled";
							chooseMeetingRoom.style="width:auto;opacity:0.4;";
						}
					}else{
						chooseMeetingRoom.onclick = showMTRoom;
						chooseMeetingRoom.disabled="";
						chooseMeetingRoom.style="width:auto;";
					}
				}catch(e){
				}
			}
			break;
		}
	}
	if(selectedRoomType == "mtRoom"){
		if(!isOnLoad){
	  		document.getElementById("beginDate").value=startDatetime;
	  		document.getElementById("endDate").value=endDatetime;
	  		document.getElementById("meetingroomId").value=meetingroomId;
	  		document.getElementById("hasMeetingRoom").value=meetingroomId;
	  	    document.getElementById("needApp").value = isNeedApp;
	  	    document.getElementById("selectedRoomName").value = selectedRoomName;
	  	  	document.getElementById("meetingPlace").value = "";
		} else {
			if(document.getElementById("isFromPortal").value=='true') {
				document.getElementById("beginDate").value=startDatetime;
	    		document.getElementById("endDate").value=endDatetime;
	    		document.getElementById("hasMeetingRoom").value = meetingroomId;
				document.getElementById("meetingroomId").value = meetingroomId;
				document.getElementById("needApp").value = isNeedApp;
			}
		}
	}
	else if(selectedRoomType == "mtPlace") {
		if(!isOnLoad){
		  	meetingAddressChange(meetingPlace);
		}
	} else {
		document.getElementById("meetingroomId").value=obj.value;
		var beginTime = document.getElementById("beginTime"+obj.value).value;
		var endTime = document.getElementById("endTime"+obj.value).value;
		document.getElementById("beginDate").value=beginTime;
		document.getElementById("endDate").value=endTime;
	}
}


//ajax导入当前可以使用的会议室
function getCanUseMeetingrooms() {
	/*try{
		var beginDate = document.all.beginDate.value;
 	var endDate = document.all.endDate.value;
 	var selectMeetingrooms = document.getElementById('selectMeetingrooms');

		if(beginDate!=null && beginDate.length==16 && endDate!=null && endDate.length==16){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMeetingRoomManager", "getMeetingRoomForMeeting", false);
			requestCaller.addParameter(1, "Long", document.getElementById('userId').value);
			requestCaller.addParameter(2, "Long", stringTimeToLongTime(beginDate));
			requestCaller.addParameter(3, "Long", stringTimeToLongTime(endDate));
			var ds = requestCaller.serviceRequest();
			var fristOption = selectMeetingrooms.options[0];
		 	optionsClear(selectMeetingrooms);
			selectMeetingrooms.options.add(fristOption);
			document.getElementById('selectMeetingrooms').options[0].selected="selected";
			if("${meetingroomId}"!="noMeetingroom"){
				var meetingroomName = ("${meetingroomId}".split("|")[1]=="") ? ("${meetingroomName}"+" ※") : ("${meetingroomName}");
				selectMeetingrooms.options.add(new Option(meetingroomName,"${meetingroomId}"));
				document.getElementById('selectMeetingrooms').options[1].selected="selected";
			}
			if(ds != null ){
				for(var i = 0; i < ds.length; i++){
					var d = ds[i];
					if((d[0]+"|"+d[1])!="${meetingroomId}"){
						if(d[1]==""){ <%-- 不用申请的会议室 --%>
							var newOption = new Option(d[2]+" ※", d[0]+"|"+d[1]);
							newOption.title="<fmt:message key="mt.mtMeetingroom.stat" />";
						}else{ <%-- 需要申请的会议室 --%>
							try{
								var newOption = new Option(d[2]+" ("+d[3].substring(5)+"--"+d[4].substring(5)+")", d[0]+"|"+d[1]);
								newOption.title=d[3]+" -- "+d[4];
							}catch(ee){
								var newOption = new Option(d[2], d[0]+"|"+d[1]);
							}
						}
						selectMeetingrooms.options.add(newOption);
					}else{
						if(d[1]==""){ <%-- 不用申请的会议室 --%>
							document.getElementById('selectMeetingrooms').options[1].text=d[2]+" ※";
							document.getElementById('selectMeetingrooms').options[1].title="<fmt:message key="mt.mtMeetingroom.stat" />";
						}else{ 	<%-- 需要申请的会议室 --%>
							try{
								document.getElementById('selectMeetingrooms').options[1].text=d[2]+" ("+d[3].substring(5)+"--"+d[4].substring(5)+")";
								document.getElementById('selectMeetingrooms').options[1].title=d[3]+" -- "+d[4];
							}catch(ee){
								document.getElementById('selectMeetingrooms').options[1].text=d[2];
							}
						}
					}
				}
			}
		}
	}catch(ex1){
		alert("Exception : " + ex1);
	}*/

}

//判断是否有office插件
function hasOffice(bodyType) {
	if(bodyType=='' || bodyType=='10' || bodyType==10) {
		return true;
	}
	var pw = new Object();
	try{
		var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
		pw.installDoc= ocxObj.WebApplication(".doc");
		pw.installWps=ocxObj.WebApplication(".wps");
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}
	if(pw.installDoc && pw.installWps){
		return true;
	}else if(pw.installWps){
		return true;
	}else if(pw.installDoc){
		return true;
	} else {
		return false;
	}
}

//使用会议格式
function loadContentTemplate() {
	var bodyType = document.getElementById('bodyType').value;
	if(document.getElementsByName('contentTemplateId')[0].value=='') {
		if(confirm(v3x.getMessage("meetingLang.load_clearTemplate"))) {
			document.getElementById('formOper').value="loadTemplate";
			document.getElementById('dataForm').target="";
			document.getElementById('method').value="${param.method}";
			saveAttachment();
			if(hasOffice(bodyType)) {
				saveOffice();
			}
			isFormSumit = true;
			document.getElementById('dataForm').submit();
		} else {
			var selectFormatlength1 = document.getElementById('selectFormat').options.length;
			for(var i=selectFormatlength1-1;i>=0;i--) {
				if(selectFormat_oldValue==document.getElementById('selectFormat').options[i].value) {
					document.getElementById('selectFormat').options[i].selected="selected";
				}
			}
		}
	} else {
		if(confirm(v3x.getMessage("meetingLang.load_text_sure"))) {
			//document.getElementById('templateIframe').src='<c:url value="/bulTemplate.do?method=detail" />&preview=true&load=true&id='+$F('templateId');;
			document.getElementById('formOper').value="loadTemplate";
			document.getElementById('dataForm').target="";
			document.getElementById('method').value="${param.method}";
			saveAttachment();
			if(hasOffice(bodyType)) {
				saveOffice();
			}
			isFormSumit = true;
			document.getElementById('dataForm').submit();
		} else {
			var selectFormatlength2 = document.getElementById('selectFormat').options.length;
			for(var i=selectFormatlength2-1;i>=0;i--){
				if(selectFormat_oldValue==document.getElementById('selectFormat').options[i].value){
					document.getElementById('selectFormat').options[i].selected="selected";
				}
			}
		}
	}
}

function complete() {
	//选择会议类型的时候清空参会领导
	if(leaderSelectArrType == 1){
		elements_leaderSelect = "";
		elements_leaderSelectArr = "";
	}
	if (req.readyState == 4) {
		if (req.status == 200) {
			if($("#mtTitle").val() != $("#mtTitle").attr("deaultValue")) {
				$("#mtTitle2").val($("#mtTitle").val());
			}
			if($("#attender").val() != $("#attender").attr("deaultValue")) {
				$("#attender2").val($("#attender").val());
			}
			if($("#tel").val() != $("#tel").attr("deaultValue")) {
				$("#tel2").val($("#tel").val());
			}
			if($("#noticeView").val() != $("#noticeView").attr("deaultValue")) {
				$("#noticeView2").val($("#noticeView").val());
			}
			if($("#planView").val() != $("#planView").attr("deaultValue")) {
				$("#planView2").val($("#planView").val());
			}
			if($("#leaderNames").val() != $("#leaderNames").attr("deaultValue")) {
				$("#leaderNames2").val($("#leaderNames").val());
				$("#leader2").val($("#leader").val());
			}

			var mtTitle = $("#mtTitle2").val();
			var attender = $("#attender2").val();
			var tel = $("#tel2").val();
			var noticeView = $("#noticeView2").val();
			var planView = $("#planView2").val();
			var leaderNames = $("#leaderNames2").val();
			var leader = $("#leader2").val();
			var table = document.getElementById("contentTable");
			var rowlen = table.rows.length;
			//目前table中只有7行
			var initlen = 7;
			//从第四行后开始增加
			var count = 4;
			<c:if test="${hasVideoConferencePlugin || hasMeetingType}">
				initlen = 8;
				count = 5;
			</c:if>
			if(rowlen > initlen){
				var start = 4;
				<c:if test="${hasVideoConferencePlugin || hasMeetingType}">
					start = 5;
				</c:if>
	            for(var i=0;i<rowlen-initlen ;i++){
	            	table.deleteRow(start);
	            }
			}

			if("empty" != req.responseText ) {
				if(req.responseText.indexOf("logout")!=-1){
					alert(v3x.getMessage("meetingLang.loginUserState_unknown"));
					self.close();
					getA8Top().location.href = '/seeyon/main.do?method=logout';
					return;
				}
				var json = eval(req.responseText);
				//var s = '<tr class="bg-summary" >';
				var tr = table.insertRow(count);
				tr.className = "bg-summary _moreField";

				var num = 0;
				var td0 = tr.insertCell(num++);
				var len = json.length;
				for(var i=0;i<json.length;i++) {
					var cl = json[i].jsFunction != '' ? 'onclick="'+json[i].jsFunction+'"' : '';
					var handCursor = json[i].cursor == 'true'? 'cursor-hand' : '';
					var v = json[i].inputValue == "" ? json[i].inputContent : json[i].inputValue;
					var isreadonly = json[i].readonly == "true" ? 'readonly="true" ' : ' ';

					var td1 = tr.insertCell(num++);
					td1.className = "bg-gray";
					td1.style.cssText = "width:6%;padding:4px;";
					td1.innerHTML = json[i].name+'<fmt:message key="label.colon" />';

					var td2 = tr.insertCell(num++);
					td2.colSpan = 3;
					if(num == 3){
						td2.style.cssText = "padding-right:24px;";
					}
					if(json[i].personSelect == "true") {

						var leaderId = '${bean.leader}';
						var leaderName = '${bean.leaderName}';
						if(leaderName=="")leaderName='${_myLabelDef}';

						var tempDefalutValue = '${_myLabelDef}';
						if("" == leaderName){
							leaderName = v;
						}

						if("" == tempDefalutValue){
							tempDefalutValue = json[i].inputContent;
						}

						td2.innerHTML = '<input type="hidden" id="leader" name="leader" value="'+leaderId+'"/>'+
						'<input type="text"  class="input-100per cursor-hand" id="leaderNames" name="leaderNames" '+ isreadonly +
						'value="'+leaderName+'" '+
						'deaultValue="'+tempDefalutValue+'"'+
						'onfocus="checkDefSubject(this, true)"'+
						'onblur="checkDefSubject(this, false)"'+
						'inputName="${_myLabel}" '+
						/* 'validate="notNull"'+ */
						'onclick="selectMtPeople(\'leaderSelect\',\'leader\');"'+
						'/>';

					} else {
						var length= json[i].inputLength;
						var subV = v;
						/* if(v != null && v.length > 30 && json[i].inputName != "attender") {
							subV = v.substring(0, 30) + "...";
						} */
						var str ='<div class="common_txtbox_wrap"><input type="text" '+cl+' style="padding-right:10px;" class="w100b cursor-hand '+handCursor+'" name="'+json[i].inputName + '" id="'+json[i].inputName + '"'+
						' maxSize="'+length+'" deaultValue="'+json[i].inputContent+'" validate="maxLength" '+
						' value="'+subV+'" inputName="'+json[i].name + '" '+ isreadonly +
						' onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)"/></div>';
						if(json[i].hiddenInputName != ""){
							str += ' <input type="hidden" value="'+v+'" name="'+json[i].hiddenInputName+'" id="'+json[i].hiddenInputName+'" />';
						}
						td2.innerHTML = str;
					}
					if((i+1)%2 == 0){
						var td_last = tr.insertCell(num++);
						num = 0;
						tr = table.insertRow(++count);
						tr.className = "bg-summary _moreField";
						var td0 = tr.insertCell(num++);
					}
				}
				if((len + 1)%2 == 0){
					var td_last = tr.insertCell(num++);
					td_last = tr.insertCell(num++);
					td_last.colspan = 3;
					td_last = tr.insertCell(num++);
					td_last = tr.insertCell(num++);
					td_last.colspan = 3;
					td_last = tr.insertCell(num++);
				}
				if($("#mtTitle").val()==$("#mtTitle").attr("deaultValue") && mtTitle != "") {
					$("#mtTitle").val(mtTitle);
				}
				if($("#attender").val()==$("#attender").attr("deaultValue") && attender != "") {
					$("#attender").val(attender);
				}
				if($("#tel").val()==$("#tel").attr("deaultValue") && tel != "") {
					$("#tel").val(tel);
				}
				if($("#noticeView").val()==$("#noticeView").attr("deaultValue") && noticeView != "") {
					$("#noticeView").val(noticeView);
				}
				if($("#planView").val()==$("#planView").attr("deaultValue") && planView != "") {
					$("#planView").val(planView);
				}
				if($("#leaderNames").val()==$("#leaderNames").attr("deaultValue") && leaderNames != "") {
					$("#leaderNames").val();
					$("#leader").val();
				}
			}

			//切换会议格式后，保留之前输入的数据
			if(meetingTypeFieldJSONStr){
				for(var typeField in meetingTypeFieldJSONStr){
					var tempObj = document.getElementById(typeField);
					if(tempObj){
						var inputValue = meetingTypeFieldJSONStr[typeField]['inputValue'];
						if(inputValue){
							tempObj.value = inputValue;
						}
						var hidenName = meetingTypeFieldJSONStr[typeField]['hiddenInputName'];
						if(hidenName){
							var temHidenObj = document.getElementById(hidenName);
							if(temHidenObj){
								temHidenObj.value = meetingTypeFieldJSONStr[typeField]['hiddenInputValue'];
							}
						}
					}
			   }
			}
			resetContextHeight();//重新计算高度
		}
	}
}

function chanageBodyTypeExt(type) {
	if(chanageBodyType(type))
	  document.getElementById('dataFormat').value=type;
}

/******************************** 初始化数据 end **************************************/


/******************************** 弹出窗窗口 start **************************************/
//打开调用模板页面
function showTemplate() {
	getA8Top().win123 = getA8Top().v3x.openDialog({
		title:"<fmt:message key='mt.templet.load' />",
		transParams:{'parentWin':window},
		url: "${meetingURL}?method=showTemplate",
		width:520,
		height:350,
		resizable : "no"
	});
}

//弹出会议地址录入界面。
function meetingAddressChange(meetingPlace) {
	getA8Top().win123 = getA8Top().v3x.openDialog({
		title:"<fmt:message key='mt.mtMeeting.address'/>",
		transParams:{'parentWin':window},
		url: "${meetingURL}?method=meetingAddressInputEntry&meetingPlace="+encodeURI(meetingPlace),
		width:350,
		height:230,
		resizable : "no",
		closeParam:{
			'show':true,
			handler:function(){
				document.getElementById("meetingPlace").value="";
				commonDialogClose('win123');
		   }}
	});
	return;
}
function meetingAddressChangeCallback(meetingAddress){
	if(meetingAddress!=undefined && meetingAddress!="undefined" && meetingAddress != ''){
		var sel = document.getElementById("selectRoomType");
		document.getElementById("meetingroomId").value="";
		document.getElementById("meetingPlace").value=meetingAddress;
		sel.options[1].text = meetingAddress;
	}
}

// 显示会议室使用情况
function showUsedMeetingrooms() {
	var w = 750;
	var h1 = 287;//半个窗口高
	var h2 = 600;//整个窗口高
    var l = (screen.width - w)/2;
    var t = (screen.height - h2)/2;
	window.showModalDialog("${meetingRoomURL}?method=view",self,"dialogHeight: "+h1+"px; dialogWidth:"+w+"px;dialogTop:"+t+";dialogLeft: "+l+";center: yes;help:no; status=no");
}

//添加,选择会议室弹出图形化选择界面
function showMTRoom() {
	isFormSumit = true;
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMeetingRoomManager", "checkHasMeetingRoom", false);
	var ds = requestCaller.serviceRequest();
	if(ds == 'false') {
		alert("<fmt:message key='mr.alert.addroom' bundle='${v3xMeetingRoomI18N }' />!");
		return;
	}
	//用来记录是添加还是修改的标记(如果是添加则不能拖动任何的时间段,如果是修改,再去判断拖动的是否是当前的会议,如果是则可拖动,否则不难拖动)
	var action="${action}";
	//修改的时候取得会议的ID用来判断只许修改当前ID的会议
	var meetingId="${meetingId}";
	var w = 1052;
	var h1 = 500;//半个窗口高
	var h2 = 700;//整个窗口高
  	var l = (screen.width - w)/2;
  	var t = (screen.height - h2)/2;
	var hasMeetingRoom = document.getElementById("hasMeetingRoom").value;
	if(hasMeetingRoom == "noMeetingroom") hasMeetingRoom = "";
	var roomAppBeginDate = document.getElementById("roomAppBeginDate").value;
	var roomAppEndDate = document.getElementById("roomAppEndDate").value;
	var oldRoomAppId = document.getElementById("oldRoomAppId").value;
	if(oldRoomAppId == "") {
		oldRoomAppId = -1;
	}

	var returnMr;
	if("" == hasMeetingRoom) {
		returnMr = "";
	} else {
		returnMr=hasMeetingRoom+","+roomAppBeginDate+","+roomAppEndDate+","+oldRoomAppId;
	}

  	var url = "${meetingRoomURL}?method=mtroom&returnMr="+returnMr+"&action="+action+"&meetingId="+meetingId+"&date="+new Date();
  	//,self,"dialogHeight: "+h1+"px; dialogWidth:"+w+"px;dialogTop:"+t+";dialogLeft: "+l+";center: yes;help:no; status=no"
  	getA8Top().win123 = getA8Top().v3x.openDialog({
		title:"<fmt:message key='mr.label.mrApplication' bundle='${chrometitleLabel}'/>",
		transParams:{'parentWin':window},
		url: url,
		width: 1052,
		height: 500,
		resizable: 'no'
	});
}
function showMTRoomCallback(retObj){
	if(retObj!=null&&""!=retObj) {
  		var strs=retObj.split(",");
	    if(strs.length>0) {

	    	var meetingroomId = strs[0];
	    	var selectedRoomName = strs[1];
	    	var needApp = strs[2];
	    	var oldRoomAppId = strs[5];
	    	var roomAppBeginDate = strs[3];
			var roomAppEndDate = strs[4];

	    	document.getElementById("meetingroomId").value = meetingroomId;
		    document.getElementById("hasMeetingRoom").value = meetingroomId;
		    //会议室是否需要申请
		    document.getElementById("needApp").value = needApp;
		    //会议开始结束时间
			document.getElementById("beginDate").value =  roomAppBeginDate;
			document.getElementById("endDate").value = roomAppEndDate;
			//会议申请开始结束时间
			document.getElementById("roomAppBeginDate").value = roomAppBeginDate;
			document.getElementById("roomAppEndDate").value = roomAppEndDate;
			//上一次选择
			document.getElementById("oldRoomAppId").value = oldRoomAppId;
			//已选择的会议室的名称
			document.getElementById("selectedRoomName").value = selectedRoomName;

			if(document.getElementById("selectRoomType")) {
				if(document.getElementById("periodicityType").value!=""){
					document.getElementById("selectRoomType").options[0].text = strs[1]+"("+roomAppBeginDate.substr(11)+"--"+roomAppEndDate.substr(11)+")";
				}else{
					document.getElementById("selectRoomType").options[0].text = strs[1]+"("+roomAppBeginDate+"--"+roomAppEndDate+")";
				}

			  	document.getElementById("selectRoomType").options[0].setAttribute("meetingroomId", meetingroomId);
			  	document.getElementById("selectRoomType").options[0].setAttribute("isNeedApp", needApp);
			 	document.getElementById("selectRoomType").options[0].setAttribute("startDatetime", roomAppBeginDate);
			  	document.getElementById("selectRoomType").options[0].setAttribute("endDatetime", roomAppEndDate);
			  	document.getElementById("selectRoomType").options[0].setAttribute("selectedRoomName", selectedRoomName);
			  	document.getElementById("selectRoomType").options[0].selected = true;
			}
      	}
 	}
}
/** 会议周期性设置 **/
function showRepeatCycle(periodicityInfoId) {
	var url = '${meetingURL}?method=showRepeatCycle&periodicityInfoId='+periodicityInfoId;
	if(getA8Top().isCtpTop){
		getA8Top().win123 = getA8Top().$.dialog({
			title:'<fmt:message key='mt.repeat.cycle.setting'/>',
			transParams:{'parentWin':window},
			url: url,
			width: 392,
			height: 204,
			isDrag:false
		});
	} else {
		getA8Top().win123 = getA8Top().v3x.openDialog({
			title:'<fmt:message key='mt.repeat.cycle.setting'/>',
			transParams:{'parentWin':window},
			url: url,
			width: 392,
			height: 204,
			isDrag:false
		});
	}
}


/** 选择与会资源 **/
function selectResources() {
	var url = '${meetingURL}?method=selectResources&type='+document.getElementById('resourcesId').value;
	window.win123 = window.v3x.openDialog({
		title:'<fmt:message key="mt.resource"/>',
		transParams:{'parentWin':window, "popWinName":"win123"},
		url: url,
		width: 400,
		height: 320,
		resizable: 'no'
	});
}
function selectResourcesCallback(elements){
	if(elements!=null) {
		document.getElementById('resourcesId').value=getIdsString(elements,false);
		document.getElementById('resourcesName').value=getNamesString(elements,true);
	}
}

//打开注意事项
function openNotice() {
	var msg = '<fmt:message key="label.please.input" />';
	var msg_sub = '<fmt:message key="mt.mtMeeting.note" />';
	msg = msg.replace("{0}",msg_sub);
	var value = document.getElementById("notice").value;
	if(msg == value) {
		value = "";
	}
	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openNotice&content="+encodeURIComponent(value)+"&ndate="+new Date();
	var fmt_message = "";
	if(${param.readonly eq 'readonly'}){
		fmt_message = "<fmt:message key='admin.label.zysx1'/>";
	}else{
		fmt_message = "<fmt:message key='admin.label.zysx1'/>";
	}
	getA8Top().win123 = getA8Top().v3x.openDialog({
	  		title:fmt_message,
	  		transParams:{'parentWin':window},
		    url:url,
		    dialogType:"modal",
		    width:winWidth,
		    height:winHeight
	  	});
}

//打开会议计划
function openPlan() {
	var msg = '<fmt:message key="label.please.input" />';
	var msg_sub = '<fmt:message key="meeting.mtMeeting.plan" />';
	msg = msg.replace("{0}",msg_sub);
	var value = document.getElementById("plan").value;
	if(msg == value) {
		value = "";
	}
	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openPlan&content="+encodeURIComponent(value)+"&ndate="+new Date();
	var fmt_message = "";
	if(${param.readonly eq 'readonly'}){
		fmt_message = "<fmt:message key='meeting.admin.label.yc1'/>";
	}else{
		fmt_message = "<fmt:message key='meeting.admin.label.yc1'/>";
	}
	getA8Top().win123 = getA8Top().v3x.openDialog({
  		title:fmt_message,
  		transParams:{'parentWin':window},
	    url:url,
	    dialogType:"modal",
	    width:winWidth,
	    height:winHeight
  	});
}

/******************************** 弹出窗窗口 end **************************************/


/******************************** 数据校验 start **************************************/
function myCheckForm(myForm,type) {
	if(!checkForm(myForm)){
		return false;
	}
	if(!validFieldData()) {
		return false;
	}
	var result = document.getElementById('beginDate').value >= document.getElementById('endDate').value;
	if(result) {
		alert(v3x.getMessage("meetingLang.date_validate"));
		return false;
	}
	//var currentDate = new Date();
	//currentDate取服务器的时间
	var newDate = "${newDate}";
	var currentDate = new Date(newDate);
	currentDate = currentDate.format("yyyy-MM-dd HH:mm");
	currentDate = Date.parse(currentDate.replace(/\-/g,"/"));
	var beginDate = document.getElementById('beginDate').value;
	beginDate = Date.parse(beginDate.replace(/\-/g,"/"));

	var endDate = document.getElementById('endDate').value;
	endDate = Date.parse(endDate.replace(/\-/g,"/"));

	/******************************** 视频会议 start **********************************/
	if(type == "toSend" || type == "toSave") {
		<c:if test="${hasVideoConferencePlugin}">
		    if(document.getElementById("meetingNature").value == '2'){
		    	if(currentDate>beginDate){
			       alert(v3x.getMessage("meetingLang.meeting_not_before_now"));
			       return false;
		    	}
		    	if(currentDate>endDate){
			       alert(v3x.getMessage("meetingLang.meeting_not_before_now"));
			       return false;
		    	}
		    }
	    </c:if>
	}
	/******************************** 视频会议 end **********************************/

	//toSave:保存待发 toSend:发送
	if(currentDate>beginDate && type == "toSend") {//保存和发送才需要提示 OA-18227
		var flag = confirm(v3x.getMessage("meetingLang.begin_date_validate"));
		if(flag) {
			//与会资源的占用判断
		  	var beginDate = document.getElementById('beginDate').value;
		  	var endDate = document.getElementById('endDate').value;
			if(document.getElementById("selectRoomType").value=="mtPlace" && document.getElementById("meetingPlace").value=='<${_inputplace }>') {
				document.getElementById("meetingPlace").value = "";
			}
			if(document.getElementById("selectRoomType").value=="mtPlace" && document.getElementById("meetingPlace").value=='') {
				document.getElementById("meetingPlace").value = "";
			}
		}
		return flag;
	}
	return true;
}

function validateMtRoom(obj) {
	var beginDate = document.all.beginDate.value;
   	var endDate = document.all.endDate.value;
   	var options = obj.options;
   	for(var i=1 ; i<obj.options.length;i++) {
   		if(options[i].selected) {
   			try {
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxResourceManager", "isResourcesImpropriated", false);
				requestCaller.addParameter(1, "Long", options[i].value);
				requestCaller.addParameter(2, "date", beginDate+":00");
				requestCaller.addParameter(3, "date", endDate+":00");
				var ds = requestCaller.serviceRequest();
				if(ds == 'true') {
					alert(v3x.getMessage("meetingLang.resource_used"));
				}
			} catch (ex1) {
				alert("Exception : " + ex1);
			}
   		}
   	}
}

/**
 * 检查input框是否为默认值
 */
function _isDefualtValue(e){
	if(e != null) {
		//判断是否是默认值
		var defalutValue = e.getAttribute("deaultValue");
		if(defalutValue != null && defalutValue != "" && defalutValue != "undefined" && e.value == defalutValue){
			return true;
		}
		return false;
	}
    return false;
}

function validFieldData() {
	//a6s 版本跳过判断
	if(projectId && projectId == "7"){
		return true;
	}
	var titleObj = document.getElementById("title");
	var meetingPlaceObj = document.getElementById("meetingPlace");
	var selectRoomTypeObj = document.getElementById("selectRoomType");
	var RoomselectedIndex = selectRoomTypeObj.selectedIndex;
	var attenderObj = document.getElementById("attender");
	var telObj = document.getElementById("tel");

	if(_isDefualtValue(attenderObj)){
		attenderObj.value = attenderObj.defaultValue;
	}

	if(_isDefualtValue(telObj)){
		telObj.value = telObj.defaultValue;
    }

	if(titleObj && titleObj.value.length > 85) {
		alert(v3x.getMessage("meetingLang.name_validate"));
		return false;
	}else if(meetingPlaceObj && selectRoomTypeObj.options[RoomselectedIndex].value =="mtPlace" && selectRoomTypeObj.options[RoomselectedIndex].text.length==0){
		alert("会议地址不能为空。");
		return false;
	}else if(meetingPlaceObj && selectRoomTypeObj.options[RoomselectedIndex].value =="mtPlace" && meetingPlaceObj.value.length > 60) {
		alert("会议室名称不能超过60字.");
		return false;
	}else if(titleObj && validateValue(titleObj.value)){
		alert("会议名称不能包含特殊字符（# ￥ % & ~ < > / | \ \" '），请重新录入！");
		return false;
	}
	if(!_isDefualtValue(attenderObj)){
		if(attenderObj && validateValue(attenderObj.value)){
		alert("参会嘉宾不能包含特殊字符（# ￥ % & ~ < > / | \ \" '），请重新录入！");
		return false;
		}
	}
	if(!_isDefualtValue(telObj)){
		if(telObj && validateValue(telObj.value)){
		alert("联系电话不能包含特殊字符（# ￥ % & ~ < > / | \ \" '），请重新录入！");
		return false;
		}
	}
	//验证参会领导，最多35人
	var leaderIdEle = document.getElementById("leader");
	if(leaderIdEle){
	    var leaderIdVal = leaderIdEle.value;
	    var idArray = leaderIdVal.split(",");
	    if(idArray.length > 35){//参会领导最大数量为35,请重新选择
	        alert('<fmt:message key="meeting.alert.create.leaderMaxSize"/>');
	        return false;
	    }
	}
	return true;
}
function meetingColliedValidateCallback(returnValue){
	var returnValue_V;
	if(returnValue){
		returnValue_V = returnValue[0];
  	}else{
  		returnValue_V = "false";
  	}
  	if(returnValue_V == "false") {
  		return;
  	}
  	document.getElementById('formOper').value='send';
	document.getElementById('listType').value=listType;
	saveAttachment();
	cloneAllAttachments();
	isHasAtts();
	if(!saveOffice()) {
		return ;
	}
	setMeetingDateNotDisabled();
	if("${mtAppId}" != null && "${mtAppId}" != "") {//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
		try {
			var needClones = document.getElementsByName("attachment_needClone");
			for(var i=0; i<needClones.length; i++) {
				needClones[i].value = "true";
			}
		} catch (e) {}
	}
	is_A6sProduct();
	send(params);
}
var conferees_str = "";
//参会人会议时间冲突校验
function meetingColliedValidate(recorder,emcee,conferees,meetingId) {
  	var beginDate = document.getElementById("beginDate").value;
  	var endDate = document.getElementById("endDate").value;

	
  	var periodicityType = document.getElementById("periodicityType").value;
  	var scope = document.getElementById("scope").value;
  	var periodicityStartDate = document.getElementById("periodicityStartDate").value;
  	var periodicityEndDate = document.getElementById("periodicityEndDate").value;
  	var periodicityInfoId = document.getElementById("periodicityInfoId").value;

  	var _url = "${meetingURL}?method=listMeetingCollideIframe&mtId="+meetingId+"&emcee="+emcee+"&recorder="+recorder+"&beginDate="+beginDate+
  				"&endDate="+endDate+"&periodicityType="+periodicityType+"&scope="+scope+"&periodicityStartDate="+periodicityStartDate+
  				"&periodicityEndDate="+periodicityEndDate+"&periodicityInfoId="+periodicityInfoId;
  	conferees_str = conferees;
	if(formOper == "new") {
		try {
			openDialog1(_url, '<fmt:message key="meeting.collide.remind"/>');
		} catch(e) {
			openDialog2(_url, '<fmt:message key="meeting.collide.remind"/>');	
		}
	}else{
		openDialog2(_url, '<fmt:message key="meeting.collide.remind"/>');
	}
  	return true;
}

function openDialog1(_url, _title) {
	getA8Top().win123 = getA8Top().$.dialog({
		title:_title,
  		transParams:{'parentWin':window},
	    url:_url,
	    dialogType:"modal",
	    width:600,
	    height:560
  	});
}

function openDialog2(_url, _title) {
	getA8Top().win123 = getA8Top().v3x.openDialog({
		title:'<fmt:message key="meeting.collide.remind"/>',
  		transParams:{'parentWin':window},
	    url:_url,
	    dialogType:"modal",
	    width:600,
	    height:560
  	});
}

function hasMeetingAtTimeRange(recorder,emcee,conferees,meetingId) {
  	var beginDate = document.getElementById("beginDate").value;
  	var endDate = document.getElementById("endDate").value;
  	if(beginDate == "" || beginDate == "") {
    	return false;
  	}

  	var periodicityType = document.getElementById("periodicityType").value;
  	var scope = document.getElementById("scope").value;
  	var periodicityStartDate = document.getElementById("periodicityStartDate").value;
  	var periodicityEndDate = document.getElementById("periodicityEndDate").value;
  	var periodicityInfoId = document.getElementById("periodicityInfoId").value;

  	var requestCaller = new XMLHttpRequestCaller(this,"ajaxMtMeetingManager","hasMeetingAtTimeRange",false);
  	requestCaller.addParameter(1,"String",beginDate);
  	requestCaller.addParameter(2,"String",endDate);
  	requestCaller.addParameter(3,"String",recorder);
  	requestCaller.addParameter(4,"String",emcee);
  	requestCaller.addParameter(5,"String",conferees);
  	requestCaller.addParameter(6,"String",meetingId);
	//周期性会议
	if(scope!=""){
		return false;
		/*
		requestCaller.addParameter(7,"String",periodicityType);
	  	requestCaller.addParameter(8,"String",scope);
	  	requestCaller.addParameter(9,"String",periodicityStartDate);
	  	requestCaller.addParameter(10,"String",periodicityEndDate);
	  	requestCaller.addParameter(11,"String",periodicityInfoId);
	  	*/
	}

  	var ds = requestCaller.serviceRequest();
  	return ds;
}

//判断会议室是否占用
function isMeetingroomUsed() {
  	var selectRoomTypeObj = document.getElementById("selectRoomType");
  	var selectType = "";
	//如果选择了填写会议地点，则不需要再判断会议室是否可用
	if(selectRoomTypeObj) {
		if(selectRoomTypeObj.value=="mtPlace") {
			return true;
		}
	}
	//会议室的占用判断
	//取消了会议室，那么肯定通过会议室占用的判断，注意将来要要删除会议室关联
	if(document.getElementById('meetingroomId').value=="" || document.getElementById('meetingroomId').value=="noMeetingroom") {
	  	return true;
	}
	//选中的是否是后台"会议室管理"已申请的会议室
	var appedFlag = false;
	if(selectRoomTypeObj) {
		for(var i=0;i<selectRoomTypeObj.options.length;i++) {
      		if(selectRoomTypeObj.options[i].selected){
           		selectType = selectRoomTypeObj.options[i].getAttribute("rType");
           		if(selectType =="apped") appedFlag = true; //xiangfan 选择了 已经审核通过的会议室 就不需要在验证了！
        	}
     	}
  	}
	if(appedFlag) {
		return true;
	} else { // 没有取消会议室，那么要验证这个会议室是否被占用
		try {
			var beginDate = document.getElementById('beginDate').value;
	    	var endDate = document.getElementById('endDate').value;

	    	if(document.getElementById('meetingroomId').value == "noMeetingroom" || document.getElementById('meetingroomId').value == "") {
				alert("请选择会议室!");
				return;
			}

	    	if( beginDate!=null && beginDate.length==16 && endDate!=null && endDate.length==16) { // 如果会议时间选择正确
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxMeetingRoomManager", "checkMeetingRoomForMeeting", false);
				var i = 1;
				// Long v3xOrgMember, Long meetingRoomId, Long meetingRoomAppId, Long startDatetime, Long endDatetime
				requestCaller.addParameter(i++, "Long", document.getElementById('userId').value);
				requestCaller.addParameter(i++, "Long", document.getElementById('meetingroomId').value);
				requestCaller.addParameter(i++, "Long", "${bean.id}");
				requestCaller.addParameter(i++, "Long", stringTimeToLongTime(beginDate));
				requestCaller.addParameter(i++, "Long", stringTimeToLongTime(endDate));
				requestCaller.addParameter(i++, "String", document.getElementById('periodicityInfoId').value);
				requestCaller.addParameter(i++, "String", document.getElementById('periodicityType').value);
				requestCaller.addParameter(i++, "String", document.getElementById('scope').value);
				var periodicityStartDate = document.getElementById('periodicityStartDate').value;
				var periodicityEndDate = document.getElementById('periodicityEndDate').value;
				if(periodicityStartDate != "" && periodicityStartDate.length>16) {
					periodicityStartDate = periodicityStartDate.substring(0,periodicityStartDate.length-2);
				}
				if(periodicityEndDate != "" && periodicityEndDate.length>16) {
					periodicityEndDate = periodicityEndDate.substring(0,periodicityEndDate.length-2);
				}
				requestCaller.addParameter(i++, "String", periodicityStartDate);
				requestCaller.addParameter(i++, "String", periodicityEndDate);				
				var ds = requestCaller.serviceRequest();
				if(ds=="true") {
					return true;
				} else if(ds=="timeerror") {
					alert(v3x.getMessage("meetingLang.meetingroom_timeerror"));
					return false;
				} else if(ds=="timefalse") {
					alert(v3x.getMessage("meetingLang.meetingroom_used"));
						return false;
				} else if(ds=="appfalse") {
					alert(v3x.getMessage("meetingLang.meetingroom_appfalse"));
					return false;
				} else if(ds=="delete") {
					alert(v3x.getMessage("meetingLang.meetingroom_delete"));
					return false;
				} else if(ds=="false") {
					//您选择的会议室在选择的会议时间段内已被占用，您确定要继续发起这个会议吗？
					alert(v3x.getMessage("meetingLang.meetingroom_used"));
						return false;
				} else if(ds=="${meetingId}") {
					return true;
				} else {
					alert(v3x.getMessage("meetingLang.meetingroom_used"));
						return false;
					}
			} else { <%-- 如果会议时间选择不正确 --%>
				alert(v3x.getMessage("meetingLang.meetingroom_time_error"));
				return false;
			}
		} catch(ex1) {
			alert("Exception : " + ex1);
			return false;
		}
	}
	return true;
}

function checkSelectConferees(element) {
	if(!isDefaultValue(element)) {
		selectMtPeople('confereesSelect','conferees');
		return false;
	}
	return true;
}

//校验会议名称特殊字符
function validateValue(v){
	var patrn = /^[^#￥%&~<>/|\"']*$/;
	if(!patrn.test(v)){
		return true;
	}
	return false;
}

/******************************** 数据校验 end **************************************/


/******************************** 会议保存 start **************************************/

function cleanMeetingParams(){
	if(document.getElementById("selectRoomType").options){
		document.getElementById("portalRoomAppId").value = "";
		document.getElementById("meetingPlace").value = "";
		document.getElementById("isFromPortal").value = "";
		document.getElementById("hasMeetingRoom").value = "";
		document.getElementById("oldRoomAppId").value = "";
		document.getElementById("roomAppId").value = "";
		document.getElementById("selectedRoomName").value = "";
		document.getElementById("meetingroomId").value = "";
		document.getElementById("meetingroomName").value = "";
		document.getElementById("needApp").value = "";
		document.getElementById("roomAppBeginDate").value = "";
		document.getElementById("roomAppEndDate").value = "";
	}
}

// 调用send方法
var params = "";
var listType = "";
function toSend(meetingId, listType) {
	listType = listType;
	var periodicityType = document.getElementById("periodicityType").value;
	var selectRoomType = document.getElementById("selectRoomType");
	if(periodicityType!= "" && projectId != "7"){
		for(var i=0; i<selectRoomType.options.length; i++) {
			var obj =selectRoomType.options[i];
			if(obj.selected) {
				var meetingroomId = obj.getAttribute("meetingroomId");
				var roomType = obj.getAttribute("roomType");
				if(periodicityType!= "" && roomType && meetingroomId != ""){
					alert("周期性设置后，不能选择提前审批好的会议室!");
					selectRoomType.options[0].selected = true;

					var chooseMeetingRoom = document.getElementById("chooseMeetingRoom");
					if(chooseMeetingRoom){
						chooseMeetingRoom.disabled = "";
						chooseMeetingRoom.onclick = showMTRoom;
					}
					cleanMeetingParams();//清空之前选择的会议室的参数
					return false;
				}
			}
		}
	}

	isFormSumit = true;

	var meetingId = "";
    if(document.getElementById("mtId")) {
      meetingId = document.getElementById("mtId").value;//如果从编辑过来的 会获取被编辑会议的ID，冲突的会议需要过滤掉这个会议 OA-5489
    }
    var recorder = document.getElementById("recorderId").value;
    var emcee = document.getElementById("emceeId").value;
    var conferees = document.getElementById("conferees").value;
    var impart = document.getElementById("impart").value;
	//当从已通过的会议申请 转到 发布会议通知页面的 就不进行 会议通知修改的判断
	if('${meetAppToMeet}'!= 'true' && meetingId!='' && !validateCanEdit(meetingId,"ajaxMtMeetingManager")) {
		alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
		self.history.back();
		return false;
	}
	if(myCheckForm(document.getElementById('dataForm'), "toSend") && isMeetingroomUsed()) {

		var mtId = document.getElementById('mtId').value;
		var meetingroomId = document.getElementById('meetingroomId').value;
		if(mtId != "" && meetingroomId != ""){

			var ff = "true";
			var periodicityInfoId = document.getElementById("periodicityInfoId").value;
			if(periodicityInfoId != ""){
				var startDate = "${pinfo.startDate }";
				var endDate = "${pinfo.endDate }";
				if(startDate.length > 10){
					startDate = startDate.substr(0,10);
				}
				if(endDate.length > 10){
					endDate = endDate.substr(0,10);
				}

				var pstartDate = document.getElementById("periodicityStartDate").value;
				var pendDate = document.getElementById("periodicityEndDate").value;
				if(pstartDate.length > 10){
					pstartDate = pstartDate.substr(0,10);
				}
				if(pendDate.length > 10){
					pendDate = pendDate.substr(0,10);
				}

				//判断周期性设置是否改变过
				if("${pinfo.periodicityType }" != document.getElementById("periodicityType").value ||
						   "${pinfo.scope }" != document.getElementById("scope").value ||
						   startDate != pstartDate ||
						   endDate != pendDate){
					ff = "false";
					params = "&periodicityInfoChanged=true";
					if("${bean.room}" != ""){
						if(!confirm("您对周期性设置进行了改变，原有会议室会被撤销，是否提交?")){
							return;
						}
					}
				}
			}
			if(ff == "true"){
				//检测会议室审核通过后，再修改会议时，是否修改了时间
			   	var requestCaller = new XMLHttpRequestCaller(this, "meetingRoomManager", "permedRoomMeetingIsUpdateTime", false);
				requestCaller.addParameter(1, "String", document.getElementById('beginDate').value);
				requestCaller.addParameter(2, "String", document.getElementById('endDate').value);
				requestCaller.addParameter(3, "String", mtId);
				requestCaller.addParameter(4, "String", meetingroomId);
				var ds = requestCaller.serviceRequest();
				if(ds == "true"){
					if(!confirm("您已申请了会议室，会议时间与会议室使用时间不符，是否提交?")){
						return;
					}
				}
				if(ds == "changeRoom"){
					if(!confirm("您已重新申请了会议室，原有会议室会被撤销，是否提交?")){
						return;
					}
				}
			}

		}



	   /******************************** 视频会议 start **********************************/
        if(document.getElementById('videoConfStatus').value.length!=0  &&  document.getElementById('meetingNature').value !="1") {
            var flag = validatePassword();
            if(!flag) {
                return;
            }
        }
       /******************************** 视频会议 end **********************************/
	    if(hasMeetingAtTimeRange(recorder,emcee,conferees,meetingId) == "true") {
	      	if(meetingColliedValidate(recorder,emcee,conferees,meetingId,formOper)) {
	      		return;
	      	}
	    }else{
			document.getElementById('formOper').value='send';
			document.getElementById('listType').value=listType;
			saveAttachment();
			cloneAllAttachments();
			isHasAtts();
			if(!saveOffice()) {
				return ;
			}
			setMeetingDateNotDisabled();
			if("${mtAppId}" != null && "${mtAppId}" != "") {//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
				try {
					var needClones = document.getElementsByName("attachment_needClone");
					for(var i=0; i<needClones.length; i++) {
						needClones[i].value = "true";
					}
				} catch (e) {}
			}
			is_A6sProduct();
			send(params);
	    }
	}
	
	try{
		WeixinJSBridge.invoke('closeWindow',{},function(res){
	    });
	}catch(e){
	}
}

//如果是a6s版本，直接读取input的会议地点
function is_A6sProduct(){
	if(projectId && projectId == "7"){
		var a6s_handwrite_address = document.getElementById("a6s_hand_write").value
		if(a6s_handwrite_address.indexOf("<fmt:message key='mt.meMeeting.input' />") > 0){
			a6s_handwrite_address = "";
		}
		document.getElementById("meetingroomId").value="";
		document.getElementById("meetingPlace").value=a6s_handwrite_address;
	}
}

/** 保存待发 **/
function toSave(listType) {
	if(myCheckForm(document.getElementById('dataForm'), "toSave")) {
		/******************************** 视频会议 start **********************************/
		if(document.getElementById('videoConfStatus').value.length!=0  &&  document.getElementById('meetingNature').value != "1") {
           	var flag = validatePassword();
            if(!flag) {
               return;
            }
        }
		/******************************** 视频会议 end **********************************/
		saveAttachment();
		cloneAllAttachments();
		if("${mtAppId}" != null && "${mtAppId}" != "") {//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
			try {
				var needClones = document.getElementsByName("attachment_needClone");
				for(i=0; i<needClones.length; i++) {
					needClones[i].value = "true";
				}
			} catch (e) {}
		}
		isHasAtts();
		if(!saveOffice()) {
			return ;
		}
		isFormSumit=true;
		disableButtons();
		if(getA8Top()!=null) {
		  	//getA8Top().startProc("");
		}
		if (getA8Top().isCtpTop) {
			document.getElementById('dataForm').target="_self";
		} else {
			document.getElementById('dataForm').target="hiddenIframe";
		}

		document.getElementById('method').value='save';
		document.getElementById('formOper').value='save';
		document.getElementById('listType').value = listType;
		setMeetingDateNotDisabled();
		is_A6sProduct();
		if (getA8Top().isCtpTop == undefined || getA8Top().isCtpTop == "undefined") {
			document.getElementById('isOpenWindow').value = "true";
	    }
		document.getElementById('dataForm').submit();
	}
}

/** 离开当前页面时保存到草稿箱 **/
function saveAsDraft(checkFlag) {
	if(myCheckForm(document.getElementById('dataForm'), "AsDraft")) {
		saveAttachment();
		cloneAllAttachments();
		if("${mtAppId}" != null && "${mtAppId}" != "") {//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
			try {
				var needClones = document.getElementsByName("attachment_needClone");
				for(var i=0; i<needClones.length; i++) {
					needClones[i].value = "true";
				}
			} catch (e) {}
		}
		isHasAtts();
		if(!saveOffice()) {
			return ;
		}
		isFormSumit=true;
		disableButtons();
		if(getA8Top()!=null) {
		  	getA8Top().startProc("");
		}
		document.getElementById('dataForm').target="hiddenIframe";
		document.getElementById('method').value='save';
		document.getElementById('formOper').value='save';
		document.getElementById('listType').value=listType;

		setMeetingDateNotDisabled();
		document.getElementById('dataForm').submit();
		return true;
	} else {
		return false;
	}
}

function isHasAtts() {
  	if(fileUploadAttachments.size()>0) {
      	document.getElementById("isHasAtt").value = "true";
  	} else {
     	document.getElementById("isHasAtt").value = "false";
  	}
}

/** 保存模板 **/
function saveAsTemplate() {
	document.getElementById('dataForm').enable = true;
	if(myCheckForm(document.getElementById('dataForm'), "saveAsTemplate")) {

		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtTemplateManager", "isMeetTempUnique", false);
		requestCaller.addParameter(1, "String", document.getElementById('title').value);
		requestCaller.addParameter(2, "Long", '${param.templateId}');
		var ds = requestCaller.serviceRequest();
		if(ds=='false') {
			if(window.confirm(v3x.getMessage("meetingLang.template_already_exist_confirm_save", document.getElementById('title').value))) {
				_toSaveTemplate()
            }
		}else{
			_toSaveTemplate();
		}
	}
}

/**
 * 执行模版保存或覆盖保存操作
 */
function _toSaveTemplate(){
		saveAttachment();
		cloneAllAttachments();
		isHasAtts();
		if(!saveOffice()) {
			return ;
		}

		fileId = getUUID();

		isFormSumit = true;
		if(document.getElementById("meetingCharacter").checked) {
			document.getElementById('meetingCharacter').value = "true";
		} else {
			document.getElementById('meetingCharacter').value = "false";
		}
		document.getElementById('dataForm').target="hiddenIframe";
		document.getElementById('method').value="saveAsTemplateNew";
		document.getElementById('dataForm').submit();
	}

//xiangfan 修改，修复在FireFox下提交表单，浏览器崩溃的问题
function send(params) {
	var theForm = document.getElementsByName("dataForm")[0];
	document.getElementById('method').value="save";
	if (getA8Top().isCtpTop == undefined || getA8Top().isCtpTop == "undefined") {
		document.getElementById('isOpenWindow').value = "true";
    }
	theForm.action = "${meetingURL}?method="+document.getElementById('method').value+params;
	disableButtons();
	if (getA8Top().isCtpTop) {
		theForm.target="_self";
	} else {
		theForm.target="hiddenIframe";
	}
	theForm.submit();
	//getA8Top().startProc('');
}
/******************************** 会议保存 start **************************************/


/******************************** 清理数据 start **************************************/
function setMeetingDateNotDisabled(){
	//提交前需要将会议开始时间和结束时间input的disabled属性取消掉，不然时间参数无法提交到后台
	document.getElementById("beginDate").disabled="";
	document.getElementById("endDate").disabled="";
}

function cleanMt() {
	document.getElementById("selectRoomType").value = "";
	document.getElementById("meetingroomId").value="";
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("oldRoomAppId").value="";
}

//清空select的optings
function optionsClear(selectObject) {
	var length = selectObject.options.length;
	for(var i=length-1;i>=0;i--) {
		selectObject.options[i] = null;;
 	}
}

function disableButtons() {
    disableButton("send");
    disableButton("save");
    disableButton("saveAs");
    disableButton("insert");
    <c:if test="${param.flag!='editMeeting'}">
	    disableButton("loadTemplate");
    </c:if>
    disableButton("bodyTypeSelectorspan");
    disableButton("bodyTypeSelector");
    isFormSumit = true;
    var title = document.getElementById('title').value;
	document.getElementById('title').value = title.trim();
}

function enableButtongs(){//会在后台调用
	enableButton("send");
	enableButton("save");
	enableButton("saveAs");
	enableButton("insert");
    <c:if test="${param.flag!='editMeeting'}">
        enableButton("loadTemplate");
    </c:if>
    enableButton("bodyTypeSelectorspan");
    enableButton("bodyTypeSelector");
    isFormSumit = false;
}

/******************************** 清理数据 end **************************************/

/******************************** 视频会议 start **********************************/
//不显示密码区域
function validatePasswordArea() {
	<c:if test="${hasVideoConferencePlugin }">
		if(document.getElementById("meetingNature")) {
			var headHeight = $("#contentTable").height();
			var className = $("#passwordArea").attr("class");
			if(document.getElementById("meetingNature").value == 1) {
			    if(className!=null && className.indexOf("hidden")==-1) {
				   $("#passwordArea").addClass("hidden");
			   	}
			} else if(document.getElementById("meetingNature").value == 2) {
			   	if(className!=null && className.indexOf("hidden")!=-1) {
				   $("#passwordArea").removeClass("hidden");
			   	}
			}
		}
		resetContextHeight();//重新计算高度
		</c:if>
}

//页面初始化的时候给密码框一个默认值
function setPasswordTextDefValue(obj) {
	<c:if test="${hasVideoConferencePlugin }">
		if(obj=="meetingPassword") {
			document.getElementById("meetingPassword").value = v3x.getMessage("meetingLang.meeting_click_enter_password");
     	}

	   	if(obj=="meetingPasswordConfirm"){
			document.getElementById("meetingPasswordConfirm").value = v3x.getMessage("meetingLang.meeting_click_enter_password_2");
	   	}

 		if(obj=="all"){
 	   		document.getElementById("meetingPassword").value = v3x.getMessage("meetingLang.meeting_click_enter_password");
        	document.getElementById("meetingPasswordConfirm").value = v3x.getMessage("meetingLang.meeting_click_enter_password_2");
     	}
 	</c:if>
}

//密码输入框验证
function changeTextValue(obj) {
	<c:if test="${hasVideoConferencePlugin }">
      	var password;
      	if(obj=="meetingPassword") {
          	password = document.getElementById("meetingPassword").value.trim();
      	}
  		if(obj=="meetingPasswordConfirm") {
  			password = document.getElementById("meetingPasswordConfirm").value.trim();
  		}
      	if(password.length!=0 && password.indexOf(v3x.getMessage("meetingLang.meeting_click_enter_password")) < 0) {
           	//donothing
      	}
      	if(password.length == 0) {
      		setPasswordTextDefValue(obj);
      	}
      	if(password.length != 0 && password.indexOf(v3x.getMessage("meetingLang.meeting_click_enter_password")) > 0) {
          	alert(v3x.getMessage("meetingLang.meeting_please_enter_password"));
      	}
	</c:if>
}

//清空密码输入框
function clearPassword(obj) {
	<c:if test="${hasVideoConferencePlugin}">
  		if(obj=="meetingPassword" && $("#meetingPassword").val() == v3x.getMessage("meetingLang.meeting_click_enter_password")) {
  			document.getElementById("meetingPassword").value="";
  			$("#meetingPassword").css("color","black");
  		}
		if(obj=="meetingPasswordConfirm" && $("#meetingPasswordConfirm").val() == v3x.getMessage("meetingLang.meeting_click_enter_password_2")) {
  			document.getElementById("meetingPasswordConfirm").value="";
  			$("#meetingPasswordConfirm").css("color","black");
  		}
	</c:if>
}

function validatePassword() {
	var password = document.getElementById("meetingPassword").value.trim();
	var passwordConfirm = document.getElementById("meetingPasswordConfirm").value.trim();
	
	if(password == null || password == v3x.getMessage("meetingLang.meeting_click_enter_password")){
	    alert(v3x.getMessage("meetingLang.meeting_please_enter_password"));//请输入密码
	    return false;
	}
	
	if(password != passwordConfirm) {
		alert(v3x.getMessage("meetingLang.meeting_password_confirm_false"));
		return false;
	}
	if(password ==""||passwordConfirm =="") {
		alert(v3x.getMessage("meetingLang.meeting_password_enter_false"));
		return false;
	}
	var re=/^[0-9a-zA-Z]{4,16}$/;
	if (password.search(re)==-1) {
		alert(v3x.getMessage("meetingLang.enter_only_num_letter"));
		return false;
  	}
	return true;
}

/******************************** 视频会议 end **********************************/

// 从字符串时间转换成Long时间
function stringTimeToLongTime(stringTime) {
	if(stringTime!=null && stringTime.length==16) {
		var time = new Date(stringTime.substring(0,4),stringTime.substring(5,7)-1,stringTime.substring(8,10),stringTime.substring(11,13),stringTime.substring(14,16));
		return time.getTime();
	} else {
		return "";
	}
}

//时间
function selectMeetingTime(thisDom) {
	var evt = v3x.getEvent();
	var x = evt.clientX?evt.clientX:evt.pageX;
	var y = evt.clientX?evt.clientX:evt.pageY;
	whenstart('${pageContext.request.contextPath}', thisDom, x, y,'datetime');
}
function saveWaitSendSuccess(fromOpen){
	refreshSection();
	try{
		if (getA8Top().isCtpTop == undefined) {
			var _win = getA8Top().opener.getCtpTop().$("#main")[0];
			var url = _win.contentWindow.location.href;
			if (url.indexOf("meetingNavigation.do") != -1 || url.indexOf("meeting.do") != -1) {
				if (fromOpen == "save") {
					_win.contentWindow.location = "${meetingURL}?method=listWaitSendMeeting&listType=listWaitSendMeeting";
				} else {
					_win.contentWindow.location = "${meetingURL}?method=listSendMeeting&listType=listSendMeeting";
				}
			}
		}
	}catch(e){}
	getA8Top().close();
}
//如果是项目会议 就需要刷新 项目计划/会议/事件  栏目
function refreshSection(){
	try{
		var win = getA8Top().opener.getCtpTop().$("#main")[0].contentWindow.$("#body")[0].contentWindow;
		if (win != undefined) {
    		if (win.sectionHandler != undefined) {
    		  	//刷新 项目计划/会议/事件  栏目
                win.sectionHandler.reload("projectPlanAndMtAndEvent",true);
            }
		}
	}catch(e){}
}

function changeRemindFlag(obj) {
	var optionsValue;
	for(var i=0; i<obj.options.length; i++){
		if(obj.options[i].selected){
			optionsValue = obj.options[i].value;
			break;
		}
	}
	if(optionsValue == 0){
		document.getElementById("remindFlag").value=false;
	}else{
		document.getElementById("remindFlag").value=true;
	}
}

//切换正文组件后的回调函数
function changeBodyTypeCallBack(){
	var opts = document.getElementById("selectFormat");
	 opts.options[0].selected = true;
	 
	 //HTML正文高度不对
	 _resizeCkeContent();
}

</script>

<jsp:include page="../include/deal_exception.jsp" />
