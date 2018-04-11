<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<%@ include file="../migrate/INC/noCache.jsp" %>
<title></title>
<%@ include file="headerbyopen.jsp" %>
<script type="text/javascript">

showCtpLocation("F09_meetingRoom");
		
function setBulDepartFields(elements){
	if(elements.length > 0){
		document.getElementById("departmentId").value = elements[0].id;
		document.getElementById("departmentName").value = elements[0].name;
	}
}
function startDateTime(obj){
	var dstart = new Date(obj.value.replace(/-/g,"/"));
	var dend = new Date();
	if(dstart < dend){
		writeValidateInfo(obj, obj.getAttribute("inputName") + "<fmt:message key='mr.alert.cannotbeforenow'/>");
		return false;
	}else{
		return true;
	}
}
		
function endDatetime(obj){
	var startDatetime = document.getElementById("startDatetime")
	var dstart = new Date(startDatetime.value.replace(/-/g,"/"));
	var dend = new Date(obj.value.replace(/-/g,"/"));
	if(dstart >= dend){
		writeValidateInfo(obj, obj.getAttribute("inputName") + "<fmt:message key='mr.alert.cannotbefore'/>" + startDatetime.getAttribute("inputName"));
		return false;
	}else{
		return true;
	}
}
function textAreaMaxLength(obj){
	if(obj.value.length > Number(obj.maxLength)){
		writeValidateInfo(obj, obj.inputName + "<fmt:message key='mr.alert.lengthcannotmorethan'/>" + obj.maxLength);
		return false;
	}else{
		return true;
	}
}
function initCreate(){
	if("${user.id}" == "${bean.v3xOrgMember.id}"){
		document.getElementById("perName").disabled = false;
	}
}
function setBulPeopleFields(elements){
	if(elements.length > 0){
		var element = elements[0];
		document.getElementById("perId").value=element.id;
		document.getElementById("perName").value=element.name;
	}
}
function submitForm(){
	document.forms[0].submit();
	parent.listFrame.location.reload();
}

window.onload = function() {
	previewFrame('Down');
}

//添加,选择会议室弹出图形化选择界面
function showMTRoom() {
    //后端已经做了判断，此处不需要做重复的判断
	//var requestCaller = new XMLHttpRequestCaller(this, "ajaxMeetingRoomManager", "checkHasMeetingRoom", false);
	//var ds = requestCaller.serviceRequest();
	//if(ds == 'false') {
	//	alert("<fmt:message key='mr.alert.addroom'/>!");
	//	return;
	//}
	//用来记录是添加还是修改的标记(如果是添加则不能拖动任何的时间段,如果是修改,再去判断拖动的是否是当前的会议,如果是则可拖动,否则不难拖动)
	var action="${action}";
	//修改的时候取得会议的ID用来判断只许修改当前ID的会议
	var meetingId="${meetingId}";
	var w = 1177;
	var h1 = 500;//半个窗口高
	var h2 = 700;//整个窗口高
    var l = (screen.width - w)/2; 
    var t = (screen.height - h2)/2;
	var meetingroomId=document.getElementById("roomId").value;
	var startDate=document.getElementById("startDate").value;
	var endDate=document.getElementById("endDate").value;
	var oldRoomAppId=document.getElementById("oldRoomAppId").value;
	var returnMr=meetingroomId+","+startDate+","+endDate+","+oldRoomAppId;
    var url = "meetingroom.do?method=mtroom&returnMr="+returnMr+"&action="+action+"&meetingId="+meetingId+"&needApp=-1&date="+new Date().getTime();

    openMeetingDialog(url, "<fmt:message key='mr.label.mrApplication'/>", 1177, window.top.document.body.clientHeight-60, function(retObj) {
		showMTRoomCallback(retObj);
	});
}
function showMTRoomCallback(retObj) {
	if(retObj!=null && ""!=retObj) {
        var strs = retObj.split(",");
        if(strs.length > 0) {
        	document.getElementById("roomId").value=strs[0];
			document.getElementById("startDate").value=strs[3];
			document.getElementById("endDate").value=strs[4];
			document.getElementById("startDatetime").value=strs[3];
			document.getElementById("endDatetime").value=strs[4];
			document.getElementById("oldRoomAppId").value=strs[5];
			document.getElementById("roomName").value=strs[1];
			document.getElementById("id").value=strs[0];
		}
	}
}

