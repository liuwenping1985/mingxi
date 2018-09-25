var listDataObj;
var toolbar;
var dialog;
var taskAjax = new taskAjaxManager();
var isContinuous;

//搜索框
function initSearch(){
  var searchobj = $.searchCondition({
    top:2,
    right:10,
    searchHandler: function(){
        var returnValue = searchobj.g.getReturnValue();
        if(returnValue != null){
            var obj = setQueryParams(returnValue);
            $("#departmentTask").ajaxgridLoad(obj);
            showTotal(obj);
        }
    },
    conditions : [{
      id: 'title',
      name: 'title',
      type: 'input',
      text: $.i18n('common.subject.label'),
      value: 'subject'
  },{
    id: 'starttime',
    name: 'starttime',
    type: 'datemulti',
    text: $.i18n('taskmanage.starttime'),
    value: 'plannedStartTime',
    ifFormat:"%Y-%m-%d",
    dateTime: true
	}, {
	    id: 'endtime',
	    name: 'endtime',
	    type: 'datemulti',
	    text: $.i18n('common.date.endtime.label'),
	    value: 'plannedEndTime',
	    ifFormat:"%Y-%m-%d",
	    dateTime: true
	}, {
	    id: 'importent',
	    name: 'importent',
	    type: 'select',
	    text: $.i18n('common.importance.label'),
	    value: 'importantLevel',
	    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
	}, {
	    id: 'statusselect',
	    name: 'statusselect',
	    type: 'select',
	    text: $.i18n('taskmanage.status'),
	    value: 'status',
	    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'",
	    items: [{
	        text: $.i18n('taskmanage.status.unfinished'),
	        value: '1,2'
	    }, {
	        text: $.i18n('common.all.label'),
	        value: '1,2,4,5'
	    },{
	        text: $.i18n('taskmanage.overdue.yes'),
	        value: '-1'
	    }]
	}, {
	    id: 'risk',
	    name: 'risk',
	    type: 'select',
	    text: $.i18n('taskmanage.risk'),
	    value: 'riskLevel',
	    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
	}, {
	    id: 'createUserText',
	    name: 'createUserText',
	    type: 'input',
	    text: $.i18n('common.creater.label'), //创建人
	    value: 'createUser'
	}, {
	    id: 'managersText',
	    name: 'managersText',
	    type: 'input',
	    text: $.i18n('taskmanage.manager'),//负责人
	    value: 'managers'
	}, {
	    id: 'participatorsText',
	    name: 'participatorsText',
	    type: 'input',
	    text: $.i18n('taskmanage.participator'),
	    value: 'participators'
	}, {
	    id: 'inspectorsText',
	    name: 'inspectorsText',
	    type: 'input',
	    text: $.i18n('taskmanage.inspector'),
	    value: 'inspectors'
	}]
    });
    searchobj.g.setCondition('statusselect','1,2,3');
    restrictionInputNumber("title", 160);
}

function selectPerson(valueId, textId, retText, retValue) {
    $.selectPeople({
        type : 'selectPeople',
        panels : 'Department,Team',
        selectType : 'Member',
        isNeedCheckLevelScope : false,
        text : $.i18n('common.default.selectPeople.value'),
        params : {
            text : retText,
            value : retValue
        },
        maxSize : 1,
        callback : function(ret) {
            if (ret) {
                $("#" + textId).val(ret.text);
                $("#" + valueId).val(ret.value);
            }
        }
    });
}

/**
 * 删除任务信息操作
 */
function deleteTask() {
    var idValues = getCheckedId();
    if (idValues == null || idValues.length == 0) {
        $.alert($.i18n('taskmanage.alert.delete.select'));
    } else {
        var bool = checkIfChildExist(idValues);
        var ret = bool == true || bool == "true" ? $.i18n('taskmanage.confirm.delete.contain_childs')
                : $.i18n('taskmanage.confirm.delete');
        var confirm = $.confirm({
            'msg' : ret,
            ok_fn : function() {
                taskAjax.deleteTask(idValues, {
                    success : function(bool) {
                        if (bool == true || bool == "true") {
                            refreshPage();
                        }
                       refreshTotal();
                    },
                    error : function(request, settings, e) {
                        $.error($.i18n('taskmanage.error.delete.server'));
                    }
                });
            },
            cancel_fn : function() {
            }
        });
    }
}


