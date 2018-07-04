<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>${ctp:i18n('taskmanage.list.MeetingTask')}-${meetingTitle }</title>
	<style type="text/css">
	    /* 左侧导航栏 */
		.projectTask_leftNav li {overflow: hidden;float: left;margin-top:0px; width: 100%;height: 48px;line-height: 48px;font-size: 14px;color: #757575;cursor: pointer;}
		.projectTask_leftNav li.current{background-color: #FFFFFF;}
		.projectTask_leftNav li.current em{position: absolute;display: inline-block;height: 48px;width: 6px;background: #3da9f7;left: 0;}
		/* 任务瀑布流 */
		.stadic_head_height{height:44px; margin-left: 5px;}
		.stadic_body_top_bottom{overflow: hidden; top: 44px; bottom: 0px;}
		.stadic_right{float:right; width:100%; height:100%; position:absolute; z-index:100;}
		.stadic_right .stadic_content{padding: 0 16px; overflow:auto; margin-left:156px; height:100%;}
		.stadic_left{float:left; width:156px; height:100%; position:absolute; z-index:300; }
		.projectTask_leftNav li.item_all{margin-top: 12px;}
		.projectTask_peopleNav .pageBtn .page_up {display: inline-block; padding: 5px;margin: 12px 0 0 20px;}
		.projectTask_peopleNav .pageBtn {display: block;position: absolute;bottom: 10px;height: 46px; width: 154px;}
	    #tree_data{overflow-y: scroll; overflow-x: hidden;margin-left: 5px;}
	    
	    /**项目不可点击效果 */
	    .projectTask_listArea .list .li_hover .projectType a{color: #8a8a8a;}
	    .projectTask_listArea .list .li_hover .projectType a:hover{color: #8a8a8a;}
	    <%
        if (Locale.ENGLISH.equals(AppContext.getLocale())) {
        %>
        .advance-search{position: absolute;z-index: 599; font-size:12px; top:10px; right: 92px;}
        <%} else {
        %>
        .advance-search{position: absolute;z-index: 599; font-size:12px; top:10px; right: 114px;}
        <%    
        }
        %>
	</style>
</head>
<body class="h100b over_hidden">
    <%--内容区 --%>
    <div class="stadic_layout meeting-task-content">
        <div class="stadic_layout_head stadic_head_height">
            <div class="clearfix">
				<ul class="projectTask_dimensionTab" id="dimension_tab">
                    <li id="status_li" title="${ctp:i18n('taskmanage.byStatus.title') }" dimension_value="status">
                    	<em id="status_icon" class="ico16 switchView_state_16"></em>
                    </li>
                    <li  id="tree_li" class="" title="${ctp:i18n('taskmanage.tree')}" dimension_value="tree">
                    	<em id="tree_icon" class="ico16 switchView_taskTree_16"></em>
                    </li>
                </ul>
                
                <%--自定义排序框 --%>
                <div id="order_data" class="clearfix"></div>
				<div class="right padding_r_30" id="operea_area">
                    <c:if test="${canAddTask }">
                    	<em  class="ico24 project_add_24 left margin_l_15 margin_t_10" title="${ctp:i18n("project.newtemp.label")}${ctp:i18n('taskmanage.name.label')}" onclick="addTask('${meetingId}');"></em>
                    </c:if>
                    <em class="ico24 project_card_24 left margin_l_15 margin_t_10" id="export_task" title="${ctp:i18n("common.toolbar.exportExcel.label")}" onclick="exportTask();"></em>
				</div>
            </div>
        </div>
        
        <div class="stadic_layout_body stadic_body_top_bottom clearfix" id="data_body"></div>
        <div class="stadic_layout_body stadic_body_top_bottom relative hidden" id="tree_data"></div>
    </div>
    
    <%--导出任务Excel时使用 --%>
    <iframe style="display:none" id="exportExcelIframe"></iframe>
    
</body>
    <%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%@include file="task-list-status-tpl.jsp"%>
	<%@include file="task-list-tree-tpl.jsp"%>
	<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/jquery.waterfall-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-status-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/projectandtask/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-tree-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-order-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-search-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/meetingTaskList.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		var taskRoles = ${taskRoles == null ? "\"\"" : taskRoles};
		var status = "${status}";
		var listType = "MeetingTask";
		var meetingId = "${meetingId}";
		var statusPlugin, treePlugin, orderPlugin, searchPlugin;
		var isFirst = true;
		var searcherBox;
		$(function(){
			statusPlugin = tasklist.state($("#data_body"), status);
	        treePlugin = tasklist.tree($("#tree_data"));
			orderPlugin = tasklist.order($("#order_data"), function(){
	            refreshPageData();
	        });
			searchPlugin = tasklist.search({
	            top : 10,
	            right : 144,
	            taskRoles : taskRoles,
	            callback : function(){
	            	refreshPageData();
	            }
	        });
			//页签事件初始化
			initDimensionTabEvent();
			//刷新页面数据
			$("#${viewType}_li").click();
			//关闭任务详情页面
			$(".meeting-task-content,.common_search").off("click").on("click", function(e) {
				//不是列表条目 | dialog中
				if ($(e.target).closest(".list_item").size() <= 0 && $(e.target).parents("div.projectTask_detailDialog").size() <= 0) {
					try {
						projectTaskDetailDialog_close();
					} catch (e) {}/*不做任何处理*/
				}
			});
		});
	</script>
</html>