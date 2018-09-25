var listType = getUrlPara("from");
var optype = getUrlPara("optype");
var flag = getUrlPara("flag");
var isFromMenu = getUrlPara("isFromMenu");
var panel,pTemp = {};
var proce;
var errMsg = "";
var fixFlag = true;
var offsetTopFlag;
$(function(){
	//单独抽一个方法用于避免按钮被遮住
	fitClientWindow();
  setFixFlag();
  fnCss();
  initEvent();
  initSubmitUrl();
  initPlanToTask();
});

function fnCss(){
	//连续添加保持状态一致
	var from = getUrlPara("from");//Decompose ,new,update
	var content = $("#content").val();
	var prompts = [];
 	prompts.push($("#content").prompt({ownContent: $.i18n('taskmanage.content.alert.js')}));
 	pTemp.prompts = prompts;
	if(optype == "new" && "Decompose" != from && "1" != flag) {
	}else if (optype == "update") {
		$(".actual_time").show();
		if($("#source_id").val() != "-1") {
			if($("#source_name_a").html()!=undefined){
				$("#source_name_a").html(getSubString($("#source_name_a").html(),0,60));
			}
			$("#source_info").addClass("extendClass");
		}
	    initMilestone();
	    initRemindTime();
	    pTemp.prompts[0].clearPrompt();
	    $("#content").val(content);
	}else if(from == "Decompose" || "1" == flag){
		$("#inspectors_text,#inspectors,#old_inspectors").val("");
	}
	fnToggleWeight();
	$("#topEm").addClass("arrow_2_b").removeClass("arrow_2_t");
	$(".extendClass,.weight_area").hide();
}

function fnGetDialog(){
	var dialog = null;
	try {
		dialog = getCtpTop().frames["main"].frames["content_iframe"].dialog;
	} catch (e) {}
	
	if (!dialog) {
		try {
			dialog = getCtpTop().frames["main"].frames["body"].dialog;
		} catch (e) {}
	}
	
	if (!dialog) {
		try {
			var win = getCtpTop().$("#main")[0].contentWindow;
			dialog = win.dialog;
		}catch (e){}
	}
	
	if (!dialog) {
		try {
			dialog = window.parentDialogObj["new_task"];
		} catch (e) {}
	}
	
	if(!dialog){
		try{
			dialog = getCtpTop().frames["main"].frames["list_content_iframe"].dialog;
		}catch(e){}
	}
	
	if(!dialog){
		try {
			var contentIframe = getCtpTop().frames["main"].frames["content_iframe"];
			if(contentIframe){
				dialog = contentIframe.frames["taskinfo_iframe"].frames["taskDetail_content_iframe"].dialog;
			}
		} catch (e) {}
	}
	return dialog;
}

function fnToggleWeight(){
	if ($("#parent_task_id").val() == "-1"||$("#parent_task_id").val()=="") {
		$(".weight_area").hide();
  } else {
      $(".weight_area").show();
  }
}

function fitClientWindow(){
	var minHeight = 515;//新建多于515px  会出现遮挡按钮的情况
	if(optype=="update"){
		minHeight=580;//更新多两个两个框更高一点
	}
	//经测试当浏览器可用窗口的大小为665时需要控制dialog的大小
	if(getCtpTop().document.body.clientHeight<minHeight){
		var dialogHeight = getCtpTop().document.body.clientHeight - 80-parent.$("#new_task")[0].offsetTop;
		fnGetDialog().reSize({height:dialogHeight,positionFix:fixFlag});
	}
}
/**
 * 缩放
 */
function fnToggleDialog(isResize){
		var em = $("#topEm");
		fitClientWindow()
	if(em.hasClass("arrow_2_t")){
		em.removeClass("rolling_btn_t").addClass("rolling_btn_b");
		em.removeClass("arrow_2_t").addClass("arrow_2_b");
		$(".extendClass").hide();
	}else{
		em.removeClass("rolling_btn_b").addClass("rolling_btn_t");
		em.removeClass("arrow_2_b").addClass("arrow_2_t");
		$(".extendClass").show(); 
		var planData =window.dialogArguments ? window.dialogArguments.planData:null;
		if(planData && planData.planName){
			$("#source_info").show();
		}
		$('html, body').animate({scrollTop: $(document).height()}, 0); 
		fnToggleWeight();
	}
}