/**
 * 获取列表中选中的id
 */
function getCheckedId() {
    var ids = null;
    var idValue = $("#departmentTask").formobj({
        gridFilter : function(data, row) {
            return $("input:checkbox", row)[0].checked;
        }
    });
    for ( var i = 0; i < idValue.length; i++) {
        if (i == 0) {
            ids = idValue[i].id;
        } else {
            ids += "," + idValue[i].id;
        }
    }
    return ids;
}

/**
 * 删除任务之前，判断选中的任务中是否包含有子任务
 * @param id 任务Id
 */
function checkIfChildExist(id) {
    var bool = false;
    bool = taskAjax.checkIfChildExist(id);
    return bool;
}

function initToolBar() {
    toolbar = $("#toolbar").toolbar({
        toolbar : [{
            id : "new",
            name : $.i18n('common.toolbar.new.label'),
            className : "ico16",
            click : function() {
                newTask(null,null,'new');
            }
        }, {
            id : "delete",
            name : $.i18n('common.toolbar.delete.label'),
            className : "ico16 del_16",
            click : deleteTask
        }, {
            id : "importExcel",
            name : $.i18n('common.toolbar.exportExcel.label'),
            className : "ico16 export_excel_16",
            click : function() {
                exportToExcel();
            }
        },{
            id : "gantt",
            name : $.i18n('taskmanage.viewstyle.gantt'),
            className : "ico16 gtt_16",
            click : function() {
              var projectId = $("[name=projectId]").val();
              var projectPhaseId = $("[name=projectPhaseId]").val();
              var listTypeName = $("[name=listTypeName]").val();
                viewAsGantt(projectId,projectPhaseId,"ProjectAll");
            }
        }]
    });
    if(getUrlPara("isNewTask") == false || getUrlPara("isNewTask")=="false") {
      toolbar.disabled("new");
    }
    if(getUrlPara("projectState")==false || getUrlPara("projectState")=="false"){//项目结束，不显示新建
        toolbar.disabled("new");
    }
    
}

//甘特图方法
function viewAsGantt(projectId, projectPhaseId, listTypeName) {
    var beginDate = $("[name=beginDate]").val();
    var endDate = $("[name=endDate]").val();
      window.location.href = '/seeyon/taskmanage/taskinfo.do?method=ganttChartTasks&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&listTypeName=' + listTypeName +'&beginDate=' +beginDate +'&endDate='+endDate;
  }

/**
 * 导出excel
 */
function exportToExcel() {
    var count = $("#departmentTask")[0].rows.length;
    if (count < 1) {
        $.alert($.i18n('taskmanage.alert.no_records_excel'));
        return false;
    }
    var proPhaseId = getUrlPara("projectPhaseId") == null ? "1" : getUrlPara("projectPhaseId");
    var url = _ctxPath
            + "/taskmanage/taskinfo.do?method=exportToExcel&from="+ getUrlPara("from") +"&userId="+ getUrlPara("userId") 
            +"&projectId="+ getUrlPara("projectId") +"&projectPhaseId="+ proPhaseId +"&condition="
            + $("#conditionText").val() + "&queryValue="
            + $("#firstQueryValueText").val() + "&queryValue1="
            + $("#secondQueryValueText").val() + "&source=mytask";
    var exportExcelIframe = $("#exportExcelIframe");
    exportExcelIframe.attr("src", url);
}

function refreshPage() {
    window.location.reload();
}

/**
 * 新建任务功能
 */
