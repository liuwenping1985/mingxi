  var toolbar;
  //初始化“我的计划”页面toolbar
  var initMyPlanToolbar = function() {
    toolbar = $("#tb4MyPlan").toolbar({
      toolbar : [ {
        id : "create",
        name : $.i18n('plan.toolbar.button.add'),
        className : "ico16",
        click : function() {
          //新建计划
          //window.parent.location= "plan.do?method=newPlan&type="+$("#planType").val();
        	openCtpWindow({'url': _ctxPath + "/plan/plan.do?method=newPlan&type="+$("#planType").val(),'id':$.ctx.CurrentUser.id});
        }
      }, {
        id : "update",
        name : $.i18n('plan.toolbar.button.update'),
        className : "ico16 editor_16",
        click : function() {
          //修改计划
          var v = $("#myPlanList").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          if(v.length>1){
            $.alert($.i18n('plan.alert.update.onlyselectone')+"！");
          }else if(v.length===0){
            $.alert($.i18n('plan.alert.planlist.mustselectone'));
          }else{
            if(v[0].publishStatus==="3"){
              $.alert($.i18n('plan.alert.update.cannotupdate')+"！");
            }else{
            	openCtpWindow({'url': _ctxPath + "/plan/plan.do?method=modifyPlan&isModify=1&planId="+v[0].planId,'id':'123123123123123123'});
                //window.parent.location= "plan.do?method=modifyPlan&isModify=1&planId="+v[0].planId;
            }
          }
        }
      }, {
        id : "delete",
        name : $.i18n('plan.toolbar.button.delete'),
        className : "ico16 del_16",
        click : function() {
          var v = $("#myPlanList").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          if(v.length>=1){
            for(i=0;i<v.length;i++){
              if(v[i].publishStatus==="3"){
                var planTitle = escapeStringToHTML(v[i].title);
                $.alert("["+ planTitle +"]"+$.i18n('plan.summary.delete'));
                return false;
              }
            }
            var confirm = $.confirm({
              'msg': $.i18n('plan.sure.delete'),
              ok_fn: function () { 
                var pm = new planManager();
                pm.deletePlan(v);
                loadList(); 
              },
                cancel_fn:function(){}
            });
          }else if(v.length===0){
            $.alert($.i18n('plan.alert.planlist.mustselectone'));
          }else{
          }
        }
      }, {
        id : "transmit",
        name : $.i18n('plan.toolbar.button.translate'),
        className : "ico16 forwarding_16",
        subMenu : [ {
          name : $.i18n('plan.toolbar.button.translate.asCollabration'),
          id   : "collabration",
          click : function() {
            var v = $("#myPlanList").formobj({
              gridFilter : function(data, row) {
                return $("input:checkbox", row)[0].checked;
              }
            });
            if(v.length>1){
              $.alert($.i18n('plan.trans.tansonlyone')+"！");
            }else if(v.length===0){
              $.alert($.i18n('plan.alert.planlist.mustselectone'));
            }else{
                $("#planId").val(v[0].planId);
                try{$("#formHTML").val(window.frames["planContentFrame"].window.getFormHTML());
                }catch(e){}
                planform.action="plan.do?method=forwordCol";
                $("#planform").jsonSubmit({
                  domains : [ "planTable" ],
                  debug : false
                  ,targetWindow:parent
                });
              }
            }
        }, {
          name : $.i18n('plan.toolbar.button.translate.asMail'),
          id   : "mail",
          click : function() {
            //判断邮箱设置
            var v = $("#myPlanList").formobj({
              gridFilter : function(data, row) {
                return $("input:checkbox", row)[0].checked;
              }
            });
            if(v.length>1){
              $.alert($.i18n('plan.trans.tansonlyone')+"！");
            }else if(v.length===0){
              $.alert($.i18n('plan.alert.planlist.mustselectone'));
            }else{
              if(hasDefaultMailBox()){
                $("#planId").val(v[0].planId);
                try{$("#formHTML").val(window.frames["planContentFrame"].window.getFormHTML());
                }catch(e){}
                planform.action="plan.do?method=forwordMail";
                $("#planform").jsonSubmit({
                  domains : [ "planTable" ],
                  debug : false
                  ,targetWindow:parent
                });
              }
            }
          }
        } ]
      }, {
        id : "hideCalender",
        name : $.i18n('plan.toolbar.button.hidecalender'),
        className : "ico16 hide_calendar_16",
        click : hideCalender

      },{
        id : "showCalender",
        name : $.i18n('plan.toolbar.button.showcalender'),
        className : "ico16 hide_calendar_16",
        click : showCalender,
        hiddenFlag: true
      }, {
        id : "planType",
        type : "select",
        value : 2,
        text : $.i18n('plan.type.weekplan'),
        onchange : getValue,
        items : [ {
          text : $.i18n('plan.type.dayplan'),
          value : 1
        }, {
          text : $.i18n('plan.type.monthplan'),
          value : 3
        }, {
          text : $.i18n('plan.type.anyscopeplan'),
          value : 4
        } ]
      }
      ]
    });
    $("#planType").val(gettype());
    toolbar.hideBtn("showCalender");
    toolbar.hideBtn("mail");
    toolbar.hideBtn("collabration");
    if($.ctx.resources.contains('F12_mailcreate')){
      toolbar.showBtn("mail");
    }
    if($.ctx.resources.contains('F01_newColl')){
      toolbar.showBtn("collabration");
    }
  };  
  //初始化“计划管理”页面toolbar；
  var initPlanManageToolbar = function() {
    toolbar = $("#tb4Manage").toolbar({
      toolbar : [ {
        id : "listTo",
        name : $.i18n('plan.toolbar.button.to'),
        iconClass : "",
        className:"ico16 send_16",
        click : selectedThis
      }, {
        id : "listCC",
        name : $.i18n('plan.toolbar.button.cc'),
        iconClass : "",
        className:"ico16 cc_16",
        click : selectedThis
      }, {
        id : "listApprize",
        name : $.i18n('plan.toolbar.button.apprize'),
        iconClass : "",
        className:"ico16 notify_16",
        click : selectedThis
      }, {
        id : "listAll",
        name : $.i18n('plan.toolbar.button.all'),
        iconClass : "",
        className:"ico16 all_16",
        click : selectedThis
      }, {
        id : "hideCalender",
        name : $.i18n('plan.toolbar.button.hidecalender'),
        className : "ico16 hide_calendar_16",
        click : hideCalender
      },{
        id : "showCalender",
        name : $.i18n('plan.toolbar.button.showcalender'),
        className : "ico16 hide_calendar_16",
        click : showCalender
      }, {
        id : "planType",
        name : "planType",
        type : "select",
        value : "2",
        text : $.i18n('plan.type.weekplan'),
        onchange : getValue,
        items : [ {
          text : $.i18n('plan.type.dayplan'),
          value : 1
        }, {
          text : $.i18n('plan.type.monthplan'),
          value : 3
        }, {
          text : $.i18n('plan.type.anyscopeplan'),
          value : 4
        } ]
      }],
    searchHtml:'search'
    });
    $("#planType").val(gettype());
    toolbar.hideBtn("showCalender");
  };
  function hideCalender(){      
    layout.setEast(0);
    toolbar.hideBtn("hideCalender");
    toolbar.showBtn("showCalender");
    reLoadGrid();
  }
  function showCalender(){  
    layout.setEast(190);
    toolbar.hideBtn("showCalender");
    toolbar.showBtn("hideCalender");
    reLoadGrid();
  }
  var rp = 20;
  function reLoadGrid(){
      var obj = $("#myPlanList")[0].p.datas;
      var params = $("#myPlanList")[0].p.params;
      rp = $("#myPlanList")[0].p.rp;
      var cacheListDate = {
              "size": obj.size,
              "total": obj.total,
              "rows": obj.rows,
              "page": obj.page,
              "pages": obj.pages,
              "startAt": 0,
              "dataCount": 20,
              "sortField": null,
              "sortOrder": null
          };
      $(".flexigrid").replaceWith(" <table id='myPlanList' style='display: none'></table>");
      needLoadListDesc = false;
      if(toPage=="myplan"){
          initPlanTable(type,toPage);
      }else{
          initPlanManageTable();
      }
      table.grid.addData(cacheListDate);
      $("#myPlanList")[0].p.params = params;
      rp = $("#myPlanList")[0].p.rp;
  }
  function getValue() {
    var selectType = $(":selected", this).val();
    initPlan(selectType);
    changeCalender(selectType);
    if(toPage == "myplan"&&selectType<4){
      table.grid.pDiv.style.display="none";
    }else{
      table.grid.pDiv.style.display="";
    }
    loadList();

  }

  function initPlan(selectType) {
    plan.planType = selectType;
    plan.startTime = getStartTime(selectType);
    plan.endTime = getEndTime(selectType);
  }

  function changeCalender(selectType) {
    document.getElementById("planCalenderFrame").src = "plan.do?method=initPlanCalender&type="
        + selectType
        + "&calSelectedYear="+getyear()+"&calSelectedMonth="+getmonth()+"&calSelectedDate="+getday();
  }
  var selectBtnValue;//主送 抄送 告知 所有
  
  function selectedThis() {
    var btns = new Array("listTo", "listCC", "listApprize", "listAll");
    var btnValues = new Array();
    btnValues["listTo"] = 1;
    btnValues["listCC"] = 2;
    btnValues["listApprize"] = 3;
    btnValues["listAll"] = 5;
    searchobj.g.clearCondition();
    if(plan != null) {
      plan.spender  = "";
      plan.replyStatus ="";
      plan.departmentIds = "";
    }
    for ( var i = 0; i < btns.length; i++) {
      if(this.id == 'listApprize_a'){
    	  searchobj.g.hideItem("replyStatus");
      }else{
    	  searchobj.g.showItem("replyStatus");
      }
      if ((this.id).indexOf(btns[i]) == 0) {
        toolbar.selected(btns[i]);//将标签设置为已选中样式
        selectBtnValue = btnValues[btns[i]];
        plan.userType=selectBtnValue;
        if(isA6=="true"){
        if(selectBtnValue==3){
            $("#myPlanList")[0].grid.toggleCol("7",false);
        }else{
            $("#myPlanList")[0].grid.toggleCol("7",true);
        }
        }else{
       	if(selectBtnValue==3){
            $("#myPlanList")[0].grid.toggleCol("8",false);
        }else{
            $("#myPlanList")[0].grid.toggleCol("8",true);
        }
        }
        loadList();
      } else {
        toolbar.unselected(btns[i]);
      }
    }
  }
  // 初始化计划列表
  //type 计划类型  1.  日计划  2.  周计划  3.  月计划  4.  任意期计划
  //toPage "myplan"我的计划列表   “planmanager” 计划管理列表 
  //
  var table;
  var initPlanTable = function(type, toPage) {
    var needpager = true; //是否需要翻页组件
    if (toPage == "myplan" && type < 4) { //我的计划中除了任意期计划外 其他三种都不需要翻页。
      needpager = false;
    }
      table = $("#myPlanList").ajaxgrid({
      usepager : needpager,
      autoload:false,
      rp:rp,
      colModel : [ {
        display : 'planId',
        name : 'planId',
        width : '8%',
        sortable : false,
        align : 'center',
        type : 'checkbox',
        isToggleHideShow:false
      }, {
        display : $.i18n('plan.grid.label.title'),
        name : 'title',
        width : '30%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.begintime'),
        name : 'startTime',
        cutsize : 10,
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.endtime'),
        name : 'endTime',
        cutsize : 10,
        width : '15%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.finishratio'),
        name : 'finishRatio',
        width : '10%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.status'),
        name : 'planStatusName',
        width : '10%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.publishstatus'),
        name : 'publishStatusName',
        width : '10%',
        sortable : true,
        align : 'left'
      } ],
      vChange: true,
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      width:"auto",
      showTableToggleBtn: false,
      slideToggleBtn: false,
      parentId: $('.layout_center').eq(0).attr('id'),
      managerName : "planManager",
      managerMethod : "getMyPlan",
      click : showPlan,
      dblclick : editPlan,
      onSuccess:loadListDesc,
      onNoDataSuccess:loadListDesc,
      onCurrentPageSort : true,
      render : rend,
      resizable:false
    });
  };
  var initPlanManageTable = function() {
	  if(isA6=="true"){
      table = $("#myPlanList").ajaxgrid({
      autoload:false,
      rp:rp,
      colModel : [ {
        display : 'id',
        name : 'planId',
        width : '5%',
        sortable : false,
        align : 'center',
        type : 'checkbox',
        isToggleHideShow:false
      }, {
        display : $.i18n('plan.grid.label.title'),
        name : 'title',
        width : '26%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.creator'),
        name : 'createUserName',
        width : '10%',
        sortable : true,
        align : 'left'
      } , {
        display : $.i18n('plan.grid.label.begintime'),
        name : 'startTime',
        cutsize : 10,
        width : '13%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.endtime'),
        name : 'endTime',
        cutsize : 10,
        width : '13%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.finishratio'),
        name : 'finishRatio',
        width : '9%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.status'),
        name : 'planStatusName',
        width : '10%',
        sortable : true,
        align : 'left'
      },{
        display : $.i18n('plan.grid.label.replystatus'),
        name:"process",
        width:'10%',
        sortable :true,
        align:'left',
        hidden:false
      }],
      width:"auto",
      showTableToggleBtn: false,
      slideToggleBtn: false,
      vChange: true,
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      parentId: $('.layout_center').eq(0).attr('id'),
      managerName : "planManager",
      managerMethod : "getMyPlan",
      click : showPlan,
      dblclick:showPlanInDialog,
      onSuccess:loadListDesc,
      onNoDataSuccess:loadListDesc,
      onCurrentPageSort : true,
      render : rend,
      resizable:false    
    });
      }else{
      table = $("#myPlanList").ajaxgrid({
      autoload:false,
      rp:rp,
      colModel : [ {
        display : 'id',
        name : 'planId',
        width : '5%',
        sortable : false,
        align : 'center',
        type : 'checkbox',
        isToggleHideShow:false
      }, {
        display : $.i18n('plan.grid.label.title'),
        name : 'title',
        width : '25%',
        sortable : true,
        align : 'left'
      },{
        display : $.i18n('plan.grid.label.isMentioned'),
        name : 'isMentioned',
        width : '7%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.creator'),
        name : 'createUserName',
        width : '10%',
        sortable : true,
        align : 'left'
      } , {
        display : $.i18n('plan.grid.label.begintime'),
        name : 'startTime',
        cutsize : 10,
        width : '11%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.endtime'),
        name : 'endTime',
        cutsize : 10,
        width : '11%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.finishratio'),
        name : 'finishRatio',
        width : '9%',
        sortable : true,
        align : 'left'
      }, {
        display : $.i18n('plan.grid.label.status'),
        name : 'planStatusName',
        width : '10%',
        sortable : true,
        align : 'left'
      },{
        display : $.i18n('plan.grid.label.replystatus'),
        name:"process",
        width:'8%',
        sortable :true,
        align:'left',
        hidden:false
      }],
      width:"auto",
      showTableToggleBtn: false,
      slideToggleBtn: false,
      vChange: true,
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      parentId: $('.layout_center').eq(0).attr('id'),
      managerName : "planManager",
      managerMethod : "getMyPlan",
      click : showPlan,
      dblclick:showPlanInDialog,
      onSuccess:loadListDesc,
      onNoDataSuccess:loadListDesc,
      onCurrentPageSort : true,
      render : rend,
      resizable:false    
    });
      }
  };


  
  var isDepartmentPlan = false;
  
  var showPlan = function(data, r, c) {
      var pm = new planManager();
      pm.checkPotent(data.planId,{
          success:function(ret){
          if(ret=="true"){
              var contentFrame = document.getElementById("planContentFrame");
              var toSrc = "plan.do?method=initPlanDetailFrame&planId="+data.planId;
              contentFrame.src = toSrc;
              //openCtpWindow({'url':toSrc,'id':data.planId});
              if(!isDepartmentPlan){
                  currentHeight=0;
                  expendContentFrame();
              }
          }else if(ret=="false"){
              $.alert($.i18n('plan.alert.nopotent'));
          }else if(ret=="absence"){
              var win = new MxtMsgBox({
                    'title':$.i18n('plan.alert.plansummary.sysmessage'),
                    'type': 0,
                    'imgType':1,
                    'msg': $.i18n('plan.alert.deleted'),
                    ok_fn:function(){
                        loadList();
                    }
                });
          }
        }
      });
  };
  
  var showPlanInDialog = function(data, r, c){
    var pm = new planManager();
    pm.checkPotent(data.planId,{
        success:function(ret){
        if(ret=="true"){
            var toSrc = "plan.do?method=initPlanDetailFrame&planId="+data.planId;
            openCtpWindow({'url':toSrc,'id':data.planId});
        }else if(ret=="false"){
            $.alert($.i18n('plan.alert.nopotent'));
        }else if(ret=="absence"){
            var win = new MxtMsgBox({
                  'title':$.i18n('plan.alert.plansummary.sysmessage'),
                  'type': 0,
                  'imgType':1,
                  'msg': $.i18n('plan.alert.deleted'),
                  ok_fn:function(){
                      loadList();
                  }
              });
        }
      }
    });
  };
  
