<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>

<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>
<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>
	<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /></c:if><fmt:message key="mt.mtMeeting" />
</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/leave.js${v3x:resSuffix()}" />"></script>
<fmt:message key="mt.mtMeeting.select.meeting.place" var="_selectplace"/>
<fmt:message key="mt.mtMeeting.input.meeting.place" var="_inputplace"/>
<fmt:message key="mt.mtMeeting.appMeetingRoom" var="_selectmeeting"/>

</head>
<body scroll='no' onload="init();"  onbeforeunload="onbeforeunload()" style="${(param.associatMeet!=null)&&((param.associatMeet=='associat'))?'padding:5px':''};overflow-y:hidden;" onunload="myOnUnload()">

<!-- 参会领导 -->
<fmt:message key="mt.mtMeeting.leader" var="_myLabel"/>

<!-- <点击此处选择{0}>-->
<fmt:message key="label.please.select" var="_myLabelDef">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<!-- 会议名称 -->
<fmt:message key="mt.list.column.mt_name" var="_label_name"/>

<!-- <点击此处填写{0}> -->
<fmt:message key="label.please.input" var="_defaultInputName">
	<fmt:param value="${_label_name}" />
</fmt:message>

<c:choose>
	<c:when test="${param.flag=='editMeeting'}">
		<c:set value="editMeeting" var="locationKey" />
	</c:when>
	<c:otherwise>
		<c:set value="newMeeting" var="locationKey" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${bean.id==null || bean.id==-1}">
		<c:set value="" var="meetingId" />
	</c:when>
	<c:otherwise>
		<c:set value="${bean.id}" var="meetingId" />
	</c:otherwise>
</c:choose>

<script type="text/javascript"><!--

//////////////////////////当前位置
showCtpLocation("F09_meetingManager",{surffix:"新建会议"});

/******************************** 初始化数据 start **************************************/	
function init(){
	//xiangfan 添加条件已发起的会议通，再次编辑时不应该有'是否保存到草稿箱'的功能 修复GOV-3922
	if("${listType}" != "listNoticeMeeting" || "${action}" != "edit"){
		//initLeave(0);
	}
	getCanUseMeetingrooms();
	loadCollboration();
	firstMtTypeContentLoad();
}

function firstMtTypeContentLoad() {
	<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) {%>
		changeMtType(document.getElementById("meetingTypeId"));
	<% } %>
	changeRoomType(document.getElementById("selectRoomType"), true);
}
/******************************** 初始化数据 end **************************************/	

// 显示会议室使用情况
function showUsedMeetingrooms(){
	var w = 750; 
	var h1 = 287;//半个窗口高
	var h2 = 600;//整个窗口高
       var l = (screen.width - w)/2; 
       var t = (screen.height - h2)/2; 
	window.showModalDialog("${mrUrl}?method=view",self,"dialogHeight: "+h1+"px; dialogWidth:"+w+"px;dialogTop:"+t+";dialogLeft: "+l+";center: yes;help:no; status=no");
}

// ajax导入当前可以使用的会议室
function getCanUseMeetingrooms(){
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
	<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
	    validatePasswordArea();//打开页面默认不显示密码区域
		if(document.getElementById("videoConfStatus").value!='disable'){
			setPasswordTextDefValue("all");//页面初始化的时候给密码框一个默认值
		}
	<%}%>
}

//判断会议室是否占用
function isMeetingroomUsed() {
    var selectRoomTypeObj = document.getElementById("selectRoomType");
    var selectType = "";
    
	//如果选择了填写会议地点，则不需要再判断会议室是否可用
	if(selectRoomTypeObj) {
		if(selectRoomTypeObj.value=="mtPlace"){
			return true;
		}
	}
	
	//会议室的占用判断
	//取消了会议室，那么肯定通过会议室占用的判断，注意将来要要删除会议室关联
	if(document.getElementById('meetingroomId').value=="" || document.getElementById('meetingroomId').value=="noMeetingroom"){
	  return true;
	}
	
	//选中的是否是后台"会议室管理"已申请的会议室
	var appedFlag = false;
	if(selectRoomTypeObj) {
		for(var i=0;i<selectRoomTypeObj.options.length;i++){
        	if(selectRoomTypeObj.options[i].selected){
             	selectType = selectRoomTypeObj.options[i].getAttribute("rType");
             	if(selectType =="apped") appedFlag = true; //xiangfan 选择了 已经审核通过的会议室 就不需要在验证了！
          	}
       	}
    }
	if(appedFlag) {
		return true;
	} else { // 没有取消会议室，那么要验证这个会议室是否被占用
		try{
			var beginDate = document.all.beginDate.value;
	    	var endDate = document.all.endDate.value;

	    	if(document.getElementById('meetingroomId').value == "noMeetingroom" || document.getElementById('meetingroomId').value == ""){
				alert("请选择会议室!");
				return;
			}
	    	
			if( beginDate!=null && beginDate.length==16 && endDate!=null && endDate.length==16){ // 如果会议时间选择正确
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxMeetingRoomManager", "checkMeetingRoomForMeeting", false);
				
				// Long v3xOrgMember, Long meetingRoomId, Long meetingRoomAppId, Long startDatetime, Long endDatetime
				requestCaller.addParameter(1, "Long", document.getElementById('userId').value);
				requestCaller.addParameter(2, "Long", document.getElementById('meetingroomId').value);
				requestCaller.addParameter(3, "Long", "${bean.id}");										
				requestCaller.addParameter(4, "Long", stringTimeToLongTime(beginDate));
				requestCaller.addParameter(5, "Long", stringTimeToLongTime(endDate));
				var ds = requestCaller.serviceRequest();
				if(ds=="true"){
					return true;
				}else if(ds=="timeerror") {
					alert(v3x.getMessage("meetingLang.meetingroom_timeerror"));
					return false;
				}else if(ds=="timefalse") {
					if(window.confirm(v3x.getMessage("meetingLang.meetingroom_used"))) {
						return true;
					} else {
						return false;
					}
				}else if(ds=="appfalse") {
					alert(v3x.getMessage("meetingLang.meetingroom_appfalse"));
					return false;
				}else if(ds=="delete") {
					alert(v3x.getMessage("meetingLang.meetingroom_delete"));
					return false;
				}else if(ds=="false"){
					//您选择的会议室在选择的会议时间段内已被占用，您确定要继续发起这个会议吗？
					if(window.confirm(v3x.getMessage("meetingLang.meetingroom_used"))) {
						return true;
					} else {
						return false;
					}
				}else if(ds=="${meetingId}"){
					return true;
				}else {
					if(window.confirm(v3x.getMessage("meetingLang.meetingroom_used"))) {
						return true;
					} else {
						return false;
					}
				}
			} else { <%-- 如果会议时间选择不正确 --%>
				alert(v3x.getMessage("meetingLang.meetingroom_time_error"));
				return false;
			}
		}catch(ex1){
			alert("Exception : " + ex1);
			return false;
		}
	}
	return true;		
}

// 清空select的optings
function optionsClear(selectObject){
  	var length = selectObject.options.length;
	for(var i=length-1;i>=0;i--){
		selectObject.options[i] = null;;
    }
}  
	
// 从字符串时间转换成Long时间
function stringTimeToLongTime(stringTime){
	if(stringTime!=null && stringTime.length==16){
		var time = new Date(stringTime.substring(0,4),stringTime.substring(5,7)-1,stringTime.substring(8,10),stringTime.substring(11,13),stringTime.substring(14,16));
		return time.getTime();
	}else{
		return "";
	}
}

//时间
function selectMeetingTime(thisDom){
	var evt = v3x.getEvent();
	var x = evt.clientX?evt.clientX:evt.pageX;
	var y = evt.clientX?evt.clientX:evt.pageY;
	whenstart('${pageContext.request.contextPath}', thisDom, x, y,'datetime');
}	

function validFieldData() {
	var titleObj = document.getElementById("title");
	var meetingPlaceObj = document.getElementById("meetingPlace");
	var selectRoomTypeObj = document.getElementById("selectRoomType");
	var RoomselectedIndex = selectRoomTypeObj.selectedIndex;
	
	if(titleObj && titleObj.value.length > 85){
		alert(v3x.getMessage("meetingLang.name_validate"));
		return false;
	} else if(meetingPlaceObj && selectRoomTypeObj.options[RoomselectedIndex].value =="mtPlace" && selectRoomTypeObj.options[RoomselectedIndex].text.length==0){
		alert("会议地址不能为空。");
		return false;
	} else if(meetingPlaceObj && selectRoomTypeObj.options[RoomselectedIndex].value =="mtPlace" && meetingPlaceObj.value.length > 60){
		alert("会议室名称不能超过60字.");
		return false;
	} 
	//可以不选择会议室
	/*else if(meetingPlaceObj && selectRoomTypeObj.options[RoomselectedIndex].value =="mtRoom" && 
			(document.getElementById("meetingroomId").value=="noMeetingroom" || document.getElementById("meetingroomId").value=="")) {
		alert("请申请会议室。");
		return false;
	}*/
	return true;
}

