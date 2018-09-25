/**
 * 查看已开始的项目
 */
function viewStartPoject() {
	loadProjectCardHtml(1, true);
}

/**
 * 查看已完成的项目
 */
function viewClosePoject() {
	loadProjectCardHtml(0, true);
}

function doReflashGrid(dialog, isNew){
	var listType = 1;
	var isInit = false;
	if(parent.window.$(".projectTask_list_head #project_tab a")){
		if (isNew == true || isNew == "true") {
			isInit = true;
			parent.window.$(".projectTask_list_head .current").removeClass("current");
			parent.window.$(".projectTask_list_head #project_tab a").eq(0).addClass("current");
		} else {
			listType = parent.window.$(".projectTask_list_head #project_tab a.current").attr("listType");
		}
  	}
	dialog.close();
	if (objParam.isSearch == "1") {
		if (objParam.projectType == "-20000") {
			searchProjectByCondition();
		} else {
			projectCardListMore(objParam.projectType);
		}
	} else {
		loadProjectCardHtml(listType, isInit);
	}
}

/**
 * 编辑项目
 * @param projectId 项目ID
 */
function editorProject(projectId) {
	if (correlationProjects != null) {
		correlationProjects.editorProjectFn(projectId);
	}
}
/**
 * 查看已关闭的项目项目
 * @param projectId 项目ID
 */
function viewCloseProject(data) {
	if (correlationProjects != null) {
		correlationProjects.viewCloseProject(data);
	}
}
/**
 * 标星项目
 * @param projectId 项目ID
 */
function markProject(evt, projectId) {
	if (correlationProjects != null) {
		correlationProjects.setStarFn(evt, projectId);
	}
}

/**
 * 取消标星项目
 * @param projectId 项目ID
 */
function removeMarkProject(projectId) {
	if (correlationProjects != null) {
		correlationProjects.removeStarFn(projectId);
	}
}

/**
 * 查看项目信息
 * @param projectId 项目ID
 */
function viewProjectInfo(projectId) {
	var projectPath = _ctxPath + "/project/project.do?method=projectSpace&projectId=" + projectId;
	getCtpTop().$("#main").attr("src", projectPath);
}

function showListMore(projectTypeId,projectTypeName,state){
	window.location.href = _ctxPath + "/project.do?method=projectInfoMore&projectTypeName="+encodeURIComponent(projectTypeName)+"&projectTypeId="+projectTypeId+"&state="+state ;
}

/**
 * 获取列表显示类型
 */
function getListType() {
	var listTypeVal = "";
	var listTypeObj = $("#project_tab .current", window.parent.document);
	if (listTypeObj.length > 0) {
		listTypeVal = listTypeObj.attr("listType");
	}
	return listTypeVal;
}

/**
 * 切换查看内容类型
 * @param type 类型
 */
function changeViweType(type) {
	viewType = type;
	var listType = getListType();
	if (listType == "1") {
		viewStartPoject();
	} else {
		viewClosePoject();
	}
}

/**
 * 查看项目看版更多
 * @param projectType 项目类型
 */
function projectCardListMore(projectType) {
	var projectState = $("#view_state").val();
	objParam = setInitParam();
	if (objParam != null) {
		objParam.projectType = projectType;
		$("#project_type_id").val(projectType);
		objParam.isSearch = "1";
		objParam.projectState = getProjectStateParam(projectState);
		var projectCount = projectAjax.getProjectSummaryCount(objParam);
		$("#total").val(projectCount);
		objParam.rowCount = 4 * objParam.rowCount;
		$("#start_index").val("0");
		if (objParam.rowCount > total) {
			$("#end_index").val(projectCount);
		} else {
			$("#end_index").val(objParam.rowCount);
		}
		var htmlContentStr = null;
		htmlContentStr = new StringBuffer();
		htmlContentStr.append("<div class=\"projects_box\" id=\"projects_box\">");
		htmlContentStr.append(projectAjax.getProjectCardHtmlData(objParam));
		htmlContentStr.append("</div>");	
		htmlContentStr.append("<div id=\"loading_text\" class=\"padding_10 font_size16 align_center color_gray hidden\">正在加载...</div>");
		$("#projects_card").html("");
		$("#projects_card").html(htmlContentStr.toString());
		$("a.more").hide();
		initProjectMarkUI();
		bindProjectMarkEvent();
		initProjectListEvent();
		clearSearchCondition();
	}
}

/**
 * 清空查询条件
 *
 */
function clearSearchCondition() {
	if (searchobj != null && searchobj.g) {
		searchobj.g.clearCondition();
	}
}