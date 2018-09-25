/**
 * 获取列表显示类型
 */
function getListType() {
	var listTypeVal = "";
	var listTypeObj = $("#task_tab .current", window.parent.document);
	if (listTypeObj.length > 0) {
		listTypeVal = listTypeObj.attr("listType");
	}
	return listTypeVal;
}

/**
 * 获取项目编号
 */
function getProjectId() {
	return getUrlPara("projectId");
}

/**
 * 根据列表类型切换任务页面数据
 * @param listTypeValue 列表类型
 */
function changeTaskPageData(listTypeValue, isInit) {
	var objParam = setInitTaskParams();
	var isTaskStatistic=getUrlPara("isTaskStatistic");
	if (isTaskStatistic!="true"&&from!="section"&&typeof listTypeValue != "undefined" && listTypeValue.length > 0) {
		objParam.listType = listTypeValue;
		fillOtherPersonParam(objParam);
	}
	var dimensValue = $("#dimension_tab li.current").attr("dimension_value");
	if(dimensValue == "member") {
		objParam.isMemberSearch = 1;
		if (searchTaskObj != null) {
			searchTaskObj.g.showItem("statusselect");
		}
		objParam.seachCondition = "status:-2";
		$(".projectTask_leftNav").addClass("projectTask_peopleNav");
	} else {
		objParam.isMemberSearch = 0;
		if (searchTaskObj != null) {
			searchTaskObj.g.hideItem("statusselect", true);
		}
		$(".projectTask_leftNav").removeClass("projectTask_peopleNav");
		objParam.total = 4;
		objParam.size = 4;
	}
	if (isInit == true || isInit == "true") {
		fillStaticsParam(objParam);
	}
	var isRange = getIsRange(objParam.statuses);
	getTaskList(isRange, objParam);
	initTaskNavigationList(objParam);
	setTaskParamObj(objParam);
	//returnDefaultSeachCondition();
	initSeachCondition(isInit);
}

function initSeachCondition(isInit) {
	var isTaskStatistic = getUrlPara("isTaskStatistic");
	var isStatistic = false;
	if ((isTaskStatistic == true || isTaskStatistic == "true") && isInit == true) {
		if (typeof taskParamObj.seachCondition != "undefined") {
			var seachConditionStr = taskParamObj.seachCondition;
			if (seachConditionStr.length > 0) {
				if (seachConditionStr.indexOf("status") > -1) {
					var statusStr = seachConditionStr.substring(seachConditionStr.indexOf(":") + 1, seachConditionStr.length);
					searchTaskObj.g.setCondition('statusselect', statusStr);
					return;
				}
				if (seachConditionStr.indexOf("plannedEndTime") > -1) {
					var plannedEndTimeStr = seachConditionStr.substring(seachConditionStr.indexOf(":") + 1, seachConditionStr.indexOf(","));
					searchTaskObj.g.setCondition('endtime', plannedEndTimeStr,plannedEndTimeStr);
					return;
				}
			}
		}
	}
	returnDefaultSeachCondition();
}

/**
 * 返回默认查询条件
 */
function returnDefaultSeachCondition() {
	if (taskParamObj == null || searchTaskObj == null) {
		return;
	}
	if (taskParamObj.isMemberSearch == 1) {
		searchTaskObj.g.setCondition('statusselect','-2');
		taskParamObj.seachCondition = "status:-2";
	} else {
		if (typeof taskParamObj.seachCondition != "undefined") {
			taskParamObj.seachCondition = undefined;
		}
		searchTaskObj.g.clearCondition();
	}
}

/**
 * 切换导航列表事件
 * @param navObj 点击导航对象
 */
function changeNavigation(navObj) {
	var navtId = $(navObj).attr("navtId");
	var isRange = getIsRange(navtId);
	getTaskListByNavigationValue($(navObj).attr("statusValue"), $(navObj).attr("isOverdue"), isRange);
}

/**
 * 删除任务之前，判断选中的任务中是否包含有子任务
 * @param id 任务Id
 */
