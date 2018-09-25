var dDate = new Date();
//var dCurMonth = dDate.getMonth();
//var dCurDayOfMonth = dDate.getDate();
//var dCurYear = dDate.getFullYear();

var dCurMonth = myMonthTop;
var dCurDayOfMonth = myDayOfMonth;
var dCurYear = myYear;

//var myMonth = dCurMonth;
//var myDayOfMonth = dCurDayOfMonth;
//var myYear = dCurYear;

var myMonth = myMonthTop;
var myDayOfMonth = myDayOfMonth;
var myYear = myYear;

var objPrevElement = new Object();
var year = 0;
var month = 0;



function fToggleColor(myElement) {
	var toggleColor = "#ff0000";
	if (myElement.id == "calDateText") {
		if (myElement.color == toggleColor) {
			myElement.color = "";
		} else {
			myElement.color = toggleColor;
		}
	} else if (myElement.id == "calCell") {
		for (var i in myElement.children) {
			if (myElement.children[i].id == "calDateText") {
				if (myElement.children[i].color == toggleColor) {
					myElement.children[i].color = "";
				} else {
					myElement.children[i].color = toggleColor;
				}
			}
		}
	}
}

function fSetSelectedDay(myElement){

   if (myElement.id == "calCell") {
	   if (!isNaN(parseInt(myElement.children["calDateText"].innerHTML))) {
		   myElement.bgColor = "#c0c0c0";
           objPrevElement.bgColor = "";
		   document.all.calSelectedDate.value = parseInt(myElement.children["calDateText"].innerHTML);
		   objPrevElement = myElement;
		   getDate=document.all.calSelectedDate.value;
		   getYear=submitform.tbSelYear.value;
		   getMonth=submitform.tbSelMonth.value;

		   submitform.calSelectedMonth.value=getMonth;
		   submitform.calSelectedYear.value=getYear;

		   submitform.submit();
      }
   }
}


function OnMouseDown(add,selWay){  //selWay:选择方式

  var obj=event.srcElement;
  var element=obj.parentElement;
  var k
  if(!element.id)
      k=obj.innerHTML;
  else
      k=element.innerHTML;
  var day=k;
  year = eval("c_Year").innerHTML;
  month = eval("c_Month").innerHTML;
  if(month == 12){
	  if(add == 1){
		year ++ ;
		month = 1;
	  }
  }else{
      //month += add;
  }

  //getSpacialDate(year+"-"+month+"-"+day);
  if(isNaN(day)==true) day=-1;
  if(day != "" && day != " " && day != null && day != NaN){
	  doSubmit(year+"",month+"",day+"",selWay) ;}
}


function doSubmit(x,y,z,selWay){
    var dCalDate = new Date(x, y-1,1);
	  var week_firstDay = dCalDate.getDay();
	  var iDaysInMonth = fGetDaysInMonth(y, x);
    var myWeek = 1;
    for(var k=1;k<=iDaysInMonth;k++){
        if(week_firstDay>6){
           myWeek++;
           week_firstDay = 0;//星期日
        }
        week_firstDay++;
        if(z==k)break;
    }
    /*if(document.submitform.calSelectedWeek){document.submitform.calSelectedWeek.value=myWeek;}else{return false;}
    if(document.submitform.calSelectedDep){document.submitform.calSelectedDep.value=document.all.selDep.options[document.all.selDep.selectedIndex].value;}else{return false;}
    if(document.submitform.calSelectedYear){document.submitform.calSelectedYear.value=x;}else{return false;}
    if(document.submitform.calSelectedMonth){document.submitform.calSelectedMonth.value=y;}else{return false;}
    if(document.submitform.calSelectedDate){document.submitform.calSelectedDate.value=z;}else{return false;}
    document.submitform.submit();*/
    /*str = x+"-"+y+"-"+z;
    parent.myform.selectDate.value=str;
    parent.doIt();*/
    fnSubmit(x,y,z,myWeek,selWay);
}


function fGetDaysInMonth(iMonth, iYear) {
	var dPrevDate = new Date(iYear, iMonth, 0);

	return dPrevDate.getDate();
}


