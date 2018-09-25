/************************************************公共方法和初始化方法区域start**************************************************/
var pageType = getUrlPara("pageType");
/**
 * 初始化项目和任务的页签选中
 */
function initProjectTaskTab() {
	if (pageType == "task") {
		chooseProjectTaskTab("Personal");
	} else {
		chooseProjectTaskTab("1");
	}
}

/**
 * 初始化项目和任务的页签切换事件
 */
function init_projectTaskMainTabEvent() {
	$(".projectTask_list_head a").click(
		function() {
			$(".projectTask_list_head .current").removeClass("current");
			$(".projectTask_list_head .group_current").removeClass("group_current");
			$(this).addClass("current").parents(".group").addClass("group_current");
			var listTypeVal = $(".projectTask_list_head .current").attr("listType");
			var typePage = $(this).parents(".group_current").attr("typePage");
			changePageContent(listTypeVal, typePage);
		}
	);
	$(".projectTask_list_head span.title").click(
		function() {
			$(".projectTask_list_head .current").removeClass("current");
			$(".projectTask_list_head .group_current").removeClass("group_current");
			$(this).parents(".group").addClass("group_current");
			$(this).parents(".group").find("a").eq(0).addClass("current");
			var listTypeVal = $(".projectTask_list_head .current").attr("listType");
			var typePage = $(this).parents(".group_current").attr("typePage");
			changePageContent(listTypeVal, typePage);
		}
	);
}

function changePageContent(listTypeVal, typePage) {
	var currentDimension = "";
	if ($("#list_content_iframe")[0].contentWindow.changeTaskPageData && typePage == "task" && listTypeVal != "Manage") {
		currentDimension = $("#list_content_iframe")[0].contentWindow.getCurrentDimensionTab();
		if (currentDimension == "tree") {// 如果是按树维度则重新加载树页面
			$("#list_content_iframe")[0].contentWindow.reloadTaskTreeListPage();
		} else {
			$("#list_content_iframe")[0].contentWindow.changeTaskPageData(listTypeVal);
		}
	} else if ($("#list_content_iframe")[0].contentWindow.loadProjectCardHtml && typePage == "project") {
		$("#list_content_iframe")[0].contentWindow.loadProjectCardHtml(listTypeVal, true);
	} else {
		changeViewPageData(typePage, listTypeVal, "0");
	}
	if (listTypeVal == "Manage") {
		hiddenOpereaAreaBtn();
	} else {
		if (currentDimension != "tree") {
			hiddenAndShowOpereaBtn(typePage);
		}
	}
}

/**
 * 初始化任务列表页面时，判断任务列表页面的告知我和我分派的页签是否显示
 */
function initTaskTitleDisplay() {
	var objParams = setInitTaskParams();
	var taskListAjax = new taskListAjaxManager();
	objParams.listType = "TellMe";
	var tellMeCount = taskListAjax.getSeachTaskCount(objParams);
	if (tellMeCount > 0) {
		$("#tell_me").show();
	}
	objParams.listType = "Sent";
	var sentCount = taskListAjax.getSeachTaskCount(objParams);
	if (sentCount > 0) {
		$("#sent").show();
	}
	var userId = $.ctx.CurrentUser.id;
	var isOtherPeople = taskListAjax.validateOtherPeopleTask(userId);
	if (isOtherPeople == true) {
		$("#other_person").show();
	}
}

/**
 * 初始化项目和任务的页面UI渲染
 */
function initProjectAndTaskPageUI() {
	initProjectTaskTab();
	hiddenAndShowOpereaBtn(pageType);
}

/**
 * 初始化项目和任务的页面的数据
 */
function initProjectAndTaskPageData() {
	var listType = getUrlPara("listType");
	changeViewPageData(pageType, listType, "1");
	initTaskTitleDisplay();
	$("#page_type").val(pageType);
}

/**
 * 初始化项目和任务的页面的事件
 */
function initProjectAndTaskPageEvent() {
	init_projectTaskMainTabEvent();
	bindAddEvent();
	bindExportEvent();
	bindSetProjectEvent();
}

/**
 * 根据要显示数据的类型切换对应的显示页面
 */
function changeViewPageData(ptype, typeVal, isInit) {
	var urlPath = "";
	if (typeVal == "Manage") {
		urlPath = _ctxPath + "/taskmanage/taskinfo.do?method=otherPeopleTaskList";
	}else {
		if (ptype == "project") {
			urlPath = _ctxPath + "/project/project.do?method=projectIndex";
		} else {
			urlPath = _ctxPath + "/taskmanage/taskinfo.do?method=projectTaskList&pageType=task";
			if (isInit == "1") {
				var statusStr = getUrlPara("status");
				if (statusStr != null) {
					urlPath += "&status=" + statusStr;
				}
			}
		}
		if (typeVal && typeVal != null && typeVal.length > 0) {
				urlPath += "&listType=" + typeVal;
		}
	}
	setContentIframeSrc(urlPath);
}

