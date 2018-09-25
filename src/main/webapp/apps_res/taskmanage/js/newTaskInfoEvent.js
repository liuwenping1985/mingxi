function OK(obj) {
		obj.dialogObj.disabledBtn('ok');
		//$("#projectId").val($("#projectId_txt").val());
		var projectId = $("#projectId").val();//新项目id
		var projectIdOld = $("#projectIdOld").val();//原项目id
		
		pTemp.prompts[0].clearPrompt();
		if(taskAjaxManager){
			var taskAjax = new taskAjaxManager();
			var result = taskAjax.checkTaskProject({"projectId":$("#projectId_txt").val(),"taskId":$("#task_id").val(),"prantTaskId":$("#parent_task_id").val()});
			
			//result返回true；并且是修改；并且有新项目ID
			if(result.canModify && result.giveTips){
				var confirm = $.confirm({
        			'msg': $.i18n('taskmanage.modify.task.in.project'),
        			ok_fn: function () { return getResult(result.canModify,obj);},
        			cancel_fn:function(){return false;}
    			});
			}else{
				return getResult(result.canModify,obj);
			}
		}
}

function getResult(ret,obj){
	if(ret){
		if(obj.operate=="modify"){
			return updateSubmit(obj);
		}
		var valid = $("#taskinfoform").validate();
		if ((valid == true || valid == "true") && isErrMsg() && checkTaskLevel() && checkParentTime() && checkTaskUser()) {
			var subject = $("#subject").val();
			if ($.trim(subject) == "") {
				$.error($.i18n('taskmanage.error.subject.not_empty'));
				obj.dialogObj.enabledBtn('ok');
				return false;
			}
			var sourceId = $("#source_id").val();
			if (sourceId != "-1") {
				var startTime = $("#starttime").val();
				var endTime = $("#endtime").val();
				if (!checkPlanTime(startTime, endTime)) {
					obj.dialogObj.enabledBtn('ok');
					return false;
				}
			}
			startProgressBar($.i18n('taskmanage.save.wait'));
			var isajax = false;
			// 经测试，现在chrome不需要isajax=true来刷新portal,若为ajax提交，会导致页面处于长时间
			// 等待状态
			/*
			 * var isChrome = window.navigator.userAgent.indexOf("Chrome") !==
			 * -1; var from = getUrlPara("from"); if(isChrome && from ==
			 * "Project" && flag == 0){ isajax = true; }
			 */
			$("#taskinfoform").jsonSubmit({
				ajax : isajax,
				domains : [ "domain_task_info" ],
				debug : false,
				callback : function(res) {
					if (res.indexOf("1") > -1) {
						res = 1;
					}
					if (res == 1) {
						try {
							closeProgressBar();
							successEvent(obj);
						} catch (e) {
						}
					}
				}
			});
		} else {
			obj.dialogObj.enabledBtn('ok');
			return false;
		}
		return valid;
	}else{
		$.alert($.i18n('taskmanage.task.not.same.js'));
		obj.dialogObj.enabledBtn('ok');
	}
	return false;
}
			

/**
 * 保存成功后执行事件
 */
function successEvent(obj) {
    if(obj.isChecked) {
        if(obj.isChecked == false || obj.isChecked == "false") {
            if(obj.runFunc) { 
            	if(obj.sectionId){
            		obj.runFunc(obj.sectionId);
            	}else{
            		obj.runFunc();
            	}
            }
            obj.dialogObj.close();
        } else {
        	if(obj.dialogObj.getTransParams()!=null){
        		obj.dialogObj.getTransParams().isExtend = pTemp.winExtend;  
        		if(obj.dialogObj.getTransParams().DiaObjoffsetTop==null){
        			obj.dialogObj.getTransParams().DiaObjoffsetTop= offsetTopFlag;
        		}
        	}
            window.location.reload();
            obj.dialogObj.enabledBtn('ok');
        }
    } else{
      if(obj.runFunc) {
            if(obj.sectionId){
            	obj.runFunc(obj.sectionId);
            }else{
				var listType = checkDataShowType();
				if (listType != null || listType.length > 0) {
					obj.runFunc(listType);
				} else {
					obj.runFunc();
				}
            }
        }
        obj.dialogObj.close();
    }
}

/**
 * 判断是否有错误信息
 */
function isErrMsg() {
    var bool = true;
    if(errMsg.length > 0) {
        $.alert(errMsg);
        bool = false;
    }
    return bool;
}

