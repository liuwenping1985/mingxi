<%-- 普通任务页面--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n('taskmanage.indexOfProjectAndTask.title')}</title>
	<style>
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
	<%
	   if (Locale.ENGLISH.equals(AppContext.getLocale())) {
	%>
	   .advance-search{position: absolute;z-index: 599; font-size:12px; top:10px; right: 8px;}
	<%} else {
	%>
	   .advance-search{position: absolute;z-index: 599; font-size:12px; top:10px; right: 30px;}
	<%    
	}
	%>
	</style>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <div class="clearfix">
                <ul class="projectTask_dimensionTab" id="dimension_tab">
                    <%--状态维度 --%>
                    <li id="status_li"  title="${ctp:i18n('taskmanage.byStatus.title') }" dimension_value="status">
                    	<em id="status_icon" class="ico16 switchView_state_16"></em>
                    </li>
                    <%--任务树 --%>
                    <li id="tree_li"  title="${ctp:i18n('taskmanage.tree')}" dimension_value="tree">
                    	<em id="tree_icon" class="ico16 switchView_taskTree_16"></em>
                    </li>
                </ul>
                <%--自定义排序框 --%>
                <div id="order_data" class="clearfix"></div>
            </div>
        </div>
        <%--任务瀑布流区--%>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix" id="data_body"></div>
        <%--任务树区 --%>
        <div class="stadic_layout_body stadic_body_top_bottom relative hidden" id="tree_data" style="overflow-y: scroll; overflow-x: hidden;margin-left: 5px;"></div>
        <%--导出任务Excel时使用 --%>
        <iframe style="display:none" id="exportExcelIframe"></iframe>
    </div>
<%-- 平台的js --%>
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<%--任务列表模板 --%>
<%@include file="task-list-status-tpl.jsp"%>
<%@include file="task-list-tree-tpl.jsp"%>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/jquery.waterfall-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/com.seeyon.apps.task-list-status-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/projectandtask/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script><%--公司平台的瀑布流组件，后期打算替换掉 --%>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/com.seeyon.apps.task-list-tree-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/com.seeyon.apps.task-list-order-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/com.seeyon.apps.task-list-search-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/taskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	//-----------------全局变量区 -----------------//
	var taskRoles = ${taskRoles == null ? "''" : taskRoles};
	var statusPlugin, treePlugin, orderPlugin, searchPlugin;
	//-----------------页面初始化区  -----------------//
	$(function() {
		statusPlugin = tasklist.state($("#data_body"), '${status}');
		treePlugin = tasklist.tree($("#tree_data"));
		orderPlugin = tasklist.order($("#order_data"), function(){
			refreshPageData();
		});
		searchPlugin = tasklist.search({
			top : 10,
			right : 60,
			taskRoles : taskRoles,
			callback : function(){
				refreshPageData();
			}
		});
		initDimensionTabEvent(); //页签事件初始化
		$("body").off("click").on("click", function(e) {
			if ($(e.target).closest(".list_item").size() <= 0) {
				try {
					projectTaskDetailDialog_close();
				} catch (e) {}/*不做任何处理*/
			}
		});
		$("#${viewType}_li").click();
	});
	//OA-116274 任务：我的任务下，点击我的和告知我的页签，连续点击两次报Js
	window.onbeforeunload=function(){
		try{ projectTaskDetailDialog_close(); }catch(e){}
	}
	
	<%-- 他人任务穿透过来需要将导出+新增按钮显示出来 --%>
    <c:if test="${listType == 'Manage'}">
    try {
        $('.taskButtons', window.parent.document).show();
    } catch (e) {}
    </c:if>
    
	/*获取页面参数*/
	function getPageParams() {
		var params = {
			listType : '${listType }',
			memberId : '${memberId }'
		};
		if ($("#dimension_tab li.current").attr("dimension_value") == 'status') {
			//1.查询过滤参数
			$.extend(params, searchPlugin.getSearchValue());
			//2.自定义排序参数
			params.orders = orderPlugin.getOrders();
		}
		return params;
	}
	/*上级Iframe新增任务的时候会调用此方法进行页面刷新:(line:129@projectAndTaskIndex.jsp)*/
	function refreshPageData() {
		<%-- 他人任务穿透过来需要将导出+新增按钮显示出来 --%>
		<c:if test="${listType == 'Manage'}">
		try {
			$('.taskButtons', window.parent.document).show();
		} catch (e) {}
		</c:if>
		var dimension = $("#dimension_tab li.current").attr("dimension_value");
		if (dimension == 'status') {//状态
			statusPlugin.initialize(getPageParams());
		} else {
			treePlugin.initialize(getPageParams());
		}
	}
</script>
</body>
</html>