//刷新列表和下面的内容区
  function refreshPlanListAndContentFrame(){
    if(plan != undefined && loadList!= undefined ){
        loadList();
        currentHeight = 0;
        expendContentFrame();
    }
  }
  var editPlan = function(data, r, c){
    if(data.publishStatus==="3"){
      $.alert($.i18n('plan.alert.update.cannotupdate')+"！");
    }else{
      window.parent.location= "plan.do?method=modifyPlan&isModify=1&planId="+data.planId;
    }
  };

  var rend = function(txt, data, r, c,col) {
     if(col.name=='title'){
        txt = txt + "&nbsp;" ;
        if(data.hasAttatchment==true){
            txt = txt+"<span class='ico16 affix_16'></span>";
        }
        txt = txt + data.viewTitle;
        return txt;
     }
    if(col.name=='finishRatio'){
        return txt.toString()+"%";
    }
    if(col.name=='process'){
            if(txt==1){
                return $.i18n('plan.desc.replydetail.replyed');
            }
            if(txt != 1){
                return $.i18n('plan.desc.replydetail.unreplyed');
            }
    }
    if(col.name=='planStatus'){
            if(txt=="1"){return $.i18n('plan.execution.state.1');}
            if(txt=="2"){return $.i18n('plan.execution.state.2');}
            if(txt=="3"){return $.i18n('plan.execution.state.3');}
            if(txt=="4"){return $.i18n('plan.execution.state.4');}
            if(txt=="5"){return $.i18n('plan.execution.state.5');}
            return txt;
    }
    if(col.name=="isMentioned"){
    	if(txt=="1"){
    		txt = "<span class='ico16 remind_me_16'></span>"
    	}else{
    		txt = "";
    	}
    	return txt;
    }
    return txt;
  };


  function Plan(userId, accountId,departmentIds,planType, userType, startTime, endTime) {
    this.userId = userId;
    this.accountId = accountId;
    this.departmentIds=departmentIds;
    this.planType = planType;
    this.userType = userType;
    this.startTime = startTime;
    this.endTime = endTime;
  }
  var plan;
  var initTable = function(type, toPage) {
    var userid = $.ctx.CurrentUser.id;
    var accountid = $.ctx.CurrentUser.loginAccount;
    var departmentIds = getDepIds();
    //如果显示传入type参数 则加载指定类型的计划列表，否则获取当前toolbar选中的类型并加载；
    var planType = (type ? type : 2);
    var userType;
    var startTime = getStartTime(planType);
    var endTime = getEndTime(planType);
    if (toPage == "myplan") {
      userType = 4;
    } else {
      userType = selectBtnValue;
    }
    plan = new Plan(userid, accountid,departmentIds,planType, userType, startTime, endTime);
    loadList();
  };

  var listDate;
  var loadList = function() {
    listDate = $("#myPlanList").ajaxgridLoad(plan);
  };

  var loadListByParam = function(planCod) {
    listDate = $("#myPlanList").ajaxgridLoad(planCod);
  };
  var needLoadListDesc = true;
  function loadListDesc(){
      if(needLoadListDesc){
        var contentFrame = document.getElementById("planContentFrame");
        var toSrc = "plan.do?method=listDesc&type="+plan.planType;
        contentFrame.src = toSrc;
      }else{
          needLoadListDesc = true;
      }
  }

  function getStartTime(planType) {
    var start;
    if (planType == 1) { //日计划 返回当日
      start = currentYear + "-" + formatMouthOrDay(currentMonth) + "-"
          + formatMouthOrDay(currentDay) + " 00:00:01";
    } else { //周计划 返回当前月第一天
      start = currentYear + "-" + formatMouthOrDay(currentMonth)
          + "-01 00:00:00";
    }
    return start;
  }

  function getEndTime(planType) {
    var end;
    if (planType == 1) { //日计划 返回当日
      end = currentYear + "-" + formatMouthOrDay(currentMonth) + "-"
          + formatMouthOrDay(currentDay) + " 23:59:59";
    } else { //周计划 返回当前月最后一天（统一为31日）
       end = currentYear + "-" + formatMouthOrDay(currentMonth) +"-"+getLastDay(currentYear,formatMouthOrDay(currentMonth))+ " 23:59:59";
    }
    return end;
  }

  function formatMouthOrDay(month) {
    if (month < 10) {
      return "0" + month;
    }
    return month;
  }
  
  function getLastDay(year,month)        
  {  
     var curArr=[31,28,31,30,31,30,31,31,30,31,30,31];
     if(((year%4==0&&year%100!=0)||(year%400==0)) && parseInt(month) == 2){  //闰年二月份需要返回29
         return 29;
     }else{
         return curArr[month-1];
     }
  }   


  /**
   * 对标题默认值的切换
   * @param isShowBlack 去掉为默认值，显示空白，用在onFocus
   */
  function checkDefSubject(obj, isShowBlack) {
    var dv = getDefaultValue(obj);
    if (isShowBlack && obj.value == dv) {
            obj.value = "";
    }
    else if (!obj.value) {
            obj.value = dv;
    }
}

