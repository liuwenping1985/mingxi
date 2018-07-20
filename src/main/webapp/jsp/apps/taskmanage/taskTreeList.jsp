<%--
 $Author:  he.t$
 $Rev:  280$
 $Date:: 2014-12-18 14:38:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('taskmanage.indexOfProjectAndTask.title')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskTreeListAjaxManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/projectAndTaskParams.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/js/ui/seeyon.ui.zsTree-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/stringBufferUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskListEvent.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/projectTaskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/openTaskFeedBack.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/listTaskInfoEvent.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskTreeList.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(document).ready(function() {
	initTreeListPage();
	
	$("body").bind("click",function(e){
		//增加点击事件：OA-79118点击除了列表外的其他地方，任务页面没有自动关闭
		if($(e.target).closest("div.list_item").size()<=0){
			try{
			  projectTaskDetailDialog_close();
			}catch(e){}
		}
	});
});
</script>
<style>
.stadic_head_height{
  height:0px;
}
.stadic_body_top_bottom{
  bottom: 0px;
  top: 0px;
  overflow-y:scroll;
  overflow-x:hidden;
  margin-left:5px;
}
</style>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout">
	<div class="stadic_layout_head stadic_head_height">
	<!--code区域-->
	</div>
	<div class="stadic_layout_body stadic_body_top_bottom relative">
	<!--code区域-->
	<div class='projectTask_listArea' style="overflow:auto;">
    	<div id='zsTreeList' class='list list_tree'></div>
	</div>
	</div>
</div><%--end of stadic_layout--%>
</body>
</html>