function cleanMt(){
	document.getElementById("roomId").value="";
	document.getElementById("startDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("oldRoomAppId").value="";
}

function init(){
	if(parent.document.getElementById("sx")!=null) {
		parent.document.getElementById("sx").rows = "100%,0";
	}
}

function leave(){
	if(parent.document.getElementById("sx")!=null) {
		parent.document.getElementById("sx").rows = "98%,2%";
	}
}
var appDoSubmiting = false;
function appDoSubmit() {
    if(appDoSubmiting) {
        return;   
    }
    appDoSubmiting = true;
    var mtId = document.getElementById("id").value;
    if(mtId == "") {
        alert(_("officeLang.meetingRoom_not_null"));
        appDoSubmiting = false;
        return;
    }
	if(checkForm(document.getElementById("myForm"))) {
		document.getElementById("myForm").action = "meetingroom.do?method=execApp";
		document.getElementById("myForm").submit();	
	}
	appDoSubmiting = false;
}
function _submitCallback(msg) {
	appDoSubmiting = false;
	if(msg != "") {
		alert(msg);
	}
	parent.location.reload();
}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>

<style type="text/css">
td {
    height: 24px;
}
input {
    height: 22px;
}
.main_div_row3 {
 	width: 100%;
 	height: 100%;
 	_padding-left:0px;
}
.right_div_row3 {
 	width: 100%;
 	height: 100%;
 	_padding:23px 0px 30px 0px;
}
.main_div_row3>.right_div_row3 {
 	width:auto;
 	position:absolute;
 	left:0px;
 	right:0px;
}
.center_div_row3 {
 	width: 100%;
 	height: 100%;
 	overflow:auto;
}
.right_div_row3>.center_div_row3 {
 	height:auto;
 	position:absolute;
 	top:23px;
 	bottom:35px;
}
.top_div_row3 {
 	height:35px;
 	width:100%;
 	position:absolute;
 	top:0px;
}
.bottom_div_row3 {
 	height:35px;
 	width:100%;
 	position:absolute;
 	bottom:0px;
 	_bottom:-1px; /*-- for IE6.0 --*/
}
.button-default-2:hover {
 	background: #62c4ef;
 	border: 1px solid #42b3e5;
}
        
</style>
</head>

<body scroll='no' bgcolor="#4D4D4D"  onload="init()" onunload="leave()">

<v3x:selectPeople id="per" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="1" maxSize="1" originalElements="${v3x:parseElementsOfIds(user.id,'Member')}"/>
<v3x:selectPeople id="dep" panels="Department" selectType="Department" jsFunction="setBulDepartFields(elements);" minSize="1" maxSize="1" originalElements="${v3x:parseElementsOfIds(v3xOrgDepartment.id,'Department')}" />

<form name="myForm" id="myForm" action="meetingroom.do?method=execApp" method="post" target="hiddenIframe" class="h100b">
<input type="hidden" name="id" id="id" value="${bean.id }" />
<input type="hidden" name="meetingId" id="meetingId" value="" />
<input type="hidden" name="sendType" id="sendType" value="" />
<input type="hidden" name="appType" id="appType" value="RoomApp" />
<input type="hidden" name="startDatetime" id="startDatetime" value=""/>
<input type="hidden" name="endDatetime" id="endDatetime" value=""/>
<input type="hidden" name="roomId" id="roomId"/>
<input type="hidden" name="oldRoomAppId" id="oldRoomAppId"/>

<div class="main_div_row3">

<div class="right_div_row3 w100b">
   
<div class="center_div_row3 detail_div_center" style="top:0px;border-top: 0px solid #b6b6b6;">

<div class="h100b" style="position: absolute;width: 100%">

<div class="categorySet-body h100b" style="padding:0;border-bottom:1px solid #a0a0a0;">

<div style="position: relative;left:50%;top:0;width: 700px;margin: 0 0 0 -350px;">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="margin_t_20" >

<tr>
    <td nowrap="nowrap" class="bg-gray" style="padding:6px"><font color="red">*</font><fmt:message key='mr.label.meetingroom'/>:</td>
    <td style="width: 100%; nowrap="nowrap" class="new-column">
    <fmt:message key="label.please.selectMeetingRoom" var="selectMeetingRoom"/>
        <input type='hidden' name='id' value='' />
        <input type="text" id="roomName" name="roomName" readonly="readonly" inputName="<fmt:message key='mr.label.meetingroom'/>" validate="notNull" maxSize="80" class="input-100per" maxLength="80" value="<c:out value="${name}" default="${selectMeetingRoom}"/>" onclick="showMTRoom()" />
    </td>
</tr>
<tr>
    <td nowrap="nowrap" class="bg-gray" style="padding:6px"><font color="red">*</font><fmt:message key='mr.label.appPerson'/>:</td>
    <td nowrap="nowrap" class="new-column" >
        <input type='hidden' name='perId' value='${user.id }' />
        <input type="text" name="perName" inputName="<fmt:message key='mr.label.appPerson'/>" validate="notNull,maxLength" maxSize="80" class="input-100per" maxLength="80" value="${v3x:toHTML(user.name) }" onclick="selectPeopleFun_per()" disabled />
    </td>
</tr>
<td nowrap="nowrap" class="bg-gray" style="padding:6px"><font color="red">*</font><fmt:message key="mr.label.appDept"/>:</td>
    <td nowrap="nowrap" class="new-column"><input type="hidden" name="departmentId" value="${v3xOrgDepartment.id }" />
        <input type="text" name="departmentName" onclick="selectPeopleFun_dep()" class="input-100per" 
        inputName="<fmt:message key="mr.label.appDept"/>" deaultValue="<<fmt:message key="mr.alert.clickToSelectDept"/>>" validate="notNull,isDeaultValue" 
        value="${v3x:toHTML(v3xOrgDepartment.name)}" disabled />
    </td>
<tr>
    <td nowrap="nowrap" class="bg-gray" style="padding:6px"><font color="red">*</font><fmt:message key='mr.label.startDatetime'/>:</td>
    <td nowrap="nowrap" class="new-column">
        <input type="text" name="startDate" id="startDate" inputName="<fmt:message key='mr.label.startDatetime'/>" validate="notNull,startDateTime" maxSize="20" class="input-100per" disabled/>
    </td>
</tr>
<tr>
<td nowrap="nowrap" class="bg-gray" style="padding:6px"><font color="red">*</font><fmt:message key="mr.label.endDatetime"/>:</td>
    <td nowrap="nowrap" class="new-column">
        <input type="text" name="endDate" id="endDate" inputName="<fmt:message key="mr.label.endDatetime"/>" validate="notNull,endDatetime" maxSize="20" class="input-100per" disabled/>
    </td>
</tr>
<tr>
    <td nowrap="nowrap" class="bg-gray" style="padding:6px"><fmt:message key='mr.label.usefor'/>:</td>
    <td class="new-column" style="padding:6px">
        <textarea style="height: 60px;" id="description" name="description" inputName="<fmt:message key='mr.label.usefor'/>" validate="maxLength" maxSize="80" class="input-100per"></textarea>
    </td>
</tr>
</table>

</div>

</div><!-- categorySet-body -->

</div>
</div><!-- center_div_row3 -->

<div class="bottom_div_row3 detail_div_bottom" align="center">
	<input type="button" class="button-default-2 button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="appDoSubmit()" />&nbsp;
	<input type="button" onclick="parent.listFrame.location.reload();" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
</div>

</div><!-- right_div_row3 -->
</div><!-- main_div_row3 -->

</form>

<iframe name="hiddenIframe" style="display:none"></iframe>
<script type="text/javascript">

showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.app'/>", [1,5], -1, _("officeLang.detail_info_meetingroom_application"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
initIpadScroll("scrollListDiv",550,870);
</script>
	</body>
</html>
	