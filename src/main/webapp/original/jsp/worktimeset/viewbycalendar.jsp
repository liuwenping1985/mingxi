<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="headerbyopen.jsp"%>
<script type="text/javascript">
showCtpLocation('F13_viewByCalendar');
	if(${v3x:currentUser().groupAdmin}){
		showCtpLocation('F13_groupTime');
	}else if(${v3x:currentUser().administrator}){
		showCtpLocation('F13_unitTime');
	}

</script>
<style>
td {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}

.titleDiv {
	font-family: Arial;
	font-size: 12px;
	line-height: 14px;
	border: 1px solid #000000;
	background-color: #66FF00;
	margin-left: 5px;
	margin-top: 3px;
	padding-left: 3px;
	padding-top: 1px;
	padding-bottom: 1px;
	position: relative;
	left: 12px;
	top: -12px;
	width: 62px;
}
.common_button_emphasize{
	color:#fff;
	border:1px solid #42b3e5;
	background:#42b3e5;
}
.common_button_emphasize:hover{
	background:#62c4ef;
	border:1px solid #42b3e5;
}
</style>
</head>
<body class="border-right">
<div id="MenuDiv" style="display: none;">
<form id='innerHtmlForm'><input type="hidden" id="clickDayNum" /><input
	type="hidden" id="clickDayId" />
<table bgcolor="#ffffff" style='width: 250px; height: 100px; border: 0px' >
	<tr>
		<td height="24" colspan='2' align=center><div id="timeTitle"></div></td>
	</tr>
	<tr>
		<td>
			<table>
				<tr>
					<td align=left valign="top">
						<label><fmt:message key='mr.label.type'/>：</label>
					</td>
					<td colspan='2' align=left valign="top">
						<label for="spicalDays0">
						<input type='radio' id="spicalDays0" name="spicalDays" value="0"><fmt:message key='mr.label.workday'/>
						</label>
						<label for="spicalDays1">
						<input type='radio' id="spicalDays1" name="spicalDays" value="1"><fmt:message key='mr.label.restday'/>
						</label>
						<label for="spicalDays2">
						<input type='radio' id="spicalDays2" name="spicalDays" value="2"><fmt:message key='mr.label.restdayinlaw'/>
						</label>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table>
				<tr>
					<td align=left valign="top"><fmt:message key='mr.label.description'/>：</td>
					<td colspan='2' align=left valign="top">
						<textarea cols='4' inputName="<fmt:message key='mr.label.description'/>"
							rows='4' style='width: 200px' id="menuRestInfo" name="menuRestInfo"
								maxLength="100" maxSize="100"  validate="notSpecChar,maxLength" >
				        </textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick='submitMenuDiv();' value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2 common_button_emphasize">&nbsp;
			<input id='closeButton' type="button" onclick='menuClose();' value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</div>