/**
 * 填充计划转任务的数据信息
 */
function initPlanToTask() {
    if(window.dialogArguments){
        var planData = window.dialogArguments.planData;
        if(planData && planData.planId) {
            $("#subject").val(planData.eventDesc);
            $("#repeat_title").val(planData.eventDesc);
            var important = 1;
            if(planData.importantLevel != undefined && planData.importantLevel.length > 0) {
                if(planData.importantLevel == 0) {
                    important = 3;
                } else if (planData.importantLevel == 2) {
                    important = 2;
                } else {
                    important = 1;
                }
            }
            $("#importantlevel").val(important);
            var startTime = "";
            var endTime = ""; 
            if(planData.startTime && planData.startTime != null && planData.startTime != "null" && planData.startTime.length > 0){
                startTime = planData.startTime;
                if(planData.dateType == 1) {
                    startTime = startTime.substring(0,10);
                } else {
                    if(startTime.length > 16) {
                        startTime = startTime.substring(0,16);
                    }
                }
            } else {
                if(planData.endTime && planData.endTime != null && planData.endTime != "null" && planData.endTime.length > 0){
                    if(planData.dateType == 1) {
                        startTime = planData.endTime.substring(0,10);
                    } else {
                        var date = new Date(parseDate(planData.endTime.substring(0, 16)));
                        var toDate = date.getTime() - 1800000;
                        startTime = new Date(toDate).print("%Y-%m-%d %H:%M");
                    }
                } else {
                    var planMgr = new planManager();
                    var planObj = planMgr.selectById(planData.planId);
                    startTime = planObj.startTime.substring(0,10);
                }
            }
            if(planData.endTime && planData.endTime != null && planData.endTime != "null" && planData.endTime.length > 0){
                endTime = planData.endTime;
                if(planData.dateType == 1) {
                    endTime = endTime.substring(0,10);
                } else {
                    if(endTime.length > 16) {
                        endTime = endTime.substring(0,16);
                    }
                }
            } else {
                if (planData.startTime && planData.startTime != null && planData.startTime != "null" && planData.startTime.length > 0) {
                    if(planData.dateType == 1) {
                        endTime = planData.startTime.substring(0,10);
                    } else {
                        var date = new Date(parseDate(planData.startTime.substring(0, 16)));
                        var toDate = date.getTime() + 1800000;
                        endTime = new Date(toDate).print("%Y-%m-%d %H:%M");
                    }
                } else {
                    var planMgr = new planManager();
                    var planObj = planMgr.selectById(planData.planId);
                    endTime = planObj.endTime.substring(0,10);
                }
            }
            $("#starttime").val(startTime);
            $("#endtime").val(endTime);
            if(startTime.length > 10 && endTime.length > 10){
                $("#fulltime").val("0");
                $("#fulltimetext").val("0");
            } else {
                $("#fulltime").val("1");
                $("#fulltimetext").val("1");
            }
            var taskAjax = new taskAjaxManager();
            if(planData.owner && planData.owner != null && planData.owner != "null" && planData.owner != "0"){
                $("#managers").val(setMemberId(planData.owner));               
                taskAjax.findMemberNames(planData.owner, {
                    success : function(ret){
                        $("#managers_text").val(ret);
                    }, 
                    error : function(request, settings, e){
                        $.alert(e);
                    }
                });
            }
            if(planData.participate && planData.participate != null && planData.participate != "null" && planData.participate != "0"){
                $("#participators").val(setMemberId(planData.participate));
                taskAjax.findMemberNames(planData.participate, {
                    success : function(ret){
                        $("#participators_text").val(ret);
                    }, 
                    error : function(request, settings, e){
                        $.alert(e);
                    }
                });
            }
            if(planData.examiner && planData.examiner != null && planData.examiner != "null" && planData.examiner != "0"){
                $("#inspectors").val(setMemberId(planData.examiner));
                taskAjax.findMemberNames(planData.examiner, {
                    success : function(ret){
                        $("#inspectors_text").val(ret);
                    }, 
                    error : function(request, settings, e){
                        $.alert(e);
                    }
                });
            }
            $("#source_id").val(planData.planId);
            if(planData.planName){
                var sourceName = $.i18n('taskmanage.plan.label')+"[<a title='"+planData.planName+"' href='javascript:void(0)' onclick='openPlan(\"" + planData.planId + "\",null,true,null,null,true)'>"+ getSubString(planData.planName,0,60) + "</a>]";
                $("#source_name").html(sourceName);
                $("#source_info").addClass("extendClass");
            } else {
                $("#source_info").hide();
            }
            $("#source_type").val("1");
            $("#source_record_id").val(planData.recordId);
        }
    }
}