//参会人会议时间冲突校验
function meetingColliedValidate(recorder,emcee,conferees,meetingId){
  var beginDate = document.getElementById("beginDate").value;
  var endDate = document.getElementById("endDate").value;
  var _url = "${mtMeetingURL}?method=listMeetingCollideIframe&mtId="+meetingId+"&conferees="+conferees+"&emcee="+emcee+"&recorder="+recorder+"&beginDate="+beginDate+"&endDate="+endDate;
  //mark by xuqiangwei Chrome37修改，这里应该被废弃了
  var returnValue = v3x.openWindow({
    url:_url,
    dialogType:"modal",
    width:600,
    height:560
  });
  if(returnValue){
    return returnValue[0];
  }
  return "false";
}

function hasMeetingAtTimeRange(recorder,emcee,conferees,meetingId){
  var beginDate = document.getElementById("beginDate").value;
  var endDate = document.getElementById("endDate").value;
  if(beginDate == "" || beginDate == ""){
    return false;
  }
  var requestCaller = new XMLHttpRequestCaller(this,"ajaxMtMeetingManager","hasMeetingAtTimeRange",false);
  requestCaller.addParameter(1,"String",beginDate);
  requestCaller.addParameter(2,"String",endDate);
  requestCaller.addParameter(3,"String",recorder);
  requestCaller.addParameter(4,"String",emcee);
  requestCaller.addParameter(5,"String",conferees);
  requestCaller.addParameter(6,"String",meetingId);
  var ds = requestCaller.serviceRequest();
  return ds;
}

// 调用send方法
function toSend(meetingId){
    var meetingId = "";
    if(document.getElementById("mtId")){
      meetingId = document.getElementById("mtId").value;//如果从编辑过来的 会获取被编辑会议的ID，冲突的会议需要过滤掉这个会议 OA-5489
    }
    var recorder = document.getElementById("recorderId").value;
    var emcee = document.getElementById("emceeId").value;
    var conferees = document.getElementById("conferees").value;
	//当从已通过的会议申请 转到 发布会议通知页面的 就不进行 会议通知修改的判断
	if('${meetAppToMeet}'!= 'true' && meetingId!='' && !validateCanEdit(meetingId,"ajaxMtMeetingManager")) {
		alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
		self.history.back();
		return false;
	}
	if(myCheckForm(document.getElementById('dataForm'), "toSend") && isMeetingroomUsed() ){
	    if(hasMeetingAtTimeRange(recorder,emcee,conferees,meetingId) == "true"){
	      if(meetingColliedValidate(recorder,emcee,conferees,meetingId) == "false")
	        return ;
	    }
		document.getElementById('formOper').value='send';
		saveAttachment();
		cloneAllAttachments();
		isHasAtts();
		if(!meetingSaveOffice()){
			return ;
		}
		setMeetingDateNotDisabled();		
		if("${mtAppId}" != null && "${mtAppId}" != ""){//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
			try{
				var needClones = document.getElementsByName("attachment_needClone");
				for(i=0; i<needClones.length; i++){
					needClones[i].value = "true";
				}
			}catch (e) {}
		}
		send();
	}
}

function setMeetingDateNotDisabled(){
	//提交前需要将会议开始时间和结束时间input的disabled属性取消掉，不然时间参数无法提交到后台
	document.getElementById("beginDate").disabled="";
	document.getElementById("endDate").disabled="";
}
	
function saveAsDraft(checkFlag){
	if(myCheckForm(document.getElementById('dataForm'), "AsDraft")){
		saveAttachment();
		cloneAllAttachments();
		if("${mtAppId}" != null && "${mtAppId}" != ""){//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
			try{
				var needClones = document.getElementsByName("attachment_needClone");
				for(i=0; i<needClones.length; i++){
					needClones[i].value = "true";
				}
			}catch (e) {
			}
		}
		isHasAtts();
		if(!meetingSaveOffice()){
			return ;
		}
		isFormSumit=true;
		disableButtons();
		if(getA8Top()!=null){
		  getA8Top().startProc("");
		}
		document.getElementById('dataForm').target="";
		document.getElementById('method').value='save';
		document.getElementById('formOper').value='save';
		setMeetingDateNotDisabled();
		document.getElementById('dataForm').submit();		
		return true;
	}else{
		return false;
	} 
}
	
// 调用save方法
function toSave(){
	if(myCheckForm(document.getElementById('dataForm'), "toSave")){
		/******************************** 视频会议 start **********************************/
		if(document.getElementById('videoConfStatus').value.length!=0  &&  document.getElementById('meetingNature').value != "1"){
           var flag = validatePassword();
            if(!flag){
               return;
            }       
        }
		/******************************** 视频会议 end **********************************/
		saveAttachment();
		cloneAllAttachments();
		if("${mtAppId}" != null && "${mtAppId}" != ""){//从会议申请 转会议通知的 情况下，如果有附件带过来，在发送时克隆附件 xiangfan 添加 修复：GOV-3042.会议申请转会议通知的时候，附件没有带过去
			try{
				var needClones = document.getElementsByName("attachment_needClone");
				for(i=0; i<needClones.length; i++){
					needClones[i].value = "true";
				}
			}catch (e) {
			}
		}
		isHasAtts();
		if(!meetingSaveOffice()){
			return ;
		}
		isFormSumit=true;
		disableButtons();
		if(getA8Top()!=null){
		  //getA8Top().startProc("");
		}
		document.getElementById('dataForm').target="";
		document.getElementById('method').value='save';
		document.getElementById('formOper').value='save';
		setMeetingDateNotDisabled();
		document.getElementById('dataForm').submit();				
	}
}
	
<%-- 使用会议格式 --%>
function loadContentTemplate(){
	if(document.getElementsByName('contentTemplateId')[0].value==''){
		if(confirm(v3x.getMessage("meetingLang.load_clearTemplate"))){
			document.getElementById('formOper').value="loadTemplate";
			document.getElementById('dataForm').target="";
			document.getElementById('method').value="${param.method}";
			saveAttachment();
			meetingSaveOffice();
			isFormSumit = true;
			document.getElementById('dataForm').submit();
		}else{
			var selectFormatlength1 = document.getElementById('selectFormat').options.length;
			for(var i=selectFormatlength1-1;i>=0;i--){
				if(selectFormat_oldValue==document.getElementById('selectFormat').options[i].value){
					document.getElementById('selectFormat').options[i].selected="selected";
				}
			}
		}
	}else{
		if(confirm(v3x.getMessage("meetingLang.load_text_sure"))){
			//document.getElementById('templateIframe').src='<c:url value="/bulTemplate.do?method=detail" />&preview=true&load=true&id='+$F('templateId');;
			document.getElementById('formOper').value="loadTemplate";
			document.getElementById('dataForm').target="";
			document.getElementById('method').value="${param.method}";
			saveAttachment();
			meetingSaveOffice();
			isFormSumit = true;
			document.getElementById('dataForm').submit();
		}else{
			var selectFormatlength2 = document.getElementById('selectFormat').options.length;
			for(var i=selectFormatlength2-1;i>=0;i--){
				if(selectFormat_oldValue==document.getElementById('selectFormat').options[i].value){
					document.getElementById('selectFormat').options[i].selected="selected";
				}
			}
		}
	}
}
	
function isHasAtts(){
  if(fileUploadAttachments.size()>0){
      document.getElementById("isHasAtt").value = "true";
  }
  else{
      document.getElementById("isHasAtt").value = "false";
  }
}

	
function saveAsTemplate(){
	document.getElementById('dataForm').enable = true;
	if(myCheckForm(document.getElementById('dataForm'), "saveAsTemplate")){
	
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtTemplateManager", "isMeetTempUnique", false);
		requestCaller.addParameter(1, "String", document.getElementById('title').value);
		requestCaller.addParameter(2, "Long", '${param.templateId}');
		var ds = requestCaller.serviceRequest();
		if(ds=='false'){
			alert(v3x.getMessage("meetingLang.template_already_exist"));
			return;
		}
	
		saveAttachment();
		cloneAllAttachments();
		isHasAtts();
		if(!meetingSaveOffice()){
			return ;
		}
		
		fileId = getUUID();
		
		isFormSumit = true;
		document.getElementById('dataForm').target="hiddenIframe";
		document.getElementById('method').value="saveAsTemplateNew";
		document.getElementById('dataForm').submit();
	}
}
	