function fBuildCal(iYear, iMonth, iDayStyle) {
	var common = "<table border='0' cellpadding='0' cellspacing='0' style='MARGIN-LEFT: 4px; MARGIN-RIGHT: 4px'>"
	common += "<tr><td></td>";
	common += "<td></td>";

	var sunday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/ri.gif' ></td></tr></table>";
	var monday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/1.gif' ></td></tr></table>";
	var tuesday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/2.gif' ></td></tr></table>";
	var wednesday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/3.gif' ></td></tr></table>";
	var thursday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/4.gif' ></td></tr></table>";
	var friday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/5.gif' ></td></tr></table>";
	var saturday = common+"<td><!--<IMG border=0 height=11 src='images/xin.gif' ><IMG border=0 height=11 src='images/qi.gif' >--><IMG border=0 height=11 src='images/6.gif' ></td></tr></table>";

	var aMonth = new Array();
	aMonth[0] = new Array(7);
	aMonth[1] = new Array(7);
	aMonth[2] = new Array(7);
	aMonth[3] = new Array(7);
	aMonth[4] = new Array(7);
	aMonth[5] = new Array(7);
	aMonth[6] = new Array(7);
	var dCalDate = new Date(iYear, iMonth,1);
	var iDayOfFirst = dCalDate.getDay();
	var iDaysInMonth = fGetDaysInMonth(iMonth+1, iYear);//alert("iDayOfFirst="+iDayOfFirst+",iDaysInMonth="+iDaysInMonth)
	var iVarDate = 1;
	var i, d, w;
	if (iDayStyle == 2) {
		aMonth[0][0] = "Sunday";
		aMonth[0][1] = "Monday";
		aMonth[0][2] = "Tuesday";
		aMonth[0][3] = "Wednesday";
		aMonth[0][4] = "Thursday";
		aMonth[0][5] = "Friday";
		aMonth[0][6] = "Saturday";
	} else if (iDayStyle == 1) {
		aMonth[0][0] = _('V3XLang.calendar_weeks0');
		aMonth[0][1] = _('V3XLang.calendar_weeks1');
		aMonth[0][2] = _('V3XLang.calendar_weeks2');
		aMonth[0][3] = _('V3XLang.calendar_weeks3');
		aMonth[0][4] = _('V3XLang.calendar_weeks4');
		aMonth[0][5] = _('V3XLang.calendar_weeks5');
		aMonth[0][6] = _('V3XLang.calendar_weeks6');
	} else if (iDayStyle == 3){   //用图片组织  --本程序使用
		aMonth[0][0] = sunday;
		aMonth[0][1] = monday;
		aMonth[0][2] = tuesday;
		aMonth[0][3] = wednesday;
		aMonth[0][4] = thursday;
		aMonth[0][5] = friday;
		aMonth[0][6] = saturday;
	}else {
		aMonth[0][0] = "Su";
		aMonth[0][1] = "Mo";
		aMonth[0][2] = "Tu";
		aMonth[0][3] = "We";
		aMonth[0][4] = "Th";
		aMonth[0][5] = "Fr";
		aMonth[0][6] = "Sa";
	}
	for (d = iDayOfFirst; d < 7; d++) {
		aMonth[1][d] = iVarDate;
		iVarDate++;
	}
	for (w = 2; w < 7; w++) {
		for (d = 0; d < 7; d++) {
			if (iVarDate <= iDaysInMonth) {
				aMonth[w][d] = iVarDate;
				iVarDate++;
			}
		}
	}
	return aMonth;
}

/**
 * 输出日历
 * iYear 年
 * iMonth 月
 * iDayStyle 输出的样式 分别为 1 2 3 三种
 * add 要增加月份的增量
 * selWay 选择方式:按年 year，按月 month，按周 week，按日 day
 */
