<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"/>
<html>
<head>
<script type="text/javascript">
<!--
var onlyLoginAccount_staff =true;

function setStaff(elements){
	
    if (!elements) {
        return;
    }
    
    var idsString =  getIdsString(elements,false);
	if(idsString.indexOf(",")!=-1)	{
	  alert(v3x.getMessage("HRLang.hr_record_staffName_onlyOne"));
    return false;
	}
 
	else{ 
	  document.getElementById("staffName").value = getNamesString(elements);
      document.getElementById("staffId").value = getIdsString(elements,false);
 
	}
}


function selectDateTime(whoClick,width,height){
  var date = whenstart('${pageContext.request.contextPath}', null, width, height);
  if (date == null) date = "";
  var newDate = new Date();
  var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
  strDate = formatDate(strDate);
    if(whoClick.name=='fromTime'){
      if(document.getElementById('toTime').value!="" && 
        date>document.getElementById('toTime').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlateend"));
      }
      else{
        whoClick.value = date; 
      }
    }
    if(whoClick.name=='toTime'){
      if(document.getElementById('fromTime').value!="" && 
        date<document.getElementById('fromTime').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"));
      }
      else if(strDate<date){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_endcannotlatenow"));
      }
      else{
        whoClick.value = date;
      }
    }
    
}

function searchStatistic(){
  var fromTime =  document.getElementById('fromTime').value ;
  var toTime = document.getElementById('toTime').value ;
   if(document.getElementById('fromTime').value==""||document.getElementById('fromTime').value=="null"){
     alert(v3x.getMessage("HRLang.hr_record_statistic_selectbegintime"));
     return;
   }
   if(document.getElementById('toTime').value==""||document.getElementById('toTime').value=="null"){
     alert(v3x.getMessage("HRLang.hr_record_statistic_selectendtime"));
     return;
   }
   if(document.getElementById('staffId').value==""){
     alert(v3x.getMessage("HRLang.hr_record_statistic_selectstaff"));
     return false;
   }
   if(compareDate(fromTime,toTime)>0)
	{
		window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
		return false;	
	}
   statisticForm.submit();
}

 function compareDate(dateStr1, dateStr2){
	var date1 = parseDate(dateStr1);
	var date2 = parseDate(dateStr2);
	
	return date1.getTime() - date2.getTime();
}

function statisticManagerDetail(type){
  	var fromTime = document.statisticForm.fromTime.value;
  	var toTime = document.statisticForm.toTime.value;
  	var staffId = document.statisticForm.staffId.value;
  	var staffName1 = document.statisticForm.staffName.value;
  	var staffName = encodeURI(staffName1);//??????????
  	parent.toolbarFrame.document.getElementById("fromTime").value = fromTime;
  	parent.toolbarFrame.document.getElementById("toTime").value = toTime;
  	parent.toolbarFrame.document.exportForm.linkFromTime.value = fromTime;
  	parent.toolbarFrame.document.exportForm.linkToTime.value = toTime;
  	parent.toolbarFrame.document.exportForm.linkName.value = staffName;
  	parent.toolbarFrame.document.exportForm.linkStaffId.value = staffId;
  	parent.toolbarFrame.document.exportForm.linkType.value = type;
    parent.listFrame.location.href = hrRecordURL+"?method=statisticManagerDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime+"&staffId="+staffId+"&staffName="+staffName;
  	
  }