function selectResources(){
	var dlgArgs=new Array();
	dlgArgs['width']=450;
	dlgArgs['height']=360;
	dlgArgs['resizable']='false';
	dlgArgs['url']='${mtMeetingURL}?method=selectResources&type='+document.getElementById('resourcesId').value;
	//mark by xuqiangwei Chrome37修改，这里应该被废弃了
	var elements=v3x.openWindow(dlgArgs);
	if(elements!=null){
		document.getElementById('resourcesId').value=getIdsString(elements,false);
		document.getElementById('resourcesName').value=getNamesString(elements,true);
	}
}

function chanageBodyTypeExt(type){
	if(chanageBodyType(type))
	  document.getElementById('dataFormat').value=type;
}

///////////////////////按钮
var myBar = new WebFXMenuBar("/seeyon");
  	    	
var insert = new WebFXMenu;
insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument()"));

<c:if test="${bean.state==10||bean.state==0}"> 
	myBar.add(new WebFXMenuButton("send", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "toSend('${meetingId}');", [1,4], "", null));
</c:if>
<c:if test="${bean.state==0}">
	myBar.add(new WebFXMenuButton("save", "<fmt:message key='meeting.list.button.waitsend' />",  "toSave();", [1,5], "", null));   	
</c:if>
<c:if test="${param.flag!='editMeeting'}">
	myBar.add(new WebFXMenuButton("loadTemplate", "<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}'/>", "showTemplate()", [3,7], "", null));    	
</c:if>
 	
<c:if test="${bean.state==10||bean.state==0}"> 
	myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='mt.templet.saveAs'/>", "saveAsTemplate();", [3,5], "", null));   	
	myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
	myBar.add(${v3x:bodyTypeSelector("v3x")});
	if(bodyTypeSelector){
		bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
	}
</c:if>
    				    	
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
	
	var curretnDate = new Date();
	curretnDate = curretnDate.format("yyyy-MM-dd HH:mm");
	curretnDate = Date.parse(curretnDate.replace(/\-/g,"/"));
	var beginDate = document.getElementById('beginDate').value;
	beginDate = Date.parse(beginDate.replace(/\-/g,"/"));
	if(curretnDate>beginDate && type != "toSave"){//xiangfan 添加 保存到草稿箱不需要有此提示 修复GOV-3392
		return confirm(v3x.getMessage("meetingLang.begin_date_validate"));
	}
	
	/******************************** 视频会议 start **********************************/
	if($('nowDate').value>$('beginDate').value){
	    <%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
		    if(document.getElementById("meetingNature").value == 2){
		       alert(v3x.getMessage("meetingLang.meeting_not_before_now"));
		       return false;
		    }
	    <%}%>
		return confirm(v3x.getMessage("meetingLang.begin_date_validate"));
	}
	/******************************** 视频会议 end **********************************/
	
  	//与会资源的占用判断
  	var beginDate = document.all.beginDate.value;
  	var endDate = document.all.endDate.value;

	/*
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxResourceManager", "isResourcesImpropriated", false);
		requestCaller.addParameter(1, "String", document.getElementById('resourcesId').value);
		requestCaller.addParameter(2, "Long", document.getElementById('meetingId').value);
		requestCaller.addParameter(3, "date", beginDate+":00");
		requestCaller.addParameter(4, "date", endDate+":00");
		var ds = requestCaller.serviceRequest();
		if(ds != "|"){
			var dsArr = ds.split("|");
			var msgStr = "";
			// 判断 资源在刚刚有没有被删除
			if(dsArr[0]=="del1"){
				alert(v3x.getMessage("meetingLang.a_resource_just_deleted"));
				selectResources();
				return false;
			}else if(dsArr[0]=="deln"){
				alert(msgStr = v3x.getMessage("meetingLang.more_resources_just_deleted"));
				selectResources();
				return false;
			}
			// 提示当前条件下已经被占用的资源名称
			if(dsArr[1]!=""){
				msgStr =v3x.getMessage("meetingLang.the_following_resources_are_occupied") + "\n" + dsArr[1];
				return confirm(msgStr);
			}
		}
	}
	catch (ex1) {
		alert("Exception : " + ex1);
	}
	*/
	
	if(document.getElementById("selectRoomType").value=="mtPlace" && document.getElementById("meetingPlace").value=='<${_inputplace }>') {
		document.getElementById("meetingPlace").value = "";
	}
	if(document.getElementById("selectRoomType").value=="mtPlace" && document.getElementById("meetingPlace").value=='') {
		document.getElementById("meetingPlace").value = "";
	}
	return true;
}
    	
var ht = new Hashtable();
    	
function validateMtRoom(obj){
	var beginDate = document.all.beginDate.value;
   	var endDate = document.all.endDate.value;
   	var options = obj.options;
   	for(var i=1 ; i<obj.options.length;i++){
   		if(options[i].selected){
   			try {
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxResourceManager", "isResourcesImpropriated", false);
				requestCaller.addParameter(1, "Long", options[i].value);
				requestCaller.addParameter(2, "date", beginDate+":00");
				requestCaller.addParameter(3, "date", endDate+":00");
				var ds = requestCaller.serviceRequest();
				if(ds == 'true'){
					alert(v3x.getMessage("meetingLang.resource_used"));
				}
			} catch (ex1) {
				alert("Exception : " + ex1);
			}
   		}
   	}
}
//xiangfan 修改，修复在FireFox下提交表单，浏览器崩溃的问题
function send(){
	/******************************** 视频会议 start **********************************/
	if(document.getElementById('videoConfStatus').value.length!=0  &&  document.getElementById('meetingNature').value !="1"){
	        var flag = validatePassword();
        if(!flag){
           return;
        }      
    }
	/******************************** 视频会议 end **********************************/
	//getA8Top().startProc('');
	var theForm = document.getElementsByName("dataForm")[0];
	document.getElementById('method').value="save";
	theForm.action = "${mtMeetingURL}?method="+document.getElementById('method').value;
 	disableButtons();
 	theForm.target="_self";
 	theForm.submit();
 	//getA8Top().startProc('');
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
		
function showTemplate(){
	window.showModalDialog("${mtMeetingURL}?method=showTemplate",window,"DialogHeight:380px;DialogWidth:500px;status=no;");
}

function checkSelectConferees(element){
	if(!isDefaultValue(element)){
		selectMtPeople('conferees','conferees');
		return false;
	}
	return true;
}
		
isNeedCheckLevelScope_emcee = false;
isNeedCheckLevelScope_conferees = false;
isNeedCheckLevelScope_recorder = false;
${alert};


//添加,选择会议室弹出图形化选择界面
function showMTRoom(){
	//用来记录是添加还是修改的标记(如果是添加则不能拖动任何的时间段,如果是修改,再去判断拖动的是否是当前的会议,如果是则可拖动,否则不难拖动)
	var action="${action}";
	//修改的时候取得会议的ID用来判断只许修改当前ID的会议
	var meetingId="${meetingId}";
	var w = 1100; 
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
    var retObj = window.showModalDialog("${mrUrl}?method=mtroom&returnMr="+returnMr+"&action="+action+"&meetingId="+meetingId+"&date="+new Date().getTime(),self,"dialogHeight: "+h1+"px; dialogWidth:"+w+"px;dialogTop:"+t+";dialogLeft: "+l+";center: yes;help:no; status=no");

    if(retObj!=null&&""!=retObj){
    	var strs=retObj.split(",");
	    if(strs.length>0) {
	    	
	    	var meetingroomId = strs[0];
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
			
			if(document.getElementById("selectRoomType")) {
			  	document.getElementById("selectRoomType").options[0].text = strs[1]+"("+roomAppBeginDate+"--"+roomAppEndDate+")";
			  	document.getElementById("selectRoomType").options[0].setAttribute("meetingroomId", meetingroomId);
			  	document.getElementById("selectRoomType").options[0].setAttribute("isNeedApp", needApp);
			 	document.getElementById("selectRoomType").options[0].setAttribute("startDatetime", roomAppBeginDate);
			  	document.getElementById("selectRoomType").options[0].setAttribute("endDatetime", roomAppEndDate);
			  	document.getElementById("selectRoomType").options[0].selected = true;
			}
        }
   }
   
}

function cleanMt(){
	document.getElementById("selectRoomType").value = "";
	document.getElementById("meetingroomId").value="";
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("oldRoomAppId").value="";
}

function openNotice(){
	var msg = '<fmt:message key="label.please.input" />';
	var msg_sub = '<fmt:message key="mt.mtMeeting.note" />';
	msg = msg.replace("{0}",msg_sub);
	var value = document.getElementById("notice").value;
	if(msg == value){
		value = "";
	}

	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openNotice&content="+encodeURI(value)+"&ndate="+new Date().getTime();
	var retObj = window.showModalDialog(url,window ,feacture);
}

function openPlan(){
	var msg = '<fmt:message key="label.please.input" />';
	var msg_sub = '<fmt:message key="mt.mtMeeting.plan" />';
	msg = msg.replace("{0}",msg_sub);
	var value = document.getElementById("plan").value;
	if(msg == value){
		value = "";
	}
	
	var winWidth = 500;
	var winHeight = 350;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
	var url = "mtAppMeetingController.do?method=openPlan&content="+encodeURI(value)+"&ndate="+new Date().getTime();
	var retObj = window.showModalDialog(url,window ,feacture);
}

function changeMtType(obj){
	var mtTypeId;
	for(i=0;i<obj.options.length;i++){
		if(obj.options[i].selected){
			mtTypeId = obj.options[i].value;
			break;
		}
	}
	
	var url = "mtAppMeetingController.do?method=getMtTypeContents&id=${bean.id}&mtTypeId="+mtTypeId+"&date="+new Date().getTime();
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
	}else if (window.ActiveXObject) { 
		req = new ActiveXObject("Microsoft.XMLHTTP"); 
		
	} 
}

