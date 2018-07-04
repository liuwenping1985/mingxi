<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
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
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/TaskUtil.js${v3x:resSuffix()}"></script>
<script type="text/javascript">
  var isA6="${isA6}";
  var type = ${type};
  var toPage = "${param.to}";
  var currentYear = ${ctp:toHTML(currentYear)};
  var currentMonth = ${ctp:toHTML(currentMonth)};
  var currentDay = ${ctp:toHTML(currentDay)};
  var isRef = "${isRef}";
  var searchobj;
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
  function formatStr(str){
	  if(str!=""){
		  var strArr = str.split(",");
		  var newStr = "Department|";
		  for(var i=0,j=strArr.length;i<j;i++){
			  if(i<j-1){
				  newStr = newStr+strArr[i]+",Department|";
			  }else{
				  newStr = newStr+strArr[i];
			  }
		  }
		  return newStr;
	  }
  }
  
  $(function(){
		var maxHeight=$('body').height()-35;
		layout = new MxtLayout({
			  'id':'frameLayout',
			  'northArea':{
				'id': 'northLayoutDiv',
				'height':40,
				'maxHeight':40,
				'minHeight':40,
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
    initPlanManageToolbar();
    initPlanManageTable();
    selectBtnValue =5;
    toolbar.selected("listAll");
    initTable(type, toPage);
    searchobj = $.searchCondition({
        top:7,
        right:10,
		//left:10,
		//bottom:10,
        searchHandler: function(){
			var searchReturnValue = searchobj.g.getReturnValue();
			//alert($.toJSON(searchReturnValue))
			if(searchReturnValue.condition =='deptId'){
				plan.spender  = "";
				plan.replyStatus ="";
				plan.departmentIds = $("#departmentId").val();
				$("#myPlanList").ajaxgridLoad(plan);
			}else if(searchReturnValue.condition =='startMemberName'){
				plan.departmentIds = "";
				plan.replyStatus ="";
				plan.spender = searchReturnValue.value;
				$("#myPlanList").ajaxgridLoad(plan);
			}else if(searchReturnValue.condition =='replyStatus'){
				plan.departmentIds = "";
				plan.spender  = "";
				plan.replyStatus = searchReturnValue.value;
				$("#myPlanList").ajaxgridLoad(plan);
			}else {
			    plan.spender  = "";
			    plan.replyStatus ="";
			    plan.departmentIds = "";
			    $("#myPlanList").ajaxgridLoad(plan);
			}
        },
        conditions: [{
            id: 'deptId',
            name: 'deptId',
            type: 'input',
            text: "${ctp:i18n('plan.queryCondition.department')}",
            value: 'deptId',
            click: function() {
            	var newValue = formatStr($("#departmentId").val());
            	$.selectPeople({
        	        type:'search'
        	        ,panels:'Department'
        	        ,selectType:'Department'
        	        ,minSize:0
        	        ,returnValueNeedType: false
        	        ,showFlowTypeRadio: false
        	        ,onlyLoginAccount:false
        	        ,maxSize:10
        	        ,isNeedCheckLevelScope : false,
        	        params:{
        	        	text:$("#deptId").val(),
            	        value:newValue
        	        }
        	        ,targetWindow:getCtpTop()
        	        ,callback : function(res){
        	           $("#deptId").val(res.text);
        	           $("#departmentId").val(res.value);        	          
        	        }
        	    });
            }
        }, {
        	id: 'spender',
            name: 'spender',
            type: 'input',
            text: "${ctp:i18n('plan.queryCondition.senderName')}",
            value: 'startMemberName'
        },{
            id: 'replyStatus',
            name: 'replyStatus',
            type: 'select',
            text: "${ctp:i18n('plan.queryCondition.replyStatus')}",
            value: 'replyStatus',
			//codecfg : "codeType:'java',codeId:'com.seeyon.apps.samples.test.enums.MyEnums'",
            items: [{
                text: "${ctp:i18n('plan.queryCondition.replyStatus.no')}",
                value: '0,2'
            }, {
                text: "${ctp:i18n('plan.queryCondition.replyStatus.yes')}",
                value: '1'
            }]
        }]
    });
      $("#spender").keypress(function(event) {
        if (getStrLeng($("#spender").val()) >= 1000) {
          event.preventDefault();
        }
      });
      $("#spender").blur(function() {
          if(getStrLeng($("#spender").val()) >= 1000){
            $("#spender").val(cutString($("#spender").val(), 1000));
          }
      });
  });
  
</script>
<script type="text/javascript" src="${path}/apps_res/plan/js/planList.js${v3x:resSuffix()}"></script>
<body class="h100b over_hidden">
	<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_planListHome'"></div>
    <div id='frameLayout' >
        <div id="northLayoutDiv" class="layout_north">
            <div id="tb4Manage"></div>
            <div id="search">
                <!--  <input class="comp font_size12" name="search" readonly type="text" id="selectDep" style="width:130px;"
                    comp="type:'search',fun:'setDeppartment',title:''" deaultValue="<${ctp:i18n('plan.view.query.clickdept')}>" value="<${ctp:i18n('plan.view.query.clickdept')}>"
                    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" onclick="selectDep()">-->
            </div>
        </div>
        <div id="centerLayoutDiv" class="layout_center over_hidden" >
           <table id="myPlanList" style="display: none"></table>
           <input type="hidden" id="departmentId" name="departmentId" />
        </div>
        <div id="eastLayoutDiv" class="layout_east over_hidden" >
            <iframe id="planCalenderFrame" frameBorder="no" style="width: 100%; height: 99%;" scrolling="no" 
                src="plan.do?method=initPlanCalender&type=${ctp:toHTML(type)}&calSelectedYear=${ctp:toHTML(currentYear) }&calSelectedMonth=${ctp:toHTML(currentMonth) }&calSelectedDate=${ctp:toHTML(currentDay)}"></iframe>
        </div>          
        <div id="planContentFrameDiv" class="layout_south over_hidden" >
        	<iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
        </div>
    </div>
</body>
</html>