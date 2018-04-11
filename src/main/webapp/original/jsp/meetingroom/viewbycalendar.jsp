<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title></title>
	<%@ include file="headerbyopen.jsp" %>
		<style>
			td {
			 font-family: Arial, Helvetica, sans-serif;
			 font-size: 12px;
			}
			.titleDiv {
				font-family: Arial;font-size: 12px;line-height: 14px;
				border: 1px solid #000000;
				background-color: #66FF00;
				margin-left:5px;margin-top:3px;padding-left:3px;padding-top:1px;padding-bottom:1px;
				position: relative;
				left: 12px;top: -12px;
				width: 62px;
			}

		</style>
	</head>
<body style="margin-top:10px;">
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
<tr><td id="cc" align="center">
</td></tr></table><form name="calendarForm"></form>
</body>

<script language="JavaScript">
function getTitleStr(The_Year,The_Month,The_Day){
	if(The_Month < 10) {
  		The_Month = "0" + The_Month;
 	}
 	if(The_Day < 10) {
 		The_Day = "0" + The_Day;
 	}
 	var Firstday;
 	var completely_date;
 	if (The_Day!=0)
 		completely_date = The_Year + "-" + The_Month + "-" + The_Day;
 	else
  		completely_date = "No Choose";
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
 document.location = "${mrUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month;
 parent.document.frames["listFrame"].location = "${mrUrl }?method=listView&day="+The_Year+"-"+The_Month+"-01";
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
 ShowCalender(The_Year,The_Month,The_Day,Firstday);
}

function clearTdBorder(){
	var ns = document.getElementsByName("selecttd");
	for(var i = 0; i < ns.length; i++){
		ns[i].className = "noSelected";
	}
}

function clickDay(node,The_Year,The_Month,The_Day) {
clearTdBorder();
node.className = "selected";
 if(The_Month < 10) {
  The_Month = "0" + The_Month;
 }
 if(The_Day < 10) {
  The_Day = "0" + The_Day;
 }
 var Firstday;
 var completely_date;
 if (The_Day!=0)
  completely_date = The_Year + "-" + The_Month + "-" + The_Day;
 else
  completely_date = "No Choose";
 parent.document.frames["listFrame"].location = "${mrUrl }?method=listView&day="+completely_date;
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

function ShowCalender(The_Year,The_Month,The_Day,Firstday){
 var showstr;
 var Month_Day;
 var ShowMonth;
 var today;
 today = new Date();
 
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
 showstr +=  "<table cellpadding=0 cellspacing=1 border=0 bgcolor=#C7C8CA width=100%>";
 showstr += "<Tr align=center bgcolor=#E8F3FF height=21px> ";
 showstr += "<td><font color=#921314><fmt:message key='mr.label.7'/></font></td>";
 showstr += "<td><font color=#000000><fmt:message key='mr.label.1'/></font></td>";
 showstr += "<td><font color=#000000><fmt:message key='mr.label.2'/></font></td>";
 showstr += "<td><font color=#000000><fmt:message key='mr.label.3'/></font></td>";
 showstr += "<td><font color=#000000><fmt:message key='mr.label.4'/></font></td>";
 showstr += "<td><font color=#000000><fmt:message key='mr.label.5'/></font></td>";
 showstr += "<td><font color=#921314><fmt:message key='mr.label.6'/></font></td>";
 showstr += "</Tr><tr>";
 
 for (i=1; i<=Firstday; i++)
  showstr += "<Td align=center bgcolor=#ffffff>&nbsp;</Td>";
 
 for (i=1; i<=Month_Day; i++){
 	var cN = "noSelected";
  if ((The_Year==today.getYear()) && (The_Month==today.getMonth()+1) && (i==today.getDate())){
   bgColor = "#FFD76A";
   cN = "selected";
  }
  else{
   bgColor = "#ffffff";
  }
  
  if (The_Day==i) bgColor = "#FFFFCC";
  var titleStr = getTitleStr(The_Year,The_Month,i);
  showstr += "<td id='selecttd' height=50px width=14% align=left valign=top class="+cN+" bgcolor=" + bgColor + " style='cursor:hand' onclick=clickDay(this," + The_Year + "," + The_Month + "," + i + ")>" + i + titleStr + "</td>";
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
</script>

<script language="JavaScript">
 var The_Year,The_Day,The_Month;
 var today;
 var Firstday;
 today = new Date();
 The_Day = today.getDate();
 if("${year}" != String.valueOf(today.getYear()) || "${month}" != String.valueOf(today.getMonth()+1)){
	The_Day = 0;
 }
 The_Year = today.getYear();
 The_Month = today.getMonth() + 1;
 The_Year = ${year};
 The_Month = ${month};
 Firstday = GetWeekday(The_Year,The_Month);
 ShowCalender(The_Year,The_Month,The_Day,Firstday);
</script><!-- 
<div id=showdate></div>
--></html>
<script type="text/javascript">
${initTitleScription}
</script>