function newTask(){
    var projectId = $("[name=projectId]").val();
    var beginDate = $("[name=beginDate]").val();
    var endDate = $("[name=endDate]").val();
    dialog = $.dialog({
        id : 'new_task',
        url : _ctxPath + '/taskmanage/taskinfo.do?method=newTaskInfo&from=Project&optype=new&projectId='+projectId+'&projectPhaseId='+ getUrlPara("projectPhaseId") +'&beginDate='+beginDate+'&endDate='+endDate+'&flag=9',
        width : 600,
        height : 500,
        title : $.i18n('menu.taskmanage.new'),
        targetWindow : getCtpTop(),
        bottomHTML : "<div class='common_checkbox_box clearfix'><label class='margin_r_10 hand' for='continuous_add'><input id='continuous_add' class='radio_com' name='continuous' value='0' type='checkbox'>&nbsp;&nbsp;"+$.i18n('taskmanage.add.continue')+"</label></div>",
        closeParam:{
            'show':true,
            handler:function(){
                if(isContinuous == true || isContinuous == "true") {
                    refreshPage();
                }
            }
        },
        buttons : [ {
            text : $.i18n('common.button.ok.label'),isEmphasize:true,
            handler : function() {
                var isChecked = dialog.getObjectById("continuous_add")[0].checked;
                var ret = dialog.getReturnValue({'dialogObj' : dialog , 'isChecked' : isChecked , 'runFunc' : refreshPage});
                if(isChecked == true || isChecked == "true") {
                    if(ret == true || ret == "true") {
                        isContinuous = true;
                    }
                }
                afterNewTotal();
            }
        }, {
            text : $.i18n('common.button.cancel.label'),
            handler : function() {
                if(isContinuous == true || isContinuous == "true") {
                    refreshPage();
                }
                dialog.close();
            }
        } ]
    });
}

/**
 * 根据任务类型选择我的任务的显示内容
 * @param type 任务类型
 */
function chooseMyTasks(type) {
    selectedBtnByTaskType(type);
    parent.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=' + type;
}

/**
 * 设置查询条件
 */
function setQueryParams(returnValue) {
    var condition = returnValue.condition;
    var value = returnValue.value;
    var obj = new Object();
    if (listDataObj != null) {
        if (listDataObj.p.params) {
            obj = listDataObj.p.params;
            delete obj.isOverdue;
        }
    }
    if (obj.listType == undefined || obj.userId == undefined) {
        obj = setInitParams();
    }
    obj.condition = condition;
    if (condition == "plannedStartTime" || condition == "plannedEndTime") {
        if (value.length > 0) {
            obj.queryValue = value[0];
            obj.queryValue1 = value[1];
        }
    } else {
        obj.queryValue = value;
    }
    if(condition=="status"&&value=="-1"){
    	//已超期
    	obj.isOverdue=1;
    	obj.queryValue="1,2";
    }
    $("#conditionText").val(obj.condition);
    $("#firstQueryValueText").val(obj.queryValue);
    $("#secondQueryValueText").val(obj.queryValue1);
    return obj;
}

function initDataList(){
    listDataObj = $("#departmentTask").ajaxgrid({
    click : clk,//单击事件
    dblclick : dblclk,//双击事件
    render : render,
    vChange: true,
    vChangeParam: {
        overflow: "hidden",
        autoResize:true
    },
    showTableToggleBtn: true,
    slideToggleBtn:true,
    resizable:true,
    colModel :[{
                 display : 'id',
                 name : 'id',
                 width : '5%',
                 align : 'center',
                 type : 'checkbox'
             }, {
                 display : $.i18n('common.subject.label'),
                 name : 'subject',
                 sortable : true,
                 width : '25%'
             },  {
                 display : $.i18n('taskmanage.weight'),
                 name : 'weight',
                 sortable : true,
                 width : '5%'
             }, {
                 display : $.i18n('common.state.label'),
                 name : 'status',
                 width : '8%',
                 sortable : true,
                 codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
             }, {
                 display : $.i18n('taskmanage.finishrate'),
                 name : 'finishRate',
                 sortable : true,
                 sortType : 'number',
                 width : '18%'
             }, {
                 display : $.i18n('taskmanage.starttime'),
                 name : 'plannedStartTime',
                 sortable : true,
                 width : '12%'
             }, {
                 display : $.i18n('common.date.endtime.label'),
                 name : 'plannedEndTime',
                 sortable : true,
                 width : '12%'
             }, {
                 display : $.i18n('taskmanage.manager'),
                 name : 'managerNames',
                 sortable : true,
                 width : '14%'
             } ],
          parentId: $('.stadic_layout_body').eq(0).attr('id'),
          managerName : "taskInfoManager",
          managerMethod : "selectTaskList",
          onSuccess : filterDeletePurview
  });
  showTotal("init");
   }    
      /**
 * 筛选删除权限
 */
