<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="headerbyopen.jsp"%>
<title><fmt:message key='mr.label.worktimeset'/></title>
<script language="JavaScript">
	 var The_Year = '${year}';
	 var The_Month = '${month}';
	 var isGroupAdmin = '${isGroupAdmin}';
	 var groupWorkTimeStr = '${groupWorkTimeStr}';
	 var groupComnRestDayStr = '${groupComnRestDayStr}';
	 //设置通用的工作日和休息日，参数sComnRestDays格式 "6,0,...";0为星期日，是休息日的星期的连接串
	 var sComnRestDays = "${sComnRestDays}";
	 var workTimeStr = "${workTimeStr}";	
</script>
</head>
<body scroll='no' onLoad="init(sComnRestDays,workTimeStr)" style="height: 100%;overflow: hidden;">
<form style="height: 100%" action="" id="timeConfigForm" method="POST" target = 'submitFrame' onkeypress="if(event.keyCode == 13){subminForm();}">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='mr.label.title'/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" height="100%">
			<div class="scrollList">
					<table width="100%" height="100%" border="0" cellspacing="0"
						cellpadding="0">
						<tr>
							<td valign="middle" align="center">
							<table width="100%" height="100%" border="0" cellspacing="0"
								cellpadding="0">
								<tr>
									<td valign="top">
									<table width="100%" height="100%" border="0" cellspacing="0"
										cellpadding="0">
										<tr>
											<td height="20" align="right"><a href="javascript:openHelp()"
												class="like-a"></a></td>
										</tr>
										<tr>
											<td valign="top">
											<table width="100%" height="20%" border="0" cellspacing="0"
												cellpadding="0">
												<tr>
													<td height="30" width="130" align="right"><fmt:message key='mr.label.amworktime'/>：</td>
													<td width="270" align="left"><select
														name="select0" id="select0" style="height=20px;width=40px">
													</select> ：<select name="select1" id="select1" style="height=20px;width=40px">
													</select> <fmt:message key='mr.label.to'/> <select id="select2" name="select2" style="height=20px;width=40px">
													</select> ： <select id="select3" name="select3" style="height=20px;width=40px">
													</select></td>
												</tr>
					
												<tr>
													<td height="30" width="130" align="right"><fmt:message key='mr.label.pmworktime'/>：</td>
													<td width="270" align="left"> <select id="select4" name="select4" style="height=20px;width=40px">
													</select> ：<select id="select5" name="select5" style="height=20px;width=40px">
													</select> <fmt:message key='mr.label.to'/> <select id="select6" name="select6" style="height=20px;width=40px">
													</select> ： <select id="select7" name="select7" style="height=20px;width=40px">
													</select> </td>
												</tr>
					
												<tr>
													<td height="30" width="130" align="right"><fmt:message key='mr.label.workday'/>：</td>
													<td align="left">
													<label for="Checkbox1">
													<input id="Checkbox1" name="Checkbox" type="checkbox" value="1" /><fmt:message key='mr.label.1'/>
													</label>
													<label for="Checkbox2">
													<input id="Checkbox2" name="Checkbox" type="checkbox" value="2" /><fmt:message key='mr.label.2'/>
													</label>
													<label for="Checkbox3">
													<input id="Checkbox3" name="Checkbox" type="checkbox" value="3" /><fmt:message key='mr.label.3'/>
													</label>
													<label for="Checkbox4">
													<input id="Checkbox4" name="Checkbox" type="checkbox" value="4" /><fmt:message key='mr.label.4'/>
													</label>
													</td>
												</tr>
					
												<tr>
													<td height="30" width="130" align="right">&nbsp;</td>
													<td align="left">
													<label for="Checkbox5">
													<input id="Checkbox5" name="Checkbox" type="checkbox" value="5" /><fmt:message key='mr.label.5'/>
													</label>
													<label for="Checkbox6">
													<input id="Checkbox6" name="Checkbox" type="checkbox" value="6" /><fmt:message key='mr.label.6'/>
													</label>
													<label for="Checkbox0">
													<input id="Checkbox0" name="Checkbox" type="checkbox" value="0" /><fmt:message key='mr.label.0'/>
													</label>
													</td>
												</tr>
											</table>
											</td>
										</tr>
									</table>
									</td>
								</tr>
								
							</table>
							</td>
						</tr>
					</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<div class="div-float" style="${v3x:getSysFlagByName('worktime_groupWorkTimeSync') ? '' : 'display: none;'}">
				<label for="copyCurrencyTimeFlag">
				<input type="checkbox" id="copyCurrencyTimeFlag" name="copyCurrencyTimeFlag" onclick="copyFlagClick()"/>
				<c:choose>
					<c:when test="${isGroupAdmin != true}">
						<fmt:message key='mr.label.syncGroupWorkTimeSetToUnit'/>
					</c:when>
					<c:otherwise>
						<fmt:message key='mr.label.syncUnitWorkTimeSetFromGroup'/>
					</c:otherwise>
				</c:choose>
				</label>
			</div>
			<input id="submintButton" type="button" onclick="subminForm()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2 button-default_emphasize">&nbsp;
			<input id="submintCancel" type="button" onclick="closeDialog()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2"> 
		</td>
	</tr>
