<%--
        项目任务列表页面
        切记：
      1. 项目任务列表专用，不要加上与此无关的逻辑；
      2. 请不要再使用使用${param.XXX}或者getUrlPara这类鬼，所有的这类的参数请在controller上处理干净了然后放到隐藏字段中！
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
.projectTask_peopleNav .pageBtn .page_up {display: inline-block; padding: 5px;margin: 12px 0 0 20px;}
.projectTask_peopleNav .pageBtn {display: block;position: absolute;bottom: 10px;height: 46px; width: 154px;}
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
    <%--隐藏字段区 --%>
    <input type="hidden" id="projectId" name="projectId" value="${projectBO.id }" />
    <input type="hidden" id="projectPhaseId" name="projectPhaseId" value="${projectPhaseId }"/>
    <input type="hidden" id="beginDate" name="beginDate" value="${beginDate }"/>
    <input type="hidden" id="endDate" name="endDate" value="${endDate }"/>
    <input type="hidden" id="listType" name="listType" value="ProjectTask" />
    <%--内容区 --%>
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <div class="clearfix">
				<ul class="projectTask_dimensionTab" id="dimension_tab">
                    <%--状态维度 --%>
                    <li class="${dimession=='status' ? 'current' : ''}" title="${ctp:i18n('taskmanage.byStatus.title') }" dimension_value="status"><em id="status_icon" class="ico16 ${dimession=='status' ? 'switchView_state_current_16' : 'switchView_state_16'}"></em></li>
					<%--项目人员维度 --%>
                    <%--人员维度瀑布流区:如果没有项目任务查看权限则不显示 --%>
                    <c:if test="${showPeople }">
                    <li class="${dimession=='member' ? 'current' : ''}" title="${ctp:i18n('taskmanage.byMember.title') }" dimension_value="member"><em id="member_icon" class="ico16 ${dimession=='member' ? 'switchView_people_current_16' : 'switchView_people_16'} "></em></li>
                    </c:if>
                    <%--任务树 --%>
                    <li class="${dimession=='tree' ? 'current' : ''}" title="${ctp:i18n('taskmanage.tree')}" dimension_value="tree"><em id="tree_icon" class="ico16 switchView_taskTree_16"></em></li>
                </ul>
                <%--自定义排序框 --%>
                <div id="order_data" class="clearfix"></div>
                <%--任务统计提示框 --%>
                <c:if test="${isAll && !taskAuthVO.canView}">
	                <div class="taskTips display_none" style="width: 500px;left:40%;height:35px;">
	                	<span class="left left padding_t_10"><em class="ico16 car_state_16 margin_r_5"></em>${warningMsg}</span>
	                	<span class="right"><em class="ico16 gray_close_16 margin_l_20" id="close_prompt" onclick="hideTaskTips();"></em></span><br>
						<p class="align_right" style="white-space:nowrap; float: right;position:absolute;bottom:0px;right:0px;"><a href="javascript:noMoreTips();" id="no_prompt">${ctp:i18n('taskmanage.msg.noMoreTips') }</a></p>
					</div>
                </c:if>
				<%--操作按钮区 --%>
				<div class="right padding_r_30" id="operea_area">
                    <%--创建任务 --%>
                    <c:if test="${canAddTask }">
                    <em style="margin-top: 10px" class="ico24 project_add_24 left margin_l_15 margin_t_15" title="${ctp:i18n("project.newtemp.label")}任务" id="add_task" onclick="addTask();"></em>
                    </c:if>
                    <%--导出任务Excel --%>
                    <em style="margin-top: 10px" class="ico24 project_card_24 left margin_l_15 margin_t_15" title="${ctp:i18n("common.toolbar.exportExcel.label")}" id="export_task" onclick="exportTask();"></em>
				</div>
            </div>
        </div>
        <%--状态维度瀑布流区 --%>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix ${dimession=='status' ? '' : 'hidden'}" id="data_body"></div>
        <%--人员维度瀑布流区:如果没有项目任务查看权限则不显示 --%>
        <c:if test="${showPeople }">
        <div class="stadic_layout_body stadic_body_top_bottom clearfix ${dimession=='member' ? '' : 'hidden'}" id="member_body"></div>
        </c:if>
        <%--任务树区 --%>
        <div class="stadic_layout_body stadic_body_top_bottom relative ${dimession=='tree' ? '' : 'hidden'}" id="tree_data" style="overflow-y: scroll; overflow-x: hidden;margin-left: 5px;"></div>
    </div>
    <%--导出任务Excel时使用 --%>
    <iframe style="display:none" id="exportExcelIframe"></iframe>
<%@include file="task-list-status-tpl.jsp"%>
<%@include file="task-list-member-tpl.jsp"%>
<%@include file="task-list-tree-tpl.jsp"%>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/jquery.waterfall-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-status-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-member-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/projectandtask/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script><%--公司平台的瀑布流组件，后期打算替换掉 --%>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-tree-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-order-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/task-list-search-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/tasklist/projectTaskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	//-----------------全局变量区 -----------------//
	//1.自定义角色
	var taskRoles = ${taskRoles == null ? "''" : taskRoles};
	var status = '${status}';
	var statusPlugin, memberPlugin,treePlugin, orderPlugin, searchPlugin;
	$(document).ready(function() {
		statusPlugin = tasklist.state($("#data_body"), status); //默认为全部
		memberPlugin = tasklist.member($("#member_body"), '${memberId}')
		treePlugin = tasklist.tree($("#tree_data"));
		orderPlugin = tasklist.order($("#order_data"), function(){
            refreshPageData(2);
        });
		searchPlugin = tasklist.search({
            top : 10,
            right : 144,
            taskRoles : taskRoles,
            
            /* 从更多带过来的参数 */
            queryType : '${queryType}',
            queryValue : ${queryValue == null ? "''" : queryValue},
            status : status,
            
            callback : function(){
                refreshPageData();
            }
        });
		initTaskTips();//初始化任務統計提示框
		initDimensionTabEvent();//初始化维度页签的事件
		refreshPageData(1);
	});
	//OA-116274 任务：我的任务下，点击我的和告知我的页签，连续点击两次报Js
	window.onbeforeunload=function(){
		try{ projectTaskDetailDialog_close(); }catch(e){}
	}
	
	/*获取页面参数*/
	function getPageParams() {
		//1.基本参数  
		var params = {
			projectId : $("#projectId").val(),
			projectPhaseId : $("#projectPhaseId").val(),
			listType : $("#listType").val()
		};
		
		//2.搜索框参数
		$.extend(params, searchPlugin.getSearchValue());
		
		//3.自定义排序
		params.orders = orderPlugin.getOrders();

		return params;
	}
	/**
	 * 页面刷新
	 * @param type 1:表示刷新整个页面，2表示刷新右侧列表,默认选择为1
	 */
	function refreshPageData(type) {
		type = type || 1;
		var dimension = $("#dimension_tab li.current").attr("dimension_value");
		var params = getPageParams();
		if (dimension == 'status') {//状态维度
			if (type == 1) {
				statusPlugin.initialize(params);
			} else {
				statusPlugin.refreshRight(params);
			}
		} else if (dimension == 'member') {//人员维度
			if (type == 1) {
				memberPlugin.initialize(params);
			} else {
				memberPlugin.refreshRight(params);
			}
		} else {//任务树
			treePlugin.initialize(params);
		}
	}
</script>
</body>
</html>