<div id="hoverDiv" style="display: none; height: 40px; width: 95px; background-color: #eaf0f6"></div>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="">

	<tr>
		<td>
		<div id="mainDiv" >
		<table width="65%" border="0" height="300" align="center"
			cellpadding="0" cellspacing="0">
			<tr>
				<td height="50">
				<fieldset style="padding: 20px; margin-top:20px;"><legend> <b><fmt:message key='mr.label.restdayset'/></b>
				</legend> <br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td id=cc></td>
					</tr>
				</table>
				<table cellpadding="0">
					<tr>
					<td>
					<table>
						<tr valign="bottom">
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td style='border:3px solid #FFD76A; height:20px;width:20px'>&nbsp;</td>
							<td><fmt:message key='mr.label.curretday'/></td>
							<td style='border:1px solid #D3D3D5; height:10px;width:20px'>&nbsp;</td>
							<td><fmt:message key='mr.label.workday'/></td>
							<td style='background-color:#c1d9ff;border:1px solid #D3D3D5; height:20px;width:20px'>&nbsp;</td>
							<td><fmt:message key='mr.label.restday'/></td>
							<td style='background-color:#ffc497;border:1px solid #D3D3D5; height:20px;width:20px'>&nbsp;</td>
							<td><fmt:message key='mr.label.restdayinlaw'/></td>
						</tr>
					</table>
					</td>
					</tr>
					<tr>
					<td>
					<table>
					<tr valign="middle" style="${v3x:getSysFlagByName('worktime_groupWorkTimeSync') ? '' : 'display: none;'}">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td><div><label for="syncCheckBox">
							<input type="checkbox" id="syncCheckBox" name="syncCheckBox" onclick="showSyncSpecialDiv()"/>
							<c:choose>
								<c:when test="${isGroupAdmin != true}">
									<fmt:message key='mr.label.syncSpecialDayFromUnitToGroup${v3x:suffix()}'/>
								</c:when>
								<c:otherwise>
									<fmt:message key='mr.label.syncSpecialDayFromGroupToUnit'/>
								</c:otherwise>
							</c:choose>
							</label></div>
						</td>
						<td>
							<div class="float-right" id="specialDaySyncDiv" style="display: none;">
								<form id='specialDaySyncForm'>
									<c:if test="${isGroupAdmin != true}">
										<a class="like-a" onclick="openGroupSpecialDaySetDlg()" id="addExternalAccountDiv">[<fmt:message key='mr.label.watchGroup'/>]</a>
									</c:if>
									<label for="syncFlag0">
										<input type='radio' id="syncFlag0" name="syncFlag" value="0"/>&nbsp;<fmt:message key='mr.label.syncAllYear'/>
									</label>
									<label for="syncFlag1">
										<input type='radio' id="syncFlag1" name="syncFlag" value="1"/>&nbsp;<fmt:message key='mr.label.syncCurrentMonth'/>
									</label>
									<input type="button" onclick='submitSyncSpecialDateDiv();' value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2 common_button_emphasize">&nbsp;
								</form>
							</div>
						</td>
					</tr>
					<tr valign="bottom" height="20px">
					<td colspan="4" class="description-lable" style="word-break:break-all;">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="mr.label.restdayset.description"/></td>
					</tr>
					<tr valign="bottom" height="20px">
					<td colspan="4" class="description-lable" style="word-break:break-all;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="mr.label.restdayset.description2"/></td>
					</tr>
				</table>
				</td>
				</tr>
				</table>
				</fieldset>
				</td>
			</tr>
			<tr>
				<td height="50">
				<fieldset style="padding: 20px"><legend> <b><fmt:message key='mr.label.worktimeset'/></b>
				</legend> <br>
				<div style="width: 400px; height: 100px">
				<table>
					<tr>
						<td style="" class="style1"><fmt:message key='mr.label.amworktime'/>：</td>
						<td style="" class="style1"><span id="amWorkTimeBeginTime"></span>
						&nbsp;&nbsp;&nbsp;<fmt:message key='mr.label.to'/>&nbsp;&nbsp;&nbsp;<span id="amWorkTimeEndTime"></span>
						</td>
					</tr>
					<tr>
						<td style="" class="style1"><fmt:message key='mr.label.pmworktime'/>：</td>
						<td style="" class="style1"><span id="pmWorkTimeBeginTime"></span>
						&nbsp;&nbsp;&nbsp;<fmt:message key='mr.label.to'/>&nbsp;&nbsp;&nbsp;<span id="pmWorkTimeEndTime"></span>
						</td>
					</tr>
					<tr>
						<td rowspan="1" style="" class="style1">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<fmt:message key='mr.label.workday'/>：</td>
						<td colspan="3" class="style1">
							<label for="Checkbox1">
							<input name="Checkbox" id="Checkbox1" type="checkbox" value="1" disabled="false"/><fmt:message key='mr.label.1'/>
							</label>
							<label for="Checkbox2">
							<input name="Checkbox" id="Checkbox2" type="checkbox" value="2" disabled="false"/><fmt:message key='mr.label.2'/>
							</label>
							<label for="Checkbox3">
							<input name="Checkbox" id="Checkbox3" type="checkbox" value="3" disabled="false"/><fmt:message key='mr.label.3'/>
							</label>
							<label for="Checkbox4">
							<input name="Checkbox" id="Checkbox4" type="checkbox" value="4" disabled="false"/><fmt:message key='mr.label.4'/>
							</label>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="3" style="height: 15px" class="style1">
							<label for="Checkbox5">
							<input name="Checkbox" id="Checkbox5" type="checkbox" value="5" disabled="false"/><fmt:message key='mr.label.5'/>
							</label>
							<label for="Checkbox6">
							<input name="Checkbox" id="Checkbox6" type="checkbox" value="6" disabled="false"/><fmt:message key='mr.label.6'/>
							</label>
							<label for="Checkbox0">
							<input name="Checkbox" id="Checkbox0" type="checkbox" value="0" disabled="false"/><fmt:message key='mr.label.0'/>
							</label>
						</td>
					</tr>
				</table>
				</div>
				<div>
					<table width="100%">
						<tr>
							<td height="42" align="center">
							<input type="submit" id="submitBtn" class="button-default-2 common_button_emphasize" value="<fmt:message key='mr.button.set'/>"
								onclick="openConfigWin()" /></td>
						</tr>
					</table>
				</div>
				</fieldset>
				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
