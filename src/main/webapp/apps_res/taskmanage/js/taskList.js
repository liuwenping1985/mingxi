var scrollTaskStatusListObj = null;
var scrollTaskListObj = null;
var searchTaskObj = null;
var taskParamObj = null;

/**
 * 设置公用查询参数
 * @param 参数条件
 */
function setTaskParamObj(paramObj) {
	if (paramObj != null) {
		taskParamObj = $.extend(taskParamObj, paramObj);
	}
}

// 项目&任务－左侧分类菜单
function init_projectTask_leftNav() {
	$(".projectTask_leftNav .list li").click(function() {
		$(".projectTask_leftNav .list li").removeClass("current");
		$(this).addClass("current");
		changeNavigation(this);
	}).mouseenter(function() {
		if ($(this).index() == 0 && $(this).hasClass("item_all")) {
			return;
		};
		$(this).addClass("hover");
	}).mouseleave(function() {
		$(this).removeClass("hover");
	});
}

/**
 * 初始化页面数据
 */
function initProjectAndTaskPage() {
	initProjectAndTaskUI();
	initTaskList();
	initTaskDataList();
	validateNewTaskPurview();
	$(window).resize(init_projectTask_list);
	initTaskStatisticPrompt();
	initTaskDimensionEvent();
	init_projectTask_list_binding();
	initNewTaskEvent();
	initExportExcelEvent();
}

/**
 * 初始化统计页面穿透过来的提示信息
 */
function initTaskStatisticPrompt() {
	var isTaskStatistic = getUrlPara("isTaskStatistic");
	var taskTotle = getUrlPara("taskTotle");
	if ((isTaskStatistic == true || isTaskStatistic == "true")) {
		var projectId = getUrlPara("projectId");
		var userId = $.ctx.CurrentUser.id;
		var taskListAjax = new taskListAjaxManager();
		var isManage = taskListAjax.isRolePurview(userId,projectId);
		var isDisplay = taskListAjax.isDisplayPrompt($.ctx.CurrentUser.id);
		if (isDisplay == 1 && taskTotle!="0" && (isManage==false||isManage=="false")) {
			$("div.taskTips").show();
			$("div.stadic_layout").css("z-index","1000");
		}
	}
	$("#close_prompt").unbind().click(function (){
		hidenPrompt();
	});
	$("#no_prompt").unbind().click(function (){
		isSavePrompt($.ctx.CurrentUser.id);
		hidenPrompt();
	});
}
/**
 * 初始化页面渲染效果
 */
function initProjectAndTaskUI() {
	initTaskListSearchDiv();
	if (getProjectId() == null) {
		hiddenMemberTab();
		hiddenOpereaArea();
	}
	if (window.parent.hiddenAndShowOpereaBtn) {
		window.parent.hiddenAndShowOpereaBtn("task");
	}
}

function validateNewTaskPurview() {
	var projectId = getUrlPara("projectId");
	if (projectId != null) {
		var taskListAjax = new taskListAjaxManager();
		var bool = taskListAjax.validateProjectPurview(projectId, $.ctx.CurrentUser.id);
		if (bool == false) {
			$("#add_task").hide();
		} else {
			$("#add_task").show();
		}
	}
}

function initTaskDataList() {
	//taskParamObj = setInitTaskParams();
	//fillStaticsParam(taskParamObj);
	//var isRange = getIsRange(taskParamObj.statuses);
	//getTaskList(isRange, taskParamObj);
	//initTaskNavigationList(taskParamObj);
	if (getUrlPara("memberId") != null && getUrlPara("projectId") != null) {
		$("#dimension_tab li.current").removeClass("current");
		$("#dimension_tab li").eq(1).addClass("current");
		chanageTaskDimensionClass("member");
	}
	changeTaskPageData("", true);
}

/**
 * 项目&任务－列表交互初始
 */
function init_projectTask_list() {
	computeProjectTaskList();
	hideAndShowProjectName();
}