/**
 * 改变iframe显示页面地址
 * @param url 页面路径地址
 */
function setContentIframeSrc(url) {
    $("#list_content_iframe").attr("src","");
    $("#list_content_iframe").attr("src", url);
}

/**
 * 隐藏显示操作按钮
 */
function hiddenAndShowOpereaBtn(ptype) {
	if (ptype == "task") {
		$("#set_project").hide();
		$("#import_task").show();
		if("true" == $("#canAddtask").val()){
			$("#add_operea").show();
		}else{
			$("#add_operea").hide();
		}
	} else {
		$("#set_project").show();
		$("#import_task").hide();
		if("true" == $("#canAddProject").val()){
			$("#add_operea").show();
		}else{
			$("#add_operea").hide();
		}
	}
}

/**
 * 隐藏操作按钮区域
 */
function hiddenOpereaAreaBtn() {
	$("#add_operea").hide();
	$("#set_project").hide();
	$("#import_task").hide();
}


/**
 * 根据要显示的列表类型，选中项目和任务的页签
 * @param listType 列表类型
 */
function chooseProjectTaskTab(listType) {
	$(".projectTask_list_head .current").removeClass("current");
	$(".projectTask_list_head .group_current").removeClass("group_current");
	$(".projectTask_list_head a").each(function (){
		if ($(this).attr("listType") == listType) {
			if ($(this).parent().hasClass("display_none")) {
				$(this).parent().show();
			}
			$(this).addClass("current").parents(".group").addClass("group_current");
		}
	});
}
/************************************************公共方法和初始化方法区域end**************************************************/

/************************************************任务的方法和事件区域start**************************************************/
/**
 * 绑定新建按钮事件
 */
function bindAddEvent() {
	$("#add_operea").unbind("click").click(function (){
		var pageType = $(".projectTask_list_head .group_current").attr("typePage");
		if (pageType == "task") {
			if ($("#list_content_iframe")[0].contentWindow.addOperea) {
				$("#list_content_iframe")[0].contentWindow.addOperea();
			}
		} else {
			createProject();
		}
	});
}

/**
 * 绑定导出按钮事件
 */
function bindExportEvent() {
	$("#import_task").unbind("click").click(function (){
		if ($("#list_content_iframe")[0].contentWindow.exportOperea) {
			$("#list_content_iframe")[0].contentWindow.exportOperea();
		}
	});
}
/************************************************任务的方法和事件区域end**************************************************/

/************************************************项目的方法和事件区域start**************************************************/

/**
 * 项目配置事件
 */
function projectConfig(){
	window.location.href = _ctxPath + "/project/project.do?method=getAllProjectList"; 
}

/**
 * 绑定项目配置事件
 */
function bindSetProjectEvent() {
	$("#set_project").unbind("click").click(function (){
		projectConfig();
	});
}

/**
 * 新建项目
 */
function createProject() {
	var dialog = $.dialog({
            id : 'newProjectWin',
            url : _ctxPath + '/project/project.do?method=createProject',
            bottomHTML : "<div class='common_checkbox_box margin_l_10 clearfix'><label class='hand' for='continueAdd'><input id='continueAdd' class='radio_com' name='continuous' value='0' type='checkbox'>"
    			+ $.i18n('taskmanage.add.continue') +"</label></div>",
            width : 556,
            height : 450,
            title : $.i18n('project.newproject') ,
            targetWindow : getCtpTop(),
            transParams:{	newProject:newOpenProject,
            				callBack:refshProejctData,
            				action:'add'}, 
            closeParam:{
            	'show':true,
            	handler:function(){
            		refshProejctData(dialog);
            	}
            },
            buttons : [ {
            	id : 'ok',
                text : $.i18n('common.button.ok.label'),
	        	isEmphasize:true,
                handler : function() {
                    dialog.getReturnValue({'dialogObj' :dialog});
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    dialog.close();
                    refshProejctData(dialog);
                }
            } ]
        });
}
 /**
  * 项目类型不存在时回调
  */
function newOpenProject(dialog){
  	dialog.close();
  	createProject();
}
function refshProejctData(dialog){
	if ($("#list_content_iframe")[0].contentWindow.doReflashGrid) {
		$("#list_content_iframe")[0].contentWindow.doReflashGrid(dialog, true);
	}
	if ($("#list_content_iframe")[0].contentWindow.reloadPage) {
		$("#list_content_iframe")[0].contentWindow.reloadPage();
		dialog.close();
	}
}
/************************************************项目的方法和事件区域end**************************************************/