</table>
<form id="worktimeForm" method="post" target="submitFrame">
<iframe name="submitFrame" frameborder="0"></iframe>
</form>
</body>
<script language="JavaScript">
  //获得每个单元格的ID
  function getTdId(The_Year,The_Month,The_Day){
  	if(The_Month < 10) {
    		The_Month = "0" + The_Month;
   	}
   	if(The_Day < 10) {
   		The_Day = "0" + The_Day;
   	}
   	var Firstday;
   	var completely_date;
   	if (The_Day!=0)
   		completely_date = The_Year + "/" + The_Month + "/" + The_Day;
   	else
    		completely_date = "No Choose";
  	return completely_date;
  }

  function getTitleStr(The_Year,The_Month,The_Day){
  	var completely_date = getTdId(The_Year,The_Month,The_Day);
  	var str = "<div class=\"titleDiv\" style=\"display:none\" id=\"div_"+completely_date+"\"></div>";
  	return str;
  }

  function RunNian(The_Year){
   if ((The_Year%400==0) || ((The_Year%4==0) && (The_Year%100!=0)))
    return true;
   else
    return false;
  }
  function GetWeekday(The_Year,The_Month){
  	if(true){
  		var d = new Date(The_Year,The_Month-1,1);
  		return d.getDay();
  	}
   var Allday;
   Allday = 0;
   if (The_Year>2000)
   {
    for (i=2000 ;i<The_Year; i++)
     if (RunNian(i))
      Allday += 366;
     else
      Allday += 365;
    for (i=2; i<=The_Month; i++)
    {
     switch (i)
     {
      case 2 :
       if (RunNian(The_Year))
        Allday += 29;
       else
        Allday += 28;
       break;
      case 3 : Allday += 31; break;
      case 4 : Allday += 30; break;
      case 5 : Allday += 31; break;
      case 6 : Allday += 30; break;
      case 7 : Allday += 31; break;
      case 8 : Allday += 31; break;
      case 9 : Allday += 30; break;
      case 10 : Allday += 31; break;
      case 11 : Allday += 30; break;
      case 12 :  Allday += 31; break;
     }
    }
   }
   return (Allday+6)%7;
  }

  function chooseday(The_Year,The_Month,The_Day){
   document.location = "${workTimeSetUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month;
   //alert("${workTimeSetUrl}");
   //设置通用的工作日和休息日，参数sComnRestDays格式 "6,0,...";0为星期日，是休息日的星期的连接串
   var sComnRestDays = "";
   if(true){
   	return;
   }
   var Firstday;
   var completely_date;
   if (The_Day!=0)
    completely_date = The_Year + "-" + The_Month + "-" + The_Day;
   else
    completely_date = "No Choose";
   //showdate 只是一个为了显示而采用的东西，
   //如果外部想引用这里的时间，可以通过使用 completely_date引用完整日期
   //也可以通过The_Year,The_Month,The_Day分别引用年，月，日
   //当进行月份和年份的选择时，认为没有选择完整的日期
   //showdate.innerText = completely_date;
   Firstday = GetWeekday(The_Year,The_Month);
   ShowCalender(The_Year,The_Month,The_Day,Firstday,sComnRestDays);
  }

  function clearTdBorder(){
  	var ns = document.getElementsByName("selecttd");
  	for(var i = 0; i < ns.length; i++){
  		ns[i].className = "noSelected";
  	}
  }

  function clickDay(node,e,The_Year,The_Month,The_Day) {
  	var objCellDate = document.getElementById(node.id);
  	document.getElementById("clickDayNum").value = node.id;
  	//document.getElementById("clickDayId").value = node.id;
  	//alert(document.getElementById("clickDayNum").value);
  	var dayFlag = document.getElementById("dayFlag_"+node.id);
  	var dayInfo = document.getElementById("dayInfo_"+node.id);
  	var radioButtons = document.getElementsByName("spicalDays");
  	if(dayFlag != null){
  		for(var i=0;i<radioButtons.length;i++){
  			var radioObj = radioButtons[i];
  			if(radioObj.value == dayFlag.value){
  				radioObj.checked = true;
  			}
  		}
  	}
	else{
		var isRest = false;
		var d = new Date(node.id);
		var comonRestDaysArray = sComnRestDays.split(",");
		for(var i=0;i<comonRestDaysArray.length;i++){
				var restDayNum = comonRestDaysArray[i];
				if(d.getDay() == restDayNum){
					isRest = true;
				}
			}

		if(isRest){
			for(var i=0;i<radioButtons.length;i++){
  				var radioObj = radioButtons[i];
				if(radioObj.value == 1){
					radioObj.checked = true;
				}
  			}
		}else{
			for(var i=0;i<radioButtons.length;i++){
  				var radioObj = radioButtons[i];
				if(radioObj.value == 0){
					radioObj.checked = true;
				}
  			}
		}
	}
  	var menuRestInfo = document.getElementById("menuRestInfo");
  	var cellDateDiv = document.getElementById("div_"+node.id);
  	var objCellDate = document.getElementById(node.id);
	var tableObj = cellDateDiv.lastChild;
	var hoverInfoValue = null;
	if(tableObj!=null){
		hoverInfoValue = tableObj.rows[0].cells[0].innerHTML;
	}
  	if((hoverInfoValue==null) || (hoverInfoValue=="")){
  		menuRestInfo.value = "";
  	} else if (dayInfo != null) {
  		menuRestInfo.value = dayInfo.value;
  	}else{
  		menuRestInfo.value = "";
  	}

	var timeTitleDiv = document.getElementById("timeTitle");
	timeTitleDiv.innerHTML = node.id;

  	//var X= objCellDate.getBoundingClientRect().left+document.documentElement.scrollLeft;
  	//var Y =objCellDate.getBoundingClientRect().top+document.documentElement.scrollTop;
  	e=e||event;
	var X= e.clientX;
  	var Y =e.clientY;
	var posX = objCellDate.offsetLeft;
	var posY = objCellDate.offsetTop;
	var aBox = objCellDate;
	do {

	   aBox = aBox.offsetParent;

	   posX += aBox.offsetLeft;

	   posY += aBox.offsetTop;

	}while (aBox.tagName != "BODY");
	X = posX;
	Y = posY;

  	var MenuDivObj = document.getElementById("MenuDiv");
  	MenuDivObj.style.position = "absolute";
  	MenuDivObj.style.left = X - document.getElementById("mainDiv").scrollLeft;
  	MenuDivObj.style.top = Y - document.getElementById("mainDiv").scrollTop;
	var dateStr = (node.id).split("/");
	var clickDate = new Date();
	clickDate.setFullYear(dateStr[0],dateStr[1]-1,dateStr[2]);
	var today = new Date();
	//bug 33774
	if (systemTimeCheck) {
		if (today < clickDate) {
			MenuDivObj.style.display = "";
		}
		else {
			MenuDivObj.style.display = "none";
		}
	}


hoverDivClose();
  }
  //提交DIV MENU
  function submitMenuDiv(){
	if(!checkForm(document.getElementById("innerHtmlForm"))){
        return;
    }
  	var rs = "";
  	var year = ${year};
	var month = ${month};
  	var flag;
  	var dayNum = document.getElementById("clickDayNum").value;
  	var radioButtons = document.getElementsByName("spicalDays");
  	for(var i=0;i<radioButtons.length;i++){
  		if(radioButtons[i].checked){
  			flag = radioButtons[i].value;
  		}
  	}
  	var spicalWorkDayId = "Id";
  	if(document.getElementById("spicalWorkDayId_"+dayNum) != null){
  		spicalWorkDayId = document.getElementById("spicalWorkDayId_"+dayNum).value;
  	}
	//alert(spicalWorkDayId);
  	var info = document.getElementById("menuRestInfo").value;
  	if(info==""){info="info";}
  	var updateDaySetStr = dayNum + "↗" + spicalWorkDayId + "↗" + flag  +"↗"+info;

  	try {
  		var requestCaller = new XMLHttpRequestCaller(this, "workTimeSetManager", "updateSpecialWorkDaySet", false);
  		requestCaller.addParameter(1,'String',year);
  		requestCaller.addParameter(2, "String", updateDaySetStr);
		requestCaller.addParameter(3, "String", month);
  		rs = requestCaller.serviceRequest();

  		setSpicalDays(rs);
  		menuClose();
  	}
  	catch (ex1) {
  		alert("Exception : " + ex1);
  		return false;
  	}
  }

    //提交工作日同步
  function submitSyncSpecialDateDiv(){
  	var syncFlag;
	var radioButtons = document.getElementsByName("syncFlag");
  	for(var i=0;i<radioButtons.length;i++){
  		if(radioButtons[i].checked){
  			syncFlag = radioButtons[i].value;
  		}
  	}
  	var confirmStr = "";
	if("true"==isGroupAdmin){
		if("1"==syncFlag){
			confirmStr = _("workTimeSetLang.ensure_alertSetGroupSyncWorkDayAllYear");
		}else{
			confirmStr = _("workTimeSetLang.ensure_alertSetGroupSyncWorkDayCurrenMonth");
		}
	}else{
		if("1"==syncFlag){
			confirmStr = _("workTimeSetLang.ensure_alertSetUnitSyncWorkDayAllYear");
		}else{
			confirmStr = _("workTimeSetLang.ensure_alertSetUnitSyncWorkDayCurrenMonth");
		}
	}


	if(!confirm(confirmStr)){
		var specialDaySyncDivObj = document.getElementById("specialDaySyncDiv");
		var syncCheckBoxObj = document.getElementById("syncCheckBox");
		syncCheckBoxObj.checked = false;
		specialDaySyncDivObj.style.display = "none";
		return;
	}

  	var rs = "";
  	//使用操作日的year month day
  	var year = today.getFullYear();
	var month = today.getMonth() + 1;
  	var currentDayNum = getTdId(year,month,today.getDate());
  	var targetYear = ${year};
  	var targetMonth = ${month};
  	try {
  		var requestCaller = new XMLHttpRequestCaller(this, "workTimeSetManager", "syncSpecialDayFromGroupToUnit", false);
  		requestCaller.addParameter(1,'String',targetYear);
  		requestCaller.addParameter(2, "String", targetMonth);
		requestCaller.addParameter(3, "String", syncFlag);
		requestCaller.addParameter(4, "String", currentDayNum);
  		rs = requestCaller.serviceRequest();
		if("returnNullSpecialDay"==rs){
			rs = "";
		}
		//重新载入页面
		window.location.reload();
  	}
  	catch (ex1) {
  		alert("Exception : " + ex1);
  		return false;
  	}
  }


  //关闭DIV MENU
  function menuClose() {
  	var MenuDivObj = document.getElementById("MenuDiv");
  	document.getElementById("clickDayNum").value = "";
  	if(MenuDivObj != null)
  	{
  		//清空上一次的选择
  		var radioButtons = document.getElementsByName("spicalDays");
  		for(var i=0;i<radioButtons.length;i++){
  			var radioObj = radioButtons[i];
  			radioObj.checked = false;
  		}
  		document.getElementById("menuRestInfo").value = "";
  		MenuDivObj.style.display = "none";
  	}
  }
  //显示说明信息
  function showInfo(node,e){
  	var cellDateDiv = document.getElementById("div_"+node.id);
  	var objCellDate = document.getElementById(node.id);
	var tableObj = cellDateDiv.lastChild;
	var hoverInfoValue = null;
	if(tableObj!=null){
		hoverInfoValue = tableObj.rows[0].cells[0].innerHTML;
	}
  	//cellDateDiv.style.display = "";
  	if((hoverInfoValue!=null) && (hoverInfoValue!="")){
  		var hoverDiv = document.getElementById("hoverDiv");
  		//var X= objCellDate.getBoundingClientRect().right+document.documentElement.scrollLeft;
  		//var Y =objCellDate.getBoundingClientRect().bottom +document.documentElement.scrollTop;
  		e=e||event;
		var X= e.clientX;
		var Y =e.clientY;

		var posX = objCellDate.offsetLeft + objCellDate.offsetWidth;

		var posY = objCellDate.offsetTop;

		var aBox = objCellDate;
		do {

		   aBox = aBox.offsetParent;

		   posX += aBox.offsetLeft;

		   posY += aBox.offsetTop;

		}while (aBox.tagName != "BODY");

		X = posX;
		Y = posY;
		hoverDiv.style.position = "absolute";
  		hoverDiv.style.left = X - document.getElementById("mainDiv").scrollLeft ;
  		hoverDiv.style.top = Y - document.getElementById("mainDiv").scrollTop;
  		hoverDiv.style.display = "";
  		hoverDiv.innerHTML = cellDateDiv.innerHTML;
  		hoverDiv.style.position = "absolute";
  		//node.appendChild(hoverDiv);
  	}
  	//alert(cellDateDiv.innerHTML);
  }
  //关闭说明信息
  function hoverDivClose(){
  	var hoverDiv = document.getElementById("hoverDiv");
  	if(hoverDiv != null)
  	{
  		hoverDiv.style.display = "none";
  	}
  }
  function nextmonth(The_Year,The_Month){
   if (The_Month==12)
    chooseday(The_Year+1,1,0);
   else
    chooseday(The_Year,The_Month+1,0);
  }

  function prevmonth(The_Year,The_Month){
   if (The_Month==1)
    chooseday(The_Year-1,12,0);
   else
    chooseday(The_Year,The_Month-1,0);
  }

  function prevyear(The_Year,The_Month){
   chooseday(The_Year-1,The_Month,0);
  }

  function nextyear(The_Year,The_Month){
   chooseday(The_Year+1,The_Month,0);
  }

  //取得日期对应的星期
  function getDayOfWeek(dayValue){
    var day = new Date(Date.parse(dayValue)); //将日期值格式化
    //alert(day.getDay());
    return day.getDay();//0为星期日
  }
  //参数sComnRestDays格式 "6,0,...";0为星期日，是休息日的星期的连接串
  function ShowCalender(The_Year,The_Month,The_Day,Firstday,sComnRestDays){
   var showstr;
   var Month_Day;
   var ShowMonth;
   var today;
   today = new Date();
   //取得统一设置的通用休息日
   var comnRestDayArray = new Array();
   //sComnRestDays = "6,0,1";
   comnRestDayArray = sComnRestDays.split(",");
   switch (The_Month)
   {
    case 1 : ShowMonth = "<fmt:message key='mr.label.month1'/>"; Month_Day = 31; break;
    case 2 :
     ShowMonth = "<fmt:message key='mr.label.month2'/>";
     if (RunNian(The_Year))
      Month_Day = 29;
     else
      Month_Day = 28;
     break;
    case 3 : ShowMonth = "<fmt:message key='mr.label.month3'/>"; Month_Day = 31; break;
    case 4 : ShowMonth = "<fmt:message key='mr.label.month4'/>"; Month_Day = 30; break;
    case 5 : ShowMonth = "<fmt:message key='mr.label.month5'/>"; Month_Day = 31; break;
    case 6 : ShowMonth = "<fmt:message key='mr.label.month6'/>"; Month_Day = 30; break;
    case 7 : ShowMonth = "<fmt:message key='mr.label.month7'/>"; Month_Day = 31; break;
    case 8 : ShowMonth = "<fmt:message key='mr.label.month8'/>"; Month_Day = 31; break;
    case 9 : ShowMonth = "<fmt:message key='mr.label.month9'/>"; Month_Day = 30; break;
    case 10 : ShowMonth = "<fmt:message key='mr.label.month10'/>"; Month_Day = 31; break;
    case 11 : ShowMonth = "<fmt:message key='mr.label.month11'/>"; Month_Day = 30; break;
    case 12 : ShowMonth = "<fmt:message key='mr.label.month12'/>"; Month_Day = 31; break;
   }
   var contextPath = v3x.baseURL;
   showstr = "";
   showstr = "<Table cellpadding=0 cellspacing=0  width=95% align=center valign=top>" ;
   showstr +=  "<tr><td align=center class='calanderTitle' style='border:1px solid #D3D3D5;border-bottom:0px;'><table><tr><td width=0 style='cursor:hand' onclick=prevyear("+The_Year+"," + The_Month + ") ><img border=0 align=absMiddle src='"+contextPath+"/common/images/leftMounth.gif' style='height:7px;width:11px;'></td><td width=60 align=center>&nbsp;" + The_Year + "&nbsp;</td><td width=0 onclick=nextyear("+The_Year+","+The_Month+")  style='cursor:hand' ><img border=0 align=absMiddle src='"+contextPath+"/common/images/rightMounth.gif' style='height:7px;width:11px;'></td><td width=30></td><td width=0 style='cursor:hand' onclick=prevmonth("+The_Year+","+The_Month+") ><img border=0 align=absMiddle src='"+contextPath+"/common/images/leftMounth.gif' style='height:7px;width:11px;'></td><td width=60 align=center >" + ShowMonth + "</td><td width=0 onclick=nextmonth("+The_Year+","+The_Month+")  style='cursor:hand' ><img border=0 align=absMiddle src='"+contextPath+"/common/images/rightMounth.gif' style='height:7px;width:11px;'></td></tr></table></td></tr>";
   showstr +=  "<tr><td align=center width=100% colspan=6>";
   showstr +=  "<table cellpadding=0 cellspacing=1 border=0 bgcolor=#C7C8CA width=100%"+" id="+The_Month+"_mon"+">";
   showstr += "<Tr align=center class='calanderTitle2' height=21px> ";
   showstr += "<td id='week0' style='color:#000000'><fmt:message key='mr.label.0'/></td>";
   showstr += "<td id='week1' style='color:#000000'><fmt:message key='mr.label.1'/></td>";
   showstr += "<td id='week2' style='color:#000000'><fmt:message key='mr.label.2'/></td>";
   showstr += "<td id='week3' style='color:#000000'><fmt:message key='mr.label.3'/></td>";
   showstr += "<td id='week4' style='color:#000000'><fmt:message key='mr.label.4'/></td>";
   showstr += "<td id='week5' style='color:#000000'><fmt:message key='mr.label.5'/></td>";
   showstr += "<td id='week6' style='color:#000000'><fmt:message key='mr.label.6'/></td>";
   showstr += "</Tr><tr>";

   for (i=1; i<=Firstday; i++){
    showstr += "<Td align=center bgcolor=#ffffff>&nbsp;</Td>";
   }
    var year = today.getFullYear();
	var month = today.getMonth() + 1;
	var currentDayNum = getTdId(year,month,today.getDate());
   for (i=1; i<=Month_Day; i++){
  	var bgColor = "#ffffff";
  	var titleStr = getTitleStr(The_Year,The_Month,i);
  	var tdId = getTdId(The_Year,The_Month,i);
  	var weekNum = parseInt(String(getDayOfWeek(tdId)));
  	for(var k=0;k<comnRestDayArray.length;k++){
  		if(weekNum == parseInt(comnRestDayArray[k])){
  			bgColor = "#c1d9ff";
  			break;
  		}
  	}
  	var strTD=" ";
	//-----bug:35540 start author:MENG
	if(tdId>currentDayNum){
		strTD=" style='cursor:hand'";
	}
	//-----bug:35540 end
  	showstr += "<td id=" + tdId +" height=50px width=14% align=left valign=top "+" bgcolor=" + bgColor+strTD+ "  onmouseover='showInfo(this,event)' onmouseout='hoverDivClose()' onclick=clickDay(this,event," + The_Year + "," + The_Month + "," + i + ")>" + i + titleStr + "</td>";
  	Firstday = (Firstday + 1)%7;
  	if ((Firstday==0) && (i!=Month_Day)) showstr += "</tr><tr>";
   }
   if (Firstday!=0) {
    for (i=Firstday; i<7; i++)
     showstr += "<td align=center bgcolor=#ffffff>&nbsp;</td>";
    showstr += "</tr>";
   }

   showstr += "</tr></table>";
   showstr +=  "<table cellpadding=0 cellspacing=0 border=1 bordercolor=#ffffff width=95%>";
   showstr += "<Tr align=center bgcolor=#ffffff> ";
      showstr += "<td></td>";
   showstr += "</Tr></table></td></tr></table>";
   cc.innerHTML = showstr;
  }
  //设置单独设置的工作日期和休息日期
  //参数sSpicalWorkDays格式 "2010/09/30||id||flag||info,2010/10/01||id||flag||info,..."
  function setSpicalDays(sSpicalWorkDays){
  	//sSpicalWorkDays = "2010/10/01||id||2||国情";
  	var spicalWorkDaysArray = new Array();
  	spicalWorkDaysArray = sSpicalWorkDays.split("↗");
  	if(spicalWorkDaysArray.length>0 && sSpicalWorkDays!=""){
  		for(var i=0;i<spicalWorkDaysArray.length;i++){
  		            var spicalWorkDayStr = spicalWorkDaysArray[i];
  		            var spicalWorkDayStrArray = spicalWorkDayStr.split(":");
  		            var spicalWorkDayNum = spicalWorkDayStrArray[0];
  		            var spicalWorkDayId = spicalWorkDayStrArray[1];
  					var spicalRestDayFlag = spicalWorkDayStrArray[2];//0工作日；1休息日；2法定休息日
					var info = spicalWorkDayStrArray[3];//说明信息
  					//info = info.escapeHTML();
  					spicalRestDayFlag = parseInt(spicalRestDayFlag);
  					var objCellDate = document.getElementById(spicalWorkDayNum);
  				 	switch (spicalRestDayFlag)
  					 {
  					  case 0 : 	objCellDate.style.backgroundColor="#ffffff"; break;
  					  case 1 : 	objCellDate.style.backgroundColor="#c1d9ff"; break;
  					  case 2 : 	objCellDate.style.backgroundColor='#ffc497'; break;
  					 }
  					 var cellDateDiv = document.getElementById("div_"+spicalWorkDayNum);
  					 cellDateDiv.innerHTML = "<input id='dayFlag_"
  						 					+spicalWorkDayNum
  						 					+"' type='hidden' value='"
  											+spicalRestDayFlag
  											+"'/>"
  											+"<input id='dayInfo_"
  											+spicalWorkDayNum
  											+"' type='hidden' value='"
  											+info
  											+"'/>"
  											+"<input id='spicalWorkDayId_"
  											+spicalWorkDayNum
  											+"' type='hidden' value='"
  											+spicalWorkDayId
  											+"'/>"
  											+"<table width='100%' height='100%' id='innerInfo_table_"
											+spicalWorkDayNum
											+"'/>"
  	        								+"<tr id='innerInfo'>"
											+"<td>"
  											+info.escapeHTML()
											+"<td>"
  											+"</tr>"
  											+"</table>"
  											;
  		    }
  	}
  }

  function openConfigWin(){
	    getA8Top().workTimeWin = getA8Top().$.dialog({
	    	title:"<fmt:message key='mr.label.title'/>",
	    	transParams:{'parentWin':window},
	    	url: "${workTimeSetUrl}?method=openWorkTimeConfig&year="+The_Year+"&month="+The_Month+"&workTimeStr="+workTimeStr+"&sComnRestDays="+sComnRestDays,
	    	width: 450,
            height: 300,
            isDrag:false
	    });
        
  }
  
  function fnConfigWinCollBack (returnValues) {
	     if(returnValues=="true"){
	    	    getA8Top().workTimeWin.close();
	            var worktimeForm = document.getElementById("worktimeForm");
	            worktimeForm.submit();
	            alert("<fmt:message key='mr.alert.success'/>");
	     } else if (returnValues=="close") {
	    	 getA8Top().workTimeWin.close();
	     }
  }
  

  function showSyncSpecialDiv(){
  	var specialDaySyncDivObj = document.getElementById("specialDaySyncDiv");
	var syncCheckBoxObj = document.getElementById("syncCheckBox");
	if(syncCheckBoxObj.checked){
		specialDaySyncDivObj.style.display = "";
	}else{
		specialDaySyncDivObj.style.display = "none";
	}
  }

