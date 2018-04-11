<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>

<c:set value="" var="startDateValue"></c:set>
<c:if test="${newVo.periodicity.startDate != null}">
<fmt:formatDate pattern="yyyy-MM-dd" value="${newVo.periodicity.startDate}" var="startDateValue" />
</c:if>

<c:set value="" var="endDateValue"></c:set>
<c:if test="${newVo.periodicity.endDate != null}">
	<fmt:formatDate pattern="yyyy-MM-dd" value="${newVo.periodicity.endDate}" var="endDateValue" />
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
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
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key='mt.repeat.cycle.setting'/></title>
<script>

var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

function _$(id){
	return document.getElementById(id);
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

$(function(){
	initHtmlData();
	initEvent();
});

function initHtmlData() {
	var periodicityType = "${newVo.periodicity.periodicityType}";
	var scope = "${newVo.periodicity.scope}";
	var startDateValue = "${startDateValue}";
	var endDateValue = "${endDateValue}";
	if(parentWindow.document.getElementById("periodicityType").value != "") {
		periodicityType = parentWindow.document.getElementById("periodicityType").value;
		scope = parentWindow.document.getElementById("periodicityScope").value;
		startDateValue = parentWindow.document.getElementById("periodicityStartDate").value;
		endDateValue = parentWindow.document.getElementById("periodicityEndDate").value;
	}
	
	if(periodicityType != ""){
		$("#periodicityType").val(periodicityType);
		changePeriodicityType();
	}
	
	if(scope != ""){
		if(periodicityType == 1) {
			$("#day_scope_sel").val(scope);
		} else if(periodicityType == 2) {
			$("#week_scope_sel").val(scope);
		} else {
			$("#month_scope_sel").val(scope);
		}
	}
	$("#beginDate").val(startDateValue);
	$("#endDate").val(endDateValue);
}

function initEvent() {
	
	document.getElementById("periodicityType").onclick = changePeriodicityType;
	
	document.getElementById("beginDate").onclick = function() {
		selectMeetingTime(this);
	};
	
	document.getElementById("endDate").onclick = function() {
		selectMeetingTime(this);
	};
	
	document.getElementById("btnOk").onclick = ok;
	
	document.getElementById("btnCancel").onclick = closeWindow;

}

function changePeriodicityType(){
	var periodicityType = $("#periodicityType").val();
	var day_scope = _$("day_scope");
	var week_scope = _$("week_scope");
	var month_scope = _$("month_scope");
	if(periodicityType == 1){
		day_scope.style.display = "";
		week_scope.style.display = "none";
		month_scope.style.display = "none";
	}else if(periodicityType == 2){
		day_scope.style.display = "none";
		week_scope.style.display = "";
		month_scope.style.display = "none";
	}else{
		day_scope.style.display = "none";
		week_scope.style.display = "none";
		month_scope.style.display = "";
	}
}

//时间
function selectMeetingTime(thisDom) {
	var evt = v3x.getEvent();
	var x = evt.clientX?evt.clientX:evt.pageX;
	var y = evt.clientX?evt.clientX:evt.pageY;
	whenstart('${pageContext.request.contextPath}', thisDom, x, y,'date');
}

function ok() {
	
	var startDate = _$("beginDate");
	var endDate = _$("endDate");
	
	if($("#beginDate").val() == ""){
		alert(meetingLang.meeting_state_time_not_null);
		return;
	}
	if($("#endDate").val() == ""){
		alert(meetingLang.meeting_end_time_not_null);
		return;
	}
	
	//当时间跨度大于1年时给出提示
	var diff = dateDiff(startDate.value,endDate.value);
	if(diff == -1) {
		alert(meetingLang.meeting_end_time_not_letter_start_time);
		return;
	}
	if(diff > 365) {
		alert(meetingLang.meeting_periodicity_times_not_more_than_one_year);
		return;
	}
	
	var scope = $("#day_scope_sel").val();
	if(periodicityType.value == 2) {
		if(dateDiff(startDate.value,endDate.value) < 7){
			alert(meetingLang.meeting_week_periodicity_times_not_letter_one_week);
			return;
		}
		scope = $("#week_scope_sel").val();
	} else if(periodicityType.value == 3) {
		
		if(dateDiff(startDate.value,endDate.value) < 62){
			var day = _$("month_scope_sel").value;
			if(!validate(startDate.value,endDate.value,day)){
				alert(v3x.getMessage("meetingLang.meeting_priodicity_notInCycle"));
				return;
			}
		}
		scope = $("#month_scope_sel").val();
	}
	
	var returnValue = [];
	var i = 0;
	returnValue[i++] = $("#periodicityType").val();
	returnValue[i++] = scope;
	returnValue[i++] = $("#beginDate").val();
	returnValue[i++] = $("#endDate").val();
	
	if(parentCallback) {
		parentCallback(returnValue);
	} else {
		parentWindow.newPeriodicityCallback(returnValue);
	}
	closeWindow();
}

function dateDiff(sDate1,sDate2) {
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

function closeWindow() {
	commonDialogClose('win123');
}

</script>
</head>
<body scroll="no" style="overflow:hidden;">

<div style="padding-top:12px; padding-left:20px; padding-right:20px;background: rgb(250,250,250);height: 117px;">

	<div style="width:55px;float:left;text-align:right;margin-left:3px;color:#333;"><fmt:message key='mt.repeat.cycle'/>:</div>
	
	<div style="width:212px;float:left; margin-left: 4px">	
		<span>
			<select style="width:63px;color:#333;" id="periodicityType">
				<c:forEach items="${newVo.meetingPeriodicityByWayNameList}" var="listVo">
					<option value="${listVo.optionId }">${listVo.optionName }</option>
				</c:forEach>
			</select>
		</span>
		
		<span id="week_scope" style="padding-left:16px;"> 
			<select id="week_scope_sel" style="width: 72px;color: #333;">
				<c:forEach items="${newVo.meetingPeriodicityWeekNameList}" var="listVo">
					<option value="${listVo.optionId }">${listVo.optionName }</option>
				</c:forEach>
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
	
	<div style="text-align: right;width:55px;float:left;margin-top:16px;color:#333;" valign="bottom">
		<fmt:message key='meeting.periodicity.scope.range'/>:
	</div>
	
	<div style="margin-top:16px;float:left;width:220px;margin-left:7px;color:#333;">
		<span><fmt:message key="mt.mtMeeting.beginDate" />:</span>
		<input type="text" name="beginDate" id="beginDate" readonly="readonly" class="cursor-hand" style="width:100px;margin-right:40px;color: #333;" inputName="${startDateValue }" validate="notNull" value="${startDateValue }"/>
				
		<span style="margin-left:2px;margin-top: 13px; display: inline-block;"><fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:</span>
		<input style="width: 98px;color: #333;" type="text" name="endDate" id="endDate" readonly="true" class="cursor-hand" inputName="${endDateValue }" validate="notNull" value="${endDateValue }" />
	</div>
</div>

<div class="dialog_main_footer bg-advance-bottom absolute align_right" >
	<input id="btnOk" type="button" class="button-default_emphasize margin_t_10" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;&nbsp;
	<input id="btnCancel" type="button" class="button-default-2 margin_r_20 margin_t_10" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
</div>

</body>
</html>