/**
 * 获取项目人员在导航列表中一页显示的条数
 */
function getProjectMemberShowCount(){
	var obj = $(".projectTask_leftNav");
    var all_Height = obj.find(".list_box").height();
    var li_Height = 34;
    var canShowItemNum = Math.floor(all_Height / li_Height);
	return canShowItemNum;
}

/**
 * 初始化导航列表分页控件事件
 */
function initNavPageBtnEvent() {
	var navObj = $(".projectTask_leftNav");
	var btnUpObj = navObj.find(".page_up");
    var btnDownObj = navObj.find(".page_down");
    btnUpObj.unbind("click").click(function () {
		var currentPage = parseInt($("#current_page").val());
		currentPage--;
		getPaginationNavigationList(currentPage);
    });
    btnDownObj.unbind("click").click(function () {
		var currentPage = parseInt($("#current_page").val());
		currentPage++;
		getPaginationNavigationList(currentPage);
    });
}

/**
 * 获取分页的导航列表
 * @param currentPage 当前页
 */
function getPaginationNavigationList(currentPage) {
	var objParam = new Object();
	$.extend(objParam, getParamsObject());
	var total = $("#total").val();
	var pageSize = $("#page_size").val();
	var pages =  parseInt(total) % parseInt(pageSize) == 0 ? parseInt(total / pageSize) : parseInt(total / pageSize) + 1;
	if (currentPage > 0 && currentPage <= pages) {
		$("#current_page").val(currentPage);
		objParam.total = total;
		objParam.size = pageSize;
		objParam.page = currentPage;
		getTaskNavigationList(objParam);
	}
}

/**
 * 初始化项目成员置顶按钮事件
 */
function initProjectMemberTopEvent() {
	$("#task_nav .top").each(function() {
		$(this).unbind("click").click(function(event) {
			var taskListAjax = new taskListAjaxManager();
			var objParam = new Object();
			objParam.userId = $.ctx.CurrentUser.id;
			objParam.memberId = $(this).parent().attr("navtId");
			objParam.projectId = getProjectId();
			taskListAjax.saveProjectMemberTop(objParam, {
				success : function(ret) {
					if (ret == true || ret == "true") {
						var currentPage = $("#current_page").val();
						getPaginationNavigationList(currentPage);
					}
				},
				error : function(request, settings, e) {
					$.error($.i18n('taskmanage.error.delete.server'));
				}
			});
			event.stopPropagation();
		});
	});
}