function checkUIAndSysTime(year,month,day){
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "workTimeSetManager", "checkUIAndSysTime", false);
		requestCaller.addParameter(1,'Integer',year);
		requestCaller.addParameter(2, "Integer", month);
		requestCaller.addParameter(3, "Integer", day);
		rs = requestCaller.serviceRequest();
		return rs;
  	}
  	catch (ex1) {
  		alert("Exception : " + ex1);
		return "false";
  	}
}
function openGroupSpecialDaySetDlg(){
	getA8Top().openGroupSpecialDayWin = getA8Top().$.dialog({
        title:"<fmt:message key='mr.label.title.group'/>",
        transParams:{'parentWin':window},
        url: "${workTimeSetUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month+"&showGroupSpeSet=true",
        width: 600,
        height: 500,
        isDrag:false
    });
}

/**
*指定年、月的最后一天
*/
function getLastDayOfMonth(The_Year,The_Month){
var Month_Day = 31;
switch (The_Month){
    case 1 : Month_Day = 31; break;
    case 2 :
     if (RunNian(The_Year))
      Month_Day = 29;
     else
      Month_Day = 28;
     break;
    case 3 :  Month_Day = 31; break;
    case 4 :  Month_Day = 30; break;
    case 5 :  Month_Day = 31; break;
    case 6 :  Month_Day = 30; break;
    case 7 :  Month_Day = 31; break;
    case 8 :  Month_Day = 31; break;
    case 9 :  Month_Day = 30; break;
    case 10 :  Month_Day = 31; break;
    case 11 :  Month_Day = 30; break;
    case 12 :  Month_Day = 31; break;
}
return Month_Day;
}
</script>
<script language="JavaScript">
	 var The_Year,The_Day,The_Month;
	 var isGroupAdmin = '${isGroupAdmin}';
	 var today;
	 var Firstday;
	 today = new Date();
	 The_Day = today.getDate();
	 if("${year}" != String.valueOf(today.getFullYear()) || "${month}" != String.valueOf(today.getMonth()+1)){
		The_Day = 0;
	 }
	 The_Year = today.getFullYear();
	 The_Month = today.getMonth() + 1;
	 The_Year = ${year};
	 The_Month = ${month};
	 Firstday = GetWeekday(The_Year,The_Month);


	/*var today4check;
	today4check = new Date();
	var currentDayNum4Check = getTdId(today4check.getYear(),(today4check.getMonth()+1),today4check.getDate());
	var systemTimeCheck = true;
	if(currentDayNum4Check!=systemDateNum){
		systemTimeCheck = false;
		alert("系统时间和客户端时间不一致，请检查设置。");
	}*/

	 //设置通用的工作日和休息日，参数sComnRestDays格式 "6,0,...";0为星期日，是休息日的星期的连接串
	  var sComnRestDays = "${v3x:toHTML(comnRestDayStr)}";
	 //显示日历
	 ShowCalender(The_Year,The_Month,The_Day,Firstday,sComnRestDays);
	 //设置当前日期
	 //if(The_Month!=2){
	 var date = getLastDayOfMonth(The_Year,The_Month);
	 if(date>today.getDate())
	 	date = today.getDate();
	 var currentDayNum = getTdId(today.getFullYear(),today.getMonth() + 1,today.getDate());
	 var currentDay = document.getElementById(currentDayNum);
