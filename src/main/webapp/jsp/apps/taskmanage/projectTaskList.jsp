<%--
 $Author:  xiangq$
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
<style>
	.stadic_head_height{
		height:44px;
		margin-left:5px;
	}
	.stadic_body_top_bottom{
		overflow: hidden;
		top: 44px;
		bottom: 0px;
	}
	.stadic_right{
		float:right;
		width:100%;
		height:100%;
		position:absolute;
		z-index:100;
	}
	.stadic_right .stadic_content{
		padding: 0 16px;
		overflow:auto;
		margin-left:156px;
		height:100%;
	}
	.stadic_left{
		float:left; 
		width:156px; 
		height:100%;
		position:absolute;
		z-index:300;
	}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/projectAndTaskParams.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/js/ui/seeyon.ui.zsTree-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/stringBufferUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskListEvent.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/projectTaskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskDetailInterface.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/openTaskFeedBack.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/listTaskInfoEvent.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/taskTreeList.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var from="${from}";
$(document).ready(function() {
	initProjectAndTaskPage();
	
	$("body").bind("click",function(e){
		//增加点击事件：OA-79118点击除了列表外的其他地方，任务页面没有自动关闭
		if($(e.target).closest("li.list_item").size()<=0){
			try{
			  projectTaskDetailDialog_close();
			}catch(e){}
		}
	});
	
	
});
</script>
</head>
<body class="h100b over_hidden" onbeforeunload="projectTaskDetailDialog_close()">
    <div class="stadic_layout">
    	
        <div class="stadic_layout_head stadic_head_height">
            <div class="clearfix">
				<ul class="projectTask_dimensionTab" id="dimension_tab">
                    <li class="current" title="${ctp:i18n('taskmanage.byStatus.title') }" dimension_value="status"><em id="status_icon" class="ico16 switchView_state_current_16"></em></li>
					<li title="${ctp:i18n('taskmanage.byMember.title') }" dimension_value="member"><em id="member_icon" class="ico16 switchView_people_16"></em></li>
                    <li title="${ctp:i18n('taskmanage.tree')}" dimension_value="tree"><em id="tree_icon" class="ico16 switchView_taskTree_16"></em></li>
                </ul>
                <div class="taskTips display_none" style="width: 500px;left:40%;height:35px;">
                        <span class="left left padding_t_10"><em class="ico16 car_state_16 margin_r_5"></em>${ctp:i18n('taskmanage.msg.tips.notEqul') }</span>
                        <span class="right"><em class="ico16 gray_close_16 margin_l_20" id="close_prompt"></em></span>
                        <br>
                    <p class="align_right" style="white-space:nowrap; float: right;position:absolute;bottom:0px;right:0px;"><a href="#" id="no_prompt">${ctp:i18n('taskmanage.tips.nomoredisplay') }</a></p>
                </div>
				<div class="right padding_r_30" id="operea_area">
                    <em class="ico24 project_add_24 left margin_l_15 margin_t_10" id="add_task"></em>
                    <em class="ico24 project_card_24 left margin_l_15 margin_t_10" id="import_task"></em>
				</div>
            </div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix" id="data_body">
            <div class="stadic_right" id="task_list_right">
                <div class="stadic_content relative">
				
                </div>
            </div>
            <div class="stadic_left" id="task_list_left">
                <div class="projectTask_leftNav">
                    <div class="list_box">
                        <ul class="list clearfix" id="task_nav">
                            
                        </ul>
						<input type="hidden" id="total" name="total" value="0"/>
						<input type="hidden" id="page_size" name="page_size" value="0"/>
						<input type="hidden" id="current_page" name="current_page" value="0"/>
                    </div>
                    <div class="pageBtn hidden">
                        <span class="page_up"><em class="ico24 arrow_l_24"></em></span>
                        <span class="page_down"><em class="ico24 arrow_r_24"></em></span>
                    </div>
                </div>
            </div>
        </div>
		<iframe style="display:none" id="exportExcelIframe"></iframe>
    </div>
</body>
</html>