/**
 * 按像素截取字符串
 * @author shuqi
 * @param string
 * @param start
 * @param length
 * @returns
 */
function getSubString(string,start,length){
	var len = 0;
	for(var i=start;len<length&&i<string.length;i++){
		if(!string.charCodeAt(i))  
            break;  
		if(string.charCodeAt(i)>255){
			len+=2;
		}else{
			len+=1;
		}
		if(len>=length&&i+1==string.length){
			return string;
		}else if(len>=length){
			return string.substring(start,i)+"..";
		}
	}
	return string.substring(start,length);
}
function setMemberId(userId) {
    var userIdStr = null;
    if(userId.length > 0){
        if(userId.indexOf(",") > 0) {
            var strTemp = userId.split(",");
            for(var i = 0;i<strTemp.length;i++){
                if(i == 0){
                    userIdStr = "Member|"+strTemp[i];
                } else {
                    userIdStr += ",Member|"+strTemp[i];
                }
            }
        } else {
            userIdStr = "Member|"+userId;
        }
    }
    return userIdStr;
}

/**
 * 初始化保存数据路径
 */
function initSubmitUrl() {
    if (optype.length != 0 && optype == "new") {
        $("#taskinfoform").attr("action", _ctxPath + "/taskmanage/taskinfo.do?method=addTask");
    } else if (optype.length != 0 && optype == "update") {
        $("#taskinfoform").attr("action", _ctxPath + "/taskmanage/taskinfo.do?method=modifyTask");
    }
}

/**
 * 初始化默认的计划开始时间
 */
function initDefaultPlannedStartTime() {
    var date = new Date();
    var nowDate = date.print("%Y-%m-%d");
    $("#starttime").val(nowDate);
}

/**
 * 初始化默认的计划结束时间
 */
function initDefaultPlannedEndTime() {
    var date = new Date();
    var nowDate = date.print("%Y-%m-%d");
    $("#endtime").val(nowDate);
}

/**
 * 初始化负责人的默认数据
 */
function initManagersText() {
    if ($.ctx.CurrentUser) {
        $("#managers_text").val($.ctx.CurrentUser.name);
        $("#managers").val("Member|" + $.ctx.CurrentUser.id);
    }
}

/**
 * 初始化页面事件
 */