//协同转发附件
function loadCollboration(){
	var affairIdObj = document.getElementById("affairId");
	var titleObj = document.getElementById("title");
    if(affairIdObj.value==null||affairIdObj.value==''){
       return;
    }else{
	     var type = "2";
	     var filename = titleObj.value;
	     var mimeType = 'collaboration';
	     var createDate = "2000-01-01 00:00:00";
	     var fileUrl = affairIdObj.value;
	     var description = fileUrl;
	     var documentType = mimeType;
	     addAttachment(type, filename, mimeType, createDate, '0', fileUrl, true, null, description, documentType, documentType + ".gif");
   }
}

function complete(){
	if (req.readyState == 4) { 
		if (req.status == 200) {
			
			var table = document.getElementById("contentTable");
			var rowlen = table.rows.length;
			//目前table中只有7行
			var initlen = 7;
			<c:if test="${v3x:hasPlugin('videoconference')}">
				initlen = 8;
			</c:if>
			if(rowlen > initlen){
				var start = 4;
				<c:if test="${v3x:hasPlugin('videoconference')}">
					start = 5;
				</c:if>
	            for(var i=0;i<rowlen-initlen ;i++){   
	            	table.deleteRow(start);   
	            }
			}
			//从第四行后开始增加
			var count = 4;
			<c:if test="${v3x:hasPlugin('videoconference')}">
				count = 5;
			</c:if>
			if("empty" != req.responseText ) {
				var json = eval(req.responseText);
				//var s = '<tr class="bg-summary" >';
				var tr = table.insertRow(count);   
				tr.className = "bg-summary";
				var num = 0;
				for(i=0;i<json.length;i++){
					var cl = json[i].jsFunction != '' ? 'onclick="'+json[i].jsFunction+'"' : '';
					var handCursor = json[i].cursor == 'true'? 'cursor-hand' : '';
					var v = json[i].inputValue == "" ? json[i].inputContent : json[i].inputValue;	
					var isreadonly = json[i].readonly == "true" ? 'readonly="true" ' : ' '; 
					
					var td1 = tr.insertCell(num++);
					td1.className = "bg-gray";
					td1.style.cssText = "width:'8%'";
					td1.innerHTML = json[i].name+'<fmt:message key="label.colon" />';
					

					var td2 = tr.insertCell(num++);
					td2.colSpan = 3;
					if(json[i].personSelect == "true"){
						
						var leaderId = '${bean.leader}';
						var leaderName = '${bean.leaderName}';
						if(leaderName=="")leaderName='${_myLabelDef}';
						
						td2.innerHTML = '<input type="hidden" id="leader" name="leader" value="'+leaderId+'"/>'+
						'<input type="text" class="input-100per cursor-hand" id="leaderNames" name="leaderNames" '+ isreadonly +
						'value="'+leaderName+'" '+
						'deaultValue="${_myLabelDef}"'+
						'onfocus="checkDefSubject(this, true)"'+
						'onblur="checkDefSubject(this, false)"'+
						'inputName="${_myLabel}" '+
						'validate="notNull"'+
						'onclick="selectMtPeople(\'leader\',\'leader\');"'+
						'/>';
						
					}else{
						var length= json[i].inputLength;
						var subV = v;
						if(v != null && v.length > 30 && json[i].inputName != "attender"){
							subV = v.substring(0, 30) + "...";
						}
						var str =' <input type="text" '+cl+' class="input-100per '+handCursor+'" name="'+json[i].inputName + '" id="'+json[i].inputName + '"'+
						' maxSize="'+length+'" deaultValue="'+json[i].inputContent+'" validate="maxLength" '+
						' value="'+subV+'" inputName="'+json[i].name + '" '+ isreadonly +
						' onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)"/>';
						if(json[i].hiddenInputName != ""){
							str += ' <input type="hidden" value="'+v+'" name="'+json[i].hiddenInputName+'" id="'+json[i].hiddenInputName+'" />';
						}
						td2.innerHTML = str;
					}
					if((i+1)%2 == 0){
						num = 0;
						tr = table.insertRow(++count);  
						tr.className = "bg-summary";
					}
				}
			}
		}
	}
}	