/**
 * 计算任务列表的宽度
 * 固定计算任务名称宽度
 */
function computeProjectTaskList() {
	var _width;
	var _window_width = $(this).width();
	var _other_width = 866 + 20;
	if (getProjectId() != null) {
		//如果来自项目空间更多则不显示项目名称，所以要去掉项目信息的宽度
		_other_width -= 143;
	}
	_width = _window_width - _other_width;
	if (_width < 0) {
		_width = 0;
	};
	$(".projectTask_listArea .list li .projectName").width(_width);
}

/**
 * 隐藏和显示项目名称
 */
function hideAndShowProjectName() {
	if (getProjectId() != null) {
		$(".projectTask_listArea .list li .projectType").hide();
	} else {
		$(".projectTask_listArea .list li .projectType").show();
	}
}

/**
 * 绑定任务列表事件
 */
function init_projectTask_list_binding() {
	$(".projectTask_listArea .list li").live("mouseenter", function() {
		//if ($(this).hasClass('li_noView')) {
		//	return;
        //};
		hideAndShowOverdueCss($(this));
		$(this).addClass("li_hover");
		hiddenNoEidtField($(this));
	}).live("mouseleave", function() {
		$(".projectTask_listArea .list li").removeClass("li_hover");
		$(this).find(".a_noEdit").show();
		hideAndShowOverdueCss($(this));
	}).live("click", function(e) {
		if ($(this).hasClass('li_noView')) {
			return;
        };
		if ($(e.target).hasClass("noClick")) {
			return;
		};
		var taskId = $(this).attr("task_id");
		var isView = validateTaskView(taskId);
		if (isView != true) {
			$.alert($.i18n("taskmanage.alert.no_auth_view_task"));
			return;
		}
		openTaskDetailPage(taskId);
	});
}

/**
 * 绑定任务树列表事件
 */
function init_projectTask_tree_list_binding() {
	$(".projectTask_listArea .list .list_item").live("mouseenter", function() {
		if ($(this).hasClass('li_noView')) {
			return;
        };
		hideAndShowOverdueCss($(this));
		$(this).addClass("li_hover");
		hiddenNoEidtField($(this));
	}).live("mouseleave", function() {
		$(".projectTask_listArea .list_item").removeClass("li_hover");
		$(this).find(".a_noEdit").show();
		if ($(this).hasClass('li_noView')) {
			return;
        };
		hideAndShowOverdueCss($(this));
	}).live("click", function(e) {
		if ($(this).hasClass('li_noView')) {
			return;
        };
		if ($(e.target).hasClass("noClick")) {
			return;
		};
		var taskId = $(this).attr("task_id");
		var isView = parent.validateTaskView(taskId);
		if (isView != true) {
			$.alert($.i18n("taskmanage.alert.no_auth_view_task"));
			return;
		}
		parent.openTaskDetailPage(taskId);
	});
}

/**
 * 验证任务的查看权限
 * @param taskId 任务Id
 */
function validateTaskView(taskId) {
	var bool = true;
	var taskListAjax = new taskListAjaxManager();
	bool = taskListAjax.validateTaskView(taskId);
	return bool;
}

/**
 * 初始化任务列表对象
 */
function initTaskList() {
	scrollTaskStatusListObj = $(".stadic_content").scrollPage({
		childSize: 5,
		pageSize: 4,
		total: 4,
		managerName: "taskListAjaxManager",
		managerMethod: "getTaskListData",
		callbackFun: function(){
			init_projectTask_list();
			initOperateBtnArea();
		}
	});
}

/**
 * 初始化任务更多查看列表对象
 */
function initTaskMoreList() {
		scrollTaskListObj = $(".projectTask_listArea .list").scrollPage({
			managerName: "taskListAjaxManager",
			managerMethod: "getTaskListMoreHtml",
			scrollContent: ".stadic_content",
			isImportAjax: false,
			isImportDataJs: false,
			callbackFun: function(){
				init_projectTask_list();
				initOperateBtnArea();
			}
		});
}

