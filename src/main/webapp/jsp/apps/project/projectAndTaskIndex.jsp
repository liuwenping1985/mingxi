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
		height:54px;
	}
	.stadic_body_top_bottom{
		overflow: hidden;
		top: 54px;
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
	#list_content_iframe{
		position: absolute;
	}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskListAjaxManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectAndTaskIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/projectAndTaskParams.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(document).ready(function() {
	initProjectAndTaskPageUI();
	initProjectAndTaskPageData();
	initProjectAndTaskPageEvent();
});
</script>
</head>
<body class="h100b over_hidden">
	<div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_projecttask'"></div>
    </div>
    <input type="hidden" id="canAddtask" value="${canAddtask}"/>
    <input type="hidden" id="canAddProject" value="${canAddProject}"/>
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <div class="projectTask_list_head clearfix">
                <div class="group group_current" id="project_tab" typePage="project">
                    <span class="title hand">${ctp:i18n('project.project.label')}</span>
                    <ul class="list">
                        <li><a class="current" listType="1">${ctp:i18n('taskmanage.status.hasStarted')}</a></li>
                        <li><a listType="0">${ctp:i18n('taskmanage.feedback.finishedrate1') }</a></li>
                    </ul>
                </div>
                <div class="group" id="task_tab" typePage="task">
                    <span class="title hand">${ctp:i18n('taskmanage.label')}</span>
                    <ul class="list">
                        <li><a listType="Personal">${ctp:i18n('taskmanage.my')}</a></li>
                        <li id="tell_me" class="display_none"><a listType="TellMe">${ctp:i18n('taskmanage.informMe.label')}</a></li>
                        <li id="sent" class="display_none"><a listType="Sent">${ctp:i18n('taskmanage.assignment')}</a></li>
                        <li id="other_person" class="display_none"><a listType="Manage">${ctp:i18n('taskmanage.otherPeople.label')}</a></li>
                    </ul>
                </div>
				<div class="right padding_r_20">
                    <em class="ico24 project_add_24 left margin_l_15 margin_t_15" title="${ctp:i18n("project.newtemp.label")}" id="add_operea"></em>
                    <em class="ico24 project_card_24 left margin_l_15 margin_t_15" title="${ctp:i18n("common.toolbar.exportExcel.label")}" id="import_task"></em>
					<em class="ico24 project_set_24 left margin_l_15 margin_t_15" title="${ctp:i18n("project.set.label") }" id="set_project"></em>
				</div>
				<input type="hidden" id="page_type" name="page_type" value="project"/>
            </div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix">
            <iframe id="list_content_iframe" name="list_content_iframe" width="100%" height="100%" src="" frameborder="no" border="0"></iframe>
        </div>
    </div>
</body>
</html>