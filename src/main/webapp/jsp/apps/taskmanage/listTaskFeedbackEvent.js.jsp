<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-19 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    $(function(){
        //监视window.resize,设置grid的bDiv的高度，使grid高度计算正确，下面区域展示高度正常
        $(window).resize(function(){
            var _grid_height = $("#center").height()-$(".flexigrid").height()-$("#grid_detail").height();
            var _bDiv_obj=$("#task_feedback_list_ajaxgrid_classtag_bDiv");
            _bDiv_obj.height(_bDiv_obj.height()+_grid_height);
        });
    });
    var listDataObj = null;
    var toolbar = null;
    var isFeedback = ${isFeedback};
    var feedBackId = "${empty param.feedBackId ? -1 : param.feedBackId}";
    /**
     * 新建任务汇报页面
     */
    function newTaskFeedback() {
        $("#task_feedback_iframe")
                .attr("src", _ctxPath + "/taskmanage/taskfeedback.do?method=newTaskFeedbackPage&isEidt=1&operaType=new&taskId=${param.id}");
        listDataObj.grid.resizeGridUpDown('middle');
    }

    /**
     * 列表单击事件
     */
    function clickEvent(data, r, c) {
        if (data) {
            viewTaskFeedback(data.id, "view", 0);
        }
    }

    /**
     * 查看任务汇报
     */
    function viewTaskFeedback(id, operaType, isEidt) {
        if(validateTaskFeedback(id)) {
            if(listDataObj != null && listDataObj != undefined) {
                listDataObj.grid.resizeGridUpDown('down');
            }
        } else {
            $("#task_feedback_iframe").attr("src",_ctxPath
                                    + "/taskmanage/taskfeedback.do?method=viewTaskFeedback&isEidt="+isEidt+"&operaType="
                                    + operaType + "&id=" + id + "&taskId=${param.id}");
            if(listDataObj != null && listDataObj != undefined) {
                listDataObj.grid.resizeGridUpDown('middle');
            }
        }
    }

    /**
     * 修改任务汇报
     */
    function updateTaskFeedback() {
        var id = getCheckedId();
        if (id == null) {
            $.alert("${ctp:i18n('taskmanage.alret.feedback.modify')}");
        } else {
            if (id.indexOf(",") > 0) {
                $.alert("${ctp:i18n('taskmanage.alret.feedback.modify.only_one')}");
                return;
            }
            viewTaskFeedback(id, "update", 1);
        }
    }

    /**
     * 删除任务汇报信息
     */
    function deleteTaskFeedback() {
        var idValues = getCheckedId();
        var taskAjax = new taskAjaxManager();
        var taskId = '${param.id}';
        if (taskAjax.checkTaskIsFinished(taskId)) {
            $.alert("${ctp:i18n('taskmanage.alret.feedback.no_delete_finished_or_canceled')}");
            return;
        }
        if (idValues == null || idValues.length == 0) {
            $.alert("${ctp:i18n('taskmanage.alret.feedback.delete')}");
        } else {
            var ret = "${ctp:i18n('taskmanage.confirm.feedback.delete')}";
            var confirm = $.confirm({
                'msg' : ret,
                ok_fn : function() {
                    taskAjax.deleteTaskFeedback(idValues, {
                        success : function(bool) {
                            if (bool == true || bool == "true") {
                                var viewType = "${param.viewType}";
                                if (viewType == "1") {
                                    if(window.parent.parent.refreshPage) {
                                        window.parent.parent.refreshPage();
                                    }
                                } else {
                                    $("#task_feedback_list").ajaxgridLoad();
                                    if(listDataObj != null) {
                                        listDataObj.grid.resizeGridUpDown('down');
                                    }
                                    $("#is_update",parent.document).val("1");
                                }
                            }
                        },
                        error : function(request, settings, e) {
                            $.error("删除任务失败，服务器报错！");
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
        var id = null;
        var idValue = $("#task_feedback_list").formobj({
            gridFilter : function(data, row) {
                return $("input:checkbox", row)[0].checked;
            }
        });
        for ( var i = 0; i < idValue.length; i++) {
            if (i == 0) {
                id = idValue[i].id;
            } else {
                id += "," + idValue[i].id;
            }
        }
        return id;
    }
    
    /**
     * 选人界面的操作
     */
    function selectPerson(valueId, textId, retText, retValue) {
        $.selectPeople({
            type : 'selectPeople',
            panels : 'Department,Team',
            selectType : 'Member',
            isNeedCheckLevelScope : false,
            text : "${ctp:i18n('common.default.selectPeople.value')}",
            params : {
                text : retText,
                value : retValue
            },
            maxSize : 1,
            callback : function(ret) {
                if(ret){
                    $("#" + textId).val(ret.text);
                    $("#" + valueId).val(ret.value);
                }
            }
        });
    }
    
    /**
     * 刷新方法
     */
    function refreshPage(){
        var viewType = "${param.viewType}";
        if (viewType == "1") {
            if(window.parent.parent.refreshPage) {
                window.parent.parent.refreshPage();
            }
        } else {
            var obj = new Object();
            obj.taskId = '${param.id}';
            $("#task_feedback_list").ajaxgridLoad(obj);
            if(listDataObj != null) {
                listDataObj.grid.resizeGridUpDown('down');
            }
            showTaskFeedbackDescription();
            window.parent.loadTaskDetail();
            $("#is_update",parent.document).val("1");
        }
    }
</script>