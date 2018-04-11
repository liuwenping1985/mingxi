<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/plan/planListCommon.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
var sourceId = "${param.sourceId}";
var currentYear = "${year}";
var currentMonth = "${month}";
var selectYear=currentYear,selectMonth="";
function initTable(){
	var table = $("#planList").ajaxgrid({
		colModel : [ {
            display : "${ctp:i18n('plan.grid.label.title')}",
            name : 'title',
            width : '38%',
            sortable : true,
            align : 'left'
          }, {
  	        display : "${ctp:i18n('plan.grid.label.creator')}",
  	        name : 'createUserName',
  	        width : '15%',
  	        sortable : true,
  	        align : 'left'
          }, {
            display : "${ctp:i18n('plan.grid.label.begintime')}",
            name : 'startTime',
            cutsize : 10,
            width : '15%',
            sortable : true,
            align : 'left'
          }, {
            display : "${ctp:i18n('plan.grid.label.endtime')}",
            name : 'endTime',
            cutsize : 10,
            width : '15%',
            sortable : true,
            align : 'left'
          }, {
            display : "${ctp:i18n('plan.grid.label.finishratio')}",
            name : 'finishRatio',
            width : '15%',
            sortable : true,
            align : 'left'
          }],
          vChange: true,
          vChangeParam: {
              overflow: "auto",
              autoResize:true
          },
          parentId: "listArea",
          managerName : "planRefRelationManager",
          managerMethod : "getRefBySourceIdForList",
          click : showPlanDetail,
          render : rend
		});
}
function showPlanDetail(data, r, c){
	var open = openPlan(data.id,null,true,null,loadRelPlans,true);
}

var initToolbar = function(){
    toolbar = $("#calenderBtn").toolbar({
    	isPager : false,
        toolbar : [ {
          id : "calender",
          name : "${ctp:i18n('taskmanage.select.calendar.label')}",
          className : "calendar_icon",
          click : showCalPanel
        }]
      });
};

var calenderDialog;
var showCalPanel = function(){
	$("#year").html(selectYear!=""?selectYear:currentYear);
	showSelects();
	if(calenderDialog){
		calenderDialog.close();
		calenderDialog=null;
	}
	//else{
		calenderDialog = $.dialog({
			id:'calenderDialog',
		    width: 180,
		    height: 160,
		    type: 'panel',
		    htmlId: 'calDiv',
		    targetId: 'calender_a',
			shadow:false,
			checkMax:false,
			panelParam:{
				'show':false,
				'margins':false
			}
			});
	//}
};
calBtnObj = $("#calenderBtn");
function closeCalDialog(){
	if (calenderDialog) {
        var dialog = $("#" + calenderDialog.id);
        mouseBind(dialog, calBtnObj, calenderDialog, "calenderDialog");
   }
}

var sourceIdAndTime = function(id,timeScope){
	this.sourceId = id;
	this.timeScope = timeScope;
};
var obj = new sourceIdAndTime();
var  loadRelPlans = function(){
	$("#planList").ajaxgridLoad(obj);
};
$(document).ready(function(){
	initToolbar();
	initTable();
	obj.sourceId = sourceId;
	loadRelPlans();
	$(".month").click(selectThisMonth);
});

function formatMonth(month){
	if(month.length==1){
		return "0"+month;
	}
	return month;
}

function selectThisMonth(){
	selectMonth = $(this).attr("value");
	selectYear=$("#year").html();
	showSelects();
	calenderDialog.close();
	calenderDialog=null;
	obj.timeScope = selectYear+"-"+selectMonth+"-01";
	loadRelPlans();
}

function prevYear(){
	$("#year").html(parseInt($("#year").html())-1);
	showSelects();
}
function nextYear(){
	$("#year").html(parseInt($("#year").html())+1);
	showSelects();
}

//#FFD76A 单击
//#C7C8CA 默认选中
function showSelects(){
	$(".month").parent().css({background:''});  //先全部清除选中
	var year = $("#year").html();
	currentYear,currentMonth,selectYear,selectMonth;
	if(year==currentYear){   //是当前年，选中当前月份
// 		$(".month[value='"+formatMonth(currentMonth)+"']").parent().css({background:'#FFD76A'});//选中当前月份
// 		if(selectYear==currentYear&&formatMonth(selectMonth)!=formatMonth(currentMonth)){//如果选中的也是当前年且选中不为当前月，则标记出选中月
			$(".month[value='"+formatMonth(selectMonth)+"']").parent().css({background:'#C7C8CA'}); 
// 		}
	}else{   //不是当前年
		if(year==selectYear){ //如果是选中年  则将选中月标记
			$(".month[value='"+formatMonth(selectMonth)+"']").parent().css({background:'#C7C8CA'});
		}
	}
}



$(function(){
    var _bDiv_h_base=$(window).height()-$(".flexigrid .bDiv").height();
    $(window).resize(function(){
        $(".flexigrid .bDiv").height($(window).height()-_bDiv_h_base)
    });
    var viewType = "${param.viewType}";
    if(window.parent.validateTask) {
        $("body").bind("click", window.parent.validateTask);
    }
})
</script>
<body>
	<div id='planListArea' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:30,maxHeight:30,minHeight:30,border:false,sprit:false">
            <div id="description" class="left">
                <span class='left font_size12 margin_t_10 margin_l_5'>${ctp:i18n("taskmanage.refplan.label")}</span>
            </div>
            <div id="calenderBtn" class="right"></div>
            <div id="calDiv" class="hidden" style="z-index: 65535" onmouseout="closeCalDialog()"> 
            	<table width="180" height="160" style="text-align: center;">
            		<tr>
            			<td  width="45"><span class="ico16 select_unselect" onclick="prevYear()"></span></td>
            			<td colspan="2"><span id="year">${year}</span>${ctp:i18n("taskmanage.year.label")}</td>
            			<td  width="45"><span class="ico16 select_selected" onclick="nextYear()"></span></td>
            		</tr>
            		<tr>
            			<td width="45"><span class="month" value="01">${ctp:i18n("taskmanage.january.label")}</span></td>
            			<td width="45"><span class="month" value="02">${ctp:i18n("taskmanage.february.label")}</span></td>
            			<td width="45"><span class="month" value="03">${ctp:i18n("taskmanage.march.label")}</span></td>
            			<td width="45"><span class="month" value="04">${ctp:i18n("taskmanage.april.label")}</span></td>
            		</tr>
            		<tr>
            			<td><span class="month" value="05">${ctp:i18n("taskmanage.may.label")}</span></td>
            			<td><span class="month" value="06">${ctp:i18n("taskmanage.june.label")}</span></td>
            			<td><span class="month" value="07">${ctp:i18n("taskmanage.july.label")}</span></td>
            			<td><span class="month" value="08">${ctp:i18n("taskmanage.august.label")}</span></td>
            		</tr>
            		<tr>
            			<td><span class="month" value="09">${ctp:i18n("taskmanage.september.label")}</span></td>
            			<td><span class="month" value="10">${ctp:i18n("taskmanage.october.label")}</span></td>
            			<td><span class="month" value="11">${ctp:i18n("taskmanage.november.label")}</span></td>
            			<td><span class="month" value="12">${ctp:i18n("taskmanage.december.label")}</span></td>
            		</tr>
            	</table>
            </div>
        </div>
        <div class="layout_center over_hidden" id="listArea" layout="border:false">
	        <table id="planList" style="display: none"></table>
        </div>
    </div>
</body>
</html>