function checkIfChildExist(id) {
    var bool = false;
	var taskAjax = new taskAjaxManager();
    bool = taskAjax.checkIfChildExist(id);
    return bool;
}
/**
 * 删除任务信息操作
 */
function deleteTaskInfo(idValues) {
	var taskAjax = new taskAjaxManager();
    if (idValues == null || idValues.length == 0) {
        $.alert($.i18n('taskmanage.alert.delete.select'));
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
                        	try{
                        		projectTaskDetailDialog_close();
                        	}catch(e){}
                            refreshPageData();
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
 * 切换按维度按钮变换样式
 * @param dimensValue 维度值
 */
function chanageTaskDimensionClass(dimensValue) {
	$("#status_icon").removeClass("switchView_state_current_16");
	$("#status_icon").addClass("switchView_state_16");
	$("#member_icon").removeClass("switchView_people_current_16");
	$("#member_icon").addClass("switchView_people_16");
	$("#tree_icon").removeClass("switchView_taskTree_current_16");
	$("#tree_icon").addClass("switchView_taskTree_16");
	if(dimensValue == "status") {
		$("#status_icon").addClass("switchView_state_current_16");
		$("#status_icon").removeClass("switchView_state_16");
	} else if (dimensValue == "member") {
		$("#member_icon").addClass("switchView_people_current_16");
		$("#member_icon").removeClass("switchView_people_16");
	} else {
		$("#tree_icon").addClass("switchView_taskTree_current_16");
		$("#tree_icon").removeClass("switchView_taskTree_16");
	}
}

/**
 * 刷新页面数据
 */
function refreshPageData(opeara, listType) {
	var tab = getCurrentDimensionTab();
	if(tab == "tree"){
		reloadTaskTreeListPage();
	}else if (opeara == "new") {
		if (window.parent.chooseProjectTaskTab) {
			window.parent.chooseProjectTaskTab(listType);
		}
		changeTaskPageData(listType, false);
	} else {
		var objParam = getParamsObject();
		var isRange = getSelectedNavRange();
		getTaskList(isRange, objParam);
		initTaskNavigationList(objParam);
	}
}

/**
 * 刷新列表数据
 */
function refreshTaskList() {
	refreshPageData();
}

/**
 * 打开项目详细信息页面
 * @param projectId 项目ID
 */
function openProjectPage(projectId) {
	var projectPath = _ctxPath + '/project/project.do?method=projectSpace&projectId=' + projectId;
	getCtpTop().$("#main").attr("src", projectPath);
}

function bindFinishRateInputEvent() {
	$("span.rateNumber_input").delegate("input", "keyup", function(e) {
		if (e.keyCode=="13"){
			inputFinishRate(this);
        }
	}).delegate("input", "mouseleave", function(e) {
		inputFinishRate(this);
	});
}

/**
 * 输入完成率
 * @param input 输入的完成率内容
 */
function inputFinishRate(input) {
	var finishRate = $(input).val();
	var bool = validateFinishRateRange(finishRate);
	var rateInputObj = $(input).parents("#finish_rate_input");
	var errorObj = rateInputObj.find(".rateNumber_error");
	var listObj = $(input).parents(".list li");
	var statusValue = listObj.find("#status_text").attr("statusValue");
	var rateText = listObj.find(".rateNumber").text();
	rateText = rateText.substring(0,rateText.indexOf("%"));
	if (finishRate == rateText) {
		return;
	}
	if (bool == true) {
		rateInputObj.removeClass("rateNumber_input_error");
		var paramObj = new Object();
		paramObj.task_id = listObj.attr("task_id");
		paramObj.finishrate_text = finishRate;
		if (finishRate == 100 || statusValue == 4||statusValue==1||statusValue==2) {
			//未开始,进行中,已完成都要进行联动
			if(finishRate==0){
				paramObj.status=1;
			}else{
				paramObj.status = finishRate == 100 ? 4 : 2;
			}
			addFeedBack(paramObj, refreshPageData);
		} else {
			addFeedBack(paramObj, function (){
				listObj.find(".rateNumber").text(finishRate + "%");
				listObj.find(".rateProgress_box>div").attr("style", "width:" + finishRate +"%;");
			});
		}
	} else {
		rateInputObj.addClass("rateNumber_input_error");
		errorObj.fadeIn();
		errorObj.fadeOut(3000, function (){
			rateInputObj.removeClass("rateNumber_input_error");
		});
		$(input).val(rateText);
	}
}

/**
 * 添加任务汇报信息
 * @param paramObj 参数对象
 */
function addFeedBack(paramObj, callBack) {
	var taskListAjax = new taskListAjaxManager();
	taskListAjax.addTaskFeedBack(paramObj, {
        success : function(bool) {
            if (bool == true || bool == "true") {
				callBack();
            }
        },
        error : function(request, settings, e) {
            $.error($.i18n('taskmanage.error.delete.server'));
        }
	});
}

/**
 * 打开编辑任务页面
 * @param taskId 任务Id
 */
function editTask(taskId,projectId) {
	var url = _ctxPath + "/taskmanage/taskinfo.do?method=updateTask&id=" + taskId
                    + "&optype=update&from=Edit&projectId="+projectId+"&projectPhaseId="+getUrlPara("projectPhaseId");
    newTask(null,url,'modify',refreshPageData);
}

/**
 * 打开新建任务页面
 */
function addTask() {
	newTask(null,"","", function (listType){
		if(listType==null){
			listType="Personal";
		}
		refreshPageData("new", listType);
	});
}

/**
 * 新建操作方法
 */
function addOperea() {
	addTask();
}

/**
 * 验证完成率是否在0-100之间的正整数
 * @param finishRate 完成率
 */
function validateFinishRateRange(finishRate) {
	var bool = true;
	var reg = new RegExp("^(0|[0-9][0-9]?|100)$", "g");
    if (!reg.test(finishRate)) {
        bool = false;
    }
	return bool;
}

/**
 * 绑定项目名称点击事件
 */
function bindProjectNameEvent() {
	$("span.span_projectName").delegate("a", "click", function(e) {
		var taskId = $(this).parent().parent().attr("task_id");
		if ($(e.target).hasClass("a_noEdit")) {
			if (!$(this).parents(".list li").hasClass('li_noView')) {
				if (parent.openTaskDetailPage) {
					parent.openTaskDetailPage(taskId);
				} else {
					openTaskDetailPage(taskId);
				}
			}
			return;
		};
		var projectId = $(this).attr("projectId");
		openProjectPage(projectId);
	});
}

/**
 *如果是任务列表则走此逻辑，判断当前列表是否可以编辑，如果可以编辑则返回true
 */
function isTaskListEdit(thisObj){
	return thisObj.parents("li.list_item").size()>0 && !thisObj.parents("li.list_item").hasClass('li_noView');
}

/**
 * 如果是任务树则走此逻辑，判断当前列表是否可以编辑，如果可以编辑则返回true
 */
function isTaskListTreeEdit(thisObj){
	return thisObj.parents("div.list_item").size()>0 && !thisObj.parents("div.list_item").hasClass('li_noView');
}

/**
 * 绑定状态按钮事件
 */
function bindStatusBtnEvent() {
	$("span.state").delegate("a", "click", function(e) {
		var taskId = $(this).parent().parent().attr("task_id");
		if ($(e.target).hasClass("a_noEdit")) {
			if (isTaskListEdit($(this)) || isTaskListTreeEdit($(this))) {
				if (parent.openTaskDetailPage) {
					parent.openTaskDetailPage(taskId);
				} else {
					openTaskDetailPage(taskId);
				}
			}
			return;
		};
		addTaskFeedback(taskId, refreshPageData);
	});
}

/**
 * 绑定开始按钮事件
 */
function bindStartBtnEvent() {
	$("span.operateBtn").delegate("#start_btn", "click", function() {
		var paramObj = new Object();
		paramObj.task_id = $(this).parents(".list li").attr("task_id");
		paramObj.status = 2;
		addFeedBack(paramObj, refreshPageData);
	});
}

/**
 * 绑定完成按钮事件
 */
function bindFinishBtnEvent() {
	$("span.operateBtn").delegate("#finish_btn", "click", function() {
		var paramObj = new Object();
		paramObj.task_id = $(this).parents(".list li").attr("task_id");
		paramObj.status = 4;
		paramObj.finishrate_text = 100;
		addFeedBack(paramObj, refreshPageData);
	});
}

/**
 * 绑定编辑按钮事件
 */
function bindEidtBtnEvent() {
	$("span.operateBtn").delegate("#edit_btn", "click", function() {
		var taskId = $(this).parents(".list li").attr("task_id");
		var projectId = $($(this).parents(".list_item").children(".span_projectName")[0]).children("a").attr("projectId");
		editTask(taskId,projectId);
	});
}

/**
 * 绑定删除按钮事件
 */
function bindDeleteBtnEvent() {
	$("span.operateBtn").delegate("#delete_btn", "click", function() {
		var taskId = $(this).parents(".list li").attr("task_id");
		deleteTaskInfo(taskId);
	});
}

function addTaskListHtml() {
	if ($("#task_list_right").length == 0) {
		var htmlStr = new StringBuffer();
		htmlStr.append("<div class='stadic_right' id='task_list_right'>");
		htmlStr.append("<div class='stadic_content'>");
		htmlStr.append("</div>");
		htmlStr.append("</div>");
		htmlStr.append("<div class='stadic_left' id='task_list_left'>");
		htmlStr.append("<div class='projectTask_leftNav'>");
		htmlStr.append("<div class='list_box'>");
		htmlStr.append("<ul class='list clearfix' id='task_nav'>");
		htmlStr.append("</ul>");
		htmlStr.append("<input type='hidden' id='total' name='total' value='0'/>");
		htmlStr.append("<input type='hidden' id='page_size' name='page_size' value='0'/>");
		htmlStr.append("<input type='hidden' id='current_page' name='current_page' value='0'/>");
		htmlStr.append("</div>");
		htmlStr.append("<div class='pageBtn hidden'>");
		htmlStr.append("<span class='page_up'><em class='ico24 arrow_l_24'></em></span>");
		htmlStr.append("<span class='page_down'><em class='ico24 arrow_r_24'></em></span>");
		htmlStr.append("</div>");
		htmlStr.append("</div>");
		htmlStr.append("</div>");
		addTaskBody(htmlStr.toString());
		initTaskList();
	}
}

function changeTaskTreeListPage() {
	if ($("#task_tree_list").length == 0) {
		var htmlStr = new StringBuffer();
		htmlStr.append("<div class='projectTask_listArea' id='task_tree_list'>");
		var url = _ctxPath + "/taskmanage/taskinfo.do?method=taskTreeList";
		htmlStr.append("<iframe src=\""+url+"\" id=\"task_tree_frame\" name=\"task_tree_frame\" frameborder=\"0\" allowtransparency=\"true\" class=\"w100b h100b\" style=\"position:absolute;\"></iframe>");
		htmlStr.append("</div>");
		addTaskBody(htmlStr.toString());
	}
}

/*
 * 重新加载树页面
 */
function reloadTaskTreeListPage(){
	var url = $("#task_tree_list #task_tree_frame")[0].src;
	$("#task_tree_list #task_tree_frame").attr("src",url);
}

/**
 * 针对任务树使用：切换到任务树不显示导出和查询框
 */
function toggleFunctionButton(from){
	if(from == "tree"){
		$("#import_task",parent.document).hide();
		$("#import_task").hide();
		$("#searchTaskCondition_ul").hide();
	}else if(from == "member"){
		$("#import_task",parent.document).show();
		$("#import_task").show();
		$("#searchTaskCondition_ul").show();
	}else if(from == "status"){
		$("#import_task",parent.document).show();
		$("#import_task").show();
		$("#searchTaskCondition_ul").show();
	}
}

function addTaskBody(htmlStr) {
	if (typeof htmlStr == "string" && htmlStr.length > 0) {
		$("#data_body").empty();
		$("#data_body").html(htmlStr);
	}
}

/**
 * 隐藏按人员查看的页签
 */
function hiddenMemberTab() {
	$("#dimension_tab li").eq(1).hide();
}

/**
 * 隐藏操作按钮区域
 */
function hiddenOpereaArea() {
	$("#operea_area").hide();
}

/**
 * 导出操作事件
 */
function exportOperea() {
	exportToExcel();
}

/**
 * 导出excel
 */
function exportToExcel(){
	var taskParam = getParamsObject();
	var nullFlag=$(".have_a_rest_area").val();
	if(nullFlag==""){
		$.alert($.i18n("taskmanage.alert.no_records_excel"));
		return false;
	}
	var condition="";
	var queryParam1="";
	var queryParam2="";
	var status;
	if(taskParam.seachCondition!="undefined"&&taskParam.seachCondition!=null){
		var param=taskParam.seachCondition.split(":");
		if(param[1].indexOf(",")>-1){
			var queryParams=param[1].split(",");
			queryParam1=queryParams[0];
			queryParam2=queryParams[1];
		}else{
			queryParam1=param[1];
		}
		condition=param[0];
	}
	var userId=taskParam.userId;
	var projectPhaseId = getUrlPara("projectPhaseId") == null ? "1" : getUrlPara("projectPhaseId");
    var url = _ctxPath+ "/taskmanage/taskinfo.do?method=exportToExcel&from=" + taskParam.listType 
			+"&condition="+condition+ "&queryValue="+encodeURI(queryParam1) + "&queryValue1="+queryParam2+"&source=combinedQuery&userId="+ userId;
    if(getUrlPara("projectId")){
    	url+="&projectId=" + getUrlPara("projectId") +"&projectPhaseId="+projectPhaseId;
    }
    var statuses=parseInt(taskParam.statuses);
    if("ProjectAll"==taskParam.listType||"ProjectMember" ==taskParam.listType){
		var memberId=statuses;
		if(condition!=""){
			if("status"==condition) {
				statuses=parseInt(queryParam1);
        	}
		}
		if (taskParam.isMemberSearch == 1) {
			url += "&isMemberSearch=" + taskParam.isMemberSearch;
		}
    }
    switch(statuses){
        case -1:
        	break;
        case -2:
        	status="1,2";
        	url+="&statuses="+statuses+"&status="+status;
        	break;
        case 6:
        	status="1,2";
        	url+="&statuses="+statuses+"&isOverdue=1&status="+status;
        	break;
        case 1: case 2: case 4: case 5:
        	url+="&status="+statuses;
	    	break;
	    default:
	    	break;
    }
    if(memberId!=null&&memberId!="undefined"){
    	if(memberId<-2||memberId>6){
    		memberId=taskParam.statuses;
		url+="&memberId="+memberId;
    	}
    }
	$("#exportExcelIframe").attr("src", url);
}

/**
 * 隐藏不可以编辑的字段
 * @param rowObj 列表行对象
 */
function hiddenNoEidtField(rowObj) {
	if (rowObj.find(".a_noEdit").size() > 0 && !rowObj.hasClass("li_noControl")) {
		rowObj.find(".a_noEdit").each(function() {
			$(this).hide();
		});
	}
}

/**
 * 隐藏和显示超期样式
 * @param domObj 列表行对象
 */
function hideAndShowOverdueCss(domObj) {
	var isOverdue = domObj.attr("is_overdue");
	if (domObj.hasClass('li_noView')) {
		return;
	}
	if (isOverdue == true || isOverdue == "true") {
		if (domObj.hasClass("li_equipment")) {
			domObj.removeClass("li_equipment");
		} else {
			domObj.addClass("li_equipment");
		}
	}
}

/**
 * 是否保存不再提示的信息
 * @param userId 用户编号
 */
function isSavePrompt(userId) {
	var taskListAjax = new taskListAjaxManager();
	var saveBool = taskListAjax.saveTaskStatisticsPrompt($.ctx.CurrentUser.id);
	if (saveBool == 0) {
		$.error("保存信息失败！");
	}
}

function hidenPrompt() {
	$("div.taskTips").hide();
	$("div.stadic_layout").css("z-index","0");
}