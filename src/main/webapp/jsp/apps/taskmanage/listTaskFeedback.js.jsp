<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-18 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
/**
 * 初始化工具条
 */
function initToolBar() {
    toolbar = $("#toolbar").toolbar({
        searchHtml : '',
        toolbar : [ {
            id : "report",
            name : "${ctp:i18n('common.toolbar.new.label')}",
            className : "ico16",
            click : function() {
                var viewType = "${param.viewType}";
                if(viewType == 2) {
                    var bool = window.parent.validateTask();
                    if(!bool) {
                        return;
                    }
                }
                newTaskFeedback();
            }
        }, {
            id : "update",
            name : "${ctp:i18n('common.toolbar.update.label')}",
            className : "ico16 editor_16",
            click : function() {
                var viewType = "${param.viewType}";
                if(viewType == 2) {
                    var bool = window.parent.validateTask();
                    if(!bool) {
                        return;
                    }
                }
                updateTaskFeedback();
            }
        }, {
            id : "delete",
            name : "${ctp:i18n('common.toolbar.delete.label')}",
            className : "ico16 del_16",
            click : function() {
                var viewType = "${param.viewType}";
                if(viewType == 2) {
                    var bool = window.parent.validateTask();
                    if(!bool) {
                        return;
                    }
                }
                deleteTaskFeedback();
            }
        } ]
    });
    isPageBtnEidt(toolbar);
}

/**
 * 页面按钮是否可以使用
 * @param obj 工具条对象
 */
function isPageBtnEidt(obj){
    var isBtnEidt = "${param.isBtnEidt}";
    if(isBtnEidt == 0) {
        obj.disabled("report");
        obj.disabled("update");
        obj.disabled("delete");
    }
}

/**
 * 初始化搜索框
 */
function initSearchDiv() {
    searchobj = $.searchCondition({
        top:2,
        right:10,
        searchHandler: function(){
            var returnValue = searchobj.g.getReturnValue();
            if(returnValue != null){
                var obj = setQueryParams(returnValue);
                $("#task_feedback_list").ajaxgridLoad(obj);
                showTaskFeedbackDescription();
                if(listDataObj != null) {
                    listDataObj.grid.resizeGridUpDown('down');
                }
            }
        },
        conditions: [ {
            id: 'createUserText',
            name: 'createUserText',
            type: 'input',
            text: "${ctp:i18n('taskmanage.feedback.creator')}",
            value: 'createUser'
        }, {
            id: 'createTimeText',
            name: 'createTimeText',
            type: 'datemulti',
            text: "${ctp:i18n('taskmanage.feedback.createtime')}",
            value: 'createTime',
            dateTime: true
        } ]
    });
}

/**
 * 初始化列表数据
 */
function initListData() {
     listDataObj = $("#task_feedback_list").ajaxgrid(
                    {
                        render: render,
                        isHaveIframe:true,
                        colModel : [
                                {
                                    display : 'id',
                                    name : 'id',
                                    width : '5%',
                                    align : 'center',
                                    type : 'checkbox'
                                }, {
                                    display : "${ctp:i18n('taskmanage.feedback.creator')}",
                                    name : 'createUser',
                                    sortable : true,
                                    width : '10%'
                                },  {
                                    display : "${ctp:i18n('taskmanage.feedback.createtime')}",
                                    name : 'createTime',
                                    sortable : true,
                                    width : '15%'
                                }, {
                                    display : "${ctp:i18n('common.state.label')}",
                                    name : 'taskStatus',
                                    width : '10%',
                                    sortable : true,
                                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"
                                }, {
                                    display : "${ctp:i18n('taskmanage.finishrate')}",
                                    name : 'finishRate',
                                    sortable : true,
                                    sortType : 'number',
                                    width : '15%'
                                }, {
                                    display : "${ctp:i18n('taskmanage.currentTime')}",
                                    name : 'elapsedTime',
                                    sortable : true,
                                    width : '10%'
                                }, {
                                    display : "${ctp:i18n('taskmanage.feedback.content')}",
                                    name : 'content',
                                    sortable : true,
                                    width : '33%'
                                } ],
                        click : clickEvent,
                        vChange: true,
                        vChangeParam: {
                            overflow: "hidden",
                            autoResize:true
                        },
                        showTableToggleBtn: false,
                        slideToggleBtn: true,
                        parentId: $('.layout_center').eq(0).attr('id'),
                        managerName : "taskFeedbackManager",
                        managerMethod : "selectTaskFeedbackPagingList",
                        onSuccess : successFunc
                    });
        //兼容处理,添加对窗口大小的resize监控，模拟点击，设置grid高度
        $(window).resize(function(){
            var _jj_height=$("#center").height()-$("#"+listDataObj.p.id).height()-$("#grid_detail").height();
            $(".bDiv").height($(".bDiv").height()+_jj_height);
            $(".slideUpBtn").trigger("click");
            $(".slideDownBtn").trigger("click");
        });
}