function addSubmit() {
    var valid = $("#taskinfoform").validate();
    var isChecked = document.getElementById("continuous_add").checked;
    if ((valid == true || valid == "true") && isErrMsg() && checkTaskLevel() && checkParentTime() && checkTaskUser()) {
        var subject = $("#subject").val();
        if($.trim(subject) == ""){
          $.error($.i18n('taskmanage.error.subject.not_empty'));
          return false;
        }
        startProgressBar($.i18n('taskmanage.save.wait'));
        
        $("#taskinfoform").jsonSubmit({
            domains : [ "domain_task_info" ],
            debug : false,
            callback : function(res) {
                if(res.indexOf("1") > -1 ) {
                    res = 1;
                }
                if (res == 1) {
                    closeProgressBar();
                    listType = checkDataShowType();
                    if(isChecked == true || isChecked == "true") {
                        window.location.href = _ctxPath + "/taskmanage/taskinfo.do?method=newTaskInfo&from=Personal&optype=new&flag=0&isFromMenu=1";
                    } else {
                        window.location.href = _ctxPath + "/taskmanage/taskinfo.do?method=listTasksIndex&from=" + listType;
                    }
                }
            }
        });
    }
}

function addCancelEvent(){
    listType = checkDataShowType();
    window.location.href = _ctxPath + '/taskmanage/taskinfo.do?method=listTasksIndex&from=' + listType;
}

/**
 * 修改任务事件
 */
function updateSubmit(obj) {
    var valid = $("#taskinfoform").validate();
    if ((valid == true || valid == "true") && isErrMsg() && checkTaskLevel() && checkParentTime() && checkChildTime() && checkTaskUser()) {
        var subject = $("#subject").val();
        if($.trim(subject) == ""){
          $.error($.i18n('taskmanage.error.subject.not_empty'));
		  obj.dialogObj.enabledBtn('ok');
          return false;
        }
        startProgressBar($.i18n('taskmanage.save.wait'));
        $("#taskinfoform").jsonSubmit({
            domains : [ "domain_task_info" ],
            debug : false,
            callback : function(res) {
            	closeProgressBar();
                successEvent(obj);
            }
        });
        return true;
    } else {
		 obj.dialogObj.enabledBtn('ok');
        return false;
    }
}

/**
 * 检验任务数据显示类型
 * @return 数据显示类型
 */
function checkDataShowType() {
    var currentUserId = $.ctx.CurrentUser.id;
    var type = ""; 
    if ($("#managers").val().indexOf(currentUserId) > -1
            || $("#participators").val().indexOf(currentUserId) > -1) {
        type = "Personal";
    } else if ($("#inspectors").val().indexOf(currentUserId) > -1) {
		type = "TellMe";
	}else{
        type = "Sent";
    }
    return type;
}

/**
 * 选择里程碑事件
 */
function selectedMilestone(obj) {
    if ($(obj).attr("checked")) {
        $("#milestone").val("1");
        if($("#remindstarttime").val() == -1){
            $("#remind_start_time_select").val("10");
            operateRemindStartTime($("#remind_start_time_select").val());
        }
        if($("#remindendtime").val() == -1) {
            $("#remind_end_time_select").val("10");
            operateRemindEndTime($("#remind_start_time_select").val());
        }
    } else {
        $("#milestone").val("0");
    }
}
/**
 * 选择人员操作
 */
function selectPerson(textId, valueId) {
    var txt = $("#" + textId).val();
    var vle = $("#" + valueId).val();
    var oldUserId;
    var size = 0;
    if(valueId == "managers"){
        size = 1;
        oldUserId = $("#inspectors").val() +"," +$("#participators").val();
    } else if(valueId == "inspectors") {
        oldUserId = $("#managers").val() + "," +$("#participators").val();
    } else if(valueId == "participators") {
        oldUserId = $("#managers").val() + "," + $("#inspectors").val();
    }
    $.selectPeople({
        type : 'selectPeople',
        panels : 'Department,Team',
        selectType : 'Member',
        isNeedCheckLevelScope : false,
        excludeElements: oldUserId,
        params : {
            text : txt,
            value : vle
        },
        maxSize : 200,
        minSize: size,
        callback : function(ret) {
            if (ret) {
                $("#" + textId).val(ret.text);
                $("#" + valueId).val(ret.value);
            }
        }
    });
}

/**
 * 显示设置计划时间面板
 */