//	 currentDay.style.backgroundColor="#FFD76A";
	if (currentDay) {
		currentDay.style.borderWidth="4px";
		currentDay.style.borderStyle="solid";
		currentDay.style.borderColor="#FFD76A";
	}
	 /*}else{
		 if(RunNian(The_Year)){
		 	if(today.getDate()<=29){
				var currentDayNum = getTdId(The_Year,The_Month,today.getDate());
	 			var currentDay = document.getElementById(currentDayNum);
	 			currentDay.style.backgroundColor="#FFD76A";
			}
		 }else{
		 	if(today.getDate()<=28){
				var currentDayNum = getTdId(The_Year,The_Month,today.getDate());
	 			var currentDay = document.getElementById(currentDayNum);
	 			currentDay.style.backgroundColor="#FFD76A";
			}
		 }
	 }*/

	 //设置特殊的工作日和非工作日
	  var sSpicalWorkDays = "${v3x:escapeJavascript(specialWorkDayStr)}";
	  //alert(sSpicalWorkDays);
	 setSpicalDays(sSpicalWorkDays);
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
	 }
	 var workTimeStr = "${workTimeStr}";
	 var workTimeStrArray = workTimeStr.split(",");
	 document.getElementById("amWorkTimeBeginTime").innerHTML = workTimeStrArray[0];
	 document.getElementById("amWorkTimeEndTime").innerHTML = workTimeStrArray[1];
	 document.getElementById("pmWorkTimeBeginTime").innerHTML = workTimeStrArray[2];
	 document.getElementById("pmWorkTimeEndTime").innerHTML = workTimeStrArray[3];

	var d = new Date();
	var currentYear = d.getFullYear(); // d.getYear();
	var currentMonth = d.getMonth() + 1;
	var yearNumtemp = "${year}";
	var monthNumtemp = "${month}";

	var systemTimeCheckStr = checkUIAndSysTime(d.getFullYear()*1,d.getMonth()*1,d.getDate()*1);
	var systemTimeCheck;
	if(systemTimeCheckStr == "true"){
		systemTimeCheck = true;
	}else{
		systemTimeCheck = false;
	}
	if(!systemTimeCheck){
		alert(_("workTimeSetLang.timeSet_alertUISysError"));
	}
	if(yearNumtemp>=currentYear&&systemTimeCheck){
		document.getElementById("submitBtn").disabled = false;
		var syncFlagRadioButtons = document.getElementsByName("syncFlag");
  		for(var i=0;i<syncFlagRadioButtons.length;i++){
	  		if(syncFlagRadioButtons[i].value=="1"){
				syncFlagRadioButtons[i].disabled = false;
				syncFlagRadioButtons[i].checked = true;
	  		}else{
	  			if(monthNumtemp<currentMonth&&yearNumtemp==currentYear){
					syncFlagRadioButtons[i].disabled = true;
				}else{
					syncFlagRadioButtons[i].disabled = false;
				}
	  		}
  		}
	}
	else{
		document.getElementById("submitBtn").disabled = true;
		document.getElementById("submitBtn").className = "button-default-2";
		document.getElementById("syncCheckBox").disabled = true;
		var syncFlagRadioButtons = document.getElementsByName("syncFlag");
  		for(var i=0;i<syncFlagRadioButtons.length;i++){
	  		syncFlagRadioButtons[i].disabled = true;
  		}
	}
	if(sComnRestDays!=""){
		var comnRestDayArray4ReSetColor = sComnRestDays.split(",");
		for(var i=0;i<comnRestDayArray4ReSetColor.length;i++){
	  		var weekNum4Color = comnRestDayArray4ReSetColor[i];
			var weekObj = document.getElementById("week"+weekNum4Color);
				weekObj.style.color = "#921314";
		}
	}

</script>
</html>