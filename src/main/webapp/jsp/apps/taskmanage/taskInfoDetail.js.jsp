<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-11-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    var taskId = null;
    /**
     * 获取任务的详细信息
     * @return 任务详细信息
     */
    function getTaskDetail() {
        var taskDetailData = null;
        var taskAjax = new taskAjaxManager();
        taskId = '${param.id}';
        taskDetailData = taskAjax.taskInfoDetailed(taskId);
        return taskDetailData;
    }

    /**
     * 初始化工具条
     */
    function initToolBar() {
        var toolbar = $("#toolbar").toolbar({
            searchHtml : '',
            toolbar : [ {
                id : "update",
                name : "${ctp:i18n('common.toolbar.update.label')}",
                className : "ico16 editor_16",
                click : function() {
                    var bool = window.parent.validateTask();
                    if(bool) {
                        updateTask();
                    } 
                }
            }, {
                id : "decomposition",
                name : "${ctp:i18n('taskmanage.decompose')}",
                className : "ico16 decomposition_16",
                click : function() {
                    var bool = window.parent.validateTask();
                    if(bool) {
                        decomposeTask();
                    }    
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
        var isEidt = "${isEdit}";
        var isDecompose = "${isDecompose}";
        var isBtnEidt = "${param.isBtnEidt}";
        if(isEidt == false || isEidt == "false") {
            obj.disabled("update");
        }
        if(isDecompose == false || isDecompose == "false") {
            obj.disabled("decomposition");
        }
        if(isBtnEidt == 0) {
            obj.disabled("update");
            obj.disabled("decomposition");
        }
    }
    
    /**
     * 获取任务的详细信息
     * @return 任务详细信息
     */
    function initData() {
        var taskDetail = null;
        taskDetail = getTaskDetail();
        if(taskDetail != null){
            $("#task_name").html(replaceTag(taskDetail.subject));
            $("#parent_task_name").html(replaceTag(taskDetail.parentTaskSubject));
            if($("#parent_task_name").html().trim().length > 30){
                $("#parent_task_name").attr("title",replaceTag(taskDetail.parentTaskSubject));
                $("#parent_task_name").attr("style","text-overflow:ellipsis;white-space:nowrap;width:370px;overflow:hidden;");
            }
            $("#weight").html(taskDetail.weight+ "%");
            if (taskDetail.parentId && taskDetail.parentId != -1) {
                $("#parent_task").removeClass("hidden");
            } else {
                $("#parent_task").addClass("hidden");
            }
            $("#importantlevel").html(taskDetail.importantLevelText);
            if (taskDetail.milestone > 0) {
                $("#milestone").attr("checked", true);
            }
            $("#importantlevel").html(taskDetail.importantlevel);
            var planStartDate = convertDateToStr(taskDetail.plannedStartTime);        
            var planEndDate = convertDateToStr(taskDetail.plannedEndTime);
            var remindStartTimeText = "";
            var remindEndTimeText = "";
            if(taskDetail.remindStartTime > -1){
                remindStartTimeText = "<span class='ico16 time_remind_16' title='${ctp:i18n('taskmanage.reminderTime.before_start.label')}："+taskDetail.remindStartTimeText+"'></span>";
            }
            if(taskDetail.remindEndTime > -1){
                remindEndTimeText = "<span class='ico16 time_remind_16' title='${ctp:i18n('taskmanage.reminderTime.before_end.label')}："+taskDetail.remindEndTimeText+"'></span>";
            }
            $("#plan_time").html(planStartDate + remindStartTimeText + "&nbsp;&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;&nbsp;" + planEndDate + remindEndTimeText);
            var actualStartTime = convertDateToStr(taskDetail.actualStartTime);
            var actualEndTime = convertDateToStr(taskDetail.actualEndTime);
//             if(actualStartTime.length > 0 && actualEndTime.length > 0){
//                 if(actualStartTime.substring(0,4) == actualEndTime.substring(0,4)){
//                     actualEndTime = actualEndTime.substring(5,actualEndTime.length);
//                 }
//             }
            if(actualStartTime.length > 0 && actualEndTime.length > 0){
                $("#actual_time").html(actualStartTime + "&nbsp;&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;&nbsp;"+ actualEndTime);
            }
            $("#managers").html(taskDetail.managerNames);
            $("#inspectors").html(taskDetail.inspectorsName);
            $("#participators").html(taskDetail.participatorsName);
            $("#create_user").html(taskDetail.createUserName);
            if(taskDetail.content == null || taskDetail.content == "null"){
            	$("#content").html("");
            }else{
            	$("#content").html(replaceTag(taskDetail.content));
            }
            if(taskDetail.sourceName != null && taskDetail.sourceId != "-1") {
                if(taskDetail.sourceName.length > 0){
                    var sourceName = "${ctp:i18n('taskmanage.plan.label')}[<a href='javascript:void(0)' onclick='openPlan(\""+taskDetail.sourceId+"\",null,true,null,null,true)'>"+ taskDetail.sourceName.escapeHTML() + "</a>]";
                    $("#source_name").html(sourceName);
                    $("#source_info").removeClass("hidden");
                } else {
                    var sourceName = "${ctp:i18n('taskmanage.plan.label')}[${ctp:i18n('taskmanage.plan_delete.label')}]";
                    $("#source_name").html(sourceName);
                    $("#source_info").removeClass("hidden");
                }
            } else {
                $("#source_info").addClass("hidden");
            }
        }
    }
    
    /**
     * 绑定任务详情页面的事件
     */
    function initPageEvent(){
//         if($("#update_btn").attr('disabled') != 'disabled'){
//             $("#update_btn").bind("click", updateTask);
//         } else {
//             $("#update_btn").attr("style","color: #b6b6b6;");
//         }
        var viewType = "${param.viewType}";
        $("body").bind("click", window.parent.validateTask);
    }
    
</script>