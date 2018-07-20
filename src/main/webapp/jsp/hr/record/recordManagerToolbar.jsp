<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
if("${recordDept}" == "true"){
	showCtpLocation("F03_deptRecord");
}else{
	showCtpLocation("F03_hrRecord");
}
 function workingtime() {
	parent.detailFrame.location.href = hrRecordURL+"?method=initWorkingTime";
 }
 
function exportExcel(){
	if(document.getElementById("statistic").value == 'search'){
		var advancedFromTime = document.getElementById("advancedFromTime").value;
	 	var advancedToTime = document.getElementById("advancedToTime").value;
	 	var advancedDepartmentIds = document.getElementById("advancedDepartmentIds").value;
	 	var advancedPeopleIds = document.getElementById("advancedPeopleIds").value;
		var count = parent.listFrame.document.getElementById("resultCount").value;
		if(count == 0){
	 			alert(v3x.getMessage("HRLang.hr_export_noData"));
	 			return false;
	 	}
		if(count>40){
			alert(v3x.getMessage("HRLang.attendance_record_tip"));
		}
		parent.detailFrame.location.href = "<c:url value='/m1/lbsRecordController.do'/>?method=exportExcel&recordDept=${recordDept}&advancedFromTime="+advancedFromTime+"&advancedToTime="+advancedToTime+"&advancedDepartmentIds="+advancedDepartmentIds+"&advancedPeopleIds="+advancedPeopleIds;
	}else{
		if(document.getElementById("statistic").value == 'statistic'){
			var advancedFromTime = document.getElementById("advancedFromTime").value;
	 		var advancedToTime = document.getElementById("advancedToTime").value;
	 		var advancedDepartmentIds = document.getElementById("advancedDepartmentIds").value;
	 		var advancedPeopleIds = document.getElementById("advancedPeopleIds").value;
	 		var statistic = document.getElementById("statistic").value;
	 		var count = parent.detailFrame.document.getElementById("resultCount").value;
	 		if(count == 0){
	 			alert(v3x.getMessage("HRLang.hr_export_noData"));
	 			return false;
	 		}
		}else{
			var fromTime = document.getElementById("linkFromTime").value;
	 		var toTime = document.getElementById("linkToTime").value;
	 		var staffName = document.getElementById("linkName").value;
	 		var staffId = document.getElementById("linkStaffId").value;
	 		var type = document.getElementById("linkType").value;
	 		var fTime = document.getElementById("fTime").value
	 		var tTime = document.getElementById("tTime").value;
	 		var searchAll = document.getElementById("searchAll").value;
	 		var count = parent.listFrame.document.getElementById("resultCount").value;
	 		var advancedFromTime = document.getElementById("advancedFromTime").value;
	 		var advancedToTime = document.getElementById("advancedToTime").value;
	 		var advancedDepartmentIds = document.getElementById("advancedDepartmentIds").value;
	 		var advancedPeopleIds = document.getElementById("advancedPeopleIds").value;
	 		var advancedState = document.getElementById("advancedState").value;
	 		var advanced = document.getElementById("advanced").value;
	 		var statistic = document.getElementById("statistic").value;
	 		if(count == 0){
	 			alert(v3x.getMessage("HRLang.hr_export_noData"));
	 			return false;
	 		}
	 		if(staffName == ''){staffName='noSearch'}
		}
 		parent.detailFrame.location.href = "<c:url value='/hrRecord.do'/>?method=exportExcel&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime+"&type="+type+"&staffName="+staffName+"&staffId="+staffId+"&searchAll="+searchAll+"&fTime="+fTime+"&tTime="+tTime+"&advancedFromTime="+advancedFromTime+"&advancedToTime="+advancedToTime+"&advancedDepartmentIds="+advancedDepartmentIds+"&advancedPeopleIds="+advancedPeopleIds+"&advancedState="+advancedState+"&advanced="+advanced+"&statistic="+statistic;
	}
 }

 function statistic() {
	document.getElementById("statistic").value = "";
	parent.listFrame.location = "${hrAppURL}?method=initRecordType&key=${param.type}&isShowDetail=false&recordDept=${recordDept}";
	parent.detailFrame.location.href = hrRecordURL+"?method=statisticManager&recordDept=${recordDept}";
 }
 
 function compareDate(dateStr1, dateStr2){
	var date1 = parseDate(dateStr1);
	var date2 = parseDate(dateStr2);
	
	return date1.getTime() - date2.getTime();
}
 function searchRecord(){
    var fromTime = document.getElementById("fromTime").value;
    var toTime = document.getElementById("toTime").value;
    if(fromTime==""||toTime==""){
       alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
       return false;
    }
    if(compareDate(fromTime,toTime)>0)
	{
		window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
		return false;	
	} 
    document.getElementById("fTime").value = fromTime;
    document.getElementById("tTime").value = toTime;
    document.getElementById("searchAll").value = "all";
    document.getElementById("advanced").value = "";
    document.getElementById("statistic").value = "";
 	parent.listFrame.location.href = hrRecordURL+"?method=searchAllRecord&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime;
 }
 