function showPlannedTime() {
    clearDateControl();
    initStartDate("starttime");
    initEndDate("endtime");
    initTime("start_time_hour", "start_time_minutes");
    initTime("end_time_hour", "end_time_minutes");
    initFullTimeData();
    selectShow();
    panel = $.dialog({
        id : 'plannedTime',
        width : 410,
        height : 360,
        type : 'panel',
        htmlId : 'set_plan_time',
        targetId : 'starttime',
        shadow : false,
        checkMax : false,
        panelParam : {
            'show' : false,
            'margins' : false
        }
    });
    setDateData("starttime", "start_date");
    setDateData("endtime", "end_date");
    setTimeData("starttime", "start_time_hour", "start_time_minutes");
    setTimeData("endtime", "end_time_hour", "end_time_minutes");
    setDefaultTime($("#fulltimetext").val());
    setRemindTime("remindstarttime", "remind_start_time_select");
    setRemindTime("remindendtime", "remind_end_time_select");
    bindPlannedTimeEvent();
}

/**
 * 显示设置实际时间面板
 */
function showActualTime() {
    clearDateControl();
    initStartDate("actual_start_time");
    initEndDate("actual_end_time");
    initTime("start_time_hour", "start_time_minutes");
    initTime("end_time_hour", "end_time_minutes");
    initFullActualTimeData();
    selectShow();
    panel = $.dialog({
        id : 'actualTime',
        width : 410,
        height : 330,
        type : 'panel',
        htmlId : 'set_plan_time',
        targetId : 'actual_start_time',
        shadow : false,
        checkMax : false,
        panelParam : {
            'show' : false,
            'margins' : false
        }
    });
    setDateData("actual_start_time", "start_date");
    setDateData("actual_end_time", "end_date");
    setTimeData("actual_start_time", "start_time_hour", "start_time_minutes");
    setTimeData("actual_end_time", "end_time_hour", "end_time_minutes");
    setDefaultTime($("#fulltimetext").val());
    $("#remind_time").addClass("hidden");
    bindActualTimeEvent();
}

/**
 * 选择是否是全天
 * @param obj 复选框对象
 */
function selectFullTime(obj) {
    if ($(obj).attr("checked")) {
        $("#fulltimetext").val("1");
    } else {
        $("#fulltimetext").val("0");
    }
}

/**
 * 清除日期控件
 */
function clearDateControl() {
    if(panel != undefined) {
        panel.close();
        panel = null;
    }
    if ($("div.calendar").length > 0) {
        $("div.calendar").remove();
    }
}
/**
 * 关闭设置计划时间面板
 */
function closePlannedTime() {
    panel.close();
    RemoveCheckMsg($("#endtime"));
}

/**
 * 关闭设置实际时间面板
 */
function closeActualTime() {
    panel.close();
}

/**
 * 设置开始日期
 * @param date 日期时间
 */
function showStart(date) {
    $("#start_date").val(date);
}

/**
 * 设置结束日期
 * @param date 日期时间
 */
function showEnd(date) {
    $("#end_date").val(date);
}

/**
 * 操作开始前提醒时间
 * @param remindStartTime 开始前提醒时间
 */
function operateRemindStartTime(remindStartTime) {
    if (remindStartTime.length > 0) {
        $("#remindstarttime").val(remindStartTime);
        if (remindStartTime > -1) {
            $("#remind_start_time_img").css("display", "block");
            $("#remind_start_time_img").attr(
                    "title",$.i18n('taskmanage.reminderTime.before_start.label') + ": "+ $("#remind_start_time_select").find("option:selected").text());
            if($(".remindImg1").attr("width") == "0"){
            		$(".remindImg1").show().attr("width","16");
            		$(".remindImgTime1").attr("width","210");
        		}
        } else {
            $("#remind_start_time_img").css("display", "none");
            $("#remind_start_time_img").removeAttr("title");
            if($(".remindImg1").attr("width") != "0"){
            		$(".remindImg1").hide().attr("width","0");
            		$(".remindImgTime1").attr("width","230");
        		}
        }
    }
}

/**
 * 操作结束前提醒时间
 * @param remindEndTime 结束前提醒时间
 */
function operateRemindEndTime(remindEndTime) {
    if (remindEndTime.length > 0) {
        $("#remindendtime").val(remindEndTime);
        if (remindEndTime > -1) {
            $("#remind_end_time_img").css("display", "block");
            $("#remind_end_time_img").attr(
                    "title",
                    $.i18n('taskmanage.reminderTime.before_end.label') + ": "
                            + $("#remind_end_time_select").find("option:selected").text());
            if(!$(".remindImg2").attr("width") == "0"){
            	$(".remindImg2").show().attr("width","18");
            	$(".remindImgTime2").attr("width","208");
				$(".remindImgTime2 .common_txtbox_wrap").removeAttr("style")
        	}
        } else {
            $("#remind_end_time_img").css("display", "none");
            $("#remind_end_time_img").removeAttr("title");
          	if($(".remindImg2").attr("width") != "0"){
          		 $(".remindImg2").hide().attr("width","0");
          		 $(".remindImgTime2").attr("width","230");
          	}
        }
    }
}