function successFunc() {
  filterUpdatePurview();
  positionTaskFeedback();
}

/**
 * 筛选修改权限
 */
function filterUpdatePurview(){
    $("#task_feedback_list").formobj({
        gridFilter : function(data, row) {
            var currentUserId = $.ctx.CurrentUser.id;
                if(data.createUserId != currentUserId){
                    if($("input:checkbox", row)[0].value == data.id){
                        $("input:checkbox", row)[0].disabled = true;
                    }
                }
            }
        });
}
/**
 * 定位任务汇报
 */
function positionTaskFeedback(){
  $("#task_feedback_list").formobj({
    gridFilter : function(data, row) {
            if(data.id == feedBackId){
              $(row).addClass("trSelected");
            }
        }
    });
}
/**
 * 验证操作权限
 */
function checkOperaPurview(){
    if(!isFeedback) {
        toolbar.disabled("report");
        toolbar.disabled("update");
        toolbar.disabled("delete");
    }
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
    if(col.name == "createUser") {
        return taskNameIconDisplay(text,row);
    } else if(col.name == "finishRate") {
        return processFinishRateData(text, row);
    } else if(col.name == "elapsedTime") {
        return text + " ${ctp:i18n('common.time.hour')}";
    } else {
        return text;
    }
}

/**
 * 汇报人中所显示图标处理
 * @param text 列表显示信息
 * @param row 列对象
 */
function taskNameIconDisplay(text,row){
    var iconStr = "";
    //风险图标
    if(row.taskRiskLevel == "1") {
        iconStr += "<span class='ico16 l_risk_16'></span>";
    } else if(row.taskRiskLevel == "2"){
        iconStr += "<span class='ico16 risk_16'></span>";
    } else if(row.taskRiskLevel == "3"){
        iconStr += "<span class='ico16 h_risk_16'></span>";
    }
    iconStr += text;
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
        if(row.taskStatus == "4") color_class="rate_filish"; //已完成
        if(row.taskStatus == "3") color_class="rate_delay"; //已延期
        if(row.taskStatus == "5") color_class="rate_canel"; //已取消
        return "<span class='right margin_l_5' style='width:40px;'>"+ text+"%</span><p class='task_rate adapt_w' style=''><a href='#' class='"+color_class+"' style='width:"+percent+"%;'></a></p>";
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
    if(obj.taskId == undefined){
        obj.taskId = '${param.id}';
    }
    obj.condition = condition;
    if (condition == "createTime") {
        if (value.length > 0) {
            obj.queryValue = value[0];
            obj.queryValue1 = value[1];
        }
    } else {
        obj.queryValue = value;
    }
    $("#conditionText").val(obj.condition);
    $("#firstQueryValueText").val(obj.queryValue);
    $("#secondQueryValueText").val(obj.queryValue1);
    return obj;
}

/**
 * 显示任务汇报描述
 */
function showTaskFeedbackDescription() {
    var total = 0;
    if (listDataObj != null) {
        if (listDataObj.p.total) {
            total = listDataObj.p.total;
        }
    }
    var url = _ctxPath + "/taskmanage/taskinfo.do?method=taskFeedbackDescription&total=" + total;
    $("#task_feedback_iframe").attr("src",url);
}

function showTaskFeedback() {
  if(feedBackId != -1) {
    viewTaskFeedback(feedBackId, "view", 0);
  }
}
/**
 * 验证任务汇报
 */
function validateTaskFeedback(id) {
    var bool = false;
    var taskAjax = new taskAjaxManager();
    if (!taskAjax.isTaskFeedbackExist(id)) {
        $.alert({
            'msg' : "${ctp:i18n('taskmanage.taskFeedback_deleted')}",
            ok_fn : function() {
                $("#task_feedback_list").ajaxgridLoad();
            }
        });
        bool = true;
        return bool;
    }
    return bool;
}
</script>