function changeRoomType(obj, isOnLoad){
	var selectedRoomType = "";//选中的会议室id
	var meetingPlace = "";
	var meetingroomId = "";
	var startDatetime = "";
	var endDatetime = "";
	var isNeedApp = "";
	for(i=0;i<obj.options.length;i++){
		
		if(obj.options[i].selected) {
			
			selectedRoomType = obj.options[i].value;
			if(obj.options[i].text != "<fmt:message key='mt.meMeeting.input' />"){
				meetingPlace = obj.options[i].text;
			}
			meetingroomId = obj.options[i].getAttribute("meetingroomId");
			startDatetime = obj.options[i].getAttribute("startDatetime");
			endDatetime = obj.options[i].getAttribute("endDatetime");
			isNeedApp = obj.options[i].getAttribute("isNeedApp");
		    if(i>0){//xiangfan 第0个是新建会议室申请 不存在 meetingRoomApp
		      	document.getElementById("roomAppId").value = obj.options[i].getAttribute("roomAppId");
		    }
		    if(obj.options[i].getAttribute("isFromPortal")=="true") {
				document.getElementById("isFromPortal").value = "true";
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

//弹出会议地址录入界面。
function meetingAddressChange(meetingPlace) {
     //mark by xuqiangwei Chrome37修改，这里应该被废弃了
	 var meetingAddress = v3x.openWindow({
		url: "mtMeeting.do?method=meetingAddressInputEntry&meetingPlace="+encodeURI(meetingPlace),
		width:"350",
		resizable : "no",
		height:"200"
	});
	if(meetingAddress!=undefined && meetingAddress!="undefined" && meetingAddress != ''){
		var sel = document.getElementById("selectRoomType"); 
		document.getElementById("meetingroomId").value="";
		document.getElementById("meetingPlace").value=meetingAddress;
		sel.options[1].text = meetingAddress;
	}
	return;
}	

//协同转发附件
function loadCollboration(){
   var affairIdObj = document.getElementById("affairId");
   var titleObj = document.getElementById("title");
   if(affairIdObj.value==null||affairIdObj.value==''){
      return;
   }else{
	    var type = "2";
	    var filename = titleObj.value;
	    var mimeType = 'collaboration';
	    var createDate = "2000-01-01 00:00:00";
	    var fileUrl = affairIdObj.value;
	    var description = fileUrl;
	    var documentType = mimeType;
	   
	    addAttachment(type, filename, mimeType, createDate, '0', fileUrl, true, null, description, documentType, documentType + ".gif");
   }
}

/******************************** 视频会议 start **********************************/
//不显示密码区域
function validatePasswordArea(){
	<c:if test="${v3x:hasPlugin('videoconference')}">
		if(document.getElementById("meetingNature")){
		   if(document.getElementById("meetingNature").value == 1){
		        document.getElementById("passwordArea").style.display="none";
		   }else if(document.getElementById("meetingNature").value == 2){
		        document.getElementById("passwordArea").style.display="";
		   }
		}
	</c:if>
}
  
//页面初始化的时候给密码框一个默认值
function setPasswordTextDefValue(obj){
	<c:if test="${v3x:hasPlugin('videoconference')}">
		if(obj=="meetingPassword"){
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
function changeTextValue(obj){
	<c:if test="${v3x:hasPlugin('videoconference')}">
        var password;
        if(obj=="meetingPassword"){
            password = document.getElementById("meetingPassword").value.trim();
        }
    	
    	if(obj=="meetingPasswordConfirm"){
    		password = document.getElementById("meetingPasswordConfirm").value.trim();
    	}
    	
        if(password.length!=0 && password.indexOf(v3x.getMessage("meetingLang.meeting_click_enter_password")) < 0){
             //donothing
        }
        
        if(password.length == 0){
        	setPasswordTextDefValue(obj);
        }
        
        if(password.length != 0 && password.indexOf(v3x.getMessage("meetingLang.meeting_click_enter_password")) > 0){
            alert(v3x.getMessage("meetingLang.meeting_please_enter_password"));
        }
	</c:if>
}
	
//清空密码输入框
function clearPassword(obj){
	<c:if test="${v3x:hasPlugin('videoconference')}">
    if(obj=="meetingPassword"){
    	document.getElementById("meetingPassword").value="";
    }
	if(obj=="meetingPasswordConfirm"){
    	document.getElementById("meetingPasswordConfirm").value="";
    }
	</c:if>
}
	
function validatePassword(){
	var password = document.getElementById("meetingPassword").value.trim();
	var passwordConfirm = document.getElementById("meetingPasswordConfirm").value.trim();
      
	if(password != passwordConfirm){
		alert(v3x.getMessage("meetingLang.meeting_password_confirm_false"));
		return false;
	}
      
	if(password ==""||passwordConfirm ==""){
		alert(v3x.getMessage("meetingLang.meeting_password_enter_false"));
		return false;
	}

	var re=/^[0-9a-zA-Z]{4,16}$/;
	if (password.search(re)==-1){ 
		alert(v3x.getMessage("meetingLang.enter_only_num_letter"));
		return false;
    }
      
	return true; 
}
	
/******************************** 视频会议 end **********************************/


--></script>

<div class="newDiv" style="${(param.associatMeet!=null)&&((param.associatMeet=='associat'))?'border:solid 1px #A4A4A4':''}">

<form id="dataForm" name="dataForm" action="${mtMeetingURL}" method="post">

<input type="hidden" id="method" name="method" value="save" />

<fmt:formatDate value="${nowTime}" pattern="yyyy-MM-dd HH:mm" var="nowDate"/>
<input type="hidden" name="nowDate" id="nowDate" value="${nowDate}" />

<!-- 页面入口参数 -->
<input type="hidden" id="listType" name="listType" value="${listType}" />
<input type="hidden" id="formOper" name="formOper" value="save" />
<input type="hidden" name="fromMethod" value="${fromMethod != null?fromMethod:param.method }"/>
<%--向凡 添加，如果会议申请转会议通知时sendType=publishAppToMt,其他情况为空值,同样是为了不允许删除其他会议的会议室问题--%>
<input type="hidden" name="sendType" id="sendType" value="${param.sendType}" >
<%--xiangfan 添加， 会议室申请有两个入口【申请会议室】和【新建会议通知】RoomApp表示入口是【申请会议室】 MtMeeting表示入口是【新建会议通知】--%>
<input type="hidden" name="appType" id="appType" value="MtMeeting" />

<!-- 会议申请ID -->
<input type="hidden"  name="mtAppId" value="${mtAppId}" />
<!-- 会议资源ID -->
<!--
<input type="hidden" id="resourcesId" name="resourcesId" value="${bean.resourcesId}" />
-->
<input type="hidden" id="userId" name="userId" value="${v3x:currentUser().id}" />
<input type="hidden" id="meetingId" name="meetingId" value="${meetingId}" />
<input type="hidden" name="affairId" id="affairId" value="${affairId}"/>
<input type="hidden" name="tempId" value="${param.templateId}" />
<input type="hidden" name="project" value="${project}" />
<input type="hidden" id="isHasAtt" name="isHasAtt" value="" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />

<!-- 当从 会议申请审核通过列表中 转到会议通知页面的时候，不保存id,因为这时候的id不是会议通知的id而是会议申请的id -->
<c:if test="${meetAppToMeet != 'true' }">
	<input type="hidden" id="mtId" name="id" value="${bean.id}" />
</c:if>
<input type="hidden" name="meetAppToMeet" value="true" />

<!-- ******************************** 视频会议 start ********************************** -->
<input type="hidden" name="videoConfPoints" id="videoConfPoints" value="${videoConfPoints}"/>
<input type="hidden" name="videoConfStatus" id="videoConfStatus" value="${videoConfStatus}"/>
<!-- ******************************** 视频会议 end ********************************** -->

<!-- ******************************** 图形化会议室 start ********************************** -->

<input type="hidden" id="portalRoomAppId" name="portalRoomAppId" value="${param.portalRoomAppId}"/>
<!-- 手工输入地址 -->
<input type="hidden" name="meetingPlace" id="meetingPlace" value="${bean.meetPlace}"/>
<!-- 选择会议室 -->
<input type="hidden" id="isFromPortal" name="isFromPortal" value=""/>
<input type="hidden" id="hasMeetingRoom" name="hasMeetingRoom" value="${hasMeetingRoom}"/>
<input type="hidden" name="oldRoomAppId" id="oldRoomAppId" value="${oldRoomAppId}"/>
<input type="hidden" id="roomAppId" name="roomAppId" value="${roomAppId}" />
<input type="hidden" name="meetingroomId" id="meetingroomId" value="${meetingroomId}" />
<input type="hidden" name="meetingroomName" id="meetingroomName" value="${meetingroomName}" />
<input type="hidden" name="needApp" id="needApp" value="${needApp}"/>
<fmt:formatDate value="${roomAppBeginDate}" pattern="yyyy-MM-dd HH:mm" var="roomAppBeginDateJsp"/>
<fmt:formatDate value="${roomAppEndDate}" pattern="yyyy-MM-dd HH:mm" var="roomAppEndDateJsp"/>
<input type="hidden" id="roomAppBeginDate" name="roomAppBeginDate" value="${roomAppBeginDateJsp }" />
<input type="hidden" id="roomAppEndDate" name="roomAppEndDate" value="${roomAppEndDateJsp }" />
<c:forEach items="${meetingRoomApp }" var="app">
	<input type="hidden" name="beginTime${app.meetingRoom.id }" id="beginTime${app.meetingRoom.id }" value="${app.startDatetime}" />
	<input type="hidden" name="endTime${app.meetingRoom.id }" id="endTime${app.meetingRoom.id }" value="${app.endDatetime}" />
</c:forEach>
<!-- ******************************** 图形化会议室 end ********************************** -->

<c:set value="${v3x:parseElements(emceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(recorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(confereeList, 'id', 'entityType')}" var="confereesList"/>
<c:set value="${v3x:parseElements(leaderList, 'id', 'entityType')}" var="leaderList"/>

<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="conferees" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker" selectType="Account,Member,Department,Team,Post" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<v3x:selectPeople id="leader" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${leaderList}" panels="Department,Team,Post,Outworker" selectType="Member" jsFunction="setMtPeopleFields(elements,'leader','leaderNames')" />
	
<%---------------------G6会议 start--------------------------%>
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_CREATE_OTHER) { %>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="22" class="webfx-menu-bar">
			<script type="text/javascript">
			<!--
					document.write(myBar);
					var elements_emceeArr = elements_emcee;
					var elements_confereesArr = elements_conferees;
					var elements_recorderArr = elements_recorder;
					var hiddenPostOfDepartment_conferees = true;
			//-->
			</script>
		</td>
	</tr>
		
	<tr>
		<td height="10">
			<table border="0" height="10" cellpadding="0" cellspacing="0" width="100%" align="center" id="contentTable">
				<tr class="bg-summary">
					<td width="8%" class="bg-gray"><fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" /></td>
					<td width="42%" colspan="3">
						<jsp:include page="../include/inputDefine.jsp">
							<jsp:param name="_property" value="title" />
							<jsp:param name="_key" value="mt.list.column.mt_name" />
							<jsp:param name="_validate" value="notNull,isDefaultValue,notSpecChar" />
						</jsp:include>
					</td>
						
					<%-- G6 会议格式 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.templateId" /><fmt:message key="label.colon" /></td>
					<td width="17%" colspan="3">
						<select id="selectFormat" name="contentTemplateId" class="input-100per" value="${bean.templateId}" onchange="loadContentTemplate();">
							<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.templateId" />&gt;</option>
							<c:forEach items="${contentTemplateList}" var="contentTemplate">
								<option value='${contentTemplate.id}'>${contentTemplate.templateName}</option>
							</c:forEach>
						</select>
						<script type="text/javascript">
						<!--
					    	var selectFormatlength = document.getElementById('selectFormat').options.length;
							for(var i=selectFormatlength-1;i>=0;i--){
								if("${bean.templateId}"==document.getElementById('selectFormat').options[i].value){
									document.getElementById('selectFormat').options[i].selected="selected";
								}
					        }
					        var selectFormat_oldValue = document.getElementById("selectFormat").value;
					    //-->
						</script>
						<input type="hidden" id="loadTemplate" value="<fmt:message key="oper.load" />" onclick="loadContentTemplate();" />
					</td>
				</tr>
				<tr class="bg-summary">
					<%-- G6 主持人 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
					<td width="18%" class="bg-gray">
						<fmt:message key="mt.mtMeeting.emceeId" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
		
						<input type="hidden" id="emceeId" name="emceeId" value="${bean.emceeId}"/>
						<input type="text" class="input-100per cursor-hand" id="emceeName" name="emceeName" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							validate="notNull,isDefaultValue"
							onclick="selectMtPeople('emcee','emceeId');"
							/>
					</td>
						
					<%-- G6 记录人 --%>
					<td width="6%" class="bg-gray"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
					<td width="18%">
						<fmt:message key="mt.mtMeeting.recorderId" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
						
						<input type="hidden" id="recorderId" name="recorderId" value="${bean.recorderId}"/>
						<input type="text" class="input-100per cursor-hand" id="recorderName" name="recorderName" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							onclick="selectMtPeople('recorder','recorderId');"
							/>
					</td>
						
					<%-- G6 参会人员 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.join" /><fmt:message key="label.colon" /></td>
					<td width="42%" colspan="3">
						<fmt:message key="mt.mtMeeting.join" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
						<input type="hidden" id="conferees" name="conferees" value="${bean.conferees}"/>
						<%-- 通过会议模板新建会议、或者在关联项目主页新建项目会议时，会初始化与会人员值，作为新旧对比的旧值，应置为空 --%>
						<input type="hidden" id="oldConferees" name="oldConferees" value="${param.formOper eq 'createByTemplate' || project eq 'project' ? '' : bean.conferees}"/>
						<input type="text" class="input-100per cursor-hand" id="confereesNames" name="confereesNames" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							validate="notNull,checkSelectConferees"
							onclick="selectMtPeople('conferees','conferees');"
							/>
					</td>
				</tr>
				<tr class="bg-summary">
					<%-- G6 会议室地点 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.place" /><fmt:message key="label.colon" /></td>
					<td width="24%" class="bg-gray" colspan="2">
						<select id="selectRoomType" name="selectRoomType" onchange="changeRoomType(this,false);" style="width:100%;">
							<option value="mtRoom" meetingroomId="${meetingroomId}" isNeedApp="${needApp}" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.beginDate}' />" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.endDate}' />" <c:if test="${bean.room!=null && param.portalRoomAppId==''}">selected</c:if>>
                               <c:choose>
                                   <c:when test="${bean.room != null}">${bean.roomName}</c:when>
                                   <c:otherwise><fmt:message key="mt.meMeeting.decription" /></c:otherwise>
                               </c:choose>
                               </option>
							<option value="mtPlace" <c:if test="${(bean.room == null && bean.meetPlace != null && bean.meetPlace != '') && param.portalRoomAppId==''}">selected</c:if>>
                               <c:choose>
                                   <c:when test="${(bean.room == null && bean.meetPlace != null && bean.meetPlace != '')}">${bean.meetPlace}</c:when>
                                   <c:otherwise><fmt:message key="mt.meMeeting.input" /></c:otherwise>
                               </c:choose>
                               </option>
							<c:forEach items="${meetingRoomApp }" var="app">
								<option value="mtRoom" roomAppId="${app.id}" meetingroomId="${app.meetingRoom.id }" <c:if test="${param.portalRoomAppId==app.id?'selected':''}" /> isNeedApp="0" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.startDatetime}' />" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.endDatetime}' />" rType="apped">${app.meetingRoom.name }(<fmt:formatDate pattern="${datetimePattern}" value="${app.startDatetime}" />--<fmt:formatDate pattern="${datetimePattern}" value="${app.endDatetime}" />)</option> 
							</c:forEach>
						</select>					
					</td>
					<td width="18%" align="left">
						<input width="80%" type="button" id="chooseMeetingRoom" value="申请会议室" onclick="showMTRoom()" />
					</td>
						
					<%-- G6 会议类型 --%>
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) {%>
						<td width="8%" class="bg-gray">
							<fmt:message key="mt.mtMeeting.meetingType" /><fmt:message key="label.colon" />
						</td>
						<td width="42%" colspan="3">
							<select id="meetingTypeId" name="meetingTypeId" class="input-100per" onchange="changeMtType(this);">
								<c:forEach items="${mtTypeList}" var="mt">
									<option value='${mt.id}' <c:if test="${mt.id == bean.meetingTypeId}">selected</c:if>>${v3x:toHTML(mt.name)}</option>
								</c:forEach>
							</select>
							
						</td>
					<% } else { %>
						<td colspan="4"></td>
					<% } %>
				</tr>
					
				<tr class="bg-summary">
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" /></td>
					<td width="17%" class="bg-gray">
						<input type="text" readonly="true" class="input-100per cursor-hand" name="beginDate" id="beginDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key="mt.mtMeeting.beginDate" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.beginDate}" />" />
					</td>
					<td width="8%" class="bg-gray">
						<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:
					</td>
					<td width="17%">
						<input type="text" readonly="true" class="input-100per cursor-hand" name="endDate" id="endDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key='common.date.endtime.label' bundle="${v3xCommonI18N}" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.endDate}" />" />
					</td>
					
					<%-- G6 会议提醒 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.remindFlag" /><fmt:message key="label.colon" /></td>
					<td width="17%" colspan="1">
						<input type="checkbox" id="remindFlag" name="remindFlag" value="${bean.remindFlag}"  onclick="this.checked?document.getElementById('beforeTime').disabled=false:document.getElementById('beforeTime').disabled=true;" />
						<fmt:message key="mt.mtMeeting.beforeTime"/><fmt:message key="label.colon" />
						<select id="beforeTime" name="beforeTime" value="${bean.beforeTime}" disabled="true">
							<v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="beforeTime" selected="${bean.beforeTime}" />
						</select>
						<script type="text/javascript">
						<!--
							//document.getElementById('remindFlag').checked=<c:if test="${bean.remindFlag}">true</c:if><c:if test="${!bean.remindFlag}">false</c:if>;
							document.getElementById('remindFlag').checked = true;
							document.getElementById('remindFlag').checked?document.getElementById('beforeTime').disabled=false:document.getElementById('beforeTime').disabled=true;
							//setSelectValue("beforeTime","${bean.beforeTime}");
						//-->
						</script>
					</td>	
						
					<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
						<!-- G6  视频会议选择框 -->
						<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.meetingNature"/><fmt:message key="label.colon" /></td>
						<td width="17%">
							<select id="meetingNature" name="meetingNature" class="input-100per" ${videoConfStatus eq 'enable'?'':'disabled'} onclick="validatePasswordArea()">
								<option value="1"><fmt:message key="mt.mtMeeting.label.ordinary"/></option>
								<option value="2" ${bean.meetingType eq '2' ? 'selected':''}><fmt:message key="mt.mtMeeting.label.video"/></option>
							</select>
						</td>
					<%}%>
				</tr>
					
				<!-- G6  视频会议密码输入框 -->
				<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")) { %>
                    <tr class="bg-summary" id="passwordArea" >
					  	<td colspan="8">
					    	<table width="100%" align="center">
					      		<tr>
					        		<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.password" /><fmt:message key="label.colon" /></td>
									<td width="11%">
										<input type="text" style="width:100%"  id="meetingPassword" name="meetingPassword" onblur="changeTextValue('meetingPassword')" onclick="clearPassword('meetingPassword')" />
									</td>
		                            <td width="10%"><label style="width:100%">(<fmt:message key="mt.mtMeeting.letter.or.num" />)</label></td>
									
									<td width="8%"align="right"><fmt:message key="mt.mtMeeting.password.confirm" /><fmt:message key="label.colon" /></td>
									<td width="13%">
										<input type="text"  style="width:100%" id="meetingPasswordConfirm" name="meetingPasswordConfirm"  onblur="changeTextValue('meetingPasswordConfirm')" onclick="clearPassword('meetingPasswordConfirm')" />
									</td>
							
									<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td colspan="4" align="left"><input type="checkbox" id="meetingCharacter" name="meetingCharacter" value="${bean.meetingCharacter}"/><fmt:message key="mt.mtMeeting.character"/></td>
									<script type="text/javascript">
			                                 $('meetingCharacter').checked=<c:if test="${bean.meetingCharacter}">true</c:if><c:if test="${!bean.meetingCharacter}">false</c:if>;
			                        </script>
							 	</tr>
					    	</table>
					  	</td>
					</tr>
			 	<% } %>
					
				<tr id="attachment2TR" class="bg-summary" style="display:none;">
				     <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
				     <td colspan="7" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
				     <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
				</tr>					
				
				<tr id="attachmentTR" style="display:none;" class="bg-summary">
					<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
					<td class="value" colspan="7">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
						<v3x:fileUpload originalAttsNeedClone="${originalBodyNeedClone}" attachments="${attachments}" canDeleteOriginalAtts="true" />
					</td>
				</tr>
					
				<tr>
		  			<td colspan="9" height="6" class="bg-b"></td>
		 		</tr>
			</table>
		</td>
	</tr>
		
	<c:choose>
	<c:when test="${bean.state!=0 && bean.state!=10 && bean.state!=null}">
	<tr>
		<td>
			<v3x:editor content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" originalNeedClone="${originalBodyNeedClone}" htmlId="col-contentText"/>
		</td>
	</tr>
	</c:when>
	<c:otherwise>
	<tr>
		<td>
			<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" originalNeedClone="${originalBodyNeedClone}"
				createDate="${bean.createDate}" category="<%=ApplicationCategoryEnum.meeting.getKey()%>"/>
		</td>
	</tr>
	</c:otherwise>
	</c:choose>
</table>
<%---------------------G6会议 end--------------------------%>
	
<% } else { %>
	
<%---------------------A6 A8会议 start--------------------------%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="22" class="webfx-menu-bar">
			<script type="text/javascript">
			<!--
					document.write(myBar);
					var elements_emceeArr = elements_emcee;
					var elements_confereesArr = elements_conferees;
					var elements_recorderArr = elements_recorder;
					var hiddenPostOfDepartment_conferees = true;
			//-->
			</script>
		</td>
	</tr>
	<tr>
		<td height="10">
			<table border="0" height="10" cellpadding="0" cellspacing="0" width="100%" align="center" id="contentTable">
				<tr class="bg-summary">
					<%-- A6 A8 会议名称 --%>
					<td width="8%" class="bg-gray"><font color="red">*</font><fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" /></td>
					<td width="42%" colspan="3">
						<%-- <jsp:include page="../include/inputDefine.jsp">
							<jsp:param name="_property" value="title" />
							<jsp:param name="_key" value="mt.list.column.mt_name" />
							<jsp:param name="_validate" value="notNull,isDefaultValue,notSpecChar" />
						</jsp:include> --%>
                        <fmt:message key="label.please.input" var="_myLabelDefault">
                            <fmt:param value="会议名称" />
                        </fmt:message>
                        <input type="text" class="input-100per" id="title" name="title" maxlength="60"
                            value="<c:out value="${bean.title}" default="${_myLabelDefault}" escapeXml="true" />" 
                            title="${bean.title}"
                            deaultValue="${_myLabelDefault}"
                            onfocus="checkDefSubject(this, true)"
                            onblur="checkDefSubject(this, false)"
                            inputName="<fmt:message key='mt.list.column.mt_name'/>"
                            validate="notNull,isDefaultValue,notSpecChar"
                            ${param.clearValue}
                        />
					</td>
					<%-- A6 A8 会议开始结束时间 --%>
					<td width="8%" class="bg-gray"><font color="red">*</font><fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" /></td>
					<td width="17%" class="bg-gray">
						<input type="text" readonly="true" class="input-100per cursor-hand" name="beginDate" id="beginDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key="mt.mtMeeting.beginDate" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.beginDate}" />" />
					</td>
					<td width="8%" class="bg-gray"><font color="red">*</font><fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:
					</td>
					<td width="17%">
						<input type="text" readonly="true" class="input-100per cursor-hand" name="endDate" id="endDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key='common.date.endtime.label' bundle="${v3xCommonI18N}" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.endDate}" />" />
					</td>
				</tr>
				
				<tr class="bg-summary">
					<%-- A6 A8 主持人 --%>
					<td width="8%" class="bg-gray"><font color="red">*</font><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
					<td width="18%" class="bg-gray">
						<fmt:message key="mt.mtMeeting.emceeId" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
		
						<input type="hidden" id="emceeId" name="emceeId" value="${bean.emceeId}"/>
						<input type="text" class="input-100per cursor-hand" id="emceeName" name="emceeName" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							validate="notNull,isDefaultValue"
							onclick="selectMtPeople('emcee','emceeId');"
							/>
					</td>
					<%-- A6 A8  记录人 --%>
					<td width="6%" class="bg-gray"><fmt:message key="mt.mtMeeting.recorderId" /><fmt:message key="label.colon" /></td>
					<td width="18%">
						<fmt:message key="mt.mtMeeting.recorderId" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
						
						<input type="hidden" id="recorderId" name="recorderId" value="${bean.recorderId}"/>
						<input type="text" class="input-100per cursor-hand" id="recorderName" name="recorderName" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							onclick="selectMtPeople('recorder','recorderId');"
							/>
					</td>
					<%-- A6 A8 会议提醒 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.remindFlag" /><fmt:message key="label.colon" /></td>
					<td width="17%" colspan="1">
						<input type="checkbox" id="remindFlag" name="remindFlag" value="${bean.remindFlag}"  onclick="this.checked?document.getElementById('beforeTime').disabled=false:document.getElementById('beforeTime').disabled=true;" />
						<fmt:message key="mt.mtMeeting.beforeTime"/><fmt:message key="label.colon" />
						<select id="beforeTime" name="beforeTime" value="${bean.beforeTime}" disabled="true">
							<v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="beforeTime" selected="${bean.beforeTime}" />
						</select>
						<script type="text/javascript">
						<!--
							//document.getElementById('remindFlag').checked=<c:if test="${bean.remindFlag}">true</c:if><c:if test="${!bean.remindFlag}">false</c:if>;
							document.getElementById('remindFlag').checked = true;
							document.getElementById('remindFlag').checked?document.getElementById('beforeTime').disabled=false:document.getElementById('beforeTime').disabled=true;
							//setSelectValue("beforeTime","${bean.beforeTime}");
						//-->
						</script>
					</td>
					<%-- A6 A8 会议格式 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.templateId" /><fmt:message key="label.colon" /></td>
					<td width="17%" colspan="3">
						<select id="selectFormat" name="contentTemplateId" class="input-100per" value="${bean.templateId}" onchange="loadContentTemplate();">
							<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.templateId" />&gt;</option>
							<c:forEach items="${contentTemplateList}" var="contentTemplate">
								<option value='${contentTemplate.id}'>${contentTemplate.templateName}</option>
							</c:forEach>
						</select>
						<script type="text/javascript">
						<!--
					    	var selectFormatlength = document.getElementById('selectFormat').options.length;
							for(var i=selectFormatlength-1;i>=0;i--){
								if("${bean.templateId}"==document.getElementById('selectFormat').options[i].value){
									document.getElementById('selectFormat').options[i].selected="selected";
								}
					        }
					        var selectFormat_oldValue = document.getElementById("selectFormat").value;
					    //-->
						</script>
						<input type="hidden" id="loadTemplate" value="<fmt:message key="oper.load" />" onclick="loadContentTemplate();" />
					</td>
					
				</tr>
				<tr class="bg-summary">
					<%-- A6 A8 参会人员 --%>
					<td width="8%" class="bg-gray"><font color="red">*</font><fmt:message key="mt.mtMeeting.join" /><fmt:message key="label.colon" /></td>
					<td width="42%" colspan="3">
						<fmt:message key="mt.mtMeeting.join" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
						<input type="hidden" id="conferees" name="conferees" value="${bean.conferees}"/>
						<%-- 通过会议模板新建会议、或者在关联项目主页新建项目会议时，会初始化与会人员值，作为新旧对比的旧值，应置为空 --%>
						<input type="hidden" id="oldConferees" name="oldConferees" value="${param.formOper eq 'createByTemplate' || project eq 'project' ? '' : bean.conferees}"/>
						<input type="text" class="input-100per cursor-hand" id="confereesNames" name="confereesNames" readonly="true" 
							value="<c:out value="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
							title="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}"
							deaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							validate="notNull,checkSelectConferees"
							onclick="selectMtPeople('conferees','conferees');"
							/>
					</td>
					
					<%-- A6 A8 所属项目 --%>
					<td width="8%" class="bg-gray">
						<fmt:message key="mt.mtMeeting.projectId" /><fmt:message key="label.colon" />
					</td>
					
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) {%>
						<td>
					<% } else {%>
						<td width="42%" colspan="3">
					<% } %>
						<select id="projectId" name="projectId" class="input-100per" value="${bean.projectId}">
							<option value="-1">&lt;<fmt:message key="oper.please.select" /><fmt:message key="mt.mtMeeting.projectId" />&gt;</option>
							<c:forEach items="${projectMap}" var="project">
								<option value='${project.id}'>${v3x:toHTML(project.projectName)}</option>
							</c:forEach>
						</select>
						<script type="text/javascript">
						<!--
							<c:set value="${bean.projectId==null ? '-1' : bean.projectId}" var="projectId" />
							setSelectValue("projectId","${projectId}");
						//-->
						</script>
					</td>
					<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) {%>
						<td width="8%" class="bg-gray">
							<fmt:message key="mt.mtMeeting.meetingType" /><fmt:message key="label.colon" />
						</td>
						<td width="42%" colspan="3">
							<select id="meetingTypeId" name="meetingTypeId" class="input-100per" onchange="changeMtType(this);">
								<c:forEach items="${mtTypeList}" var="mt">
									<option value='${mt.id}' <c:if test="${mt.id == bean.meetingTypeId}">selected</c:if>>${v3x:toHTML(mt.name)}</option>
								</c:forEach>
							</select>
							
						</td>
					<% } %>
				</tr>
					
				<tr class="bg-summary">
					<%-- A6 A8 会议室地点 --%>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.place" /><fmt:message key="label.colon" /></td>
					<td width="24%" class="bg-gray" colspan="2">
						<select id="selectRoomType" name="selectRoomType" onchange="changeRoomType(this,false);" style="width:100%;">
							<option value="mtRoom" meetingroomId="${meetingroomId}" isNeedApp="${needApp}" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.beginDate}' />" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.endDate}' />" <c:if test="${bean.room != null && param.portalRoomAppId==''}">selected</c:if>>
                               <c:choose>
                                   <c:when test="${bean.room != null}">${bean.roomName}</c:when>
                                   <c:otherwise><fmt:message key="mt.meMeeting.decription" /></c:otherwise>
                               </c:choose>
                               </option>
							<option value="mtPlace" <c:if test="${(bean.room == null && bean.meetPlace != null && bean.meetPlace != '') && param.portalRoomAppId==''}">selected</c:if>>
                               <c:choose>
                                   <c:when test="${(bean.room == null && bean.meetPlace != null && bean.meetPlace != '')}">${bean.meetPlace}</c:when>
                                   <c:otherwise><fmt:message key="mt.meMeeting.input" /></c:otherwise>
                               </c:choose>
                               </option>
							<c:forEach items="${meetingRoomApp }" var="app">
								<option value="mtRoom" roomAppId="${app.id}" isFromPortal="${param.portalRoomAppId==app.id}" <c:if test="${param.portalRoomAppId==app.id}">selected</c:if> meetingroomId="${app.meetingRoom.id }" isNeedApp="0" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.startDatetime}' />" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.endDatetime}' />" rType="apped">${app.meetingRoom.name }(<fmt:formatDate pattern="${datetimePattern}" value="${app.startDatetime}" />--<fmt:formatDate pattern="${datetimePattern}" value="${app.endDatetime}" />)</option> 
							</c:forEach>
						</select>					
					</td>
					<td width="18%" align="left">
						<input width="80%" type="button" id="chooseMeetingRoom" value="申请会议室" onclick="showMTRoom()" />
					</td>
					
					<%-- A6 A8 与会资源 --%>
                    <c:choose>
                    <c:when test="${hasPubRsourcePlug}">
                        <td width="8%" class="bg-gray">
                            <fmt:message key="mt.resource"/><fmt:message key="label.colon" />
                        </td>
                        <td width="17%">
                            <input type="hidden" id="resourcesId" name="resourcesId" value="${bean.resourcesId}" />
                                <input type="text"  readonly="readonly" class="input-100per cursor-hand" id="resourcesName"  name="resourcesName" 
                                value="${v3x:toHTML(bean.resourcesName)}" onclick="selectResources();"/>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td width="8%" class="bg-gray">
                        </td>
                        <td width="17%">
                        </td>
                    </c:otherwise>
                    </c:choose>
						
					<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
					<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.meetingNature"/><fmt:message key="label.colon" /></td>
					<td width="17%">
						<c:choose>
						<c:when test="${videoConfStatus eq 'enable'}">
						<select id="meetingNature" name="meetingNature" class="input-100per"  onclick="validatePasswordArea()">
						</c:when>
						<c:otherwise>
						<select id="meetingNature" name="meetingNature" class="input-100per" disabled='true' onclick="validatePasswordArea()">
						</c:otherwise>
						</c:choose>
							<option value="1"><fmt:message key="mt.mtMeeting.label.ordinary"/></option>
						<c:choose>
						<c:when test="${bean.meetingType eq '2'}">
						    <option value="2" selected><fmt:message key="mt.mtMeeting.label.video"/></option>
						</c:when>
						<c:otherwise>
						    <option value="2"><fmt:message key="mt.mtMeeting.label.video"/></option>
						</c:otherwise>
						</c:choose>
						</select>
					</td>
					<% } else {%>
					<td colspan="2"></td>
					<% } %>
				</tr>
					
				<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
                <tr class="bg-summary" id="passwordArea" >
					<td colspan="8">
						<table width="100%" align="center">
					      	<tr>
					        	<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.password" /><fmt:message key="label.colon" /></td>
								<td width="11%">
									<input type="text" style="width:100%"  id="meetingPassword" name="meetingPassword" onblur="changeTextValue('meetingPassword')" onclick="clearPassword('meetingPassword')" />
								</td>
                            	<td width="10%"><label style="width:100%">(<fmt:message key="mt.mtMeeting.letter.or.num" />)</label></td>
							
								<td width="8%"align="right"><fmt:message key="mt.mtMeeting.password.confirm" /><fmt:message key="label.colon" /></td>
								<td width="13%">
									<input type="text"  style="width:100%" id="meetingPasswordConfirm" name="meetingPasswordConfirm"  onblur="changeTextValue('meetingPasswordConfirm')" onclick="clearPassword('meetingPasswordConfirm')" />
								</td>
							
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td colspan="4" align="left"><input type="checkbox" id="meetingCharacter" name="meetingCharacter" value="${bean.meetingCharacter}"/><fmt:message key="mt.mtMeeting.character"/></td>
								<script type="text/javascript">
	                                 $('meetingCharacter').checked=<c:if test="${bean.meetingCharacter}">true</c:if><c:if test="${!bean.meetingCharacter}">false</c:if>;
	                        	</script>
					      	</tr>
					    </table>
					</td>
				</tr>
				<% } %>
					
				<tr id="attachment2TR" class="bg-summary" style="display:none;">
				     <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
				     <td colspan="7" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
				     <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
				</tr>					
					
				<tr id="attachmentTR" style="display:none;" class="bg-summary">
					<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
					<td class="value" colspan="7">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
						<v3x:fileUpload originalAttsNeedClone="${originalBodyNeedClone}" attachments="${attachments}" canDeleteOriginalAtts="true" />
					</td>
				</tr>
					
				<tr>
		  			<td colspan="9" height="6" class="bg-b"></td>
		 		</tr>
			</table>
		</td>
	</tr>
		
	<c:choose>
	<c:when test="${bean.state!=0 && bean.state!=10 && bean.state!=null}">
	<tr>
		<td>
			<v3x:editor content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" originalNeedClone="${originalBodyNeedClone}" htmlId="col-contentText"/>
		</td>
	</tr>
	</c:when>
	<c:otherwise>
	<tr>
		<td>
			<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" originalNeedClone="${originalBodyNeedClone}"
				createDate="${bean.createDate}" category="<%=ApplicationCategoryEnum.meeting.getKey()%>"/>
		</td>
	</tr>
	</c:otherwise>
	</c:choose>
</table>
<% } %>
<%---------------------A6 A8会议 end--------------------------%>
	
</form>
</div>
<!-- radishlee add 2012-4-16                见cvs版本1.2 无注释 如果调用模板。不许修改    此处删除 ext5字段无用 -->
<c:if test="${bean.isEdit!=null && bean.isEdit!='' && !bean.isEdit && bean.state!=10 }">
<script type="text/javascript">
	$('dataForm').disable();
</script>
</c:if>

<iframe name="hiddenIframe" width="0" height="0"></iframe>
<jsp:include page="../include/deal_exception.jsp" />

<script>
	previewFrame('Down');
</script>
</body>
</html> 