/**
 * 设置计划时间提交结果
 * @param startTime 开始时间
 * @param endTime 结束时间
 * @param fullTime 全天
 * @param remindStartTime 开始前提醒
 * @param remindEndTime 结束前提醒
 */
function setPlanTimeSubmitResult(startTime, endTime, fullTime,
        remindStartTime, remindEndTime) {
    if (startTime.length > 0) {
        $("#starttime").val(startTime);
    }
    if (endTime.length > 0) {
        $("#endtime").val(endTime);
    }
    if (fullTime.length > 0) {
        $("#fulltime").val(fullTime);
    }
    operateRemindStartTime(remindStartTime);
    operateRemindEndTime(remindEndTime);
}
/**
 * 设置计划时间确定按钮事件
 */
function setPlanTimeSubmit() {
    var startTime;
    var endTime;
    var fullTimeText;
    var remindStartTime;
    var remindEndTime;
    fullTimeText = $("#fulltimetext").val();
    if ($("#start_date").val().length > 0) {
        startTime = $("#start_date").val();
        if ($("#start_time_hour").val().length > 0) {
            if(fullTimeText != 1) {
                startTime += " " + $("#start_time_hour").val();
                if ($("#start_time_minutes").val().length > 0) {
                    startTime += ":" + $("#start_time_minutes").val();
                }
            }
        }
    }
    if ($("#end_date").val().length > 0) {
        endTime = $("#end_date").val();
        if ($("#end_time_hour").val().length > 0) {
            if(fullTimeText != 1) {
                endTime += " " + $("#end_time_hour").val();
                if ($("#end_time_minutes").val().length > 0) {
                    endTime += ":" + $("#end_time_minutes").val();
                }
            }
        }
    }
    remindStartTime = $("#remind_start_time_select").val();
    remindEndTime = $("#remind_end_time_select").val();
    if (checkPlanTime(startTime, endTime)) {
        var bool = comparePlanEndTime(endTime);
        if (bool || bool == "true") {
            $.confirm({
                'msg' : $.i18n("taskmanage.msg.endtime.early.systemtime"),
                ok_fn : function() {
                    setPlanTimeSubmitResult(startTime, endTime,
                            fullTimeText, remindStartTime, remindEndTime);
                    closePlannedTime();
                },
                cancel_fn : function() {
                }
            });
        } else {
            setPlanTimeSubmitResult(startTime, endTime, fullTimeText,
                    remindStartTime, remindEndTime);
            closePlannedTime();
            $(".remindImgTime2 .common_txtbox_wrap").removeAttr("style");//在显示不能为空的图标后 ，有提示结束时间图标，就不设置宽度了
        }
    }
}

/**
 * 设置实际时间提交结果
 * @param startTime 开始时间
 * @param endTime 结束时间
 */
function setActualTimeSubmitResult(startTime, endTime) {
    if (startTime.length > 0) {
        $("#actual_start_time").val(startTime);
    }
    if (endTime.length > 0) {
        $("#actual_end_time").val(endTime);
    }
}
/**
 * 设置实际时间确定按钮事件
 */
function setActualTimeSubmit() {
    var startTime;
    var endTime;
    var fullTimeText;
    fullTimeText = $("#fulltimetext").val();
    if ($("#start_date").val().length > 0) {
        startTime = $("#start_date").val();
        if ($("#start_time_hour").val().length > 0) {
            if(fullTimeText != 1) {
                startTime += " " + $("#start_time_hour").val();
                if ($("#start_time_minutes").val().length > 0) {
                    startTime += ":" + $("#start_time_minutes").val();
                }
            }
        }
    }
    if ($("#end_date").val().length > 0) {
        endTime = $("#end_date").val();
        if ($("#end_time_hour").val().length > 0) {
            if(fullTimeText != 1) {
                endTime += " " + $("#end_time_hour").val();
                if ($("#end_time_minutes").val().length > 0) {
                    endTime += ":" + $("#end_time_minutes").val();
                }
            }
        }
    }
    var tempStartTime = "";
    var tempEndTime = "";
    if ($("#fulltimetext").val() == 1) {
        tempStartTime = startTime + " 00:00";
        tempEndTime = endTime + " 23:59";
    }
    if (compareDate(tempStartTime, tempEndTime) >= 0) {
        $.alert("任务的实际开始时间应当早于实际结束时间！");
    } else {
        setActualTimeSubmitResult(startTime, endTime);
        closeActualTime();
    }
}

