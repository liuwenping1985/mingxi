var listDataObj = null;
// 隐藏显示树
function toggleTree(obj) {
    var target = $(obj);
    var root = target.attr("root");
    var id = target.parents("tr").attr("id");

    var hiddentr = $("." + id).parents("tr");
    hiddentr.toggleClass("hidden");
    if(hiddentr.hasClass("hidden")) {
        target.attr("class","ico16 table_add_16");
    } else {
        target.attr("class","ico16 table_plus_16");
    }
    if (hiddentr.hasClass("hidden")) {
        hiddenChildTask(hiddentr);
    }
}

/**
 * 隐藏子任务
 * @param hiddentr 子任务对象
 */
function hiddenChildTask(hiddentr){
    hiddentr.each(function(index) {
        //alert(index + ': ' + $(this).text()+"---" + $(this).find("span").hasClass("table_plus_16"));
        $(this).addClass("hidden");
        if($(this).find("span").hasClass("table_plus_16")) {
            $(this).find(".table_plus_16").attr("class","ico16 table_add_16");
        }
        var hiddentr = $("." + $(this).attr("id")).parents("tr");
        if(hiddentr.length > 0) {
            hiddenChildTask(hiddentr);
        }
    });
}

/**
 * 删除任务信息操作
 */
function deleteTask() {
    var taskAjax = new taskAjaxManager();
    var idValues = getCheckedId();
    var taskId = getUrlPara("id");
    if (idValues == null || idValues.length == 0) {
        $.alert($.i18n('taskmanage.alert.delete.select'));
    } else if (taskAjax.checkTaskIsFinished(idValues)) {
        var retMsg = $.i18n('taskmanage.alert.delete.no_delete');
        if(idValues.indexOf(",") > -1) {
            retMsg = $.i18n('taskmanage.alert.delete.contain_no_delete');
        }
        $.alert(retMsg);
    } else if(idValues.indexOf(taskId) > -1) {
        $.alert($.i18n('taskmanage.alert.delete.no_delete_view_task'));
    } else if(taskAjax.isContainCurrentTask(idValues,taskId)) {
        $.alert($.i18n('taskmanage.alert.delete.no_delete_view_contain_childs'));
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
                            decomposeSuccess();
                        }
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
 * 分解任务
 */
function decomposeTask() {
    var idValue = getCheckedId();
    var taskAjax = new taskAjaxManager();
    if (idValue == null || idValue.length == 0) {
        $.alert($.i18n('taskmanage.alert.decompose.select'));
    } else {
        if (idValue.indexOf(",") > -1) {
            $.alert($.i18n('taskmanage.alert.decompose.select_one'));
            return;
        }
        if (taskAjax.checkTaskIsFinished(idValue)) {
            $.alert($.i18n('taskmanage.alert.decompose.no_decompose_finished_or_canceled'));
            return;
        }
        if (!taskAjax.checkDecomposePurview(idValue, $.ctx.CurrentUser.id)) {
            $.alert($.i18n('taskmanage.alert.decompose.no_manager_or_creater'));
            return;
        }
        decomposeEvent(idValue);
    }
}

/**
 * 分解成功执行的事件
 */
function decomposeSuccess() {
    var viewType = getUrlPara("viewType");
    if (viewType == "1") {
        if(window.parent.parent.refreshPage) {
            window.parent.parent.refreshPage();
        }
    } else {
        $("#is_update",parent.document).val("1");
        $("#taskInfoList").ajaxgridLoad();
    }
}

function doubleClickEvent(data, r, c) {
    var isFromTree = getUrlPara("isFromTree");
    var isViewTree = getUrlPara("isViewTree");
    if(isFromTree > 0) {
        var taskId = getUrlPara("id");
        if(taskId == data.id) {
            $.alert($.i18n('taskmanage.open.never_again'));
            return;
        }
        if(isViewTree == 0) {
            viewTaskInfoDialog(data.id ,1, 2);
        } else {
            if(isViewTree == 1) {
                viewTaskInfoDialog(data.id ,0, 1 ,2);
            }
        }
    }
}

/**
 * 关闭弹出窗口执行的事件
 * 
 */
function CLOSE(){
    var bool = false;
    if($("#is_update").val() == "1") {
        bool = true;
    }
    return bool;
}