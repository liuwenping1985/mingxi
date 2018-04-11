<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>关联项目首页</title>
	<style type="text/css">
		.stadic_head_height {height: 44px;margin-left : 5px;}
		.stadic_body_top_bottom {bottom: 0px;top: 44px;margin-left : 5px;}
	</style>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/projectandtask/js/stringBufferUtil.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/correlationProjects.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectIndex.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		var listType = '${param.listType}';//显示类型（已开始、已结束）
		var pageSize = '${param.listType == 1 ? "4" : "6"}';//显示行数
		var viewType = '${viewType }';//查看类型（列表、卡片）
		$(function() {
			init();
		});
	</script>
</head>
<body class="h100b over_hidden" >
	<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height">
			<div class="projects_head clearfix">
				<ul class="projectTask_dimensionTab" id="project_tabs">
                    <li class="${viewType == 1 ? 'current' : ''}"  title="${ctp:i18n("project.display.panel")}" dimension_value="card">
                    	<em id="card_icon" class="ico16 switchView_card${viewType == 1 ? '_current' : ''}_16"></em>
                    </li>
                    <li class="${viewType == 0 ? 'current' : ''}"  title="${ctp:i18n("project.display.list")}" dimension_value="list">
                    	<em id="list_icon" class="ico16 switchView_list${viewType == 0 ? '_current' : ''}_16"></em>
                    </li>
                </ul>
				<span class="right margin_r_10 margin_t_10">
					<div id="searchDiv" class="left margin_r_10"></div>
				</span>
				<input type="hidden" id="start_index" name="start_index" value="0"/>
				<input type="hidden" id="end_index" name="end_index" value="0"/>
				<input type="hidden" id="total" name="total" value="0"/>
				<input type="hidden" id="view_state" name="view_state" value="1"/>
				<input type="hidden" id="project_type_id" name="project_type_id" value="-1"/>
			</div>
		</div>
		<div id="projects_card" class="stadic_layout_body stadic_body_top_bottom">
		</div>
	</div>
</body>
</html>