function initEvent() {
		$("#projectIdOld").val($("#projectId").val());
		//初始化所属项目
		initProjectSelect({"class":"w100b","id":"projectId_txt"},"projectDiv",null,function() {
			$("#projectId").val($("#projectId_txt").val());
		});
		setTimeout(function(){
			var hasOption = true;
			var currentId = $("#projectId").val();
			var currentName = $("#projectName").val();
			//如果URL传递了Id且存在13个以内，则直接赋值，否则在更多前边加一个新的project的option并回填
			if($("#projectId_txt [value='"+currentId+"']").length==0&&currentName.length>0){
				var hh="<option value='"+currentId+"' title='"+currentName.escapeHTML()+"' id='selProject'>"+currentName.escapeHTML()+"</option>";
				fillProject(hh,"projectId_txt",currentId,currentName)
			}else{
				$("#projectId_txt").val($("#projectId").val());
			}
		},618);
    $("#starttime").parent().find(".calendar_icon").bind("click", showPlannedTime);
    $("#endtime").parent().find(".calendar_icon").bind("click", showPlannedTime);
    $("#actual_start_time").parent().find(".calendar_icon").bind("click", showActualTime);
    $("#actual_end_time").parent().find(".calendar_icon").bind("click", showActualTime);
    $("#milestone_check").bind("click", function() {
        selectedMilestone(this);
    });
    $("#managers_text").bind("click", function() {
        selectPerson("managers_text", "managers");
    });
    $("#inspectors_text").bind("click", function() {
        selectPerson("inspectors_text", "inspectors");
    });
    $("#participators_text").bind("click", function() {
        selectPerson("participators_text", "participators");
    });
    if((optype.length != 0 && optype == "new") && (isFromMenu != null && isFromMenu == "1")) {
        $("#btn_submit").bind("click", addSubmit);
        $("#btn_cancel").bind("click", addCancelEvent);
    }else if (optype.length != 0 && optype == "update") {
        $("#btn_submit").bind("click", updateSubmit);
        $("#btn_cancel").bind("click", updateCancelEvent);
    }
    $("#parent_task_text").bind("click", listParentTasksDialog);
    bindWeightInputEvent();
}

/**
 * 输入框只能输入数字
 */
$.fn.inputNumber= function() { 
	$(this).css("ime-mode", "disabled"); 
	this.bind("keypress",function(e) {
		var code = (e.keyCode ? e.keyCode : e.which); //兼容火狐 IE
		if(this.value.indexOf(".")==-1){
			if (!$.browser.mozilla) {
				return (code >= 48 && code<= 57) || (code==46);
			} else {
				return (code >= 48 && code<= 57) || (code==46) || (code==8);
			}
		}else{
			if (!$.browser.mozilla) {
				return code >= 48 && code<= 57;
			} else {
				return (code >= 48 && code<= 57) || (code==8);
			}	
		} 
	}); 
	this.bind("paste", function() { 
		return false; 
	}); 
	this.bind("keyup", function() {
		if(this.value.slice(0,1) == "."){ 
			this.value = ""; 
		} 
	});
}
/**
 * 绑定权重输入框录入事件
 */
function bindWeightInputEvent() {
	//绑定权重输入框只能输入数字
	$("#weight").inputNumber();
    $("#weight").bind("blur",function() {
    	if(this.value.slice(-1) == "."){ 
			this.value = this.value.slice(0,this.value.length-1); 
		}
        if(!checkWeightPurview()){
            errMsg = $.i18n('taskmanage.alert.weight.zero_hundred');
            $.alert(errMsg);
        } else {
            if(checkCildTaskWeightSum()){
                errMsg = $.i18n('taskmanage.alert.weight.more_than_100_percent');
                $.alert(errMsg);
            } else {
                errMsg = "";
            }
        }
    });
}

/**
 * 计划时间设置页面按钮事件绑定
 */
function bindPlannedTimeEvent() {
    $("#btnok").unbind().bind("click", setPlanTimeSubmit);
    $("#btncancel").unbind().bind("click", closePlannedTime);
    $("#fulltimechk").unbind().bind("click", function() {
        selectFullTime(this);
        setDefaultTime($("#fulltimetext").val());
    });
}

/**
 * 实际时间设置页面按钮事件绑定
 */
function bindActualTimeEvent() {
    $("#btnok").unbind().bind("click", setActualTimeSubmit);
    $("#btncancel").unbind().bind("click", closeActualTime);
    $("#fulltimechk").unbind().bind("click", function() {
        selectFullTime(this);
        setDefaultTime($("#fulltimetext").val());
    });
}

/**
 * 初始化默认时间
 */