/**
 * 初始化任务列表对象
 */
function getTaskListData(objParam) {
	if (objParam != null && objParam.isMoreList) {
		objParam.isMoreList = 0;
		setTaskParamObj(objParam);
	}
	if(objParam.isMemberSearch == 1) {
		var taskListAjax = new taskListAjaxManager();
		objParam.total = taskListAjax.getProjectMemberCount(objParam);
		objParam.size = 8;
		objParam.page = 1;
	} else {
		if (objParam.statuses == -1) {
			objParam.total = 4;
			objParam.size = 4;
		} else {
			objParam.total = getCurrentCount(objParam);
			objParam.size = 20;
		}
	}
	if ($(".stadic_content").ajaxSrollLoad) {
		$(".stadic_content").ajaxSrollLoad(objParam);
	}
}

/**
 * 初始化任务导航列表
 */
function initTaskNavigationList(objParam) {
	var objNavParam = new Object();
	$.extend(objNavParam, objParam);
	if(objNavParam.isMemberSearch == 1) {
		var taskListAjax = new taskListAjaxManager();
		objNavParam.total = taskListAjax.getProjectMemberCount(objNavParam);
		objNavParam.size = getProjectMemberShowCount();
		$("#total").val(objNavParam.total);
		$("#page_size").val(objNavParam.size);
		$("#current_page").val("1");
	}
	getTaskNavigationList(objNavParam);
	if (typeof initNavPageBtnEvent != "undefined") {
		initNavPageBtnEvent();
	}
}

/**
 * 获取任务导航列表数据
 */
function getTaskNavigationList(objParams) {
	var taskListAjax = new taskListAjaxManager();
	taskListAjax.getNavigationListHtml(objParams, {
		success : function(htmlText) {
			$("#task_nav").html(htmlText);
			init_projectTask_leftNav();
			if (typeof initProjectMemberTopEvent != "undefined") {
				initProjectMemberTopEvent();
			}
			setNavSeachCondCount(objParams);
			selectedNavList(objParams.statuses);
        },
        error : function(request, settings, e) {
			$.error($.i18n('taskmanage.error.delete.server'));
        }
	});
}

/**
 * 获取选中导航列表数据，是否在查询范围之内
 */
function getSelectedNavRange() {
	var isRange = false;
	var paramObj = getParamsObject();
	var navtId = paramObj.statuses;
	isRange = getIsRange(navtId);
	return isRange;
}
/**
 * 初始化搜索框
 */
function initTaskListSearchDiv() {
	var rightNum = 32;
	if (getProjectId() != null) {
		rightNum = 112;
	}
    searchTaskObj = $.searchCondition({
		id: "searchTaskCondition",
        top: 10,
        right: rightNum,
        searchHandler: function(){
            var returnValue = searchTaskObj.g.getReturnValue();
			if (returnValue != null) {
				var seachCondParam = setQueryParams(returnValue);
				setTaskParamObj(seachCondParam);
				var objParams = getParamsObject();
				setNavSeachCondCount(objParams);
				var isRange = getSelectedNavRange();
				getTaskList(isRange, objParams);
			}
        },
        conditions: [{
			id: 'title',
			name: 'title',
			type: 'input',
			text: $.i18n('common.subject.label'),
			value: 'subject'
        }, {
			id: 'starttime',
			name: 'starttime',
			type: 'datemulti',
			text: $.i18n('taskmanage.starttime'),
			value: 'plannedStartTime',
			ifFormat:"%Y-%m-%d",
            dateTime: false
        }, {
			id: 'endtime',
			name: 'endtime',
			type: 'datemulti',
			text: $.i18n('common.date.endtime.label'),
			value: 'plannedEndTime',
			ifFormat:"%Y-%m-%d",
			dateTime: false
        }, {
			id: 'importent',
			name: 'importent',
			type: 'select',
			text: $.i18n('common.importance.label'),
			value: 'importantLevel',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
        }, {
            id: 'statusselect',
            name: 'statusselect',
            type: 'select',
            text: $.i18n('taskmanage.status'),
            value: 'status',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusCondEnums'"
        }, {
            id: 'risk',
            name: 'risk',
			type: 'select',
			text: $.i18n('taskmanage.risk'),
			value: 'riskLevel',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
        }, {
			id: 'createUserText',
			name: 'createUserText',
			type: 'input',
			text: $.i18n('common.creater.label'),
			value: 'createUser'
        }, {
			id: 'managersText',
			name: 'managersText',
			type: 'input',
            text: $.i18n('taskmanage.manager'),
            value: 'managers'
        }, {
			id: 'participatorsText',
			name: 'participatorsText',
			type: 'input',
			text: $.i18n('taskmanage.participator'),
			value: 'participators'
        }, {
			id: 'inspectorsText',
			name: 'inspectorsText',
			type: 'input',
			text: $.i18n('taskmanage.inspector'),
			value: 'inspectors'
        }]
    });
	searchTaskObj.g.hideItem("statusselect", true);
}

