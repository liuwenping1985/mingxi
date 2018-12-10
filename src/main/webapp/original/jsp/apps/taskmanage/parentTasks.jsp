<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n("taskmanage.parentTask.select")}</title>
	<style type="text/css">
		 .common_search_condition .calendar_icon_area{vertical-align:top}
	</style>
</head>
<body>

	<%-- 有选择上级任务的权限	--%>
	<c:if test="${hasMyCreate || hasMyTab || hasInspector || param.from eq 'projectTask'}">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <div class="common_tabs clearfix margin_t_5 margin_l_5" id="tab_area">
                    <ul class="left" id="tab_list">
                    
                      <%-- 普通任务 --%>
                      <c:if test="${param.from ne 'projectTask' }">
                     	  <c:if test="${hasMyTab }">
                          	<li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="myTask">${ctp:i18n("taskmanage.my")}</a></li>
	                      </c:if>
                     	  <c:if test="${hasMyCreate || hasInspector }">
                          	<li class="${hasMyTab ? '':'current' }"><a hideFocus="true" last_tab no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="tellMe">${ctp:i18n("taskmanage.informMe.label")}</a></li>
	                      </c:if>
                     	  <c:if test="${hasMyCreate }">
                          	<li><a hideFocus="true" class="last_tab no_b_border" href="javascript:void(0)" onclick="changeTab(this)" value="assign">${ctp:i18n("taskmanage.assignment")}</a></li>
	                      </c:if>
                       </c:if>
                       
                       <%-- 项目任务 --%>
                       <c:if test="${param.from eq 'projectTask' }">
                          <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0);" value="projectTask">${ctp:i18n("taskmanage.Task.name.js")}</a></li>
                       </c:if>
                       
                    </ul>
            </div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
            <input type="hidden" id="checked_id" name="checked_id" />
        </div>
    </div>
    </c:if>
    
    <%-- 没有选择上级任务的权限 --%>
    <c:if test="${!hasMyCreate && !hasMyTab && !hasInspector && param.from ne 'projectTask'}">
    	<div class="tabs_area_body">
    		<div class="have_a_rest_area" id="notcontent">对不起你没有分解任务的权限</div>
    	</div>
    </c:if>
    
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/parentTasks.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	var taskRoles = ${taskRoles == null ? "''" : taskRoles};
	var hasMyCreate = ${hasMyCreate};
	var hasMyTab = ${hasMyTab};
	var hasInspector = ${hasInspector};
	var projectTask = ${param.from eq 'projectTask' };
	$(document).ready(function() {
		if(hasMyTab || hasMyCreate || hasInspector || projectTask){
			//初始化查询条件
		    initSearch(taskRoles);
			//初始化ajaxGrid
		    initTaskListTable();
		    //执行一次查询
		    doSearch();
		}
	}); 
</script>
</html>