/**
 * 修改任务中取消按钮事件
 */
function updateCancelEvent(){
    $('#update_iframe', window.parent.document).addClass("hidden");
    $('#update_iframe', window.parent.document).attr("src", "");
    $('#task_info_div', window.parent.document).removeClass("hidden");
}

/**
 * 上级任务列表
 */
function listParentTasksDialog() {
    var title = $.i18n('taskmanage.parentTask.select');
    var parentId = $("#parent_task_id").val();
    var taskId = $("#task_id").val();
    var projectCond = "";
    //,("Personal"==listType || "Sent"==listType) && "new"==optype 
    if($("#projectId").val() != "-1"){
        projectCond = "&from=newTask&projectId=" + $("#projectId").val() + "&projectPhaseId=" + $("#projectPhaseId").val();
    }
    var dialog = $.dialog({
        id : 'parent_task',
        url : _ctxPath + '/taskmanage/taskinfo.do?method=listParentTasks&parentId='+parentId + "&taskId=" + taskId + "&isFromParent=1" + projectCond,
        width : $(getCtpTop()).width()-100,
        height : $(getCtpTop()).height()-100,
        title : title,
        targetWindow : getCtpTop(),
        buttons : [ {
            text : $.i18n('common.button.ok.label'),isEmphasize:true,
            handler : function() {
                var ret = dialog.getReturnValue();
                var taskAjax = new taskAjaxManager();
                if(ret != null && ret.length > 0) {
                    var taskDetailData = null;
                    taskDetailData = taskAjax.taskInfoDetailed(ret);
                    if(taskDetailData != null) {
                    	var taskParentIdOld = $("#parent_task_id").val();
                    	if(ret != taskParentIdOld){//修改了上级任务，权重自动回填0，OA-75971
                    		$("#weight").val(0);
                    	}
                        $("#parent_task_id").val(taskDetailData.id);
                        $("#parent_task_text").val(taskDetailData.subject);
                        $("#parent_logical_path").val(taskDetailData.logicalPath);
                        if(optype != "update"){
                            $("#importantlevel").val(taskDetailData.importantLevel);
                            $("#fulltime").val(taskDetailData.fulltime);
                            if(taskDetailData.plannedStartTime.length > 0){
                                $("#starttime").val(taskDetailData.plannedStartTime);
                            } else {
                                $("#starttime").val(new Date().print("%Y-%m-%d"));
                            }
                            if(taskDetailData.plannedEndTime.length > 0){
                                $("#endtime").val(taskDetailData.plannedEndTime);
                            }
                        }
                        //OA-75330新建任务，选择上级任务，选择后，任务的角色数据回显错误
                        if(!$.isNull(taskDetailData.managers)){
                            $("#managers_text").val(taskDetailData.managerNames);
                            $("#managers").val(taskDetailData.managers);
                        }
                        //if($("#inspectors_text").val().length == 0){
                            //$("#inspectors_text").val(taskDetailData.inspectorsName);
                            //$("#inspectors").val(taskDetailData.inspectors);
                        //}
                        if (taskDetailData.projectId != -1) {
                            $("#projectId").val(taskDetailData.projectId);
                            $("#projectId_txt").val(taskDetailData.projectId);
                            $("#projectPhaseId").val(taskDetailData.projectPhaseId);
                        }
                    } 
                } else {
                    $("#parent_task_id").val("-1");
                    $("#parent_task_text").val("");
                    $("#parent_logical_path").val("");
                }
                
                if(typeof (fnToggleWeight) !== 'undefined'){
                	fnToggleWeight();
                }
                
                dialog.close();
            }
        }, {
            text : $.i18n('common.button.cancel.label'),
            handler : function() {
                dialog.close();
            }
        } ]
    });
}

/**
 * 检查当前任务在逻辑层级的深度
 */
function checkTaskLevel(){
    var bool = true;
    var logicalPath = $("#parent_logical_path").val();
    var index = logicalPath.split(".").length;
    if(index >= 10 && optype != "update") {
        $.alert($.i18n('taskmanage.alert.task_level_not_more_than_10'));
        bool = false;
    }
    return bool;
}