/**
 * 设置查询条件
 */
function setQueryParams(returnValue) {
    var condition = returnValue.condition;
    var value = returnValue.value;
    var paramObj = new Object();
	if (typeof condition != "undefined" && condition.length > 0) {
		var seachCondition = new StringBuffer();
		seachCondition.append(condition);
		seachCondition.append(":");
		if (condition == "plannedStartTime" || condition == "plannedEndTime") {
			if (value.length > 0) {
				seachCondition.append(value[0]);
				seachCondition.append(",");
				seachCondition.append(value[1]);
			}
		} else {
			seachCondition.append(value);
		}
		paramObj.seachCondition = seachCondition.toString();
	} else {
		paramObj.seachCondition = "";
	}
    return paramObj;
}

/**
 * 获取是否在条件的查看范围
 * @param navtId Id编号
 */
function getIsRange(navtId) {
	var taskListAjax = new taskListAjaxManager();
	var isRange = taskListAjax.isStatusCondEnumsRange(navtId);
	return isRange;
}

/**
 * 获取条件参数
 * @param isRange 是否是查询更多
 */
function getParamsObject() {
	var objParam = null;
	if (taskParamObj != null) {
		objParam = taskParamObj;
	}
	if (objParam.listType == undefined || objParam.userId == undefined) {
		objParam = setInitTaskParams();
	}
	return objParam;
}

/**
 * 根据导航列表参数获取对应的列表数据
 * @param navVal 导航列表参数
 * @param isOverdue 是否超期
 * @param isRange 是否是查询更多
 */
function getTaskListByNavigationValue(navVal, isOverdue, isRange) {
	var objParam = new Object();
	objParam = $.extend(objParam, getParamsObject());
	objParam.statuses = navVal;
	objParam.isOverdue = isOverdue;
	setTaskParamObj(objParam);
	$(".stadic_content").html("");
	getTaskList(isRange,objParam);
}

/**
 * 获取任务列表数据
 * @param params 查询参数
 * @param isRan 是否是查询更多
 */
function getTaskList(isRan, params) {
	if (params != null) {
		if (isRan == true) {
			getTaskListData(params);
		} else {
			getTaskListMore(params);
		}
	}
}

/**
 * 获取当前选中事项的总数
 */
function getCurrentCount(objParams) {
	var count = 0;
	var numberObj = $(".projectTask_leftNav .list li.current").find(".number");
	var numberStr = "0";
	if (typeof numberObj != "undefined" && numberObj.size() > 0) {
		numberStr = numberObj.html();
	} else {
		var taskListAjax = new taskListAjaxManager();
		numberStr = String(taskListAjax.getSeachTaskCount(objParams));
	}
	if (numberStr.indexOf("/") > -1) {
		count = numberStr.substring(0, numberStr.indexOf("/"));
	} else {
		count = numberStr;
	}
	return count;
}

/**
 * 获取任务更多列表
 * @param params 参数条件
 */
