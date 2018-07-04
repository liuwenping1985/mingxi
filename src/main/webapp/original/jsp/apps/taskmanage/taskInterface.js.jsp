<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-12-7 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	var dialog = null;
	var isContinuous = false;
	/**
	 * 查看任务详细信息页面
	 * @param id 任务编号
	 */
	function viewTaskInfo(id, isBtnEidt, isViewTree) {
		taskInfoAPI.openTaskDetail(id);
		/* var title = "${ctp:i18n('taskmanage.content')}";
		var isEidt = "";
		var isTree = "";
		var taskAjax = new taskAjaxManager();
		/* var isTask = taskAjax.validateTask(id);
		if (isTask != null && !isTask) {
			$.alert({
				'msg' : "${ctp:i18n('taskmanage.task_deleted')}",
				ok_fn : function() {
					try {
						refreshPage();
					} catch (e) {
					}
				}
			});
			return;
		}
		var isView = taskAjax.validateTaskView(id);
		if (isView != null && !isView) {
			$.alert("${ctp:i18n('taskmanage.alert.no_auth_view_task')}");
			return;
		}
		var m = taskAjax.validateViewTaskInfo(id);
		if (!m.exist) {
			$.alert({
				'msg' : "${ctp:i18n('taskmanage.task_deleted')}",
				ok_fn : function() {
					try {
						refreshPage();
					} catch (e) {
					}
				}
			});
			return;
		}
		if (!m.view) {
			$.alert("${ctp:i18n('taskmanage.alert.no_auth_view_task')}");
			return;
		}
		var type = $("#show_type").val();
		if (isBtnEidt == 0) {
			isEidt = "&isBtnEidt=0";
		}
		if (isViewTree == 1) {
			isTree = "&isViewTree=1";
		}
		var detailUrl = _ctxPath + "/taskmanage/taskinfo.do?method=openTaskDetailPage&from=planTask&taskId=" + id;
		var contentUrl = _ctxPath + "/taskmanage/taskinfo.do?method=openTaskContentPage&taskId=" + id;
		var taskDetailTreeManager_ = new taskDetailTreeManager();
		//var exitTree = taskDetailTreeManager_.checkTaskTree(id);
		var exitTree = (new taskAjaxManager().validateViewTaskInfo(id))["tree"];
		var treeUrl = "";
		var hideBtnC = true;
		if (exitTree) {
			hideBtnC = false;
			treeUrl = _ctxPath + "/taskmanage/taskinfo.do?method=openTaskTreePage&taskId=" + id;
		}
		new projectTaskDetailDialog({
			"url1" : detailUrl,
			"url2" : contentUrl,
			"url3" : treeUrl,
			"openB" : true,
			"hideBtnC" : hideBtnC,
			"animate" : false
		}); */
	}

	/**
	 * 新建任务功能
	 * @param obj 任务编号
	 */
	function newTaskInfo(obj) {
		var options = {};
		if (obj.beginDate) {
			options.beginDate = obj.beginDate;
		} 
		taskInfoAPI.newTask(options, obj.runFunc);
		
		/* var startTime = obj.beginDate ? obj.beginDate : "";
		var flag = obj.flag ? obj.flag : 0;
		dialog = $.dialog({
			id : 'new_task',
			url : _ctxPath + '/taskmanage/taskinfo.do?method=newTaskInfo&from=Personal&optype=new&beginDate=' + startTime + "&flag=" + flag,
			width : 554,
			top : 40,
			height : 397,//?obj.height:(397+110),
			isClear : false,
			title : "${ctp:i18n('menu.taskmanage.new')}",
			targetWindow : getCtpTop(),
			transParams : {
				planData : obj.planId ? obj : ""
			},
			bottomHTML : "<div class='common_checkbox_box clearfix'><label class='margin_r_10 hand' for='continuous_add'><input id='continuous_add' class='radio_com' name='continuous' value='0' type='checkbox'>${ctp:i18n('taskmanage.add.continue')}</label></div>",
			closeParam : {
				'show' : true,
				handler : function() {
					if (isContinuous == true || isContinuous == "true") {
						if (obj.runFunc) {
							obj.runFunc();
						}
					}
				}
			},
			buttons : [ {
				text : "${ctp:i18n('common.button.ok.label')}",
				isEmphasize : true,
				handler : function() {
					var isChecked = dialog.getObjectById("continuous_add")[0].checked;
					var objParam = new Object();
					objParam.dialogObj = dialog;
					objParam.isChecked = isChecked;
					if (obj.runFunc) {
						objParam.runFunc = obj.runFunc;
					}
					var ret = dialog.getReturnValue(objParam);
					if (isChecked == true || isChecked == "true") {
						if (ret == true || ret == "true") {
							isContinuous = true;
						}
					}
				}
			}, {
				text : "${ctp:i18n('common.button.cancel.label')}",
				handler : function() {
					if (isContinuous == true || isContinuous == "true") {
						if (obj.runFunc) {
							obj.runFunc();
						}
					}
					dialog.close();
				}
			} ]
		}); */
	}
</script>