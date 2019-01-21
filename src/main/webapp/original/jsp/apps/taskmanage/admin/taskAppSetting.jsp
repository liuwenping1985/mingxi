<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
	<%@include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>${ctp:i18n('taskmanage.taskappsetting.title')}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<style type="text/css">
	  /**图标 */
	  .task_checkbox{background: url(${path}/apps_res/taskmanage/images/checkbox.png) no-repeat;}
	  .task_disable_checkbox{background: url(${path}/apps_res/taskmanage/images/disable_checkbox.png) no-repeat;cursor: default;cursor: not-allowed;}
	  .task_checked{background: url(${path}/apps_res/taskmanage/images/checked.png) no-repeat;}
	  .task_disable_checked{background: url(${path}/apps_res/taskmanage/images/disable_checked.png) no-repeat;cursor: default;cursor: not-allowed;}
	  
	  .common_tabs a{max-width: 100px;}
	  /** 高分辨率下变形 */
	  .common_toolbar_box{width: 100%;!import}
	  
	  .auth-setting .role-thead{background:#80AAD4;color: #fff;}
	  .auth-setting .auth-name{width:20%;}
	  .auth-setting .auth-item{width:13%;border-left: 1px solid #fff;}
	  .auth-setting .border-td{border-left: 1px solid #fff; }
	  .auth-setting .content-td,.auth-setting .frist-tr td{border-bottom: 1px solid #E7EAEC;}
	  .auth-setting tr td{text-align: center;height: 34px;font-size: 12px;}
	  .auth-setting .notfrist-tr:hover .content-td,.auth-setting .hover-tr:hover .content-td{background:#D3E0EC;}
	  .frist-td{border-right: 1px solid #E7EAEC;}
	</style>
</head>
<body class="h100b over_hidden">
	<div class="comp" comp="type:'breadcrumb',code:'F02_taskSystemPage'"></div>
	<div id="tabs2" class="comp" comp="type:'tab'">
		<div id="tabs2_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current">
					<a href="javascript:void(0)" tgt="taskAppSetting" onclick="changeTab('taskAppSetting');">
						<span title="${ctp:i18n("taskmanage.modify.ztask.js") }${ctp:i18n("taskmanage.manager") }">${ctp:i18n("taskmanage.modify.ztask.js") }${ctp:i18n("taskmanage.manager") } </span>
					</a>
				</li>
				<li>
					<a href="javascript:void(0)" tgt="taskroleconfig" onclick="changeTab('taskroleconfig');">
						<span title="${ctp:i18n("taskmanage.a_roleconfig.setting") }">${ctp:i18n("taskmanage.a_roleconfig.setting") }</span>
					</a>
				</li>
			</ul>
		</div>
		<div id="tabs2_body" class="common_tabs_body ">
		
			<%-- 任务负责人修改 --%>
			<div id="taskAppSetting">
				<div id="toolbar"></div>
				<div id="taskContent" class="taskContent">
					<table id="taskList"></table>
				</div>
			</div>
			
			<%-- 任务角色权限配置 --%>
			<div id="taskroleconfig" class="hidden">
				<div class="common_toolbar_box clearfix" style="overflow: hidden; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-right-width: 0px; border-color: #b6b6b6; border-style: solid;">
					<%-- toolbar 区域 --%>
					<div class="toolbar_l clearfix" style="overflow: hidden;">
						<div style="height: 30px; white-space: nowrap; width: auto">
							<a id="sava-role-config">
								<em  class="ico16 save_as_16"></em>
								<span  class="menu_span" title="${ctp:i18n("common.toolbar.save.label") }">${ctp:i18n("common.toolbar.save.label") }</span>
							</a>
							<a id="use-default">
								<em  class="ico16 restoreDefaultSort_16"></em>
								<span  class="menu_span" title="${ctp:i18n("taskmanage.a_roleconfig.usedefault") }">${ctp:i18n("taskmanage.a_roleconfig.usedefault") }</span>
							</a>
						</div>
					</div>
				</div>
				<%-- 角色权限设置 区域 --%>
				<div style="clear: both;padding: 0px 5px 0px;overflow-y:auto; " class="auth-setting">
					<table width="100%" cellspacing="0" cellpadding="0">
						<thead>
							<tr class="role-thead">
								<td class="auth-name" colspan="2">${ctp:i18n("taskmanage.a_roleconfig.role") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.View") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.Update") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.Decompose") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.Delete") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.Feedback") }</td>
								<td class="auth-item">${ctp:i18n("taskmanage.taskauth.Hasten") }</td>
							</tr>
						</thead>
						<tbody id="role-config-tbody">
						</tbody>
					</table>
					<div style="height: 10px;"></div>
				</div>
			</div>
			
		</div>
	</div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/html" id="role-tpl">
	<tr class="{{d.taskLevel}}_{{d.pluginName}} {{d.fristtr}}" data-config="{{d.taskLevel}}_{{d.pluginName}}_{{d.roleType}}" >
		{{# if(d.isFrist){ }}	
			<td rowspan="1" class="frist-td">
				{{# if(d.pluginName == "taskmanage" && d.taskLevel == "task" ){ }}
					${ctp:i18n('taskmanage.taskroleconfig.setting')}
				{{# } else if(d.pluginName == "taskmanage" && d.taskLevel == "parentTask" ){ }}
					${ctp:i18n('taskmanage.taskroleconfig.parent.setting')}
				{{# }else{ 							  }}
					${ctp:i18n('project.projecttaskroleconfig.setting')}
				{{# } 								  }}
			</td>
		{{# }				}}
			<td class="content-td">{{d.roleName}}</td>
		 {{# 
			 for(var i = 0; i < d.authVos.length ; i++){ 
				 var authVo = d.authVos[i];
				 var authModifyVo = d.authModifyVos[i];
		 }}
			<td class="content-td" tdindex="{{i}}">
				 {{# if(authModifyVo && authVo){ 		}}
					<span class="ico16 {{checkedClass}}" index="{{i}}"></span>
				 {{# }else if(authModifyVo && !authVo){ }}
					<span class="ico16 {{emptyClass}}"  index="{{i}}"></span>
				 {{# }else if(!authModifyVo && authVo){ 							}}
					<span class="ico16 {{diableCheckedClass}}"  index="{{i}}"></span>
				 {{# }else{ 							}}
					<span class="ico16 {{diableEmptyClass}}" index="{{i}}"></span>
				 {{# } 									}}
			</td>
		{{# 
			 } 
		 }}

	</tr>
</script>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/admin/task-app-setting-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/admin/task-role-config-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	function changeTab(domId) {
		if (domId == "taskAppSetting") {
			showTaskAppSetting()
		} else {
			//隐藏搜索框
			hideSearcher();
			showTaskRoleConfig()
		}
	}
</script>
</html>