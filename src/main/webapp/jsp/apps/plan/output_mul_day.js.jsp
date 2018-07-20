<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">

var dDate = new Date();

var myMonth,myDayOfMonth,myYear,myPreDay;
// #FFD76A
// #C7C8CA
function OnMouseDown(dom){  //selWay:选择方式
	var day = $(dom).attr("value");
	var year = $("#c_Year").html();
	var month = $("#c_Month").html();
	$(".cday[value!='"+myDayOfMonth+"']").css({background:""});
	if(month==myMonthTop&&year==myYear&&day==myDayOfMonth){
		
	}else{
		$(dom).css({background:"#C7C8CA"});
	}
	myPreDay = day;
	if(isNaN(day)==true){ 
		day=-1;
		return false;
	}
	if(day != "" && day != " " && day != null && day != NaN){
		fnSubmit(year+"",month+"",day+"") ;
	}
}


//获取该月的总天数
function fGetDaysInMonth(iMonth, iYear) {
  var dPrevDate = new Date(iYear, iMonth, 0);
  return dPrevDate.getDate();
}

//构造日期数组
function fBuildCal (iYear, iMonth){
  var aMonth = new Array();
  aMonth[0] = new Array(7);
  aMonth[1] = new Array(7);
  aMonth[2] = new Array(7);
  aMonth[3] = new Array(7);
  aMonth[4] = new Array(7);
  aMonth[5] = new Array(7);
  aMonth[6] = new Array(7);
  var dCalDate = new Date(iYear,iMonth-1,1);
  var iDayOfFirst = dCalDate.getDay();
  var iDaysInMonth = fGetDaysInMonth(iMonth, iYear);
  var iVarDate = 1;
  var i, d, w;

  aMonth[0][0] = "日";
  aMonth[0][1] = "一";
  aMonth[0][2] = "二";
  aMonth[0][3] = "三";
  aMonth[0][4] = "四";
  aMonth[0][5] = "五";
  aMonth[0][6] = "六";
  
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
var fDrawCal = function (iYear, iMonth) {
  var myMonth;
  var contextPath = v3x.baseURL;
  myMonth = fBuildCal(iYear, iMonth);
  var htmlStr="";
  htmlStr+="<table align='center' class='w100b' style='width:180px;height:180px;text-align:center;'>";
  htmlStr+="	<tr class='calenderTitle' align='center'>";
  htmlStr+="      <td colspan='2'>";
  htmlStr+="			<span class='ico16 select_unselect'onclick='ChangeYearAndMonth(0)'></span></td>";
  htmlStr+="		<td colspan='3'id='YearAndMonth'>";
  htmlStr+="			<span id='c_Year'>"+iYear+"</span>/";
  htmlStr+="			<span id='c_Month'>"+iMonth+"</span>";
  htmlStr+="		</td>";
  htmlStr+="		<td colspan='2'>";
  htmlStr+="			<span class='ico16 select_selected'onclick='ChangeYearAndMonth(1)'></span>";
  htmlStr+="		</td>";
  htmlStr+="	</tr>";
  htmlStr+="	<tr id='draw' style='background:#E1EEFF;'>";
  htmlStr+="		<td>";
  htmlStr+=myMonth[0][0]+"</td><td>";
  htmlStr+=myMonth[0][1]+"</td><td>";
  htmlStr+=myMonth[0][2]+"</td><td>";
  htmlStr+=myMonth[0][3]+"</td><td>";
  htmlStr+=myMonth[0][4]+"</td><td>";
  htmlStr+=myMonth[0][5]+"</td><td>";
  htmlStr+=myMonth[0][6]+"</tr>";

  var week_clicked = 1;
  for (w = 1; w < 7; w++) {
      htmlStr+="<tr>";
      for (d = 0; d < 7; d++) {
		    if(myDayOfMonth==myMonth[w][d]) week_clicked = w;
		    //去掉td中onclick事件，否则会重复执行OnMouseDown方法
		   
		    htmlStr+="<td id='calCell"+w+d+"' class='cday' value='"+myMonth[w][d]+"' onclick='OnMouseDown(this)'>";
		    
          	htmlStr+="<span name='calDateText'>";

	        if (!isNaN(myMonth[w][d])) {
	            htmlStr+="" + myMonth[w][d] + "</span>";
	        } else {
	            htmlStr+="<span>&nbsp;</span>";
	        }
	        htmlStr+="</td>";
      }
      htmlStr+="</tr>";
  }
  htmlStr+="</table>";
  $("#divCal").html(htmlStr);
  if(iYear==myYear&&iMonth==myMonthTop){
	if(myPreDay==""||myPreDay==undefined){ myPreDay = myDayOfMonth;}
  	$(".cday[value='"+myDayOfMonth+"']").css({background:"#FFD76A"});
  	
  }
};

/**
* 单击按钮， 按上下月份翻转
* flag 翻转标志 为0时为向前翻；为1时为向后翻；
*/

function ChangeYearAndMonth(flag){
	var obj_Year=eval("c_Year");
	var obj_Month = eval("c_Month");
	year = obj_Year.innerHTML;
	month = (obj_Month.innerHTML);
	if(flag==1){
	   if(month>=12){
	       month=1;
	       year++;
	   }else{
	       month++;
	   }
	}else if(flag==0){
	   if(month<=1){
	       month=12;
	       year--;
	   }else{
	       month--;
	   }
	}
	obj_Year.innerHTML=year;
	obj_Month.innerHTML = month;
	fDrawCal(year,month);
}

function fnSubmit(year,month,day){
	if(typeof(parent.searchobj)!="undefined"){
	   parent.searchobj.g.clearCondition()
	}
     var flag=0;
     month = formatMouth(month);
     var startTime;
     var endTime;
     if(day==-1||day=="-1"){
       startTime=year+"-"+month+"-"+"01 00:00:00";
       endTime = new Date().getMonthEnd(year+"-"+month+"-"+"01") + " 23:59:59";
     }else{
       day = formatMouth(day);
       startTime=year+"-"+month+"-"+day+" 00:00:00";
       endTime=year+"-"+month+"-"+day+" 23:59:59";
     }
     if(parent.plan != null) {
       parent.plan.spender  = "";
       parent.plan.replyStatus ="";
       parent.plan.departmentIds = "";
     }
     parent.plan.startTime = startTime;
     parent.plan.endTime = endTime;
     parent.loadList();
}

function formatMouth(month){
  if(month<10){
    return "0"+month;
  }
  return month;
}
</script>