function filterDeletePurview(){
    $("#departmentTask").formobj({
        gridFilter : function(data, row) {
            var currentUserId = $.ctx.CurrentUser.id;
            if(data.createUser.indexOf(currentUserId) < 0 && data.managers.indexOf(currentUserId) < 0){
                if($("input:checkbox", row)[0].value == data.id){
                    $("input:checkbox", row)[0].disabled = true;
                }
            }
        }
    });
}
  
  /**
 * 处理列表中所显示的数据
 * @param text 列表显示信息
 * @param row 列对象
 * @param rowIndex 列索引
 * @param colIndex 行索引
 * @param col 行对象
 */
function render(text, row, rowIndex, colIndex,col){
    if(col.name == "subject"){
        return taskNameIconDisplay(text,row);
    }
    if(col.name == "finishRate") {
        return processFinishRateData(text, row);
    } else {
        return text;
    }   
}

/**
 * 任务标题中所显示图标处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function taskNameIconDisplay(text,row){
    var iconStr = "";
    //根节点图标
    if(row.haschild==true && row.ischild != true) {    
        iconStr += "<span root='true' class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"+row.id+"' index='"+row.index+"'> </span>";
    }
    //重要程度图标
    if(row.importantLevel == "2") {
        iconStr += "<span class='ico16 important_16'></span>";
    } else if(row.importantLevel == "3"){
        iconStr += "<span class='ico16 much_important_16'></span>";
    }
    //里程碑
    if(row.milestone == "1") {    
        iconStr += "<span class='ico16 milestone'></span>";
    }
    //风险图标
    if(row.riskLevel == "1") {
        iconStr += "<span class='ico16 l_risk_16'></span>";
    } else if(row.riskLevel == "2"){
        iconStr += "<span class='ico16 risk_16'></span>";
    } else if(row.riskLevel == "3"){
        iconStr += "<span class='ico16 h_risk_16'></span>";
    }
    iconStr += text;
    //附件图标
    if(row.has_attachments == true || row.has_attachments == "true") {    
        iconStr += "<span class='ico16 affix_16'></span>";
    } 
    //判断是否是子节点
    if(row.ischild==true){
            var index;
            if(row.index > 0){
                index = row.index-1;
            } else {
                index = row.index;
            }
            var margin=index*20+"px";
            if(row.haschild==true){//判断是否存在二级子节点
                iconStr = "<a href='javascript:void(0)' class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'><span class='ico16 table_add_16' onclick='toggleTree(this)' parentId='"+row.id+"' index='"+row.index+"'> </span>"+iconStr+"</a>";        
            } else {
                iconStr = "<a href='javascript:void(0)'  class='row"+row.parentId+" treeNode' style='margin-left:"+margin+";'>"+iconStr+"</a>";   
            }
    }
    return iconStr;
}

/**
 * 对完成率显示内容进行处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function processFinishRateData(text,row){
        var percent=parseInt(text);//百分数
        var color_class="rate_process";
        if(row.status == "4") color_class="rate_filish"; //已完成
        if(row.status == "3") color_class="rate_delay"; //已延期
        if(row.status == "5") color_class="rate_canel"; //已取消
        return "<span class='right margin_l_5' style='width:40px;'>"+ text+"%</span><p class='task_rate adapt_w' style=''><a href='#' class='"+color_class+"' style='width:"+percent+"%;'></a></p>";
}

  function clk(data, r, c,id) {
    viewTaskInfoByIframe(data.id);
  }
  function dblclk(data, r, c,id) {
    viewTaskInfoDialog(data.id);
  }
  $("#btn").click(function() {
    var v = $("#mytable").formobj({
      gridFilter : function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    alert($.toJSON(v));
  });


/**
   * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
   * @param id 任务编号
   */
  function viewTaskInfoDialog(id) {
      var title = $.i18n('taskmanage.content');
      var isTask = taskAjax.validateTask(id);
      if(isTask != null && !isTask) {
          $.alert({
              'msg' : $.i18n('taskmanage.task_deleted'),
              ok_fn : function() {
                  $("#departmentTask").ajaxgridLoad();
              }
          });
          return;
      }
      dialog = $.dialog({
          id : 'viewTask',
          url : _ctxPath + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='+ id + "&from=Project",
          width : $(getCtpTop()).width()-100,
          height : $(getCtpTop()).height()-100,
          title : title,
          targetWindow : getCtpTop(),
          closeParam:{
              'show':true,
              autoClose : false,
              handler:function(){
                  dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshGrid});
              }
          },
          buttons: [{
              text: $.i18n('common.button.close.label'),
              handler: function () {
                  dialog.getClose({'dialogObj' : dialog ,'runFunc' : refreshGrid});
              }
          }]
      });
  }

  function refreshGrid() {
      $("#departmentTask").ajaxgridLoad();
  }