/**
 * 从input中读取属性为defaultValue的值
 */
function getDefaultValue(obj){
    if(!obj){
        return null;
    }
    var def = obj.attributes.getNamedItem("defaultValue");
    if(!def){
        def = obj.attributes.getNamedItem("deaultValue"); //兼容以前错误的写法
    }
    
    if(def){
        return def.nodeValue;
    }
    
    return null;
}

var departmentIds="";
var departmentString="";


function selectDep(){
  $.selectPeople({
    panels: 'Department',
    selectType: 'Department',
    minSize: 0,
    isConfirmExcludeSubDepartment:true,
    isNeedCheckLevelScope : false,
    params : {
      type: 'selectPeople',
      value : departmentIds,
      text : departmentString
    },
    callback : function(ret) {
      departmentIds = ret.value;
      departmentString = ret.text;
      $("#selectDep").val(departmentString);
    }
});
}

function getDepIds(){
  if(departmentIds!=null&&departmentIds!=""){
    var deps = departmentIds.split(",");
    if(deps!=null&&deps.length>0){
      var ids="";
      for(var i = 0;i<deps.length;i++){
        var dep = deps[i].replace("Department|","");
        ids+=dep;
        if(i!=deps.length-1){
          ids+=",";
        }
      }
      return ids;
    }
  }
  return "";
}

function setDeppartment(){
  plan.departmentIds = getDepIds();
  loadList();
}
var bodyHeight;
var heightLever;
var toolbarHeight = 30;
var currentHeight = 0;
$().ready(function(){
      if(parent.tab_iframe){
          var parantDoc = parent.tab_iframe.document;
          bodyHeight = $("body",parantDoc).height();
          heightLever = [0,(bodyHeight-toolbarHeight)*0.65,bodyHeight-toolbarHeight-5];
      }
      $("#planContentFrame").resize(function(){
          //拖动布局的分割条 没有对应事件，只能在下面的内容区大小改变时重新使表格自适应
          table.grid.resizeGridAuto();
        });
});

function expendContentFrame(){
    if(currentHeight<heightLever.length-1){
        var h=heightLever[++currentHeight];
        layout.setSouth(h);
        //table.grid.resizeGridAuto();
        //table.grid.resizeGridUpDown("up");
        //alert($("#planContentFrame").height());
    }
}

function descendContentFrame(){ 
    if(currentHeight!=0){
        layout.setSouth(heightLever[--currentHeight]);
        //table.grid.resizeGridUpDown("down");
    }
}