function getTaskListMore(params) {
	var taskListAjax = new taskListAjaxManager();
	if (params != null) {
		params.isMoreList = 1;
		selectedNavList(params.statuses);
		setTaskParamObj(params);
		params.total = getCurrentCount(params);
		params.size = 20;
	}
	taskListAjax.getTaskListTitleHtml(params, {
		success : function(htmlText) {
			if (htmlText.length > 0) {
				$(".stadic_content").html(htmlText);
			} else {
				$(".stadic_content").html("<div class=\"have_a_rest_area\">"+$.i18n("taskmanage.condition.no.content")+"</div>");
			}
			initTaskMoreList();
			if ($(".projectTask_listArea .list").size() > 0 && $(".projectTask_listArea .list").ajaxSrollLoad) {
				$(".projectTask_listArea .list").ajaxSrollLoad(params);
			}
        },
        error : function(request, settings, e) {
			$.error($.i18n('taskmanage.error.delete.server'));
        }
	});
}

/**
 * 根据ID定位导航列表中被选中的行
 * @param navId ID编号
 */
function selectedNavList(navId) {
	$(".projectTask_leftNav .list li").removeClass("current");
	$("#task_nav li").each(function(){
		if ($(this).attr("navtid") == navId) {
			$(this).addClass("current");
		}
	});
}

/**
 * 设置导航列表查询条数
 * @param paramsObj 参数对象
 */
function setNavSeachCondCount(paramsObj) {
	var taskListAjax = new taskListAjaxManager();
	var objCondParam = new Object();
	$.extend(objCondParam, paramsObj);
	if (typeof objCondParam.seachCondition == "undefined"){
		return;
	}
	var statusStr = $(this).attr("statusvalue");
	if (objCondParam.isMemberSearch == 1) {
		objCondParam.memberId = statusStr;
	} else {
		objCondParam.status = statusStr;
	}
	objCondParam.isOverdue = $(this).attr("isOverdue");
	var length=$("#task_nav li").length;
	var currentType=$("#dimension_tab .current").attr("dimension_value");
	if(currentType=="member"){
		//按人员查看
		fillTaskMemberCount(taskListAjax,objCondParam)
	}else if(currentType=="status"){
		//按状态查看
		fillTaskStatusCount(taskListAjax,objCondParam);
	}
}
var defaultParam;
var firstVisit=true;
/**
*按人员查看
*/
function fillTaskMemberCount(taskListAjax,objCondParam){
	var task_nav_li=$("#task_nav li[navtid!='-1']");
	var member_id="";
	$.each(task_nav_li,function(i,item){
		member_id+=$(item).attr("navtid")+",";
	})
	member_id=member_id.substring(0,member_id.length-1);
	objCondParam.memberId=member_id;
	if(firstVisit){//第一次访问带进默认条件
		defaultParam=objCondParam;
		firstVisit = false;
	}else{//随后访问都不带默认条件，但memberId必须同步
		defaultParam.memberId = member_id;
	}
	var seachCountMap=taskListAjax.getSeachTaskCountMember(objCondParam,defaultParam);
	var allTotle=$("#task_nav li[navtid='-1']").find(".number");
	if(allTotle.length>0){
		fillTaskCount(seachCountMap,allTotle,"allTotleContain");
	}
	$.each(task_nav_li,function(i,item){
		var leftTotle=seachCountMap.leftMap[$(item).attr("navtid").trim()];
		var rightTotle=seachCountMap.rightMap[$(item).attr("navtid").trim()];
		if(leftTotle!=undefined||rightTotle!=undefined){
			$(item).find(".number").html((leftTotle!=undefined?leftTotle:0)+"/"+rightTotle);
		}else{
			$(item).find(".number").html("0/0");
		}
	})
}
/**
*按状态查询任务数
*/
function fillTaskStatusCount(taskListAjax,objCondParam){
		//按状态查看
		var seachCountMap = taskListAjax.getSeachTaskCountMap(objCondParam);
		var total=0;
		//全部
		var allTotle=$("#task_nav li[navtid='-1']").find(".number");
		if(allTotle.length>0){
			fillTaskCount(seachCountMap,allTotle,"all");
		}
		//未完成
		var unfinishedTotle=$("#task_nav li[navtid='-2']").find(".number");
		if(unfinishedTotle.length>0){
			fillTaskCount(seachCountMap,unfinishedTotle,"unfinished");
		}
		//进行中
		var marching=$("#task_nav li[navtid='2']").find(".number");
		if(marching.length>0){
			fillTaskCount(seachCountMap,marching,"marching");
		}
		//未开始
		var notstarted=$("#task_nav li[navtid='1']").find(".number");
		if(notstarted.length>0){
			fillTaskCount(seachCountMap,notstarted,"notstarted");
		}
		//已超期
		var overdue=$("#task_nav li[navtid='6']").find(".number");
		if(overdue.length>0){
			fillTaskCount(seachCountMap,overdue,"overdue");
		}
		//已完成
		var finished=$("#task_nav li[navtid='4']").find(".number");
		if(finished.length>0){
			fillTaskCount(seachCountMap,finished,"finished");
		}
		//已取消
		var canceled=$("#task_nav li[navtid='5']").find(".number");
		if(canceled.length>0){
			fillTaskCount(seachCountMap,canceled,"canceled");
		}
}
/**
*回填统计的任务数
*/
function fillTaskCount(seachCountMap,eleTotle,key){
	var navCountStr=eleTotle.html();
	var total=navCountStr;
	if (navCountStr.indexOf("/") > -1) {
		total = navCountStr.substring(navCountStr.indexOf("/") + 1, navCountStr.length);
	}
	eleTotle.html(seachCountMap[key]+"/"+total);
}
/**
 * 根据查看的内容维度隐藏和显示分页控件
 * @param dsnv 维度参数
 */