</table>
</form>
	
	

<iframe name="submitFrame" frameborder="0"></iframe>
</body>
<script language="JavaScript">

function closeDialog() {
	transParams.parentWin.fnConfigWinCollBack("close");
}
function init(sComnRestDays,workTimeStr){
	 //显示右侧通用工作日区
	 var checkboxArray = document.getElementsByName("Checkbox");
	 var sComnRestDaysArray = sComnRestDays.split(",");
	 for(var ci=0;ci<checkboxArray.length;ci++){
	 	var checkboxOrg = checkboxArray[ci];
		checkboxOrg.checked = true;
		for(var ri=0;ri<sComnRestDaysArray.length;ri++){
			if(checkboxOrg.value == sComnRestDaysArray[ri]){
				checkboxOrg.checked = false;
			}
		}
	 };
	 var workTimeStrArray = workTimeStr.split(",");
	 
	 var workTimeAmBegin = workTimeStrArray[0];
	 var workTimeAmBeginArray = workTimeAmBegin.split(":");
	 var amBeginHour = workTimeAmBeginArray[0];
	 var amBeginMin = workTimeAmBeginArray[1];
	 
	 
	 var workTimeAmEnd = workTimeStrArray[1];
	 var workTimeAmEndArray = workTimeAmEnd.split(":");
	 var amEndHour = workTimeAmEndArray[0];
	 var amEndMin = workTimeAmEndArray[1];
	 
	 var workTimePmBegin = workTimeStrArray[2];
	 var workTimePmBeginArray = workTimePmBegin.split(":");
	 var pmBeginHour = workTimePmBeginArray[0];
	 var pmBeginMin = workTimePmBeginArray[1];
	 
	 var workTimePmEnd = workTimeStrArray[3];
	 var workTimePmEndArray = workTimePmEnd.split(":");
	 var pmEndHour = workTimePmEndArray[0];
	 var pmEndMin = workTimePmEndArray[1];
	 
	var selectArray = document.getElementsByTagName("select");
	for(var i=0;i<selectArray.length;i++){
		var tempSelectHourObj = document.getElementById("select"+i);
		tempSelectHourObj.innerHTML = "";
		if(i==0||i==2||i==4||i==6){
			for(var j=0;j<24;j++){
				var hour = "";
				if(j<10){
					hour = "0"+j.toString();
				}
				else{
					hour = j.toString();
				}
				tempSelectHourObj.options.add(new Option(hour,hour));
				if((amBeginHour==hour&&i==0)||(amEndHour==hour&&i==2)||(pmBeginHour==hour&&i==4)||(pmEndHour==hour&&i==6)){
					tempSelectHourObj.options[j].selected = true;
				}
			}
		}
		if(i==1||i==3||i==5||i==7){
			var tempSelectMinObj = document.getElementById("select"+i);
			var loopNum = 0;
			for(var k=0;k<60;k=k+5){
				var min = "";
				if(k<10){
					min = "0"+k.toString();
				}
				else{
					min = k.toString();
				}
				tempSelectMinObj.options.add(new Option(min,min));
				if((amBeginMin==min&&i==1)||(amEndMin==min&&i==3)||(pmBeginMin==min&&i==5)||(pmEndMin==min&&i==7)){
					tempSelectMinObj.options[loopNum].selected = true;
				}
				loopNum = loopNum + 1; 
			}
		}
		
	}
}
  function subminForm(){
 	var amBeginHour ;
	var amBeginMin ;
	var amEndHour ;
	 var amEndMin ;
	 
	 var pmBeginHour ;
	var pmBeginMin ;
	var pmEndHour ;
	 var pmEndMin ;
	
	
 	var selectArray = document.getElementsByTagName("select");
	for (var i = 0; i < selectArray.length; i++) {
		if (i == 0 || i == 2 || i == 4 || i == 6) {
			var tempSelectHourObj = document.getElementById("select"+i);
			var optionObjs = tempSelectHourObj.options;
			for(var j=0;j<optionObjs.length;j++){
				var tempOptionObj = optionObjs[j];
				if(tempOptionObj.selected&&i==0){
					amBeginHour = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==2){
					amEndHour = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==4){
					pmBeginHour = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==6){
					pmEndHour = tempOptionObj.value;
				}
			}
		}
		if (i == 1 || i == 3 || i == 5 || i == 7) {
			var tempSelectMinObj = document.getElementById("select"+i);
			var optionObjs = tempSelectMinObj.options;
			for(var j=0;j<optionObjs.length;j++){
				var tempOptionObj = optionObjs[j];
				if(tempOptionObj.selected&&i==1){
					amBeginMin = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==3){
					amEndMin = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==5){
					pmBeginMin = tempOptionObj.value;
				}
				if(tempOptionObj.selected&&i==7){
					pmEndMin = tempOptionObj.value;
				}
			}
		}
	}
	var amBeginWorkTime = amBeginHour + ":" + amBeginMin;
	var amEndWorkTime = amEndHour + ":" + amEndMin;
	var pmBeginWorkTime = pmBeginHour + ":" + pmBeginMin;
	var pmEndWorkTime = pmEndHour + ":" + pmEndMin;
	
	var checkWeekNum = "";
	var checkBoxArray = document.getElementsByName("Checkbox");
	for(var i=0;i<7;i++){
		var tempCheckObj = document.getElementById("Checkbox"+i);
		if(tempCheckObj.checked){
			checkWeekNum = checkWeekNum + "1" + ",";
		}
		else{
			checkWeekNum = checkWeekNum + "0" + ",";
		}
	}
	if(!checkTimeSet(amBeginHour,amEndHour,pmBeginHour,pmEndHour,amBeginMin,amEndMin,pmBeginMin,pmEndMin)){
		return;
	};
	var copyCurrencyTimeFlag = document.forms[0].copyCurrencyTimeFlag;
	if (copyCurrencyTimeFlag.checked) {
	  	var confirmStr = "";
		if("true"==isGroupAdmin){
			confirmStr = v3x.getMessage("workTimeSetLang.ensure_alertSetGroupSyncWorkTime");
		}else{
			confirmStr = v3x.getMessage("workTimeSetLang.ensure_alertSetUnitSyncWorkTime");
		}
		if(!confirm(confirmStr)){
			copyCurrencyTimeFlag.checked = false;
			return;
		}
	}
	var parent = transParams.parentWin;
	if(parent){
		var worktimeForm = parent.document.getElementById("worktimeForm");
		worktimeForm.action = "${workTimeSetUrl}?method=setCurrencyWorkTime&workAmBeginTime="+amBeginWorkTime+"&workAmEndTime="+amEndWorkTime
									+ "&workPmBeginTime=" + pmBeginWorkTime + "&workPmEndTime=" + pmEndWorkTime + "&year=" + The_Year + "&workDays="
									+ checkWeekNum
									+"&copyCurrencyTimeFlag="
									+ copyCurrencyTimeFlag.checked
									+"&month="
									+The_Month;
		/*worktimeForm.method = "post";	
		worktimeForm.submit();*/
		parent.fnConfigWinCollBack("true");
	}
 }
 
 function checkTimeSet(amBeginHour,amEndHour,pmBeginHour,pmEndHour,amBeginMin,amEndMin,pmBeginMin,pmEndMin){
 	var amBegin = amBeginHour*60 + amBeginMin*1;
	var amEnd = amEndHour*60 + amEndMin*1;
	var pmBegin = pmBeginHour*60 + pmBeginMin*1;
	var pmEnd = pmEndHour*60 + pmEndMin*1;
	if(amEnd<=amBegin){
		alert(_("workTimeSetLang.timeSet_alertOverAM"));
		return false;
	}
	if(pmBegin<=amEnd){
		alert(_("workTimeSetLang.timeSet_alertOverAMPM"));
		return false;
	}
	if(pmEnd<=pmBegin){
		alert(_("workTimeSetLang.timeSet_alertOverPM"));
		return false;
	}
	return true;
 }
 
 function copyFlagClick(){
 	var selectObjArr = document.getElementsByTagName("select");
	var copyCurrencyTimeFlag = document.forms[0].copyCurrencyTimeFlag;
	var checkBoxArray = document.getElementsByName("Checkbox");
 	if(isGroupAdmin=="false"){
		if(copyCurrencyTimeFlag.checked){
			for(var i=0;i<selectObjArr.length;i++){
				var selectObj = selectObjArr[i];
				selectObj.disabled = true;
			}
			for(var j=0;j<checkBoxArray.length;j++){
				var checkBoxObj = checkBoxArray[j];
				checkBoxObj.disabled = true;
			}
			init(groupComnRestDayStr,groupWorkTimeStr);
		}else{
			for(var i=0;i<selectObjArr.length;i++){
				var selectObj = selectObjArr[i];
				selectObj.disabled = false;
			}
			for(var j=0;j<checkBoxArray.length;j++){
				var checkBoxObj = checkBoxArray[j];
				checkBoxObj.disabled = false;
			}
			init(sComnRestDays,workTimeStr);
		}
	}
 }
</script>
</html>