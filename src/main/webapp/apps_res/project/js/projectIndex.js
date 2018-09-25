var correlationProjects = null;
var projectAjax = new projectAjaxManager();
var projectTypeIds = null;
var objParam = new Object();
var pageSize = 4;
var viewType = 1;
var searchobj = null;
var listType = 1;

/**
 * 初始化页面方法
 */
function init() {
	correlationProjects = new CorrelationProjects();
	var correlationProjectsRun = new CorrelationProjectsRun(correlationProjects);
	correlationProjectsRun.run();
	var list_type = getListType();
	loadProjectCardHtml(list_type, true);
	initUIEvent();
	initSearchDiv();
	initHoverCss();
}

/**
 * 获取listType的值
 */
function getListType() {
	var list_type = getUrlPara("listType");
	if (list_type == null) {
		list_type = 1;
	}
	return list_type;
}

/**
 * 将页面的$("#view_state").val()转换为后台识别的项目状态参数
 */
function getProjectStateParam(projectState){
	if (projectState == 1) {
		return "0,1";
	} else {
		return "2,3";
	}
}

/**
 * 加载项目看版数据
 */
function loadProjectCardHtml(projectState, isInit) {
	if (isInit == true || isInit == "true") {
		objParam = setInitParam();
	}
	objParam.projectState = getProjectStateParam(projectState);
	if (objParam.projectType != "-20000") {
		projectTypeIds = initProjectTypeIds(objParam.projectState);
	}
	$("#view_state").val(projectState);
	objParam.viewType = viewType;
	initLoadParam();
	var htmlContentStr = null;
	if (viewType == 1) {
		htmlContentStr = new StringBuffer();
		htmlContentStr.append("<div class=\"projects_box\" id=\"projects_box\">");
		htmlContentStr.append(getProjectCardHtml(objParam));
		htmlContentStr.append("</div>");
	} else {
		htmlContentStr = new StringBuffer();
		htmlContentStr.append(getProjectCardHtml(objParam));
	}
	htmlContentStr.append("<div id=\"loading_text\" class=\"padding_10 font_size16 align_center color_gray hidden\">正在加载...</div>");
	$("#projects_card").html("");
	$("#projects_card").html(htmlContentStr.toString());
	$("#project_type_id").val("-1");
	initProjectMarkUI();
	bindProjectMarkEvent();
	initProjectListEvent();
	if (isInit == true || isInit == "true") {
		clearSearchCondition();
	}
}

/**
 * 初始化条件参数
 */
function setInitParam() {
	var paramsObj = new Object();
	paramsObj.memberId = $.ctx.CurrentUser.id;
	if (correlationProjects != null) {
		if (viewType == 1) {
			paramsObj.rowCount = correlationProjects.getRowCanShowNum();
		} else {
			paramsObj.rowCount = 5;
		}
	}
	paramsObj.currentPage = 1;
	return paramsObj;
}

/**
 * 初始化滚动加载数据的起始参数
 */
function initLoadParam() {
	if (viewType == 1) {
		pageSize = 4;
	} else {
		pageSize = 6;
	}
	$("#start_index").val("0");
	var total = $("#total").val();
	if (pageSize > total) {
		$("#end_index").val(total);
	} else {
		$("#end_index").val(pageSize);
	}
}
/**
 * 获取项目看版的html
 * @param paramsObj 参数条件
 */
function getProjectCardHtml(paramsObj) {
	var htmlContent = new StringBuffer();
	if (paramsObj && paramsObj != null) {
		var projectTypeIdStr = "";
		//OA-79350  添加一个!paramsObj.projectType，如果已经传过来了说明就不必在赋值了
		if (projectTypeIds != null && paramsObj.projectType != "-20000") {
			var start = parseInt($("#start_index").val());
			var end = parseInt($("#end_index").val());
			for (var i = start; i<end; i++) {
				projectTypeIdStr += projectTypeIds[i] + ",";
			}
			paramsObj.projectType = projectTypeIdStr.substring(0,projectTypeIdStr.length - 1);
		}
		var projectHtml = projectAjax.getProjectCardHtmlData(paramsObj);
		if (projectHtml.length > 0) {
			htmlContent.append(projectHtml);
		} else {
			//没有符合条件的内容
			htmlContent.append("<div class=\"have_a_rest_area\">"+$.i18n('taskmanage.condition.no.content')+"</div>");
		}
	}
	return htmlContent.toString();
}

