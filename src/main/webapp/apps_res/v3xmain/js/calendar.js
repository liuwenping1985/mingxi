/*
*	author: misshjn
*	email: misshjn@163.com
*	homepage: www.happyshow.org
*	createDate: 2007-02-23
*/
function HS_DateAdd(interval,number,date){
	number = parseInt(number);
	if (typeof(date)=="string"){var date = new Date(date.split("-")[0],date.split("-")[1],date.split("-")[2])}
	if (typeof(date)=="object"){var date = date}
	switch(interval){
	case "y":return new Date(date.getFullYear()+number,date.getMonth(),date.getDate()); break;
	case "m":return new Date(date.getFullYear(),date.getMonth()+number,checkDate(date.getFullYear(),date.getMonth()+number,date.getDate())); break;
	case "d":return new Date(date.getFullYear(),date.getMonth(),date.getDate()+number); break;
	case "w":return new Date(date.getFullYear(),date.getMonth(),7*number+date.getDate()); break;
	}
}
function checkDate(year,month,date){
	var enddate = ["31","28","31","30","31","30","31","31","30","31","30","31"];
	var returnDate = "";
	if (year%4==0){enddate[1]="29"}
	if (date>enddate[month]){returnDate = enddate[month]}else{returnDate = date}
	return returnDate;
}

function WeekDay(date){
	var theDate;
	if (typeof(date)=="string"){theDate = new Date(date.split("-")[0],date.split("-")[1],date.split("-")[2]);}
	if (typeof(date)=="object"){theDate = date}
	return theDate.getDay();
}
function HS_calender(now, allEvents){
	var lis = "";
	var lastMonthEndDate = HS_DateAdd("d","-1",now.getFullYear()+"-"+now.getMonth()+"-01").getDate();
	var lastMonthDate = WeekDay(now.getFullYear()+"-"+now.getMonth()+"-01");
	var thisMonthLastDate = HS_DateAdd("d","-1",now.getFullYear()+"-"+(parseInt(now.getMonth())+1).toString()+"-01");
	var thisMonthEndDate = thisMonthLastDate.getDate();
	var thisMonthEndDay = thisMonthLastDate.getDay();
	var todayObj = new Date();
	today = todayObj.getFullYear()+"-"+todayObj.getMonth()+"-"+todayObj.getDate();
	
	var count = 0;
	for (i=0; i<lastMonthDate; i++){  // Last Month's Date
		lis = "<td class='lastMonthDate'>"+lastMonthEndDate+"</td>\n" + lis;
		lastMonthEndDate--;
		
		if(count++ % 7 == 6){
			lis += "</tr>\n<tr class='calenderBody'>\n";
		}
	}
	
	for (i=1; i<=thisMonthEndDate; i++){ // Current Month's Date
		var content = "";
		var events = allEvents.get("" + i);
		if(events){
			content = events.join("\n");
		}

		var isToday = today == now.getFullYear()+"-"+now.getMonth()+"-"+i;
		var hasEvent = events != null;

		var currentDay = now.getFullYear()+"-"+(now.getMonth()+1)+"-"+i ;

		lis += "<td class='today-" + isToday + " "  + " hasEvent-" + hasEvent + " cursor-hand' title='"+ content +"' onclick=\"location.href='" + getA8Top().contentFrame.topFrame.calEventURL + "?method=day&selectedDate="+currentDay+"'\" >"+i+"</td>\n";
		
		if(count++ % 7 == 6){
			lis += "</tr>\n<tr class='calenderBody'>\n";
		}
	}
	
	var j=1;
	for (i=thisMonthEndDay; i<6; i++){  // Next Month's Date
		lis += "<td class='nextMonthDate'>"+j+"</td>\n";
		j++;
		if(count++ % 7 == 6){
			lis += "</tr>\n<tr class='calenderBody'>\n";
		}
	}

	var CalenderBox = "" +
			"<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n" +
			"  <tr class='calenderTitle'>\n" +
			"    <td colspan='7'>" + v3xSection.getMessage("V3XLang.calendar_months" + now.getMonth()) + ", " + now.getFullYear() + "</td>\n" +
			"  </tr>\n" +
			"  <tr class='calenderHeader'>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks0") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks1") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks2") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks3") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks4") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks5") + "</td>\n" +
			"    <td>" + v3xSection.getMessage("V3XLang.calendar_weeks6") + "</td>\n" +
			"  </tr>\n" +
			"  <tr class='calenderBody'>"+lis+"</tr>\n" +
			"</table>";
			
		return CalenderBox;
}
function _selectThisDay(d){
//	var boxObj = d.parentNode.parentNode.parentNode.parentNode.parentNode;
//		boxObj.targetObj.value = d.title;
//		boxObj.parentNode.removeChild(boxObj);
}

function CalenderselectYear(obj){
		var opt = "";
		var thisYear = obj.innerHTML;
		for (i=2007; i<=2030; i++){
			if (i==thisYear){
				opt += "<option value="+i+" selected>"+i+"</option>";
			}else{
				opt += "<option value="+i+">"+i+"</option>";
			}
		}
		opt = "<select onblur='selectThisYear(this)' onchange='selectThisYear(this)' style='font-size:11px'>"+opt+"</select>";
		obj.parentNode.innerHTML = opt;
}

function selectThisYear(obj){
	HS_calender(obj.value+"-"+obj.parentNode.parentNode.getElementsByTagName("span")[1].getElementsByTagName("a")[0].innerHTML+"-1",obj.parentNode);
}

function CalenderselectMonth(obj){
		var opt = "";
		var thisMonth = obj.innerHTML;
		for (i=1; i<=12; i++){
			if (i==thisMonth){
				opt += "<option value="+i+" selected>"+i+"</option>";
			}else{
				opt += "<option value="+i+">"+i+"</option>";
			}
		}
		opt = "<select onblur='selectThisMonth(this)' onchange='selectThisMonth(this)' style='font-size:11px'>"+opt+"</select>";
		obj.parentNode.innerHTML = opt;
}
function selectThisMonth(obj){
	HS_calender(obj.parentNode.parentNode.getElementsByTagName("span")[0].getElementsByTagName("a")[0].innerHTML+"-"+obj.value+"-1",obj.parentNode);
}