function advancedQuery(){
	var fromTime = document.getElementById("fromTime").value;
    var toTime = document.getElementById("toTime").value;
    if(fromTime==""||toTime==""){
       alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
       return false;
    }
    if(compareDate(fromTime,toTime)>0)
	{
		window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
		return false;	
	} 
    getA8Top().advancedQueryWin = getA8Top().$.dialog({
        title:" ",
        transParams:{'parentWin':window},
        url: hrRecordURL + "?method=advancedQuery&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime,
        width: 400,
        height: 300,
        isDrag:false
    });
 }

 function advancedSearch(){
	 var recordDept = document.getElementById("recordDept").value;
	 getA8Top().advancedSearchWin = getA8Top().$.dialog({
         title:" ",
         transParams:{'parentWin':window},
         url: m1RecordURL + "?method=index&recordDept="+recordDept,
         width: 400,
         height: 300,
         isDrag:false
     });
 }
 
function attendanceStat(){
	document.getElementById("statistic").value = "statistic";
	var fromTime = document.getElementById("fromTime").value;
    var toTime = document.getElementById("toTime").value;
	window.parent.listFrame.location = "${hrRecordURL}?method=attendanceStatic&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime;
	parent.detailFrame.location.href = "${hrRecordURL}?method=attendanceStatistic&recordDept=${recordDept}&fromTime=&toTime=&departmentId=&staffId=nobody";
}
 
function deleteAttendance(){
	var showWindow = "hr/record/deleteAttendance";
	document.getElementById("statistic").value = "";
	getA8Top().deleteAttendanceWin = getA8Top().$.dialog({
        title:" ",
        transParams:{'parentWin':window},
        url: hrRecordURL + "?method=showWindow&recordDept=${recordDept}&showWindowURL=" + showWindow,
        width: 400,
        height: 280,
        isDrag:false
    });
}
</script>
<body topmargin="0" leftmargin="0">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td height="22" width="60%" class="webfx-menu-bar">
    <script>	
	//def toolbar
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	//add buttons
	myBar1.add(new WebFXMenuButton("statistic", "<fmt:message key='hr.toolbar.salaryinfo.statisticStaff.label' bundle='${v3xHRI18N}' />","statistic()" , [6,9]));
	myBar1.add(new WebFXMenuButton("attendanceStat", "<fmt:message key='hr.record.attendance.statistic.label' bundle='${v3xHRI18N}' />", "attendanceStat()" ,[1,2]));
	<c:if test="${v3x:hasPlugin('lbs')}">
		myBar1.add(new WebFXMenuButton("search", "<fmt:message key='m1.lbs.attendance.record.search' bundle='${v3xHRI18N}' />",  "advancedSearch()" , [7,2], "", null));	
	</c:if>
	myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "deleteAttendance()", [1,3]));
	myBar1.add(new WebFXMenuButton("query", "<fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' />",  "advancedQuery()" , [7,2], "", null));
	myBar1.add(new WebFXMenuButton("export", "<fmt:message key='hr.toolbar.salaryinfo.export.label' bundle='${v3xHRI18N}' />", "exportExcel()", [2,8]));
	
	document.write(myBar1);
	document.close();
	</script>   
	</td>
	<td class="webfx-menu-bar">
		<div class="div-float-right" >
			<div id="subjectDiv" class="div-float">
				<fmt:message key='hr.userDefined.type.date.label' bundle='${v3xHRI18N}' />:&nbsp;&nbsp;&nbsp;
			</div>
			<div id="subjectDiv" class="div-float">			
				<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,775,150)" readonly
           		value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
           	</div>
			<div id="subjectDiv" class="div-float">&nbsp;&nbsp;-&nbsp;
				<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,1075,150)" readonly
           		value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
			</div>
			<div onclick="javascript:searchRecord()" class="condition-search-button"></div>
		</div>
	</td>
  </tr>
</table>
	<form name="exportForm" action="" method="post">
		<input type="hidden" name="linkFromTime" id="linkFromTime" value="" />
        	<input type="hidden" name="linkToTime" id="linkToTime" value="" />
        	<input type="hidden" name="linkName" id="linkName" value="" />
			<input type="hidden" name="linkStaffId" id="linkStaffId" value="" />
			<input type="hidden" name="linkType" id="linkType" value="" />
			<input type="hidden" name="fTime" id="fTime" value="" />
			<input type="hidden" name="tTime" id="tTime" value="" />
			<input type="hidden" name="searchAll" id="searchAll" value="" />
			<input type="hidden" id="advancedFromTime" value="" />
			<input type="hidden" id="advancedToTime" value="" />
			<input type="hidden" id="advancedDepartmentIds" value="" />
			<input type="hidden" id="advancedPeopleIds" value="" />
			<input type="hidden" id="advancedState" value="" />
			<input type="hidden" id="advanced" value="" />
			<input type="hidden" id="statistic" value="" />
		<input type="hidden" value="${records }" />
		<input type="hidden" value="${staffName }" />
		<input type="hidden" name="recordDept" id="recordDept" value="${recordDept}">
	</form>
</body>	