<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-3 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="listTaskInfoEvent.js.jsp" %>
<script type="text/javascript">
    /**
     * 切换到修改页面事件
     */  
    function updateTask() {
        taskId = '${param.id}';
        var taskAjax = new taskAjaxManager();       
        if (taskAjax.checkTaskIsFinished(taskId)) {
            $.alert("${ctp:i18n('taskmanage.alert.update.not_allowed')}");
        } else {
            var url = _ctxPath + "/taskmanage/taskinfo.do?method=updateTask&id=" + taskId
                    + "&optype=update&viewType=${param.viewType}&from=Edit";
                    new newTask(null,url,'modify');
        }
    }

    /**
     * 分解任务事件
     */
    function decomposeTask() {
        taskId = '${param.id}';
        var taskAjax = new taskAjaxManager();
        if (taskAjax.checkTaskIsFinished(taskId)) {
            $.alert("${ctp:i18n('taskmanage.alert.decompose.not_allowed')}");
        } else {
            decomposeEvent(taskId);
        }
    }

    /**
     * 分解成功执行的事件
     */
    function decomposeSuccess() {
        var viewType = "${param.viewType}";
        if (viewType == "1") {
            if(window.parent.parent.refreshPage) {
                window.parent.parent.refreshPage();
            }
        } else {
            $("#is_update", parent.document).val("1");
        }
    }
    
    /**
     * 刷新方法
     */
    function refreshPage() {
        if(window.parent.loadTaskDetail) {
            window.parent.loadTaskDetail();
        }
        $("#is_update",parent.document).val("1");
        var contentIframeUrl = $("#taskDetail_content_iframe",parent.document).attr("src");
        $("#taskDetail_content_iframe",parent.document).attr("src", contentIframeUrl);
    }
</script>
