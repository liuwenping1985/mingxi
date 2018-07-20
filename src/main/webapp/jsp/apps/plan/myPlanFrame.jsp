<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	#southSp_frameLayout{
		border-style:solid;
        border-width:1px;
        border-color:#b6b6b6;
	}
</style>
</head>
<script type="text/javascript" src="${path}/apps_res/plan/js/planList.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript">
var type = ${ctp:toHTML(type)};
var toPage = "${param.to}";
var currentYear = ${ctp:toHTML(currentYear)};
var currentMonth = ${ctp:toHTML(currentMonth)};
var currentDay = ${ctp:toHTML(currentDay)};
var layout;
function gettype(){
	return '${ctp:toHTML(type)}';
}
function getyear(){
	return '${ctp:toHTML(currentYear)}';
}
function getmonth(){
	return '${ctp:toHTML(currentMonth)}';
}
function getday(){
	return '${ctp:toHTML(currentDay)}';
}
$(function(){
	var maxHeight=$('body').height()-35;
	layout = new MxtLayout({
		  'id':'frameLayout',
		  'northArea':{
			'id': 'northLayoutDiv',
			'height':30,
			'maxHeight':30,
			'minHeight':30,
			'border':false,
			'sprit':false
		  },
		  'centerArea':{
			  'id':'centerLayoutDiv',
			  'border':false
		  },
		  'eastArea':{
			'id':'eastLayoutDiv',
			'width':190,
			'minWidth':0,
			'maxWidth':190,
			'border':false
		  },
		  'southArea':{
			  'id':'planContentFrameDiv',
			  'border':false,
			  'height':0,
			  'minHeight':2,
			  'maxHeight':maxHeight,
			  spiretBar:{
				  'show':true,
				  'handlerB':descendContentFrame,
				  'handlerT':expendContentFrame
			  }			  
		  }
	  });
    initMyPlanToolbar();
    initPlanTable(type,toPage);
    selectBtnValue = 4;
    initTable(type,toPage);
});
</script>
<body class="h100b over_hidden">
	<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_planListHome'"></div>
    <div id='frameLayout' class="page_color">
        <div id="northLayoutDiv" class="layout_north page_color" > <!-- layout="height:30,maxHeight:30,minHeight:30,border:false,sprit:false" -->
           <div id="tb4MyPlan"></div>
        </div>
        <div id="centerLayoutDiv" class="layout_center over_hidden" > <!-- layout="border:false" -->
            <table id="myPlanList" style="display: none"></table>
        </div>
        <div id="eastLayoutDiv" class="layout_east over_hidden" ><!-- layout="width:190,minWidth:0,maxWidth:190,border:false" -->
            <iframe id="planCalenderFrame" class="border_t border_l" frameBorder="no" style="width: 100%; height: 99%;" scrolling="no" 
                src="plan.do?method=initPlanCalender&calSelectedYear=${ctp:toHTML(currentYear) }&calSelectedMonth=${ctp:toHTML(currentMonth) }&calSelectedDate=${ctp:toHTML(currentDay)}&type=${ctp:toHTML(type)}"></iframe>
        </div>          
        <!-- layout="border:true,height:0,spiretBar:{show: true,handlerB: descendContentFrame,handlerT: expendContentFrame}" -->
         <div id="planContentFrameDiv" class="layout_south over_hidden" >  
        	<iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
        </div>
    </div>
    <form id="planform" name="planform" action="">
        <table id="planTable">
        <input type="hidden" id="planId">
        <input type="hidden" id="formHTML">
        </table>
    </form>
</body>
</html>