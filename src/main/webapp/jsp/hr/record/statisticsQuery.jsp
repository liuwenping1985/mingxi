<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var onlyLoginAccount_dep = true;
var onlyLoginAccount_peo = true;
	function query(){
	    var fromTime = document.getElementById("fromTime").value;
	    var toTime = document.getElementById("toTime").value;
	    var departmentId = document.getElementById("departmentId").value;
	    var peopleId = document.getElementById("peopleId").value;
	   	if(fromTime != '' && toTime != '' && compareDate(fromTime,toTime)>0){
			window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
			return false;	
		}
	   	if(document.getElementById("timeScope2").checked == true && (fromTime == '' || toTime == '')){
	   		window.alert("<fmt:message key='hr.record.fromtime.totime.alert' bundle='${v3xHRI18N}' />");
			return false;	
	   	}
	   	if(document.getElementById("scope2").checked == true && departmentId == ''){
	   		window.alert("<fmt:message key='hr.record.special.dept.alert' bundle='${v3xHRI18N}' />");
			return false;	
	   	}
	   	if(document.getElementById("scope3").checked == true && peopleId == ''){
	   		window.alert("<fmt:message key='hr.record.special.person.alert' bundle='${v3xHRI18N}' />");
			return false;	
	   	}
	   	if(fromTime != null && fromTime != "" && toTime != null && toTime != ""){
	   		parent.toolbarFrame.document.getElementById("fromTime").value = fromTime;
		  	parent.toolbarFrame.document.getElementById("toTime").value = toTime;
	   	}else{
	   		parent.toolbarFrame.document.getElementById("fromTime").value = "${fromTime}";
		  	parent.toolbarFrame.document.getElementById("toTime").value = "${toTime}";
	   	}
	   	parent.toolbarFrame.document.getElementById("advancedFromTime").value = fromTime;
	   	parent.toolbarFrame.document.getElementById("advancedToTime").value = toTime;
	   	parent.toolbarFrame.document.getElementById("advancedDepartmentIds").value = departmentId;
	   	parent.toolbarFrame.document.getElementById("advancedPeopleIds").value = peopleId;
	   	parent.toolbarFrame.document.getElementById("statistic").value = "statistic";
	   	
		window.parent.detailFrame.location.href = "${hrRecordURL}?method=attendanceStatistic&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime+"&departmentId="+departmentId+"&staffId="+peopleId;
	}
	function compareDate(dateStr1, dateStr2){
		var date1 = parseDate(dateStr1);
		var date2 = parseDate(dateStr2);
		
		return date1.getTime() - date2.getTime();
	}	
	function setDepartment(elements){
		if(!elements){
			return;
		}
		document.getElementById("department").value = getNamesString(elements);
    	document.getElementById("departmentId").value = getIdsString(elements,false);
	}
	function setPeople(elements){
		if(!elements){
			return;
		}
		document.getElementById("people").value = getNamesString(elements);
    	document.getElementById("peopleId").value = getIdsString(elements,false);
	}
	function changeType(){
		document.getElementById("scope1").checked = true;
		document.getElementById("scope2").checked = false;
		document.getElementById("scope3").checked = false;
		document.getElementById("department").value = "";
    	document.getElementById("departmentId").value = "";
    	document.getElementById("people").value = "";
    	document.getElementById("peopleId").value = "";
		document.getElementById("department").disabled = "disabled";
		document.getElementById("people").disabled = "disabled";
	}
	function changeType1(){
		document.getElementById("scope1").checked = false;
		document.getElementById("scope2").checked = true;
		document.getElementById("scope3").checked = false;
		document.getElementById("department").disabled = "";
		document.getElementById("people").value = "";
    	document.getElementById("peopleId").value = "";
		document.getElementById("people").disabled = "disabled";
	}
	function changeType2(){
		document.getElementById("scope1").checked = false;
		document.getElementById("scope2").checked = false;
		document.getElementById("scope3").checked = true;
		document.getElementById("people").disabled = "";
		document.getElementById("department").value = "";
    	document.getElementById("departmentId").value = "";
		document.getElementById("department").disabled = "disabled";
	}
	function changeType3(){
		document.getElementById("timeScope1").checked = false;
		document.getElementById("timeScope2").checked = true;
		document.getElementById("fromTime").disabled = "";
		document.getElementById("toTime").disabled = "";
	}
	function change(){
		document.getElementById("timeScope1").checked = true;
		document.getElementById("timeScope2").checked = false;
		document.getElementById("fromTime").value = "";
		document.getElementById("toTime").value = "";
		document.getElementById("fromTime").disabled = "disabled";
		document.getElementById("toTime").disabled = "disabled";
	}
	showConcurrentMember_peo = false;
