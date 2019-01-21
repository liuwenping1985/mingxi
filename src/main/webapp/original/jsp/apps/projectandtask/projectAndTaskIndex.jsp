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
<title>${ctp:i18n('system.menuname.projectAndTask')})</title>
<style>
.stadic_head_height{height:54px;}
.stadic_body_top_bottom{overflow:hidden; top:54px; bottom:0px;}
.stadic_right{float:right; width:100%; height:100%; position:absolute; z-index:100;}
.stadic_right .stadic_content{padding: 0 16px; overflow:auto; margin-left:156px; height:100%;}
.stadic_left{float:left; width:156px; height:100%; position:absolute; z-index:300;}
#list_content_iframe{position: absolute;}
.color_white{color:#FFFFFF}
</style>
</head>
<body class="h100b over_hidden">
	<div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_projecttask'"></div>
    </div>
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <div class="projectTask_list_head clearfix">
            	<c:if test="${ctp:hasPlugin('project')}">
                <div class="group group_current" id="project_tab" typePage="project">
                    <span class="title hand">${ctp:i18n('project.project.label')}</span>
                    <ul class="list">
                        <li><a class="current" listType="1">${ctp:i18n('project.status.hasStarted')}</a></li><%--已开始 --%>
                        <li><a listType="0">${ctp:i18n('project.feedback.finishedrate1') }</a></li><%--已结束 --%>
                    </ul>
                </div>
                </c:if>
                <c:if test="${ctp:hasPlugin('taskmanage')}">
                <div class="group" id="task_tab" typePage="task">
                    <span class="title hand">${ctp:i18n('taskmanage.label')}</span>
                    <ul class="list">
                        <%--(显示任务中，我是我负责的，我参与的角色的所有任务) --%>
                        <li id="Personal"><a listType="Personal">${ctp:i18n('taskmanage.my')}</a></li>
                        <%--告知我的 (显示任务中，我是告知角色的所有任务)--%>
                        <li id="tell_me" class="display_none"><a listType="TellMe">${ctp:i18n('taskmanage.informMe.label')}</a></li>
                        <%--我分派的(显示仅仅是我创建的，但不担任任何角色的任务) --%>
                        <li id="sent" class="display_none"><a listType="Sent">${ctp:i18n('taskmanage.assignment')}</a></li>
                        <%--他人的 --%>
                        <li id="other_person" class="display_none"><a listType="Manage">${ctp:i18n('taskmanage.otherPeople.label')}</a></li>
                        <script type="text/javascript">
                          $(function(){
                            var _manager = new taskAjaxManager();
                            _manager.validateTaskTabs({},{
                              success: function(d){
                                d.TellMe && $("#tell_me").show();
                                d.Sent && $("#sent").show();
                                d.Manage && $("#other_person").show();
                              }
                            });
                          });
                        </script>
                    </ul>
                </div>
                </c:if>
                <div class="right padding_r_20" style="padding-bottom: 1px">
                    <c:if test="${ctp:hasPlugin('project') }">
                    <div class="projectButtons">
                        <c:if test="${canAddProject}">
                        <%--创建项目 --%>
                        <em style="margin-top: 14px" class="ico24 project_add_24 left margin_l_15 margin_t_15" title="${ctp:i18n("project.newproject")}" id="add_project" onclick="createProject();"></em>
                        </c:if>
                        <%--项目设置 --%>
                        <em style="margin-top: 14px" class="ico24 project_set_24 left margin_l_15 margin_t_15" title="${ctp:i18n("project.set.label") }" id="set_project" onclick="projectConfig();"></em>
                    </div>
                    </c:if>    
                    <c:if test="${ctp:hasPlugin('taskmanage') }">
                    <div class="taskButtons display_none">
                        <c:if test="${canAddtask }">
                        <%--创建任务 --%>
                        <em style="margin-top: 14px" class="ico24 project_add_24 left margin_l_15 margin_t_15" title="${ctp:i18n("menu.taskmanage.new")}" id="add_task" onclick="addTask();"></em>
                        </c:if>
                        <%--导出任务Excel --%>
                        <em style="margin-top: 14px" class="ico24 project_card_24 left margin_l_15 margin_t_15" title="${ctp:i18n("common.toolbar.exportExcel.label")}" id="export_task" onclick="exportTask();"></em>
                    </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom clearfix">
            <iframe id="list_content_iframe" name="list_content_iframe" width="100%" height="100%" src="" frameborder="no" border="0"></iframe>
        </div>
    </div>
<%--任务相关代码 --%>
<c:if test="${ctp:hasPlugin('taskmanage') }">
<script type="text/javascript"src="${path}/apps_res/taskmanage/js/taskInfo-api-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
/* 新增任务 */
function addTask(){
  taskInfoAPI.newTask({}, function(json){
	  var _coca = json._coca, currentUserId = $.ctx.CurrentUser.id, listType;
	  if (_coca.managers.indexOf(currentUserId) > -1 || _coca.participators.indexOf(currentUserId) > -1) {
		  listType = 'Personal';
	  } else if (json._coca.inspectors.indexOf(currentUserId) > -1) {
		  listType = "TellMe"; 
	  } else {
		  listType = "Sent";
	  }
	  var $listtype = $(".projectTask_list_head").find("[listtype=" + listType +"]");
	  if ($listtype.hasClass("current") && $listtype.parent().is(":visible")) {//调用子Frame的方法进行刷新
		  $("#list_content_iframe")[0].contentWindow.refreshPageData();
	  } else {
		  $listtype.parent().show().end().trigger('click');
	  }
  });
}
/* 导出任务Excel表格 */
function exportTask() {
  if ($("#list_content_iframe")[0].contentWindow.exportExcel) {
    $("#list_content_iframe")[0].contentWindow.exportExcel();
  }
};
</script>
</c:if>

<script type="text/javascript">
$(document).ready(function() {
  <%-- 1. 绑定项目{已开始,已结束}+任务{我的，}页签事件 --%>
  $(".projectTask_list_head a").off("click").on("click",function(e) {
        $(".projectTask_list_head .current").removeClass("current");
        $(".projectTask_list_head .group_current").removeClass("group_current");
        $(this).addClass("current").parents(".group").addClass("group_current");
        var listTypeVal = $(".projectTask_list_head .current").attr("listType");
        var typePage = $(this).parents(".group_current").attr("typePage");
        changePageView(listTypeVal, typePage);
      }
  );
  $(".projectTask_list_head span.title").off("click").on("click", function(e, init) {
        $(".projectTask_list_head .current").removeClass("current");
        $(".projectTask_list_head .group_current").removeClass("group_current");
        $(this).parents(".group").addClass("group_current");
        $(this).parents(".group").find("a").eq(0).addClass("current");
        var listTypeVal = $(".projectTask_list_head .current").attr("listType");
        var typePage = $(this).parents(".group_current").attr("typePage");
        changePageView(listTypeVal, typePage, init);
      }
  );
  <%-- 2. 根据后台参数触发对一个页签加载对应数据  --%>
  $(".projectTask_list_head span.title").eq(${pageType == 'project' ? 0 : 1}).trigger('click', true);
});
/* 切换页签 */
function changePageView(listType, typePage, init) {//listType:大分类，项目还是任务；typePage:小分类，init:是页面初始化时候触发还是点击触发
  var url;
  if (typePage == 'project') { //项目
    $(".projectButtons").removeClass("display_none").siblings(".taskButtons").addClass("display_none");
    url = _ctxPath + "/project/project.do?method=projectIndex&listType=" + listType; 
  } else {//任务
    $(".taskButtons").removeClass("display_none").siblings(".projectButtons").addClass("display_none");
    if (listType == 'Manage'){ //他人任务
    	$(".taskButtons").addClass("display_none");
    	url = _ctxPath + "/taskmanage/taskinfo.do?method=otherPeopleTaskList";
    } else {//我的(我负责的，我参与的),告知我的，我分派的
    	$(".taskButtons").removeClass("display_none");
    	if (init) {
	    	url = _ctxPath + "/taskmanage/taskinfo.do?method=taskList&pageType=ztask&listType=" + listType + "&status=${status}";
    	} else {
	    	url = _ctxPath + "/taskmanage/taskinfo.do?method=taskList&pageType=ztask&listType=" + listType;
    	}
    }
  }
  $("#list_content_iframe").attr("src","").attr("src", url);
}

/* 项目配置事件 */
function projectConfig(){
    window.location.href = _ctxPath + "/project/project.do?method=getAllProjectList"; 
}
/* 新建项目 */
function createProject() {
    var dialog = $.dialog({
            id : 'newProjectWin',
            url : _ctxPath + '/project/project.do?method=createProject',
            bottomHTML : "<div class='common_checkbox_box margin_l_10 clearfix'><label class='hand color_white' for='continueAdd'><input id='continueAdd' class='radio_com' name='continuous' value='0' type='checkbox'>"
                + $.i18n('taskmanage.add.continue') +"</label></div>",
            width : 556,
            height : 450,
            title : $.i18n('project.newproject') ,
            targetWindow : getCtpTop(),
            transParams:{   newProject:newOpenProject,
                            callBack:refshProejctData,
                            action:'add'}, 
            closeParam:{
                'show':true,
                 handler:function(){
                     refshProejctData(dialog);
                 }
            },
            buttons : [ {
                id : 'ok',
                text : $.i18n('common.button.ok.label'),
                isEmphasize:true,
                handler : function() {
                    dialog.getReturnValue({'dialogObj' :dialog});
                }
            }, {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    refshProejctData(dialog);
                    dialog.close();
                }
            } ]
        });
}
/* 项目类型不存在时回调 */
function newOpenProject(dialog){
    dialog.close();
    createProject();
}
function refshProejctData(dialog){
    if ($("#list_content_iframe")[0].contentWindow.doReflashGrid) {
        $("#list_content_iframe")[0].contentWindow.doReflashGrid(dialog, true);
    }
    if ($("#list_content_iframe")[0].contentWindow.reloadPage) {
        $("#list_content_iframe")[0].contentWindow.reloadPage();
        dialog.close();
    }
}
</script>
</body>
</html>