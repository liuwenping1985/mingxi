<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"/>
<html>
<head>
<script type="text/javascript">
<!--
function selectDateTime(whoClick,width,height){
  var date = whenstart('${pageContext.request.contextPath}', null, width, height);
  var newDate = new Date();
  var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
  strDate = formatDate(strDate);
    if(whoClick.name=='fromTime'){
      if(document.getElementById('toTime').value!="" && 
        date>document.getElementById('toTime').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlateend"));
      }
      else if(date!=null&&date!=""){
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
      else if(date!=null&&date!=""){
        whoClick.value = date;
      }
    } 
}

function searchStatistic(){
   statisticForm.submit();
}

function statisticDetail(type){
	var fromTime = document.statisticForm.fromTime.value;
	var toTime = document.statisticForm.toTime.value;
  	if(type == 'noBegin'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'noEnd'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'noCard'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'comeLate'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'leaveEarly'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'both'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'normal'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'noBeginLeaveEarly'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  	else if(type == 'comeLateNoEnd'){
  		parent.listFrame.location.href = hrRecordURL+"?method=statisticDetail&type="+type+"&fromTime="+fromTime+"&toTime="+toTime;
  	}
  }

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
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='hr.record.statisticInfo.label' bundle='${v3xHRI18N}' /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td><p>&nbsp;</p></td></tr>
  					<tr align="center">
   		 				<td width="50%">
        					<div align="center">
					       <table>
					        	<tr>
					        		<td>
							           <input type="hidden" inputName="<fmt:message key="plan.body.endtime.label"/>" 
							           name="fromTime" 
							           value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
							 
							           <input type="hidden" inputName="<fmt:message key="plan.body.endtime.label"/>" 
							           name="toTime" 
							           value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
									<p>&nbsp;</p>
									</td>
								</tr>
							</table>
							</div>
						</td>
					</tr>
					<tr align="center">
							<td>
								<fieldset align="center" style="font-size:9pt; width:500px">
									<legend><fmt:message key="hr.record.statisticInfo.label" bundle="${v3xHRI18N}" /></legend>
									<div style="padding:8px">
									<table width="500" border="1">
									  <tr>
										<th scope="col" bgcolor="#cccccc"><fmt:message key="hr.record.statistictype.label" bundle="${v3xHRI18N}" /></th>
										<th scope="col" bgcolor="#cccccc"><fmt:message key="hr.record.statisticdays.label" bundle="${v3xHRI18N}" /></th>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('noBegin')"><fmt:message key="hr.record.nobegincard.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${noBeginCard}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('noBeginLeaveEarly')"><fmt:message key="hr.record.nobegincard.leaveearly.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${noBeginCardLeaveEarly}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('comeLate')"><fmt:message key="hr.record.comelate.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${comeLate}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('noEnd')"><fmt:message key="hr.record.noendcard.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${noEndCard}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('comeLateNoEnd')"><fmt:message key="hr.record.comelate.noendcard.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${comeLateNoEndCard}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('leaveEarly')"><fmt:message key="hr.record.leaveearly.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${leaveEarly}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('both')"><fmt:message key="hr.record.both.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${both}</span></td>
									  </tr>
									  <tr>
										<td align="left"><a href="javascript:statisticDetail('normal')"><fmt:message key="hr.record.normal.label" bundle="${v3xHRI18N}" /></a></td>
										<td align="center"><span class="STYLE1">${normal}</span></td>
			  						</tr>
			  						<tr>
										<td align="left"><fmt:message key="hr.record.nocard.label" bundle="${v3xHRI18N}" /></td>
										<td align="center"><span class="STYLE1">${noCard}</span></td>
									  </tr>
									</table>
									</div>
								</fieldset>
							</td>
					</tr>
		</table>
</body>
</html>