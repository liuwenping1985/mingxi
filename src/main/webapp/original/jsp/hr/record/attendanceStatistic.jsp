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
     return;
   }
   if(compareDate(fromTime,toTime)>0)
	{
		window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
		return ;	
	}
   statisticForm.submit();
}

 function compareDate(dateStr1, dateStr2){
	var date1 = parseDate(dateStr1);
	var date2 = parseDate(dateStr2);
	
	return date1.getTime() - date2.getTime();
}

function statisticManagerDetail(type, staffName1, staffId){
  	var fromTime = document.getElementById('fromTime').value;
  	var toTime = document.getElementById('toTime').value;
  	var staffName = encodeURI(staffName1);
  	parent.toolbarFrame.document.getElementById("fromTime").value = fromTime;
  	parent.toolbarFrame.document.getElementById("toTime").value = toTime;
  	parent.toolbarFrame.document.exportForm.linkFromTime.value = fromTime;
  	parent.toolbarFrame.document.exportForm.linkToTime.value = toTime;
  	parent.toolbarFrame.document.exportForm.linkName.value = staffName;
  	parent.toolbarFrame.document.exportForm.linkStaffId.value = staffId;
  	parent.toolbarFrame.document.exportForm.linkType.value = type;
    parent.listFrame.location.href = hrRecordURL+"?method=statisticManagerDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime+"&staffId="+staffId+"&staffName="+staffName;
  	
  }

-->
</script>
</head>
<body>
	<script type="text/javascript">
	<!--
	getDetailPageBreak("","${param.direction}");
	//-->
	</script>
     <input size="10" type="hidden" id="fromTime" name="fromTime"  readonly
        	value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
     <input size="10" type="hidden" id="toTime" name="toTime"  readonly
         value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	<input type="hidden" id="resultCount" name="resultCount" value="${resultCount}" />
	<v3x:table data="${recordDTOs}" var="recordDTO"  htmlId="recordStatList" >					
		
		<v3x:column width="14%" type="String" label="hr.staffInfo.name.label" 
				value="${recordDTO.name}" className="cursor-hand sort" maxLength="15" symbol="..." alt="${recordDTO.name}">
		</v3x:column>
		<v3x:column width="23%" type="String" label="hr.record.department.label" 
				value="${recordDTO.department}" className="cursor-hand sort" symbol="..." alt="${recordDTO.department}">
		</v3x:column>
		<v3x:column width="8%" type="String" label="hr.record.nobegincard.label" className="cursor-hand sort" >
				<span class="STYLE1"><a href="javascript:statisticManagerDetail('noBegin','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.noBeginCard}</a></span>
              	</v3x:column>
		<v3x:column width="10%" type="String" label="hr.record.nobegincard.leaveearly.label" className="cursor-hand sort" >
				<span class="STYLE1"><a href="javascript:statisticManagerDetail('noBeginLeaveEarly','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.noBeginCardLeaveEarly}</a></span>
		</v3x:column>
		<v3x:column width="8%" type="String" label="hr.record.noendcard.label" className="cursor-hand sort" >
				<span class="STYLE1"><a href="javascript:statisticManagerDetail('noEnd','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.noEndCard}</a></span>
		</v3x:column>
		<v3x:column width="8%" type="String" label="hr.record.comelate.label" className="cursor-hand sort" >
              			<span class="STYLE1"><a href="javascript:statisticManagerDetail('comeLate','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.comeLate}</a></span>
              	</v3x:column>
		<v3x:column width="8%" type="String" label="hr.record.leaveearly.label" className="cursor-hand sort" >
				<span class="STYLE1"><a href="javascript:statisticManagerDetail('leaveEarly','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.leaveEarly}</a></span>
		</v3x:column>
		<v3x:column width="10%" type="String" label="hr.record.comelate.noendcard.label" className="cursor-hand sort" >
				<span class="STYLE1"><a href="javascript:statisticManagerDetail('comeLateNoEnd','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.comeLateNoEndCard}</a></span>
		</v3x:column>
		<v3x:column width="8%" type="String" label="hr.record.both.label" className="cursor-hand sort" >
      		<span class="STYLE1"><a href="javascript:statisticManagerDetail('both','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.both}</a></span>
       	</v3x:column>
       	<v3x:column width="6%" type="String" label="hr.record.normal.label" className="cursor-hand sort" >
      		<span class="STYLE1"><a href="javascript:statisticManagerDetail('normal','${recordDTO.name}','${recordDTO.userId}')">${recordDTO.normal}</a></span>
       	</v3x:column>
       	<v3x:column width="6%" type="String" label="hr.record.nocard.label" className="cursor-hand sort" 
      		value="${recordDTO.noCard}" >
       	</v3x:column>
	</v3x:table>
</form>
</body>
</html>