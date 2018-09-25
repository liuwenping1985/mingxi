/**
 * 设置初始化任务查询参数
 */
function setInitTaskParams() {
	var objParam = new Object();
	var projectId = getUrlPara("projectId");
	if (projectId != null) {
		var taskListAjax = new taskListAjaxManager();
		objParam.listType = taskListAjax.getProjectListType(projectId, $.ctx.CurrentUser.id);
		objParam.projectId = projectId;
		if (getUrlPara("projectPhaseId") != null) {
			objParam.projectPhaseId = getUrlPara("projectPhaseId");
		}
	} else {
		var listType = getUrlPara("listType");
		if (listType != null) {
			objParam.listType = listType;
		} else {
			objParam.listType = "Personal";
		}
	}
	objParam.statuses = "-1";
	objParam.source = "combinedQuery";
	fillOtherPersonParam(objParam);
	return objParam;
}

/**
 * 填充他人任务的参数
 * @param objParams 初始化参数
 */
function fillOtherPersonParam(objParams) {
	if (objParams != null) {
		var paramObj = new Object();
		if (objParams.listType == "Manage") {
			if (getUrlPara("memberId") != null) {
				paramObj.userId = getUrlPara("memberId");
				paramObj.isOtherUser = 1;
			}
		} else {
			paramObj.userId = $.ctx.CurrentUser.id;
			paramObj.isOtherUser = 0;
		}
		$.extend(objParams, paramObj);
	}
}

function fillStaticsParam(targetObjParam) {
	var paramObj = new Object();
	var statusStr = getUrlPara("status");
	var plannedEndDateStr = getUrlPara("plannedEndDate");
	if (statusStr == "1,2") {
		statusStr = "-2";
	}
	if (getUrlPara("memberId") != null && getUrlPara("projectId") != null) {
		paramObj.statuses = getUrlPara("memberId");
		if (statusStr != null) {
			paramObj.seachCondition = "status:" + statusStr + "";
		} else {
			paramObj.seachCondition = "status:-1";
		}
	} else {
		if (getUrlPara("projectId") != null) {
			if (plannedEndDateStr != null) {
				paramObj.seachCondition = "plannedEndTime:"+ plannedEndDateStr +"," + plannedEndDateStr;
			}
		}
		if (statusStr != null) {
			paramObj.statuses = statusStr;
		}
	}
	$.extend(targetObjParam, paramObj)
} 