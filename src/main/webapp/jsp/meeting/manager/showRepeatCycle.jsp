<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
	.dialog_main_footer {
		height: 35px;
	}
	.padding_t_5 {
		padding-top:7px;
	}
	.margin_r_10 {
		margin-top:10px;
	}
	.absolute{
		position:absolute;
		bottom:0;
		width:100%;
	}

</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key='mt.repeat.cycle.setting'/></title>
<script>
//时间
function selectMeetingTime(thisDom) {
	var evt = v3x.getEvent();
	var x = evt.clientX?evt.clientX:evt.pageX;
	var y = evt.clientX?evt.clientX:evt.pageY;
	whenstart('${pageContext.request.contextPath}', thisDom, x, y,'date');
}

function _$(id){
	return document.getElementById(id);
}

function changeRepeatCycle(sel){
	var day_scope = _$("day_scope");
	var week_scope = _$("week_scope");
	var month_scope = _$("month_scope");
	
	if(sel.value == 1){
		day_scope.style.display = "";
		week_scope.style.display = "none";
		month_scope.style.display = "none";
	}else if(sel.value == 2){
		day_scope.style.display = "none";
		week_scope.style.display = "";
		month_scope.style.display = "none";
	}else{
		day_scope.style.display = "none";
		week_scope.style.display = "none";
		month_scope.style.display = "";
	}
}


function dateDiff(sDate1,sDate2){ 
    
    var arrDate = null;
    var objDate1 = null;
    var objDate2 = null;
    var intDays = null;
    
    arrDate = sDate1.split("-");
    objDate1 = Date.parse(arrDate[1]+'/'+arrDate[2]+'/'+arrDate[0]);

    arrDate = sDate2.split("-");
    objDate2 = Date.parse(arrDate[1] + '/'+arrDate[2]+'/'+arrDate[0]);
	if(objDate1 > objDate2){
		return -1;
	}
    intDays = parseInt(Math.abs((objDate1 - objDate2) / (1000*60*60*24)));
    return intDays;
}

function addDate(dd,n){  
	var a = new Date(dd);
	a = a.valueOf(); 
	a = a + n * 24 * 60 * 60 * 1000;
	a = new Date(a);
	return a.format("yyyy-MM-dd");  
}  

function validate(start,end,day){
	var cur = start;
	var curDay = cur.substr(8);
	if(day<10){
		day = "0"+day;
	}else{
		day = ""+day;
	}
	
	while(dateDiff(cur,end)>-1){
		if(curDay != day){
			cur = addDate(cur,1);
			curDay = cur.substr(8);
		}else{
			return true;
		}
	}
	return false;
}

function ok(){
	var p = null;
	if(typeof(transParams)!="undefined"){
		p = transParams.parentWin;
	}else{
		p = dialogArguments;
	}
	var startDate = _$("beginDate");
	var endDate = _$("endDate");
	
	if(startDate.value == ""){
		alert(meetingLang.meeting_state_time_not_null);
		return;
	}
	if(endDate.value == ""){
		alert(meetingLang.meeting_end_time_not_null);
		return;
	}
	
	//当时间跨度大于1年时给出提示
	var diff = dateDiff(startDate.value,endDate.value);
	if(diff == -1){
		alert(meetingLang.meeting_end_time_not_letter_start_time);
		return;
	}
	if(diff > 365){
		alert(meetingLang.meeting_periodicity_times_not_more_than_one_year);
		return;
	}
	
	var periodicityType = _$("periodicityType");
	p.document.getElementById("periodicityType").value = periodicityType.value;
	if(periodicityType.value == 1){
		p.document.getElementById("scope").value=_$("day_scope_sel").value;
	}	
	else if(periodicityType.value == 2){
		if(dateDiff(startDate.value,endDate.value) < 7){
			alert(meetingLang.meeting_week_periodicity_times_not_letter_one_week);
			return;
		}
		p.document.getElementById("scope").value=_$("week_scope_sel").value;
	}else{
		if(dateDiff(startDate.value,endDate.value) < 62){
			var day = _$("month_scope_sel").value;
			if(!validate(startDate.value,endDate.value,day)){
				alert("重复周期不在所选的时间范围内，请重新选择!");
				return;
			}
		}
		p.document.getElementById("scope").value=_$("month_scope_sel").value;
	}
	p.document.getElementById("periodicityStartDate").value = startDate.value;
	p.document.getElementById("periodicityEndDate").value = endDate.value;

	var requestCaller = new XMLHttpRequestCaller(this, "mtPeriodicityInfoManager", "getAllMeetingTimesInPer",false);
	var i=1;
	requestCaller.addParameter(i++, "String", periodicityType.value);  
    requestCaller.addParameter(i++, "String", p.document.getElementById("scope").value);  
    requestCaller.addParameter(i++, "String", startDate.value);  
    requestCaller.addParameter(i++, "String", endDate.value);  
    requestCaller.addParameter(i++, "String", "${periodicityInfoId}");
    var ds = requestCaller.serviceRequest();
    p.document.getElementById("periodicityDates").value = ds;
    commonDialogClose('win123');
}
function init(){
	var p = null;
	if(typeof(transParams)!="undefined"){
		p = transParams.parentWin;
	}else{
		p = dialogArguments;
	}
	
	var ptValue = p.document.getElementById("periodicityType").value;
	if(ptValue != ""){
		_$("periodicityType").value = ptValue;
		changeRepeatCycle(_$("periodicityType"));
	}

	var scopeValue = p.document.getElementById("scope").value;
	if(scopeValue != ""){
		if(ptValue == 1){
			_$("day_scope_sel").value = scopeValue;
		}
		else if(ptValue == 2){
			_$("week_scope_sel").value = scopeValue;
		}else{
			_$("month_scope_sel").value = scopeValue;
		}
	}else{
		_$("week_scope_sel").value = "${dayOfWeek}";
	}
	var parentStartDate = p.document.getElementById("periodicityStartDate").value;
	if(parentStartDate != "" && parentStartDate.length>10){
		_$("beginDate").value = parentStartDate.substr(0,10);
	}else if(parentStartDate == ""){
		_$("beginDate").value = "${periodicityCurrentStartDate}";
	}else{
		_$("beginDate").value = parentStartDate;
	}

	var parentEndDate = p.document.getElementById("periodicityEndDate").value;
	if(parentEndDate != "" && parentEndDate.length>10){
		_$("endDate").value = parentEndDate.substr(0,10);
	}else if(parentEndDate == ""){
		_$("endDate").value = "${periodicityCurrentEndDate}";
	}else{
		_$("endDate").value = parentEndDate;
	}
	
	
}