/**
   * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
   * @param id 任务编号
   */
  function viewTaskInfoByIframe(id) {
      var isTask = taskAjax.validateTask(id);
      if(isTask != null && !isTask) {
          $.alert({
              'msg' : $.i18n('taskmanage.task_deleted'),
              ok_fn : function() {
                  $("#departmentTask").ajaxgridLoad();
              }
          });
          return;
      }
      $("#moreListTaskInfo_iframe").attr("src", _ctxPath + '/taskmanage/taskinfo.do?method=taskDetailIndex&id='+id+"&viewType=1&from=Project");
  }

function showTotal(objValue) {
    if(objValue == "init") {
        if (listDataObj != null && listDataObj.p.datas) {
            parent.document.getElementById('projectTaskCount').innerHTML = $.i18n('taskmanage.all') + $.i18n('common.items.count.label',listDataObj.p.datas.total);
        } else {
            parent.document.getElementById('projectTaskCount').innerHTML = $.i18n('taskmanage.all') + $.i18n('common.items.count.label','0');
        }
    } else {
        var count = taskAjax.findTaskCount(objValue);
        parent.document.getElementById('projectTaskCount').innerHTML = $.i18n('taskmanage.all') + $.i18n('common.items.count.label',count);
    }
}

/**
 * 显示任务描述
 */
function showTaskDescription() {
    var from = getUrlPara("from");
    var total = 0;
    if (listDataObj != null) {
        if (listDataObj.p.total) {
            total = listDataObj.p.total;
        }
    }
    var url = _ctxPath + "/taskmanage/taskinfo.do?method=taskDescription&from=" + from + "&total=" + total;
    $("#moreListTaskInfo_iframe").attr("src","");
}

/**
 * 刷新页面
 * 
 */ 
function refreshPage() {
    var obj = new Object();
    if (listDataObj != null) {
        if (listDataObj.p.params) {
            obj = listDataObj.p.params;
        }
    }
    if (obj.listType == undefined || obj.userId == undefined) {
        obj = setInitParams();
        $("#departmentTask").ajaxgridLoad(obj);
    } else {
        $("#departmentTask").ajaxgridLoad();
    }    
    showTaskDescription();
    if(listDataObj != null && listDataObj != undefined) {
        listDataObj.grid.resizeGridUpDown('down');
    }
}

/**
 * 设置初始化查询参数
 */ 
function setInitParams() {
    var obj = new Object();
    obj.listType = getUrlPara("from");
    obj.userId = $.ctx.CurrentUser.id;
    obj.projectId = getUrlPara("projectId");
    obj.projectPhaseId = getUrlPara("projectPhaseId");
    obj.condition = "status";
    obj.queryValue = "1,2,3";
    return obj;
}
/**
 * 新建任务后，刷新下“全部”那里的总条数
 */ 
function afterNewTotal(){
    var returnValue = new Object();
    returnValue.condition = "status";
    returnValue.type="select";
    returnValue.value="1,2,3";
    var obj = setQueryParams(returnValue);
    var count = taskAjax.findTaskCount(obj);
    count=count+1;//加1的原因是因为当前新建的数据还没有插入到数据库中，所以查出来的数据，要少一条，加1后才正确
    parent.document.getElementById('projectTaskCount').innerHTML = $.i18n('taskmanage.all') + $.i18n('common.items.count.label',count);
}
/**
 * 删除任务后，刷新下“全部”那里的总条数
 */ 
function refreshTotal(){
     var returnValue = new Object();
     returnValue.condition = "status";
     returnValue.type="select";
     returnValue.value="1,2,3";
     var obj = setQueryParams(returnValue);
     showTotal(obj);
}