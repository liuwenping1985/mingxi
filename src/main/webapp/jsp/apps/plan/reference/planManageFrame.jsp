<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
  var type = ${type};
  var toPage = "${param.to}";
  var currentYear = ${currentYear};
  var currentMonth = ${currentMonth};
  var currentDay = ${currentDay};
  var isRef = "${isRef}";

  var initPlanManageTable = function() {
      table = $("#othersPlanList").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'planId',
        width : '10%',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : "${ctp:i18n('plan.grid.label.title')}",
        name : 'title',
        width : '25%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.creator')}",
        name : 'createUserName',
        width : '10%',
        sortable : true,
        align : 'left'
      } , {
        display : "${ctp:i18n('plan.grid.label.begintime')}",
        name : 'startTime',
        cutsize : 10,
        width : '13%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.endtime')}",
        name : 'endTime',
        cutsize : 10,
        width : '13%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.finishratio')}",
        name : 'finishRatio',
        width : '9%',
        sortable : true,
        align : 'left'
      }, {
        display : "${ctp:i18n('plan.grid.label.status')}",
        name : 'planStatusName',
        width : '10%',
        sortable : true,
        align : 'left'
      },{
        display:"${ctp:i18n('plan.grid.label.replystatus')}",
        name:"process",
        width:'10%',
        sortable :true,
        align:'left',
        hidden:false
      }],
      width:"auto",
      onSuccess:bindCheckBoxEvent,
      singleSelect:false,
      showTableToggleBtn: false,
      slideToggleBtn: true,
      vChange: true,
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      parentId: $('.layout_center').eq(0).attr('id'),
      managerName : "planManager",
      managerMethod : "getMyPlan",
      click : showPlan,
      render : rend
    });
  }

  var initPlanManageToolbar = function() {
        toolbar = $("#tb4Manage").toolbar({
          toolbar : [ {
            id : "listTo",
            name : "${ctp:i18n('plan.toolbar.button.to')}",
            iconClass : "",
            click : selectedThis
          }, {
            id : "listCC",
            name : "${ctp:i18n('plan.toolbar.button.cc')}",
            iconClass : "",
            click : selectedThis
          }, {
            id : "listApprize",
            name : "${ctp:i18n('plan.toolbar.button.apprize')}",
            iconClass : "",
            click : selectedThis
          }, {
            id : "listAll",
            name : "${ctp:i18n('plan.toolbar.button.all')}",
            iconClass : "",
            click : selectedThis
          }, {
            id : "planType",
            name : "planType",
            type : "select",
            value : "2",
            text : "${ctp:i18n('plan.type.weekplan')}",
            onchange : getValue,
            items : [ {
              text : "${ctp:i18n('plan.type.dayplan')}",
              value : 1
            }, {
              text : "${ctp:i18n('plan.type.monthplan')}",
              value : 3
            }, {
              text : "${ctp:i18n('plan.type.anyscopeplan')}",
              value : 4
            } ]
          }],
        searchHtml:'search'
        });
        $("#planType").val('${type}');
      }

  function selectedThis() {
        var btns = new Array("listTo", "listCC", "listApprize", "listAll");
        var btnValues = new Array();
        btnValues["listTo"] = 1
        btnValues["listCC"] = 2
        btnValues["listApprize"] = 3
        btnValues["listAll"] = 5
        for ( var i = 0; i < btns.length; i++) {
          if ((this.id).indexOf(btns[i]) == 0) {
            toolbar.selected(btns[i]);//将标签设置为已选中样式
            selectBtnValue = btnValues[btns[i]];
            plan.userType=selectBtnValue;
            if(selectBtnValue==3){
                $("#othersPlanList")[0].grid.toggleCol("7",false);
            }else{
                $("#othersPlanList")[0].grid.toggleCol("7",true);
            }
            loadList();
          } else {
            toolbar.unselected(btns[i]);
          }
        }
      }
  
  $().ready(function() {
    initPlanManageToolbar();
    initPlanManageTable();
    selectBtnValue =5;
    toolbar.selected("listAll");
    initTable(type, toPage);
  });
</script>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,maxHeight:30,minHeight:30,border:false,sprit:false">
            <div id="tb4Manage"></div>
            <div id="search">
                <input class="comp" name="search" readonly type="text" id="selectDep"
                    comp="type:'search',fun:'setDeppartment',title:''" deaultValue="<${ctp:i18n('plan.view.query.clickdept')}>" value="<${ctp:i18n('plan.view.query.clickdept')}>"
                    onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" onclick="selectDep()">
            </div>
        </div>
        <div class="layout_center" layout="border:false">
            <div id="layout2" class="comp" comp="type:'layout'">
                <div class="layout_center over_hidden" layout="border:false">
                    <table id="othersPlanList" style="display: none"></table>
                    <div id="grid_detail">
                        <iframe src="" id="planContentFrame" width="100%" height="100%" frameborder="0"></iframe>
                    </div>
                </div>
                <div class="layout_east over_hidden" layout="width:190,minWidth:0,maxWidth:190">
                    <iframe id="planCalenderFrame" frameBorder="no" style="width: 185px; height: 99%;" scrolling="no" 
                        src="plan.do?method=initPlanCalender&type=2&calSelectedYear=${currentYear }&calSelectedMonth=${currentMonth }&calSelectedDate=${currentDay}"></iframe>
                </div>
            </div>
        </div>
        
    </div>
</body>
</html>