</script>
</head>
<body onload="init();" scroll="no" style="overflow:hidden;">
<div style="padding-top:12px; padding-left:26px; padding-right:26px; ">
	<div><fmt:message key='mt.repeat.cycle'/>:</div>
	<div style="margin-top:6px;">	
		<span>
			<select id="periodicityType" onchange="changeRepeatCycle(this);">
				<option value="2"><fmt:message key='calendar.event.create.periodical.tip2'/></option>
				<option value="1"><fmt:message key='calendar.event.create.periodical.tip1'/></option>
				<option value="3"><fmt:message key='calendar.event.create.periodical.tip3'/></option>
			</select>
		</span>
		<span id="week_scope" style="padding-left:16px;"> 
			<select id="week_scope_sel">
				<option value="1"><fmt:message key='mr.label.1' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="2"><fmt:message key='mr.label.2' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="3"><fmt:message key='mr.label.3' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="4"><fmt:message key='mr.label.4' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="5"><fmt:message key='mr.label.5' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="6"><fmt:message key='mr.label.6' bundle='${v3xMeetingRoomI18N }'/></option>
				<option value="7"><fmt:message key='mr.label.7' bundle='${v3xMeetingRoomI18N }'/></option>
			</select>
		</span>
		<span id="day_scope" style="display:none;padding-left:16px;">
			<fmt:message key='mt.every.other'/>
			<select id="day_scope_sel">
				<c:forEach begin="1" end="30" varStatus="status">
				<option value="${status.index }">${status.index }</option>
				</c:forEach>
			</select>
			<fmt:message key='mt.day'/>
		</span>
		
		<span id="month_scope"  style="display:none;padding-left:16px;">
			<fmt:message key='mt.every.month'/>
			<select id="month_scope_sel">
				<c:forEach begin="1" end="31" varStatus="status">
				<option value="${status.index }">${status.index }</option>
				</c:forEach>
			</select>
			<fmt:message key='mt.day'/>
		</span>
	</div>
	<div style="margin-top:16px;" valign="bottom">
		<fmt:message key='calendar.event.create.periodicalStyle'/>:
	</div>
	<div style="margin-top:6px;">
		<span><fmt:message key="mt.mtMeeting.beginDate" />:</span>
				<input type="text" name="beginDate" id="beginDate" readonly="readonly" class=" cursor-hand" style="width:100px;" onclick="selectMeetingTime(this);" inputName="${beginDateLabel }" validate="notNull" value="2014-04-10" />
				
		<span style="margin-left:2px;"><fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:</span>
		<input type="text" name="endDate" id="endDate" readonly="true" class="cursor-hand" style="width:98px;" onclick="selectMeetingTime(this);" inputName="${endDateLabel }" validate="notNull" value="2014-04-18" />
	</div>
</div>

<div class="dialog_main_footer bg-advance-bottom padding_t_5  absolute align_right" >
		<input type="button" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="ok();"/>&nbsp;&nbsp;
		<input type="button" class="button-default-2 margin_r_5" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" onclick="commonDialogClose('win123');"/>
</div>

</body>
</html>