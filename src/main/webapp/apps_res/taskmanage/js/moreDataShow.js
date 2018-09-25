var listDataObj;

function initLayout() {
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 35,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}

function initTotal(){
  if(listDataObj.p){
    $("#total").html(listDataObj.p.total);
  }
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
        }
    }
    if (obj.startTime == undefined || obj.userId == undefined) {
        obj = setInitParams();
    }
    obj.condition = condition;
    if (condition == "createTime") {
        obj.condition = "createTimeStr";
        if (value.length > 0) {
            if(value[0].length > 0) {
                obj.queryValue = value[0] + " 00:00";
            } else {
                obj.queryValue = getUrlPara("queryValue");
            }
            if(value[1].length > 0) {
                obj.queryValue1 = value[1] + " 23:59";
            } else {
                obj.queryValue1 = getUrlPara("queryValue1");
                }
            }
        } else {
            obj.queryValue = value;
        }
        return obj;
    }

/**
 * 设置初始化查询参数
 */ 
function setInitParams() {
    var obj = new Object();
    obj.userId = $.ctx.CurrentUser.id;
    obj.roleType = getUrlPara("from");
    obj.startTime = getUrlPara("queryValue");
    obj.endTime = getUrlPara("queryValue1");
    return obj;
} 
    
//搜索框
function initSearch(){
    var searchobj = $.searchCondition({
                top : 5,
                right : 5,
                searchHandler : function() {
                    var returnVal = searchobj.g.getReturnValue();
                    if(returnVal != null){
                        var obj = setQueryParams(returnVal);
                        $("#newReportInfoList").ajaxgridLoad(obj);
                    }
                },
                conditions : [{
                  id : 'taskName',
                  name : 'taskName',
                  type : 'input',
                  text : $.i18n('taskmanage.task_subject.label'),
                  value : 'taskName'  
              },{
                  id : 'createUser',
                  name : 'createUser',
                  type : 'input',
                  text : $.i18n('taskmanage.feedback.creator'),
                  value : 'createUser'
              },{
                  id: 'createTime',
                  name: 'createTime',
                  type: 'datemulti',
                  text: $.i18n('taskmanage.feedback.createtime'),
                  value: 'createTime',
                  ifFormat:"%Y-%m-%d",
                  daFormat:"%Y-%m-%d",
                  dateTime: false
              }]
        });
}

function initDataList(){
      listDataObj = $("#newReportInfoList").ajaxgrid({
      click : clk,//单击事件
      render : rend,
      resizable:false,
      colModel :[{
                display : $.i18n('common.subject.label'),
                name : 'taskName',
                width : '15%',
                sortable : true
            },{
                display : $.i18n('taskmanage.feedback.creator'),
                name : 'createUser',
                sortable : true,
                width : '8%'
            },{
                display : $.i18n('taskmanage.feedback.createtime'),
                name : 'createTime',
                sortable : true,
                width : '14%'
            },{
                display : $.i18n('taskmanage.weight'),
                name : 'taskWeight',
                sortable : true,
                width : '5%'
            },{
                display : $.i18n('common.state.label'),
                name : 'taskStatus',
                sortable : true,
                width : '8%',
                codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
            },{
                display : $.i18n('taskmanage.finishrate'),
                name : 'finishRate',
                sortable : true,
                sortType : 'number',
                width : '15%'
            },{
                display : $.i18n('taskmanage.currentTime'),
                name : 'elapsedTime',
                sortable : true,
                width : '10%'
            },{
                display : $.i18n('taskmanage.feedback.content'),
                name : 'content',
                sortable : true,
                width : '24%'
            }],
            parentId: $('.layout_center').eq(0).attr('id'),
            managerName : "taskFeedbackManager",
            managerMethod : "selectNewestTaskFeedbackList"
    });
    function rend(text, row, rowIndex, colIndex,col) {
      if(col.name == "taskName"){
            return taskNameIconDisplay(text,row);
        }
        if(col.name == "finishRate") {
            return processFinishRateData(text, row);
        } else {
            return text;
        }
    }
    function clk(data, r, c) {
        viewTaskInfoDialog(data.taskId,data.id);
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
     * 对完成率显示内容进行处理
     * @param text 列表显示信息
     * @param row 列对象
     */
    function processFinishRateData(text,row){
            var percent=parseInt(text);//百分数
            var color_class="rate_process";
            if(row.taskStatus == "4") color_class="rate_filish"; //已完成
            if(row.taskStatus == "3") color_class="rate_delay"; //已延期
            if(row.taskStatus == "5") color_class="rate_canel"; //已取消
            return "<span class='right margin_l_5' style='width:40px;'>"+ text +"%</span><p class='task_rate adapt_w' style=''><a href='#' class='"+color_class+"' style='width:"+percent+"%;'></a></p>";
    }
    
    /**
     * 任务标题中所显示图标处理
     * @param text 列表显示信息
     * @param row 列对象
     */
    function taskNameIconDisplay(text,row){
        var iconStr = "";
        if (row.taskInfo && row.taskInfo != null) {
            //重要程度图标
            if(row.taskInfo.importantLevel == "2") {
                iconStr += "<span class='ico16 important_16'></span>";
            } else if(row.taskInfo.importantLevel == "3"){
                iconStr += "<span class='ico16 much_important_16'></span>";
            }
            //里程碑
            if(row.taskInfo.milestone == "1") {    
                iconStr += "<span class='ico16 milestone'></span>";
            }
            //风险图标
            if(row.taskInfo.riskLevel == "1") {
                iconStr += "<span class='ico16 l_risk_16'></span>";
            } else if(row.taskInfo.riskLevel == "2"){
                iconStr += "<span class='ico16 risk_16'></span>";
            } else if(row.taskInfo.riskLevel == "3"){
                iconStr += "<span class='ico16 h_risk_16'></span>";
            }
            iconStr += text;
            //附件图标
            if(row.taskInfo.hasAttachments == true || row.taskInfo.hasAttachments == "true") {    
                iconStr += "<span class='ico16 affix_16'></span>";
            } 
        } else {
            iconStr = text;
        }
        return iconStr;
    }
    
      /**
       * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
       * @param id 任务编号
       */
      function viewTaskInfoDialog(id,feedBackId) {
          var title = $.i18n('taskmanage.content');
          var taskAjax = new taskAjaxManager();
          var isTask = taskAjax.validateTask(id);
          if(isTask != null && !isTask) {
              $.alert({
                  'msg' : $.i18n('taskmanage.task_deleted'),
                  ok_fn : function() {
                      $("#newReportInfoList").ajaxgridLoad();
                  }
              });
              return;
          }
          var isView = taskAjax.validateTaskView(id);
          if(isView != null && !isView) {
             $.alert($.i18n('taskmanage.alert.no_auth_view_task'));
             return;
          }
          dialog = $.dialog({
              url : _ctxPath + "/taskmanage/taskinfo.do?method=taskDetailIndex&id="+id +"&sourceFeedback=1" + "&from=feedBack&feedBackId="+feedBackId,
              width : $(getCtpTop()).width()-100,
              height : $(getCtpTop()).height()-100,
              title : title,
              targetWindow : getCtpTop(),
              closeParam:{
                  'show':true,
                  autoClose:false,
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
}

function refreshGrid() {
    $("#newReportInfoList").ajaxgridLoad();
}