function setDefaultTime(fullTime) {
    if (fullTime == 1) {
        $("#start_time_hour").attr("disabled", true);
        $("#start_time_minutes").attr("disabled", true);
        $("#end_time_hour").attr("disabled", true);
        $("#end_time_minutes").attr("disabled", true);
        $("#start_time_hour").val("00");
        $("#start_time_minutes").val("00");
        $("#end_time_hour").val("23");
        $("#end_time_minutes").val("59");
    } else {
        $("#start_time_hour").attr("disabled", false);
        $("#start_time_minutes").attr("disabled", false);
        $("#end_time_hour").attr("disabled", false);
        $("#end_time_minutes").attr("disabled", false);
    }
}

/**
 * 初始化开始日期
 */
function initStartDate(startId) {
    var date = null;
    var starttime = $("#" + startId).val();
    if (starttime.length > 0) {
        date = new Date(parseDate(starttime.substring(0, 10)));
    } else {
        date = new Date();
    }
    $.calendar({
        displayArea : 'start_date',
        flat : 'startdate',
        returnValue : true,
        date : date,
        onUpdate : showStart,
        ifFormat : "%Y-%m-%d",
        daFormat : "%Y-%m-%d",
        dateString : date.toDateString(),
        showsTime : false,
        hideOkClearButton : true
    });
    var nowDate = date.print("%Y-%m-%d");
    $("#start_date").val(nowDate);
}

/**
 * 初始化结束日期
 */
function initEndDate(endId) {
    var date = null;
    var endtime = $("#" + endId).val();
    if (endtime.length > 0) {
        date = new Date(parseDate(endtime.substring(0, 10)));
    } else {
        date = new Date();
    }
    $.calendar({
        displayArea : 'end_date',
        flat : 'enddate',
        returnValue : true,
        date : date,
        onUpdate : showEnd,
        ifFormat : "%Y-%m-%d",
        daFormat : "%Y-%m-%d",

        showsTime : false,
        hideOkClearButton : true
    });
    var nowDate = date.print("%Y-%m-%d");
    $("#end_date").val(nowDate);
}

/**
 * 初始化时间
 */
function initTime(startId, endId) {
    var time;
    if ($("#" + startId + " option").length == 0) {
        for ( var i = 0; i <= 23; i++) {
            if (i < 10) {
                time = "0" + i;
            } else {
                time = i;
            }
            $("#" + startId).append("<option value='"+time+"'>" + time + "</option>");
        }
    }
    if ($("#" + endId + " option").length == 0) {
        for ( var i = 0; i < 60; i++) {
            if (i < 10) {
                time = "0" + i;
            } else {
                time = i;
            }
            $("#" + endId).append(
                    "<option value='"+time+"'>" + time + "</option>");
        }
    }
}

/**
 * 初始化全天数据
 */
function initFullTimeData() {
    if ($("#fulltime").val() == 1) {
        $("[name = fulltimechk]:checkbox").attr("checked", true);
        $("#fulltimetext").val(1);
    } else {
        $("[name = fulltimechk]:checkbox").attr("checked", false);
        $("#fulltimetext").val(0);
    }
}

/**
 * 初始化全天数据
 */
function initFullActualTimeData() {
    if ($("#actual_start_time").val().length > 10) {
        $("[name = fulltimechk]:checkbox").attr("checked", false);
        $("#fulltimetext").val(0);
    } else {
        $("[name = fulltimechk]:checkbox").attr("checked", true);
        $("#fulltimetext").val(1);
    }
}

/**
 * 设置日期参数
 * @param paramId 参数控件id
 * @param hourId 日期控件id
 */
function setDateData(paramId, dateId) {
    var time = $("#" + paramId).val();
    if (time.length > 0) {
        if (time.length > 10) {
            var date = time.substring(0, 10);
            $("#" + dateId).val(date);
        } else {
            $("#" + dateId).val(time);
        }
    }
}

/**
 * 设置时间参数
 * @param paramId 参数控件id
 * @param hourId 小时控件id
 * @param minutesId 分钟控件id
 */