function hiddenAndShowPageBtn(dsnv) {
	if(dsnv == "status") {
		$(".pageBtn").hide();
	} else if(dsnv == "member") {
		$(".pageBtn").show();
	}
}

//增加记录当前点击的是哪个维度：状态？人员？树
var _currentDimensionTab = "status";
function getCurrentDimensionTab(){
	return _currentDimensionTab;
}
var dimensionType="";
/**
 * 初始化任务按维度切换按钮事件
 */
function initTaskDimensionEvent() {
	$("#dimension_tab li").each(function(){
		$(this).unbind("click").click(function() {
			var dimensValue = $(this).attr("dimension_value");
			dimensionType=dimensValue;
			$("#dimension_tab li.current").removeClass("current");
			$(this).addClass("current");
			chanageTaskDimensionClass(dimensValue);
			addTaskListHtml();
			if(dimensValue == "status") {
				var listTypeVal = getListType();
				changeTaskPageData(listTypeVal, false);
				//显示导出和查询框
				toggleFunctionButton("status");
			} else if(dimensValue == "member") {
				changeTaskPageData("", false);
				//显示导出和查询框
				toggleFunctionButton("member");
			} else {
				//切换树形结构
				changeTaskTreeListPage();
				//隐藏导出和查询框
				toggleFunctionButton("tree");
			}
			_currentDimensionTab = dimensValue;
			hiddenAndShowPageBtn(dimensValue);
		});
	});
}

/**
 * 初始化任务列表按钮的操作事件
 */
function initOperateBtnArea() {
	bindProjectNameEvent();
	bindFinishRateInputEvent();
	bindStatusBtnEvent();
	bindStartBtnEvent();
	bindFinishBtnEvent();
	bindEidtBtnEvent();
	bindDeleteBtnEvent();
}

/**
 * 初始化任务新建按钮事件
 */
function initNewTaskEvent() {
	$("#add_task").unbind("click").click(function() {
		addTask();
	});
}

/**
 * 初始化任务导出excel按钮事件
 */
function initExportExcelEvent() {
	$("#import_task").unbind("click").click(function() {
		exportToExcel();
	});
}