</script>
<title><fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' /></title>
</head>
<body scroll="no" style="overflow: no">
<c:choose>
<c:when test="${recordDept=='true' && v3x:isRole('DepAdmin', v3x:currentUser())}">
	<script type="text/javascript">
		<!--
			var includeElements_dep = "${v3x:parseElementsOfTypeAndId(deptlist)}";
			var includeElements_peo = "${v3x:parseElementsOfTypeAndId(deptlist)}";
			var showDepartmentsOfTree_dep = '${scope_deptId}';
			var showDepartmentsOfTree_peo = '${scope_deptId}';
			var hiddenOtherMemberOfTeam_dep = true;
			var hiddenOtherMemberOfTeam_peo = true;
			
		//-->
	</script>
		<v3x:selectPeople id="peo" panels="Department" selectType="Member" maxSize="1" jsFunction="setPeople(elements)" />
</c:when>
<c:otherwise>
	<v3x:selectPeople id="peo" panels="Department,Post" selectType="Member" maxSize="1" jsFunction="setPeople(elements)" />
</c:otherwise>
</c:choose>
<v3x:selectPeople id="dep" panels="Department" selectType="Department" maxSize="1" jsFunction="setDepartment(elements)" />
<fieldset style="padding:10px 10px 10px 10px; margin:10px;height:90px;">
<legend><b><fmt:message key='hr.record.attendance.statistic.label' bundle='${v3xHRI18N}' /></b></legend>
<table width="100%" align="center" border="0" height="100%"  cellspacing="0" cellpadding="0">
 <tr>
	<td>
		<form name="advancedForm" action="" method="post">
			<input type="hidden" name="departmentId" id="departmentId" value="">
			<input type="hidden" name="peopleId" id="peopleId" value="">
			
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:50"><fmt:message key='hr.record.statistic.object.label' bundle='${v3xHRI18N}' /></label>:&nbsp;&nbsp;
			
			<label for="scope1"><input type="radio" id="scope1" name="scope" value="1" checked onclick="changeType()" /><fmt:message key='hr.record.statistic.all.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			<label for="scope2"><input type="radio" id="scope2" name="scope" value="2" onclick="changeType1()"/><fmt:message key='hr.staffInfo.department.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			<input type="text" size="10" name="department" id="department" value="" onClick="selectPeopleFun_dep()" disabled="disabled" readonly="readonly" class="cursor-hand"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<label for="scope3"><input type="radio" id="scope3" name="scope" value="3" onclick="changeType2()"/><fmt:message key='hr.staffInfo.name.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			<input type="text" size="10" name="people" id="people" value="" onClick="selectPeopleFun_peo()" disabled="disabled" readonly="readonly" class="cursor-hand"/><p/>
			
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:50"><fmt:message key='hr.record.statistic.time.label' bundle='${v3xHRI18N}' /></label>:&nbsp;&nbsp;
			
			<label for="timeScope1"><input type="radio" id="timeScope1" name="timeScope" value="4" checked onclick="change()" /><fmt:message key='hr.record.statistic.month.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			<label for="timeScope2"><input type="radio" id="timeScope2" name="timeScope" value="5" onclick="changeType3()"/><fmt:message key='hr.record.statistic.designation.time.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			<input type="text"  style="cursor:hand"
         	validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,400,400)" readonly disabled="disabled"
         	value="">
			－<input type="text"  style="cursor:hand"
           	validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,400,400)" readonly disabled="disabled"
           	value="">&nbsp;&nbsp;
           	<input type="button" onClick="query()" value="<fmt:message key='hr.record.statistic.label' bundle='${v3xHRI18N}' />" class="button-default-2">
           	<p/>
		</form>
    </td>
 </tr>
</table>
</fieldset>
</body>
</html>