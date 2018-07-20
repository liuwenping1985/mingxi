<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>                 
    
<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /></c:if><fmt:message key="mt.mtMeeting" />
	</title>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/leave.js${v3x:resSuffix()}" />"></script>
</head>
<body scroll='no' onload="init();"  onbeforeunload="onbeforeunload()"  style="${(param.associatMeet!=null)&&((param.associatMeet=='associat'))?'padding:5px':''};overflow-y:hidden;" onunload="myOnUnload()">


<fmt:message key="mt.mtMeeting.leader" var="_myLabel"/>
<fmt:message key="label.please.select" var="_myLabelDef">
	<fmt:param value="${_myLabel}" />
</fmt:message>

<fmt:message key="label.please.input" var="_label_input"/>

<fmt:message key="mt.list.column.mt_name" var="_label_name"/>
<fmt:message key="label.please.input" var="_defaultInputName">
	<fmt:param value="${_label_name}" />
</fmt:message>

<script type="text/javascript">

<!--
<c:choose>
	<c:when test="${param.flag=='editMeeting'}">
		<c:set value="editMeeting" var="locationKey" />
	</c:when>
	<c:otherwise>
		<c:set value="newMeeting" var="locationKey" />
	</c:otherwise>
</c:choose>

/////////////////当前位置
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
<c:choose>
<c:when test="${bean.id==null || bean.id==-1}">
getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.application.label'/>","<fmt:message key='mt.admin.button.create'/><fmt:message key='admin.label.appMeeting'/>");
</c:when>
<c:otherwise>
getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.application.label'/>","<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}'/><fmt:message key='admin.label.appMeeting'/>");
</c:otherwise>
</c:choose>
}

//getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.application.label'/>","<fmt:message key='admin.label.appMeeting'/>");

//mt.admin.button.create

//xiangfan 添加，待审核列表的信息编辑离开时 不需要保存到草稿箱的功能GOV-4032
function init(){
	if("${param.listType}" != "listMyAppMeetingWaitVarificate"){
		initLeave(0);
	}
}

