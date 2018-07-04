<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>    
<%@ include file="../../../hr/header.jsp"%>  
<%@ include file="./common.jsp"%>
<%@ include file = "./mCmpLbsSearch_js.jsp" %>  
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

<title>${ctp:i18n('m1.lbs.attendance.record.attendanceSearch')}</title>
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
	<td class="bg-advance-middel">
		<form id="M1MCmpLbsSearch" name="M1MCmpLbsSearch" method="post" action="">
	<input type="hidden" name="departmentId" id="departmentId" value = ""/>
	<input type="hidden" name="peopleId" id="peopleId" value = ""/>
			<table border="0" width="100%" height="98%" align="center">
			<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;<label style="width:50">${ctp:i18n('m1.lbs.attendance.record.searchTime')}</label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" inputName="<fmt:message key="m1.lbs.attendance.record.searchTime"/>"  style="cursor:hand"
         	 name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,400,400,'datetime')" readonly
         	value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm"/>">
			－<input type="text" inputName="<fmt:message key="m1.lbs.attendance.record.searchTime"/>"  style="cursor:hand"
            name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,400,400,'datetime')" readonly
           	value="<fmt:formatDate value="${toTime}" type="both" dateStyle="" pattern="yyyy-MM-dd HH:mm"/>">
           	</td>
           	</tr>
           	<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;<label style="width:50">${ctp:i18n('m1.lbs.attendance.record.searchByDepartment')}</label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" id="department"  name ="department" onClick="selectPeopleFun_dep();inputchange(this);" readonly="readonly"  size="30">
			</td>
           	</tr>
           	<tr>
			<td class="bg-gray" nowrap="nowrap">
			&nbsp;&nbsp;<label style="width:50">${ctp:i18n('m1.lbs.attendance.record.searchByperson')}</label>&nbsp;&nbsp;
			</td>
			<td class="new-column" nowrap="nowrap">
			<input type="text" id="people"  name = "people"  onClick="selectPeopleFun_peo();inputchange(this);" readonly="readonly" size="30">
			</td>
           	</tr>
           	
			</table>			
		</form>
    </td>
 </tr>
 <tr>
 <td height="42" align="right" class="bg-advance-bottom">
	<input type = "button" value="${ctp:i18n('m1.lbs.attendance.record.searchButton')}"  class="button-default-2" onClick="query()">
 </td>	
 </tr>
</table>
</body>
</html>