/**
 * 初始化获取本单位下的所有项目类型
 */
function initProjectTypeIds(projectState) {
	var projectTypeId = new Array();
	var projectTypeList = projectAjax.getProjectTypeIdsByAccoutId($.ctx.CurrentUser.loginAccount, $.ctx.CurrentUser.id, projectState, viewType);
	$("#total").val(projectTypeList.length);
	for (var i = 0; i < projectTypeList.length; i++){
		projectTypeId.push(projectTypeList[i].id);
	}
	return projectTypeId;
}

/**
 * 初始化页面事件方法
 */
function initUIEvent() {
	$("#project_tabs li").unbind("click").bind("click", function() {
		var view_type = $(this).attr("dimension_value");
		$("#project_tabs li").removeClass("current");
		$(this).addClass("current");
		if (view_type == "card") {
			$("#list_icon").removeClass("ico16 switchView_list_current_16");
			$("#card_icon").removeClass("ico16 switchView_card_16");
			$("#list_icon").attr("class", "ico16  switchView_list_16");
			$("#card_icon").attr("class", "ico16  switchView_card_current_16");
			changeViweType(1);
		} else {
			$("#list_icon").removeClass("ico16 switchView_list_16");
			$("#card_icon").removeClass("ico16 switchView_card_current_16");
			$("#list_icon").attr("class","ico16 switchView_list_current_16");
			$("#card_icon").attr("class","ico16 switchView_card_16");
			changeViweType(0);
		}
	});
}

/**
 * 给项目看版模块绑定对应的事件
 */
function bindProjectMarkEvent () {
	$("li.list_item").each(function() {
		bindProjectMarkEventByObj($(this));
	});
	//$("li.list_item").unbind("click").click(function(){});
}

/**
 * 给项目看版的item绑定对应的事件
 * @param obj jquery对象
 */
function bindProjectMarkEventByObj (obj) {
		var projectId = obj.attr("projectId");
		obj.hover(
			function () {
				if (obj.find(".project_star_24").attr("isDisplay") == "0") {
					obj.children(".list_item_head").children(".project_no_star_24").show();
				}
				obj.children(".list_item_head").children(".project_editor_24").show();
			},
			function () {
				obj.children(".list_item_head").children(".project_no_star_24").hide();
				obj.children(".list_item_head").children(".project_editor_24").hide();
			}
		);
		//已开始的项目编辑
		obj.children(".list_item_head").children(".editEnable").unbind("click").click(function(event){
			editorProject(projectId);
			event.stopPropagation();
		});
		//已结束的项目查看
		obj.children(".list_item_head").children(".viewOnly").unbind("click").click(function(event){
			viewCloseProject({"id":projectId,"projectIState":2,"canEditorDel":true});
			event.stopPropagation();
		});
		obj.children(".list_item_head").children(".project_no_star_24").unbind("click").click(function(event){
			markProject(event, projectId);
			event.stopPropagation();
		});
		obj.children(".list_item_head").children(".project_star_24").unbind("click").click(function(event){
			removeMarkProject(projectId);
			event.stopPropagation();
		});
		obj.unbind("click").click(function(){
			viewProjectInfo(projectId);
		});
	//$("li.list_item").unbind("click").click(function(){});
}
/**
 * 初始化项目列表的事件
 */
function initProjectListEvent() {
	$("div#list_more").each(function() {
		var projectTypeId = $(this).attr("projectTypeId");
		var projectTypeName = $("#p_"+projectTypeId).find("div.title").html();
		var projectState = $("#view_state").val();
		$(this).find("a").unbind("click").click(function(){
			showListMore(projectTypeId,projectTypeName,projectState);
		});
	});
}

/**
 * 给项目看版模块添加样式
 */
function initProjectMarkUI() {
	$("li.list_item").addClass("hand");
	$("li.list_item").each(function() {
		if ($(this).find(".project_star_24").attr("isDisplay") != "0") {
			$(this).find(".project_star_24").show();
		} else {
			$(this).find(".project_star_24").hide();
		}
	});
}

/**
 * 填充查询条件
 * @param objParams
 * @param searchCondValue
 */