// 显示会议室使用情况
function showUsedMeetingrooms(){
	var w = 750; 
	var h1 = 287;//半个窗口高
	var h2 = 600;//整个窗口高
       var l = (screen.width - w)/2; 
       var t = (screen.height - h2)/2; 
	window.showModalDialog("${mrUrl}?method=view",self,"dialogHeight: "+h1+"px; dialogWidth:"+w+"px;dialogTop:"+t+";dialogLeft: "+l+";center: yes;help:no; status=no");
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

// 选择时间
function selectMeetingTime(thisDom){
	var evt = v3x.getEvent();
	var x = evt.clientX?evt.clientX:evt.pageX;
	var y = evt.clientX?evt.clientX:evt.pageY;
	whenstart('${pageContext.request.contextPath}', thisDom, x, y,'datetime');
}	
		
// 调用send方法
function toSend(meetingId){
	if(meetingId!='' && !validateCanEdit(meetingId)) {
		alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
		self.history.back();
		return false;
	}
	
	if( myCheckForm(document.getElementById('dataForm'))){	
		document.getElementById('formOper').value='send';
		saveAttachment();
		cloneAllAttachments();
		isHasAtts();
		/*if(!saveOffice()){
			return ;
		}*/
		//TODO
		send();
	}
}

function saveAsDraft(checkFlag){
	if(!myCheckForm(document.getElementById('dataForm'))) {
		return;
	}

	saveAttachment();
	cloneAllAttachments();
	isHasAtts();
	if(!saveOffice()){
		return ;
	}
	isFormSumit=true;
	disableButtons();
	if(getA8Top() != null){
	   getA8Top().startProc("");
	}
	document.getElementById('dataForm').target="";
	document.getElementById('method').value='save';
	document.getElementById('formOper').value='save';
	document.getElementById('saveStatus').value='draft';
	document.getElementById('dataForm').submit();		
}
	
// 调用save方法
function toSave(needCheck){
	if(needCheck!=false) {
		if(!myCheckForm(document.getElementById('dataForm'))) {
			return;
		}
	}
	saveAttachment();
	cloneAllAttachments();
	isHasAtts();
	/*if(!saveOffice()){
		return ;
	}*/
	//TODO
	isFormSumit=true;
	disableButtons();
	if(getA8Top() != null){
		try {
			getA8Top().startProc("");
		} catch(e){}	   
	}
	document.getElementById('dataForm').target="";
	document.getElementById('method').value='save';
	document.getElementById('formOper').value='save';
	document.getElementById('saveStatus').value='draft';
	document.getElementById('dataForm').submit();
}
	
<%-- 使用会议格式 --%>
function loadContentTemplate(){
	//debugger;
	if(document.getElementById('contentTemplateId').value==''){
		if(confirm(v3x.getMessage("meetingLang.load_clearTemplate"))){
			document.getElementById('formOper').value="loadTemplate";
			document.getElementById('dataForm').target="";
			document.getElementById('method').value="${param.method}";
			saveAttachment();
			saveOffice();
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
			//document.getElementById('method').value="${param.method}";
			document.getElementById('method').value="create";
			saveAttachment();
			saveOffice();
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

	//for(var i = 0 ; i < templateArray.length ; i++){
	//	if(templateArray[i] == document.getElementById('title').value){
	//		alert(v3x.getMessage("meetingLang.template_already_exist"));
	//		return;
	//	}
	//}

	document.getElementById('dataForm').enable();
	if(myCheckForm(document.getElementById('dataForm'))){
	
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
		if(!saveOffice()){
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
		
var myBar = new WebFXMenuBar("/seeyon");
    	    	
var insert = new WebFXMenu;
insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument()"));

<c:choose>
	<c:when test="${bean.id==null || bean.id==-1}">
		<c:set value="" var="meetingId" />
	</c:when>
	<c:otherwise>
		<c:set value="${bean.id}" var="meetingId" />
	</c:otherwise>
</c:choose>
approveState =  ${bean.approveState};
myBar.add(new WebFXMenuButton("send", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "toSend('${meetingId}');", [1,4], "", null));
<c:if test="${bean.id==null || bean.id==-1 || bean.approveState == 0 || bean.approveState == 40 }">
	myBar.add(new WebFXMenuButton("save", "<fmt:message key='meeting.list.button.waitsend'/>",  "toSave();", [1,5], "", null));   	
</c:if>
    	
myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
myBar.add(${v3x:bodyTypeSelector("v3x")});
if(bodyTypeSelector){
	bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
}

function myCheckForm(myForm){
	var result=document.getElementById('beginDate').value>=document.getElementById('endDate').value;
	if(!checkForm(myForm)){
		return false;
	}
	
	if(result){
		alert(v3x.getMessage("meetingLang.date_validate"));
		return false;
	}
	
	if(document.getElementById('nowDate').value>document.getElementById('beginDate').value){
		return confirm(v3x.getMessage("meetingLang.begin_date_validate"));
	}

	//特殊字符判断
	if(document.getElementById('mtTitle')!=undefined && document.getElementById('mtTitle')!=null) {
		var mtTitleObj = (document.getElementById('mtTitle'));
		if(mtTitleObj.value != v3x.getMessage("meetingLang.meeting_create_subject")){// xiangfan 添加2012-04-24，默认情况下 为'<点击此处填写会议主题>'，要排除掉 修复GOV-2153
			if(!notSpecChar(mtTitleObj)){
				return;
			}
		}
	}
	
	if(document.getElementById('title').value.length>85){
		alert(v3x.getMessage("meetingLang.name_validate"));
		return false;
	}
    		
  	//与会资源的占用判断
  	var beginDate = document.all.beginDate.value;
  	var endDate = document.all.endDate.value;

  	//debugger;
	/*try {
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
	  //TODO
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
			}
			catch (ex1) {
				alert("Exception : " + ex1);
			}
  		}
  	}
}
    	
function send(){
  if(getA8Top() != null){
	  try {
		  getA8Top().startProc('');
	  } catch(e){}
  }
 	disableButtons();
 	//document.getElementById('dataForm').target="";
 	//document.getElementById('method').value="save";
 	document.getElementById('dataForm').submit();
 	//parent.parent.location.href = "mtMeeting.do?method=listHome&menuId=2101&listMethod=list&listType=listMyAppMeetingWaitVarificate";
}
    	
function disableButtons() {
    disableButton("send");
    disableButton("save");
    disableButton("saveAs");
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
	var url = "mtAppMeetingController.do?method=openNotice&content="+encodeURI(value)+"&ndate="+new Date();
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
	var url = "mtAppMeetingController.do?method=openPlan&content="+encodeURI(value)+"&ndate="+new Date();
	var retObj = window.showModalDialog(url,window ,feacture);
}

function openLeader(){
	var winWidth = 500;
	var winHeight = 370;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";

	var approves = document.getElementById("approves").value;
	var url = "mtAppMeetingController.do?method=openLeader&approves="+approves+"&ndate="+new Date();
	var retObj = window.showModalDialog(url,window ,feacture);
}
		

function complete(){
	if (req.readyState == 4) { 
		if (req.status == 200) {
			
			var table = document.getElementById("contentTable");
			var rowlen = table.rows.length;
			//目前table中只有6行
			var initlen = 6;
			if(rowlen > initlen){
				var start = 3;
	            for(var i=0;i<rowlen-initlen ;i++){   
	            	table.deleteRow(start);   
	            }
			}
			//从第三行后开始增加
			var count = 3;
			if("empty" != req.responseText ) {
				var json = eval(req.responseText);
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
						var id = "'id'";
						var leaderList = '${leaderList}';
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
						var str = ' <input type="text" '+cl+' class="input-100per '+handCursor+'" name="'+json[i].inputName + '" id="'+json[i].inputName + '"'+
						' maxSize="'+length+'" deaultValue="'+json[i].inputContent+'" validate="maxLength" '+
						' value="'+subV+'" inputName="'+json[i].name + '" '+ isreadonly +
						' onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)" />';

						
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

function changeMtType(obj){
	var mtTypeId;
	for(i=0;i<obj.options.length;i++){
		if(obj.options[i].selected){
			mtTypeId = obj.options[i].value;
			break;
		}
	}

	var url = "mtAppMeetingController.do?method=getMtTypeContents&id=${bean.id}&meetingType=app&mtTypeId="+mtTypeId+"&date="+new Date();

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

function firstMtTypeContentLoad(){
	changeMtType(document.getElementById("meetingTypeId"));
}

--></script>

<div class="newDiv" style="${(param.associatMeet!=null)&&((param.associatMeet=='associat'))?'border:solid 1px #A4A4A4':''}">
<form id="dataForm" name="dataForm" action="mtAppMeetingController.do" method="post">
<input type="hidden" name="addApprove" value="${param.addApprove }" />
<input type="hidden" name="saveStatus" />
<input type="hidden" id="userId" name="userId" value="${v3x:currentUser().id}" />
<input type="hidden" id="meetingId" name="meetingId" value="${meetingId}" />
<input type="hidden" name="meetingroomId" value="${meetingroomId}"/>
<input type="hidden" name="meetingroomName" value="${meetingroomName}" />
<input type="hidden" name="fromMethod" value="${fromMethod != null?fromMethod:param.method }"/>
<input type="hidden" id="method" name="method" value="save" />
<input type="hidden" id="formOper" name="formOper" value="save" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="tempId" value="${param.templateId}" />
<input type="hidden" name="project" value="${project}" />
<input type="hidden" id="isHasAtt" name="isHasAtt" value="" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<fmt:formatDate value="${nowTime}" pattern="yyyy-MM-dd HH:mm" var="nowDate"/>
<input type="hidden" name="nowDate" id="nowDate" value="${nowDate}" />
<c:set value="${v3x:parseElements(emceeList, 'id', 'entityType')}" var="emceesList"/>
<c:set value="${v3x:parseElements(recorderList, 'id', 'entityType')}" var="recordersList"/>
<c:set value="${v3x:parseElements(confereeList, 'id', 'entityType')}" var="confereesList"/>
<c:set value="${v3x:parseElements(leaderList, 'id', 'entityType')}" var="leaderList"/>

<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="conferees" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker" selectType="Account,Member,Department,Team,Post" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" minSize="0" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
<v3x:selectPeople id="approves" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${approvesList}" panels="Department,Team,Post,Outworker" selectType="Member,Department,Team,Post" jsFunction="setMtPeopleFields(elements,'approves','approvesNames')" />
<v3x:selectPeople id="leader" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${leaderList}" panels="Department,Team,Post,Outworker" selectType="Member" jsFunction="setMtPeopleFields(elements,'leader','leaderNames')" />

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable" >
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
					<tr class="bg-summary lest-shadow">
						<td width="8%" class="bg-gray"><fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" /></td>
						<td width="42%" colspan="3">
							<jsp:include page="../include/inputDefine.jsp">
								<jsp:param name="_property" value="title" />
								<jsp:param name="_key" value="mt.list.column.mt_name" />
								<jsp:param name="_validate" value="notNull,isDefaultValue,notSpecChar" />
							</jsp:include>
						</td>
						<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" /></td>
						<td width="17%">
							<input type="text" readonly="true" class="input-100per cursor-hand" name="beginDate" id="beginDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key="mt.mtMeeting.beginDate" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.beginDate}" />" />
						</td>
						<td width="8%" class="bg-gray">
							<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:
						</td>
						<td width="17%">
							<input type="text" readonly="true" class="input-100per cursor-hand" name="endDate" id="endDate" onclick="selectMeetingTime(this);" inputName="<fmt:message key='common.date.endtime.label' bundle="${v3xCommonI18N}" />" validate="notNull" value="<fmt:formatDate pattern="${datetimePattern}" value="${bean.endDate}" />" />
						</td>
					</tr>
					<tr class="bg-summary" >
						<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" /></td>
						<td width="18%" class="bg-gray">
							<fmt:message key="mt.mtMeeting.emceeId" var="_myLabel"/>
							<fmt:message key="label.please.select" var="_myLabelDefault">
								<fmt:param value="${_myLabel}" />
							</fmt:message>
			
							<input type="hidden" id="emceeId" name="emceeId" value="${bean.emceeId }"/>
							<input type="text" class="input-100per cursor-hand" id="emceeName" name="emceeName" readonly="true" 
								value="<c:out value="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
								title="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}"
								deaultValue="${_myLabelDefault}"
								onfocus="checkDefSubject(this, true)"
								onblur="checkDefSubject(this, false)"
								inputName="${_myLabel}" 
								validate="isDefaultValue"
								onclick="selectMtPeople('emcee','emceeId');"
								/>
						</td>
						
						<td width="6%" class="bg-gray"><fmt:message key="mt.mtMeeting.approve" /><fmt:message key="label.colon" /></td>
						<td width="18%">
							<fmt:message key="mt.mtMeeting.approve" var="_myLabel"/>
							<fmt:message key="label.please.select" var="_myLabelDefault">
								<fmt:param value="${_myLabel}" />
							</fmt:message>
							<c:if test="${empty bean.approvesNames }">
								<c:set value="${_myLabelDefault}" var="lvalue"/>
							</c:if>
							<c:if test="${!empty bean.approvesNames }">
								<c:set value="${bean.approvesNames}" var="lvalue"/>
							</c:if>
							
							<input type="hidden" id="approves" name="approves" value="${bean.approves}"/>
							<input type="hidden" id="oldApproves" name="oldApproves" value="${param.formOper eq 'createByTemplate' || project eq 'project' ? '' : bean.approves}"/>
							
							<input type="text" class="input-100per cursor-hand" id="approvesNames" name="approvesNames" readonly="true" 
								value="${lvalue}"
								deaultValue="${_myLabelDefault}"
								onfocus="checkDefSubject(this, true)"
								onblur="checkDefSubject(this, false)"
								<c:choose>
								<c:when test="${bean.approveState==0 || bean.approveState==40 || bean.approveState==30}"><%-- xiangfan 添加30(审核未通过可以编辑审核人，修复GOV-3710) --%>
								onclick="openLeader();"
								</c:when>
								<c:otherwise>
								disabled
								</c:otherwise>
								</c:choose>
								validate="notNull,isDefaultValue"
								inputName="${_myLabel}" 
							/>
							
						</td>
						
						
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
						<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.join" /><fmt:message key="label.colon" /></td>
						<td width="42%" colspan="3">
							<fmt:message key="mt.mtMeeting.join" var="_myLabel"/>
							<fmt:message key="label.please.select" var="_myLabelDefault">
								<fmt:param value="${_myLabel}" />
							</fmt:message>
							<input type="hidden" id="conferees" name="conferees" value=""/>
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
					</tr>
					
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
							<!-- 为了和会议通知js保持一致，不出错，因此保留以前的 -->
							<input type="hidden" id="resourcesId" name="resourcesId" value="${bean.resourcesId}" />
						</td>
					</tr>
					
					<tr>
			  			<td colspan="9" height="6" class="bg-b"></td>
			 		</tr>
				</table>
			</td>
		</tr>
		
		<c:choose>
			<c:when test="${bean.approveState!=0 && bean.approveState!=10 && bean.approveState!=null}">
				<tr>
					<td>
						<v3x:editor content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" originalNeedClone="${originalBodyNeedClone}" htmlId="content"/>
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

</form>
</div>
<c:if test="${bean.isEdit!=null && bean.isEdit!='' && !bean.isEdit && bean.approveState!=10 }">
<script type="text/javascript">
	document.getElementById('dataForm').disable();
</script>
</c:if>
<iframe name="hiddenIframe" width="0" height="0"></iframe>
<jsp:include page="../include/deal_exception.jsp" />

<script>
firstMtTypeContentLoad();
previewFrame('Down');
</script>
</body>
</html> 