function setTimeData(paramId, hourId, minutesId) {
    var time = $("#" + paramId).val();
    if (time.length > 10 && $("#fulltimetext").val() == 0) {
        var timeTemp = time.substring(11, time.length);
        var times = timeTemp.split(":");
        if (times.length > 1) {
            $("#" + hourId).val(times[0]);
            $("#" + minutesId).val(times[1]);
        }
    }
}

/**
 * 设置提醒时间参数
 * @param paramId 参数控件id
 * @param timeId 提醒时间控件id
 */
function setRemindTime(paramId, timeId) {
    var paramObj = $("#" + paramId).val();
    if (paramObj.length > 0) {
        $("#" + timeId).val(paramObj);
    }
}

/**
 * 将日期字符转换成日期类型
 * 
 * @param dateStr 日期字符串
 * @return 转换后日期
 */
function parseDate(dateStr) {
    return Date.parse(dateStr.replace(/\-/g, '/'));
}

/**
 * 比较两个字符串日期的前后，不比较时间
 * 
 * @param dateStr1 日期1 字符串
 * @param dateStr2 日期2 字符串
 * @return 负整数、零或正整数，根据此对象是小于、等于还是大于
 */
function compareDate(dateStr1, dateStr2) {
    return parseDate(dateStr1) - parseDate(dateStr2);
}

/**
 * 比较计划结束时间和系统时间前后
 * 
 * @param endTime 计划结束时间
 * @return 如果计划结束时间小于系统时间就返回true
 */
function comparePlanEndTime(endTime) {
    var bool = false;
    var nowDate = new Date();
    if ($("#fulltimetext").val() == 1) {
        endTime += " 23:59";
    }
    if (compareDate(nowDate.print("%Y-%m-%d %H:%M"), endTime) > 0) {
        bool = true;
    }
    return bool;
}

/**
 * 下拉列表框显示
 */
function selectShow() {
    $("#remind_start_time_select").css("visibility", "inherit");
    $("#remind_end_time_select").css("visibility", "inherit");
    $("#start_time_hour").css("visibility", "inherit");
    $("#start_time_minutes").css("visibility", "inherit");
    $("#end_time_hour").css("visibility", "inherit");
    $("#end_time_minutes").css("visibility", "inherit");
}

/**
 * 验证计划时间
 * 
 * @param startTime 计划开始时间
 * @param endTime 计划结束时间
 * @return 验证通过返回为true
 */
function checkPlanTime(startTime, endTime) {
    if ($("#fulltimetext").val() == 1) {
        startTime += " 00:00";
        endTime += " 23:59";
    }
    if (compareDate(startTime, endTime) >= 0) {
        $.alert($.i18n('taskmanage.alert.planTime.start_time_before_end_time'));
        return false;
    }
    var duration = (parseDate(endTime) - parseDate(startTime))
            / (1000 * 60);
    var endRemindTime = $('#remind_end_time_select').val();
    if (endRemindTime >= duration) {
        $.alert($.i18n('taskmanage.alert.reminder_time_setting_not_reasonable',duration ,endRemindTime));
        return false;
    }
    return true;
}

/**
 * 启动进度条
 */
function startProgressBar(meg) {
    proce = $.progressBar({
        text : meg
    });
}

/**
 * 关闭进度条
 */
function closeProgressBar() {
    if (proce && proce != null) {
        proce.close();
        proce = null;
    }
}

/**
 * 初始化里程碑数据
 */
function initMilestone() {
    if ($("#milestone").val() == "1") {
        $("#milestone_check").attr("checked", true);
    }
}

/**
 * 初始化提醒时间数据
 */
function initRemindTime() {
    $("#remind_start_time_select").val($("#remindstarttime").val());
    $("#remind_end_time_select").val($("#remindendtime").val());
    operateRemindStartTime($("#remind_start_time_select").val());
    operateRemindEndTime($("#remind_end_time_select").val());
}

