<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file="headerbyopen.jsp" %>
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
        </style>
        <title><fmt:message key='mr.label.worktimeset.group'/></title><base target="_self"/>
    </head>
    <body scroll='no'>
        <form action="" id="timeConfigForm" method="POST">
            <a id="reload" style="display:none"></a>
            <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="20" class="PopupTitle">
                        <fmt:message key='mr.label.title.group'/>
                    </td>
                </tr>
                <tr>
                    <td class="bg-advance-middel" height="100%">
                        <div style="overflow: hidden">
                            <div id="hoverDiv" style="display: none; height: 40px; width: 95px; background-color: #eaf0f6">
                            </div>
                            <table>
                                <tr>
                                    <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="">
                                        <tr>
                                            <td>
                                                <table border="0" align="center" cellpadding="0" cellspacing="0" style="width: 90%;">
                                                    <tr>
                                                        <td height="50">
                                                            <fieldset style="padding: 20px;">
                                                                <legend>
                                                                    <b><fmt:message key='mr.label.restdayset'/></b>
                                                                </legend>
                                                                <br>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td id=cc>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <table>
                                                                                <tr valign="bottom">
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td style='background-color:#ffd76a;border:1px solid #D3D3D5; height:20px;width:20px'>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <fmt:message key='mr.label.curretday'/>
                                                                                    </td>
                                                                                    <td style='border:1px solid #D3D3D5; height:10px;width:20px'>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <fmt:message key='mr.label.workday'/>
                                                                                    </td>
                                                                                    <td style='background-color:#c1d9ff;border:1px solid #D3D3D5; height:20px;width:20px'>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <fmt:message key='mr.label.restday'/>
                                                                                    </td>
                                                                                    <td style='background-color:#ffc497;border:1px solid #D3D3D5; height:20px;width:20px'>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <fmt:message key='mr.label.restdayinlaw'/>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </fieldset>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <iframe name="showGroupFrame" frameborder="0" style="display:none;">
        </iframe>
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
        		  	var reloadObj = document.getElementById("reload");
        			reload.href = "${workTimeSetUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month+"&showGroupSpeSet=true";
        			reload.click();
        		  	//document.reload = "${workTimeSetUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month+"&showGroupSpeSet=true";
        		  	//var formObj = document.forms[0];
                   //ormObj.action = "${workTimeSetUrl}?method=viewByCalendar&year="+The_Year+"&month="+The_Month+"&showGroupSpeSet=true";
                  //formObj.submit();
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
                  
                  //显示说明信息
                  function showInfo(node){
                  	var cellDateDiv = document.getElementById("div_"+node.id);
                  	var objCellDate = document.getElementById(node.id);
                	var tableObj = cellDateDiv.lastChild;
                	var hoverInfoValue = null;
                	if(tableObj!=null){
                		hoverInfoValue = tableObj.rows[0].cells[0].innerHTML;
                	}
                  	//cellDateDiv.style.display = "";
              		var hoverDiv = document.getElementById("hoverDiv");
                  	if((hoverInfoValue!=null) && (hoverInfoValue!="")){
                  		//var X= objCellDate.getBoundingClientRect().right+document.documentElement.scrollLeft;
                  		//var Y =objCellDate.getBoundingClientRect().bottom +document.documentElement.scrollTop;
                		var X= event.clientX;
                		var Y =event.clientY;
                			
                		var posX = objCellDate.offsetLeft + objCellDate.offsetWidth;;
                		
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
                  		hoverDiv.style.left = X;
                  		hoverDiv.style.top = Y ;
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
                   showstr += "<Tr align=center bgcolor=#E8F3FF height=21px> ";
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
                  	showstr += "<td id=" + tdId +" height=50px width=14% align=left valign=top "+" bgcolor=" + bgColor + " onmouseover='showInfo(this)' onmouseout='hoverDivClose()')>" + i + titleStr + "</td>";
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
                	 if("${year}" != String.valueOf(today.getYear()) || "${month}" != String.valueOf(today.getMonth()+1)){
                		The_Day = 0;
                	 }
                	 The_Year = today.getYear();
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
                	  var sComnRestDays = "${comnRestDayStr}";
                	 //显示日历
                	 ShowCalender(The_Year,The_Month,The_Day,Firstday,sComnRestDays);
                	 //设置当前日期
                	 /*
                	 if(The_Month!=2){
                	 	 var currentDayNum = getTdId(The_Year,The_Month,today.getDate());
                		 var currentDay = document.getElementById(currentDayNum);
                		 currentDay.style.backgroundColor="#FFD76A";
                	 }else{
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
                	 var date = getLastDayOfMonth(The_Year,The_Month);
                     if(date>today.getDate())
                        date = today.getDate();
                     var currentDayNum = getTdId(today.getYear(),today.getMonth() + 1,today.getDate());
                     var currentDay = document.getElementById(currentDayNum);
                     if (currentDay) {
                         currentDay.style.backgroundColor="#FFD76A";
                     }
                	 //设置特殊的工作日和非工作日
                	  var sSpicalWorkDays = "${v3x:escapeJavascript(specialWorkDayStr)}";
                	  //alert(sSpicalWorkDays);
                	 setSpicalDays(sSpicalWorkDays);
            
    </script>
</html>