function fillSearchConditionParam(objParams, searchCondValue) {
	var condition = searchCondValue.condition;
	var conditionValue = searchCondValue.value;
	if (objParams != null) {
		if (condition == "projectName") {
			objParams.projectName = conditionValue;
		} else {
			objParams.projectName = undefined;
		}
		if (condition == "projectNum") {
			objParams.projectNumber = conditionValue;
		} else {
			objParams.projectNumber = undefined;
		}
		if (condition == "projectManager") {
			objParams.projectManager = conditionValue;
		} else {
			objParams.projectManager = undefined;
		}
		if (condition == "projectDate" && conditionValue.length > 0) {
			objParams.beginTime = conditionValue[0];
			objParams.endTime = conditionValue[1];
		} else {
			objParams.beginTime = undefined;
			objParams.endTime = undefined;
		}
		if (condition == "projectRole") {
			objParams.projectRole = conditionValue;
		} else {
			objParams.projectRole = undefined;
		}
	}
}

/**
 * 初始查询组件
 */
function initSearchDiv() {
	searchobj = $.searchCondition({
		id: "searchDiv1",
        top: 10,
        right: 20,
        searchHandler: searchProjectByCondition,
        conditions: [{
            id: 'title',
            name: 'title',
            type: 'input',
            text: $.i18n('project.body.projectName.label'),
            value: 'projectName'
        }, {
            id: 'projectNumber',
            name: 'projectNumber',
            type: 'input',
            text: $.i18n('project.body.projectNum.label'),
            value: 'projectNum'
        }, {
            id: 'manager',
            name: 'manager',
            type: 'input',
            text: $.i18n('project.body.responsible.label'),
            value: 'projectManager'
        }, {
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: $.i18n('project.body.search.projecttime'),
            value: 'projectDate',
			ifFormat:"%Y-%m-%d",
            dateTime: false
        }, {
            id: 'role',
            name: 'role',
            type: 'select',
            text: $.i18n('project.body.role.label'),
            value: 'projectRole',
            items: [{
                text: $.i18n('project.body.responsible.label'),
                value: '0'
            }, {
                text: $.i18n('project.body.assistant.label'),
                value: '5'
            }, {
                text: $.i18n('project.body.member.label'),
                value: '2'
            }, {
                text: $.i18n('project.body.leader.label'),
                value: '1'
            }, {
                text: $.i18n('project.body.related.label'),
                value: '3'
            }]
        }]
    });
}

/**
 * 项目看版页面--对项目内容进行条件查询
 */
function searchProjectByCondition() {
    var returnValue = searchobj.g.getReturnValue();
    var condition = returnValue.condition;
    var conditionValue = returnValue.value;
    var projectState = $("#view_state").val();
    if (objParam != null) {
        fillSearchConditionParam(objParam, returnValue);
        objParam.projectType = "-20000";
        if ($("#project_type_id").val() != -1) {
            objParam.projectTypeId = $("#project_type_id").val();
        } else {
            objParam.projectTypeId = undefined;
        }
        objParam.isSearch = "1";
        var projectCount = projectAjax.getProjectSummaryCount(objParam);
        $("#total").val(projectCount);
        if (viewType == 1) {
            objParam.rowCount = 4 * parseInt(correlationProjects.getRowCanShowNum());
        } else {
            objParam.rowCount = 30;
        }
        objParam.currentPage = 1;
        $("#start_index").val("0");
        if (objParam.rowCount > total) {
            $("#end_index").val(projectCount);
        } else {
            $("#end_index").val(objParam.rowCount);
        }
        var htmlContentStr = null;
        if (viewType == 1) {
            htmlContentStr = new StringBuffer();
            htmlContentStr.append("<div class=\"projects_box\" id=\"projects_box\">");
            htmlContentStr.append(getProjectCardHtml(objParam));
            htmlContentStr.append("</div>");
        } else {
            htmlContentStr = new StringBuffer();
            htmlContentStr.append(getProjectCardHtml(objParam));
        }
        htmlContentStr.append("<div id=\"loading_text\" class=\"padding_10 font_size16 align_center color_gray hidden\">正在加载...</div>");
        $("#projects_card").html("");
        $("#projects_card").html(htmlContentStr.toString());
        initProjectMarkUI();
        bindProjectMarkEvent();
        initProjectListEvent();
    }
}

function initHoverCss(){
	$("span.title").live("mouseenter", function() {
		$(this).css("color","#318ED9");
	}).live("mouseleave", function() {
		$(this).css("color","");
	});
	$("a.more").live("mouseenter", function() {
		$(this).css("color","#318ED9");
	}).live("mouseleave",function(){
		$(this).css("color","");
	});
}
