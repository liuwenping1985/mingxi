<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=mLbsRecordManager"></script>
<script type="text/javascript">
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "${v3x:getLanguage(pageContext.request)}");
var m1RecordURL = "<html:link renderURL='/m1/lbsRecordController.do' />";
var dialog;
function query(){
	    var fromTime = document.getElementById("fromTime").value;
	    var toTime = document.getElementById("toTime").value;
	   	if(fromTime != '' && toTime != '' && compareDate(fromTime,toTime)>0)
		{
			window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
			return false;	
		}	    
	    
	    var departmentId = document.getElementById("departmentId").value;
	    var peopleId = document.getElementById("peopleId").value;
	    var parent =  transParams.parentWin;
		var recordDept = "false";
		recordDept = document.getElementById("recordDept").value;
	    parent.document.getElementById("advancedFromTime").value = fromTime;
	    parent.document.getElementById("advancedToTime").value = toTime;
	    parent.document.getElementById("advancedDepartmentIds").value = departmentId;
	    parent.document.getElementById("advancedPeopleIds").value = peopleId;
	    parent.document.getElementById("statistic").value = 'search';
	    parent.parent.listFrame.location.href = m1RecordURL +"?method=indexSearchList&fromTime="+fromTime+"&toTime="+toTime+"&departmentId="+departmentId+"&recordDept="+recordDept+"&peopleId="+peopleId;
	    getA8Top().advancedSearchWin.close();
	}
	function compareDate(dateStr1, dateStr2){
		var date1 = parseDate(dateStr1);
		var date2 = parseDate(dateStr2);
		
		return date1.getTime() - date2.getTime();
	}
	

	//时间
	function selectMeetingTime(thisDom) {
		var evt = v3x.getEvent();
		var x = evt.clientX?evt.clientX:evt.pageX;
		var y = evt.clientX?evt.clientX:evt.pageY;
		whenstart('/seeyon', thisDom, x, y,'datetime');
	}  
</script>
<html:link renderURL="/lbsRecordController.do" var="m1RecordURL" />