showConcurrentMember_staff = false;
-->
</script>
</head>
<body>
<form name="statisticForm" action="${hrRecordURL}?method=statistic" method="post"  >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak();  
			//document.write("<img src=\"/seeyon/common/images/button.preview.up.gif\" height=\"8\" onclick=\"previewFrame('Up')\" class=\"cursor-hand\">");
			//document.write("<img src=\"/seeyon/common/images/button.preview.down.gif\" height=\"8\" onclick=\"previewFrame('Down')\" class=\"cursor-hand\">");
			//document.close();
		</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='hr.toolbar.salaryinfo.statisticStaff.label' bundle='${v3xHRI18N}' /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body" id="scrollDiv">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  					<tr align="center">
   		 				<td width="50%">
        <div align="center">
        <table width="500px">
        <tr>
        <td>
        <c:choose>
        <c:when test="${recordDept=='true' && v3x:isRole('DepAdmin', v3x:currentUser())}">
        	<script type="text/javascript">
                <!--
                var includeElements_staff = "${v3x:parseElementsOfTypeAndId(deptlist)}";
                var showDepartmentsOfTree_staff = '${scope_deptId}';
                //-->
        </script>
          <v3x:selectPeople id="staff" panels="Department" selectType="Member" jsFunction="setStaff(elements)"/>
        </c:when>
		<c:otherwise>
		  <v3x:selectPeople id="staff" panels="Department,Team" selectType="Member" jsFunction="setStaff(elements)"/>
		</c:otherwise>
		</c:choose>
        	<fmt:message key="hr.record.staffName.label" bundle="${v3xHRI18N}"/>:&nbsp;&nbsp;
        	
        	<input type="hidden" name="staffId" id="staffId" value="${staffId}">
        	<input type="hidden" name="recordDept" id="recordDept" value="${recordDept}">
        	<input size="10" type="text" name="staffName" id="staffName" width="50"
            	value="${staffName}" readOnly  onClick="selectPeopleFun_staff()">
        </td>
        <td align="right"><fmt:message key="hr.record.querytime.label" bundle="${v3xHRI18N}" />:&nbsp;&nbsp;<fmt:message key="hr.record.queryfromtime.label" bundle="${v3xHRI18N}" /></td>
        <td>
        	<input size="10" type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"
           		validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,400,500)" readonly
           		value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
        </td>
        <td align="center"><fmt:message key="hr.record.querytotime.label" bundle="${v3xHRI18N}" /></td>
        <td><input size="10" type="text" width="10%" inputName="<fmt:message key="plan.body.endtime.label"/>"
           validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,900,450)" readonly
           value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>"></td>
        <td>
            <input type="button" value='<fmt:message key="hr.record.query.label" bundle="${v3xHRI18N}" />' onclick="searchStatistic()">
        </td>
        </tr>
		</table>
		</div>
		</td>
		</tr>
		<tr align="center"> 
		  <td width="50%">
			 <div align="center">
			  <table width="500" border="0">
			   <tr>
			    <td>
			      <div class="hr-blue-font"><strong><fmt:message key="hr.record.statisticInfo.label" bundle="${v3xHRI18N}" /></strong></div>
			    </td>
			   </tr>
			 </table>
			</div>
		  </td>
		</tr>	
		<tr align="center">
		<td>		
		<div style="padding:8px">
		<table width="500" border="1">		  	 
		  <tr>
			<th scope="col" bgcolor="#cccccc"><fmt:message key="hr.record.statistictype.label" bundle="${v3xHRI18N}" /></th>
			<th scope="col" bgcolor="#cccccc"><fmt:message key="hr.record.statisticdays.label" bundle="${v3xHRI18N}" /></th>
		  </tr>
		  <c:choose>
		  <c:when test="${usable}">
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('noBegin')"><fmt:message key="hr.record.nobegincard.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${noBeginCard}</span></td>
			  </tr>
			   <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('noBeginLeaveEarly')"><fmt:message key="hr.record.nobegincard.leaveearly.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${noBeginCardLeaveEarly}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('noEnd')"><fmt:message key="hr.record.noendcard.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${noEndCard}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('comeLate')"><fmt:message key="hr.record.comelate.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${comeLate}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('leaveEarly')"><fmt:message key="hr.record.leaveearly.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${leaveEarly}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('comeLateNoEnd')"><fmt:message key="hr.record.comelate.noendcard.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${comeLateNoEndCard}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('both')"><fmt:message key="hr.record.both.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${both}</span></td>
			  </tr>
			  <tr>
				<td align="left"><a href="javascript:statisticManagerDetail('normal')"><fmt:message key="hr.record.normal.label" bundle="${v3xHRI18N}" /></a></td>
				<td align="center"><span class="STYLE1">${normal}</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.nocard.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">${noCard}</span></td>
			  </tr>
		  </c:when>
		  <c:otherwise>
		  	  <tr>
				<td align="left"><fmt:message key="hr.record.nobegincard.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.nobegincard.leaveearly.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.noendcard.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.comelate.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.leaveearly.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.comelate.noendcard.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.both.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.normal.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
			  <tr>
				<td align="left"><fmt:message key="hr.record.nocard.label" bundle="${v3xHRI18N}" /></td>
				<td align="center"><span class="STYLE1">&nbsp;</span></td>
			  </tr>
		  </c:otherwise>
		  </c:choose>
		</table>
		</div>		
 		</td>
 		</tr>
 		</table>
 		</div>
 		</td>
 		</tr>
 		</table>
		</form>
		<script>
			bindOnresize('scrollDiv',30,55);
		</script>
</body>
</html>