<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var onlyLoginAccount_dep = true;
var onlyLoginAccount_peo = true;
var isConfirmExcludeSubDepartment_dep = true;

  function inputchange(whoClick){
	whoClick.title=whoClick.value;
    }
	function query(){
	    var fromTime = document.getElementById("fromTime").value;
	    var toTime = document.getElementById("toTime").value;
	    if(fromTime==""||toTime==""){
	        alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
	        return false;
	    }
	   	if(fromTime != '' && toTime != '' && compareDate(fromTime,toTime)>0)
		{
			window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
			return false;	
		}	    
	    
	    var departmentId = document.getElementById("departmentId").value;
	    var peopleId = document.getElementById("peopleId").value;
	    var state = document.getElementById("state").value;
	    var parent = transParams.parentWin;
	    parent.document.getElementById("advancedFromTime").value = fromTime;
	    parent.document.getElementById("advancedToTime").value = toTime;
	    parent.document.getElementById("advancedDepartmentIds").value = departmentId;
	    parent.document.getElementById("advancedPeopleIds").value = peopleId;
	    parent.document.getElementById("advancedState").value = state;
	    parent.document.getElementById("advanced").value = "advanced";
	    parent.document.getElementById("statistic").value = "";
	    parent.document.getElementById("fromTime").value = fromTime;
	    parent.document.getElementById("toTime").value = toTime;
	    parent.parent.detailFrame.location.src = "<c:url value="/common/detail.jsp" />";
	    parent.parent.listFrame.location.href = "${hrRecordURL}?method=recordQuery&recordDept=${recordDept}&fromTime="+fromTime+"&toTime="+toTime+"&departmentId="+departmentId+"&peopleId="+peopleId+"&state="+state;
	    getA8Top().advancedQueryWin.close();
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

	showConcurrentMember_peo = false;
</script>
<title><fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' /></title>
</head>
<body scroll="yes" style="">
<c:choose>
<c:when test="${recordDept=='true' && v3x:isRole('DepAdmin', v3x:currentUser())}">
	<script type="text/javascript">
		<!--
			var includeElements_dep = "${v3x:parseElementsOfTypeAndId(deptlist)}";
			var includeElements_peo = "${v3x:parseElementsOfTypeAndId(deptlist)}";
			var showDepartmentsOfTree_dep = '${scope_deptId}';
			var showDepartmentsOfTree_peo = '${scope_deptId}';
		//-->
	</script>
		<v3x:selectPeople id="peo" panels="Department" selectType="Member" jsFunction="setPeople(elements)" />
</c:when>
<c:otherwise>
	<v3x:selectPeople id="peo" panels="Department,Post" selectType="Member" jsFunction="setPeople(elements)" />
</c:otherwise>
</c:choose>
<v3x:selectPeople id="dep" panels="Department" selectType="Department" jsFunction="setDepartment(elements)" />
<table class="popupTitleRight" width="100%" align="center" border="0" height="100%"  cellspacing="0" cellpadding="0">
 <tr>
	<td height="20" class="PopupTitle"><fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' /></td>
 </tr>
 <tr>
	<td class="bg-advance-middel">
		<form name="advancedForm" action="" method="post">
			<input type="hidden" name="departmentId" id="departmentId" value="">
			<input type="hidden" name="peopleId" id="peopleId" value="">
			<table border="0" width="100%" height="98%" align="center">
			<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:50"><fmt:message key='hr.record.time.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
         	validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,400,400)" readonly
         	value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
			－<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           	validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,400,400)" readonly
           	value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
           	</td>
           	</tr>
           	<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:50"><fmt:message key='hr.staffInfo.department.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" size="30"  name="department" id="department" value="" onClick="selectPeopleFun_dep();inputchange(this);" readonly="readonly" class="cursor-hand"/>
			</td>
           	</tr>
           	<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:50"><fmt:message key='hr.staffInfo.name.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" size="30" name="people" id="people" value="" onClick="selectPeopleFun_peo();inputchange(this);" readonly="readonly" class="cursor-hand"/>
			</td>
           	</tr>
           	<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;&nbsp;&nbsp;<label style="width:45"><fmt:message key='hr.record.state.label' bundle='${v3xHRI18N}' /></label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<select style="width:120px" name="state" id="state">
				<option value="0"></option>
				<option value="1"><fmt:message key='hr.record.nobegincard.label' bundle='${v3xHRI18N}' /></option>
				<option value="2"><fmt:message key='hr.record.noendcard.label' bundle='${v3xHRI18N}' /></option>
				<option value="3"><fmt:message key='hr.record.nocard.label' bundle='${v3xHRI18N}' /></option>
				<option value="4"><fmt:message key='hr.record.comelate.label' bundle='${v3xHRI18N}' /></option>
				<option value="5"><fmt:message key='hr.record.leaveearly.label' bundle='${v3xHRI18N}' /></option>
				<option value="6"><fmt:message key='hr.record.both.label' bundle='${v3xHRI18N}' /></option>
				<option value="7"><fmt:message key='hr.record.normal.label' bundle='${v3xHRI18N}' /></option>
				<option value="8"><fmt:message key='hr.record.nobegincard.leaveearly.label' bundle='${v3xHRI18N}' /></option>
				<option value="9"><fmt:message key='hr.record.comelate.noendcard.label' bundle='${v3xHRI18N}' /></option>
			</select>
			</td>
           	</tr>	
			</table>			
		</form>
    </td>
 </tr>
 <tr>
 <td height="42" align="right" class="bg-advance-bottom">
	<input type="button" onClick="query()" value="<fmt:message key='hr.record.query.label' bundle='${v3xHRI18N}' />" class="button-default-2">
 </td>	
 </tr>
</table>
</body>
</html>