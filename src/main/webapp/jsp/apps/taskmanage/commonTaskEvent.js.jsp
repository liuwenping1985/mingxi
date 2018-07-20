<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-13 12:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskListAjaxManager"></script>
<script type="text/javascript">
    var isContinuous = false;
    var from = '${param.from}';
    /**
     * 查看任务详细信息页面（当用户双击列表中某条任务，则以弹出框形式显示）
     * @param id 任务编号
     */
    function viewTaskInfoDialog(id, isBtnEidt, isFromTree, isViewTree) {
        var title = "${ctp:i18n('taskmanage.content')}";
        var taskAjax = new taskAjaxManager();
        var taskListAjax = new taskListAjaxManager();
        var isTask = taskAjax.validateTask(id);
        if(isTask != null && !isTask) {
            $.alert({
                'msg' : "${ctp:i18n('taskmanage.task_deleted')}",
                ok_fn : function() {
                    $("#taskInfoList").ajaxgridLoad();
                }
            });
            return;
        }
        var isView = taskListAjax.validateTaskView(id);
        if(isView != null && !isView) {
            $.alert("${ctp:i18n('taskmanage.alert.no_auth_view_task')}");
            return;
        }
        var fromTree = "";
        if(isFromTree != undefined) {
            if(isFromTree > 0) {
            	fromTree = "&isFromTree=" + isFromTree;
            }
        } else {
            fromTree = "&isFromTree=1";
        }
        var isTree = "";
        if(isViewTree != undefined) {
            isTree = "&isViewTree=" + isViewTree;
        }
        
        var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&from=bnOperate&taskId="+id;
		var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&taskId="+id;
	 	var taskDetailTreeManager_=new taskDetailTreeManager();
		var exitTree=taskDetailTreeManager_.checkTaskTree(id);
		var treeUrl="";
		var hideBtnC = true;
		if(exitTree){
			hideBtnC = false;
			treeUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskTreePage&taskId="+id;
		}
		new projectTaskDetailDialog({"url1":detailUrl,"url2":contentUrl,"url3":treeUrl,"openB":true,"hideBtnC":hideBtnC,"animate":false});
    }
    
    function refreshGrid() {
        $("#taskInfoList").ajaxgridLoad();
    }
    /**
     * 分解任务事件
     * @param taskId
     */
    function decomposeEvent(taskId,fnCallBack){
    	var _fnCallBack = null;
    	if(fnCallBack){
    		_fnCallBack = fnCallBack;
    	}else if(decomposeSuccess){
    		_fnCallBack = decomposeSuccess;
    	}
    	
        var dialog = $.dialog({
            url : _ctxPath + '/taskmanage/taskinfo.do?method=newTaskInfo&from=Decompose&parentTaskId='+taskId+'&optype=new&flag=9',
            width : 554,
            top:40,
            height : 387+110,
            id : 'new_task',
            title : "${ctp:i18n('taskmanage.decompose.label')}",
            targetWindow : getCtpTop(),
            bottomHTML : "<div class='common_checkbox_box clearfix'><label class='margin_l_10 hand' for='continuous_add'><input id='continuous_add' class='radio_com' name='continuous' value='0' type='checkbox'>${ctp:i18n('taskmanage.add.continue')}</label></div>",
            buttons : [ {
                text : "${ctp:i18n('common.button.ok.label')}",isEmphasize:true,
                id : 'ok',
                handler : function() {
                    var viewType = "${empty param.viewType ? 2 : param.viewType}";
                    if(viewType == 2) {
                        if(window.parent.validateTask) {
                            var bool = window.parent.validateTask();
                            if(!bool) {
                                return;
                            }
                        }
                    }
                    var isChecked = dialog.getObjectById("continuous_add")[0].checked;
                    var ret = dialog.getReturnValue({'dialogObj' : dialog , 'isChecked' : isChecked , 'runFunc' : _fnCallBack});
                    if(isChecked == true || isChecked == "true") {
                        if(ret == true || ret == "true") {
                            isContinuous = true;
                        }
                    }
                }
            }, {
                text : "${ctp:i18n('common.button.cancel.label')}",
                handler : function() {
                    if(isContinuous == true || isContinuous == "true") {
						//window.parent.parent.parent.location.reload();
						if(_fnCallBack){
							_fnCallBack();
						}
                    }
                    dialog.close();
                }
            } ]
        });
    }
</script>