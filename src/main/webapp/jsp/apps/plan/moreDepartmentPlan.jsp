<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planListCommon.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>moreDepartmentPlan</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript">
$().ready(function(){
  var initDepartmentList = function () {
    grid = $("#myPlanList").ajaxgrid({
      colModel : [ {
        display : 'planId',
        name : 'planId',
        width : '5%',
        sortable : false,
        align : 'center',
        isToggleHideShow:false,
        type : 'checkbox'
      }, {
        display : "${ctp:i18n('plan.grid.label.title')}",
        name : 'title',
        width : '25%',
        sortable : true,
        align : 'left',
        isToggleHideShow:false
      },{
          display : "${ctp:i18n('plan.grid.label.creator')}",
          name : 'createUserName',
          width : '10%',
          sortable : true,
          align : 'left'
      },{
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
      }, {
        display : "${ctp:i18n('plan.grid.label.status')}",
        name : 'planStatus',
        width : '15%',
        sortable : true,
        align : 'left'
      }],
      width:"auto",
      showTableToggleBtn: false,
      slideToggleBtn: true,
      parentId: $('.layout_center').eq(0).attr('id'),
      vChange: true,
	  vChangeParam: {
          overflow: "hidden",
		  autoResize:true
      },
      managerName : "planManager",
      managerMethod : "getDepartmentPlan",
      click:showPlan,
      render : rend
    });
  }();
  
  
 
  var toolbar = function(){
	   $("#tb4depPlan").toolbar({
	      toolbar : [ {
	          id : "cancelPublish",
	          name : "${ctp:i18n('plan.normal.button.cancelpublish')}",
	          iconClass : "ico16",
	          click : function() {
	            	//取消发布
					cancelPublish();
	
	          }
	        }]
  		});
  	}();
});
function back(){
	getA8Top().main.history.back();
}
var grid;
function cancelPublish(){
	var rows = grid.grid.getSelectRows();
	if(rows.length==0){
			$.alert("${ctp:i18n('plan.normal.button.choosecancelplan')}");
			return;
		}
	var ids = "";
	for(var i=0;i<rows.length;i++){
		ids+=rows[i].planId;
		if(i!=rows.length-1){
			ids+=",";
			}
		}
	$("#cancelForm #planIds").val(ids);
	var ret = "${ctp:i18n('plan.cancelpublish.confirm')}";
	var retMsg = "${ctp:i18n('plan.cancelpublish.notallowed')}";
	var planMag = new planManager();
	var obj = new Object();
	obj.planIds = ids;
	obj.depId = '${param.departmentId}';
	obj.spaceId = '${param.spaceId}';
	if(planMag.checkCancelPublish(obj)){
    	var confirm = $.confirm({
            'msg' : ret,
            ok_fn : function() {
                $("#cancelForm").jsonSubmit();
            },
            cancel_fn : function() {
            }
        });
	} else {
	    $.alert(retMsg);
	}
}
getCtpTop().showMoreSectionLocation("${ctp:i18n('plan.type.departmentplan')}");
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:35,maxHeight:65,minHeight:65,border:false,sprit:false">
           <div id="tb4depPlan"></div>
        </div>   
        <div class="layout_center" layout="border:false">
	        <table id="myPlanList" style="display: none"></table>
            <div id="grid_detail">
               <iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0"></iframe>
            </div>
        </div>
    </div>
    <form id="cancelForm" name="cancelForm" method="post" action="plan.do?method=cancelPublish">
 		<input type="hidden" id="planIds" name="planIds" value=""/>
        <input type="hidden" id="departmentId" name="departmentId" value="${departmentId}"/>
 	</form>
</body>
</html>