/**
 * 验证权重输入的范围（数字：最多含一个小数位；数值在0.0 – 100.0之间）
 * 
 * @param value 权重数字
 */
function checkWeightPurview(){
    var input = $("#weight");
    var v = $.trim(input.val());
    var bool = true;

    var reg = new RegExp("^[0-9]+(.[0-9]{1})?$", "g");
    if (!reg.test(v)) {
        bool = false;
    } else{
        if(!(v >= 0 && v <= 100)){
            bool = false;
        }
    }
    return bool;
} 

/**
 * 验证子任务权重数值求和
 */
function checkCildTaskWeightSum() {
    var taskAjax = new taskAjaxManager();
    var bool = taskAjax.checkChildTaskWeightSum($("#parent_task_id").val(),$("#weight").val(),$("#task_id").val());
    return bool;
}

/**
 * 验证子任务时间必须在父任务事件范围内
 */
function checkParentTime(){
    var startTime = $("#starttime").val();
    var endTime = $("#endtime").val();
    if ($("#fulltime").val() == 1) {
        startTime += " 00:00";
        endTime += " 23:59";
    }
    if($("#parent_task_id").val() != -1) {
        var taskAjax = new taskAjaxManager();
        var parentTask = null;
        parentTask = taskAjax.taskInfoDetailed($("#parent_task_id").val());
        if(parentTask != null){
            var len = parentTask.plannedStartTime.length;
            if (compareDate(parentTask.plannedStartTime, startTime.substring(0,len)) > 0) {
                $.alert($.i18n('taskmanage.alert.subtasks_time_set_range_superiors'));
                return false;
            }
            if (compareDate(endTime.substring(0,len), parentTask.plannedEndTime) > 0) {
                $.alert($.i18n('taskmanage.alert.subtasks_time_set_range_superiors'));
                return false;
            }
        }
    }
    return true;
}

/**
 * 验证父任务时间不能小于子任务
 */
function checkChildTime(){
    var startTime = $("#starttime").val();
    var endTime = $("#endtime").val();
    var bool = false;
    if($("#task_id").val().length != 0) {
        var taskAjax = new taskAjaxManager();
        if ($("#fulltime").val() == 1) {
            startTime += " 00:00";
            endTime += " 23:59";
        }
        var bool = taskAjax.checkChildTaskTime(startTime,endTime,$("#task_id").val());
        if(bool) {
            $.alert($.i18n('taskmanage.alert.subtasks_time_set_range_superiors'));
            return false;
        }
    }
    return true;
}

/**
 * 验证参与人，检查人，是否重复
 */
function checkTaskUser() {
    var managers = $("#managers").val();
    var inspectors = $("#inspectors").val();
    var participators = $("#participators").val();
    var managersTemp = managers.split(",");
    var inspectorsTemp = inspectors.split(",");
    var participatorsTemp = participators.split(",");
    for(var i = 0; i<managersTemp.length; i++) {
        for(var j = 0; j<inspectorsTemp.length; j++) {
            if(managersTemp[i] == inspectorsTemp[j]) {
                $.alert($.i18n("taskmanage.repeat.inspector_and_manager"));
                return false;
            }
        }
        for(var k = 0; k<participatorsTemp.length; k++) {
            if(managersTemp[i] == participatorsTemp[k]) {
                $.alert($.i18n("taskmanage.repeat.manager_and_participator"));
                return false;
            }
        }
    }
    for(var c = 0; c<inspectorsTemp.length; c++) {
        for(var n = 0; n<participatorsTemp.length; n++) {
            if(inspectorsTemp[c].length > 0 && participatorsTemp[n].length > 0) {
                if(inspectorsTemp[c] == participatorsTemp[n]) {
                    $.alert($.i18n("taskmanage.repeat.inspector_and_participator"));
                    return false;
                }
            }
        }
    }
    return true;
}

function setFixFlag(){
	if(getCtpTop().screen.height<=768){
		fixFlag=false;
	}else{
		fixFlag=true;
	}
}