function fDrawCal(iYear, iMonth, iDayStyle,add,selWay) {

	var myMonth;
    var contextPath = v3x.baseURL;
	myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	var tmp = iMonth +1;
	
	document.write("<table border='0' cellspacing='0' cellpadding='0' width='100%'><tr>");
	document.write("<td height='22px' width='50px' bgcolor='#e3efff'  align='center'>");
    document.write("<table border='0' cellPadding='0' cellSpacing='0' onmousedown=\"this.className='down'\" onmouseup=\"this.className='over'\" onmouseout=\"this.className='out'\" onmouseover=\"this.className='over'\" onclick='ChangeYearAndMonth(0)'  height='12' style='margin-top: 2'>");
	document.write("<tr><td width='100%' align='center'>&nbsp;<img border='0' src = '"+contextPath+"/apps_res/plan/images/arrow_left.gif'>&nbsp;</td>");

    document.write("</tr></table></td><td bgcolor='#e3efff' height='22' id='YearAndMonth'><p align='center' style='margin-left: 20; margin-right: 20'><table id='tblYearAndMonth' border='0' cellPadding='0' cellSpacing='0'><tr><td width='100%' align='center'><span id='c_Year'>"+iYear+"</span> / <span id='c_Month'>");
	document.write(tmp+"</span></td></tr></table></p></td>");
	
	if(selWay=="month"){
		document.all.tblYearAndMonth.className="down";
	}
	
	document.write("<td height='22' width='50px' bgcolor='#e3efff' align='center'>");
	document.write("<table border='0' cellPadding='0' cellSpacing='0' onmousedown=\"this.className='down'\" onmouseup=\"this.className='over'\" onmouseout=\"this.className='out'\" onmouseover=\"this.className='over'\" onclick='ChangeYearAndMonth(1)'  height='12' style='margin-top: 2'>");
	document.write("<tr><td width='100%' align='center'>&nbsp;<img border='0' src='"+contextPath+"/apps_res/plan/images/arrow_right.gif"+"'>&nbsp;</td></tr>");
	document.write("</table></td></tr></table>");

	document.write("<table border='0' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF' style='border-top: 2 solid #FFFFFF; border-bottom: 1 solid #6593cf' width='100%'><tr id='draw'>");
	document.write("<td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][0]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][1]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][2]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][3]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][4]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][5]+"</td><td align='center' nowrap height='17' style='border-bottom: 1 solid #6593cf'>");
	document.write(myMonth[0][6]+"</tr>");

  	var week_clicked = 1;
	for (w = 1; w < 7; w++) {
		document.write("<tr>");
		for (d = 0; d < 7; d++) {

      if(myDayOfMonth==myMonth[w][d]) week_clicked = w;
      if (!isNaN(myMonth[w][d])) {
           document.write("<td align='middle' onclick=\"javascript:OnMouseDown("+add+",'week');\" style='CURSOR:pointer' id='calCell"+w+d+"' oncontextmenu = 'event.returnValue=false'>");
      }else{
           document.write("<td align='middle' style='CURSOR:pointer' id='calCell"+w+d+"' oncontextmenu = 'event.returnValue=false'>");
      }
			document.write("<table border='0' cellpadding='0' cellspacing='0'><tr><td><p style='MARGIN-TOP: 2px' align='center'>");

			if (!isNaN(myMonth[w][d])) {
				document.write("<font onclick=\"javascript:OnMouseDown("+add+",'week');\" name='calDateText' id='calDateText' style='CURSOR:pointer'>" + myMonth[w][d] + "</font></p></td></tr></table>");
			} else {
				document.write("<font color='#808080' id='calDateText' name='calDateText' style='CURSOR:pointer'>&nbsp;</font></p></td></tr></table>");
			}
			document.write("</td>");

		}
		document.write("</tr>");
	}
	document.write("</table>");
	
	document.write("<table border='0' cellspacing='0' cellpadding='0' style='border-top: 2 solid #FFFFFF;' align=center>");
	
	if(window.opener != null){
		
		document.write("<tr><td><input type=button value='"+v3x.getMessage("PLANLang.plan_date_today")+"' name=today onclick='todaySubmit();'></td></tr>");
	}

  	if(selWay=="week"){//日计划按周选时，有灰色带
	    for (d = 0; d < 7; d++) {
	         if (!isNaN(myMonth[week_clicked][d])){
	              eval("document.all.calCell"+week_clicked+d).style.backgroundColor = "#ece9d8";
	         }
	    }
  	}

}

/*function fnChangeColor(objTd){//2003-10-03 cx Add
  try{
  for(var i=0;i<objTd.parentNode.parentNode.rows.length;i++){
      objTd.parentNode.parentNode.rows[i].style.backgroundColor="#ffffff";
  }
  objTd.parentNode.style.backgroundColor="yellow";
  }catch(ex){
     alert("错误："+ex.description);
  }
}*/

function fDrawCal_Month(iYear, iMonth, iDayStyle,add) {
	var myMonth;

	myMonth = fBuildCal(iYear, iMonth, iDayStyle);


	document.write("<table  border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'  width='100%'><tr id='draw'  bgcolor='#ededed'>");
	document.write("<td  bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][0]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][1]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][2]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][3]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][4]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][5]+"</td><td bgcolor='#ededed'  align='center' nowrap height='17' style='border-bottom: 1 solid #808080'>");
	document.write(myMonth[0][6]+"</tr>");

	for (w = 1; w < 6; w++) {

		document.write("<tr >");
		for (d = 0; d < 7; d++) {

			document.write("<td  height='50'  style='CURSOR:pointer' id=calCell onclick='OnMouseDown("+add+");' oncontextmenu = 'event.returnValue=false'>");

			//document.write("<table border='0' height='50' cellpadding='0' cellspacing='0' ><tr><td><p style='MARGIN-TOP: 2px' align='center'>");

			if (!isNaN(myMonth[w][d])) {
				document.write("<div align='right' valign='top'><font  name='calDateText' id='calDateText' style='CURSOR:pointer' title='"+eval("c_Year").innerHTML+" 年 "+eval("c_Month").innerHTML+" 月 "+myMonth[w][d]+" 日'>" + myMonth[w][d] + "</font></p></div>");
			} else {
				document.write("<font color='#808080' name='calDateText' id='calDateText' style='CURSOR:pointer'>&nbsp;</font>");
			}
			document.write("</td>");
		}
		document.write("</tr>");
	}
	document.write("</table>");
}





function fDrawCal_Week(iYear,iMonth,iDay,iDayStyle,add) {
	var myMonth;
	var myWeek;
	var myWeekDay = new Array(7);

	myMonth = fBuildCal(iYear, iMonth, iDayStyle);

       for (w = 1; w < 6; w++) {
		for (d = 0; d < 7; d++) {
			if(myMonth[w][d]==iDay){ myWeek=w;break}
			}
		}



document.write(" <table width='100%' border='0' cellspacing='0' cellpadding='0'>");
document.write("  <tr> ");
document.write("    <td>");
document.write("      <table width='100%'border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'  >");
document.write("        <tr>");
document.write("          <td bgcolor='#ededed' >日</td>");
document.write("        </tr>");
document.write("        <tr>");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("    <td>");
document.write("      <table width='100%' border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'  >");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >一</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("  </tr>");
document.write("  <tr> ");
document.write("    <td>");
document.write("      <table width='100%' border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'  >");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >二</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("    <td>");
document.write("      <table width='100%'  border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'>");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >三</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("  </tr>");
document.write("  <tr> ");
document.write("    <td>");
document.write("      <table width='100%'  border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'>");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >四</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("    <td>");
document.write("      <table width='100%'  border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'>");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >五</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("  </tr>");
document.write("  <tr> ");
document.write("    <td>");
document.write("      <table width='100%' border='1' align='center' cellspacing='1' cellpadding='1' bordercolorlight='#CCCCCC' bordercolordark='#FFFFFF' bgcolor='#FFFFFF'>");
document.write("        <tr> ");
document.write("          <td bgcolor='#ededed' >六</td>");
document.write("        </tr>");
document.write("        <tr> ");
document.write("          <td height='50'>&nbsp;</td>");
document.write("        </tr>");
document.write("      </table>");
document.write("    </td>");
document.write("    <td>");

document.write("    </td>");
document.write("  </tr>");
document.write("</table>");


}



/**
 * 单击按钮， 按上下月份翻转
 * flag 翻转标志 为0时为向前翻；为1时为向后翻；
 */

function ChangeYearAndMonth(flag){
  var obj_Year=eval("c_Year");
  var obj_Month = eval("c_Month");
  var tmp_month = eval("tmpmonth");
  year = obj_Year.innerHTML;
  month = (obj_Month.innerHTML);
  if(flag==1){
     if(month>=12){
         month=1
         year++;
     }
     else
         month++;
   }
  else if(flag==0){
     if(month<=1){
         month=12;
         year--;
     }
     else
         month--;
  }
  obj_Year.innerHTML=year;
  obj_Month.innerHTML = month;
  var v3x = new V3X();
  _ = v3x.getMessage;
  tmp_month.innerHTML = _('V3XLang.calendar_months'+(month-1));
  innerhtml="";
  //fUpdateCal(year,month,dDate.getDate());
  fUpdateCal(year,month-1,myDayOfMonth);

  var tds = document.getElementsByTagName("TD");//2003-10-05 cx 当翻月时清除当前的选择
  for(var j=0;j<tds.length;j++){
      if(tds[j].id.indexOf("calCell")!=-1)tds[j].style.backgroundColor = "#ffffff";
  }
}


function fUpdateCal(iYear, iMonth,iDate) {
	//if (iDate==null) iDate = dCurDayOfMonth;
	if (iDate==null) iDate = myDayOfMonth;

	myMonth = fBuildCal(iYear, iMonth);
	objPrevElement.bgColor = "";
	for (var w = 1; w < 7; w++) {
		for (d = 0; d < 7; d++) {
			if (!isNaN(myMonth[w][d])) {
				if(document.getElementsByName('calDateText')[((7*w)+d)-7]){
					document.getElementsByName('calDateText')[((7*w)+d)-7].innerHTML = myMonth[w][d];
					document.getElementsByName('calDateText')[((7*w)+d)-7].title=eval("c_Year").innerHTML+" 年 "+eval("c_Month").innerHTML+" 月 "+myMonth[w][d]+" 日";
					document.getElementsByName('calDateText')[((7*w)+d)-7].color="";
				}
				if (myMonth[w][d]== iDate) {
					thiselement=document.getElementsByName('calDateText')[((7*w)+d)-7];
					//thiselement.color="red";
	        	}
			} else {
				if(document.getElementsByName('calDateText')[((7*w)+d)-7]){
					document.getElementsByName('calDateText')[((7*w)+d)-7].innerHTML = " ";
					document.getElementsByName('calDateText')[((7*w)+d)-7].title="";
				}
        	}
      	}
   	}
	
	var font_Tag = document.getElementsByTagName("font");
	for(var i=0;i<font_Tag.length;i++){
		if(font_Tag[i].innerHTML == "&nbsp;"){
			font_Tag[i].parentNode.parentNode.bgColor="#ffffff";
		}else{
			if(font_Tag[i].innerHTML == iDate){
				font_Tag[i].parentNode.parentNode.bgColor="#9999ff";
				if(eval("c_Year").innerHTML == dCurYear && eval("c_Month").innerHTML == (dCurMonth+1) && font_Tag[i].innerHTML == dCurDayOfMonth) font_Tag[i].title = eval("c_Year").innerHTML+" 年 "+eval("c_Month").innerHTML+" 月 "+font_Tag[i].innerHTML+" 日  今天";

			//}
			//else if(font_Tag[i].innerText==myDayOfMonth){
			//font_Tag[i].parentElement.parentElement.bgColor="#D4D0C8";
			//if(eval("c_Year").innerHTML == dCurYear && eval("c_Month").innerHTML == (dCurMonth+1) && font_Tag[i].innerText == dCurDayOfMonth) font_Tag[i].title = eval("c_Year").innerHTML+" 年 "+eval("c_Month").innerHTML+" 月 "+font_Tag[i].innerText+" 日  今天";
//
			}else{
				font_Tag[i].parentNode.parentNode.bgColor="";
			}
		}
	}
}



